import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import '../../services/car_data_service.dart';
import './widgets/saved_vehicle_card_widget.dart';

class SavedVehiclesScreen extends StatefulWidget {
  const SavedVehiclesScreen({super.key});

  @override
  State<SavedVehiclesScreen> createState() => _SavedVehiclesScreenState();
}

class _SavedVehiclesScreenState extends State<SavedVehiclesScreen> {
  final CarDataService _carDataService = CarDataService();
  List<Map<String, dynamic>> _savedVehicles = [];
  List<Map<String, dynamic>> _filteredVehicles = [];
  bool _isLoading = true;
  String _sortBy = 'Recently Added';
  String _filterBy = 'All';

  @override
  void initState() {
    super.initState();
    _loadSavedVehicles();
  }

  Future<void> _loadSavedVehicles() async {
    setState(() => _isLoading = true);

    // Simulate loading saved vehicles
    await Future.delayed(const Duration(seconds: 1));

    final vehicles = _carDataService.generateMultipleListings(12);

    setState(() {
      _savedVehicles = vehicles;
      _filteredVehicles = vehicles;
      _isLoading = false;
    });
  }

  void _filterVehicles() {
    List<Map<String, dynamic>> filtered = List.from(_savedVehicles);

    // Apply filter
    if (_filterBy != 'All') {
      filtered = filtered.where((vehicle) {
        switch (_filterBy) {
          case 'Recently Added':
            return vehicle['listedDate']
                .isAfter(DateTime.now().subtract(const Duration(days: 7)));
          case 'Under 50k':
            return vehicle['price'] < 50000;
          case 'Electric':
            return vehicle['fuelType'] == 'Electric';
          case 'Luxury':
            return ['BMW', 'Mercedes-Benz', 'Audi', 'Lexus']
                .contains(vehicle['make']);
          default:
            return true;
        }
      }).toList();
    }

    // Apply sort
    switch (_sortBy) {
      case 'Price: Low to High':
        filtered.sort((a, b) => a['price'].compareTo(b['price']));
        break;
      case 'Price: High to Low':
        filtered.sort((a, b) => b['price'].compareTo(a['price']));
        break;
      case 'Year: Newest First':
        filtered.sort((a, b) => b['year'].compareTo(a['year']));
        break;
      case 'Mileage: Low to High':
        filtered.sort((a, b) => a['mileage'].compareTo(b['mileage']));
        break;
      case 'Recently Added':
      default:
        filtered.sort((a, b) => b['listedDate'].compareTo(a['listedDate']));
        break;
    }

    setState(() => _filteredVehicles = filtered);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.lightTheme.scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text('Saved Vehicles'),
        backgroundColor: AppTheme.lightTheme.colorScheme.surface,
        elevation: 0,
        leading: IconButton(
          icon: CustomIconWidget(
            iconName: 'arrow_back',
            color: AppTheme.lightTheme.colorScheme.onSurface,
            size: 24,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            icon: CustomIconWidget(
              iconName: 'search',
              color: AppTheme.lightTheme.colorScheme.onSurface,
              size: 24,
            ),
            onPressed: _showSearchDialog,
          ),
          IconButton(
            icon: CustomIconWidget(
              iconName: 'more_vert',
              color: AppTheme.lightTheme.colorScheme.onSurface,
              size: 24,
            ),
            onPressed: _showOptionsMenu,
          ),
        ],
      ),
      body: Column(
        children: [
          _buildFilterBar(),
          Expanded(
            child: _isLoading ? _buildLoadingState() : _buildContent(),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterBar() {
    return Container(
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.surface,
        boxShadow: [
          BoxShadow(
            color: AppTheme.shadowLight,
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Text(
            '${_filteredVehicles.length} vehicles',
            style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          const Spacer(),
          GestureDetector(
            onTap: _showFilterDialog,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
              decoration: BoxDecoration(
                color: AppTheme.lightTheme.colorScheme.primary
                    .withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CustomIconWidget(
                    iconName: 'filter_list',
                    color: AppTheme.lightTheme.colorScheme.primary,
                    size: 16,
                  ),
                  SizedBox(width: 1.w),
                  Text(
                    _filterBy,
                    style: AppTheme.lightTheme.textTheme.labelMedium?.copyWith(
                      color: AppTheme.lightTheme.colorScheme.primary,
                    ),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(width: 2.w),
          GestureDetector(
            onTap: _showSortDialog,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
              decoration: BoxDecoration(
                border: Border.all(
                  color: AppTheme.lightTheme.colorScheme.outline
                      .withValues(alpha: 0.5),
                ),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CustomIconWidget(
                    iconName: 'sort',
                    color: AppTheme.lightTheme.colorScheme.onSurface,
                    size: 16,
                  ),
                  SizedBox(width: 1.w),
                  Text(
                    'Sort',
                    style: AppTheme.lightTheme.textTheme.labelMedium,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLoadingState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(
            color: AppTheme.lightTheme.colorScheme.primary,
          ),
          SizedBox(height: 2.h),
          Text(
            'Loading saved vehicles...',
            style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
              color: AppTheme.textSecondaryLight,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContent() {
    if (_filteredVehicles.isEmpty) {
      return _buildEmptyState();
    }

    return RefreshIndicator(
      onRefresh: _loadSavedVehicles,
      color: AppTheme.lightTheme.colorScheme.primary,
      child: ListView.builder(
        padding: EdgeInsets.all(4.w),
        itemCount: _filteredVehicles.length,
        itemBuilder: (context, index) {
          final vehicle = _filteredVehicles[index];
          return SavedVehicleCardWidget(
            vehicle: vehicle,
            onTap: () => _navigateToVehicleDetail(vehicle),
            onRemove: () => _removeSavedVehicle(vehicle['id']),
            onShare: () => _shareVehicle(vehicle),
          );
        },
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(8.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CustomIconWidget(
              iconName: 'favorite_border',
              color: AppTheme.textSecondaryLight,
              size: 80,
            ),
            SizedBox(height: 3.h),
            Text(
              'No Saved Vehicles',
              style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: 1.h),
            Text(
              'Start saving vehicles you\'re interested in to see them here',
              style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                color: AppTheme.textSecondaryLight,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 4.h),
            ElevatedButton.icon(
              onPressed: () => Navigator.pushNamed(context, '/search-screen'),
              icon: CustomIconWidget(
                iconName: 'search',
                color: Colors.white,
                size: 20,
              ),
              label: Text('Browse Vehicles'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.lightTheme.colorScheme.primary,
                foregroundColor: Colors.white,
                padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 1.5.h),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showSearchDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Search Saved Vehicles'),
        content: TextField(
          decoration: InputDecoration(
            hintText: 'Enter make, model, or keyword',
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          onChanged: (value) {
            // Implement search functionality
          },
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Search'),
          ),
        ],
      ),
    );
  }

  void _showFilterDialog() {
    final filters = [
      'All',
      'Recently Added',
      'Under 50k',
      'Electric',
      'Luxury'
    ];

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        decoration: BoxDecoration(
          color: AppTheme.lightTheme.colorScheme.surface,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 12.w,
              height: 0.5.h,
              margin: EdgeInsets.only(top: 2.h),
              decoration: BoxDecoration(
                color: AppTheme.dividerLight,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            SizedBox(height: 3.h),
            Text(
              'Filter By',
              style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: 2.h),
            ...filters.map((filter) => ListTile(
                  title: Text(filter),
                  trailing: _filterBy == filter
                      ? CustomIconWidget(
                          iconName: 'check',
                          color: AppTheme.lightTheme.colorScheme.primary,
                          size: 20,
                        )
                      : null,
                  onTap: () {
                    setState(() => _filterBy = filter);
                    _filterVehicles();
                    Navigator.pop(context);
                  },
                )),
            SizedBox(height: 2.h),
          ],
        ),
      ),
    );
  }

  void _showSortDialog() {
    final sorts = [
      'Recently Added',
      'Price: Low to High',
      'Price: High to Low',
      'Year: Newest First',
      'Mileage: Low to High'
    ];

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        decoration: BoxDecoration(
          color: AppTheme.lightTheme.colorScheme.surface,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 12.w,
              height: 0.5.h,
              margin: EdgeInsets.only(top: 2.h),
              decoration: BoxDecoration(
                color: AppTheme.dividerLight,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            SizedBox(height: 3.h),
            Text(
              'Sort By',
              style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: 2.h),
            ...sorts.map((sort) => ListTile(
                  title: Text(sort),
                  trailing: _sortBy == sort
                      ? CustomIconWidget(
                          iconName: 'check',
                          color: AppTheme.lightTheme.colorScheme.primary,
                          size: 20,
                        )
                      : null,
                  onTap: () {
                    setState(() => _sortBy = sort);
                    _filterVehicles();
                    Navigator.pop(context);
                  },
                )),
            SizedBox(height: 2.h),
          ],
        ),
      ),
    );
  }

  void _showOptionsMenu() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        decoration: BoxDecoration(
          color: AppTheme.lightTheme.colorScheme.surface,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 12.w,
              height: 0.5.h,
              margin: EdgeInsets.only(top: 2.h),
              decoration: BoxDecoration(
                color: AppTheme.dividerLight,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            SizedBox(height: 3.h),
            ListTile(
              leading: CustomIconWidget(
                iconName: 'select_all',
                color: AppTheme.lightTheme.colorScheme.primary,
                size: 24,
              ),
              title: Text('Select All'),
              onTap: () {
                Navigator.pop(context);
                _selectAllVehicles();
              },
            ),
            ListTile(
              leading: CustomIconWidget(
                iconName: 'delete_outline',
                color: Colors.red,
                size: 24,
              ),
              title: Text('Remove All'),
              onTap: () {
                Navigator.pop(context);
                _showRemoveAllDialog();
              },
            ),
            ListTile(
              leading: CustomIconWidget(
                iconName: 'share',
                color: AppTheme.lightTheme.colorScheme.primary,
                size: 24,
              ),
              title: Text('Export List'),
              onTap: () {
                Navigator.pop(context);
                _exportSavedVehicles();
              },
            ),
            SizedBox(height: 2.h),
          ],
        ),
      ),
    );
  }

  void _navigateToVehicleDetail(Map<String, dynamic> vehicle) {
    Navigator.pushNamed(
      context,
      '/vehicle-detail-screen',
      arguments: vehicle,
    );
  }

  void _removeSavedVehicle(String vehicleId) {
    HapticFeedback.mediumImpact();
    setState(() {
      _savedVehicles.removeWhere((vehicle) => vehicle['id'] == vehicleId);
      _filteredVehicles.removeWhere((vehicle) => vehicle['id'] == vehicleId);
    });
  }

  void _shareVehicle(Map<String, dynamic> vehicle) {
    HapticFeedback.lightImpact();
    // Implement share functionality
  }

  void _selectAllVehicles() {
    // Implement select all functionality
  }

  void _showRemoveAllDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Remove All Saved Vehicles'),
        content: Text(
            'Are you sure you want to remove all saved vehicles? This action cannot be undone.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              setState(() {
                _savedVehicles.clear();
                _filteredVehicles.clear();
              });
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            child: Text('Remove All'),
          ),
        ],
      ),
    );
  }

  void _exportSavedVehicles() {
    // Implement export functionality
  }
}
