import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class LocationSelectionWidget extends StatefulWidget {
  final Function(Map<String, dynamic>) onLocationChanged;
  final Map<String, dynamic> locationData;

  const LocationSelectionWidget({
    Key? key,
    required this.onLocationChanged,
    required this.locationData,
  }) : super(key: key);

  @override
  State<LocationSelectionWidget> createState() =>
      _LocationSelectionWidgetState();
}

class _LocationSelectionWidgetState extends State<LocationSelectionWidget> {
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _cityController = TextEditingController();
  final TextEditingController _stateController = TextEditingController();
  final TextEditingController _zipController = TextEditingController();

  bool _useCurrentLocation = true;
  bool _isGettingLocation = false;
  String? _currentLocationText;

  @override
  void initState() {
    super.initState();
    _initializeLocation();
  }

  void _initializeLocation() {
    _addressController.text = widget.locationData['address'] ?? '';
    _cityController.text = widget.locationData['city'] ?? '';
    _stateController.text = widget.locationData['state'] ?? '';
    _zipController.text = widget.locationData['zipCode'] ?? '';
    _useCurrentLocation = widget.locationData['useCurrentLocation'] ?? true;
    _currentLocationText = widget.locationData['currentLocationText'];

    if (_useCurrentLocation && _currentLocationText == null) {
      _getCurrentLocation();
    }
  }

  Future<void> _getCurrentLocation() async {
    setState(() {
      _isGettingLocation = true;
    });

    // Simulate GPS location fetch
    await Future.delayed(Duration(seconds: 2));

    // Mock location data
    final mockLocations = [
      'Los Angeles, CA 90210',
      'New York, NY 10001',
      'Chicago, IL 60601',
      'Houston, TX 77001',
      'Phoenix, AZ 85001',
      'Philadelphia, PA 19101',
      'San Antonio, TX 78201',
      'San Diego, CA 92101',
      'Dallas, TX 75201',
      'San Jose, CA 95101',
    ];

    final location =
        mockLocations[DateTime.now().millisecond % mockLocations.length];

    setState(() {
      _currentLocationText = location;
      _isGettingLocation = false;
    });

    _updateLocationData();
  }

  void _updateLocationData() {
    final data = {
      'useCurrentLocation': _useCurrentLocation,
      'currentLocationText': _currentLocationText,
      'address': _addressController.text,
      'city': _cityController.text,
      'state': _stateController.text,
      'zipCode': _zipController.text,
    };
    widget.onLocationChanged(data);
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
                iconName: 'location_on',
                color: AppTheme.lightTheme.colorScheme.primary,
                size: 24,
              ),
              SizedBox(width: 2.w),
              Text(
                'Vehicle Location',
                style: AppTheme.lightTheme.textTheme.titleMedium,
              ),
            ],
          ),
          SizedBox(height: 3.h),

          // Current Location Toggle
          Container(
            padding: EdgeInsets.all(3.w),
            decoration: BoxDecoration(
              color: _useCurrentLocation
                  ? AppTheme.lightTheme.colorScheme.primary
                      .withValues(alpha: 0.1)
                  : AppTheme.lightTheme.colorScheme.outline
                      .withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: _useCurrentLocation
                    ? AppTheme.lightTheme.colorScheme.primary
                        .withValues(alpha: 0.3)
                    : AppTheme.lightTheme.colorScheme.outline
                        .withValues(alpha: 0.3),
              ),
            ),
            child: Row(
              children: [
                CustomIconWidget(
                  iconName: 'my_location',
                  color: _useCurrentLocation
                      ? AppTheme.lightTheme.colorScheme.primary
                      : AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                  size: 20,
                ),
                SizedBox(width: 3.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Use Current Location',
                        style:
                            AppTheme.lightTheme.textTheme.titleSmall?.copyWith(
                          color: _useCurrentLocation
                              ? AppTheme.lightTheme.colorScheme.primary
                              : AppTheme.lightTheme.colorScheme.onSurface,
                        ),
                      ),
                      if (_isGettingLocation)
                        Text(
                          'Getting your location...',
                          style:
                              AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                            color: AppTheme
                                .lightTheme.colorScheme.onSurfaceVariant,
                          ),
                        )
                      else if (_currentLocationText != null &&
                          _useCurrentLocation)
                        Text(
                          _currentLocationText!,
                          style:
                              AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                            color: AppTheme
                                .lightTheme.colorScheme.onSurfaceVariant,
                          ),
                        )
                      else
                        Text(
                          'Automatically detect your location',
                          style:
                              AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                            color: AppTheme
                                .lightTheme.colorScheme.onSurfaceVariant,
                          ),
                        ),
                    ],
                  ),
                ),
                Switch(
                  value: _useCurrentLocation,
                  onChanged: (value) {
                    setState(() {
                      _useCurrentLocation = value;
                    });
                    if (value && _currentLocationText == null) {
                      _getCurrentLocation();
                    }
                    _updateLocationData();
                  },
                ),
              ],
            ),
          ),

          if (_isGettingLocation) ...[
            SizedBox(height: 2.h),
            Center(
              child: CircularProgressIndicator(
                color: AppTheme.lightTheme.colorScheme.primary,
              ),
            ),
          ],

          if (!_useCurrentLocation) ...[
            SizedBox(height: 3.h),
            Text(
              'Manual Address Entry',
              style: AppTheme.lightTheme.textTheme.titleSmall,
            ),
            SizedBox(height: 2.h),

            // Street Address
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Street Address *',
                  style: AppTheme.lightTheme.textTheme.labelMedium,
                ),
                SizedBox(height: 1.h),
                TextFormField(
                  controller: _addressController,
                  decoration: InputDecoration(
                    hintText: '123 Main Street',
                    prefixIcon: Padding(
                      padding: EdgeInsets.all(3.w),
                      child: CustomIconWidget(
                        iconName: 'home',
                        color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                        size: 20,
                      ),
                    ),
                  ),
                  onChanged: (value) => _updateLocationData(),
                ),
              ],
            ),
            SizedBox(height: 2.h),

            // City and State Row
            Row(
              children: [
                Expanded(
                  flex: 2,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'City *',
                        style: AppTheme.lightTheme.textTheme.labelMedium,
                      ),
                      SizedBox(height: 1.h),
                      TextFormField(
                        controller: _cityController,
                        decoration: InputDecoration(
                          hintText: 'Los Angeles',
                          prefixIcon: Padding(
                            padding: EdgeInsets.all(3.w),
                            child: CustomIconWidget(
                              iconName: 'location_city',
                              color: AppTheme
                                  .lightTheme.colorScheme.onSurfaceVariant,
                              size: 20,
                            ),
                          ),
                        ),
                        onChanged: (value) => _updateLocationData(),
                      ),
                    ],
                  ),
                ),
                SizedBox(width: 3.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'State *',
                        style: AppTheme.lightTheme.textTheme.labelMedium,
                      ),
                      SizedBox(height: 1.h),
                      TextFormField(
                        controller: _stateController,
                        textCapitalization: TextCapitalization.characters,
                        decoration: InputDecoration(
                          hintText: 'CA',
                          prefixIcon: Padding(
                            padding: EdgeInsets.all(3.w),
                            child: CustomIconWidget(
                              iconName: 'map',
                              color: AppTheme
                                  .lightTheme.colorScheme.onSurfaceVariant,
                              size: 20,
                            ),
                          ),
                        ),
                        onChanged: (value) => _updateLocationData(),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: 2.h),

            // ZIP Code
            SizedBox(
              width: 40.w,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'ZIP Code *',
                    style: AppTheme.lightTheme.textTheme.labelMedium,
                  ),
                  SizedBox(height: 1.h),
                  TextFormField(
                    controller: _zipController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      hintText: '90210',
                      prefixIcon: Padding(
                        padding: EdgeInsets.all(3.w),
                        child: CustomIconWidget(
                          iconName: 'local_post_office',
                          color:
                              AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                          size: 20,
                        ),
                      ),
                    ),
                    onChanged: (value) => _updateLocationData(),
                  ),
                ],
              ),
            ),
          ],

          SizedBox(height: 3.h),
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
                  iconName: 'info',
                  color: AppTheme.lightTheme.colorScheme.tertiary,
                  size: 16,
                ),
                SizedBox(width: 2.w),
                Expanded(
                  child: Text(
                    'Your exact address won\'t be shared publicly. Only city and state will be visible to buyers.',
                    style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                      color: AppTheme.lightTheme.colorScheme.tertiary,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _addressController.dispose();
    _cityController.dispose();
    _stateController.dispose();
    _zipController.dispose();
    super.dispose();
  }
}
