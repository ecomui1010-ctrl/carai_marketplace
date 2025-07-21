import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class OwnershipCostEstimatorWidget extends StatefulWidget {
  final Map<String, dynamic> costData;

  const OwnershipCostEstimatorWidget({
    Key? key,
    required this.costData,
  }) : super(key: key);

  @override
  State<OwnershipCostEstimatorWidget> createState() =>
      _OwnershipCostEstimatorWidgetState();
}

class _OwnershipCostEstimatorWidgetState
    extends State<OwnershipCostEstimatorWidget> {
  bool _isExpanded = false;

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
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Ownership Cost Estimator',
                style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              CustomIconWidget(
                iconName: 'info_outline',
                color: AppTheme.lightTheme.colorScheme.primary,
                size: 20,
              ),
            ],
          ),
          SizedBox(height: 2.h),
          _buildTotalCostCard(),
          SizedBox(height: 2.h),
          GestureDetector(
            onTap: () {
              setState(() {
                _isExpanded = !_isExpanded;
              });
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'View Breakdown',
                  style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                    color: AppTheme.lightTheme.colorScheme.primary,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                CustomIconWidget(
                  iconName: _isExpanded ? 'expand_less' : 'expand_more',
                  color: AppTheme.lightTheme.colorScheme.primary,
                  size: 20,
                ),
              ],
            ),
          ),
          if (_isExpanded) ...[
            SizedBox(height: 2.h),
            _buildCostBreakdown(),
          ],
        ],
      ),
    );
  }

  Widget _buildTotalCostCard() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppTheme.lightTheme.colorScheme.primary,
            AppTheme.lightTheme.colorScheme.primaryContainer,
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Estimated Monthly Cost',
            style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
              color: AppTheme.lightTheme.colorScheme.onPrimary,
            ),
          ),
          SizedBox(height: 1.h),
          Text(
            widget.costData['monthlyTotal'] ?? '\$850',
            style: AppTheme.lightTheme.textTheme.headlineMedium?.copyWith(
              color: AppTheme.lightTheme.colorScheme.onPrimary,
              fontWeight: FontWeight.w700,
            ),
          ),
          SizedBox(height: 0.5.h),
          Text(
            'Based on 12,000 miles/year',
            style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
              color: AppTheme.lightTheme.colorScheme.onPrimary
                  .withValues(alpha: 0.8),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCostBreakdown() {
    final List<Map<String, dynamic>> breakdownItems = [
      {'label': 'Fuel', 'amount': '\$320', 'icon': 'local_gas_station'},
      {'label': 'Insurance', 'amount': '\$180', 'icon': 'security'},
      {'label': 'Maintenance', 'amount': '\$150', 'icon': 'build'},
      {'label': 'Registration', 'amount': '\$25', 'icon': 'description'},
      {'label': 'Depreciation', 'amount': '\$175', 'icon': 'trending_down'},
    ];

    return Column(
      children: breakdownItems.map((item) {
        return Padding(
          padding: EdgeInsets.only(bottom: 1.5.h),
          child: Row(
            children: [
              Container(
                padding: EdgeInsets.all(2.w),
                decoration: BoxDecoration(
                  color: AppTheme.lightTheme.colorScheme.primary
                      .withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: CustomIconWidget(
                  iconName: item['icon'],
                  color: AppTheme.lightTheme.colorScheme.primary,
                  size: 20,
                ),
              ),
              SizedBox(width: 3.w),
              Expanded(
                child: Text(
                  item['label'],
                  style: AppTheme.lightTheme.textTheme.bodyMedium,
                ),
              ),
              Text(
                item['amount'],
                style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }
}
