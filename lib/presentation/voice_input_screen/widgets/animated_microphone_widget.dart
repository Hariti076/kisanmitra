import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class AnimatedMicrophoneWidget extends StatefulWidget {
  final bool isRecording;
  final VoidCallback onTap;
  final double audioLevel;

  const AnimatedMicrophoneWidget({
    Key? key,
    required this.isRecording,
    required this.onTap,
    this.audioLevel = 0.0,
  }) : super(key: key);

  @override
  State<AnimatedMicrophoneWidget> createState() =>
      _AnimatedMicrophoneWidgetState();
}

class _AnimatedMicrophoneWidgetState extends State<AnimatedMicrophoneWidget>
    with TickerProviderStateMixin {
  late AnimationController _pulseController;
  late AnimationController _waveController;
  late Animation<double> _pulseAnimation;
  late Animation<double> _waveAnimation;

  @override
  void initState() {
    super.initState();

    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );

    _waveController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    );

    _pulseAnimation = Tween<double>(
      begin: 1.0,
      end: 1.2,
    ).animate(CurvedAnimation(
      parent: _pulseController,
      curve: Curves.easeInOut,
    ));

    _waveAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _waveController,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void didUpdateWidget(AnimatedMicrophoneWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isRecording != oldWidget.isRecording) {
      if (widget.isRecording) {
        _pulseController.repeat(reverse: true);
        _waveController.repeat();
      } else {
        _pulseController.stop();
        _waveController.stop();
        _pulseController.reset();
        _waveController.reset();
      }
    }
  }

  @override
  void dispose() {
    _pulseController.dispose();
    _waveController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      child: Container(
        width: 45.w,
        height: 45.w,
        child: Stack(
          alignment: Alignment.center,
          children: [
            // Outer concentric circles
            if (widget.isRecording) ...[
              AnimatedBuilder(
                animation: _waveAnimation,
                builder: (context, child) {
                  return Container(
                    width: 45.w * (1 + _waveAnimation.value * 0.5),
                    height: 45.w * (1 + _waveAnimation.value * 0.5),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: AppTheme.lightTheme.colorScheme.primary
                            .withValues(
                                alpha: 0.3 * (1 - _waveAnimation.value)),
                        width: 2,
                      ),
                    ),
                  );
                },
              ),
              AnimatedBuilder(
                animation: _waveAnimation,
                builder: (context, child) {
                  return Container(
                    width: 45.w * (1 + _waveAnimation.value * 0.3),
                    height: 45.w * (1 + _waveAnimation.value * 0.3),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: AppTheme.lightTheme.colorScheme.primary
                            .withValues(
                                alpha: 0.5 * (1 - _waveAnimation.value)),
                        width: 2,
                      ),
                    ),
                  );
                },
              ),
            ],

            // Main microphone button
            AnimatedBuilder(
              animation: _pulseAnimation,
              builder: (context, child) {
                return Transform.scale(
                  scale: widget.isRecording ? _pulseAnimation.value : 1.0,
                  child: Container(
                    width: 30.w,
                    height: 30.w,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: widget.isRecording
                          ? AppTheme.lightTheme.colorScheme.error
                          : AppTheme.lightTheme.colorScheme.primary,
                      boxShadow: [
                        BoxShadow(
                          color: widget.isRecording
                              ? AppTheme.lightTheme.colorScheme.error
                                  .withValues(alpha: 0.3)
                              : AppTheme.lightTheme.colorScheme.primary
                                  .withValues(alpha: 0.3),
                          blurRadius: 20,
                          spreadRadius: 5,
                        ),
                      ],
                    ),
                    child: Center(
                      child: CustomIconWidget(
                        iconName: widget.isRecording ? 'stop' : 'mic',
                        color: Colors.white,
                        size: 8.w,
                      ),
                    ),
                  ),
                );
              },
            ),

            // Audio level indicator
            if (widget.isRecording && widget.audioLevel > 0.1)
              Positioned(
                bottom: -2.h,
                child: Container(
                  width: 20.w,
                  height: 1.h,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(2),
                    color: AppTheme.lightTheme.colorScheme.primary
                        .withValues(alpha: 0.3),
                  ),
                  child: FractionallySizedBox(
                    alignment: Alignment.centerLeft,
                    widthFactor: widget.audioLevel.clamp(0.0, 1.0),
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(2),
                        color: AppTheme.lightTheme.colorScheme.primary,
                      ),
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
