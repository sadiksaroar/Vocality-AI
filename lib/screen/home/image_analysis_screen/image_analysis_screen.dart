import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

import 'package:vocality_ai/core/gen/assets.gen.dart';

class ImageAnalysisScreen extends StatefulWidget {
  const ImageAnalysisScreen({super.key});

  @override
  State<ImageAnalysisScreen> createState() => _ImageAnalysisScreenState();
}

class _ImageAnalysisScreenState extends State<ImageAnalysisScreen> {
  File? _selectedImage;
  final ImagePicker _picker = ImagePicker();

  Future<void> _pickImageFromCamera() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.camera);
    if (image != null) {
      setState(() {
        _selectedImage = File(image.path);
      });
    }
  }

  Future<void> _pickImageFromGallery() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() {
        _selectedImage = File(image.path);
      });
    }
  }

  void _analyzeImage() {
    // Implement your analysis logic here
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Analyzing image...')));
  }

  void _chooseDifferentImage() {
    setState(() {
      _selectedImage = null;
    });
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
                      '\$1.00 per analysis',
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

              // Main content area
              Expanded(
                child: Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: _selectedImage == null
                      ? _buildUploadSection()
                      : _buildImagePreviewSection(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildUploadSection() {
    return Padding(
      padding: const EdgeInsets.all(32.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Image icon
          Container(
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

          // Take Photo button
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
                  SizedBox(width: 8),
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

          // Choose from Gallery button
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
                  SizedBox(width: 8),
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
      padding: const EdgeInsets.all(24.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Image preview
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Image.file(
              _selectedImage!,
              height: 300,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(height: 24),

          // Choose Different Image button
          SizedBox(
            width: double.infinity,
            height: 56,
            child: OutlinedButton(
              onPressed: _chooseDifferentImage,
              style: OutlinedButton.styleFrom(
                foregroundColor: Colors.black87,
                side: const BorderSide(color: Colors.black26),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: Text(
                'Choose Different Image',
                textAlign: TextAlign.center,
                style: GoogleFonts.inter(
                  color: const Color(0xFF354152),
                  fontSize: 16,
                  fontWeight: FontWeight.w400,
                  height: 1.50,
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Analyze Image button
          SizedBox(
            width: double.infinity,
            height: 56,
            child: ElevatedButton(
              onPressed: _analyzeImage,
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
                  Image.asset(Assets.icons.anlayxe.path, width: 20, height: 20),
                  const SizedBox(width: 8),
                  Text(
                    'Analyze Image (\$1.00)',
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
        ],
      ),
    );
  }
}
