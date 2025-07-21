import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class RecentSearchesWidget extends StatelessWidget {
  final List<String> recentSearches;
  final Function(String) onSearchTap;
  final Function(String) onRemoveSearch;

  const RecentSearchesWidget({
    Key? key,
    required this.recentSearches,
    required this.onSearchTap,
    required this.onRemoveSearch,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (recentSearches.isEmpty) {
      return SizedBox.shrink();
    }

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 4.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Recent Searches',
                style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              TextButton(
                onPressed: () {
                  for (String search in List.from(recentSearches)) {
                    onRemoveSearch(search);
                  }
                },
                child: Text(
                  'Clear All',
                  style: AppTheme.lightTheme.textTheme.labelLarge?.copyWith(
                    color: AppTheme.lightTheme.colorScheme.primary,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 1.h),
          ListView.separated(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemCount: recentSearches.length > 5 ? 5 : recentSearches.length,
            separatorBuilder: (context, index) => Divider(
              color: AppTheme.lightTheme.colorScheme.outline
                  .withValues(alpha: 0.3),
              height: 1,
            ),
            itemBuilder: (context, index) {
              final search = recentSearches[index];
              return ListTile(
                contentPadding:
                    EdgeInsets.symmetric(horizontal: 2.w, vertical: 0.5.h),
                leading: CustomIconWidget(
                  iconName: 'history',
                  color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                  size: 5.w,
                ),
                title: Text(
                  search,
                  style: AppTheme.lightTheme.textTheme.bodyLarge,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                trailing: GestureDetector(
                  onTap: () => onRemoveSearch(search),
                  child: CustomIconWidget(
                    iconName: 'close',
                    color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                    size: 4.w,
                  ),
                ),
                onTap: () => onSearchTap(search),
              );
            },
          ),
        ],
      ),
    );
  }
}
