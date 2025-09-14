import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class QueryHistoryCard extends StatelessWidget {
  final Map<String, dynamic> queryData;
  final VoidCallback? onTap;
  final VoidCallback? onShare;
  final VoidCallback? onDelete;
  final VoidCallback? onFavorite;

  const QueryHistoryCard({
    Key? key,
    required this.queryData,
    this.onTap,
    this.onShare,
    this.onDelete,
    this.onFavorite,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final inputType = queryData['inputType'] as String? ?? 'text';
    final query = queryData['query'] as String? ?? '';
    final response = queryData['response'] as String? ?? '';
    final timestamp = queryData['timestamp'] as DateTime? ?? DateTime.now();
    final isFavorite = queryData['isFavorite'] as bool? ?? false;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
      child: Slidable(
        key: ValueKey(queryData['id']),
        startActionPane: ActionPane(
          motion: const ScrollMotion(),
          children: [
            SlidableAction(
              onPressed: (_) => onShare?.call(),
              backgroundColor: AppTheme.lightTheme.colorScheme.secondary,
              foregroundColor: Colors.white,
              icon: Icons.share,
              label: 'Share',
              borderRadius: BorderRadius.circular(12),
            ),
          ],
        ),
        endActionPane: ActionPane(
          motion: const ScrollMotion(),
          children: [
            SlidableAction(
              onPressed: (_) => onDelete?.call(),
              backgroundColor: AppTheme.lightTheme.colorScheme.error,
              foregroundColor: Colors.white,
              icon: Icons.delete,
              label: 'Delete',
              borderRadius: BorderRadius.circular(12),
            ),
          ],
        ),
        child: GestureDetector(
          onTap: onTap,
          onLongPress: onFavorite,
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
              boxShadow: [
                BoxShadow(
                  color: AppTheme.lightTheme.shadowColor,
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    _buildInputTypeIcon(inputType),
                    SizedBox(width: 3.w),
                    Expanded(
                      child: Text(
                        _getInputTypeLabel(inputType),
                        style:
                            AppTheme.lightTheme.textTheme.labelMedium?.copyWith(
                          color: AppTheme.lightTheme.colorScheme.primary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    if (isFavorite)
                      CustomIconWidget(
                        iconName: 'favorite',
                        color: AppTheme.lightTheme.colorScheme.tertiary,
                        size: 18,
                      ),
                    SizedBox(width: 2.w),
                    Text(
                      _formatTimestamp(timestamp),
                      style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                        color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 2.h),
                Text(
                  query.length > 100 ? '${query.substring(0, 100)}...' : query,
                  style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                    color: AppTheme.lightTheme.colorScheme.onSurface,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: 1.h),
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
                  child: Text(
                    response.length > 150
                        ? '${response.substring(0, 150)}...'
                        : response,
                    style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                      color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                    ),
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                SizedBox(height: 1.h),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    CustomIconWidget(
                      iconName: 'arrow_forward_ios',
                      color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                      size: 16,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInputTypeIcon(String inputType) {
    String iconName;
    Color iconColor;

    switch (inputType) {
      case 'voice':
        iconName = 'mic';
        iconColor = AppTheme.lightTheme.colorScheme.tertiary;
        break;
      case 'image':
        iconName = 'camera_alt';
        iconColor = AppTheme.lightTheme.colorScheme.secondary;
        break;
      default:
        iconName = 'keyboard';
        iconColor = AppTheme.lightTheme.colorScheme.primary;
    }

    return Container(
      padding: EdgeInsets.all(2.w),
      decoration: BoxDecoration(
        color: iconColor.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: CustomIconWidget(
        iconName: iconName,
        color: iconColor,
        size: 20,
      ),
    );
  }

  String _getInputTypeLabel(String inputType) {
    switch (inputType) {
      case 'voice':
        return 'వాయిస్ ప్రశ్న';
      case 'image':
        return 'చిత్రం విశ్లేషణ';
      default:
        return 'టెక్స్ట్ ప్రశ్న';
    }
  }

  String _formatTimestamp(DateTime timestamp) {
    final now = DateTime.now();
    final difference = now.difference(timestamp);

    if (difference.inDays > 0) {
      return '${difference.inDays} రోజుల క్రితం';
    } else if (difference.inHours > 0) {
      return '${difference.inHours} గంటల క్రితం';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes} నిమిషాల క్రితం';
    } else {
      return 'ఇప్పుడే';
    }
  }
}
