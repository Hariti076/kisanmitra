import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../../theme/app_theme.dart';

class HistorySkeletonLoader extends StatefulWidget {
  const HistorySkeletonLoader({Key? key}) : super(key: key);

  @override
  State<HistorySkeletonLoader> createState() => _HistorySkeletonLoaderState();
}

class _HistorySkeletonLoaderState extends State<HistorySkeletonLoader>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );
    _animation = Tween<double>(begin: 0.3, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
    _animationController.repeat(reverse: true);
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return ListView.builder(
          itemCount: 5,
          padding: EdgeInsets.symmetric(vertical: 2.h),
          itemBuilder: (context, index) {
            return Padding(
              padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
              child: Container(
                width: double.infinity,
                padding: EdgeInsets.all(4.w),
                decoration: BoxDecoration(
                  color: AppTheme.lightTheme.colorScheme.surface,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: AppTheme.lightTheme.dividerColor,
                    width: 1,
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        _buildShimmerBox(8.w, 8.w, isCircle: true),
                        SizedBox(width: 3.w),
                        _buildShimmerBox(20.w, 2.h),
                        const Spacer(),
                        _buildShimmerBox(15.w, 2.h),
                      ],
                    ),
                    SizedBox(height: 2.h),
                    _buildShimmerBox(double.infinity, 2.h),
                    SizedBox(height: 1.h),
                    _buildShimmerBox(80.w, 2.h),
                    SizedBox(height: 2.h),
                    Container(
                      width: double.infinity,
                      padding: EdgeInsets.all(3.w),
                      decoration: BoxDecoration(
                        color: AppTheme.lightTheme.colorScheme.surface
                            .withValues(alpha: 0.5),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: AppTheme.lightTheme.dividerColor
                              .withValues(alpha: 0.5),
                          width: 1,
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildShimmerBox(double.infinity, 1.5.h),
                          SizedBox(height: 1.h),
                          _buildShimmerBox(90.w, 1.5.h),
                          SizedBox(height: 1.h),
                          _buildShimmerBox(70.w, 1.5.h),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildShimmerBox(double width, double height,
      {bool isCircle = false}) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.dividerColor
            .withValues(alpha: _animation.value),
        borderRadius: isCircle
            ? BorderRadius.circular(width / 2)
            : BorderRadius.circular(4),
      ),
    );
  }
}
