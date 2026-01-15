import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:permission_handler/permission_handler.dart';
import 'dart:io';

import 'package:vocality_ai/core/gen/assets.gen.dart';
import 'package:vocality_ai/core/gen/stroge_helper/stroge_helper.dart';
import 'package:vocality_ai/screen/home/image_analysis_screen/services/image_analysis_service.dart';

class ImageAnalysisScreen extends StatefulWidget {
  const ImageAnalysisScreen({super.key});

  @override
  State<ImageAnalysisScreen> createState() => _ImageAnalysisScreenState();
}

class _ImageAnalysisScreenState extends State<ImageAnalysisScreen> {
  File? _selectedImage;
  Uint8List? _selectedImageBytes;
  final ImagePicker _picker = ImagePicker();
  final TextEditingController _promptController = TextEditingController();
  final ImageAnalysisController _analysisController = ImageAnalysisController();

  @override
  void initState() {
    super.initState();
    _analysisController.addListener(_onControllerUpdate);
  }

  void _onControllerUpdate() {
    setState(() {});

    // Show error message if any
    if (_analysisController.state == ImageAnalysisState.error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            _analysisController.errorMessage ?? 'An error occurred',
          ),
          backgroundColor: Colors.red,
        ),
      );
    }

    // Show completion message
    if (_analysisController.state == ImageAnalysisState.completed) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Analysis complete!'),
          backgroundColor: Colors.green,
        ),
      );
    }
  }

  Future<bool> _requestCameraPermission() async {
    if (kIsWeb) return true;

    final status = await Permission.camera.request();
    if (status.isDenied || status.isPermanentlyDenied) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Camera permission is required to take photos'),
            backgroundColor: Colors.red,
          ),
        );
      }
      return false;
    }
    return status.isGranted;
  }

  Future<bool> _requestStoragePermission() async {
    if (kIsWeb) return true;

    // For Android 13+ (API 33+), use photos permission
    if (Platform.isAndroid) {
      final androidVersion = await _getAndroidVersion();
      if (androidVersion >= 33) {
        final status = await Permission.photos.request();
        if (status.isDenied || status.isPermanentlyDenied) {
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text(
                  'Photos permission is required to access gallery',
                ),
                backgroundColor: Colors.red,
              ),
            );
          }
          return false;
        }
        return status.isGranted;
      } else {
        // For older Android versions, use storage permission
        final status = await Permission.storage.request();
        if (status.isDenied || status.isPermanentlyDenied) {
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text(
                  'Storage permission is required to access gallery',
                ),
                backgroundColor: Colors.red,
              ),
            );
          }
          return false;
        }
        return status.isGranted;
      }
    }

    // For iOS
    final status = await Permission.photos.request();
    return status.isGranted;
  }

  Future<int> _getAndroidVersion() async {
    if (!Platform.isAndroid) return 0;
    // This is a simplified version. In production, you might want to use device_info_plus
    return 33; // Assume modern Android for safety
  }

  Future<void> _pickImageFromCamera() async {
    final hasPermission = await _requestCameraPermission();
    if (!hasPermission) return;

    final XFile? image = await _picker.pickImage(source: ImageSource.camera);
    if (image != null) {
      if (kIsWeb) {
        final bytes = await image.readAsBytes();
        setState(() {
          _selectedImageBytes = bytes;
        });
      } else {
        setState(() {
          _selectedImage = File(image.path);
        });
      }
    }
  }

  Future<void> _pickImageFromGallery() async {
    final hasPermission = await _requestStoragePermission();
    if (!hasPermission) return;

    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      if (kIsWeb) {
        final bytes = await image.readAsBytes();
        setState(() {
          _selectedImageBytes = bytes;
        });
      } else {
        setState(() {
          _selectedImage = File(image.path);
        });
      }
    }
  }

  Future<void> _analyzeImage() async {
    if (_selectedImage == null && _selectedImageBytes == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select an image first')),
      );
      return;
    }
    if (_promptController.text.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Please enter a prompt')));
      return;
    }

    // Get auth token from storage
    final token = await StorageHelper.getToken();
    if (token == null || token.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please login first'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    // Start analysis with the image and prompt
    await _analysisController.analyzeAndSpeak(
      imageFile: _selectedImage,
      imageBytes: _selectedImageBytes,
      userRequest: _promptController.text,
      authToken: 'Bearer $token',
    );
  }

  void _chooseDifferentImage() {
    setState(() {
      _selectedImage = null;
      _selectedImageBytes = null;
    });
    _analysisController.reset();
  }

  @override
  void dispose() {
    _promptController.dispose();
    _analysisController.removeListener(_onControllerUpdate);
    _analysisController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFC107),
      appBar: AppBar(
        backgroundColor: const Color(0xFFFFC107),
        elevation: 0,
        leading: IconButton(
          icon: Image.asset(Assets.icons.backIcon.path, width: 24, height: 24),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header
                Row(
                  children: [
                    Image.asset(
                      Assets.icons.imageAIAnalysisStar.path,
                      width: 24,
                      height: 24,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'Image AI Analysis',
                      style: GoogleFonts.inter(
                        color: Colors.black,
                        fontSize: 30,
                        fontWeight: FontWeight.w700,
                        height: 1.20,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  'Upload an image for AI-powered insights',
                  style: GoogleFonts.inter(
                    color: const Color(0xFF5C5C5C),
                    fontSize: 18,
                    fontWeight: FontWeight.w400,
                    height: 1.56,
                  ),
                ),

                const SizedBox(height: 16),
                // Price tag
                Container(
                  width: 199.06,
                  height: 51.97,
                  decoration: ShapeDecoration(
                    color: Colors.white.withValues(alpha: 0.25),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(41073000),
                    ),
                  ),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 8,
                  ),
                  child: Row(
                    children: [
                      Image.asset(
                        Assets.icons.doller.path,
                        width: 18,
                        height: 18,
                      ),
                      Text(
                        '\$2.99 per analysis',
                        style: GoogleFonts.inter(
                          color: Colors.black,
                          fontSize: 16,
                          fontWeight: FontWeight.w400,
                          height: 1.50,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),

                // Main content area (white container)
                Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: (_selectedImage == null && _selectedImageBytes == null)
                      ? _buildUploadSection()
                      : _buildImagePreviewSection(),
                ),

                // Show prompt and analyze button only when image is selected
                if (_selectedImage != null || _selectedImageBytes != null) ...[
                  const SizedBox(height: 18),

                  // Prompt label
                  Row(
                    children: [
                      const Icon(
                        Icons.chat_bubble_outline,
                        color: Colors.black54,
                        size: 18,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'Image Analysis Prompt',
                        style: GoogleFonts.inter(
                          color: Colors.black,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),

                  // Prompt textarea
                  Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: TextField(
                      controller: _promptController,
                      maxLines: 4,
                      enabled: !_analysisController.isLoading,
                      decoration: InputDecoration(
                        hintText: 'write here....',
                        hintStyle: GoogleFonts.inter(color: Colors.grey[500]),
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 12,
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(color: Colors.grey.shade300),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: const BorderSide(color: Colors.black87),
                        ),
                        disabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(color: Colors.grey.shade200),
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Analyze Image button with loading states
                  SizedBox(
                    width: double.infinity,
                    height: 52,
                    child: ElevatedButton(
                      onPressed: _analysisController.isLoading
                          ? null
                          : _analyzeImage,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.black,
                        foregroundColor: Colors.white,
                        disabledBackgroundColor: Colors.grey,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 0,
                      ),
                      child: _buildButtonContent(),
                    ),
                  ),

                  // Upload progress indicator
                  if (_analysisController.state ==
                      ImageAnalysisState.uploading) ...[
                    const SizedBox(height: 16),
                    LinearProgressIndicator(
                      value: _analysisController.uploadProgress,
                      backgroundColor: Colors.white,
                      valueColor: const AlwaysStoppedAnimation<Color>(
                        Colors.black,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Uploading... ${(_analysisController.uploadProgress * 100).toInt()}%',
                      style: GoogleFonts.inter(
                        color: Colors.black54,
                        fontSize: 14,
                      ),
                    ),
                  ],

                  // Analysis result display - show when speaking or completed
                  if (_analysisController.state ==
                          ImageAnalysisState.speaking ||
                      _analysisController.state ==
                          ImageAnalysisState.completed) ...[
                    const SizedBox(height: 24),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.grey.shade300),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Icon(
                                _analysisController.state ==
                                        ImageAnalysisState.speaking
                                    ? Icons.volume_up
                                    : Icons.check_circle,
                                color:
                                    _analysisController.state ==
                                        ImageAnalysisState.speaking
                                    ? Colors.orange
                                    : Colors.green,
                                size: 20,
                              ),
                              const SizedBox(width: 8),
                              Text(
                                _analysisController.state ==
                                        ImageAnalysisState.speaking
                                    ? 'Playing Audio Response...'
                                    : 'Analysis Complete',
                                style: GoogleFonts.inter(
                                  color: Colors.black,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                          if (_analysisController.analysisResult != null) ...[
                            const SizedBox(height: 12),
                            Text(
                              _analysisController.analysisResult!,
                              style: GoogleFonts.inter(
                                color: Colors.black87,
                                fontSize: 14,
                                height: 1.5,
                              ),
                            ),
                          ] else ...[
                            const SizedBox(height: 12),
                            Text(
                              _analysisController.state ==
                                      ImageAnalysisState.speaking
                                  ? 'Listen to the audio response for your image analysis.'
                                  : 'Your image has been analyzed. Audio response played successfully.',
                              style: GoogleFonts.inter(
                                color: Colors.black54,
                                fontSize: 14,
                                height: 1.5,
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                  ],

                  const SizedBox(height: 20),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildButtonContent() {
    switch (_analysisController.state) {
      case ImageAnalysisState.uploading:
        return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(
              width: 20,
              height: 20,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
              ),
            ),
            const SizedBox(width: 8),
            Text(
              'Uploading...',
              style: GoogleFonts.inter(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        );
      case ImageAnalysisState.analyzing:
        return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(
              width: 20,
              height: 20,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
              ),
            ),
            const SizedBox(width: 8),
            Text(
              'Analyzing...',
              style: GoogleFonts.inter(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        );
      case ImageAnalysisState.speaking:
        return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.volume_up, size: 20),
            const SizedBox(width: 8),
            Text(
              'Speaking Result...',
              style: GoogleFonts.inter(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        );
      default:
        return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(Assets.icons.anlayxe.path, width: 20, height: 20),
            const SizedBox(width: 8),
            Text(
              'Analyze Image (\$2.99)',
              textAlign: TextAlign.center,
              style: GoogleFonts.inter(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        );
    }
  }

  Widget _buildUploadSection() {
    return Padding(
      padding: const EdgeInsets.all(32.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            width: 100,
            height: 100,
            child: Center(
              child: Image.asset(
                Assets.icons.uploadYourImage.path,
                width: 91,
                height: 91,
              ),
            ),
          ),
          const SizedBox(height: 24),
          Text(
            'Upload Your Image',
            textAlign: TextAlign.center,
            style: GoogleFonts.inter(
              color: const Color(0xFF1D2838),
              fontSize: 16,
              fontWeight: FontWeight.w400,
              height: 1.50,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Choose from camera or gallery',
            textAlign: TextAlign.center,
            style: GoogleFonts.inter(
              color: const Color(0xFF495565),
              fontSize: 16,
              fontWeight: FontWeight.w400,
              height: 1.50,
            ),
          ),
          const SizedBox(height: 32),
          SizedBox(
            width: double.infinity,
            height: 56,
            child: ElevatedButton(
              onPressed: _pickImageFromCamera,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.black,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 0,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    Assets.icons.takePhoto.path,
                    width: 20,
                    height: 20,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'Take Photo',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.inter(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                      height: 1.50,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            height: 56,
            child: OutlinedButton(
              onPressed: _pickImageFromGallery,
              style: OutlinedButton.styleFrom(
                foregroundColor: Colors.black87,
                side: const BorderSide(color: Colors.black26),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    Assets.icons.chooseFromGallery.path,
                    width: 20,
                    height: 20,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'Choose from Gallery',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.inter(
                      color: const Color(0xFF354152),
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                      height: 1.50,
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

  Widget _buildImagePreviewSection() {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: kIsWeb
                ? (_selectedImageBytes != null
                      ? Image.memory(
                          _selectedImageBytes!,
                          height: 200,
                          width: double.infinity,
                          fit: BoxFit.cover,
                        )
                      : const SizedBox())
                : Image.file(
                    _selectedImage!,
                    height: 200,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
          ),
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            height: 46,
            child: OutlinedButton(
              onPressed: _analysisController.isLoading
                  ? null
                  : _chooseDifferentImage,
              style: OutlinedButton.styleFrom(
                foregroundColor: Colors.black87,
                side: const BorderSide(color: Colors.black12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: Text(
                'Choose Different Image',
                textAlign: TextAlign.center,
                style: GoogleFonts.inter(
                  color: const Color(0xFF354152),
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
