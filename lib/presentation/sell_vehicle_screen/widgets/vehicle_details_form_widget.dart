import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class VehicleDetailsFormWidget extends StatefulWidget {
  final Function(Map<String, dynamic>) onDetailsChanged;
  final Map<String, dynamic> vehicleDetails;

  const VehicleDetailsFormWidget({
    Key? key,
    required this.onDetailsChanged,
    required this.vehicleDetails,
  }) : super(key: key);

  @override
  State<VehicleDetailsFormWidget> createState() =>
      _VehicleDetailsFormWidgetState();
}

class _VehicleDetailsFormWidgetState extends State<VehicleDetailsFormWidget> {
  final TextEditingController _makeController = TextEditingController();
  final TextEditingController _modelController = TextEditingController();
  final TextEditingController _yearController = TextEditingController();
  final TextEditingController _mileageController = TextEditingController();
  final TextEditingController _vinController = TextEditingController();

  String? _selectedFuelType;
  String? _selectedTransmission;
  String? _selectedCondition;
  String? _selectedBodyType;

  final List<String> _carMakes = [
    'Toyota',
    'Honda',
    'Ford',
    'Chevrolet',
    'BMW',
    'Mercedes-Benz',
    'Audi',
    'Volkswagen',
    'Nissan',
    'Hyundai',
    'Kia',
    'Mazda',
    'Subaru',
    'Lexus',
    'Acura',
    'Infiniti',
    'Cadillac',
    'Lincoln',
    'Buick',
    'GMC',
    'Jeep',
    'Ram',
    'Dodge',
    'Chrysler'
  ];

  final Map<String, List<String>> _carModels = {
    'Toyota': [
      'Camry',
      'Corolla',
      'RAV4',
      'Highlander',
      'Prius',
      'Tacoma',
      'Tundra',
      '4Runner'
    ],
    'Honda': [
      'Civic',
      'Accord',
      'CR-V',
      'Pilot',
      'Odyssey',
      'Ridgeline',
      'Passport',
      'HR-V'
    ],
    'Ford': [
      'F-150',
      'Mustang',
      'Explorer',
      'Escape',
      'Edge',
      'Expedition',
      'Ranger',
      'Bronco'
    ],
    'Chevrolet': [
      'Silverado',
      'Equinox',
      'Malibu',
      'Tahoe',
      'Suburban',
      'Traverse',
      'Camaro',
      'Corvette'
    ],
    'BMW': ['3 Series', '5 Series', 'X3', 'X5', 'X1', '7 Series', 'X7', 'i4'],
    'Mercedes-Benz': [
      'C-Class',
      'E-Class',
      'S-Class',
      'GLC',
      'GLE',
      'GLS',
      'A-Class',
      'CLA'
    ],
  };

  final List<String> _fuelTypes = [
    'Gasoline',
    'Diesel',
    'Hybrid',
    'Electric',
    'Plug-in Hybrid'
  ];
  final List<String> _transmissions = ['Automatic', 'Manual', 'CVT'];
  final List<String> _conditions = [
    'Excellent',
    'Very Good',
    'Good',
    'Fair',
    'Poor'
  ];
  final List<String> _bodyTypes = [
    'Sedan',
    'SUV',
    'Truck',
    'Coupe',
    'Convertible',
    'Wagon',
    'Hatchback',
    'Van'
  ];

  @override
  void initState() {
    super.initState();
    _initializeControllers();
  }

  void _initializeControllers() {
    _makeController.text = widget.vehicleDetails['make'] ?? '';
    _modelController.text = widget.vehicleDetails['model'] ?? '';
    _yearController.text = widget.vehicleDetails['year']?.toString() ?? '';
    _mileageController.text =
        widget.vehicleDetails['mileage']?.toString() ?? '';
    _vinController.text = widget.vehicleDetails['vin'] ?? '';
    _selectedFuelType = widget.vehicleDetails['fuelType'];
    _selectedTransmission = widget.vehicleDetails['transmission'];
    _selectedCondition = widget.vehicleDetails['condition'];
    _selectedBodyType = widget.vehicleDetails['bodyType'];
  }

  void _updateDetails() {
    final details = {
      'make': _makeController.text,
      'model': _modelController.text,
      'year': int.tryParse(_yearController.text),
      'mileage': int.tryParse(_mileageController.text),
      'vin': _vinController.text,
      'fuelType': _selectedFuelType,
      'transmission': _selectedTransmission,
      'condition': _selectedCondition,
      'bodyType': _selectedBodyType,
    };
    widget.onDetailsChanged(details);
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
                iconName: 'directions_car',
                color: AppTheme.lightTheme.colorScheme.primary,
                size: 24,
              ),
              SizedBox(width: 2.w),
              Text(
                'Vehicle Details',
                style: AppTheme.lightTheme.textTheme.titleMedium,
              ),
            ],
          ),
          SizedBox(height: 3.h),

          // Make and Model Row
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Make *',
                      style: AppTheme.lightTheme.textTheme.labelMedium,
                    ),
                    SizedBox(height: 1.h),
                    DropdownButtonFormField<String>(
                      value: _makeController.text.isNotEmpty
                          ? _makeController.text
                          : null,
                      decoration: InputDecoration(
                        hintText: 'Select make',
                        prefixIcon: Padding(
                          padding: EdgeInsets.all(3.w),
                          child: CustomIconWidget(
                            iconName: 'business',
                            color: AppTheme
                                .lightTheme.colorScheme.onSurfaceVariant,
                            size: 20,
                          ),
                        ),
                      ),
                      items: _carMakes.map((make) {
                        return DropdownMenuItem(
                          value: make,
                          child: Text(make),
                        );
                      }).toList(),
                      onChanged: (value) {
                        setState(() {
                          _makeController.text = value ?? '';
                          _modelController.clear();
                        });
                        _updateDetails();
                      },
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
                      'Model *',
                      style: AppTheme.lightTheme.textTheme.labelMedium,
                    ),
                    SizedBox(height: 1.h),
                    DropdownButtonFormField<String>(
                      value: _modelController.text.isNotEmpty
                          ? _modelController.text
                          : null,
                      decoration: InputDecoration(
                        hintText: 'Select model',
                        prefixIcon: Padding(
                          padding: EdgeInsets.all(3.w),
                          child: CustomIconWidget(
                            iconName: 'car_rental',
                            color: AppTheme
                                .lightTheme.colorScheme.onSurfaceVariant,
                            size: 20,
                          ),
                        ),
                      ),
                      items: _makeController.text.isNotEmpty &&
                              _carModels.containsKey(_makeController.text)
                          ? _carModels[_makeController.text]!.map((model) {
                              return DropdownMenuItem(
                                value: model,
                                child: Text(model),
                              );
                            }).toList()
                          : [],
                      onChanged: _makeController.text.isNotEmpty
                          ? (value) {
                              setState(() {
                                _modelController.text = value ?? '';
                              });
                              _updateDetails();
                            }
                          : null,
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 2.h),

          // Year and Mileage Row
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Year *',
                      style: AppTheme.lightTheme.textTheme.labelMedium,
                    ),
                    SizedBox(height: 1.h),
                    TextFormField(
                      controller: _yearController,
                      keyboardType: TextInputType.number,
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,
                        LengthLimitingTextInputFormatter(4),
                      ],
                      decoration: InputDecoration(
                        hintText: '2020',
                        prefixIcon: Padding(
                          padding: EdgeInsets.all(3.w),
                          child: CustomIconWidget(
                            iconName: 'calendar_today',
                            color: AppTheme
                                .lightTheme.colorScheme.onSurfaceVariant,
                            size: 20,
                          ),
                        ),
                      ),
                      onChanged: (value) => _updateDetails(),
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
                      'Mileage *',
                      style: AppTheme.lightTheme.textTheme.labelMedium,
                    ),
                    SizedBox(height: 1.h),
                    TextFormField(
                      controller: _mileageController,
                      keyboardType: TextInputType.number,
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                      decoration: InputDecoration(
                        hintText: '50,000',
                        suffixText: 'miles',
                        prefixIcon: Padding(
                          padding: EdgeInsets.all(3.w),
                          child: CustomIconWidget(
                            iconName: 'speed',
                            color: AppTheme
                                .lightTheme.colorScheme.onSurfaceVariant,
                            size: 20,
                          ),
                        ),
                      ),
                      onChanged: (value) => _updateDetails(),
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 2.h),

          // Body Type and Fuel Type Row
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Body Type *',
                      style: AppTheme.lightTheme.textTheme.labelMedium,
                    ),
                    SizedBox(height: 1.h),
                    DropdownButtonFormField<String>(
                      value: _selectedBodyType,
                      decoration: InputDecoration(
                        hintText: 'Select type',
                        prefixIcon: Padding(
                          padding: EdgeInsets.all(3.w),
                          child: CustomIconWidget(
                            iconName: 'category',
                            color: AppTheme
                                .lightTheme.colorScheme.onSurfaceVariant,
                            size: 20,
                          ),
                        ),
                      ),
                      items: _bodyTypes.map((type) {
                        return DropdownMenuItem(
                          value: type,
                          child: Text(type),
                        );
                      }).toList(),
                      onChanged: (value) {
                        setState(() {
                          _selectedBodyType = value;
                        });
                        _updateDetails();
                      },
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
                      'Fuel Type *',
                      style: AppTheme.lightTheme.textTheme.labelMedium,
                    ),
                    SizedBox(height: 1.h),
                    DropdownButtonFormField<String>(
                      value: _selectedFuelType,
                      decoration: InputDecoration(
                        hintText: 'Select fuel',
                        prefixIcon: Padding(
                          padding: EdgeInsets.all(3.w),
                          child: CustomIconWidget(
                            iconName: 'local_gas_station',
                            color: AppTheme
                                .lightTheme.colorScheme.onSurfaceVariant,
                            size: 20,
                          ),
                        ),
                      ),
                      items: _fuelTypes.map((fuel) {
                        return DropdownMenuItem(
                          value: fuel,
                          child: Text(fuel),
                        );
                      }).toList(),
                      onChanged: (value) {
                        setState(() {
                          _selectedFuelType = value;
                        });
                        _updateDetails();
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 2.h),

          // Transmission and Condition Row
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Transmission *',
                      style: AppTheme.lightTheme.textTheme.labelMedium,
                    ),
                    SizedBox(height: 1.h),
                    DropdownButtonFormField<String>(
                      value: _selectedTransmission,
                      decoration: InputDecoration(
                        hintText: 'Select transmission',
                        prefixIcon: Padding(
                          padding: EdgeInsets.all(3.w),
                          child: CustomIconWidget(
                            iconName: 'settings',
                            color: AppTheme
                                .lightTheme.colorScheme.onSurfaceVariant,
                            size: 20,
                          ),
                        ),
                      ),
                      items: _transmissions.map((transmission) {
                        return DropdownMenuItem(
                          value: transmission,
                          child: Text(transmission),
                        );
                      }).toList(),
                      onChanged: (value) {
                        setState(() {
                          _selectedTransmission = value;
                        });
                        _updateDetails();
                      },
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
                      'Condition *',
                      style: AppTheme.lightTheme.textTheme.labelMedium,
                    ),
                    SizedBox(height: 1.h),
                    DropdownButtonFormField<String>(
                      value: _selectedCondition,
                      decoration: InputDecoration(
                        hintText: 'Select condition',
                        prefixIcon: Padding(
                          padding: EdgeInsets.all(3.w),
                          child: CustomIconWidget(
                            iconName: 'star',
                            color: AppTheme
                                .lightTheme.colorScheme.onSurfaceVariant,
                            size: 20,
                          ),
                        ),
                      ),
                      items: _conditions.map((condition) {
                        return DropdownMenuItem(
                          value: condition,
                          child: Text(condition),
                        );
                      }).toList(),
                      onChanged: (value) {
                        setState(() {
                          _selectedCondition = value;
                        });
                        _updateDetails();
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 2.h),

          // VIN Number
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'VIN Number (Optional)',
                style: AppTheme.lightTheme.textTheme.labelMedium,
              ),
              SizedBox(height: 1.h),
              TextFormField(
                controller: _vinController,
                textCapitalization: TextCapitalization.characters,
                inputFormatters: [
                  LengthLimitingTextInputFormatter(17),
                  FilteringTextInputFormatter.allow(RegExp(r'[A-Z0-9]')),
                ],
                decoration: InputDecoration(
                  hintText: 'Enter 17-character VIN',
                  prefixIcon: Padding(
                    padding: EdgeInsets.all(3.w),
                    child: CustomIconWidget(
                      iconName: 'qr_code',
                      color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                      size: 20,
                    ),
                  ),
                ),
                onChanged: (value) => _updateDetails(),
              ),
            ],
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _makeController.dispose();
    _modelController.dispose();
    _yearController.dispose();
    _mileageController.dispose();
    _vinController.dispose();
    super.dispose();
  }
}
