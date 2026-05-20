import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

import 'utils/app_colors.dart';
import 'screens/splash_screen.dart';
import 'screens/app_shell.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]);
  runApp(const FinAgentApp());
}
class FinAgentApp extends StatelessWidget {
  const FinAgentApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<ThemeMode>(
      valueListenable: themeModeNotifier,
      builder: (context, currentMode, _) {
        return MaterialApp(
          title: 'FinAgent',
          debugShowCheckedModeBanner: false,
          themeMode: currentMode,
          darkTheme: ThemeData(
            brightness: Brightness.dark,
            scaffoldBackgroundColor: AppColors.darkBg,
            cardColor: AppColors.darkCard,
            colorScheme: const ColorScheme.dark(
              primary: AppColors.electricCyan,
              secondary: AppColors.neonGreen,
              surface: AppColors.darkSurface,
              background: AppColors.darkBg,
            ),
            textTheme: GoogleFonts.interTextTheme(ThemeData.dark().textTheme),
          ),
          theme: ThemeData(
            brightness: Brightness.light,
            scaffoldBackgroundColor: AppColors.lightBg,
            cardColor: AppColors.lightCard,
            colorScheme: const ColorScheme.light(
              primary: AppColors.electricCyan,
              secondary: AppColors.neonGreen,
              surface: AppColors.lightSurface,
              background: AppColors.lightBg,
            ),
            textTheme: GoogleFonts.interTextTheme(ThemeData.light().textTheme),
          ),
          home: const SplashScreen(),
        );
      },
    );
  }
}

