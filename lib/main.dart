import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'screens/home_screen.dart';
import 'theme/app_theme.dart';
import 'package:google_fonts/google_fonts.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
    ),
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ADTSMED',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.themeData,
      home: const SplashScreen(),
    );
  }
}

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    // Navigate to HomeScreen after 3 seconds
    Future.delayed(const Duration(seconds: 3), () {
      Navigator.pushReplacement(
        context,
        PageRouteBuilder(
          pageBuilder: (_, __, ___) => const MainScreen(),
          transitionDuration: const Duration(milliseconds: 800),
          transitionsBuilder: (_, animation, __, child) {
            return FadeTransition(
              opacity: animation,
              child: child,
            );
          },
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              AppTheme.gradientStart,
              AppTheme.gradientEnd,
            ],
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Logo
              Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 20,
                      offset: const Offset(0, 10),
                    ),
                  ],
                ),
                child: const Center(
                  child: Icon(
                    Icons.medical_services_rounded,
                    size: 60,
                    color: AppTheme.primaryColor,
                  ),
                ),
              ).animate().fadeIn(duration: 600.ms).slideY(
                    begin: 0.3,
                    end: 0,
                    curve: Curves.easeOutQuad,
                    duration: 800.ms,
                  ),
              
              const SizedBox(height: 24),
              
              // App name with animated text
              AnimatedTextKit(
                animatedTexts: [
                  TypewriterAnimatedText(
                    'ADTSMED',
                    textStyle: GoogleFonts.poppins(
                      fontSize: 36,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      letterSpacing: 2,
                    ),
                    speed: const Duration(milliseconds: 150),
                  ),
                ],
                totalRepeatCount: 1,
              ),
              
              const SizedBox(height: 8),
              
              // Tagline
              Text(
                'ADTS Testing Services',
                style: GoogleFonts.poppins(
                  fontSize: 16,
                  fontWeight: FontWeight.w400,
                  color: Colors.white.withOpacity(0.9),
                ),
              ).animate().fadeIn(delay: 800.ms, duration: 800.ms),
              
              const SizedBox(height: 60),
              
              // Loading indicator
              SizedBox(
                width: 36,
                height: 36,
                child: CircularProgressIndicator(
                  strokeWidth: 3,
                  valueColor: AlwaysStoppedAnimation<Color>(
                    Colors.white.withOpacity(0.9),
                  ),
                ),
              ).animate().fadeIn(delay: 400.ms, duration:
                                600.ms),
            ],
          ),
        ),
      ),
    );
  }
}
