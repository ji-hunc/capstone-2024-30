package com.example.capstone.domain.qna.controller;

import com.example.capstone.domain.jwt.JwtTokenProvider;
import com.example.capstone.domain.qna.dto.*;
import com.example.capstone.domain.qna.service.AnswerService;
import com.example.capstone.global.dto.ApiResult;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.Parameter;
import io.swagger.v3.oas.annotations.responses.ApiResponse;
import lombok.RequiredArgsConstructor;
import org.springframework.http.RequestEntity;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.*;

import java.util.Map;
import java.util.UUID;

@Controller
@RequiredArgsConstructor
@RequestMapping("/api/answer")
public class AnswerController {
    private final AnswerService answerService;
    private final JwtTokenProvider jwtTokenProvider;

    @PostMapping("/create")
    @Operation(summary = "댓글 생성", description = "request 정보를 기반으로 댓글을 생성합니다.")
    @ApiResponse(responseCode = "200", description = "생성된 댓글을 반환합니다.")
    public ResponseEntity<ApiResult<AnswerResponse>> createAnswer(/*@RequestHeader String token,*/
                                            @Parameter(description = "댓글의 구성요소 입니다. 질문글의 id, 작성자, 댓글내용이 필요합니다.", required = true)
                                            @RequestBody AnswerPostRequest request) {
        String userId = UUID.randomUUID().toString(); //jwtTokenProvider.extractUUID(token);
        AnswerResponse answer = answerService.createAnswer(userId, request);
        return ResponseEntity
                .ok(new ApiResult<>("Successfully create answer",answer));
    }

    @GetMapping("/list")
    @Operation(summary = "댓글 리스트 생성", description = "request 정보를 기반으로 댓글의 리스트를 생성합니다.")
    @ApiResponse(responseCode = "200", description = "request 정보를 기반으로 생성된 댓글의 리스트가 반환됩니다.")
    public ResponseEntity<ApiResult<AnswerSliceResponse>> listAnswer(@Parameter(description = "댓글 리스트 생성을 위한 파라미터 값입니다. 질문글의 id, cursorId, 댓글 정렬 기준( date / like )이 필요합니다.", required = true)
                                        @RequestBody AnswerListRequest request) {
        AnswerSliceResponse response = answerService.getAnswerList(request.questionId(), request.cursorId(), request.sortBy());
        return ResponseEntity
                .ok(new ApiResult<>("Successfully create answer list", response));
    }

    @PutMapping("/update")
    @Operation(summary = "댓글 수정", description = "request 정보를 기반으로 댓글을 수정합니다.")
    @ApiResponse(responseCode = "200", description = "완료시 200을 반환됩니다.")
    public ResponseEntity<ApiResult<Integer>> updateAnswer(/*@RequestHeader String token,*/
                                            @Parameter(description = "댓글 수정을 위한 파라미터입니다. 댓글 id, 질문글 id, 작성자, 댓글 내용이 필요합니다.", required = true)
                                            @RequestBody AnswerPutRequest request) {
        String userId = UUID.randomUUID().toString(); //jwtTokenProvider.extractUUID(token);
        answerService.updateAnswer(userId, request);
        return ResponseEntity
                .ok(new ApiResult<>("Successfully update answer", 200));
    }

    @DeleteMapping("/erase")
    @Operation(summary = "질문글 삭제", description = "댓글 id를 통해 해당글을 삭제합니다.")
    @ApiResponse(responseCode = "200", description = "완료시 200이 반환됩니다.")
    public ResponseEntity<ApiResult<Integer>> eraseAnswer(   @Parameter(description = "삭제할 댓글의 id가 필요합니다.", required = true)
                                            @RequestParam Long id) {
        answerService.eraseAnswer(id);
        return ResponseEntity
                .ok(new ApiResult<>("Successfully delete answer", 200));
    }

    @PutMapping("/like")
    @Operation(summary = "댓글 추천", description = "해당 id의 댓글을 추천합니다. 현재 추천 댓글 여부를 관리하지 않습니다.")
    @ApiResponse(responseCode = "200", description = "완료시 200을 반환합니다.")
    public ResponseEntity<ApiResult<Integer>> upLikeCount(   @Parameter(description = "추천할 댓글의 id가 필요합니다.", required = true)
                                            @RequestParam Long id) {
        answerService.upLikeCountById(id);
        return ResponseEntity
                .ok(new ApiResult<>("Successfully like answer", 200));
    }

    @PutMapping("/unlike")
    @Operation(summary = "댓글 추천 해제", description = "해당 id의 댓글을 추천 해제합니다. 현재 추천 댓글 여부를 관리하지 않습니다.")
    @ApiResponse(responseCode = "200", description = "완료시 200을 반환합니다.")
    public ResponseEntity<ApiResult<Integer>> downLikeCount( @Parameter(description = "추천 해제할 댓글의 id가 필요합니다.", required = true)
                                            @RequestParam Long id) {
        answerService.downLikeCountById(id);
        return ResponseEntity
                .ok(new ApiResult<>("Successfully unlike answer", 200));
    }
}