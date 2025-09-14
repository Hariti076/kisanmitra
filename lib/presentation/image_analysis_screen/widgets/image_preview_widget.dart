import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class ImagePreviewWidget extends StatelessWidget {
  final XFile? capturedImage;
  final VoidCallback onRetake;
  final VoidCallback onConfirm;

  const ImagePreviewWidget({
    Key? key,
    required this.capturedImage,
    required this.onRetake,
    required this.onConfirm,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (capturedImage == null) {
      return Container();
    }

    return Container(
      width: double.infinity,
      height: double.infinity,
      color: Colors.black,
      child: Stack(
        children: [
          // Image preview
          Center(
            child: Container(
              width: 90.w,
              height: 70.h,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.3),
                    blurRadius: 8,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: Image.file(
                  File(capturedImage!.path),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),

          // Top bar with close button
          Positioned(
            top: 6.h,
            left: 4.w,
            right: 4.w,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: Container(
                    padding: EdgeInsets.all(2.w),
                    decoration: BoxDecoration(
                      color: Colors.black.withValues(alpha: 0.5),
                      shape: BoxShape.circle,
                    ),
                    child: CustomIconWidget(
                      iconName: 'close',
                      color: Colors.white,
                      size: 6.w,
                    ),
                  ),
                ),
                Text(
                  'ఫోటో ప్రివ్యూ',
                  style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(width: 10.w),
              ],
            ),
          ),

          // Bottom action buttons
          Positioned(
            bottom: 6.h,
            left: 4.w,
            right: 4.w,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                // Retake button
                Expanded(
                  child: GestureDetector(
                    onTap: onRetake,
                    child: Container(
                      padding: EdgeInsets.symmetric(vertical: 2.h),
                      decoration: BoxDecoration(
                        color: Colors.black.withValues(alpha: 0.7),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: Colors.white.withValues(alpha: 0.3),
                          width: 1,
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          CustomIconWidget(
                            iconName: 'refresh',
                            color: Colors.white,
                            size: 5.w,
                          ),
                          SizedBox(width: 2.w),
                          Text(
                            'మళ్లీ తీయండి',
                            style: AppTheme.lightTheme.textTheme.bodyLarge
                                ?.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

                SizedBox(width: 4.w),

                // Confirm button
                Expanded(
                  child: GestureDetector(
                    onTap: onConfirm,
                    child: Container(
                      padding: EdgeInsets.symmetric(vertical: 2.h),
                      decoration: BoxDecoration(
                        color: AppTheme.lightTheme.primaryColor,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: AppTheme.lightTheme.primaryColor
                                .withValues(alpha: 0.3),
                            blurRadius: 8,
                            offset: Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          CustomIconWidget(
                            iconName: 'check',
                            color: Colors.white,
                            size: 5.w,
                          ),
                          SizedBox(width: 2.w),
                          Text(
                            'విశ్లేషించండి',
                            style: AppTheme.lightTheme.textTheme.bodyLarge
                                ?.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Image quality tips
          Positioned(
            bottom: 20.h,
            left: 4.w,
            right: 4.w,
            child: Container(
              padding: EdgeInsets.all(3.w),
              decoration: BoxDecoration(
                color: Colors.black.withValues(alpha: 0.7),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      CustomIconWidget(
                        iconName: 'info',
                        color: AppTheme.lightTheme.colorScheme.tertiary,
                        size: 5.w,
                      ),
                      SizedBox(width: 2.w),
                      Text(
                        'మంచి ఫలితాల కోసం:',
                        style:
                            AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 1.h),
                  Text(
                    '• ఆకు స్పష్టంగా కనిపించాలి\n• మంచి వెలుతురు ఉండాలి\n• ఆకు పూర్తిగా ఫ్రేమ్‌లో ఉండాలి',
                    style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                      color: Colors.white.withValues(alpha: 0.9),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
