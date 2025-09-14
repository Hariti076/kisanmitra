import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class NetworkStatusWidget extends StatefulWidget {
  const NetworkStatusWidget({Key? key}) : super(key: key);

  @override
  State<NetworkStatusWidget> createState() => _NetworkStatusWidgetState();
}

class _NetworkStatusWidgetState extends State<NetworkStatusWidget> {
  bool _isConnected = true;
  late Stream<ConnectivityResult> _connectivityStream;

  @override
  void initState() {
    super.initState();
    _initConnectivity();
    _connectivityStream = Connectivity().onConnectivityChanged;
    _connectivityStream.listen(_updateConnectionStatus);
  }

  Future<void> _initConnectivity() async {
    try {
      final ConnectivityResult result =
          await Connectivity().checkConnectivity();
      _updateConnectionStatus(result);
    } catch (e) {
      setState(() => _isConnected = false);
    }
  }

  void _updateConnectionStatus(ConnectivityResult result) {
    setState(() {
      _isConnected = result == ConnectivityResult.mobile ||
          result == ConnectivityResult.wifi ||
          result == ConnectivityResult.ethernet;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_isConnected) {
      return const SizedBox.shrink();
    }

    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.error.withValues(alpha: 0.1),
        border: Border.all(
          color: AppTheme.lightTheme.colorScheme.error.withValues(alpha: 0.3),
          width: 1,
        ),
        borderRadius: BorderRadius.circular(2.w),
      ),
      child: Row(
        children: [
          CustomIconWidget(
            iconName: 'wifi_off',
            color: AppTheme.lightTheme.colorScheme.error,
            size: 5.w,
          ),
          SizedBox(width: 3.w),
          Expanded(
            child: Text(
              "ఇంటర్నెట్ కనెక్షన్ లేదు • AI సేవలు అందుబాటులో లేవు",
              style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                color: AppTheme.lightTheme.colorScheme.error,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }
}