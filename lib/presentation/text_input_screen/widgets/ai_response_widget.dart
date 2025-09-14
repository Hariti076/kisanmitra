import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class AiResponseWidget extends StatefulWidget {
  final String response;
  final bool isLoading;
  final VoidCallback? onRetry;

  const AiResponseWidget({
    Key? key,
    required this.response,
    this.isLoading = false,
    this.onRetry,
  }) : super(key: key);

  @override
  State<AiResponseWidget> createState() => _AiResponseWidgetState();
}

class _AiResponseWidgetState extends State<AiResponseWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  bool _isExpanded = true;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: Duration(milliseconds: 300),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );

    if (!widget.isLoading && widget.response.isNotEmpty) {
      _animationController.forward();
    }
  }

  @override
  void didUpdateWidget(AiResponseWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (!widget.isLoading &&
        widget.response.isNotEmpty &&
        oldWidget.isLoading) {
      _animationController.forward();
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _copyToClipboard() {
    Clipboard.setData(ClipboardData(text: widget.response));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('సమాధానం కాపీ చేయబడింది'),
        duration: Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _shareResponse() {
    // Share functionality would be implemented here
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('షేర్ ఫీచర్ త్వరలో అందుబాటులో ఉంటుంది'),
        duration: Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  Widget _buildLoadingSkeleton() {
    return Container(
      width: double.infinity,
      margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppTheme.lightTheme.colorScheme.outline.withValues(alpha: 0.2),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 8.w,
                height: 4.h,
                decoration: BoxDecoration(
                  color: AppTheme.lightTheme.colorScheme.primary
                      .withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: CustomIconWidget(
                  iconName: 'psychology',
                  color: AppTheme.lightTheme.colorScheme.primary,
                  size: 20,
                ),
              ),
              SizedBox(width: 3.w),
              Text(
                'AI సమాధానం తయారు చేస్తోంది...',
                style: AppTheme.lightTheme.textTheme.titleSmall?.copyWith(
                  color: AppTheme.lightTheme.colorScheme.primary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          SizedBox(height: 3.h),
          ...List.generate(
              3,
              (index) => Padding(
                    padding: EdgeInsets.only(bottom: 2.h),
                    child: Container(
                      height: 2.h,
                      width: index == 2 ? 60.w : double.infinity,
                      decoration: BoxDecoration(
                        color: AppTheme.lightTheme.colorScheme.onSurface
                            .withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                  )),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (widget.isLoading) {
      return _buildLoadingSkeleton();
    }

    if (widget.response.isEmpty) {
      return SizedBox.shrink();
    }

    return FadeTransition(
      opacity: _fadeAnimation,
      child: Container(
        width: double.infinity,
        margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
        decoration: BoxDecoration(
          color: AppTheme.lightTheme.colorScheme.surface,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color:
                AppTheme.lightTheme.colorScheme.primary.withValues(alpha: 0.2),
          ),
          boxShadow: [
            BoxShadow(
              color:
                  AppTheme.lightTheme.colorScheme.shadow.withValues(alpha: 0.1),
              blurRadius: 8,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Container(
              padding: EdgeInsets.all(4.w),
              decoration: BoxDecoration(
                color: AppTheme.lightTheme.colorScheme.primary
                    .withValues(alpha: 0.05),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(12),
                  topRight: Radius.circular(12),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Container(
                        width: 8.w,
                        height: 4.h,
                        decoration: BoxDecoration(
                          color: AppTheme.lightTheme.colorScheme.primary
                              .withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: CustomIconWidget(
                          iconName: 'psychology',
                          color: AppTheme.lightTheme.colorScheme.primary,
                          size: 20,
                        ),
                      ),
                      SizedBox(width: 3.w),
                      Text(
                        'AI సమాధానం',
                        style:
                            AppTheme.lightTheme.textTheme.titleSmall?.copyWith(
                          color: AppTheme.lightTheme.colorScheme.primary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        _isExpanded = !_isExpanded;
                      });
                    },
                    child: CustomIconWidget(
                      iconName: _isExpanded ? 'expand_less' : 'expand_more',
                      color: AppTheme.lightTheme.colorScheme.onSurface
                          .withValues(alpha: 0.6),
                      size: 24,
                    ),
                  ),
                ],
              ),
            ),

            // Content
            if (_isExpanded) ...[
              Padding(
                padding: EdgeInsets.all(4.w),
                child: Text(
                  widget.response,
                  style: AppTheme.lightTheme.textTheme.bodyLarge?.copyWith(
                    fontSize: 15.sp,
                    height: 1.6,
                    color: AppTheme.lightTheme.colorScheme.onSurface,
                  ),
                ),
              ),

              // Action buttons
              Container(
                padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.w),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton.icon(
                      onPressed: _copyToClipboard,
                      icon: CustomIconWidget(
                        iconName: 'content_copy',
                        color: AppTheme.lightTheme.colorScheme.primary,
                        size: 18,
                      ),
                      label: Text(
                        'కాపీ',
                        style:
                            AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                          color: AppTheme.lightTheme.colorScheme.primary,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    SizedBox(width: 2.w),
                    TextButton.icon(
                      onPressed: _shareResponse,
                      icon: CustomIconWidget(
                        iconName: 'share',
                        color: AppTheme.lightTheme.colorScheme.primary,
                        size: 18,
                      ),
                      label: Text(
                        'షేర్',
                        style:
                            AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                          color: AppTheme.lightTheme.colorScheme.primary,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
