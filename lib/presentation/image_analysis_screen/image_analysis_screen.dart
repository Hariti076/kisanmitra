
import 'package:camera/camera.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import './widgets/analysis_progress_widget.dart';
import './widgets/analysis_results_widget.dart';
import './widgets/camera_preview_widget.dart';
import './widgets/image_preview_widget.dart';

class ImageAnalysisScreen extends StatefulWidget {
  const ImageAnalysisScreen({Key? key}) : super(key: key);

  @override
  State<ImageAnalysisScreen> createState() => _ImageAnalysisScreenState();
}

class _ImageAnalysisScreenState extends State<ImageAnalysisScreen> {
  // Camera related variables
  CameraController? _cameraController;
  List<CameraDescription> _cameras = [];
  bool _isCameraInitialized = false;
  bool _isFlashOn = false;

  // Image and analysis related variables
  XFile? _capturedImage;
  bool _isAnalyzing = false;
  Map<String, dynamic>? _analysisResult;

  // Screen state management
  AnalysisScreenState _currentState = AnalysisScreenState.camera;

  // Image picker instance
  final ImagePicker _imagePicker = ImagePicker();

  @override
  void initState() {
    super.initState();
    _initializeCamera();
  }

  @override
  void dispose() {
    _cameraController?.dispose();
    super.dispose();
  }

  // Initialize camera with permission handling
  Future<void> _initializeCamera() async {
    try {
      // Request camera permission
      if (!await _requestCameraPermission()) {
        _showPermissionDeniedDialog();
        return;
      }

      // Get available cameras
      _cameras = await availableCameras();
      if (_cameras.isEmpty) {
        _showNoCameraDialog();
        return;
      }

      // Select appropriate camera (rear for mobile, front for web)
      final camera = kIsWeb
          ? _cameras.firstWhere(
              (c) => c.lensDirection == CameraLensDirection.front,
              orElse: () => _cameras.first)
          : _cameras.firstWhere(
              (c) => c.lensDirection == CameraLensDirection.back,
              orElse: () => _cameras.first);

      // Initialize camera controller
      _cameraController = CameraController(
        camera,
        kIsWeb ? ResolutionPreset.medium : ResolutionPreset.high,
      );

      await _cameraController!.initialize();

      // Apply camera settings (skip unsupported features on web)
      await _applyCameraSettings();

      if (mounted) {
        setState(() {
          _isCameraInitialized = true;
        });
      }
    } catch (e) {
      debugPrint('Camera initialization error: $e');
      if (mounted) {
        _showCameraErrorDialog();
      }
    }
  }

  // Apply platform-specific camera settings
  Future<void> _applyCameraSettings() async {
    if (_cameraController == null) return;

    try {
      // Set focus mode (works on both platforms)
      await _cameraController!.setFocusMode(FocusMode.auto);

      // Set flash mode (skip on web as it's not supported)
      if (!kIsWeb) {
        await _cameraController!.setFlashMode(FlashMode.auto);
      }
    } catch (e) {
      // Silently handle unsupported features
      debugPrint('Camera settings error: $e');
    }
  }

  // Request camera permission
  Future<bool> _requestCameraPermission() async {
    if (kIsWeb) return true; // Browser handles permissions

    final status = await Permission.camera.request();
    return status.isGranted;
  }

  // Capture photo from camera
  Future<void> _capturePhoto() async {
    if (_cameraController == null || !_cameraController!.value.isInitialized) {
      return;
    }

    try {
      final XFile photo = await _cameraController!.takePicture();
      setState(() {
        _capturedImage = photo;
        _currentState = AnalysisScreenState.preview;
      });
    } catch (e) {
      debugPrint('Photo capture error: $e');
      _showErrorSnackBar('ఫోటో తీయడంలో లోపం జరిగింది');
    }
  }

  // Select image from gallery
  Future<void> _selectFromGallery() async {
    try {
      final XFile? image = await _imagePicker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 85,
      );

      if (image != null) {
        setState(() {
          _capturedImage = image;
          _currentState = AnalysisScreenState.preview;
        });
      }
    } catch (e) {
      debugPrint('Gallery selection error: $e');
      _showErrorSnackBar('గ్యాలరీ నుండి ఫోటో ఎంచుకోవడంలో లోపం');
    }
  }

  // Toggle flash (mobile only)
  Future<void> _toggleFlash() async {
    if (kIsWeb || _cameraController == null) return;

    try {
      final newFlashMode = _isFlashOn ? FlashMode.off : FlashMode.torch;
      await _cameraController!.setFlashMode(newFlashMode);
      setState(() {
        _isFlashOn = !_isFlashOn;
      });
    } catch (e) {
      debugPrint('Flash toggle error: $e');
    }
  }

  // Start image analysis
  Future<void> _startAnalysis() async {
    if (_capturedImage == null) return;

    setState(() {
      _isAnalyzing = true;
      _currentState = AnalysisScreenState.analyzing;
    });

    try {
      // Simulate AI analysis with realistic delay
      await Future.delayed(Duration(seconds: 3));

      // Generate mock analysis result
      final result = _generateMockAnalysisResult();

      setState(() {
        _analysisResult = result;
        _isAnalyzing = false;
        _currentState = AnalysisScreenState.results;
      });
    } catch (e) {
      debugPrint('Analysis error: $e');
      setState(() {
        _isAnalyzing = false;
        _currentState = AnalysisScreenState.preview;
      });
      _showErrorSnackBar('విశ్లేషణలో లోపం జరిగింది');
    }
  }

  // Generate mock analysis result
  Map<String, dynamic> _generateMockAnalysisResult() {
    final diseases = [
      'ఆకుల మచ్చ వ్యాధి',
      'పుట్టగొడుగు వ్యాధి',
      'బ్యాక్టీరియా వ్యాధి',
      'వైరస్ వ్యాధి',
      'ఆరోగ్యకరమైన ఆకు',
    ];

    final severities = ['తేలికైన', 'మధ్యమ', 'తీవ్రమైన'];

    final selectedDisease =
        diseases[DateTime.now().millisecond % diseases.length];
    final selectedSeverity =
        severities[DateTime.now().second % severities.length];

    return {
      'disease': selectedDisease,
      'confidence': 0.85 + (DateTime.now().millisecond % 15) / 100,
      'severity': selectedSeverity,
      'treatments': [
        'సేంద్రీయ కీటకనాశకాలు వాడండి',
        'నీటిపారుదల తగ్గించండి',
        'వ్యాధిగ్రస్త ఆకులను తొలగించండి',
        'మంచి వెంటిలేషన్ ఉంచండి',
      ],
      'preventions': [
        'క్రమం తప్పకుండా తనిఖీ చేయండి',
        'అధిక తేమను నివారించండి',
        'పంట మధ్య దూరం ఉంచండి',
        'సరైన పోషకాహారం ఇవ్వండి',
      ],
      'additionalInfo':
          'మరింత సహాయం కోసం స్థానిక వ్యవసాయ అధికారిని సంప్రదించండి. నియమిత పరిశీలన మరియు సరైన పోషకాహారం మీ పంటల ఆరోగ్యానికి చాలా ముఖ్యం.',
    };
  }

  // Retake photo
  void _retakePhoto() {
    setState(() {
      _capturedImage = null;
      _currentState = AnalysisScreenState.camera;
    });
  }

  // Start new analysis
  void _startNewAnalysis() {
    setState(() {
      _capturedImage = null;
      _analysisResult = null;
      _currentState = AnalysisScreenState.camera;
    });
  }

  // Share analysis results
  void _shareResults() {
    if (_analysisResult == null) return;

    // Mock share functionality
    _showSuccessSnackBar('ఫలితాలు షేర్ చేయబడ్డాయి');
  }

  // Show permission denied dialog
  void _showPermissionDeniedDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('అనుమతి అవసరం'),
        content: Text(
            'కెమెరా ఉపయోగించడానికి అనుమతి అవసరం. దయచేసి సెట్టింగ్స్‌లో అనుమతి ఇవ్వండి.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('రద్దు చేయండి'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              openAppSettings();
            },
            child: Text('సెట్టింగ్స్'),
          ),
        ],
      ),
    );
  }

  // Show no camera dialog
  void _showNoCameraDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('కెమెరా లేదు'),
        content: Text('ఈ పరికరంలో కెమెరా అందుబాటులో లేదు.'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pop(context);
            },
            child: Text('సరే'),
          ),
        ],
      ),
    );
  }

  // Show camera error dialog
  void _showCameraErrorDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('కెమెరా లోపం'),
        content: Text(
            'కెమెరా ప్రారంభించడంలో లోపం జరిగింది. దయచేసి మళ్లీ ప్రయత్నించండి.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('రద్దు చేయండి'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _initializeCamera();
            },
            child: Text('మళ్లీ ప్రయత్నించండి'),
          ),
        ],
      ),
    );
  }

  // Show error snackbar
  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: AppTheme.errorLight,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  // Show success snackbar
  void _showSuccessSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: AppTheme.successLight,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.lightTheme.scaffoldBackgroundColor,
      body: SafeArea(
        child: Stack(
          children: [
            // Main content based on current state
            _buildMainContent(),

            // Analysis progress overlay
            AnalysisProgressWidget(isAnalyzing: _isAnalyzing),
          ],
        ),
      ),
    );
  }

  Widget _buildMainContent() {
    switch (_currentState) {
      case AnalysisScreenState.camera:
        return _buildCameraView();
      case AnalysisScreenState.preview:
        return _buildPreviewView();
      case AnalysisScreenState.analyzing:
        return _buildPreviewView(); // Show preview while analyzing
      case AnalysisScreenState.results:
        return _buildResultsView();
    }
  }

  Widget _buildCameraView() {
    return Column(
      children: [
        // Header
        Container(
          padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
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
              Text(
                'ఆకు విశ్లేషణ',
                style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),

        // Camera preview
        Expanded(
          child: Padding(
            padding: EdgeInsets.all(4.w),
            child: CameraPreviewWidget(
              cameraController: _isCameraInitialized ? _cameraController : null,
              isFlashOn: _isFlashOn,
              onFlashToggle: _toggleFlash,
              onCapture: _capturePhoto,
              onGallery: _selectFromGallery,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPreviewView() {
    return ImagePreviewWidget(
      capturedImage: _capturedImage,
      onRetake: _retakePhoto,
      onConfirm: _startAnalysis,
    );
  }

  Widget _buildResultsView() {
    if (_analysisResult == null) {
      return Center(child: CircularProgressIndicator());
    }

    return AnalysisResultsWidget(
      analysisResult: _analysisResult!,
      onNewAnalysis: _startNewAnalysis,
      onShare: _shareResults,
    );
  }
}

enum AnalysisScreenState {
  camera,
  preview,
  analyzing,
  results,
}
