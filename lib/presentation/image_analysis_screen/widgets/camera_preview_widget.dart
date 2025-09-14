import 'package:camera/camera.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class CameraPreviewWidget extends StatelessWidget {
  final CameraController? cameraController;
  final bool isFlashOn;
  final VoidCallback onFlashToggle;
  final VoidCallback onCapture;
  final VoidCallback onGallery;

  const CameraPreviewWidget({
    Key? key,
    required this.cameraController,
    required this.isFlashOn,
    required this.onFlashToggle,
    required this.onCapture,
    required this.onGallery,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 70.h,
      decoration: BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Stack(
        children: [
          // Camera Preview
          if (cameraController != null && cameraController!.value.isInitialized)
            ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: SizedBox(
                width: double.infinity,
                height: double.infinity,
                child: CameraPreview(cameraController!),
              ),
            )
          else
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(
                    color: AppTheme.lightTheme.primaryColor,
                  ),
                  SizedBox(height: 2.h),
                  Text(
                    'కెమెరా లోడ్ అవుతోంది...',
                    style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),

          // Overlay guides for leaf positioning
          if (cameraController != null && cameraController!.value.isInitialized)
            Positioned.fill(
              child: CustomPaint(
                painter: LeafGuidePainter(),
              ),
            ),

          // Top controls
          Positioned(
            top: 2.h,
            left: 4.w,
            right: 4.w,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Close button
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

                // Flash toggle (only for mobile)
                if (!kIsWeb)
                  GestureDetector(
                    onTap: onFlashToggle,
                    child: Container(
                      padding: EdgeInsets.all(2.w),
                      decoration: BoxDecoration(
                        color: Colors.black.withValues(alpha: 0.5),
                        shape: BoxShape.circle,
                      ),
                      child: CustomIconWidget(
                        iconName: isFlashOn ? 'flash_on' : 'flash_off',
                        color: isFlashOn
                            ? AppTheme.lightTheme.colorScheme.tertiary
                            : Colors.white,
                        size: 6.w,
                      ),
                    ),
                  ),
              ],
            ),
          ),

          // Bottom action bar
          Positioned(
            bottom: 4.h,
            left: 4.w,
            right: 4.w,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                // Gallery button
                GestureDetector(
                  onTap: onGallery,
                  child: Container(
                    padding: EdgeInsets.all(3.w),
                    decoration: BoxDecoration(
                      color: Colors.black.withValues(alpha: 0.7),
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: Colors.white.withValues(alpha: 0.3),
                        width: 1,
                      ),
                    ),
                    child: CustomIconWidget(
                      iconName: 'photo_library',
                      color: Colors.white,
                      size: 7.w,
                    ),
                  ),
                ),

                // Capture button
                GestureDetector(
                  onTap: onCapture,
                  child: Container(
                    width: 20.w,
                    height: 20.w,
                    decoration: BoxDecoration(
                      color: AppTheme.lightTheme.primaryColor,
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: Colors.white,
                        width: 4,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.3),
                          blurRadius: 8,
                          offset: Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Center(
                      child: CustomIconWidget(
                        iconName: 'camera_alt',
                        color: Colors.white,
                        size: 8.w,
                      ),
                    ),
                  ),
                ),

                // Spacer for symmetry
                SizedBox(width: 14.w),
              ],
            ),
          ),

          // Instruction text
          Positioned(
            bottom: 15.h,
            left: 4.w,
            right: 4.w,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
              decoration: BoxDecoration(
                color: Colors.black.withValues(alpha: 0.7),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                'ఆకును గైడ్ లైన్లలో ఉంచి ఫోటో తీయండి',
                textAlign: TextAlign.center,
                style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class LeafGuidePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withValues(alpha: 0.8)
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;

    final center = Offset(size.width / 2, size.height / 2);
    final rect = Rect.fromCenter(
      center: center,
      width: size.width * 0.7,
      height: size.height * 0.5,
    );

    // Draw rounded rectangle guide
    canvas.drawRRect(
      RRect.fromRectAndRadius(rect, Radius.circular(16)),
      paint,
    );

    // Draw corner markers
    final cornerLength = 20.0;
    final corners = [
      rect.topLeft,
      rect.topRight,
      rect.bottomLeft,
      rect.bottomRight,
    ];

    for (final corner in corners) {
      // Horizontal line
      canvas.drawLine(
        corner,
        corner +
            Offset(
                corner == rect.topLeft || corner == rect.bottomLeft
                    ? cornerLength
                    : -cornerLength,
                0),
        paint..strokeWidth = 3,
      );

      // Vertical line
      canvas.drawLine(
        corner,
        corner +
            Offset(
                0,
                corner == rect.topLeft || corner == rect.topRight
                    ? cornerLength
                    : -cornerLength),
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
