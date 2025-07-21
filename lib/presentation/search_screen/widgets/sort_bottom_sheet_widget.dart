import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class SortBottomSheetWidget extends StatelessWidget {
  final String currentSort;
  final Function(String) onSortChanged;

  const SortBottomSheetWidget({
    Key? key,
    required this.currentSort,
    required this.onSortChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final sortOptions = [
      {
        'key': 'relevance',
        'title': 'Relevance',
        'subtitle': 'Best match for your search'
      },
      {
        'key': 'price_low',
        'title': 'Price: Low to High',
        'subtitle': 'Cheapest first'
      },
      {
        'key': 'price_high',
        'title': 'Price: High to Low',
        'subtitle': 'Most expensive first'
      },
      {
        'key': 'mileage_low',
        'title': 'Mileage: Low to High',
        'subtitle': 'Lowest mileage first'
      },
      {
        'key': 'mileage_high',
        'title': 'Mileage: High to Low',
        'subtitle': 'Highest mileage first'
      },
      {
        'key': 'date_new',
        'title': 'Date Added: Newest',
        'subtitle': 'Recently listed first'
      },
      {
        'key': 'distance',
        'title': 'Distance',
        'subtitle': 'Closest to you first'
      },
    ];

    return Container(
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.surface,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
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
                Text(
                  'Sort by',
                  style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Spacer(),
                GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: CustomIconWidget(
                    iconName: 'close',
                    color: AppTheme.lightTheme.colorScheme.onSurface,
                    size: 6.w,
                  ),
                ),
              ],
            ),
          ),
          ListView.builder(
            shrinkWrap: true,
            itemCount: sortOptions.length,
            itemBuilder: (context, index) {
              final option = sortOptions[index];
              final isSelected = currentSort == option['key'];

              return ListTile(
                onTap: () {
                  onSortChanged(option['key'] as String);
                  Navigator.pop(context);
                },
                leading: Radio<String>(
                  value: option['key'] as String,
                  groupValue: currentSort,
                  onChanged: (value) {
                    if (value != null) {
                      onSortChanged(value);
                      Navigator.pop(context);
                    }
                  },
                ),
                title: Text(
                  option['title'] as String,
                  style: AppTheme.lightTheme.textTheme.bodyLarge?.copyWith(
                    fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                    color: isSelected
                        ? AppTheme.lightTheme.colorScheme.primary
                        : AppTheme.lightTheme.colorScheme.onSurface,
                  ),
                ),
                subtitle: Text(
                  option['subtitle'] as String,
                  style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                    color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                  ),
                ),
              );
            },
          ),
          SizedBox(height: 2.h),
        ],
      ),
    );
  }
}
