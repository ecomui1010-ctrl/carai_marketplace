import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class FilterModalWidget extends StatefulWidget {
  final Map<String, dynamic> currentFilters;
  final Function(Map<String, dynamic>) onApplyFilters;

  const FilterModalWidget({
    Key? key,
    required this.currentFilters,
    required this.onApplyFilters,
  }) : super(key: key);

  @override
  State<FilterModalWidget> createState() => _FilterModalWidgetState();
}

class _FilterModalWidgetState extends State<FilterModalWidget> {
  late Map<String, dynamic> _filters;
  RangeValues _priceRange = RangeValues(5000, 50000);
  RangeValues _mileageRange = RangeValues(0, 100000);
  double _locationRadius = 25;

  @override
  void initState() {
    super.initState();
    _filters = Map.from(widget.currentFilters);
    _priceRange = RangeValues(
      (_filters['minPrice'] ?? 5000).toDouble(),
      (_filters['maxPrice'] ?? 50000).toDouble(),
    );
    _mileageRange = RangeValues(
      (_filters['minMileage'] ?? 0).toDouble(),
      (_filters['maxMileage'] ?? 100000).toDouble(),
    );
    _locationRadius = (_filters['locationRadius'] ?? 25).toDouble();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 90.h,
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.surface,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        children: [
          _buildHeader(),
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.all(4.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildMakeModelSection(),
                  SizedBox(height: 3.h),
                  _buildPriceRangeSection(),
                  SizedBox(height: 3.h),
                  _buildMileageSection(),
                  SizedBox(height: 3.h),
                  _buildFuelTypeSection(),
                  SizedBox(height: 3.h),
                  _buildLocationSection(),
                  SizedBox(height: 3.h),
                  _buildAdvancedFiltersSection(),
                ],
              ),
            ),
          ),
          _buildBottomActions(),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: AppTheme.lightTheme.colorScheme.outline,
            width: 1,
          ),
        ),
      ),
      child: Row(
        children: [
          GestureDetector(
            onTap: () => Navigator.pop(context),
            child: CustomIconWidget(
              iconName: 'close',
              color: AppTheme.lightTheme.colorScheme.onSurface,
              size: 6.w,
            ),
          ),
          SizedBox(width: 4.w),
          Expanded(
            child: Text(
              'Filters',
              style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          TextButton(
            onPressed: _clearAllFilters,
            child: Text(
              'Clear All',
              style: AppTheme.lightTheme.textTheme.labelLarge?.copyWith(
                color: AppTheme.lightTheme.colorScheme.primary,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMakeModelSection() {
    return _buildExpandableSection(
      title: 'Make & Model',
      child: Column(
        children: [
          _buildFilterChipGroup(
            'Make',
            ['Toyota', 'Honda', 'BMW', 'Mercedes', 'Audi', 'Ford'],
            _filters['makes'] ?? [],
          ),
          SizedBox(height: 2.h),
          _buildFilterChipGroup(
            'Model',
            ['Camry', 'Accord', 'X3', 'C-Class', 'A4', 'F-150'],
            _filters['models'] ?? [],
          ),
        ],
      ),
    );
  }

  Widget _buildPriceRangeSection() {
    return _buildExpandableSection(
      title: 'Price Range',
      child: Column(
        children: [
          RangeSlider(
            values: _priceRange,
            min: 0,
            max: 100000,
            divisions: 100,
            labels: RangeLabels(
              '\$${_priceRange.start.round()}',
              '\$${_priceRange.end.round()}',
            ),
            onChanged: (values) {
              setState(() => _priceRange = values);
            },
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '\$${_priceRange.start.round()}',
                style: AppTheme.lightTheme.textTheme.bodyMedium,
              ),
              Text(
                '\$${_priceRange.end.round()}',
                style: AppTheme.lightTheme.textTheme.bodyMedium,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMileageSection() {
    return _buildExpandableSection(
      title: 'Mileage',
      child: Column(
        children: [
          RangeSlider(
            values: _mileageRange,
            min: 0,
            max: 200000,
            divisions: 100,
            labels: RangeLabels(
              '${_mileageRange.start.round()}',
              '${_mileageRange.end.round()}',
            ),
            onChanged: (values) {
              setState(() => _mileageRange = values);
            },
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '${_mileageRange.start.round()} miles',
                style: AppTheme.lightTheme.textTheme.bodyMedium,
              ),
              Text(
                '${_mileageRange.end.round()} miles',
                style: AppTheme.lightTheme.textTheme.bodyMedium,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildFuelTypeSection() {
    return _buildExpandableSection(
      title: 'Fuel Type',
      child: _buildFilterChipGroup(
        '',
        ['Gasoline', 'Diesel', 'Hybrid', 'Electric'],
        _filters['fuelTypes'] ?? [],
      ),
    );
  }

  Widget _buildLocationSection() {
    return _buildExpandableSection(
      title: 'Location',
      child: Column(
        children: [
          Text(
            'Search radius: ${_locationRadius.round()} miles',
            style: AppTheme.lightTheme.textTheme.bodyMedium,
          ),
          Slider(
            value: _locationRadius,
            min: 5,
            max: 100,
            divisions: 19,
            onChanged: (value) {
              setState(() => _locationRadius = value);
            },
          ),
        ],
      ),
    );
  }

  Widget _buildAdvancedFiltersSection() {
    return _buildExpandableSection(
      title: 'Advanced Filters',
      child: Column(
        children: [
          CheckboxListTile(
            title: Text('Clean ownership history'),
            value: _filters['cleanHistory'] ?? false,
            onChanged: (value) {
              setState(() => _filters['cleanHistory'] = value);
            },
          ),
          CheckboxListTile(
            title: Text('No accident reports'),
            value: _filters['noAccidents'] ?? false,
            onChanged: (value) {
              setState(() => _filters['noAccidents'] = value);
            },
          ),
          CheckboxListTile(
            title: Text('Single owner'),
            value: _filters['singleOwner'] ?? false,
            onChanged: (value) {
              setState(() => _filters['singleOwner'] = value);
            },
          ),
        ],
      ),
    );
  }

  Widget _buildExpandableSection(
      {required String title, required Widget child}) {
    return ExpansionTile(
      title: Text(
        title,
        style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
          fontWeight: FontWeight.w600,
        ),
      ),
      children: [
        Padding(
          padding: EdgeInsets.all(2.w),
          child: child,
        ),
      ],
    );
  }

  Widget _buildFilterChipGroup(
      String label, List<String> options, List<dynamic> selected) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (label.isNotEmpty) ...[
          Text(
            label,
            style: AppTheme.lightTheme.textTheme.labelLarge,
          ),
          SizedBox(height: 1.h),
        ],
        Wrap(
          spacing: 2.w,
          runSpacing: 1.h,
          children: options.map((option) {
            final isSelected = selected.contains(option);
            return GestureDetector(
              onTap: () {
                setState(() {
                  if (isSelected) {
                    selected.remove(option);
                  } else {
                    selected.add(option);
                  }
                });
              },
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
                decoration: BoxDecoration(
                  color: isSelected
                      ? AppTheme.lightTheme.colorScheme.primary
                          .withValues(alpha: 0.1)
                      : AppTheme.lightTheme.colorScheme.surface,
                  border: Border.all(
                    color: isSelected
                        ? AppTheme.lightTheme.colorScheme.primary
                        : AppTheme.lightTheme.colorScheme.outline,
                  ),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  option,
                  style: AppTheme.lightTheme.textTheme.labelMedium?.copyWith(
                    color: isSelected
                        ? AppTheme.lightTheme.colorScheme.primary
                        : AppTheme.lightTheme.colorScheme.onSurface,
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildBottomActions() {
    return Container(
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(
            color: AppTheme.lightTheme.colorScheme.outline,
            width: 1,
          ),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: OutlinedButton(
              onPressed: _clearAllFilters,
              child: Text('Clear All'),
            ),
          ),
          SizedBox(width: 4.w),
          Expanded(
            flex: 2,
            child: ElevatedButton(
              onPressed: _applyFilters,
              child: Text('Apply Filters'),
            ),
          ),
        ],
      ),
    );
  }

  void _clearAllFilters() {
    setState(() {
      _filters.clear();
      _priceRange = RangeValues(5000, 50000);
      _mileageRange = RangeValues(0, 100000);
      _locationRadius = 25;
    });
  }

  void _applyFilters() {
    final updatedFilters = Map<String, dynamic>.from(_filters);
    updatedFilters['minPrice'] = _priceRange.start.round();
    updatedFilters['maxPrice'] = _priceRange.end.round();
    updatedFilters['minMileage'] = _mileageRange.start.round();
    updatedFilters['maxMileage'] = _mileageRange.end.round();
    updatedFilters['locationRadius'] = _locationRadius.round();

    widget.onApplyFilters(updatedFilters);
    Navigator.pop(context);
  }
}
