import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../../theme/app_theme.dart';

class VehicleSpecificationsWidget extends StatelessWidget {
  final Map<String, dynamic> specifications;

  const VehicleSpecificationsWidget({
    Key? key,
    required this.specifications,
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
            'Specifications',
            style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 2.h),
          _buildSpecificationGrid(),
        ],
      ),
    );
  }

  Widget _buildSpecificationGrid() {
    final List<MapEntry<String, dynamic>> specEntries =
        specifications.entries.toList();

    return Column(
      children: [
        for (int i = 0; i < specEntries.length; i += 2)
          Padding(
            padding: EdgeInsets.only(bottom: 2.h),
            child: Row(
              children: [
                Expanded(
                  child: _buildSpecificationItem(
                    specEntries[i].key,
                    specEntries[i].value.toString(),
                  ),
                ),
                SizedBox(width: 4.w),
                Expanded(
                  child: i + 1 < specEntries.length
                      ? _buildSpecificationItem(
                          specEntries[i + 1].key,
                          specEntries[i + 1].value.toString(),
                        )
                      : SizedBox(),
                ),
              ],
            ),
          ),
      ],
    );
  }

  Widget _buildSpecificationItem(String label, String value) {
    return Container(
      padding: EdgeInsets.all(3.w),
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.surface,
        border: Border.all(
          color: AppTheme.lightTheme.colorScheme.outline.withValues(alpha: 0.3),
        ),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
              color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
            ),
          ),
          SizedBox(height: 0.5.h),
          Text(
            value,
            style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
