import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class TextInputFieldWidget extends StatefulWidget {
  final TextEditingController controller;
  final Function(String) onChanged;
  final VoidCallback? onVoicePressed;
  final bool isLoading;
  final int maxCharacters;

  const TextInputFieldWidget({
    Key? key,
    required this.controller,
    required this.onChanged,
    this.onVoicePressed,
    this.isLoading = false,
    this.maxCharacters = 500,
  }) : super(key: key);

  @override
  State<TextInputFieldWidget> createState() => _TextInputFieldWidgetState();
}

class _TextInputFieldWidgetState extends State<TextInputFieldWidget> {
  final FocusNode _focusNode = FocusNode();
  bool _isFocused = false;

  @override
  void initState() {
    super.initState();
    _focusNode.addListener(() {
      setState(() {
        _isFocused = _focusNode.hasFocus;
      });
    });
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      constraints: BoxConstraints(
        minHeight: 20.h,
        maxHeight: 35.h,
      ),
      margin: EdgeInsets.symmetric(horizontal: 4.w),
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: _isFocused
              ? AppTheme.lightTheme.colorScheme.primary
              : AppTheme.lightTheme.colorScheme.outline.withValues(alpha: 0.3),
          width: _isFocused ? 2 : 1,
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
        children: [
          Expanded(
            child: TextField(
              controller: widget.controller,
              focusNode: _focusNode,
              onChanged: widget.onChanged,
              enabled: !widget.isLoading,
              maxLines: null,
              expands: true,
              textAlignVertical: TextAlignVertical.top,
              style: AppTheme.lightTheme.textTheme.bodyLarge?.copyWith(
                fontSize: 16.sp,
                height: 1.5,
              ),
              decoration: InputDecoration(
                hintText: 'మీ వ్యవసాయ ప్రశ్నను ఇక్కడ టైప్ చేయండి...',
                hintStyle: AppTheme.lightTheme.textTheme.bodyLarge?.copyWith(
                  color: AppTheme.lightTheme.colorScheme.onSurface
                      .withValues(alpha: 0.5),
                  fontSize: 16.sp,
                ),
                border: InputBorder.none,
                contentPadding: EdgeInsets.all(4.w),
                suffixIcon: widget.onVoicePressed != null
                    ? Padding(
                        padding: EdgeInsets.only(right: 2.w, top: 2.w),
                        child: Align(
                          alignment: Alignment.topRight,
                          child: GestureDetector(
                            onTap:
                                widget.isLoading ? null : widget.onVoicePressed,
                            child: Container(
                              width: 12.w,
                              height: 6.h,
                              decoration: BoxDecoration(
                                color: AppTheme.lightTheme.colorScheme.primary
                                    .withValues(alpha: 0.1),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: CustomIconWidget(
                                iconName: 'mic',
                                color: widget.isLoading
                                    ? AppTheme.lightTheme.colorScheme.onSurface
                                        .withValues(alpha: 0.3)
                                    : AppTheme.lightTheme.colorScheme.primary,
                                size: 24,
                              ),
                            ),
                          ),
                        ),
                      )
                    : null,
              ),
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.w),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'టెలుగులో టైప్ చేయండి',
                  style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                    color: AppTheme.lightTheme.colorScheme.onSurface
                        .withValues(alpha: 0.6),
                    fontSize: 12.sp,
                  ),
                ),
                Text(
                  '${widget.controller.text.length}/${widget.maxCharacters}',
                  style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                    color: widget.controller.text.length >
                            widget.maxCharacters * 0.9
                        ? AppTheme.lightTheme.colorScheme.error
                        : AppTheme.lightTheme.colorScheme.onSurface
                            .withValues(alpha: 0.6),
                    fontSize: 12.sp,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
