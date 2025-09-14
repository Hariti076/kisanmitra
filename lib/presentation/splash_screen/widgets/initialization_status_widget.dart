import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../core/app_export.dart';
import '../../../theme/app_theme.dart';
import '../../../widgets/custom_icon_widget.dart';

class InitializationStatusWidget extends StatefulWidget {
  final VoidCallback? onInitializationComplete;

  const InitializationStatusWidget({
    Key? key,
    this.onInitializationComplete,
  }) : super(key: key);

  @override
  State<InitializationStatusWidget> createState() =>
      _InitializationStatusWidgetState();
}

class _InitializationStatusWidgetState
    extends State<InitializationStatusWidget> {
  final List<Map<String, dynamic>> _initializationSteps = [
    {
      'title': 'తెలుగు భాషా మోడల్స్ లోడ్ చేస్తోంది',
      'completed': false,
      'duration': 800,
    },
    {
      'title': 'వాయిస్ రికగ్నిషన్ సేవలు ప్రారంభిస్తోంది',
      'completed': false,
      'duration': 600,
    },
    {
      'title': 'కెమెరా అనుమతులు తనిఖీ చేస్తోంది',
      'completed': false,
      'duration': 400,
    },
    {
      'title': 'వ్యవసాయ డేటాబేస్ సిద్ధం చేస్తోంది',
      'completed': false,
      'duration': 700,
    },
  ];

  int _currentStep = 0;
  bool _allCompleted = false;

  @override
  void initState() {
    super.initState();
    _startInitialization();
  }

  Future<void> _startInitialization() async {
    for (int i = 0; i < _initializationSteps.length; i++) {
      await Future.delayed(
          Duration(milliseconds: _initializationSteps[i]['duration']));

      if (mounted) {
        setState(() {
          _initializationSteps[i]['completed'] = true;
          _currentStep = i + 1;
        });
      }
    }

    await Future.delayed(const Duration(milliseconds: 500));

    if (mounted) {
      setState(() {
        _allCompleted = true;
      });

      widget.onInitializationComplete?.call();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 80.w,
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.surface.withValues(alpha: 0.9),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppTheme.lightTheme.colorScheme.outline.withValues(alpha: 0.2),
          width: 1,
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ..._initializationSteps.asMap().entries.map((entry) {
            int index = entry.key;
            Map<String, dynamic> step = entry.value;
            bool isActive = index <= _currentStep - 1;
            bool isCompleted = step['completed'];

            return Padding(
              padding: EdgeInsets.symmetric(vertical: 0.5.h),
              child: Row(
                children: [
                  Container(
                    width: 5.w,
                    height: 5.w,
                    decoration: BoxDecoration(
                      color: isCompleted
                          ? AppTheme.lightTheme.colorScheme.primary
                          : isActive
                              ? AppTheme.lightTheme.colorScheme.secondary
                              : AppTheme.lightTheme.colorScheme.outline
                                  .withValues(alpha: 0.3),
                      shape: BoxShape.circle,
                    ),
                    child: isCompleted
                        ? CustomIconWidget(
                            iconName: 'check',
                            color: AppTheme.lightTheme.colorScheme.onPrimary,
                            size: 3.w,
                          )
                        : isActive
                            ? SizedBox(
                                width: 3.w,
                                height: 3.w,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                    AppTheme.lightTheme.colorScheme.onSecondary,
                                  ),
                                ),
                              )
                            : null,
                  ),
                  SizedBox(width: 3.w),
                  Expanded(
                    child: Text(
                      step['title'],
                      style: GoogleFonts.notoSans(
                        fontSize: 12.sp,
                        fontWeight:
                            isActive ? FontWeight.w500 : FontWeight.w400,
                        color: isActive
                            ? AppTheme.lightTheme.colorScheme.onSurface
                            : AppTheme.lightTheme.colorScheme.onSurface
                                .withValues(alpha: 0.6),
                      ),
                    ),
                  ),
                ],
              ),
            );
          }).toList(),
          if (_allCompleted) ...[
            SizedBox(height: 2.h),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
              decoration: BoxDecoration(
                color: AppTheme.lightTheme.colorScheme.primary
                    .withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CustomIconWidget(
                    iconName: 'check_circle',
                    color: AppTheme.lightTheme.colorScheme.primary,
                    size: 4.w,
                  ),
                  SizedBox(width: 2.w),
                  Text(
                    'సిద్ధం!',
                    style: GoogleFonts.notoSans(
                      fontSize: 13.sp,
                      fontWeight: FontWeight.w600,
                      color: AppTheme.lightTheme.colorScheme.primary,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}