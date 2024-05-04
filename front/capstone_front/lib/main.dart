import 'package:capstone_front/firebase_options.dart';
import 'package:capstone_front/models/helper_article_preview_model.dart';
import 'package:capstone_front/models/notice_model.dart';
import 'package:capstone_front/models/qna_post_model.dart';
import 'package:capstone_front/provider/qna_provider.dart';
import 'package:capstone_front/screens/cafeteriaMenu/cafeteriaMenuScreen.dart';
import 'package:capstone_front/screens/chatbot/chatbot.dart';
import 'package:capstone_front/screens/faq/faq_screen.dart';
import 'package:capstone_front/screens/helper/helper_board/helper_board_screen.dart';
import 'package:capstone_front/screens/helper/helper_screen.dart';
import 'package:capstone_front/screens/helper/helper_write_screen.dart';
import 'package:capstone_front/screens/helper/helper_board/helper_writing_screen.dart';
import 'package:capstone_front/screens/home/home_screen.dart';
import 'package:capstone_front/screens/login/login_screen.dart';
import 'package:capstone_front/screens/question/question_screen.dart';
import 'package:capstone_front/screens/signup/signup_college_screen.dart';
import 'package:capstone_front/screens/signup/signup_country_screen.dart';
import 'package:capstone_front/screens/signup/signup_email_screen.dart';
import 'package:capstone_front/screens/signup/signup_email_auth_screen.dart';
import 'package:capstone_front/screens/signup/signup_name.dart';
import 'package:capstone_front/screens/signup/signup_service.dart';
import 'package:capstone_front/screens/main_screen.dart';
import 'package:capstone_front/screens/notice/notice_screen.dart';
import 'package:capstone_front/screens/notice/notice_detail_screen.dart';
import 'package:capstone_front/screens/qna/qna_detail/qna_detail_screen.dart';
import 'package:capstone_front/screens/qna/qna_list_screen/qna_list_screen.dart';
import 'package:capstone_front/screens/qna/qna_write/qna_write_screen.dart';
import 'package:capstone_front/screens/signup/singup_password_screen.dart';
import 'package:capstone_front/screens/speech_practice/speech_practice_screen.dart';
import 'package:capstone_front/screens/speech_practice/speech_screen.dart';
import 'package:capstone_front/screens/speech_practice/speech_example_sentences/speech_select_sentence_screen.dart';
import 'package:capstone_front/screens/speech_practice/utils/recorder_screen.dart';
import 'package:capstone_front/utils/page_animation.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

// 앱에서 지원하는 언어 리스트 변수
final supportedLocales = [const Locale('en', 'US'), const Locale('ko', 'KR')];

// 기본적으로 한국어로 세팅
List<String> languageSetting = ['ko', 'KR'];

// 로그인 되어있었는지 여부
bool _isLogin = false;

// 언어를 설정해주고 로그인 정보를 불러오는 함수
Future<void> setSetting() async {
  const storage = FlutterSecureStorage();
  String? language = await storage.read(key: 'language');
  if (language == 'english') {
    languageSetting = ['en', 'US'];
  } else {
    languageSetting = ['ko', 'KR'];
  }
  String? str = await storage.read(key: 'isLogin');
  if (str == 'true') {
    _isLogin = true;
  }
}

void initializeFirebase() async {
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  initializeFirebase();
  await setSetting();
  await EasyLocalization.ensureInitialized();
  await dotenv.load(fileName: ".env");

  runApp(
    EasyLocalization(
      supportedLocales: supportedLocales,
      path: 'assets/translations',
      fallbackLocale: const Locale('en', 'US'),
      startLocale: Locale(languageSetting[0], languageSetting[1]),
      child: ChangeNotifierProvider<QnaProvider>(
        create: (_) => QnaProvider(),
        child: const App(),
      ),
    ),
  );
}

final GoRouter router = GoRouter(
  initialLocation: _isLogin ? '/' : '/login',
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => const MainScreen(),
      routes: [
        GoRoute(
          name: 'speech',
          path: 'speech',
          builder: (context, state) => const SpeechScreen(),
          routes: [
            GoRoute(
                path: 'practice',
                pageBuilder: (context, state) {
                  return buildPageWithSlideRight(
                    context: context,
                    state: state,
                    child: const SpeechPracticeScreen(),
                  );
                }),
          ],
        ),
        GoRoute(
          name: 'helper',
          path: 'helper',
          builder: (context, state) => const HelperScreen(),
          routes: [
            GoRoute(
              name: 'helperWriting',
              path: 'writing',
              builder: (context, state) {
                final notice = state.extra as HelperArticlePreviewModel?;
                if (notice == null) {
                  return const HelperScreen();
                }
                return HelperWritingScreen(notice);
              },
            ),
            GoRoute(
              name: 'helperWrite',
              path: 'write',
              builder: (context, state) => const HelperWriteScreen(),
            ),
          ],
        ),
      ],
    ),
    GoRoute(
      path: '/cafeteriamenu',
      builder: (context, state) => const CafeteriaMenuScreen(),
    ),
    GoRoute(
      name: 'login',
      path: '/login',
      builder: (context, state) => const LoginScreen(),
    ),
    GoRoute(
        name: 'signup',
        path: '/signup',
        builder: (context, state) => const SignupNameScreen(),
        routes: [
          GoRoute(
            name: 'email',
            path: 'email',
            builder: (context, state) => const SignupEmailScreen(),
          ),
          GoRoute(
            name: 'password',
            path: 'password',
            builder: (context, state) => const SignupPasswordScreen(),
          ),
          GoRoute(
            name: 'college',
            path: 'college',
            builder: (context, state) => const SignupCollegeScreen(),
          ),
          GoRoute(
            name: 'country',
            path: 'country',
            builder: (context, state) => const SignupCountryScreen(),
          ),
        ]),
    GoRoute(
      name: 'chatbot',
      path: '/chatbot',
      builder: (context, state) => const ChatbotScreen(),
    ),
    GoRoute(
      name: 'notice',
      path: '/notice',
      builder: (context, state) => const NoticeScreen(),
    ),
    GoRoute(
      name: 'noticedetail',
      path: '/notice/detail/:id',
      builder: (context, state) {
        // 'state.extra'를 통해 전달된 'NoticeModel' 객체를 받아옴
        final notice = state.extra as NoticeModel?;
        if (notice == null) {
          return const NoticeScreen();
        }
        return NoticeDetailScreen(notice);
      },
    ),
    GoRoute(
      name: 'qnalist',
      path: '/qnalist',
      builder: (context, state) => const QnaListScreen(),
    ),
    GoRoute(
        name: 'qnalistdetail',
        path: '/qnalist/detail',
        builder: (context, state) {
          final qna = state.extra as QnaPostModel?;
          if (qna == null) {
            return const QnaListScreen();
          }
          return QnaDetailScreen(
            data: qna,
          );
        }),
    GoRoute(
        name: 'qnawrite',
        path: '/qnawrite',
        builder: (context, state) {
          final qnas = state.extra as List<QnaPostModel>?;
          if (qnas == null) {
            return const QnaListScreen();
          }
          return QnaWriteScreen(qnas: qnas);
        }),
    GoRoute(
      name: 'faq',
      path: '/faq',
      builder: (context, state) => const FaqScreen(),
    ),
    GoRoute(
      name: 'question',
      path: '/question',
      builder: (context, state) => const QuestionScreen(),
    ),
  ],
);

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      localizationsDelegates: context.localizationDelegates,
      supportedLocales: context.supportedLocales,
      locale: context.locale,
      routerConfig: router,
      theme: ThemeData(
        fontFamily: 'pretendard',
        colorScheme: const ColorScheme(
          brightness: Brightness.light,
          primary: Color(0xff6E2FF4),
          onPrimary: Colors.red,
          secondary: Color(0xFFE8E8FC),
          onSecondary: Colors.yellow,
          error: Colors.green,
          onError: Colors.blue,
          background: Colors.white,
          onBackground: Colors.lightBlue,
          surface: Colors.white,
          onSurface: Colors.black,
        ),
        textTheme: const TextTheme(
            headlineLarge: TextStyle(
              fontFamily: 'pretendard',
              fontSize: 50,
              fontWeight: FontWeight.w600,
            ),
            // 앱바 기본 폰트
            titleLarge: TextStyle(
              fontFamily: 'pretendard',
              fontSize: 20,
              fontWeight: FontWeight.w600,
            ),
            titleMedium: TextStyle(
              fontFamily: 'pretendard',
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
            bodyLarge: TextStyle(
              fontFamily: 'pretendard',
              fontSize: 20,
              fontWeight: FontWeight.w600,
            ),
            // 앱 내의 Text 기본 폰트
            bodyMedium: TextStyle(
              fontFamily: 'pretendard',
              fontSize: 16,
              fontWeight: FontWeight.w400,
            ),
            bodySmall: TextStyle(
              fontFamily: 'pretendard',
              fontSize: 13,
              fontWeight: FontWeight.w400,
            )),
      ),
    );
  }
}
