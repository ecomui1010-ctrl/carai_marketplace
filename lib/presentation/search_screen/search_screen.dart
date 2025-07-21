import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import './widgets/camera_search_widget.dart';
import './widgets/empty_search_widget.dart';
import './widgets/filter_chip_widget.dart';
import './widgets/filter_modal_widget.dart';
import './widgets/popular_searches_widget.dart';
import './widgets/recent_searches_widget.dart';
import './widgets/search_bar_widget.dart';
import './widgets/sort_bottom_sheet_widget.dart';
import './widgets/vehicle_result_card_widget.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({Key? key}) : super(key: key);

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen>
    with TickerProviderStateMixin {
  final TextEditingController _searchController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  List<Map<String, dynamic>> _searchResults = [];
  List<String> _recentSearches = [
    'Toyota Camry 2020',
    'BMW X3',
    'Honda Accord'
  ];
  Map<String, dynamic> _activeFilters = {};
  List<Map<String, dynamic>> _selectedVehicles = [];

  bool _isLoading = false;
  bool _isMultiSelectMode = false;
  bool _hasSearched = false;
  String _currentSort = 'relevance';
  int _currentPage = 1;
  bool _hasMoreResults = true;

  // Mock vehicle data
  final List<Map<String, dynamic>> _mockVehicles = [
    {
      "id": 1,
      "make": "Toyota",
      "model": "Camry",
      "year": 2022,
      "price": "\$28,500",
      "mileage": "15,000",
      "fuelType": "Gasoline",
      "distance": "2.5 miles",
      "image":
          "https://images.pexels.com/photos/3802510/pexels-photo-3802510.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1",
      "isSaved": false,
    },
    {
      "id": 2,
      "make": "Honda",
      "model": "Accord",
      "year": 2021,
      "price": "\$26,800",
      "mileage": "22,000",
      "fuelType": "Hybrid",
      "distance": "4.1 miles",
      "image":
          "https://images.pexels.com/photos/1545743/pexels-photo-1545743.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1",
      "isSaved": true,
    },
    {
      "id": 3,
      "make": "BMW",
      "model": "X3",
      "year": 2023,
      "price": "\$45,200",
      "mileage": "8,500",
      "fuelType": "Gasoline",
      "distance": "6.3 miles",
      "image":
          "https://images.pexels.com/photos/1719648/pexels-photo-1719648.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1",
      "isSaved": false,
    },
    {
      "id": 4,
      "make": "Mercedes",
      "model": "C-Class",
      "year": 2022,
      "price": "\$42,900",
      "mileage": "12,000",
      "fuelType": "Gasoline",
      "distance": "3.7 miles",
      "image":
          "https://images.pexels.com/photos/1592384/pexels-photo-1592384.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1",
      "isSaved": false,
    },
    {
      "id": 5,
      "make": "Tesla",
      "model": "Model 3",
      "year": 2023,
      "price": "\$39,990",
      "mileage": "5,200",
      "fuelType": "Electric",
      "distance": "1.8 miles",
      "image":
          "https://images.pexels.com/photos/1638459/pexels-photo-1638459.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1",
      "isSaved": true,
    },
    {
      "id": 6,
      "make": "Audi",
      "model": "A4",
      "year": 2021,
      "price": "\$38,500",
      "mileage": "18,000",
      "fuelType": "Gasoline",
      "distance": "5.2 miles",
      "image":
          "https://images.pexels.com/photos/1149137/pexels-photo-1149137.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1",
      "isSaved": false,
    },
  ];

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _searchController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      if (!_isLoading && _hasMoreResults) {
        _loadMoreResults();
      }
    }
  }

  Future<void> _performSearch(String query) async {
    if (query.trim().isEmpty) {
      setState(() {
        _searchResults.clear();
        _hasSearched = false;
      });
      return;
    }

    setState(() {
      _isLoading = true;
      _hasSearched = true;
      _currentPage = 1;
    });

    // Add to recent searches
    if (!_recentSearches.contains(query)) {
      _recentSearches.insert(0, query);
      if (_recentSearches.length > 10) {
        _recentSearches.removeLast();
      }
    }

    // Simulate API call
    await Future.delayed(Duration(milliseconds: 800));

    // Filter mock data based on search query
    final filteredResults = _mockVehicles.where((vehicle) {
      final searchLower = query.toLowerCase();
      return (vehicle['make'] as String).toLowerCase().contains(searchLower) ||
          (vehicle['model'] as String).toLowerCase().contains(searchLower) ||
          '${vehicle['make']} ${vehicle['model']}'
              .toLowerCase()
              .contains(searchLower);
    }).toList();

    setState(() {
      _searchResults = List.from(filteredResults);
      _isLoading = false;
      _hasMoreResults = filteredResults.length >= 6;
    });
  }

  Future<void> _loadMoreResults() async {
    setState(() => _isLoading = true);

    await Future.delayed(Duration(milliseconds: 500));

    // Simulate loading more results
    final moreResults = _mockVehicles.take(3).toList();

    setState(() {
      _searchResults.addAll(moreResults);
      _currentPage++;
      _isLoading = false;
      _hasMoreResults = _currentPage < 3; // Limit to 3 pages
    });
  }

  Future<void> _refreshResults() async {
    if (_searchController.text.isNotEmpty) {
      await _performSearch(_searchController.text);
    }
  }

  void _openCameraSearch() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CameraSearchWidget(
          onImageCaptured: (image) {
            // Process captured image for reverse search
            _performReverseImageSearch(image);
          },
        ),
      ),
    );
  }

  void _performReverseImageSearch(XFile image) {
    // Simulate AI-powered reverse image search
    setState(() => _isLoading = true);

    Future.delayed(Duration(milliseconds: 1500), () {
      // Mock results based on image analysis
      final similarVehicles = _mockVehicles.take(4).toList();
      setState(() {
        _searchResults = similarVehicles;
        _hasSearched = true;
        _isLoading = false;
        _searchController.text = 'Similar vehicles found';
      });
    });
  }

  void _toggleVehicleSelection(Map<String, dynamic> vehicle) {
    setState(() {
      if (_selectedVehicles.any((v) => v['id'] == vehicle['id'])) {
        _selectedVehicles.removeWhere((v) => v['id'] == vehicle['id']);
      } else {
        _selectedVehicles.add(vehicle);
      }

      if (_selectedVehicles.isEmpty) {
        _isMultiSelectMode = false;
      }
    });
  }

  void _toggleSaveVehicle(Map<String, dynamic> vehicle) {
    setState(() {
      vehicle['isSaved'] = !(vehicle['isSaved'] ?? false);
    });
  }

  void _showFilterModal() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => FilterModalWidget(
        currentFilters: _activeFilters,
        onApplyFilters: (filters) {
          setState(() => _activeFilters = filters);
          _applyFilters();
        },
      ),
    );
  }

  void _showSortBottomSheet() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => SortBottomSheetWidget(
        currentSort: _currentSort,
        onSortChanged: (sortType) {
          setState(() => _currentSort = sortType);
          _applySorting();
        },
      ),
    );
  }

  void _applyFilters() {
    // Apply filters to search results
    List<Map<String, dynamic>> filteredResults = List.from(_mockVehicles);

    if (_activeFilters['makes'] != null &&
        (_activeFilters['makes'] as List).isNotEmpty) {
      filteredResults = filteredResults.where((vehicle) {
        return (_activeFilters['makes'] as List).contains(vehicle['make']);
      }).toList();
    }

    if (_activeFilters['fuelTypes'] != null &&
        (_activeFilters['fuelTypes'] as List).isNotEmpty) {
      filteredResults = filteredResults.where((vehicle) {
        return (_activeFilters['fuelTypes'] as List)
            .contains(vehicle['fuelType']);
      }).toList();
    }

    setState(() => _searchResults = filteredResults);
  }

  void _applySorting() {
    List<Map<String, dynamic>> sortedResults = List.from(_searchResults);

    switch (_currentSort) {
      case 'price_low':
        sortedResults.sort((a, b) {
          final priceA = double.parse(
              (a['price'] as String).replaceAll(RegExp(r'[^\d.]'), ''));
          final priceB = double.parse(
              (b['price'] as String).replaceAll(RegExp(r'[^\d.]'), ''));
          return priceA.compareTo(priceB);
        });
        break;
      case 'price_high':
        sortedResults.sort((a, b) {
          final priceA = double.parse(
              (a['price'] as String).replaceAll(RegExp(r'[^\d.]'), ''));
          final priceB = double.parse(
              (b['price'] as String).replaceAll(RegExp(r'[^\d.]'), ''));
          return priceB.compareTo(priceA);
        });
        break;
      case 'mileage_low':
        sortedResults.sort((a, b) {
          final mileageA =
              double.parse((a['mileage'] as String).replaceAll(',', ''));
          final mileageB =
              double.parse((b['mileage'] as String).replaceAll(',', ''));
          return mileageA.compareTo(mileageB);
        });
        break;
    }

    setState(() => _searchResults = sortedResults);
  }

  void _removeFilter(String filterKey) {
    setState(() {
      _activeFilters.remove(filterKey);
    });
    _applyFilters();
  }

  void _exitMultiSelectMode() {
    setState(() {
      _isMultiSelectMode = false;
      _selectedVehicles.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.lightTheme.scaffoldBackgroundColor,
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(),
            _buildFilterChips(),
            Expanded(
              child: _buildBody(),
            ),
          ],
        ),
      ),
      bottomNavigationBar: _buildBottomNavigation(),
      floatingActionButton:
          _isMultiSelectMode ? _buildMultiSelectActions() : null,
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 1.h),
      child: Column(
        children: [
          SearchBarWidget(
            controller: _searchController,
            onCameraPressed: _openCameraSearch,
            onVoicePressed: () {
              // Voice search implementation would go here
            },
            onChanged: (query) {
              if (query.isEmpty) {
                setState(() {
                  _searchResults.clear();
                  _hasSearched = false;
                });
              }
            },
            onSubmitted: _performSearch,
          ),
          if (_isMultiSelectMode)
            Container(
              padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
              color: AppTheme.lightTheme.colorScheme.primary
                  .withValues(alpha: 0.1),
              child: Row(
                children: [
                  Text(
                    '${_selectedVehicles.length} selected',
                    style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                      color: AppTheme.lightTheme.colorScheme.primary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Spacer(),
                  TextButton(
                    onPressed: _exitMultiSelectMode,
                    child: Text('Cancel'),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildFilterChips() {
    if (_activeFilters.isEmpty && !_hasSearched) return SizedBox.shrink();

    return Container(
      height: 6.h,
      margin: EdgeInsets.only(bottom: 1.h),
      child: ListView(
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.symmetric(horizontal: 4.w),
        children: [
          FilterChipWidget(
            label: 'All Filters',
            isSelected: false,
            onTap: _showFilterModal,
          ),
          if (_hasSearched)
            FilterChipWidget(
              label: 'Sort',
              isSelected: false,
              onTap: _showSortBottomSheet,
            ),
          ..._activeFilters.entries.map((entry) {
            if (entry.value is List && (entry.value as List).isNotEmpty) {
              return FilterChipWidget(
                label: entry.key,
                count: (entry.value as List).length,
                isSelected: true,
                onRemove: () => _removeFilter(entry.key),
              );
            }
            return SizedBox.shrink();
          }).toList(),
        ],
      ),
    );
  }

  Widget _buildBody() {
    if (!_hasSearched) {
      return SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: 2.h),
            RecentSearchesWidget(
              recentSearches: _recentSearches,
              onSearchTap: (search) {
                _searchController.text = search;
                _performSearch(search);
              },
              onRemoveSearch: (search) {
                setState(() => _recentSearches.remove(search));
              },
            ),
            SizedBox(height: 4.h),
            PopularSearchesWidget(
              onSearchTap: (search) {
                _searchController.text = search;
                _performSearch(search);
              },
            ),
          ],
        ),
      );
    }

    if (_searchResults.isEmpty && !_isLoading) {
      return EmptySearchWidget(
        searchQuery: _searchController.text,
        onSuggestionTap: (suggestion) {
          if (suggestion.isEmpty) {
            _searchController.clear();
            setState(() {
              _searchResults = List.from(_mockVehicles);
              _hasSearched = true;
            });
          } else {
            _searchController.text = suggestion;
            _performSearch(suggestion);
          }
        },
      );
    }

    return RefreshIndicator(
      onRefresh: _refreshResults,
      child: ListView.builder(
        controller: _scrollController,
        itemCount: _searchResults.length + (_isLoading ? 1 : 0),
        itemBuilder: (context, index) {
          if (index == _searchResults.length) {
            return Container(
              padding: EdgeInsets.all(4.w),
              child: Center(
                child: CircularProgressIndicator(
                  color: AppTheme.lightTheme.colorScheme.primary,
                ),
              ),
            );
          }

          final vehicle = _searchResults[index];
          final isSelected =
              _selectedVehicles.any((v) => v['id'] == vehicle['id']);

          return VehicleResultCardWidget(
            vehicle: vehicle,
            isSelected: isSelected,
            onTap: () {
              if (_isMultiSelectMode) {
                _toggleVehicleSelection(vehicle);
              } else {
                Navigator.pushNamed(context, '/vehicle-detail-screen');
              }
            },
            onSave: () => _toggleSaveVehicle(vehicle),
            onLongPress: () {
              if (!_isMultiSelectMode) {
                setState(() => _isMultiSelectMode = true);
                _toggleVehicleSelection(vehicle);
              }
            },
          );
        },
      ),
    );
  }

  Widget _buildBottomNavigation() {
    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      currentIndex: 1, // Search tab is active
      selectedItemColor: AppTheme.lightTheme.colorScheme.primary,
      unselectedItemColor: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
      items: [
        BottomNavigationBarItem(
          icon: CustomIconWidget(
            iconName: 'home',
            color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
            size: 6.w,
          ),
          activeIcon: CustomIconWidget(
            iconName: 'home',
            color: AppTheme.lightTheme.colorScheme.primary,
            size: 6.w,
          ),
          label: 'Home',
        ),
        BottomNavigationBarItem(
          icon: CustomIconWidget(
            iconName: 'search',
            color: AppTheme.lightTheme.colorScheme.primary,
            size: 6.w,
          ),
          label: 'Search',
        ),
        BottomNavigationBarItem(
          icon: CustomIconWidget(
            iconName: 'add_circle_outline',
            color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
            size: 6.w,
          ),
          activeIcon: CustomIconWidget(
            iconName: 'add_circle',
            color: AppTheme.lightTheme.colorScheme.primary,
            size: 6.w,
          ),
          label: 'Sell',
        ),
        BottomNavigationBarItem(
          icon: CustomIconWidget(
            iconName: 'favorite_border',
            color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
            size: 6.w,
          ),
          activeIcon: CustomIconWidget(
            iconName: 'favorite',
            color: AppTheme.lightTheme.colorScheme.primary,
            size: 6.w,
          ),
          label: 'Saved',
        ),
        BottomNavigationBarItem(
          icon: CustomIconWidget(
            iconName: 'person_outline',
            color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
            size: 6.w,
          ),
          activeIcon: CustomIconWidget(
            iconName: 'person',
            color: AppTheme.lightTheme.colorScheme.primary,
            size: 6.w,
          ),
          label: 'Profile',
        ),
      ],
      onTap: (index) {
        switch (index) {
          case 0:
            Navigator.pushNamed(context, '/home-screen');
            break;
          case 1:
            // Already on search screen
            break;
          case 2:
            Navigator.pushNamed(context, '/sell-vehicle-screen');
            break;
          case 3:
            // Navigate to saved vehicles
            break;
          case 4:
            // Navigate to profile
            break;
        }
      },
    );
  }

  Widget _buildMultiSelectActions() {
    return Container(
      margin: EdgeInsets.only(bottom: 10.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          FloatingActionButton.extended(
            heroTag: "compare",
            onPressed: () {
              // Compare selected vehicles
            },
            icon: CustomIconWidget(
              iconName: 'compare_arrows',
              color: Colors.white,
              size: 5.w,
            ),
            label: Text('Compare'),
            backgroundColor: AppTheme.lightTheme.colorScheme.primary,
          ),
          FloatingActionButton.extended(
            heroTag: "save_all",
            onPressed: () {
              // Save all selected vehicles
              for (var vehicle in _selectedVehicles) {
                vehicle['isSaved'] = true;
              }
              _exitMultiSelectMode();
            },
            icon: CustomIconWidget(
              iconName: 'favorite',
              color: Colors.white,
              size: 5.w,
            ),
            label: Text('Save All'),
            backgroundColor: Colors.red,
          ),
          FloatingActionButton.extended(
            heroTag: "share",
            onPressed: () {
              // Share selected vehicles
            },
            icon: CustomIconWidget(
              iconName: 'share',
              color: Colors.white,
              size: 5.w,
            ),
            label: Text('Share'),
            backgroundColor: AppTheme.lightTheme.colorScheme.secondary,
          ),
        ],
      ),
    );
  }
}
