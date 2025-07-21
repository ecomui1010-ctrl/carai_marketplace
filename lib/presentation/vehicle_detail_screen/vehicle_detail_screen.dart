import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import './widgets/action_buttons_widget.dart';
import './widgets/ownership_cost_estimator_widget.dart';
import './widgets/seller_information_widget.dart';
import './widgets/similar_vehicles_widget.dart';
import './widgets/vehicle_hero_section_widget.dart';
import './widgets/vehicle_image_gallery_widget.dart';
import './widgets/vehicle_specifications_widget.dart';

class VehicleDetailScreen extends StatefulWidget {
  const VehicleDetailScreen({Key? key}) : super(key: key);

  @override
  State<VehicleDetailScreen> createState() => _VehicleDetailScreenState();
}

class _VehicleDetailScreenState extends State<VehicleDetailScreen> {
  final ScrollController _scrollController = ScrollController();
  bool _showFloatingButton = false;

  // Mock vehicle data
  final Map<String, dynamic> vehicleData = {
    "id": 1,
    "name": "2022 Tesla Model S Plaid",
    "price": "\$89,990",
    "year": 2022,
    "make": "Tesla",
    "model": "Model S",
    "variant": "Plaid",
    "mileage": "12,450",
    "location": "San Francisco, CA",
    "mainImage":
        "https://images.pexels.com/photos/3802510/pexels-photo-3802510.jpeg",
    "images": [
      "https://images.pexels.com/photos/3802510/pexels-photo-3802510.jpeg",
      "https://images.pexels.com/photos/919073/pexels-photo-919073.jpeg",
      "https://images.pexels.com/photos/1719648/pexels-photo-1719648.jpeg",
      "https://images.pexels.com/photos/2365572/pexels-photo-2365572.jpeg",
      "https://images.pexels.com/photos/1592384/pexels-photo-1592384.jpeg"
    ],
    "description":
        """Experience the pinnacle of electric performance with this stunning 2022 Tesla Model S Plaid. This revolutionary vehicle combines cutting-edge technology with breathtaking acceleration, delivering 0-60 mph in just 1.99 seconds. 

The AI-enhanced autopilot system provides unparalleled safety and convenience, while the premium interior features a 17-inch touchscreen, premium audio system, and luxurious seating for five adults.

With over 400 miles of range and access to Tesla's extensive Supercharger network, this Model S Plaid is perfect for both daily commuting and long-distance travel. The vehicle has been meticulously maintained with full service history and comes with remaining warranty coverage.""",
    "specifications": {
      "Engine": "Tri-Motor Electric",
      "Power": "1,020 HP",
      "Transmission": "Single-Speed",
      "Drivetrain": "All-Wheel Drive",
      "Fuel Type": "Electric",
      "Range": "396 miles",
      "Acceleration": "0-60 in 1.99s",
      "Top Speed": "200 mph",
      "Seating": "5 Adults",
      "Body Style": "Sedan",
      "Color": "Pearl White",
      "Interior": "Black Premium"
    },
    "ownershipCost": {
      "monthlyTotal": "\$850",
      "breakdown": {
        "insurance": "\$180",
        "maintenance": "\$150",
        "charging": "\$120",
        "registration": "\$25",
        "depreciation": "\$375"
      }
    }
  };

  final Map<String, dynamic> sellerData = {
    "name": "Michael Rodriguez",
    "avatar":
        "https://cdn.pixabay.com/photo/2015/03/04/22/35/avatar-659652_640.png",
    "rating": 4.9,
    "reviewCount": 127,
    "location": "San Francisco, CA",
    "carsSold": 23,
    "responseTime": "< 1 hour",
    "memberSince": "2019",
    "isVerified": true
  };

  final List<Map<String, dynamic>> similarVehicles = [
    {
      "id": 2,
      "name": "2021 Tesla Model S",
      "price": "\$79,990",
      "year": 2021,
      "mileage": "18,500",
      "image":
          "https://images.pexels.com/photos/919073/pexels-photo-919073.jpeg"
    },
    {
      "id": 3,
      "name": "2022 Porsche Taycan",
      "price": "\$85,500",
      "year": 2022,
      "mileage": "8,200",
      "image":
          "https://images.pexels.com/photos/1719648/pexels-photo-1719648.jpeg"
    },
    {
      "id": 4,
      "name": "2021 Audi e-tron GT",
      "price": "\$72,900",
      "year": 2021,
      "mileage": "15,800",
      "image":
          "https://images.pexels.com/photos/2365572/pexels-photo-2365572.jpeg"
    }
  ];

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_scrollListener);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_scrollListener);
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollListener() {
    if (_scrollController.offset > 200 && !_showFloatingButton) {
      setState(() {
        _showFloatingButton = true;
      });
    } else if (_scrollController.offset <= 200 && _showFloatingButton) {
      setState(() {
        _showFloatingButton = false;
      });
    }
  }

  void _showToast(String message) {
    Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      backgroundColor: AppTheme.lightTheme.colorScheme.surface,
      textColor: AppTheme.lightTheme.colorScheme.onSurface,
    );
  }

  void _handleShare() {
    _showToast('Vehicle details shared successfully!');
  }

  void _handleSave() {
    _showToast('Vehicle saved to your favorites!');
  }

  void _handleBack() {
    Navigator.pop(context);
  }

  void _handleFullScreenGallery() {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) => Dialog.fullscreen(
        child: Stack(
          children: [
            PageView.builder(
              itemCount: (vehicleData['images'] as List).length,
              itemBuilder: (context, index) {
                return InteractiveViewer(
                  child: CustomImageWidget(
                    imageUrl: (vehicleData['images'] as List)[index],
                    width: double.infinity,
                    height: double.infinity,
                    fit: BoxFit.contain,
                  ),
                );
              },
            ),
            Positioned(
              top: 6.h,
              right: 4.w,
              child: GestureDetector(
                onTap: () => Navigator.pop(context),
                child: Container(
                  padding: EdgeInsets.all(3.w),
                  decoration: BoxDecoration(
                    color: AppTheme.lightTheme.colorScheme.surface
                        .withValues(alpha: 0.9),
                    shape: BoxShape.circle,
                  ),
                  child: CustomIconWidget(
                    iconName: 'close',
                    color: AppTheme.lightTheme.colorScheme.onSurface,
                    size: 24,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _handleContactSeller() {
    _showToast('Starting AI-assisted chat with seller...');
  }

  void _handleSimilarVehicleTap(Map<String, dynamic> vehicle) {
    _showToast('Loading ${vehicle['name']}...');
  }

  void _handleCallSeller() {
    _showToast('Calling seller...');
  }

  void _handleChat() {
    _showToast('Opening chat with seller...');
  }

  void _handleScheduleVisit() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        height: 50.h,
        decoration: BoxDecoration(
          color: AppTheme.lightTheme.colorScheme.surface,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          children: [
            Container(
              width: 12.w,
              height: 0.5.h,
              margin: EdgeInsets.symmetric(vertical: 2.h),
              decoration: BoxDecoration(
                color: AppTheme.lightTheme.colorScheme.outline,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(4.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Schedule a Visit',
                    style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(height: 2.h),
                  Text(
                    'Choose your preferred time to visit and inspect the vehicle.',
                    style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                      color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                  SizedBox(height: 4.h),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                        _showToast('Visit scheduled successfully!');
                      },
                      child: Text('Confirm Schedule'),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _handleVirtualTestDrive() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Virtual Test Drive'),
        content: Text(
            'Experience this vehicle in immersive 3D with steering wheel controls and realistic driving simulation.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              _showToast('Launching virtual test drive...');
            },
            child: Text('Start Drive'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.lightTheme.scaffoldBackgroundColor,
      body: Stack(
        children: [
          CustomScrollView(
            controller: _scrollController,
            slivers: [
              // Hero Section
              SliverToBoxAdapter(
                child: VehicleHeroSectionWidget(
                  vehicleData: vehicleData,
                  onShare: _handleShare,
                  onSave: _handleSave,
                  onBack: _handleBack,
                ),
              ),

              // Content
              SliverToBoxAdapter(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 2.h),

                    // Image Gallery
                    VehicleImageGalleryWidget(
                      images: (vehicleData['images'] as List).cast<String>(),
                      onFullScreenView: _handleFullScreenGallery,
                    ),

                    SizedBox(height: 4.h),

                    // AI-Generated Description
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 4.w),
                      child: Container(
                        width: double.infinity,
                        padding: EdgeInsets.all(4.w),
                        decoration: BoxDecoration(
                          color: AppTheme.lightTheme.colorScheme.surface,
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [
                            BoxShadow(
                              color: AppTheme.lightTheme.colorScheme.shadow,
                              blurRadius: 8,
                              offset: Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Text(
                                  'AI-Generated Description',
                                  style: AppTheme
                                      .lightTheme.textTheme.titleLarge
                                      ?.copyWith(
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                SizedBox(width: 2.w),
                                Container(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 2.w, vertical: 0.5.h),
                                  decoration: BoxDecoration(
                                    color: AppTheme
                                        .lightTheme.colorScheme.tertiary
                                        .withValues(alpha: 0.1),
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                  child: Text(
                                    'AI',
                                    style: AppTheme
                                        .lightTheme.textTheme.bodySmall
                                        ?.copyWith(
                                      color: AppTheme
                                          .lightTheme.colorScheme.tertiary,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 2.h),
                            Text(
                              vehicleData['description'] ?? '',
                              style: AppTheme.lightTheme.textTheme.bodyMedium
                                  ?.copyWith(
                                height: 1.5,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    SizedBox(height: 4.h),

                    // Specifications
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 4.w),
                      child: VehicleSpecificationsWidget(
                        specifications: vehicleData['specifications'] ?? {},
                      ),
                    ),

                    SizedBox(height: 4.h),

                    // Ownership Cost Estimator
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 4.w),
                      child: OwnershipCostEstimatorWidget(
                        costData: vehicleData['ownershipCost'] ?? {},
                      ),
                    ),

                    SizedBox(height: 4.h),

                    // Seller Information
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 4.w),
                      child: SellerInformationWidget(
                        sellerData: sellerData,
                        onContactSeller: _handleContactSeller,
                      ),
                    ),

                    SizedBox(height: 4.h),

                    // Similar Vehicles
                    SimilarVehiclesWidget(
                      similarVehicles: similarVehicles,
                      onVehicleTap: _handleSimilarVehicleTap,
                    ),

                    SizedBox(height: 12.h), // Space for bottom actions
                  ],
                ),
              ),
            ],
          ),

          // Floating Action Button
          if (_showFloatingButton)
            Positioned(
              bottom: 20.h,
              right: 4.w,
              child: FloatingActionButton(
                onPressed: () {
                  _scrollController.animateTo(
                    0,
                    duration: Duration(milliseconds: 500),
                    curve: Curves.easeInOut,
                  );
                },
                child: CustomIconWidget(
                  iconName: 'keyboard_arrow_up',
                  color: AppTheme.lightTheme.colorScheme.onPrimary,
                  size: 24,
                ),
              ),
            ),
        ],
      ),

      // Bottom Action Buttons
      bottomNavigationBar: ActionButtonsWidget(
        onCallSeller: _handleCallSeller,
        onChat: _handleChat,
        onScheduleVisit: _handleScheduleVisit,
        onVirtualTestDrive: _handleVirtualTestDrive,
      ),
    );
  }
}
