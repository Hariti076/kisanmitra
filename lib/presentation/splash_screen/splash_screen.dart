import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../core/app_export.dart';
import '../../theme/app_theme.dart';
import './widgets/animated_logo_widget.dart';
import './widgets/gradient_background_widget.dart';
import './widgets/initialization_status_widget.dart';
import './widgets/loading_indicator_widget.dart';
import 'widgets/animated_logo_widget.dart';
import 'widgets/gradient_background_widget.dart';
import 'widgets/initialization_status_widget.dart';
import 'widgets/loading_indicator_widget.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  late AnimationController _fadeController;
  late Animation<double> _fadeAnimation;

  bool _showInitializationStatus = false;
  bool _isInitializationComplete = false;

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
    _startSplashSequence();
  }

  void _initializeAnimations() {
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeInOut,
    ));

    _fadeController.forward();
  }

  Future<void> _startSplashSequence() async {
    // Show logo and initial loading for 2 seconds
    await Future.delayed(const Duration(milliseconds: 2000));

    if (mounted) {
      setState(() {
        _showInitializationStatus = true;
      });
    }
  }

  void _onInitializationComplete() {
    setState(() {
      _isInitializationComplete = true;
    });

    // Navigate to main dashboard after a brief delay
    Future.delayed(const Duration(milliseconds: 1000), () {
      if (mounted) {
        _navigateToMainDashboard();
      }
    });
  }

  void _navigateToMainDashboard() {
    Navigator.pushReplacementNamed(context, '/main-dashboard');
  }

  @override
  void dispose() {
    _fadeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarIconBrightness: Brightness.dark,
          systemNavigationBarColor: AppTheme.lightTheme.colorScheme.surface,
          systemNavigationBarIconBrightness: Brightness.dark,
        ),
        child: SafeArea(
          child: GradientBackgroundWidget(
            child: FadeTransition(
              opacity: _fadeAnimation,
              child: Container(
                width: double.infinity,
                height: double.infinity,
                child: Column(
                  children: [
                    // Top spacer
                    SizedBox(height: 15.h),

                    // Animated logo section
                    const AnimatedLogoWidget(),

                    // App title
                    SizedBox(height: 3.h),
                    Text(
                      'KisanMitra',
                      style: GoogleFonts.roboto(
                        fontSize: 18.sp,
                        fontWeight: FontWeight.w600,
                        color: AppTheme.lightTheme.colorScheme.onSurface,
                        letterSpacing: 1.2,
                      ),
                    ),

                    SizedBox(height: 1.h),
                    Text(
                      'AI-Powered Agricultural Assistant',
                      style: GoogleFonts.notoSans(
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w400,
                        color: AppTheme.lightTheme.colorScheme.onSurface
                            .withValues(alpha: 0.7),
                      ),
                    ),

                    // Flexible spacer
                    const Spacer(),

                    // Loading indicator or initialization status
                    _showInitializationStatus
                        ? InitializationStatusWidget(
                            onInitializationComplete: _onInitializationComplete,
                          )
                        : const LoadingIndicatorWidget(),

                    // Bottom spacer
                    SizedBox(height: 8.h),

                    // Version info
                    Text(
                      'Version 1.0.0',
                      style: GoogleFonts.roboto(
                        fontSize: 10.sp,
                        fontWeight: FontWeight.w400,
                        color: AppTheme.lightTheme.colorScheme.onSurface
                            .withValues(alpha: 0.5),
                      ),
                    ),

                    SizedBox(height: 2.h),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}