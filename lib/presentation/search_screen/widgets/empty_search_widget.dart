import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class EmptySearchWidget extends StatelessWidget {
  final String searchQuery;
  final Function(String) onSuggestionTap;

  const EmptySearchWidget({
    Key? key,
    required this.searchQuery,
    required this.onSuggestionTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final suggestions = [
      'Try searching for specific car models',
      'Check your spelling',
      'Use broader search terms',
      'Browse by popular brands',
    ];

    return Container(
      padding: EdgeInsets.all(4.w),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CustomIconWidget(
            iconName: 'search_off',
            color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
            size: 20.w,
          ),
          SizedBox(height: 3.h),
          Text(
            'No results found',
            style: AppTheme.lightTheme.textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.w600,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 1.h),
          Text(
            searchQuery.isNotEmpty
                ? 'No vehicles found for "$searchQuery"'
                : 'Start typing to search for vehicles',
            style: AppTheme.lightTheme.textTheme.bodyLarge?.copyWith(
              color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 4.h),
          Text(
            'Suggestions:',
            style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 2.h),
          Column(
            children: suggestions.map((suggestion) {
              return Container(
                margin: EdgeInsets.only(bottom: 1.h),
                child: Row(
                  children: [
                    CustomIconWidget(
                      iconName: 'lightbulb_outline',
                      color: AppTheme.lightTheme.colorScheme.primary,
                      size: 4.w,
                    ),
                    SizedBox(width: 2.w),
                    Expanded(
                      child: Text(
                        suggestion,
                        style: AppTheme.lightTheme.textTheme.bodyMedium,
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
          ),
          SizedBox(height: 4.h),
          ElevatedButton(
            onPressed: () => onSuggestionTap(''),
            child: Text('Browse All Vehicles'),
          ),
        ],
      ),
    );
  }
}
