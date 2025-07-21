import 'package:camera/camera.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class CameraSearchWidget extends StatefulWidget {
  final Function(XFile) onImageCaptured;

  const CameraSearchWidget({
    Key? key,
    required this.onImageCaptured,
  }) : super(key: key);

  @override
  State<CameraSearchWidget> createState() => _CameraSearchWidgetState();
}

class _CameraSearchWidgetState extends State<CameraSearchWidget> {
  CameraController? _cameraController;
  List<CameraDescription> _cameras = [];
  bool _isInitialized = false;
  bool _isLoading = false;
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

  Future<void> _initializeCamera() async {
    try {
      if (!await _requestCameraPermission()) {
        return;
      }

      _cameras = await availableCameras();
      if (_cameras.isEmpty) return;

      final camera = kIsWeb
          ? _cameras.firstWhere(
              (c) => c.lensDirection == CameraLensDirection.front,
              orElse: () => _cameras.first)
          : _cameras.firstWhere(
              (c) => c.lensDirection == CameraLensDirection.back,
              orElse: () => _cameras.first);

      _cameraController = CameraController(
          camera, kIsWeb ? ResolutionPreset.medium : ResolutionPreset.high);

      await _cameraController!.initialize();
      await _applySettings();

      if (mounted) {
        setState(() => _isInitialized = true);
      }
    } catch (e) {
      debugPrint('Camera initialization error: $e');
    }
  }

  Future<bool> _requestCameraPermission() async {
    if (kIsWeb) return true;
    return (await Permission.camera.request()).isGranted;
  }

  Future<void> _applySettings() async {
    if (_cameraController == null) return;

    try {
      await _cameraController!.setFocusMode(FocusMode.auto);
      if (!kIsWeb) {
        try {
          await _cameraController!.setFlashMode(FlashMode.auto);
        } catch (e) {
          debugPrint('Flash mode not supported: $e');
        }
      }
    } catch (e) {
      debugPrint('Camera settings error: $e');
    }
  }

  Future<void> _capturePhoto() async {
    if (_cameraController == null || !_cameraController!.value.isInitialized)
      return;

    setState(() => _isLoading = true);

    try {
      final XFile photo = await _cameraController!.takePicture();
      widget.onImageCaptured(photo);
      Navigator.pop(context);
    } catch (e) {
      debugPrint('Photo capture error: $e');
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _pickFromGallery() async {
    setState(() => _isLoading = true);

    try {
      final XFile? image = await _imagePicker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 85,
      );

      if (image != null) {
        widget.onImageCaptured(image);
        Navigator.pop(context);
      }
    } catch (e) {
      debugPrint('Gallery pick error: $e');
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: CustomIconWidget(
            iconName: 'close',
            color: Colors.white,
            size: 6.w,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Search by Photo',
          style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
            color: Colors.white,
          ),
        ),
      ),
      body: _isInitialized && _cameraController != null
          ? Stack(
              children: [
                Positioned.fill(
                  child: CameraPreview(_cameraController!),
                ),
                Positioned(
                  bottom: 10.h,
                  left: 0,
                  right: 0,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _buildActionButton(
                        icon: 'photo_library',
                        label: 'Gallery',
                        onTap: _pickFromGallery,
                      ),
                      _buildCaptureButton(),
                      _buildActionButton(
                        icon: 'flip_camera_ios',
                        label: 'Flip',
                        onTap: _flipCamera,
                      ),
                    ],
                  ),
                ),
                if (_isLoading)
                  Container(
                    color: Colors.black.withValues(alpha: 0.5),
                    child: Center(
                      child: CircularProgressIndicator(
                        color: AppTheme.lightTheme.colorScheme.primary,
                      ),
                    ),
                  ),
              ],
            )
          : Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(
                    color: AppTheme.lightTheme.colorScheme.primary,
                  ),
                  SizedBox(height: 2.h),
                  Text(
                    'Initializing camera...',
                    style: AppTheme.lightTheme.textTheme.bodyLarge?.copyWith(
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
    );
  }

  Widget _buildCaptureButton() {
    return GestureDetector(
      onTap: _isLoading ? null : _capturePhoto,
      child: Container(
        width: 20.w,
        height: 20.w,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.white,
          border: Border.all(color: Colors.grey, width: 3),
        ),
        child: _isLoading
            ? Center(
                child: CircularProgressIndicator(
                  color: AppTheme.lightTheme.colorScheme.primary,
                  strokeWidth: 2,
                ),
              )
            : CustomIconWidget(
                iconName: 'camera_alt',
                color: Colors.black,
                size: 8.w,
              ),
      ),
    );
  }

  Widget _buildActionButton({
    required String icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: _isLoading ? null : onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: EdgeInsets.all(3.w),
            decoration: BoxDecoration(
              color: Colors.black.withValues(alpha: 0.5),
              shape: BoxShape.circle,
            ),
            child: CustomIconWidget(
              iconName: icon,
              color: Colors.white,
              size: 6.w,
            ),
          ),
          SizedBox(height: 1.h),
          Text(
            label,
            style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _flipCamera() async {
    if (_cameras.length < 2) return;

    final currentCamera = _cameraController!.description;
    final newCamera = _cameras.firstWhere(
      (camera) => camera.lensDirection != currentCamera.lensDirection,
      orElse: () => currentCamera,
    );

    if (newCamera == currentCamera) return;

    await _cameraController!.dispose();
    _cameraController = CameraController(
      newCamera,
      kIsWeb ? ResolutionPreset.medium : ResolutionPreset.high,
    );

    try {
      await _cameraController!.initialize();
      await _applySettings();
      if (mounted) setState(() {});
    } catch (e) {
      debugPrint('Camera flip error: $e');
    }
  }
}
