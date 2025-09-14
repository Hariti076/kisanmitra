import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class AnalysisProgressWidget extends StatefulWidget {
  final bool isAnalyzing;

  const AnalysisProgressWidget({
    Key? key,
    required this.isAnalyzing,
  }) : super(key: key);

  @override
  State<AnalysisProgressWidget> createState() => _AnalysisProgressWidgetState();
}

class _AnalysisProgressWidgetState extends State<AnalysisProgressWidget>
    with TickerProviderStateMixin {
  late AnimationController _rotationController;
  late AnimationController _pulseController;
  late Animation<double> _rotationAnimation;
  late Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();

    _rotationController = AnimationController(
      duration: Duration(seconds: 2),
      vsync: this,
    );

    _pulseController = AnimationController(
      duration: Duration(milliseconds: 1500),
      vsync: this,
    );

    _rotationAnimation = Tween<double>(
      begin: 0,
      end: 1,
    ).animate(CurvedAnimation(
      parent: _rotationController,
      curve: Curves.linear,
    ));

    _pulseAnimation = Tween<double>(
      begin: 0.8,
      end: 1.2,
    ).animate(CurvedAnimation(
      parent: _pulseController,
      curve: Curves.easeInOut,
    ));

    if (widget.isAnalyzing) {
      _startAnimations();
    }
  }

  void _startAnimations() {
    _rotationController.repeat();
    _pulseController.repeat(reverse: true);
  }

  void _stopAnimations() {
    _rotationController.stop();
    _pulseController.stop();
  }

  @override
  void didUpdateWidget(AnalysisProgressWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isAnalyzing && !oldWidget.isAnalyzing) {
      _startAnimations();
    } else if (!widget.isAnalyzing && oldWidget.isAnalyzing) {
      _stopAnimations();
    }
  }

  @override
  void dispose() {
    _rotationController.dispose();
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!widget.isAnalyzing) {
      return SizedBox.shrink();
    }

    return Container(
      width: double.infinity,
      height: double.infinity,
      color: Colors.black.withValues(alpha: 0.8),
      child: Center(
        child: Container(
          width: 80.w,
          padding: EdgeInsets.all(6.w),
          decoration: BoxDecoration(
            color: AppTheme.lightTheme.colorScheme.surface,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.2),
                blurRadius: 20,
                offset: Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Animated analysis icon
              AnimatedBuilder(
                animation: _rotationAnimation,
                builder: (context, child) {
                  return Transform.rotate(
                    angle: _rotationAnimation.value * 2 * 3.14159,
                    child: AnimatedBuilder(
                      animation: _pulseAnimation,
                      builder: (context, child) {
                        return Transform.scale(
                          scale: _pulseAnimation.value,
                          child: Container(
                            width: 20.w,
                            height: 20.w,
                            decoration: BoxDecoration(
                              color: AppTheme.lightTheme.primaryColor
                                  .withValues(alpha: 0.1),
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: AppTheme.lightTheme.primaryColor,
                                width: 2,
                              ),
                            ),
                            child: Center(
                              child: CustomIconWidget(
                                iconName: 'biotech',
                                color: AppTheme.lightTheme.primaryColor,
                                size: 8.w,
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  );
                },
              ),

              SizedBox(height: 4.h),

              // Progress indicator
              LinearProgressIndicator(
                backgroundColor:
                    AppTheme.lightTheme.primaryColor.withValues(alpha: 0.2),
                valueColor: AlwaysStoppedAnimation<Color>(
                  AppTheme.lightTheme.primaryColor,
                ),
              ),

              SizedBox(height: 3.h),

              // Analysis text
              Text(
                'విశ్లేషిస్తోంది...',
                style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: AppTheme.lightTheme.primaryColor,
                ),
              ),

              SizedBox(height: 1.h),

              Text(
                'దయచేసి వేచి ఉండండి, మేము మీ ఆకును విశ్లేషిస్తున్నాము',
                textAlign: TextAlign.center,
                style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                  color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                ),
              ),

              SizedBox(height: 3.h),

              // Analysis steps
              Container(
                padding: EdgeInsets.all(3.w),
                decoration: BoxDecoration(
                  color:
                      AppTheme.lightTheme.primaryColor.withValues(alpha: 0.05),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  children: [
                    _buildAnalysisStep('చిత్రం ప్రాసెస్ చేస్తోంది', true),
                    SizedBox(height: 1.h),
                    _buildAnalysisStep('వ్యాధులను గుర్తిస్తోంది', true),
                    SizedBox(height: 1.h),
                    _buildAnalysisStep('సిఫార్సులను తయారు చేస్తోంది', false),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAnalysisStep(String text, bool isActive) {
    return Row(
      children: [
        Container(
          width: 4.w,
          height: 4.w,
          decoration: BoxDecoration(
            color: isActive
                ? AppTheme.lightTheme.primaryColor
                : AppTheme.lightTheme.colorScheme.onSurfaceVariant
                    .withValues(alpha: 0.3),
            shape: BoxShape.circle,
          ),
          child: isActive
              ? Center(
                  child: SizedBox(
                    width: 2.w,
                    height: 2.w,
                    child: CircularProgressIndicator(
                      strokeWidth: 1,
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                    ),
                  ),
                )
              : null,
        ),
        SizedBox(width: 3.w),
        Expanded(
          child: Text(
            text,
            style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
              color: isActive
                  ? AppTheme.lightTheme.primaryColor
                  : AppTheme.lightTheme.colorScheme.onSurfaceVariant,
              fontWeight: isActive ? FontWeight.w500 : FontWeight.w400,
            ),
          ),
        ),
      ],
    );
  }
}
