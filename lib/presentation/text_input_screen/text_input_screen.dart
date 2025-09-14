import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import './widgets/ai_response_widget.dart';
import './widgets/header_widget.dart';
import './widgets/suggestion_chips_widget.dart';
import './widgets/text_input_field_widget.dart';

class TextInputScreen extends StatefulWidget {
  const TextInputScreen({Key? key}) : super(key: key);

  @override
  State<TextInputScreen> createState() => _TextInputScreenState();
}

class _TextInputScreenState extends State<TextInputScreen> {
  final TextEditingController _textController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final FocusNode _textFocusNode = FocusNode();

  bool _isLoading = false;
  String _aiResponse = '';
  bool _hasSubmittedQuery = false;
  static const int _maxCharacters = 500;

  // Mock AI responses for different query types
  final Map<String, String> _mockResponses = {
    'పంట వ్యాధులు':
        '''పంట వ్యాధుల గురించి మీ ప్రశ్న చాలా ముఖ్యమైనది. సాధారణంగా కనిపించే వ్యాధులు:

🌱 **ఆకుల మచ్చలు**: ఫంగల్ ఇన్ఫెక్షన్ వల్ల వస్తాయి
🌱 **వేర్ల కుళ్ళడం**: అధిక నీరు వల్ల సంభవిస్తుంది
🌱 **కీటకాల దాడి**: సరైన పురుగుమందులు వాడాలి

**చికిత్స**: 
- సేంద్రీయ ఎరువులు వాడండి
- సరైన నీటిపారుదల చేయండి
- వ్యాధిగ్రస్త భాగాలను తొలగించండి

మరిన్ని వివరాలకు మీ స్థానిక వ్యవసాయ అధికారిని సంప్రదించండి.''',
    'ఎరువులు': '''ఎరువుల వాడకం గురించి మంచి ప్రశ్న అడిగారు:

🌾 **సేంద్రీయ ఎరువులు** (ఉత్తమం):
- గోబర ఎరువు
- కంపోస్ట్
- వర్మీ కంపోస్ట్

🌾 **రసాయన ఎరువులు**:
- యూరియా (నత్రజని కోసం)
- DAP (ఫాస్పరస్ కోసం)
- MOP (పొటాషియం కోసం)

**వాడకం**:
- మట్టి పరీక్ష చేయించుకోండి
- సరైన నిష్పత్తిలో వాడండి
- సమయానుకూలంగా వేయండి

మీ పంట రకాన్ని బట్టి ఎరువుల మోతాదు మారుతుంది.''',
    'నీటిపారుదల': '''నీటిపారుదల వ్యవస్థ గురించి మీ ప్రశ్న:

💧 **సరైన పద్ధతులు**:
- డ్రిప్ ఇరిగేషన్ (నీటి ఆదా)
- స్ప్రింక్లర్ సిస్టమ్
- ఫర్రో ఇరిగేషన్

💧 **సమయం**:
- తెల్లవారుజామున లేదా సాయంత్రం
- మధ్యాహ్నం నీరు వేయవద్దు
- మట్టి తేమను చూసి నిర్ణయించండి

💧 **లాభాలు**:
- నీటి వృధా తగ్గుతుంది
- పంట దిగుబడి పెరుగుతుంది
- కార్మిక వ్యయం తగ్గుతుంది

మీ పంట రకం మరియు మట్టి రకాన్ని బట్టి నీటి అవసరం మారుతుంది.''',
    'default': '''మీ వ్యవసాయ ప్రశ్నకు ధన్యవాదాలు. 

🌾 **సాధారణ సలహాలు**:
- మట్టి పరీక్ష చేయించుకోండి
- సేంద్రీయ ఎరువులను ప్రాధాన్యత ఇవ్వండి
- సరైన విత్తన రకాలను ఎంచుకోండి
- వాతావరణ సమాచారాన్ని తెలుసుకోండి

🌾 **సహాయం కోసం**:
- స్థానిక వ్యవసాయ అధికారిని సంప్రదించండి
- కృషి విజ్ఞాన కేంద్రాలను సంప్రదించండి
- అనుభవజ్ఞులైన రైతుల సలహా తీసుకోండి

మరిన్ని వివరాలకు మీ ప్రశ్నను మరింత స్పష్టంగా అడగండి.'''
  };

  @override
  void initState() {
    super.initState();
    _textController.addListener(_onTextChanged);
  }

  @override
  void dispose() {
    _textController.dispose();
    _scrollController.dispose();
    _textFocusNode.dispose();
    super.dispose();
  }

  void _onTextChanged() {
    setState(() {});
  }

  void _onSuggestionChipTap(String suggestion) {
    if (_textController.text.isEmpty) {
      _textController.text = suggestion;
    } else {
      _textController.text += ' $suggestion';
    }
    _textController.selection = TextSelection.fromPosition(
      TextPosition(offset: _textController.text.length),
    );
    setState(() {});
  }

  Future<void> _submitQuery() async {
    if (_textController.text.trim().isEmpty || _isLoading) return;

    setState(() {
      _isLoading = true;
      _hasSubmittedQuery = true;
    });

    // Hide keyboard
    FocusScope.of(context).unfocus();

    // Scroll to show response area
    Future.delayed(Duration(milliseconds: 100), () {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });

    // Simulate AI processing time
    await Future.delayed(Duration(seconds: 2));

    // Generate response based on query content
    String response = _generateMockResponse(_textController.text);

    setState(() {
      _isLoading = false;
      _aiResponse = response;
    });

    // Scroll to show complete response
    Future.delayed(Duration(milliseconds: 300), () {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: Duration(milliseconds: 500),
          curve: Curves.easeOut,
        );
      }
    });
  }

  String _generateMockResponse(String query) {
    String lowerQuery = query.toLowerCase();

    if (lowerQuery.contains('వ్యాధు') ||
        lowerQuery.contains('వ్యాధులు') ||
        lowerQuery.contains('రోగం')) {
      return _mockResponses['పంట వ్యాధులు']!;
    } else if (lowerQuery.contains('ఎరువు') ||
        lowerQuery.contains('ఎరువులు') ||
        lowerQuery.contains('మందు')) {
      return _mockResponses['ఎరువులు']!;
    } else if (lowerQuery.contains('నీరు') ||
        lowerQuery.contains('నీటిపారుదల') ||
        lowerQuery.contains('నీటి')) {
      return _mockResponses['నీటిపారుదల']!;
    } else {
      return _mockResponses['default']!;
    }
  }

  void _onVoicePressed() {
    // Voice input functionality would be implemented here
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('వాయిస్ ఇన్‌పుట్ త్వరలో అందుబాటులో ఉంటుంది'),
        duration: Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _onClosePressed() {
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.lightTheme.scaffoldBackgroundColor,
      body: Column(
        children: [
          HeaderWidget(
            onClosePressed: _onClosePressed,
            characterCount: _textController.text.length,
            maxCharacters: _maxCharacters,
          ),
          Expanded(
            child: SingleChildScrollView(
              controller: _scrollController,
              physics: BouncingScrollPhysics(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 2.h),

                  // Text input field
                  TextInputFieldWidget(
                    controller: _textController,
                    onChanged: (value) => _onTextChanged(),
                    onVoicePressed: _onVoicePressed,
                    isLoading: _isLoading,
                    maxCharacters: _maxCharacters,
                  ),

                  SizedBox(height: 2.h),

                  // Suggestion chips
                  SuggestionChipsWidget(
                    onChipTap: _onSuggestionChipTap,
                    isLoading: _isLoading,
                  ),

                  SizedBox(height: 2.h),

                  // AI Response
                  if (_hasSubmittedQuery)
                    AiResponseWidget(
                      response: _aiResponse,
                      isLoading: _isLoading,
                    ),

                  SizedBox(height: 10.h), // Extra space for keyboard
                ],
              ),
            ),
          ),
        ],
      ),

      // Send button
      floatingActionButton:
          _textController.text.trim().isNotEmpty && !_isLoading
              ? FloatingActionButton.extended(
                  onPressed: _submitQuery,
                  backgroundColor: AppTheme.lightTheme.colorScheme.primary,
                  foregroundColor: AppTheme.lightTheme.colorScheme.onPrimary,
                  icon: CustomIconWidget(
                    iconName: 'send',
                    color: AppTheme.lightTheme.colorScheme.onPrimary,
                    size: 20,
                  ),
                  label: Text(
                    'పంపండి',
                    style: AppTheme.lightTheme.textTheme.labelLarge?.copyWith(
                      color: AppTheme.lightTheme.colorScheme.onPrimary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                )
              : null,
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}