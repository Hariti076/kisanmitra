import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class SearchFilterBar extends StatelessWidget {
  final TextEditingController searchController;
  final VoidCallback onFilterTap;
  final ValueChanged<String> onSearchChanged;

  const SearchFilterBar({
    Key? key,
    required this.searchController,
    required this.onFilterTap,
    required this.onSearchChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.surface,
        boxShadow: [
          BoxShadow(
            color: AppTheme.lightTheme.shadowColor,
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: Container(
              height: 6.h,
              decoration: BoxDecoration(
                color: AppTheme.lightTheme.colorScheme.surface,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: AppTheme.lightTheme.dividerColor,
                  width: 1,
                ),
              ),
              child: TextField(
                controller: searchController,
                onChanged: onSearchChanged,
                style: AppTheme.lightTheme.textTheme.bodyMedium,
                decoration: InputDecoration(
                  hintText: 'చరిత్రలో వెతకండి',
                  hintStyle: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                    color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                  ),
                  prefixIcon: Padding(
                    padding: EdgeInsets.all(3.w),
                    child: CustomIconWidget(
                      iconName: 'search',
                      color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                      size: 20,
                    ),
                  ),
                  suffixIcon: searchController.text.isNotEmpty
                      ? GestureDetector(
                          onTap: () {
                            searchController.clear();
                            onSearchChanged('');
                          },
                          child: Padding(
                            padding: EdgeInsets.all(3.w),
                            child: CustomIconWidget(
                              iconName: 'clear',
                              color: AppTheme
                                  .lightTheme.colorScheme.onSurfaceVariant,
                              size: 20,
                            ),
                          ),
                        )
                      : null,
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: 4.w,
                    vertical: 2.h,
                  ),
                ),
              ),
            ),
          ),
          SizedBox(width: 3.w),
          GestureDetector(
            onTap: onFilterTap,
            child: Container(
              height: 6.h,
              width: 6.h,
              decoration: BoxDecoration(
                color: AppTheme.lightTheme.colorScheme.primary,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: AppTheme.lightTheme.colorScheme.primary
                        .withValues(alpha: 0.3),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Center(
                child: CustomIconWidget(
                  iconName: 'filter_list',
                  color: AppTheme.lightTheme.colorScheme.onPrimary,
                  size: 24,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
