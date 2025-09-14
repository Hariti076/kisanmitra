import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class ActionCardWidget extends StatelessWidget {
  final String title;
  final String subtitle;
  final String iconName;
  final Color iconColor;
  final VoidCallback onTap;
  final bool isActive;

  const ActionCardWidget({
    Key? key,
    required this.title,
    required this.subtitle,
    required this.iconName,
    required this.iconColor,
    required this.onTap,
    this.isActive = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: double.infinity,
        constraints: BoxConstraints(minHeight: 12.h),
        padding: EdgeInsets.all(5.w),
        decoration: BoxDecoration(
          color: isActive
              ? AppTheme.lightTheme.colorScheme.primary.withValues(alpha: 0.05)
              : AppTheme.lightTheme.colorScheme.surface,
          borderRadius: BorderRadius.circular(3.w),
          border: Border.all(
            color: isActive
                ? AppTheme.lightTheme.colorScheme.primary.withValues(alpha: 0.3)
                : AppTheme.lightTheme.colorScheme.outline
                    .withValues(alpha: 0.2),
            width: 1.5,
          ),
          boxShadow: [
            BoxShadow(
              color: AppTheme.lightTheme.colorScheme.shadow
                  .withValues(alpha: 0.08),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 15.w,
              height: 15.w,
              decoration: BoxDecoration(
                color: iconColor.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(2.w),
              ),
              child: Center(
                child: CustomIconWidget(
                  iconName: iconName,
                  color: iconColor,
                  size: 8.w,
                ),
              ),
            ),
            SizedBox(width: 4.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: AppTheme.lightTheme.colorScheme.onSurface,
                    ),
                  ),
                  SizedBox(height: 1.h),
                  Text(
                    subtitle,
                    style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                      color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            CustomIconWidget(
              iconName: 'arrow_forward_ios',
              color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
              size: 5.w,
            ),
          ],
        ),
      ),
    );
  }
}
