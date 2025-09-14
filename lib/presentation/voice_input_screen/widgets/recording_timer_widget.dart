import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../../theme/app_theme.dart';

class RecordingTimerWidget extends StatelessWidget {
  final Duration recordingDuration;
  final bool isRecording;
  final Duration maxDuration;

  const RecordingTimerWidget({
    Key? key,
    required this.recordingDuration,
    required this.isRecording,
    this.maxDuration = const Duration(seconds: 60),
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (!isRecording && recordingDuration.inSeconds == 0) {
      return const SizedBox.shrink();
    }

    final progress =
        recordingDuration.inMilliseconds / maxDuration.inMilliseconds;
    final isNearLimit = progress > 0.8;

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
      decoration: BoxDecoration(
        color: isNearLimit
            ? AppTheme.lightTheme.colorScheme.error.withValues(alpha: 0.1)
            : AppTheme.lightTheme.colorScheme.primary.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isNearLimit
              ? AppTheme.lightTheme.colorScheme.error.withValues(alpha: 0.3)
              : AppTheme.lightTheme.colorScheme.primary.withValues(alpha: 0.3),
          width: 1,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Recording indicator dot
          if (isRecording)
            Container(
              width: 2.w,
              height: 2.w,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isNearLimit
                    ? AppTheme.lightTheme.colorScheme.error
                    : AppTheme.lightTheme.colorScheme.primary,
              ),
            ),

          if (isRecording) SizedBox(width: 2.w),

          // Timer text
          Text(
            _formatDuration(recordingDuration),
            style: AppTheme.lightTheme.textTheme.labelLarge?.copyWith(
              color: isNearLimit
                  ? AppTheme.lightTheme.colorScheme.error
                  : AppTheme.lightTheme.colorScheme.primary,
              fontWeight: FontWeight.w600,
              fontFeatures: [const FontFeature.tabularFigures()],
            ),
          ),

          SizedBox(width: 2.w),

          // Progress indicator
          Container(
            width: 15.w,
            height: 0.5.h,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(2),
              color: isNearLimit
                  ? AppTheme.lightTheme.colorScheme.error.withValues(alpha: 0.2)
                  : AppTheme.lightTheme.colorScheme.primary
                      .withValues(alpha: 0.2),
            ),
            child: FractionallySizedBox(
              alignment: Alignment.centerLeft,
              widthFactor: progress.clamp(0.0, 1.0),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(2),
                  color: isNearLimit
                      ? AppTheme.lightTheme.colorScheme.error
                      : AppTheme.lightTheme.colorScheme.primary,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _formatDuration(Duration duration) {
    final minutes = duration.inMinutes;
    final seconds = duration.inSeconds % 60;
    return '${minutes.toString().padLeft(1, '0')}:${seconds.toString().padLeft(2, '0')}';
  }
}
