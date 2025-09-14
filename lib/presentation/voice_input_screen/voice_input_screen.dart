import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:record/record.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import './widgets/animated_microphone_widget.dart';
import './widgets/recording_timer_widget.dart';
import './widgets/transcription_display_widget.dart';
import './widgets/voice_response_widget.dart';
import './widgets/voice_waveform_widget.dart';

class VoiceInputScreen extends StatefulWidget {
  const VoiceInputScreen({Key? key}) : super(key: key);

  @override
  State<VoiceInputScreen> createState() => _VoiceInputScreenState();
}

class _VoiceInputScreenState extends State<VoiceInputScreen>
    with TickerProviderStateMixin {
  // Audio recording
  final AudioRecorder _audioRecorder = AudioRecorder();
  bool _isRecording = false;
  bool _isProcessing = false;
  String _recordingPath = '';

  // Timer and duration
  Timer? _recordingTimer;
  Duration _recordingDuration = Duration.zero;
  static const Duration _maxRecordingDuration = Duration(seconds: 60);

  // Transcription and response
  String _transcribedText = '';
  String _responseText = '';
  bool _isTranscribing = false;
  bool _isPlayingResponse = false;
  double _confidence = 0.0;

  // Audio level for waveform
  double _currentAudioLevel = 0.0;
  List<double> _waveformData = [];
  Timer? _audioLevelTimer;

  // Animation controllers
  late AnimationController _slideController;
  late Animation<Offset> _slideAnimation;

  // Mock data for demonstration
  final List<Map<String, dynamic>> _mockResponses = [
    {
      "query": "నా పంట ఆకులు పసుపు రంగులోకి మారుతున్నాయి",
      "response":
          "పంట ఆకులు పసుపు రంగులోకి మారడం సాధారణంగా నత్రజని లోపం వల్ల వస్తుంది. మీ పంటకు యూరియా ఎరువు వేయండి. ఎకరానికి 50 కిలోలు యూరియా వేసి నీరు పోయండి. 15 రోజుల తర్వాత మళ్లీ చూడండి.",
    },
    {
      "query": "వరి పంటలో కీటకాలు ఉన్నాయి",
      "response":
          "వరి పంటలో కీటకాల దాడి ఉంటే క్లోరోపైరిఫాస్ లేదా ఇమిడాక్లోప్రిడ్ మందు వాడండి. లీటర్ నీటికి 2 మిల్లీ మందు కలిపి స్ప్రే చేయండి. సాయంత్రం సమయంలో స్ప్రే చేయడం మంచిది.",
    },
    {
      "query": "మిరప పంట వృద్ధి లేదు",
      "response":
          "మిరప పంట వృద్ధికి ఫాస్పరస్ మరియు పొటాష్ ఎరువులు అవసరం. DAP ఎరువు మరియు MOP ఎరువు వేయండి. మట్టి తేమ ఎల్లప్పుడూ ఉండేలా చూసుకోండి. వారానికి రెండు సార్లు నీరు పోయండి.",
    },
  ];

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
    _requestPermissions();
  }

  void _initializeAnimations() {
    _slideController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 1),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _slideController,
      curve: Curves.easeInOut,
    ));
  }

  Future<void> _requestPermissions() async {
    await Permission.microphone.request();
  }

  Future<void> _startRecording() async {
    try {
      if (await _audioRecorder.hasPermission()) {
        // Get temporary directory for recording
        final directory = await getTemporaryDirectory();
        final timestamp = DateTime.now().millisecondsSinceEpoch;
        _recordingPath = '${directory.path}/recording_$timestamp.m4a';

        // Start recording
        await _audioRecorder.start(
          const RecordConfig(
            encoder: AudioEncoder.aacLc,
            bitRate: 128000,
            sampleRate: 44100,
          ),
          path: _recordingPath,
        );

        setState(() {
          _isRecording = true;
          _transcribedText = '';
          _responseText = '';
          _recordingDuration = Duration.zero;
          _confidence = 0.0;
        });

        // Start timer
        _startRecordingTimer();
        _startAudioLevelSimulation();

        // Provide haptic feedback
        HapticFeedback.mediumImpact();

        // Start transcription simulation
        _simulateTranscription();
      } else {
        _showErrorSnackBar('మైక్రోఫోన్ అనుమతి అవసరం');
      }
    } catch (e) {
      _showErrorSnackBar('రికార్డింగ్ ప్రారంభించడంలో లోపం');
    }
  }

  Future<void> _stopRecording() async {
    try {
      final path = await _audioRecorder.stop();

      setState(() {
        _isRecording = false;
        _isProcessing = true;
      });

      _stopRecordingTimer();
      _stopAudioLevelSimulation();

      // Provide haptic feedback
      HapticFeedback.lightImpact();

      // Process the recording
      await _processRecording(path);
    } catch (e) {
      setState(() {
        _isRecording = false;
        _isProcessing = false;
      });
      _showErrorSnackBar('రికార్డింగ్ ఆపడంలో లోపం');
    }
  }

  void _startRecordingTimer() {
    _recordingTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        _recordingDuration = Duration(seconds: timer.tick);
      });

      // Auto-stop at max duration
      if (_recordingDuration >= _maxRecordingDuration) {
        _stopRecording();
      }
    });
  }

  void _stopRecordingTimer() {
    _recordingTimer?.cancel();
    _recordingTimer = null;
  }

  void _startAudioLevelSimulation() {
    _audioLevelTimer =
        Timer.periodic(const Duration(milliseconds: 100), (timer) {
      if (_isRecording) {
        setState(() {
          // Simulate audio level changes
          _currentAudioLevel = (0.2 + (timer.tick % 10) * 0.08).clamp(0.0, 1.0);
        });
      }
    });
  }

  void _stopAudioLevelSimulation() {
    _audioLevelTimer?.cancel();
    _audioLevelTimer = null;
    setState(() {
      _currentAudioLevel = 0.0;
    });
  }

  void _simulateTranscription() {
    setState(() {
      _isTranscribing = true;
    });

    // Simulate real-time transcription
    Timer.periodic(const Duration(milliseconds: 500), (timer) {
      if (!_isRecording) {
        timer.cancel();
        setState(() {
          _isTranscribing = false;
        });
        return;
      }

      // Simulate progressive transcription
      final words = ['నా', 'పంట', 'ఆకులు', 'పసుపు', 'రంగులోకి', 'మారుతున్నాయి'];
      final currentWordIndex = (timer.tick - 1) % words.length;

      if (currentWordIndex < words.length) {
        setState(() {
          _transcribedText = words.sublist(0, currentWordIndex + 1).join(' ');
          _confidence = (0.6 + currentWordIndex * 0.1).clamp(0.0, 1.0);
        });
      }
    });
  }

  Future<void> _processRecording(String? recordingPath) async {
    if (recordingPath == null) {
      setState(() {
        _isProcessing = false;
      });
      return;
    }

    // Simulate AI processing delay
    await Future.delayed(const Duration(seconds: 2));

    // Get mock response based on transcribed text
    final response = _getMockResponse(_transcribedText);

    setState(() {
      _responseText = response;
      _isProcessing = false;
      _confidence = 0.85;
    });

    // Show response with animation
    _slideController.forward();
  }

  String _getMockResponse(String query) {
    // Simple keyword matching for mock responses
    final lowerQuery = query.toLowerCase();

    for (final mockResponse in _mockResponses) {
      final mockQuery = (mockResponse['query'] as String).toLowerCase();
      if (mockQuery.contains('పసుపు') && lowerQuery.contains('పసుపు')) {
        return mockResponse['response'] as String;
      } else if (mockQuery.contains('కీటక') && lowerQuery.contains('కీటక')) {
        return mockResponse['response'] as String;
      } else if (mockQuery.contains('వృద్ధి') &&
          lowerQuery.contains('వృద్ధి')) {
        return mockResponse['response'] as String;
      }
    }

    // Default response
    return "మీ ప్రశ్న గురించి మరింత వివరాలు ఇవ్వగలరా? మీ పంట రకం, ప్రాంతం, మరియు సమస్య గురించి స్పష్టంగా చెప్పండి. అప్పుడు మంచి సలహా ఇవ్వగలను.";
  }

  void _toggleRecording() {
    if (_isRecording) {
      _stopRecording();
    } else {
      _startRecording();
    }
  }

  void _playPauseResponse() {
    setState(() {
      _isPlayingResponse = !_isPlayingResponse;
    });

    if (_isPlayingResponse) {
      // Simulate TTS playback
      Timer(const Duration(seconds: 5), () {
        if (mounted) {
          setState(() {
            _isPlayingResponse = false;
          });
        }
      });
    }
  }

  void _shareResponse() {
    if (_responseText.isNotEmpty) {
      // Simulate sharing functionality
      _showSuccessSnackBar('సలహా షేర్ చేయబడింది');
    }
  }

  void _clearSession() {
    setState(() {
      _transcribedText = '';
      _responseText = '';
      _recordingDuration = Duration.zero;
      _confidence = 0.0;
      _isProcessing = false;
      _isPlayingResponse = false;
    });
    _slideController.reset();
  }

  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: AppTheme.lightTheme.colorScheme.error,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _showSuccessSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: AppTheme.lightTheme.colorScheme.primary,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  void dispose() {
    _recordingTimer?.cancel();
    _audioLevelTimer?.cancel();
    _slideController.dispose();
    _audioRecorder.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.lightTheme.scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: AppTheme.lightTheme.appBarTheme.backgroundColor,
        elevation: 0,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: CustomIconWidget(
            iconName: 'arrow_back',
            color: AppTheme.lightTheme.colorScheme.onSurface,
            size: 6.w,
          ),
        ),
        title: Text(
          'వాయిస్ ప్రశ్న',
          style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
            color: AppTheme.lightTheme.colorScheme.onSurface,
            fontWeight: FontWeight.w600,
          ),
        ),
        actions: [
          if (_transcribedText.isNotEmpty || _responseText.isNotEmpty)
            IconButton(
              onPressed: _clearSession,
              icon: CustomIconWidget(
                iconName: 'refresh',
                color: AppTheme.lightTheme.colorScheme.onSurface,
                size: 6.w,
              ),
            ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Main content area
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(vertical: 2.h),
                child: Column(
                  children: [
                    SizedBox(height: 4.h),

                    // Recording timer
                    RecordingTimerWidget(
                      recordingDuration: _recordingDuration,
                      isRecording: _isRecording,
                      maxDuration: _maxRecordingDuration,
                    ),

                    SizedBox(height: 4.h),

                    // Animated microphone
                    AnimatedMicrophoneWidget(
                      isRecording: _isRecording,
                      onTap: _isProcessing ? () {} : _toggleRecording,
                      audioLevel: _currentAudioLevel,
                    ),

                    SizedBox(height: 4.h),

                    // Waveform visualization
                    VoiceWaveformWidget(
                      isRecording: _isRecording,
                      audioLevel: _currentAudioLevel,
                      waveformData: _waveformData,
                    ),

                    SizedBox(height: 4.h),

                    // Processing indicator
                    if (_isProcessing)
                      Container(
                        padding: EdgeInsets.symmetric(
                            horizontal: 4.w, vertical: 2.h),
                        child: Column(
                          children: [
                            SizedBox(
                              width: 6.w,
                              height: 6.w,
                              child: CircularProgressIndicator(
                                strokeWidth: 3,
                                valueColor: AlwaysStoppedAnimation<Color>(
                                  AppTheme.lightTheme.colorScheme.primary,
                                ),
                              ),
                            ),
                            SizedBox(height: 2.h),
                            Text(
                              'విశ్లేషిస్తోంది...',
                              style: AppTheme.lightTheme.textTheme.bodyMedium
                                  ?.copyWith(
                                color: AppTheme.lightTheme.colorScheme.primary,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),

                    // Transcription display
                    if (!_isProcessing)
                      TranscriptionDisplayWidget(
                        transcribedText: _transcribedText,
                        isTranscribing: _isTranscribing,
                        confidence: _confidence,
                      ),

                    SizedBox(height: 3.h),

                    // Response display
                    if (_responseText.isNotEmpty)
                      SlideTransition(
                        position: _slideAnimation,
                        child: VoiceResponseWidget(
                          responseText: _responseText,
                          isPlaying: _isPlayingResponse,
                          onPlayPause: _playPauseResponse,
                          onShare: _shareResponse,
                        ),
                      ),
                  ],
                ),
              ),
            ),

            // Bottom instructions
            Container(
              padding: EdgeInsets.all(4.w),
              child: Column(
                children: [
                  if (!_isRecording && _transcribedText.isEmpty)
                    Text(
                      'మైక్రోఫోన్ నొక్కి మీ వ్యవసాయ ప్రశ్న అడగండి',
                      textAlign: TextAlign.center,
                      style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                        color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                  if (_isRecording)
                    Text(
                      'మాట్లాడుతూ ఉండండి... (${_maxRecordingDuration.inSeconds - _recordingDuration.inSeconds}s మిగిలింది)',
                      textAlign: TextAlign.center,
                      style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                        color: AppTheme.lightTheme.colorScheme.primary,
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
