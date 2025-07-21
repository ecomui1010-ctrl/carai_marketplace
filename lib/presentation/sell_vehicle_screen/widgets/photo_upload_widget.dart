import 'package:camera/camera.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class PhotoUploadWidget extends StatefulWidget {
  final Function(List<XFile>) onPhotosChanged;
  final List<XFile> selectedPhotos;

  const PhotoUploadWidget({
    Key? key,
    required this.onPhotosChanged,
    required this.selectedPhotos,
  }) : super(key: key);

  @override
  State<PhotoUploadWidget> createState() => _PhotoUploadWidgetState();
}

class _PhotoUploadWidgetState extends State<PhotoUploadWidget> {
  CameraController? _cameraController;
  List<CameraDescription> _cameras = [];
  bool _isCameraInitialized = false;
  bool _showCamera = false;
  final ImagePicker _imagePicker = ImagePicker();
  int _primaryImageIndex = 0;

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

  Future<bool> _requestCameraPermission() async {
    if (kIsWeb) return true;
    return (await Permission.camera.request()).isGranted;
  }

  Future<void> _initializeCamera() async {
    try {
      if (!await _requestCameraPermission()) return;

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
        setState(() {
          _isCameraInitialized = true;
        });
      }
    } catch (e) {
      debugPrint('Camera initialization error: $e');
    }
  }

  Future<void> _applySettings() async {
    if (_cameraController == null) return;

    try {
      await _cameraController!.setFocusMode(FocusMode.auto);
    } catch (e) {}

    if (!kIsWeb) {
      try {
        await _cameraController!.setFlashMode(FlashMode.auto);
      } catch (e) {}
    }
  }

  Future<void> _capturePhoto() async {
    if (_cameraController == null || !_cameraController!.value.isInitialized)
      return;

    try {
      final XFile photo = await _cameraController!.takePicture();
      final updatedPhotos = List<XFile>.from(widget.selectedPhotos)..add(photo);
      widget.onPhotosChanged(updatedPhotos);

      setState(() {
        _showCamera = false;
      });
    } catch (e) {
      debugPrint('Photo capture error: $e');
    }
  }

  Future<void> _pickFromGallery() async {
    try {
      final List<XFile> images = await _imagePicker.pickMultiImage();
      if (images.isNotEmpty) {
        final updatedPhotos = List<XFile>.from(widget.selectedPhotos)
          ..addAll(images);
        widget.onPhotosChanged(updatedPhotos);
      }
    } catch (e) {
      debugPrint('Gallery pick error: $e');
    }
  }

  void _removePhoto(int index) {
    final updatedPhotos = List<XFile>.from(widget.selectedPhotos)
      ..removeAt(index);
    widget.onPhotosChanged(updatedPhotos);

    if (_primaryImageIndex >= updatedPhotos.length &&
        updatedPhotos.isNotEmpty) {
      _primaryImageIndex = 0;
    }
  }

  void _setPrimaryImage(int index) {
    setState(() {
      _primaryImageIndex = index;
    });
  }

  void _reorderPhotos(int oldIndex, int newIndex) {
    if (newIndex > oldIndex) {
      newIndex -= 1;
    }

    final updatedPhotos = List<XFile>.from(widget.selectedPhotos);
    final item = updatedPhotos.removeAt(oldIndex);
    updatedPhotos.insert(newIndex, item);

    widget.onPhotosChanged(updatedPhotos);

    if (_primaryImageIndex == oldIndex) {
      _primaryImageIndex = newIndex;
    } else if (oldIndex < _primaryImageIndex &&
        newIndex >= _primaryImageIndex) {
      _primaryImageIndex--;
    } else if (oldIndex > _primaryImageIndex &&
        newIndex <= _primaryImageIndex) {
      _primaryImageIndex++;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppTheme.lightTheme.colorScheme.outline.withValues(alpha: 0.3),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CustomIconWidget(
                iconName: 'camera_alt',
                color: AppTheme.lightTheme.colorScheme.primary,
                size: 24,
              ),
              SizedBox(width: 2.w),
              Text(
                'Vehicle Photos',
                style: AppTheme.lightTheme.textTheme.titleMedium,
              ),
            ],
          ),
          SizedBox(height: 2.h),
          if (_showCamera && _isCameraInitialized) ...[
            Container(
              height: 40.h,
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                color: Colors.black,
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: CameraPreview(_cameraController!),
              ),
            ),
            SizedBox(height: 2.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton.icon(
                  onPressed: () => setState(() => _showCamera = false),
                  icon: CustomIconWidget(
                    iconName: 'close',
                    color: AppTheme.lightTheme.colorScheme.onPrimary,
                    size: 20,
                  ),
                  label: Text('Cancel'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.lightTheme.colorScheme.outline,
                  ),
                ),
                ElevatedButton.icon(
                  onPressed: _capturePhoto,
                  icon: CustomIconWidget(
                    iconName: 'camera',
                    color: AppTheme.lightTheme.colorScheme.onPrimary,
                    size: 20,
                  ),
                  label: Text('Capture'),
                ),
              ],
            ),
          ] else ...[
            if (widget.selectedPhotos.isEmpty) ...[
              Container(
                height: 25.h,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: AppTheme.lightTheme.colorScheme.surface
                      .withValues(alpha: 0.5),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: AppTheme.lightTheme.colorScheme.outline
                        .withValues(alpha: 0.3),
                    style: BorderStyle.solid,
                  ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CustomIconWidget(
                      iconName: 'add_a_photo',
                      color: AppTheme.lightTheme.colorScheme.outline,
                      size: 48,
                    ),
                    SizedBox(height: 2.h),
                    Text(
                      'Add photos of your vehicle',
                      style: AppTheme.lightTheme.textTheme.bodyLarge?.copyWith(
                        color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                    SizedBox(height: 1.h),
                    Text(
                      'First photo will be the cover image',
                      style: AppTheme.lightTheme.textTheme.bodySmall,
                    ),
                  ],
                ),
              ),
            ] else ...[
              ReorderableListView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: widget.selectedPhotos.length,
                onReorder: _reorderPhotos,
                itemBuilder: (context, index) {
                  final photo = widget.selectedPhotos[index];
                  return Container(
                    key: ValueKey(photo.path),
                    margin: EdgeInsets.only(bottom: 2.h),
                    child: Stack(
                      children: [
                        Container(
                          height: 20.h,
                          width: double.infinity,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            border: _primaryImageIndex == index
                                ? Border.all(
                                    color:
                                        AppTheme.lightTheme.colorScheme.primary,
                                    width: 3,
                                  )
                                : null,
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: kIsWeb
                                ? Image.network(
                                    photo.path,
                                    fit: BoxFit.cover,
                                    errorBuilder: (context, error, stackTrace) {
                                      return Container(
                                        color: AppTheme
                                            .lightTheme.colorScheme.outline
                                            .withValues(alpha: 0.1),
                                        child: Center(
                                          child: CustomIconWidget(
                                            iconName: 'broken_image',
                                            color: AppTheme
                                                .lightTheme.colorScheme.outline,
                                            size: 32,
                                          ),
                                        ),
                                      );
                                    },
                                  )
                                : Image.network(
                                    photo.path,
                                    fit: BoxFit.cover,
                                    errorBuilder: (context, error, stackTrace) {
                                      return Container(
                                        color: AppTheme
                                            .lightTheme.colorScheme.outline
                                            .withValues(alpha: 0.1),
                                        child: Center(
                                          child: CustomIconWidget(
                                            iconName: 'broken_image',
                                            color: AppTheme
                                                .lightTheme.colorScheme.outline,
                                            size: 32,
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                          ),
                        ),
                        if (_primaryImageIndex == index)
                          Positioned(
                            top: 8,
                            left: 8,
                            child: Container(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 2.w, vertical: 0.5.h),
                              decoration: BoxDecoration(
                                color: AppTheme.lightTheme.colorScheme.primary,
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Text(
                                'Cover Photo',
                                style: AppTheme.lightTheme.textTheme.labelSmall
                                    ?.copyWith(
                                  color:
                                      AppTheme.lightTheme.colorScheme.onPrimary,
                                ),
                              ),
                            ),
                          ),
                        Positioned(
                          top: 8,
                          right: 8,
                          child: Row(
                            children: [
                              if (_primaryImageIndex != index)
                                GestureDetector(
                                  onTap: () => _setPrimaryImage(index),
                                  child: Container(
                                    padding: EdgeInsets.all(1.w),
                                    decoration: BoxDecoration(
                                      color:
                                          Colors.black.withValues(alpha: 0.7),
                                      borderRadius: BorderRadius.circular(6),
                                    ),
                                    child: CustomIconWidget(
                                      iconName: 'star_border',
                                      color: Colors.white,
                                      size: 20,
                                    ),
                                  ),
                                ),
                              SizedBox(width: 1.w),
                              GestureDetector(
                                onTap: () => _removePhoto(index),
                                child: Container(
                                  padding: EdgeInsets.all(1.w),
                                  decoration: BoxDecoration(
                                    color: Colors.black.withValues(alpha: 0.7),
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                  child: CustomIconWidget(
                                    iconName: 'delete',
                                    color: Colors.white,
                                    size: 20,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Positioned(
                          bottom: 8,
                          right: 8,
                          child: Container(
                            padding: EdgeInsets.all(1.w),
                            decoration: BoxDecoration(
                              color: Colors.black.withValues(alpha: 0.7),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: CustomIconWidget(
                              iconName: 'drag_handle',
                              color: Colors.white,
                              size: 20,
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ],
            SizedBox(height: 2.h),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: _pickFromGallery,
                    icon: CustomIconWidget(
                      iconName: 'photo_library',
                      color: AppTheme.lightTheme.colorScheme.primary,
                      size: 20,
                    ),
                    label: Text('Gallery'),
                  ),
                ),
                SizedBox(width: 3.w),
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: _isCameraInitialized
                        ? () => setState(() => _showCamera = true)
                        : null,
                    icon: CustomIconWidget(
                      iconName: 'camera_alt',
                      color: _isCameraInitialized
                          ? AppTheme.lightTheme.colorScheme.primary
                          : AppTheme.lightTheme.colorScheme.outline,
                      size: 20,
                    ),
                    label: Text('Camera'),
                  ),
                ),
              ],
            ),
          ],
          if (widget.selectedPhotos.isNotEmpty) ...[
            SizedBox(height: 2.h),
            Container(
              padding: EdgeInsets.all(3.w),
              decoration: BoxDecoration(
                color: AppTheme.lightTheme.colorScheme.tertiary
                    .withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  CustomIconWidget(
                    iconName: 'auto_awesome',
                    color: AppTheme.lightTheme.colorScheme.tertiary,
                    size: 20,
                  ),
                  SizedBox(width: 2.w),
                  Expanded(
                    child: Text(
                      'AI is analyzing your photos for damage detection and background enhancement',
                      style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                        color: AppTheme.lightTheme.colorScheme.tertiary,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}
