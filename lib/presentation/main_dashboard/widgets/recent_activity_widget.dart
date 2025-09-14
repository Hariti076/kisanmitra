import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class RecentActivityWidget extends StatelessWidget {
  const RecentActivityWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> recentQueries = [
      {
        "id": 1,
        "type": "voice",
        "query": "మా పంట ఆకులు పసుపు రంగులోకి మారుతున్నాయి",
        "timestamp": "2 గంటల క్రితం",
        "icon": "mic",
        "status": "completed"
      },
      {
        "id": 2,
        "type": "image",
        "query": "టమాటో ఆకుల వ్యాధి గుర్తింపు",
        "timestamp": "5 గంటల క్రితం",
        "icon": "camera_alt",
        "status": "completed"
      },
      {
        "id": 3,
        "type": "text",
        "query": "వరి పంటకు ఎరువులు ఎప్పుడు వేయాలి?",
        "timestamp": "1 రోజు క్రితం",
        "icon": "keyboard",
        "status": "completed"
      },
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 1.w),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "ఇటీవలి కార్యకలాపాలు",
                style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: AppTheme.lightTheme.colorScheme.onSurface,
                ),
              ),
              TextButton(
                onPressed: () =>
                    Navigator.pushNamed(context, '/query-history-screen'),
                child: Text(
                  "అన్నీ చూడండి",
                  style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                    color: AppTheme.lightTheme.colorScheme.primary,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: 2.h),
        recentQueries.isEmpty
            ? _buildEmptyState()
            : ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: recentQueries.length,
                separatorBuilder: (context, index) => SizedBox(height: 2.h),
                itemBuilder: (context, index) {
                  final query = recentQueries[index];
                  return _buildActivityItem(query);
                },
              ),
      ],
    );
  }

  Widget _buildActivityItem(Map<String, dynamic> query) {
    Color iconColor;
    switch (query["type"] as String) {
      case "voice":
        iconColor = AppTheme.lightTheme.colorScheme.tertiary;
        break;
      case "image":
        iconColor = AppTheme.lightTheme.colorScheme.secondary;
        break;
      default:
        iconColor = AppTheme.lightTheme.colorScheme.primary;
    }

    return Container(
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.surface,
        borderRadius: BorderRadius.circular(2.w),
        border: Border.all(
          color: AppTheme.lightTheme.colorScheme.outline.withValues(alpha: 0.2),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 12.w,
            height: 12.w,
            decoration: BoxDecoration(
              color: iconColor.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(1.5.w),
            ),
            child: Center(
              child: CustomIconWidget(
                iconName: query["icon"] as String,
                color: iconColor,
                size: 6.w,
              ),
            ),
          ),
          SizedBox(width: 3.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  query["query"] as String,
                  style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                    color: AppTheme.lightTheme.colorScheme.onSurface,
                    fontWeight: FontWeight.w500,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: 0.5.h),
                Text(
                  query["timestamp"] as String,
                  style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                    color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
          CustomIconWidget(
            iconName: 'check_circle',
            color: AppTheme.cropHealthy,
            size: 5.w,
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(8.w),
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.surface,
        borderRadius: BorderRadius.circular(2.w),
        border: Border.all(
          color: AppTheme.lightTheme.colorScheme.outline.withValues(alpha: 0.2),
          width: 1,
        ),
      ),
      child: Column(
        children: [
          CustomIconWidget(
            iconName: 'history',
            color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
            size: 12.w,
          ),
          SizedBox(height: 2.h),
          Text(
            "ఇంకా ప్రశ్నలు లేవు",
            style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
              color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
            ),
          ),
          SizedBox(height: 1.h),
          Text(
            "మీ మొదటి ప్రశ్న అడగడానికి పైన ఉన్న కార్డులను ఉపయోగించండి",
            style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
              color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
