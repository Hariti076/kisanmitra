import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class VoiceResponseWidget extends StatefulWidget {
  final String responseText;
  final bool isPlaying;
  final VoidCallback? onPlayPause;
  final VoidCallback? onShare;

  const VoiceResponseWidget({
    Key? key,
    required this.responseText,
    this.isPlaying = false,
    this.onPlayPause,
    this.onShare,
  }) : super(key: key);

  @override
  State<VoiceResponseWidget> createState() => _VoiceResponseWidgetState();
}

class _VoiceResponseWidgetState extends State<VoiceResponseWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.elasticOut,
    ));

    // Start animation when widget is built
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _animationController.forward();
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _scaleAnimation,
      builder: (context, child) {
        return Transform.scale(
          scale: _scaleAnimation.value,
          child: Container(
            width: 90.w,
            margin: EdgeInsets.symmetric(horizontal: 5.w),
            padding: EdgeInsets.all(4.w),
            decoration: BoxDecoration(
              color: AppTheme.lightTheme.colorScheme.surface,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: AppTheme.lightTheme.colorScheme.primary
                    .withValues(alpha: 0.2),
                width: 1,
              ),
              boxShadow: [
                BoxShadow(
                  color: AppTheme.lightTheme.colorScheme.primary
                      .withValues(alpha: 0.1),
                  blurRadius: 20,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header with AI indicator
                Row(
                  children: [
                    Container(
                      padding: EdgeInsets.all(2.w),
                      decoration: BoxDecoration(
                        color: AppTheme.lightTheme.colorScheme.primary
                            .withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: CustomIconWidget(
                        iconName: 'psychology',
                        color: AppTheme.lightTheme.colorScheme.primary,
                        size: 5.w,
                      ),
                    ),
                    SizedBox(width: 3.w),
                    Expanded(
                      child: Text(
                        'కిసాన్ మిత్ర సలహా',
                        style:
                            AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                          color: AppTheme.lightTheme.colorScheme.primary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    // Action buttons
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // Play/Pause button
                        GestureDetector(
                          onTap: widget.onPlayPause,
                          child: Container(
                            padding: EdgeInsets.all(2.w),
                            decoration: BoxDecoration(
                              color: widget.isPlaying
                                  ? AppTheme.lightTheme.colorScheme.primary
                                      .withValues(alpha: 0.1)
                                  : Colors.transparent,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: CustomIconWidget(
                              iconName:
                                  widget.isPlaying ? 'pause' : 'play_arrow',
                              color: AppTheme.lightTheme.colorScheme.primary,
                              size: 5.w,
                            ),
                          ),
                        ),
                        SizedBox(width: 2.w),
                        // Share button
                        GestureDetector(
                          onTap: widget.onShare,
                          child: Container(
                            padding: EdgeInsets.all(2.w),
                            decoration: BoxDecoration(
                              color: Colors.transparent,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: CustomIconWidget(
                              iconName: 'share',
                              color: AppTheme
                                  .lightTheme.colorScheme.onSurfaceVariant,
                              size: 5.w,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),

                SizedBox(height: 3.h),

                // Response text
                Container(
                  width: double.infinity,
                  constraints: BoxConstraints(
                    maxHeight: 40.h,
                  ),
                  child: SingleChildScrollView(
                    child: SelectableText(
                      widget.responseText,
                      style: AppTheme.lightTheme.textTheme.bodyLarge?.copyWith(
                        color: AppTheme.lightTheme.colorScheme.onSurface,
                        height: 1.5,
                      ),
                    ),
                  ),
                ),

                SizedBox(height: 2.h),

                // Audio playback indicator
                if (widget.isPlaying)
                  Container(
                    width: double.infinity,
                    height: 1.h,
                    margin: EdgeInsets.symmetric(vertical: 1.h),
                    child: Row(
                      children: List.generate(20, (index) {
                        return Expanded(
                          child: Container(
                            margin: EdgeInsets.symmetric(horizontal: 0.5.w),
                            decoration: BoxDecoration(
                              color: AppTheme.lightTheme.colorScheme.primary
                                  .withValues(
                                alpha: 0.3 + (index % 3) * 0.2,
                              ),
                              borderRadius: BorderRadius.circular(1),
                            ),
                          ),
                        );
                      }),
                    ),
                  ),

                // Timestamp
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(
                      _getCurrentTime(),
                      style: AppTheme.lightTheme.textTheme.labelSmall?.copyWith(
                        color: AppTheme.lightTheme.colorScheme.onSurfaceVariant
                            .withValues(alpha: 0.7),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  String _getCurrentTime() {
    final now = DateTime.now();
    final hour = now.hour > 12 ? now.hour - 12 : now.hour;
    final minute = now.minute.toString().padLeft(2, '0');
    final period = now.hour >= 12 ? 'PM' : 'AM';
    return '$hour:$minute $period';
  }
}
