import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class AnalysisResultsWidget extends StatelessWidget {
  final Map<String, dynamic> analysisResult;
  final VoidCallback onNewAnalysis;
  final VoidCallback onShare;

  const AnalysisResultsWidget({
    Key? key,
    required this.analysisResult,
    required this.onNewAnalysis,
    required this.onShare,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      child: Column(
        children: [
          // Header
          Container(
            padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
            decoration: BoxDecoration(
              color: AppTheme.lightTheme.colorScheme.surface,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.05),
                  blurRadius: 4,
                  offset: Offset(0, 2),
                ),
              ],
            ),
            child: Row(
              children: [
                GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: CustomIconWidget(
                    iconName: 'arrow_back',
                    color: AppTheme.lightTheme.colorScheme.onSurface,
                    size: 6.w,
                  ),
                ),
                SizedBox(width: 4.w),
                Expanded(
                  child: Text(
                    'విశ్లేషణ ఫలితాలు',
                    style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: onShare,
                  child: CustomIconWidget(
                    iconName: 'share',
                    color: AppTheme.lightTheme.primaryColor,
                    size: 6.w,
                  ),
                ),
              ],
            ),
          ),

          // Results content
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.all(4.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Disease identification card
                  _buildDiseaseCard(),

                  SizedBox(height: 3.h),

                  // Treatment recommendations
                  _buildTreatmentCard(),

                  SizedBox(height: 3.h),

                  // Prevention tips
                  _buildPreventionCard(),

                  SizedBox(height: 3.h),

                  // Additional information
                  _buildAdditionalInfoCard(),

                  SizedBox(height: 4.h),
                ],
              ),
            ),
          ),

          // Bottom action buttons
          Container(
            padding: EdgeInsets.all(4.w),
            decoration: BoxDecoration(
              color: AppTheme.lightTheme.colorScheme.surface,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.05),
                  blurRadius: 4,
                  offset: Offset(0, -2),
                ),
              ],
            ),
            child: Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: onNewAnalysis,
                    style: OutlinedButton.styleFrom(
                      padding: EdgeInsets.symmetric(vertical: 2.h),
                      side: BorderSide(
                        color: AppTheme.lightTheme.primaryColor,
                        width: 1.5,
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CustomIconWidget(
                          iconName: 'add_a_photo',
                          color: AppTheme.lightTheme.primaryColor,
                          size: 5.w,
                        ),
                        SizedBox(width: 2.w),
                        Text('కొత్త విశ్లేషణ'),
                      ],
                    ),
                  ),
                ),
                SizedBox(width: 4.w),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () =>
                        Navigator.pushNamed(context, '/query-history-screen'),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CustomIconWidget(
                          iconName: 'history',
                          color: Colors.white,
                          size: 5.w,
                        ),
                        SizedBox(width: 2.w),
                        Text('చరిత్ర చూడండి'),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDiseaseCard() {
    final disease = analysisResult['disease'] as String? ?? 'గుర్తించలేకపోయాము';
    final confidence = analysisResult['confidence'] as double? ?? 0.0;
    final severity = analysisResult['severity'] as String? ?? 'మధ్యమ';

    Color severityColor = AppTheme.lightTheme.primaryColor;
    if (severity == 'తీవ్రమైన') {
      severityColor = AppTheme.errorLight;
    } else if (severity == 'తేలికైన') {
      severityColor = AppTheme.successLight;
    } else if (severity == 'మధ్యమ') {
      severityColor = AppTheme.warningLight;
    }

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: EdgeInsets.all(4.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: EdgeInsets.all(2.w),
                  decoration: BoxDecoration(
                    color: severityColor.withValues(alpha: 0.1),
                    shape: BoxShape.circle,
                  ),
                  child: CustomIconWidget(
                    iconName: 'local_hospital',
                    color: severityColor,
                    size: 6.w,
                  ),
                ),
                SizedBox(width: 3.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'వ్యాధి గుర్తింపు',
                        style:
                            AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Text(
                        disease,
                        style:
                            AppTheme.lightTheme.textTheme.bodyLarge?.copyWith(
                          color: severityColor,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),

            SizedBox(height: 3.h),

            // Confidence and severity
            Row(
              children: [
                Expanded(
                  child: Container(
                    padding: EdgeInsets.all(3.w),
                    decoration: BoxDecoration(
                      color: AppTheme.lightTheme.primaryColor
                          .withValues(alpha: 0.05),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Column(
                      children: [
                        Text(
                          'విశ్వసనీయత',
                          style: AppTheme.lightTheme.textTheme.bodySmall,
                        ),
                        SizedBox(height: 0.5.h),
                        Text(
                          '${(confidence * 100).toInt()}%',
                          style: AppTheme.lightTheme.textTheme.titleLarge
                              ?.copyWith(
                            color: AppTheme.lightTheme.primaryColor,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(width: 3.w),
                Expanded(
                  child: Container(
                    padding: EdgeInsets.all(3.w),
                    decoration: BoxDecoration(
                      color: severityColor.withValues(alpha: 0.05),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Column(
                      children: [
                        Text(
                          'తీవ్రత',
                          style: AppTheme.lightTheme.textTheme.bodySmall,
                        ),
                        SizedBox(height: 0.5.h),
                        Text(
                          severity,
                          style: AppTheme.lightTheme.textTheme.titleMedium
                              ?.copyWith(
                            color: severityColor,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTreatmentCard() {
    final treatments =
        (analysisResult['treatments'] as List?)?.cast<String>() ??
            [
              'సేంద్రీయ కీటకనాశకాలు వాడండి',
              'నీటిపారుదల తగ్గించండి',
              'వ్యాధిగ్రస్త ఆకులను తొలగించండి',
            ];

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: EdgeInsets.all(4.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CustomIconWidget(
                  iconName: 'medical_services',
                  color: AppTheme.lightTheme.primaryColor,
                  size: 6.w,
                ),
                SizedBox(width: 3.w),
                Text(
                  'చికిత్స సిఫార్సులు',
                  style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            SizedBox(height: 2.h),
            ...treatments
                .map((treatment) => Padding(
                      padding: EdgeInsets.only(bottom: 1.5.h),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            margin: EdgeInsets.only(top: 0.5.h),
                            width: 1.5.w,
                            height: 1.5.w,
                            decoration: BoxDecoration(
                              color: AppTheme.lightTheme.primaryColor,
                              shape: BoxShape.circle,
                            ),
                          ),
                          SizedBox(width: 3.w),
                          Expanded(
                            child: Text(
                              treatment,
                              style: AppTheme.lightTheme.textTheme.bodyMedium,
                            ),
                          ),
                        ],
                      ),
                    ))
                .toList(),
          ],
        ),
      ),
    );
  }

  Widget _buildPreventionCard() {
    final preventions =
        (analysisResult['preventions'] as List?)?.cast<String>() ??
            [
              'మంచి వెంటిలేషన్ ఉంచండి',
              'అధిక తేమను నివారించండి',
              'క్రమం తప్పకుండా తనిఖీ చేయండి',
            ];

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: EdgeInsets.all(4.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CustomIconWidget(
                  iconName: 'shield',
                  color: AppTheme.successLight,
                  size: 6.w,
                ),
                SizedBox(width: 3.w),
                Text(
                  'నివారణ చర్యలు',
                  style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            SizedBox(height: 2.h),
            ...preventions
                .map((prevention) => Padding(
                      padding: EdgeInsets.only(bottom: 1.5.h),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            margin: EdgeInsets.only(top: 0.5.h),
                            width: 1.5.w,
                            height: 1.5.w,
                            decoration: BoxDecoration(
                              color: AppTheme.successLight,
                              shape: BoxShape.circle,
                            ),
                          ),
                          SizedBox(width: 3.w),
                          Expanded(
                            child: Text(
                              prevention,
                              style: AppTheme.lightTheme.textTheme.bodyMedium,
                            ),
                          ),
                        ],
                      ),
                    ))
                .toList(),
          ],
        ),
      ),
    );
  }

  Widget _buildAdditionalInfoCard() {
    final additionalInfo = analysisResult['additionalInfo'] as String? ??
        'మరింత సహాయం కోసం స్థానిక వ్యవసాయ అధికారిని సంప్రదించండి. నియమిత పరిశీలన మరియు సరైన పోషకాహారం మీ పంటల ఆరోగ్యానికి చాలా ముఖ్యం.';

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: EdgeInsets.all(4.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CustomIconWidget(
                  iconName: 'info',
                  color: AppTheme.lightTheme.colorScheme.tertiary,
                  size: 6.w,
                ),
                SizedBox(width: 3.w),
                Text(
                  'అదనపు సమాచారం',
                  style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            SizedBox(height: 2.h),
            Text(
              additionalInfo,
              style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                height: 1.5,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
