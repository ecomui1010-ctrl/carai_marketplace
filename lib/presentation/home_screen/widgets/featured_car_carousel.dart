import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class FeaturedCarCarousel extends StatefulWidget {
  const FeaturedCarCarousel({super.key});

  @override
  State<FeaturedCarCarousel> createState() => _FeaturedCarCarouselState();
}

class _FeaturedCarCarouselState extends State<FeaturedCarCarousel>
    with SingleTickerProviderStateMixin {
  late PageController _pageController;
  late AnimationController _rotationController;
  int _currentIndex = 0;

  final List<Map<String, dynamic>> featuredCars = [
    {
      "id": 1,
      "name": "BMW X5 2023",
      "price": "\$89,500",
      "location": "Los Angeles, CA",
      "mileage": "15,000 miles",
      "fuelType": "Gasoline",
      "transmission": "Automatic",
      "image":
          "https://images.pexels.com/photos/170811/pexels-photo-170811.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1",
      "specs": ["3.0L Turbo", "335 HP", "AWD"],
      "rating": 4.8,
      "isFeatured": true
    },
    {
      "id": 2,
      "name": "Mercedes-Benz C-Class",
      "price": "\$67,200",
      "location": "Miami, FL",
      "mileage": "8,500 miles",
      "fuelType": "Hybrid",
      "transmission": "Automatic",
      "image":
          "https://images.pexels.com/photos/3802510/pexels-photo-3802510.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1",
      "specs": ["2.0L Hybrid", "255 HP", "RWD"],
      "rating": 4.7,
      "isFeatured": true
    },
    {
      "id": 3,
      "name": "Audi Q7 Premium",
      "price": "\$95,800",
      "location": "New York, NY",
      "mileage": "12,300 miles",
      "fuelType": "Gasoline",
      "transmission": "Automatic",
      "image":
          "https://images.pexels.com/photos/244206/pexels-photo-244206.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1",
      "specs": ["3.0L V6", "340 HP", "Quattro"],
      "rating": 4.9,
      "isFeatured": true
    }
  ];

  @override
  void initState() {
    super.initState();
    _pageController = PageController(viewportFraction: 0.85);
    _rotationController = AnimationController(
      duration: const Duration(seconds: 8),
      vsync: this,
    )..repeat();
  }

  @override
  void dispose() {
    _pageController.dispose();
    _rotationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 32.h,
      child: PageView.builder(
        controller: _pageController,
        onPageChanged: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        itemCount: featuredCars.length,
        itemBuilder: (context, index) {
          final car = featuredCars[index];
          final isActive = index == _currentIndex;

          return AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            margin: EdgeInsets.symmetric(
              horizontal: 2.w,
              vertical: isActive ? 0 : 2.h,
            ),
            child: GestureDetector(
              onTap: () {
                Navigator.pushNamed(context, '/vehicle-detail-screen');
              },
              onLongPress: () {
                _showContextMenu(context, car);
              },
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      AppTheme.lightTheme.colorScheme.surface,
                      AppTheme.lightTheme.colorScheme.surface
                          .withValues(alpha: 0.95),
                    ],
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: AppTheme.shadowLight,
                      blurRadius: isActive ? 20 : 10,
                      offset: Offset(0, isActive ? 8 : 4),
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: Stack(
                    children: [
                      // 3D Car Image with Rotation Effect
                      Positioned.fill(
                        child: AnimatedBuilder(
                          animation: _rotationController,
                          builder: (context, child) {
                            return Transform(
                              alignment: Alignment.center,
                              transform: Matrix4.identity()
                                ..setEntry(3, 2, 0.001)
                                ..rotateY(_rotationController.value * 0.5),
                              child: CustomImageWidget(
                                imageUrl: car["image"] as String,
                                width: double.infinity,
                                height: double.infinity,
                                fit: BoxFit.cover,
                              ),
                            );
                          },
                        ),
                      ),

                      // Gradient Overlay
                      Positioned.fill(
                        child: Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [
                                Colors.transparent,
                                Colors.black.withValues(alpha: 0.7),
                              ],
                            ),
                          ),
                        ),
                      ),

                      // Featured Badge
                      Positioned(
                        top: 4.w,
                        right: 4.w,
                        child: Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 3.w,
                            vertical: 1.h,
                          ),
                          decoration: BoxDecoration(
                            color: AppTheme.accentLight,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            "FEATURED",
                            style: AppTheme.lightTheme.textTheme.labelSmall
                                ?.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),

                      // Car Details
                      Positioned(
                        bottom: 0,
                        left: 0,
                        right: 0,
                        child: Container(
                          padding: EdgeInsets.all(4.w),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                car["name"] as String,
                                style: AppTheme.lightTheme.textTheme.titleLarge
                                    ?.copyWith(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w600,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              SizedBox(height: 1.h),
                              Row(
                                children: [
                                  Expanded(
                                    child: Text(
                                      car["price"] as String,
                                      style: AppTheme
                                          .lightTheme.textTheme.headlineSmall
                                          ?.copyWith(
                                        color: AppTheme.accentLight,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                  ),
                                  Container(
                                    padding: EdgeInsets.symmetric(
                                      horizontal: 2.w,
                                      vertical: 0.5.h,
                                    ),
                                    decoration: BoxDecoration(
                                      color:
                                          Colors.white.withValues(alpha: 0.2),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        CustomIconWidget(
                                          iconName: 'star',
                                          color: AppTheme.warningLight,
                                          size: 16,
                                        ),
                                        SizedBox(width: 1.w),
                                        Text(
                                          car["rating"].toString(),
                                          style: AppTheme
                                              .lightTheme.textTheme.labelMedium
                                              ?.copyWith(
                                            color: Colors.white,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 1.h),
                              Row(
                                children: [
                                  CustomIconWidget(
                                    iconName: 'location_on',
                                    color: Colors.white.withValues(alpha: 0.8),
                                    size: 16,
                                  ),
                                  SizedBox(width: 1.w),
                                  Expanded(
                                    child: Text(
                                      car["location"] as String,
                                      style: AppTheme
                                          .lightTheme.textTheme.bodySmall
                                          ?.copyWith(
                                        color:
                                            Colors.white.withValues(alpha: 0.8),
                                      ),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                  Text(
                                    car["mileage"] as String,
                                    style: AppTheme
                                        .lightTheme.textTheme.bodySmall
                                        ?.copyWith(
                                      color:
                                          Colors.white.withValues(alpha: 0.8),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  void _showContextMenu(BuildContext context, Map<String, dynamic> car) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        decoration: BoxDecoration(
          color: AppTheme.lightTheme.colorScheme.surface,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
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
                iconName: 'favorite_border',
                color: AppTheme.lightTheme.colorScheme.primary,
                size: 24,
              ),
              title: Text(
                'Save to Favorites',
                style: AppTheme.lightTheme.textTheme.titleMedium,
              ),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: CustomIconWidget(
                iconName: 'share',
                color: AppTheme.lightTheme.colorScheme.primary,
                size: 24,
              ),
              title: Text(
                'Share',
                style: AppTheme.lightTheme.textTheme.titleMedium,
              ),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: CustomIconWidget(
                iconName: 'search',
                color: AppTheme.lightTheme.colorScheme.primary,
                size: 24,
              ),
              title: Text(
                'Find Similar Cars',
                style: AppTheme.lightTheme.textTheme.titleMedium,
              ),
              onTap: () {
                Navigator.pop(context);
                Navigator.pushNamed(context, '/search-screen');
              },
            ),
            SizedBox(height: 2.h),
          ],
        ),
      ),
    );
  }
}
