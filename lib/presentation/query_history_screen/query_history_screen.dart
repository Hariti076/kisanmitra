import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import './widgets/empty_history_state.dart';
import './widgets/filter_bottom_sheet.dart';
import './widgets/history_skeleton_loader.dart';
import './widgets/query_history_card.dart';
import './widgets/search_filter_bar.dart';

class QueryHistoryScreen extends StatefulWidget {
  const QueryHistoryScreen({Key? key}) : super(key: key);

  @override
  State<QueryHistoryScreen> createState() => _QueryHistoryScreenState();
}

class _QueryHistoryScreenState extends State<QueryHistoryScreen> {
  final TextEditingController _searchController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  List<Map<String, dynamic>> _allQueries = [];
  List<Map<String, dynamic>> _filteredQueries = [];
  Map<String, dynamic> _currentFilters = {
    'inputType': 'all',
    'topic': 'అన్నీ',
    'dateRange': null,
  };

  bool _isLoading = true;
  bool _isLoadingMore = false;
  bool _hasMoreData = true;
  int _currentPage = 1;
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _loadMockData();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _searchController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _loadMockData() {
    // Mock query history data
    final List<Map<String, dynamic>> mockQueries = [
      {
        "id": 1,
        "inputType": "text",
        "query":
            "నా పత్తి మొక్కల ఆకులపై తెల్లని మచ్చలు కనిపిస్తున్నాయి. ఇది ఏ వ్యాధి?",
        "response":
            "మీ పత్తి మొక్కలపై కనిపిస్తున్న తెల్లని మచ్చలు పౌడరీ మిల్డ్యూ వ్యాధికి సంకేతం కావచ్చు. ఇది ఒక ఫంగల్ వ్యాధి. చికిత్స కోసం కార్బెండాజిమ్ లేదా ప్రోపికోనజోల్ స్ప్రే చేయండి. వారానికి రెండుసార్లు స్ప్రే చేయండి.",
        "timestamp": DateTime.now().subtract(const Duration(hours: 2)),
        "topic": "వ్యాధులు",
        "isFavorite": true,
      },
      {
        "id": 2,
        "inputType": "voice",
        "query": "వరిలో గోధుమ రంగు మచ్చలు వస్తున్నాయి",
        "response":
            "వరిలో గోధుమ రంగు మచ్చలు బ్లాస్ట్ వ్యాధికి సంకేతం. ఇది మాగ్నపోర్థే గ్రిసియా అనే ఫంగస్ వల్ల వస్తుంది. ట్రైసైక్లాజోల్ లేదా కార్బెండాజిమ్ + మాన్కోజెబ్ కలిపి స్ప్రే చేయండి. నత్రజని ఎరువులు తగ్గించండి.",
        "timestamp": DateTime.now().subtract(const Duration(hours: 5)),
        "topic": "వ్యాధులు",
        "isFavorite": false,
      },
      {
        "id": 3,
        "inputType": "image",
        "query": "టమాటో ఆకుల చిత్రం - వ్యాధి గుర్తింపు",
        "response":
            "మీ టమాటో మొక్కలో ఎర్లీ బ్లైట్ వ్యాధి కనిపిస్తుంది. ఆకులపై గోధుమ రంగు వృత్తాకార మచ్చలు దీని లక్షణం. మాన్కోజెబ్ లేదా కాపర్ ఆక్సిక్లోరైడ్ స్ప్రే చేయండి. వారానికి రెండుసార్లు 15 రోజుల పాటు చేయండి.",
        "timestamp": DateTime.now().subtract(const Duration(days: 1)),
        "topic": "వ్యాధులు",
        "isFavorite": false,
      },
      {
        "id": 4,
        "inputType": "text",
        "query": "మిర్చిలో కీటకాల దాడి ఎలా నియంత్రించాలి?",
        "response":
            "మిర్చిలో థ్రిప్స్, అఫిడ్స్, వైట్ ఫ్లై వంటి కీటకాలు దాడి చేస్తాయి. ఇమిడాక్లోప్రిడ్ లేదా థియామెథాక్సామ్ స్ప్రే చేయండి. నీమ్ ఆయిల్ కూడా ఉపయోగించవచ్చు. పసుపు స్టిక్కీ ట్రాప్స్ వేయండి.",
        "timestamp": DateTime.now().subtract(const Duration(days: 2)),
        "topic": "కీటకాలు",
        "isFavorite": true,
      },
      {
        "id": 5,
        "inputType": "voice",
        "query": "వరి పంటకు ఎంత నీరు అవసరం?",
        "response":
            "వరి పంటకు వేర్వేరు దశలలో వేర్వేరు మొత్తంలో నీరు అవసరం. నాట్లు వేసిన తర్వాత 2-3 సెం.మీ నీరు ఉంచండి. టిల్లరింగ్ దశలో 5 సెం.మీ నీరు అవసరం. పుష్పించే సమయంలో 10 సెం.మీ నీరు ఉంచండి.",
        "timestamp": DateTime.now().subtract(const Duration(days: 3)),
        "topic": "నీటిపారుదల",
        "isFavorite": false,
      },
      {
        "id": 6,
        "inputType": "text",
        "query": "సూర్యకాంతి పువ్వుల విత్తనాలు ఎప్పుడు వేయాలి?",
        "response":
            "సూర్యకాంతి పువ్వుల విత్తనాలు జూన్-జూలై మాసాల్లో వేయాలి. ఖరీఫ్ సీజన్‌లో వేయడం మంచిది. ఎకరానికి 2-3 కిలోలు విత్తనాలు అవసరం. వరుసల మధ్య 45 సెం.మీ దూరం ఉంచండి.",
        "timestamp": DateTime.now().subtract(const Duration(days: 4)),
        "topic": "విత్తనాలు",
        "isFavorite": false,
      },
      {
        "id": 7,
        "inputType": "image",
        "query": "మొక్కజొన్న ఆకుల రంగు మార్పు",
        "response":
            "మీ మొక్కజొన్న మొక్కలలో నత్రజని లోపం కనిపిస్తుంది. ఆకులు పసుపు రంగులోకి మారడం దీని లక్షణం. యూరియా ఎరువు వేయండి లేదా అమ్మోనియం సల్ఫేట్ వాడండి. ఎకరానికి 50 కిలోలు యూరియా వేయండి.",
        "timestamp": DateTime.now().subtract(const Duration(days: 5)),
        "topic": "ఎరువులు",
        "isFavorite": true,
      },
      {
        "id": 8,
        "inputType": "voice",
        "query": "వాతావరణం ఎలా ఉంటే పంట మంచిది?",
        "response":
            "మంచి పంట కోసం సమతుల్య వాతావరణం అవసరం. తగినంత వర్షపాతం (75-150 సెం.మీ), మధ్యస్థ ఉష్ణోగ్రత (20-30°C), తేమ 60-70% ఉండాలి. గాలి వేగం తక్కువగా ఉండాలి. అధిక వర్షాలు లేదా కరువు హానికరం.",
        "timestamp": DateTime.now().subtract(const Duration(days: 6)),
        "topic": "వాతావరణం",
        "isFavorite": false,
      },
    ];

    setState(() {
      _allQueries = mockQueries;
      _filteredQueries = List.from(_allQueries);
      _isLoading = false;
    });
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      if (!_isLoadingMore && _hasMoreData) {
        _loadMoreData();
      }
    }
  }

  void _loadMoreData() {
    if (!_hasMoreData) return;

    setState(() {
      _isLoadingMore = true;
    });

    // Simulate loading more data
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) {
        setState(() {
          _isLoadingMore = false;
          _currentPage++;
          // Simulate no more data after page 3
          if (_currentPage > 3) {
            _hasMoreData = false;
          }
        });
      }
    });
  }

  void _onSearchChanged(String query) {
    setState(() {
      _searchQuery = query;
      _applyFilters();
    });
  }

  void _applyFilters() {
    List<Map<String, dynamic>> filtered = List.from(_allQueries);

    // Apply search filter
    if (_searchQuery.isNotEmpty) {
      filtered = filtered.where((query) {
        final queryText = (query['query'] as String).toLowerCase();
        final responseText = (query['response'] as String).toLowerCase();
        final searchLower = _searchQuery.toLowerCase();
        return queryText.contains(searchLower) ||
            responseText.contains(searchLower);
      }).toList();
    }

    // Apply input type filter
    if (_currentFilters['inputType'] != 'all') {
      filtered = filtered.where((query) {
        return query['inputType'] == _currentFilters['inputType'];
      }).toList();
    }

    // Apply topic filter
    if (_currentFilters['topic'] != 'అన్నీ') {
      filtered = filtered.where((query) {
        return query['topic'] == _currentFilters['topic'];
      }).toList();
    }

    // Apply date range filter
    if (_currentFilters['dateRange'] != null) {
      final DateTimeRange dateRange =
          _currentFilters['dateRange'] as DateTimeRange;
      filtered = filtered.where((query) {
        final queryDate = query['timestamp'] as DateTime;
        return queryDate
                .isAfter(dateRange.start.subtract(const Duration(days: 1))) &&
            queryDate.isBefore(dateRange.end.add(const Duration(days: 1)));
      }).toList();
    }

    setState(() {
      _filteredQueries = filtered;
    });
  }

  void _showFilterBottomSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => FilterBottomSheet(
        currentFilters: _currentFilters,
        onApplyFilters: (filters) {
          setState(() {
            _currentFilters = filters;
            _applyFilters();
          });
        },
      ),
    );
  }

  void _shareQuery(Map<String, dynamic> queryData) {
    // Implement share functionality
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'ప్రశ్న షేర్ చేయబడింది',
          style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
            color: Colors.white,
          ),
        ),
        backgroundColor: AppTheme.lightTheme.colorScheme.primary,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
    );
  }

  void _deleteQuery(Map<String, dynamic> queryData) {
    setState(() {
      _allQueries.removeWhere((query) => query['id'] == queryData['id']);
      _applyFilters();
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'ప్రశ్న తొలగించబడింది',
          style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
            color: Colors.white,
          ),
        ),
        backgroundColor: AppTheme.lightTheme.colorScheme.error,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        action: SnackBarAction(
          label: 'రద్దు చేయండి',
          textColor: Colors.white,
          onPressed: () {
            setState(() {
              _allQueries.add(queryData);
              _applyFilters();
            });
          },
        ),
      ),
    );
  }

  void _toggleFavorite(Map<String, dynamic> queryData) {
    setState(() {
      final index =
          _allQueries.indexWhere((query) => query['id'] == queryData['id']);
      if (index != -1) {
        _allQueries[index]['isFavorite'] =
            !(_allQueries[index]['isFavorite'] as bool);
        _applyFilters();
      }
    });

    final isFavorite = queryData['isFavorite'] as bool;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          isFavorite
              ? 'ఇష్టమైనవి నుండి తొలగించబడింది'
              : 'ఇష్టమైనవిలో జోడించబడింది',
          style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
            color: Colors.white,
          ),
        ),
        backgroundColor: AppTheme.lightTheme.colorScheme.secondary,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
    );
  }

  void _viewQueryDetails(Map<String, dynamic> queryData) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => _buildQueryDetailSheet(queryData),
    );
  }

  Widget _buildQueryDetailSheet(Map<String, dynamic> queryData) {
    return Container(
      height: 80.h,
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.all(4.w),
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  color: AppTheme.lightTheme.dividerColor,
                  width: 1,
                ),
              ),
            ),
            child: Row(
              children: [
                Text(
                  'ప్రశ్న వివరాలు',
                  style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const Spacer(),
                GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: CustomIconWidget(
                    iconName: 'close',
                    color: AppTheme.lightTheme.colorScheme.onSurface,
                    size: 24,
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.all(4.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'ప్రశ్న:',
                    style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(height: 1.h),
                  Text(
                    queryData['query'] as String,
                    style: AppTheme.lightTheme.textTheme.bodyMedium,
                  ),
                  SizedBox(height: 3.h),
                  Text(
                    'జవాబు:',
                    style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(height: 1.h),
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.all(4.w),
                    decoration: BoxDecoration(
                      color: AppTheme.lightTheme.colorScheme.primary
                          .withValues(alpha: 0.05),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: AppTheme.lightTheme.colorScheme.primary
                            .withValues(alpha: 0.2),
                        width: 1,
                      ),
                    ),
                    child: Text(
                      queryData['response'] as String,
                      style: AppTheme.lightTheme.textTheme.bodyMedium,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _refreshData() async {
    setState(() {
      _isLoading = true;
    });

    // Simulate refresh delay
    await Future.delayed(const Duration(seconds: 1));

    _loadMockData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.lightTheme.scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text(
          'ప్రశ్న చరిత్ర',
          style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
        elevation: 0,
        backgroundColor: AppTheme.lightTheme.colorScheme.surface,
        leading: GestureDetector(
          onTap: () => Navigator.pop(context),
          child: Padding(
            padding: EdgeInsets.all(3.w),
            child: CustomIconWidget(
              iconName: 'arrow_back',
              color: AppTheme.lightTheme.colorScheme.onSurface,
              size: 24,
            ),
          ),
        ),
        actions: [
          GestureDetector(
            onTap: () {
              // Export functionality
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    'చరిత్ర ఎక్స్‌పోర్ట్ చేయబడింది',
                    style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                      color: Colors.white,
                    ),
                  ),
                  backgroundColor: AppTheme.lightTheme.colorScheme.secondary,
                  behavior: SnackBarBehavior.floating,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8)),
                ),
              );
            },
            child: Padding(
              padding: EdgeInsets.all(3.w),
              child: CustomIconWidget(
                iconName: 'download',
                color: AppTheme.lightTheme.colorScheme.onSurface,
                size: 24,
              ),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          SearchFilterBar(
            searchController: _searchController,
            onFilterTap: _showFilterBottomSheet,
            onSearchChanged: _onSearchChanged,
          ),
          Expanded(
            child: _isLoading
                ? const HistorySkeletonLoader()
                : _filteredQueries.isEmpty
                    ? const EmptyHistoryState()
                    : RefreshIndicator(
                        onRefresh: _refreshData,
                        color: AppTheme.lightTheme.colorScheme.primary,
                        child: ListView.builder(
                          controller: _scrollController,
                          itemCount: _filteredQueries.length +
                              (_isLoadingMore ? 1 : 0),
                          padding: EdgeInsets.symmetric(vertical: 1.h),
                          itemBuilder: (context, index) {
                            if (index == _filteredQueries.length) {
                              return Padding(
                                padding: EdgeInsets.all(4.w),
                                child: Center(
                                  child: CircularProgressIndicator(
                                    color:
                                        AppTheme.lightTheme.colorScheme.primary,
                                  ),
                                ),
                              );
                            }

                            final queryData = _filteredQueries[index];
                            return QueryHistoryCard(
                              queryData: queryData,
                              onTap: () => _viewQueryDetails(queryData),
                              onShare: () => _shareQuery(queryData),
                              onDelete: () => _deleteQuery(queryData),
                              onFavorite: () => _toggleFavorite(queryData),
                            );
                          },
                        ),
                      ),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: 3, // History tab is active
        selectedItemColor: AppTheme.lightTheme.colorScheme.primary,
        unselectedItemColor: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
        backgroundColor: AppTheme.lightTheme.colorScheme.surface,
        elevation: 8,
        items: [
          BottomNavigationBarItem(
            icon: CustomIconWidget(
              iconName: 'home',
              color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
              size: 24,
            ),
            activeIcon: CustomIconWidget(
              iconName: 'home',
              color: AppTheme.lightTheme.colorScheme.primary,
              size: 24,
            ),
            label: 'హోమ్',
          ),
          BottomNavigationBarItem(
            icon: CustomIconWidget(
              iconName: 'keyboard',
              color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
              size: 24,
            ),
            activeIcon: CustomIconWidget(
              iconName: 'keyboard',
              color: AppTheme.lightTheme.colorScheme.primary,
              size: 24,
            ),
            label: 'టెక్స్ట్',
          ),
          BottomNavigationBarItem(
            icon: CustomIconWidget(
              iconName: 'mic',
              color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
              size: 24,
            ),
            activeIcon: CustomIconWidget(
              iconName: 'mic',
              color: AppTheme.lightTheme.colorScheme.primary,
              size: 24,
            ),
            label: 'వాయిస్',
          ),
          BottomNavigationBarItem(
            icon: CustomIconWidget(
              iconName: 'history',
              color: AppTheme.lightTheme.colorScheme.primary,
              size: 24,
            ),
            activeIcon: CustomIconWidget(
              iconName: 'history',
              color: AppTheme.lightTheme.colorScheme.primary,
              size: 24,
            ),
            label: 'చరిత్ర',
          ),
          BottomNavigationBarItem(
            icon: CustomIconWidget(
              iconName: 'camera_alt',
              color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
              size: 24,
            ),
            activeIcon: CustomIconWidget(
              iconName: 'camera_alt',
              color: AppTheme.lightTheme.colorScheme.primary,
              size: 24,
            ),
            label: 'చిత్రం',
          ),
        ],
        onTap: (index) {
          switch (index) {
            case 0:
              Navigator.pushNamed(context, '/main-dashboard');
              break;
            case 1:
              Navigator.pushNamed(context, '/text-input-screen');
              break;
            case 2:
              Navigator.pushNamed(context, '/voice-input-screen');
              break;
            case 3:
              // Already on history screen
              break;
            case 4:
              Navigator.pushNamed(context, '/image-analysis-screen');
              break;
          }
        },
      ),
    );
  }
}
