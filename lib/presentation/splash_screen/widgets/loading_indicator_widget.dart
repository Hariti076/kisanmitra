import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/app_export.dart';
import '../../../theme/app_theme.dart';

class LoadingIndicatorWidget extends StatefulWidget {
  const LoadingIndicatorWidget({Key? key}) : super(key: key);

  @override
  State<LoadingIndicatorWidget> createState() => _LoadingIndicatorWidgetState();
}

class _LoadingIndicatorWidgetState extends State<LoadingIndicatorWidget>
    with TickerProviderStateMixin {
  late AnimationController _progressController;
  late AnimationController _pulseController;
  late Animation<double> _progressAnimation;
  late Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();

    _progressController = AnimationController(
      duration: const Duration(milliseconds: 2500),
      vsync: this,
    );

    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );

    _progressAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _progressController,
      curve: Curves.easeInOut,
    ));

    _pulseAnimation = Tween<double>(
      begin: 0.8,
      end: 1.2,
    ).animate(CurvedAnimation(
      parent: _pulseController,
      curve: Curves.easeInOut,
    ));

    _progressController.forward();
    _pulseController.repeat(reverse: true);
  }

  @override
  void dispose() {
    _progressController.dispose();
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          'వ్యవసాయ సహాయకుడు లోడ్ అవుతోంది',
          style: GoogleFonts.notoSans(
            fontSize: 14.sp,
            fontWeight: FontWeight.w500,
            color: AppTheme.lightTheme.colorScheme.onSurface,
          ),
          textAlign: TextAlign.center,
        ),
        SizedBox(height: 3.h),
        Container(
          width: 60.w,
          height: 0.8.h,
          decoration: BoxDecoration(
            color: AppTheme.lightTheme.colorScheme.surface,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: AppTheme.lightTheme.colorScheme.outline
                  .withValues(alpha: 0.3),
              width: 1,
            ),
          ),
          child: AnimatedBuilder(
            animation: _progressAnimation,
            builder: (context, child) {
              return Stack(
                children: [
                  Container(
                    width: 60.w * _progressAnimation.value,
                    height: 0.8.h,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          AppTheme.lightTheme.colorScheme.primary,
                          AppTheme.lightTheme.colorScheme.secondary,
                        ],
                      ),
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ],
              );
            },
          ),
        ),
        SizedBox(height: 2.h),
        AnimatedBuilder(
          animation: _pulseAnimation,
          builder: (context, child) {
            return Transform.scale(
              scale: _pulseAnimation.value,
              child: Container(
                width: 6.w,
                height: 6.w,
                decoration: BoxDecoration(
                  color: AppTheme.lightTheme.colorScheme.primary
                      .withValues(alpha: 0.2),
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Container(
                    width: 3.w,
                    height: 3.w,
                    decoration: BoxDecoration(
                      color: AppTheme.lightTheme.colorScheme.primary,
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ],
    );
  }
}