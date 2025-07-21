import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class RecommendedSection extends StatelessWidget {
  const RecommendedSection({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> recommendedCars = [
      {
        "id": 1,
        "name": "Tesla Model 3",
        "price": "\$52,990",
        "location": "San Francisco, CA",
        "mileage": "5,200 miles",
        "fuelType": "Electric",
        "year": "2023",
        "image":
            "https://images.pexels.com/photos/1592384/pexels-photo-1592384.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1",
        "aiScore": 95,
        "matchReason": "Perfect match for eco-friendly preferences"
      },
      {
        "id": 2,
        "name": "Honda Accord Sport",
        "price": "\$34,750",
        "location": "Austin, TX",
        "mileage": "18,500 miles",
        "fuelType": "Gasoline",
        "year": "2022",
        "image":
            "https://images.pexels.com/photos/116675/pexels-photo-116675.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1",
        "aiScore": 88,
        "matchReason": "Great value in your price range"
      },
      {
        "id": 3,
        "name": "Lexus RX 350",
        "price": "\$71,200",
        "location": "Seattle, WA",
        "mileage": "22,100 miles",
        "fuelType": "Gasoline",
        "year": "2022",
        "image":
            "https://images.pexels.com/photos/1719648/pexels-photo-1719648.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1",
        "aiScore": 92,
        "matchReason": "Luxury SUV matching your search history"
      }
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 4.w),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Recommended for You',
                      style:
                          AppTheme.lightTheme.textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(height: 0.5.h),
                    Row(
                      children: [
                        CustomIconWidget(
                          iconName: 'auto_awesome',
                          color: AppTheme.accentLight,
                          size: 16,
                        ),
                        SizedBox(width: 1.w),
                        Text(
                          'Powered by Gemini AI',
                          style:
                              AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                            color: AppTheme.accentLight,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              TextButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/search-screen');
                },
                child: Text(
                  'View All',
                  style: AppTheme.lightTheme.textTheme.titleSmall?.copyWith(
                    color: AppTheme.lightTheme.colorScheme.primary,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: 2.h),
        Container(
          height: 28.h,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: EdgeInsets.symmetric(horizontal: 4.w),
            itemCount: recommendedCars.length,
            itemBuilder: (context, index) {
              final car = recommendedCars[index];
              return Container(
                width: 75.w,
                margin: EdgeInsets.only(right: 4.w),
                child: GestureDetector(
                  onTap: () {
                    Navigator.pushNamed(context, '/vehicle-detail-screen');
                  },
                  onLongPress: () {
                    _showContextMenu(context, car);
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      color: AppTheme.lightTheme.colorScheme.surface,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: AppTheme.shadowLight,
                          blurRadius: 12,
                          offset: const Offset(0, 4),
                        ),
                        BoxShadow(
                          color: AppTheme.shadowLight.withValues(alpha: 0.05),
                          blurRadius: 24,
                          offset: const Offset(0, 8),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Image Section with AI Badge
                        Expanded(
                          flex: 3,
                          child: Stack(
                            children: [
                              ClipRRect(
                                borderRadius: const BorderRadius.vertical(
                                  top: Radius.circular(16),
                                ),
                                child: CustomImageWidget(
                                  imageUrl: car["image"] as String,
                                  width: double.infinity,
                                  height: double.infinity,
                                  fit: BoxFit.cover,
                                ),
                              ),
                              Positioned(
                                top: 3.w,
                                left: 3.w,
                                child: Container(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 2.w,
                                    vertical: 0.5.h,
                                  ),
                                  decoration: BoxDecoration(
                                    color: AppTheme.accentLight,
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      CustomIconWidget(
                                        iconName: 'auto_awesome',
                                        color: Colors.white,
                                        size: 12,
                                      ),
                                      SizedBox(width: 1.w),
                                      Text(
                                        '${car["aiScore"]}% Match',
                                        style: AppTheme
                                            .lightTheme.textTheme.labelSmall
                                            ?.copyWith(
                                          color: Colors.white,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              Positioned(
                                top: 3.w,
                                right: 3.w,
                                child: GestureDetector(
                                  onTap: () {
                                    // Handle save functionality
                                  },
                                  child: Container(
                                    padding: EdgeInsets.all(2.w),
                                    decoration: BoxDecoration(
                                      color:
                                          Colors.white.withValues(alpha: 0.9),
                                      shape: BoxShape.circle,
                                    ),
                                    child: CustomIconWidget(
                                      iconName: 'favorite_border',
                                      color: AppTheme
                                          .lightTheme.colorScheme.primary,
                                      size: 20,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),

                        // Details Section
                        Expanded(
                          flex: 2,
                          child: Padding(
                            padding: EdgeInsets.all(3.w),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  car["name"] as String,
                                  style: AppTheme
                                      .lightTheme.textTheme.titleMedium
                                      ?.copyWith(
                                    fontWeight: FontWeight.w600,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                SizedBox(height: 0.5.h),
                                Text(
                                  car["price"] as String,
                                  style: AppTheme
                                      .lightTheme.textTheme.titleLarge
                                      ?.copyWith(
                                    color: AppTheme.accentLight,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                                SizedBox(height: 1.h),
                                Row(
                                  children: [
                                    CustomIconWidget(
                                      iconName: 'location_on',
                                      color: AppTheme.textSecondaryLight,
                                      size: 14,
                                    ),
                                    SizedBox(width: 1.w),
                                    Expanded(
                                      child: Text(
                                        car["location"] as String,
                                        style: AppTheme
                                            .lightTheme.textTheme.bodySmall
                                            ?.copyWith(
                                          color: AppTheme.textSecondaryLight,
                                        ),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 0.5.h),
                                Text(
                                  car["matchReason"] as String,
                                  style: AppTheme.lightTheme.textTheme.bodySmall
                                      ?.copyWith(
                                    color:
                                        AppTheme.lightTheme.colorScheme.primary,
                                    fontStyle: FontStyle.italic,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  void _showContextMenu(BuildContext context, Map<String, dynamic> car) {
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
