import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class RecentlyAddedGrid extends StatelessWidget {
  const RecentlyAddedGrid({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> recentCars = [
      {
        "id": 1,
        "name": "Ford Mustang GT",
        "price": "\$45,990",
        "location": "Phoenix, AZ",
        "mileage": "12,500 miles",
        "year": "2023",
        "fuelType": "Gasoline",
        "image":
            "https://images.pexels.com/photos/544542/pexels-photo-544542.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1",
        "isNew": true,
        "postedHours": 2
      },
      {
        "id": 2,
        "name": "Chevrolet Camaro SS",
        "price": "\$42,500",
        "location": "Dallas, TX",
        "mileage": "8,900 miles",
        "year": "2023",
        "fuelType": "Gasoline",
        "image":
            "https://images.pexels.com/photos/358070/pexels-photo-358070.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1",
        "isNew": true,
        "postedHours": 5
      },
      {
        "id": 3,
        "name": "Jeep Wrangler Unlimited",
        "price": "\$38,750",
        "location": "Denver, CO",
        "mileage": "15,200 miles",
        "year": "2022",
        "fuelType": "Gasoline",
        "image":
            "https://images.pexels.com/photos/1335077/pexels-photo-1335077.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1",
        "isNew": false,
        "postedHours": 8
      },
      {
        "id": 4,
        "name": "Subaru Outback",
        "price": "\$32,990",
        "location": "Portland, OR",
        "mileage": "19,800 miles",
        "year": "2022",
        "fuelType": "Gasoline",
        "image":
            "https://images.pexels.com/photos/1719648/pexels-photo-1719648.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1",
        "isNew": false,
        "postedHours": 12
      },
      {
        "id": 5,
        "name": "Nissan Altima SR",
        "price": "\$28,450",
        "location": "Las Vegas, NV",
        "mileage": "22,100 miles",
        "year": "2022",
        "fuelType": "Gasoline",
        "image":
            "https://images.pexels.com/photos/116675/pexels-photo-116675.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1",
        "isNew": false,
        "postedHours": 18
      },
      {
        "id": 6,
        "name": "Hyundai Tucson SEL",
        "price": "\$31,200",
        "location": "Salt Lake City, UT",
        "mileage": "16,500 miles",
        "year": "2023",
        "fuelType": "Hybrid",
        "image":
            "https://images.pexels.com/photos/170811/pexels-photo-170811.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1",
        "isNew": false,
        "postedHours": 24
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
                child: Text(
                  'Recently Added',
                  style: AppTheme.lightTheme.textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
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
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 4.w),
          child: GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 3.w,
              mainAxisSpacing: 3.w,
              childAspectRatio: 0.75,
            ),
            itemCount: recentCars.length,
            itemBuilder: (context, index) {
              final car = recentCars[index];
              return GestureDetector(
                onTap: () {
                  Navigator.pushNamed(context, '/vehicle-detail-screen');
                },
                onLongPress: () {
                  _showContextMenu(context, car);
                },
                child: Container(
                  decoration: BoxDecoration(
                    color: AppTheme.lightTheme.colorScheme.surface,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: AppTheme.shadowLight,
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Image Section
                      Expanded(
                        flex: 3,
                        child: Stack(
                          children: [
                            ClipRRect(
                              borderRadius: const BorderRadius.vertical(
                                top: Radius.circular(12),
                              ),
                              child: CustomImageWidget(
                                imageUrl: car["image"] as String,
                                width: double.infinity,
                                height: double.infinity,
                                fit: BoxFit.cover,
                              ),
                            ),

                            // New Badge
                            if (car["isNew"] as bool)
                              Positioned(
                                top: 2.w,
                                left: 2.w,
                                child: Container(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 2.w,
                                    vertical: 0.5.h,
                                  ),
                                  decoration: BoxDecoration(
                                    color: AppTheme.successLight,
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Text(
                                    'NEW',
                                    style: AppTheme
                                        .lightTheme.textTheme.labelSmall
                                        ?.copyWith(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                              ),

                            // Save Button
                            Positioned(
                              top: 2.w,
                              right: 2.w,
                              child: GestureDetector(
                                onTap: () {
                                  // Handle save functionality
                                },
                                child: Container(
                                  padding: EdgeInsets.all(1.5.w),
                                  decoration: BoxDecoration(
                                    color: Colors.white.withValues(alpha: 0.9),
                                    shape: BoxShape.circle,
                                  ),
                                  child: CustomIconWidget(
                                    iconName: 'favorite_border',
                                    color:
                                        AppTheme.lightTheme.colorScheme.primary,
                                    size: 18,
                                  ),
                                ),
                              ),
                            ),

                            // Time Posted
                            Positioned(
                              bottom: 2.w,
                              right: 2.w,
                              child: Container(
                                padding: EdgeInsets.symmetric(
                                  horizontal: 2.w,
                                  vertical: 0.5.h,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.black.withValues(alpha: 0.7),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Text(
                                  '${car["postedHours"]}h ago',
                                  style: AppTheme
                                      .lightTheme.textTheme.labelSmall
                                      ?.copyWith(
                                    color: Colors.white,
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
                          padding: EdgeInsets.all(2.5.w),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                car["name"] as String,
                                style: AppTheme.lightTheme.textTheme.titleSmall
                                    ?.copyWith(
                                  fontWeight: FontWeight.w600,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              SizedBox(height: 0.5.h),
                              Text(
                                car["price"] as String,
                                style: AppTheme.lightTheme.textTheme.titleMedium
                                    ?.copyWith(
                                  color: AppTheme.accentLight,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              const Spacer(),
                              Row(
                                children: [
                                  CustomIconWidget(
                                    iconName: 'location_on',
                                    color: AppTheme.textSecondaryLight,
                                    size: 12,
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
                                '${car["year"]} • ${car["mileage"]}',
                                style: AppTheme.lightTheme.textTheme.bodySmall
                                    ?.copyWith(
                                  color: AppTheme.textSecondaryLight,
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
