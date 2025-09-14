import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class HeaderWidget extends StatelessWidget {
  final VoidCallback onClosePressed;
  final int characterCount;
  final int maxCharacters;

  const HeaderWidget({
    Key? key,
    required this.onClosePressed,
    required this.characterCount,
    required this.maxCharacters,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.surface,
        boxShadow: [
          BoxShadow(
            color:
                AppTheme.lightTheme.colorScheme.shadow.withValues(alpha: 0.1),
            blurRadius: 4,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: SafeArea(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            GestureDetector(
              onTap: onClosePressed,
              child: Container(
                width: 10.w,
                height: 5.h,
                decoration: BoxDecoration(
                  color: AppTheme.lightTheme.colorScheme.onSurface
                      .withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: CustomIconWidget(
                  iconName: 'close',
                  color: AppTheme.lightTheme.colorScheme.onSurface,
                  size: 24,
                ),
              ),
            ),
            Expanded(
              child: Center(
                child: Text(
                  'టెక్స్ట్ ప్రశ్న',
                  style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: AppTheme.lightTheme.colorScheme.onSurface,
                  ),
                ),
              ),
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
              decoration: BoxDecoration(
                color: characterCount > maxCharacters * 0.9
                    ? AppTheme.lightTheme.colorScheme.error
                        .withValues(alpha: 0.1)
                    : AppTheme.lightTheme.colorScheme.primary
                        .withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                '$characterCount/$maxCharacters',
                style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                  color: characterCount > maxCharacters * 0.9
                      ? AppTheme.lightTheme.colorScheme.error
                      : AppTheme.lightTheme.colorScheme.primary,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
