import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class EmptyHistoryState extends StatelessWidget {
  const EmptyHistoryState({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(8.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 40.w,
              height: 40.w,
              decoration: BoxDecoration(
                color: AppTheme.lightTheme.colorScheme.primary
                    .withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(20.w),
              ),
              child: Center(
                child: CustomIconWidget(
                  iconName: 'history',
                  color: AppTheme.lightTheme.colorScheme.primary,
                  size: 15.w,
                ),
              ),
            ),
            SizedBox(height: 4.h),
            Text(
              'మీ ప్రశ్న చరిత్ర ఇక్కడ కనిపిస్తుంది',
              style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w600,
                color: AppTheme.lightTheme.colorScheme.onSurface,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 2.h),
            Text(
              'మీరు AI సహాయకుడిని ఉపయోగించి అడిగిన అన్ని ప్రశ్నలు మరియు వాటి జవాబులు ఇక్కడ భద్రపరచబడతాయి.',
              style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 4.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildFeatureCard(
                  icon: 'keyboard',
                  label: 'టెక్స్ట్',
                  color: AppTheme.lightTheme.colorScheme.primary,
                ),
                _buildFeatureCard(
                  icon: 'mic',
                  label: 'వాయిస్',
                  color: AppTheme.lightTheme.colorScheme.tertiary,
                ),
                _buildFeatureCard(
                  icon: 'camera_alt',
                  label: 'చిత్రం',
                  color: AppTheme.lightTheme.colorScheme.secondary,
                ),
              ],
            ),
            SizedBox(height: 4.h),
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/main-dashboard');
              },
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 2.h),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: Text(
                'ప్రశ్న అడగండి',
                style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                  color: AppTheme.lightTheme.colorScheme.onPrimary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFeatureCard({
    required String icon,
    required String label,
    required Color color,
  }) {
    return Column(
      children: [
        Container(
          width: 15.w,
          height: 15.w,
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(7.5.w),
          ),
          child: Center(
            child: CustomIconWidget(
              iconName: icon,
              color: color,
              size: 6.w,
            ),
          ),
        ),
        SizedBox(height: 1.h),
        Text(
          label,
          style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
            color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}
