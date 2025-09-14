import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import './widgets/action_card_widget.dart';
import './widgets/network_status_widget.dart';
import './widgets/recent_activity_widget.dart';
import './widgets/weather_widget.dart';

class MainDashboard extends StatefulWidget {
  const MainDashboard({Key? key}) : super(key: key);

  @override
  State<MainDashboard> createState() => _MainDashboardState();
}

class _MainDashboardState extends State<MainDashboard>
    with TickerProviderStateMixin {
  int _currentIndex = 0;
  bool _isVoiceReady = true;
  bool _isRefreshing = false;
  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;

  final List<Map<String, dynamic>> _tabItems = [
    {"label": "డాష్‌బోర్డ్", "icon": "dashboard", "route": "/main-dashboard"},
    {"label": "చరిత్ర", "icon": "history", "route": "/query-history-screen"},
    {"label": "ప్రొఫైల్", "icon": "person", "route": "/profile-screen"},
  ];

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
    _checkVoiceServices();
  }

  void _initializeAnimations() {
    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );
    _pulseAnimation = Tween<double>(
      begin: 1.0,
      end: 1.1,
    ).animate(CurvedAnimation(
      parent: _pulseController,
      curve: Curves.easeInOut,
    ));

    if (_isVoiceReady) {
      _pulseController.repeat(reverse: true);
    }
  }

  Future<void> _checkVoiceServices() async {
    // Simulate voice service check
    await Future.delayed(const Duration(milliseconds: 500));
    setState(() => _isVoiceReady = true);
    if (_isVoiceReady) {
      _pulseController.repeat(reverse: true);
    }
  }

  Future<void> _onRefresh() async {
    setState(() => _isRefreshing = true);
    HapticFeedback.lightImpact();

    // Simulate data refresh
    await Future.delayed(const Duration(seconds: 2));

    setState(() => _isRefreshing = false);
    HapticFeedback.selectionClick();
  }

  void _onTabTapped(int index) {
    if (index != _currentIndex) {
      HapticFeedback.selectionClick();
      setState(() => _currentIndex = index);

      if (index != 0) {
        Navigator.pushNamed(context, _tabItems[index]["route"] as String);
      }
    }
  }

  void _onActionCardTapped(String route) {
    HapticFeedback.mediumImpact();
    Navigator.pushNamed(context, route);
  }

  void _onHelpPressed() {
    HapticFeedback.lightImpact();
    _showHelpDialog();
  }

  void _showHelpDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            "సహాయం",
            style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "కిసాన్ మిత్రతో మీరు:",
                style: AppTheme.lightTheme.textTheme.bodyMedium,
              ),
              SizedBox(height: 2.h),
              _buildHelpItem("🎤", "వాయిస్ ద్వారా ప్రశ్నలు అడగవచ్చు"),
              _buildHelpItem("⌨️", "టెక్స్ట్ ద్వారా ప్రశ్నలు అడగవచ్చు"),
              _buildHelpItem("📷", "ఆకుల ఫోటోలు తీసి వ్యాధులను గుర్తించవచ్చు"),
              _buildHelpItem("📚", "మీ చరిత్రను చూడవచ్చు"),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(
                "అర్థమైంది",
                style: TextStyle(
                  color: AppTheme.lightTheme.colorScheme.primary,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildHelpItem(String emoji, String text) {
    return Padding(
      padding: EdgeInsets.only(bottom: 1.h),
      child: Row(
        children: [
          Text(emoji, style: TextStyle(fontSize: 16.sp)),
          SizedBox(width: 2.w),
          Expanded(
            child: Text(
              text,
              style: AppTheme.lightTheme.textTheme.bodySmall,
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.lightTheme.scaffoldBackgroundColor,
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: _onRefresh,
          color: AppTheme.lightTheme.colorScheme.primary,
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: EdgeInsets.all(4.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header Section
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "నమస్కారం రాజేష్ గారు! 🙏",
                          style: AppTheme.lightTheme.textTheme.headlineSmall
                              ?.copyWith(
                            fontWeight: FontWeight.w600,
                            color: AppTheme.lightTheme.colorScheme.onSurface,
                          ),
                        ),
                        SizedBox(height: 0.5.h),
                        Text(
                          "మీ వ్యవసాయ సహాయకుడు సిద్ధంగా ఉన్నాడు",
                          style: AppTheme.lightTheme.textTheme.bodyMedium
                              ?.copyWith(
                            color: AppTheme
                                .lightTheme.colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
                    GestureDetector(
                      onTap: _onHelpPressed,
                      child: Container(
                        width: 12.w,
                        height: 12.w,
                        decoration: BoxDecoration(
                          color: AppTheme.lightTheme.colorScheme.primary
                              .withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(2.w),
                        ),
                        child: Center(
                          child: CustomIconWidget(
                            iconName: 'help_outline',
                            color: AppTheme.lightTheme.colorScheme.primary,
                            size: 6.w,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),

                SizedBox(height: 3.h),

                // Network Status
                const NetworkStatusWidget(),
                SizedBox(height: 2.h),

                // Weather Widget
                const WeatherWidget(),

                SizedBox(height: 4.h),

                // Action Cards Section
                Text(
                  "మీరు ఏమి చేయాలనుకుంటున్నారు?",
                  style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: AppTheme.lightTheme.colorScheme.onSurface,
                  ),
                ),

                SizedBox(height: 3.h),

                // Voice Input Card with Animation
                AnimatedBuilder(
                  animation: _pulseAnimation,
                  builder: (context, child) {
                    return Transform.scale(
                      scale: _isVoiceReady ? _pulseAnimation.value : 1.0,
                      child: ActionCardWidget(
                        title: "వాయిస్ ఇన్‌పుట్",
                        subtitle: "మీ ప్రశ్నను మాట్లాడండి, మేము వింటాము",
                        iconName: "mic",
                        iconColor: AppTheme.lightTheme.colorScheme.tertiary,
                        isActive: _isVoiceReady,
                        onTap: () => _onActionCardTapped('/voice-input-screen'),
                      ),
                    );
                  },
                ),

                SizedBox(height: 3.h),

                // Text Input Card
                ActionCardWidget(
                  title: "టెక్స్ట్ ప్రశ్న",
                  subtitle: "మీ ప్రశ్నను టైప్ చేసి అడగండి",
                  iconName: "keyboard",
                  iconColor: AppTheme.lightTheme.colorScheme.primary,
                  onTap: () => _onActionCardTapped('/text-input-screen'),
                ),

                SizedBox(height: 3.h),

                // Image Analysis Card
                ActionCardWidget(
                  title: "ఆకుల విశ్లేషణ",
                  subtitle: "ఆకుల ఫోటో తీసి వ్యాధులను గుర్తించండి",
                  iconName: "camera_alt",
                  iconColor: AppTheme.lightTheme.colorScheme.secondary,
                  onTap: () => _onActionCardTapped('/image-analysis-screen'),
                ),

                SizedBox(height: 5.h),

                // Recent Activity Section
                const RecentActivityWidget(),

                SizedBox(height: 3.h),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: AppTheme.lightTheme.colorScheme.surface,
          boxShadow: [
            BoxShadow(
              color:
                  AppTheme.lightTheme.colorScheme.shadow.withValues(alpha: 0.1),
              blurRadius: 8,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: BottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: _onTabTapped,
          type: BottomNavigationBarType.fixed,
          backgroundColor: AppTheme.lightTheme.colorScheme.surface,
          selectedItemColor: AppTheme.lightTheme.colorScheme.primary,
          unselectedItemColor: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
          elevation: 0,
          items: _tabItems.map((item) {
            return BottomNavigationBarItem(
              icon: CustomIconWidget(
                iconName: item["icon"] as String,
                color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                size: 6.w,
              ),
              activeIcon: CustomIconWidget(
                iconName: item["icon"] as String,
                color: AppTheme.lightTheme.colorScheme.primary,
                size: 6.w,
              ),
              label: item["label"] as String,
            );
          }).toList(),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _onActionCardTapped('/voice-input-screen'),
        backgroundColor: AppTheme.lightTheme.colorScheme.tertiary,
        child: AnimatedBuilder(
          animation: _pulseAnimation,
          builder: (context, child) {
            return Transform.scale(
              scale: _isVoiceReady ? _pulseAnimation.value : 1.0,
              child: CustomIconWidget(
                iconName: 'mic',
                color: Colors.white,
                size: 7.w,
              ),
            );
          },
        ),
      ),
    );
  }
}
