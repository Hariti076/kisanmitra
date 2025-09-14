import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../../theme/app_theme.dart';

class SuggestionChipsWidget extends StatelessWidget {
  final Function(String) onChipTap;
  final bool isLoading;

  const SuggestionChipsWidget({
    Key? key,
    required this.onChipTap,
    this.isLoading = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final List<String> suggestions = [
      'పంట వ్యాధులు',
      'ఎరువులు',
      'నీటిపారుదల',
      'కీటకాలు',
      'విత్తనాలు',
      'వాతావరణం'
    ];

    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'సాధారణ ప్రశ్నలు:',
            style: AppTheme.lightTheme.textTheme.titleSmall?.copyWith(
              color: AppTheme.lightTheme.colorScheme.onSurface
                  .withValues(alpha: 0.7),
              fontWeight: FontWeight.w500,
            ),
          ),
          SizedBox(height: 1.h),
          Wrap(
            spacing: 2.w,
            runSpacing: 1.h,
            children: suggestions.map((suggestion) {
              return GestureDetector(
                onTap: isLoading ? null : () => onChipTap(suggestion),
                child: AnimatedContainer(
                  duration: Duration(milliseconds: 200),
                  padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
                  decoration: BoxDecoration(
                    color: isLoading
                        ? AppTheme.lightTheme.colorScheme.surface
                            .withValues(alpha: 0.5)
                        : AppTheme.lightTheme.colorScheme.primaryContainer
                            .withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: isLoading
                          ? AppTheme.lightTheme.colorScheme.outline
                              .withValues(alpha: 0.3)
                          : AppTheme.lightTheme.colorScheme.primary
                              .withValues(alpha: 0.3),
                      width: 1,
                    ),
                  ),
                  child: Text(
                    suggestion,
                    style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                      color: isLoading
                          ? AppTheme.lightTheme.colorScheme.onSurface
                              .withValues(alpha: 0.4)
                          : AppTheme.lightTheme.colorScheme.primary,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}
