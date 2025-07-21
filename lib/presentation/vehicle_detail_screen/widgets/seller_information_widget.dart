import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class SellerInformationWidget extends StatelessWidget {
  final Map<String, dynamic> sellerData;
  final VoidCallback? onContactSeller;

  const SellerInformationWidget({
    Key? key,
    required this.sellerData,
    this.onContactSeller,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
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
          Text(
            'Seller Information',
            style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 3.h),
          Row(
            children: [
              Container(
                width: 15.w,
                height: 15.w,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: AppTheme.lightTheme.colorScheme.shadow,
                      blurRadius: 4,
                      offset: Offset(0, 2),
                    ),
                  ],
                ),
                child: ClipOval(
                  child: CustomImageWidget(
                    imageUrl: sellerData['avatar'] ??
                        'https://cdn.pixabay.com/photo/2015/03/04/22/35/avatar-659652_640.png',
                    width: 15.w,
                    height: 15.w,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              SizedBox(width: 4.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      sellerData['name'] ?? 'John Smith',
                      style:
                          AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(height: 0.5.h),
                    Row(
                      children: [
                        CustomIconWidget(
                          iconName: 'star',
                          color: Colors.amber,
                          size: 16,
                        ),
                        SizedBox(width: 1.w),
                        Text(
                          '${sellerData['rating'] ?? '4.8'} (${sellerData['reviewCount'] ?? '127'} reviews)',
                          style:
                              AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                            color: AppTheme
                                .lightTheme.colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 0.5.h),
                    Row(
                      children: [
                        CustomIconWidget(
                          iconName: 'location_on',
                          color:
                              AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                          size: 16,
                        ),
                        SizedBox(width: 1.w),
                        Text(
                          sellerData['location'] ?? 'San Francisco, CA',
                          style:
                              AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                            color: AppTheme
                                .lightTheme.colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 3.h),
          _buildSellerStats(),
          SizedBox(height: 3.h),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: onContactSeller,
              icon: CustomIconWidget(
                iconName: 'chat',
                color: AppTheme.lightTheme.colorScheme.onPrimary,
                size: 20,
              ),
              label: Text('Contact Seller'),
              style: AppTheme.lightTheme.elevatedButtonTheme.style,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSellerStats() {
    return Row(
      children: [
        Expanded(
          child: _buildStatItem(
            'Cars Sold',
            sellerData['carsSold']?.toString() ?? '23',
            'directions_car',
          ),
        ),
        Container(
          width: 1,
          height: 6.h,
          color: AppTheme.lightTheme.colorScheme.outline.withValues(alpha: 0.3),
        ),
        Expanded(
          child: _buildStatItem(
            'Response Time',
            sellerData['responseTime'] ?? '< 1 hour',
            'schedule',
          ),
        ),
        Container(
          width: 1,
          height: 6.h,
          color: AppTheme.lightTheme.colorScheme.outline.withValues(alpha: 0.3),
        ),
        Expanded(
          child: _buildStatItem(
            'Member Since',
            sellerData['memberSince'] ?? '2019',
            'person',
          ),
        ),
      ],
    );
  }

  Widget _buildStatItem(String label, String value, String iconName) {
    return Column(
      children: [
        CustomIconWidget(
          iconName: iconName,
          color: AppTheme.lightTheme.colorScheme.primary,
          size: 24,
        ),
        SizedBox(height: 1.h),
        Text(
          value,
          style: AppTheme.lightTheme.textTheme.titleSmall?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(height: 0.5.h),
        Text(
          label,
          style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
            color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}
