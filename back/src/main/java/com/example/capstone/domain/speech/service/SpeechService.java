package com.example.capstone.domain.speech.service;

import com.microsoft.cognitiveservices.speech.*;
import com.microsoft.cognitiveservices.speech.audio.AudioConfig;
import com.github.difflib.DiffUtils;
import com.github.difflib.patch.AbstractDelta;
import com.github.difflib.patch.DeltaType;
import com.github.difflib.patch.Patch;
import jakarta.json.Json;
import jakarta.json.JsonArray;
import jakarta.json.JsonObject;
import jakarta.json.JsonReader;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

import java.io.StringReader;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;
import java.util.concurrent.*;

@Service
public class SpeechService {
    private String speechKey = "";
    private String speechRegion = "koreacentral";
    private String speechLang = "ko-KR";

    private Semaphore stopRecognitionSemaphore;
    public void pronunciation(String compareText) throws InterruptedException, ExecutionException {
        SpeechConfig speechConfig = SpeechConfig.fromSubscription(speechKey, speechRegion);
        AudioConfig audioConfig = AudioConfig.fromWavFileInput("sample.wav");

        stopRecognitionSemaphore = new Semaphore(0);
        List<String> recognizedWords = new ArrayList<>();
        List<Word> pronWords = new ArrayList<>();
        List<Word> finalWords = new ArrayList<>();
        List<Double> fluencyScores = new ArrayList<>();
        List<Long> durations = new ArrayList<>();

        SpeechRecognizer recognizer = new SpeechRecognizer(speechConfig, speechLang, audioConfig);
        {
            recognizer.recognized.addEventListener((s, e) -> {
                if (e.getResult().getReason() == ResultReason.RecognizedSpeech) {
                    System.out.println("RECOGNIZED: Text=" + e.getResult().getText());
                    PronunciationAssessmentResult pronResult = PronunciationAssessmentResult.fromResult(e.getResult());
                    System.out.println(
                            String.format(
                                    "    Accuracy score: %f, Prosody score: %f, Pronunciation score: %f, Completeness score : %f, FluencyScore: %f",
                                    pronResult.getAccuracyScore(), pronResult.getProsodyScore(), pronResult.getPronunciationScore(),
                                    pronResult.getCompletenessScore(), pronResult.getFluencyScore()));
                    fluencyScores.add(pronResult.getFluencyScore());
                    String jString = e.getResult().getProperties().getProperty(PropertyId.SpeechServiceResponse_JsonResult);
                    try {
                        JsonReader jsonReader = Json.createReader(new StringReader(jString));
                        JsonObject jsonObject = jsonReader.readObject();
                        JsonArray nBestArray = jsonObject.getJsonArray("NBest");

                        for (int i = 0; i < nBestArray.size(); i++) {
                            JsonObject nBestItem = nBestArray.getJsonObject(i);

                            JsonArray wordsArray = nBestItem.getJsonArray("Words");
                            long durationSum = 0;

                            for (int j = 0; j < wordsArray.size(); j++) {
                                JsonObject wordItem = wordsArray.getJsonObject(j);
                                recognizedWords.add(wordItem.getString("Word"));
                                durationSum += wordItem.getJsonNumber("Duration").longValue();

                                JsonObject pronAssessment = wordItem.getJsonObject("PronunciationAssessment");
                                pronWords.add(new Word(wordItem.getString("Word"), pronAssessment.getString("ErrorType"), pronAssessment.getJsonNumber("AccuracyScore").doubleValue()));
                            }
                            durations.add(durationSum);
                            jsonReader.close();
                        }
                    }
                    catch (Exception error){
                        System.out.println(error.getMessage());
                    }
                }
                else if (e.getResult().getReason() == ResultReason.NoMatch) {
                    System.out.println("NOMATCH: Speech could not be recognized.");
                }
            });

            recognizer.canceled.addEventListener((s, e) -> {
                System.out.println("CANCELED: Reason=" + e.getReason());

                if (e.getReason() == CancellationReason.Error) {
                    System.out.println("CANCELED: ErrorCode=" + e.getErrorCode());
                    System.out.println("CANCELED: ErrorDetails=" + e.getErrorDetails());
                    System.out.println("CANCELED: Did you update the subscription info?");
                }

                stopRecognitionSemaphore.release();
            });

            recognizer.sessionStarted.addEventListener((s, e) -> {
                System.out.println("\n    Session started event.");
            });

            recognizer.sessionStopped.addEventListener((s, e) -> {
                System.out.println("\n    Session stopped event.");
            });

            boolean enableMiscue = true;
            // 발음평가를 위해 참고할 원문
            String referenceText = compareText;

            PronunciationAssessmentConfig pronunciationAssessmentConfig = PronunciationAssessmentConfig.fromJson("{\"referenceText\":\"북한 중앙방송은 이날 시사논단에서 미국 국무부가 지난 달 말 발표한 인권보고서와 관련해 다른 나라의 인권에 대해 이러쿵 저러쿵 시비질을 하면서 마치 세계 인권재판관이라도 되는 듯이 행세하고 있다고 비난했다.\",\"gradingSystem\":\"HundredMark\",\"granularity\":\"Phoneme\",\"phonemeAlphabet\":\"IPA\"}");
            pronunciationAssessmentConfig.applyTo(recognizer);

            recognizer.startContinuousRecognitionAsync().get();

            stopRecognitionSemaphore.acquire();

            recognizer.stopContinuousRecognitionAsync().get();

            String[] referenceWords = referenceText.toLowerCase().split(" ");
            for (int j = 0; j < referenceWords.length; j++) {
                referenceWords[j] = referenceWords[j].replaceAll("^\\p{Punct}+|\\p{Punct}+$","");
            }

            if (enableMiscue) {
                Patch<String> diff = DiffUtils.diff(Arrays.asList(referenceWords), recognizedWords, true);

                int currentIdx = 0;
                for (AbstractDelta<String> d : diff.getDeltas()) {
                    if (d.getType() == DeltaType.EQUAL) {
                        for (int i = currentIdx; i < currentIdx + d.getSource().size(); i++) {
                            finalWords.add(pronWords.get(i));
                        }
                        currentIdx += d.getTarget().size();
                    }
                    if (d.getType() == DeltaType.DELETE || d.getType() == DeltaType.CHANGE) {
                        for (String w : d.getSource().getLines()) {
                            finalWords.add(new Word(w, "Omission"));
                        }
                    }
                    if (d.getType() == DeltaType.INSERT || d.getType() == DeltaType.CHANGE) {
                        for (int i = currentIdx; i < currentIdx + d.getTarget().size(); i++) {
                            Word w = pronWords.get(i);
                            w.errorType = "Insertion";
                            finalWords.add(w);
                        }
                        currentIdx += d.getTarget().size();
                    }
                }
            }
            else {
                finalWords = pronWords;
            }

            double totalAccuracyScore = 0;
            int accuracyCount = 0;
            int validCount = 0;
            for (Word word : finalWords) {
                if (!"Insertion".equals(word.errorType)) {
                    totalAccuracyScore += word.accuracyScore;
                    accuracyCount += 1;
                }

                if ("None".equals(word.errorType)) {
                    validCount += 1;
                }
            }
            double accuracyScore = totalAccuracyScore / accuracyCount;

            double fluencyScoreSum = 0;
            long durationSum = 0;
            for (int i = 0; i < durations.size(); i++) {
                fluencyScoreSum += fluencyScores.get(i)*durations.get(i);
                durationSum += durations.get(i);
            }
            double fluencyScore = fluencyScoreSum / durationSum;

            double completenessScore = (double)validCount / referenceWords.length * 100;
            completenessScore = completenessScore <= 100 ? completenessScore : 100;

            System.out.println("Paragraph accuracy score: " + accuracyScore +
                    ", completeness score: " +completenessScore +
                    " , fluency score: " + fluencyScore);
            for (Word w : finalWords) {
                System.out.println(" word: " + w.word + "\taccuracy score: " +
                        w.accuracyScore + "\terror type: " + w.errorType);
            }
        }
        speechConfig.close();
        audioConfig.close();
        recognizer.close();
    }

    public static class Word {
        public String word;
        public String errorType;
        public double accuracyScore;
        public Word(String word, String errorType) {
            this.word = word;
            this.errorType = errorType;
            this.accuracyScore = 0;
        }

        public Word(String word, String errorType, double accuracyScore) {
            this(word, errorType);
            this.accuracyScore = accuracyScore;
        }
    }

}
