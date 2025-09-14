import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class TranscriptionDisplayWidget extends StatelessWidget {
  final String transcribedText;
  final bool isTranscribing;
  final double confidence;

  const TranscriptionDisplayWidget({
    Key? key,
    required this.transcribedText,
    this.isTranscribing = false,
    this.confidence = 0.0,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 90.w,
      constraints: BoxConstraints(
        minHeight: 12.h,
        maxHeight: 25.h,
      ),
      margin: EdgeInsets.symmetric(horizontal: 5.w),
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppTheme.lightTheme.colorScheme.outline.withValues(alpha: 0.3),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          // Header with confidence indicator
          Row(
            children: [
              CustomIconWidget(
                iconName: 'record_voice_over',
                color: isTranscribing
                    ? AppTheme.lightTheme.colorScheme.primary
                    : AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                size: 5.w,
              ),
              SizedBox(width: 2.w),
              Text(
                'వాయిస్ టెక్స్ట్',
                style: AppTheme.lightTheme.textTheme.labelMedium?.copyWith(
                  color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                ),
              ),
              const Spacer(),
              if (confidence > 0.0)
                Container(
                  padding:
                      EdgeInsets.symmetric(horizontal: 2.w, vertical: 0.5.h),
                  decoration: BoxDecoration(
                    color: _getConfidenceColor().withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    '${(confidence * 100).toInt()}%',
                    style: AppTheme.lightTheme.textTheme.labelSmall?.copyWith(
                      color: _getConfidenceColor(),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
            ],
          ),

          SizedBox(height: 2.h),

          // Transcribed text area
          Flexible(
            child: Container(
              width: double.infinity,
              child: transcribedText.isEmpty && !isTranscribing
                  ? _buildPlaceholder()
                  : _buildTranscriptionContent(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPlaceholder() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        CustomIconWidget(
          iconName: 'mic_none',
          color: AppTheme.lightTheme.colorScheme.onSurfaceVariant
              .withValues(alpha: 0.5),
          size: 8.w,
        ),
        SizedBox(height: 1.h),
        Text(
          'మైక్రోఫోన్ నొక్కి మీ ప్రశ్న అడగండి',
          textAlign: TextAlign.center,
          style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
            color: AppTheme.lightTheme.colorScheme.onSurfaceVariant
                .withValues(alpha: 0.7),
          ),
        ),
      ],
    );
  }

  Widget _buildTranscriptionContent() {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (isTranscribing)
            Row(
              children: [
                SizedBox(
                  width: 4.w,
                  height: 4.w,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor: AlwaysStoppedAnimation<Color>(
                      AppTheme.lightTheme.colorScheme.primary,
                    ),
                  ),
                ),
                SizedBox(width: 2.w),
                Text(
                  'వింటోంది...',
                  style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                    color: AppTheme.lightTheme.colorScheme.primary,
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ],
            ),
          if (transcribedText.isNotEmpty) ...[
            if (isTranscribing) SizedBox(height: 1.h),
            SelectableText(
              transcribedText,
              style: AppTheme.lightTheme.textTheme.bodyLarge?.copyWith(
                color: AppTheme.lightTheme.colorScheme.onSurface,
                height: 1.4,
              ),
            ),
          ],
          if (transcribedText.isEmpty && isTranscribing)
            Container(
              height: 6.h,
              child: Center(
                child: Text(
                  'మాట్లాడండి...',
                  style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                    color: AppTheme.lightTheme.colorScheme.onSurfaceVariant
                        .withValues(alpha: 0.7),
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Color _getConfidenceColor() {
    if (confidence >= 0.8) {
      return AppTheme.lightTheme.colorScheme.primary;
    } else if (confidence >= 0.6) {
      return const Color(0xFFFF8F00); // Warning color
    } else {
      return AppTheme.lightTheme.colorScheme.error;
    }
  }
}
