import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import './widgets/ai_description_widget.dart';
import './widgets/location_selection_widget.dart';
import './widgets/photo_upload_widget.dart';
import './widgets/pricing_section_widget.dart';
import './widgets/progress_indicator_widget.dart';
import './widgets/vehicle_details_form_widget.dart';

class SellVehicleScreen extends StatefulWidget {
  const SellVehicleScreen({Key? key}) : super(key: key);

  @override
  State<SellVehicleScreen> createState() => _SellVehicleScreenState();
}

class _SellVehicleScreenState extends State<SellVehicleScreen>
    with TickerProviderStateMixin {
  final PageController _pageController = PageController();
  int _currentStep = 0;
  final int _totalSteps = 5;
  bool _isPublishing = false;
  bool _isDraftSaved = false;

  // Form data
  List<XFile> _selectedPhotos = [];
  Map<String, dynamic> _vehicleDetails = {};
  String _aiDescription = '';
  Map<String, dynamic> _pricingData = {};
  Map<String, dynamic> _locationData = {};

  final List<String> _stepLabels = [
    'Photos',
    'Details',
    'Description',
    'Pricing',
    'Location'
  ];

  @override
  void initState() {
    super.initState();
    _loadDraftData();
  }

  Future<void> _loadDraftData() async {
    // Simulate loading draft data
    await Future.delayed(Duration(milliseconds: 500));

    // Mock draft data could be loaded here
    setState(() {
      _isDraftSaved = false;
    });
  }

  Future<void> _saveDraft() async {
    setState(() {
      _isDraftSaved = true;
    });

    // Simulate saving draft
    await Future.delayed(Duration(seconds: 1));

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Draft saved successfully'),
          backgroundColor: AppTheme.lightTheme.colorScheme.tertiary,
        ),
      );
    }
  }

  bool _canProceedToNextStep() {
    switch (_currentStep) {
      case 0: // Photos
        return _selectedPhotos.isNotEmpty;
      case 1: // Details
        return _vehicleDetails['make'] != null &&
            _vehicleDetails['model'] != null &&
            _vehicleDetails['year'] != null &&
            _vehicleDetails['mileage'] != null &&
            _vehicleDetails['condition'] != null;
      case 2: // Description
        return _aiDescription.isNotEmpty;
      case 3: // Pricing
        return _pricingData['price'] != null && _pricingData['price'] > 0;
      case 4: // Location
        return (_locationData['useCurrentLocation'] == true &&
                _locationData['currentLocationText'] != null) ||
            (_locationData['useCurrentLocation'] == false &&
                _locationData['address']?.isNotEmpty == true &&
                _locationData['city']?.isNotEmpty == true &&
                _locationData['state']?.isNotEmpty == true &&
                _locationData['zipCode']?.isNotEmpty == true);
      default:
        return false;
    }
  }

  bool _canPublishListing() {
    return _selectedPhotos.isNotEmpty &&
        _vehicleDetails['make'] != null &&
        _vehicleDetails['model'] != null &&
        _vehicleDetails['year'] != null &&
        _vehicleDetails['mileage'] != null &&
        _vehicleDetails['condition'] != null &&
        _aiDescription.isNotEmpty &&
        _pricingData['price'] != null &&
        _pricingData['price'] > 0 &&
        ((_locationData['useCurrentLocation'] == true &&
                _locationData['currentLocationText'] != null) ||
            (_locationData['useCurrentLocation'] == false &&
                _locationData['address']?.isNotEmpty == true &&
                _locationData['city']?.isNotEmpty == true &&
                _locationData['state']?.isNotEmpty == true &&
                _locationData['zipCode']?.isNotEmpty == true));
  }

  void _nextStep() {
    if (_currentStep < _totalSteps - 1 && _canProceedToNextStep()) {
      setState(() {
        _currentStep++;
      });
      _pageController.nextPage(
        duration: Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
      _saveDraft();
    }
  }

  void _previousStep() {
    if (_currentStep > 0) {
      setState(() {
        _currentStep--;
      });
      _pageController.previousPage(
        duration: Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  Future<void> _publishListing() async {
    if (!_canPublishListing()) return;

    setState(() {
      _isPublishing = true;
    });

    // Simulate publishing process
    await Future.delayed(Duration(seconds: 3));

    if (mounted) {
      // Show success dialog
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 20.w,
                height: 20.w,
                decoration: BoxDecoration(
                  color: AppTheme.lightTheme.colorScheme.tertiary
                      .withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: CustomIconWidget(
                    iconName: 'check_circle',
                    color: AppTheme.lightTheme.colorScheme.tertiary,
                    size: 48,
                  ),
                ),
              ),
              SizedBox(height: 3.h),
              Text(
                'Listing Published!',
                style: AppTheme.lightTheme.textTheme.headlineSmall?.copyWith(
                  color: AppTheme.lightTheme.colorScheme.onSurface,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 2.h),
              Text(
                'Your vehicle listing is now live and visible to potential buyers.',
                style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                  color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 3.h),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                        Navigator.pushNamed(context, '/home-screen');
                      },
                      child: Text('View Listing'),
                    ),
                  ),
                  SizedBox(width: 3.w),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                        Navigator.pushNamed(context, '/home-screen');
                      },
                      child: Text('Done'),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      );
    }

    setState(() {
      _isPublishing = false;
    });
  }

  void _previewListing() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        height: 90.h,
        decoration: BoxDecoration(
          color: AppTheme.lightTheme.colorScheme.surface,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.all(4.w),
              decoration: BoxDecoration(
                color: AppTheme.lightTheme.colorScheme.surface,
                borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                boxShadow: [
                  BoxShadow(
                    color: AppTheme.lightTheme.colorScheme.shadow,
                    blurRadius: 4,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              child: Row(
                children: [
                  CustomIconWidget(
                    iconName: 'visibility',
                    color: AppTheme.lightTheme.colorScheme.primary,
                    size: 24,
                  ),
                  SizedBox(width: 2.w),
                  Text(
                    'Listing Preview',
                    style: AppTheme.lightTheme.textTheme.titleMedium,
                  ),
                  Spacer(),
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: CustomIconWidget(
                      iconName: 'close',
                      color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
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
                    // Preview content would go here
                    if (_selectedPhotos.isNotEmpty)
                      Container(
                        height: 25.h,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          color: AppTheme.lightTheme.colorScheme.outline
                              .withValues(alpha: 0.1),
                        ),
                        child: Center(
                          child: Text(
                            'Photo Preview',
                            style: AppTheme.lightTheme.textTheme.bodyLarge,
                          ),
                        ),
                      ),
                    SizedBox(height: 2.h),
                    Text(
                      '${_vehicleDetails['year']} ${_vehicleDetails['make']} ${_vehicleDetails['model']}',
                      style: AppTheme.lightTheme.textTheme.headlineSmall,
                    ),
                    SizedBox(height: 1.h),
                    Text(
                      '\$${_pricingData['price']?.toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},') ?? '0'}',
                      style: AppTheme.lightTheme.textTheme.headlineMedium
                          ?.copyWith(
                        color: AppTheme.lightTheme.colorScheme.primary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 2.h),
                    Text(
                      'Description',
                      style: AppTheme.lightTheme.textTheme.titleMedium,
                    ),
                    SizedBox(height: 1.h),
                    Text(
                      _aiDescription,
                      style: AppTheme.lightTheme.textTheme.bodyMedium,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<bool> _onWillPop() async {
    if (_selectedPhotos.isNotEmpty ||
        _vehicleDetails.isNotEmpty ||
        _aiDescription.isNotEmpty) {
      final result = await showDialog<bool>(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Unsaved Changes'),
          content: Text(
              'You have unsaved changes. Do you want to save as draft before leaving?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: Text('Discard'),
            ),
            TextButton(
              onPressed: () async {
                Navigator.of(context).pop(true);
                await _saveDraft();
              },
              child: Text('Save Draft'),
            ),
          ],
        ),
      );
      return result ?? false;
    }
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        backgroundColor: AppTheme.lightTheme.scaffoldBackgroundColor,
        appBar: AppBar(
          title: Text('Sell Your Vehicle'),
          leading: IconButton(
            onPressed: () async {
              if (await _onWillPop()) {
                Navigator.pop(context);
              }
            },
            icon: CustomIconWidget(
              iconName: 'arrow_back',
              color: AppTheme.lightTheme.colorScheme.onSurface,
              size: 24,
            ),
          ),
          actions: [
            if (!_isDraftSaved &&
                (_selectedPhotos.isNotEmpty || _vehicleDetails.isNotEmpty))
              TextButton.icon(
                onPressed: _saveDraft,
                icon: CustomIconWidget(
                  iconName: 'save',
                  color: AppTheme.lightTheme.colorScheme.primary,
                  size: 16,
                ),
                label: Text('Save Draft'),
              ),
            if (_canPublishListing())
              TextButton.icon(
                onPressed: _previewListing,
                icon: CustomIconWidget(
                  iconName: 'visibility',
                  color: AppTheme.lightTheme.colorScheme.primary,
                  size: 16,
                ),
                label: Text('Preview'),
              ),
          ],
        ),
        body: Column(
          children: [
            // Progress Indicator
            ProgressIndicatorWidget(
              currentStep: _currentStep,
              totalSteps: _totalSteps,
              stepLabels: _stepLabels,
            ),

            // Form Content
            Expanded(
              child: PageView(
                controller: _pageController,
                physics: NeverScrollableScrollPhysics(),
                children: [
                  // Step 1: Photos
                  SingleChildScrollView(
                    padding: EdgeInsets.all(4.w),
                    child: PhotoUploadWidget(
                      selectedPhotos: _selectedPhotos,
                      onPhotosChanged: (photos) {
                        setState(() {
                          _selectedPhotos = photos;
                        });
                      },
                    ),
                  ),

                  // Step 2: Vehicle Details
                  SingleChildScrollView(
                    padding: EdgeInsets.all(4.w),
                    child: VehicleDetailsFormWidget(
                      vehicleDetails: _vehicleDetails,
                      onDetailsChanged: (details) {
                        setState(() {
                          _vehicleDetails = details;
                        });
                      },
                    ),
                  ),

                  // Step 3: AI Description
                  SingleChildScrollView(
                    padding: EdgeInsets.all(4.w),
                    child: AiDescriptionWidget(
                      description: _aiDescription,
                      vehicleDetails: _vehicleDetails,
                      hasPhotos: _selectedPhotos.isNotEmpty,
                      onDescriptionChanged: (description) {
                        setState(() {
                          _aiDescription = description;
                        });
                      },
                    ),
                  ),

                  // Step 4: Pricing
                  SingleChildScrollView(
                    padding: EdgeInsets.all(4.w),
                    child: PricingSectionWidget(
                      pricingData: _pricingData,
                      vehicleDetails: _vehicleDetails,
                      onPricingChanged: (pricing) {
                        setState(() {
                          _pricingData = pricing;
                        });
                      },
                    ),
                  ),

                  // Step 5: Location
                  SingleChildScrollView(
                    padding: EdgeInsets.all(4.w),
                    child: LocationSelectionWidget(
                      locationData: _locationData,
                      onLocationChanged: (location) {
                        setState(() {
                          _locationData = location;
                        });
                      },
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),

        // Bottom Navigation
        bottomNavigationBar: Container(
          padding: EdgeInsets.all(4.w),
          decoration: BoxDecoration(
            color: AppTheme.lightTheme.colorScheme.surface,
            boxShadow: [
              BoxShadow(
                color: AppTheme.lightTheme.colorScheme.shadow,
                blurRadius: 8,
                offset: Offset(0, -2),
              ),
            ],
          ),
          child: SafeArea(
            child: Row(
              children: [
                if (_currentStep > 0)
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: _previousStep,
                      icon: CustomIconWidget(
                        iconName: 'arrow_back',
                        color: AppTheme.lightTheme.colorScheme.primary,
                        size: 16,
                      ),
                      label: Text('Previous'),
                    ),
                  ),
                if (_currentStep > 0) SizedBox(width: 3.w),
                Expanded(
                  flex: 2,
                  child: _currentStep < _totalSteps - 1
                      ? ElevatedButton.icon(
                          onPressed: _canProceedToNextStep() ? _nextStep : null,
                          icon: CustomIconWidget(
                            iconName: 'arrow_forward',
                            color: _canProceedToNextStep()
                                ? AppTheme.lightTheme.colorScheme.onPrimary
                                : AppTheme.lightTheme.colorScheme.onSurface
                                    .withValues(alpha: 0.38),
                            size: 16,
                          ),
                          label: Text('Next'),
                        )
                      : ElevatedButton.icon(
                          onPressed: _canPublishListing() && !_isPublishing
                              ? _publishListing
                              : null,
                          icon: _isPublishing
                              ? SizedBox(
                                  width: 16,
                                  height: 16,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    color: AppTheme
                                        .lightTheme.colorScheme.onPrimary,
                                  ),
                                )
                              : CustomIconWidget(
                                  iconName: 'publish',
                                  color: _canPublishListing()
                                      ? AppTheme
                                          .lightTheme.colorScheme.onPrimary
                                      : AppTheme
                                          .lightTheme.colorScheme.onSurface
                                          .withValues(alpha: 0.38),
                                  size: 16,
                                ),
                          label: Text(_isPublishing
                              ? 'Publishing...'
                              : 'Publish Listing'),
                        ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }
}
