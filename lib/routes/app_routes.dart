import 'package:flutter/material.dart';
import '../presentation/main_dashboard/main_dashboard.dart';
import '../presentation/splash_screen/splash_screen.dart';
import '../presentation/image_analysis_screen/image_analysis_screen.dart';
import '../presentation/query_history_screen/query_history_screen.dart';
import '../presentation/text_input_screen/text_input_screen.dart';
import '../presentation/voice_input_screen/voice_input_screen.dart';

class AppRoutes {
  // TODO: Add your routes here
  static const String initial = '/';
  static const String mainDashboard = '/main-dashboard';
  static const String splash = '/splash-screen';
  static const String imageAnalysis = '/image-analysis-screen';
  static const String queryHistory = '/query-history-screen';
  static const String textInput = '/text-input-screen';
  static const String voiceInput = '/voice-input-screen';

  static Map<String, WidgetBuilder> routes = {
    initial: (context) => const SplashScreen(),
    mainDashboard: (context) => const MainDashboard(),
    splash: (context) => const SplashScreen(),
    imageAnalysis: (context) => const ImageAnalysisScreen(),
    queryHistory: (context) => const QueryHistoryScreen(),
    textInput: (context) => const TextInputScreen(),
    voiceInput: (context) => const VoiceInputScreen(),
    // TODO: Add your other routes here
  };
}
