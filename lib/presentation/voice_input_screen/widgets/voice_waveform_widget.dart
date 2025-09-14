import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../../theme/app_theme.dart';

class VoiceWaveformWidget extends StatefulWidget {
  final bool isRecording;
  final double audioLevel;
  final List<double> waveformData;

  const VoiceWaveformWidget({
    Key? key,
    required this.isRecording,
    this.audioLevel = 0.0,
    this.waveformData = const [],
  }) : super(key: key);

  @override
  State<VoiceWaveformWidget> createState() => _VoiceWaveformWidgetState();
}

class _VoiceWaveformWidgetState extends State<VoiceWaveformWidget>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _animation;
  List<double> _displayWaveform = [];

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 100),
      vsync: this,
    );
    _animation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(_animationController);

    _initializeWaveform();
  }

  void _initializeWaveform() {
    _displayWaveform = List.generate(30, (index) => 0.1);
  }

  @override
  void didUpdateWidget(VoiceWaveformWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isRecording != oldWidget.isRecording) {
      if (widget.isRecording) {
        _animationController.repeat();
      } else {
        _animationController.stop();
        _animationController.reset();
        setState(() {
          _displayWaveform = List.generate(30, (index) => 0.1);
        });
      }
    }

    if (widget.audioLevel != oldWidget.audioLevel && widget.isRecording) {
      _updateWaveform();
    }
  }

  void _updateWaveform() {
    setState(() {
      // Shift existing values to the left
      for (int i = 0; i < _displayWaveform.length - 1; i++) {
        _displayWaveform[i] = _displayWaveform[i + 1];
      }

      // Add new value based on audio level
      final newValue = (widget.audioLevel * 0.8 + 0.1).clamp(0.1, 0.9);
      _displayWaveform[_displayWaveform.length - 1] = newValue;
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!widget.isRecording && widget.waveformData.isEmpty) {
      return const SizedBox.shrink();
    }

    return Container(
      width: 80.w,
      height: 8.h,
      margin: EdgeInsets.symmetric(horizontal: 10.w),
      child: AnimatedBuilder(
        animation: _animation,
        builder: (context, child) {
          return CustomPaint(
            painter: WaveformPainter(
              waveformData:
                  widget.isRecording ? _displayWaveform : widget.waveformData,
              isRecording: widget.isRecording,
              animationValue: _animation.value,
              primaryColor: AppTheme.lightTheme.colorScheme.primary,
              backgroundColor: AppTheme.lightTheme.colorScheme.primary
                  .withValues(alpha: 0.2),
            ),
            size: Size(80.w, 8.h),
          );
        },
      ),
    );
  }
}

class WaveformPainter extends CustomPainter {
  final List<double> waveformData;
  final bool isRecording;
  final double animationValue;
  final Color primaryColor;
  final Color backgroundColor;

  WaveformPainter({
    required this.waveformData,
    required this.isRecording,
    required this.animationValue,
    required this.primaryColor,
    required this.backgroundColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    if (waveformData.isEmpty) return;

    final paint = Paint()
      ..style = PaintingStyle.fill
      ..strokeCap = StrokeCap.round;

    final barWidth = size.width / waveformData.length;
    final centerY = size.height / 2;

    for (int i = 0; i < waveformData.length; i++) {
      final barHeight = waveformData[i] * size.height;
      final x = i * barWidth + barWidth / 2;

      // Background bar
      paint.color = backgroundColor;
      canvas.drawRRect(
        RRect.fromRectAndRadius(
          Rect.fromCenter(
            center: Offset(x, centerY),
            width: barWidth * 0.6,
            height: size.height * 0.2,
          ),
          const Radius.circular(2),
        ),
        paint,
      );

      // Active bar
      if (isRecording) {
        // Animate color based on position and animation value
        final colorIntensity = (animationValue + i * 0.1) % 1.0;
        paint.color = Color.lerp(
          primaryColor.withValues(alpha: 0.3),
          primaryColor,
          colorIntensity,
        )!;
      } else {
        paint.color = primaryColor;
      }

      canvas.drawRRect(
        RRect.fromRectAndRadius(
          Rect.fromCenter(
            center: Offset(x, centerY),
            width: barWidth * 0.6,
            height: barHeight,
          ),
          const Radius.circular(2),
        ),
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant WaveformPainter oldDelegate) {
    return oldDelegate.waveformData != waveformData ||
        oldDelegate.isRecording != isRecording ||
        oldDelegate.animationValue != animationValue;
  }
}
