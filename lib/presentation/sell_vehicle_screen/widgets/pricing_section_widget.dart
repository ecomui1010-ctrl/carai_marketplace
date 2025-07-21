import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class PricingSectionWidget extends StatefulWidget {
  final Function(Map<String, dynamic>) onPricingChanged;
  final Map<String, dynamic> pricingData;
  final Map<String, dynamic> vehicleDetails;

  const PricingSectionWidget({
    Key? key,
    required this.onPricingChanged,
    required this.pricingData,
    required this.vehicleDetails,
  }) : super(key: key);

  @override
  State<PricingSectionWidget> createState() => _PricingSectionWidgetState();
}

class _PricingSectionWidgetState extends State<PricingSectionWidget> {
  final TextEditingController _priceController = TextEditingController();
  bool _isFeaturedListing = false;
  bool _isAnalyzing = false;
  Map<String, dynamic> _marketAnalysis = {};

  @override
  void initState() {
    super.initState();
    _priceController.text = widget.pricingData['price']?.toString() ?? '';
    _isFeaturedListing = widget.pricingData['isFeatured'] ?? false;
    _marketAnalysis = widget.pricingData['marketAnalysis'] ?? {};

    if (_shouldAnalyzeMarket()) {
      _performMarketAnalysis();
    }
  }

  bool _shouldAnalyzeMarket() {
    return widget.vehicleDetails['make'] != null &&
        widget.vehicleDetails['model'] != null &&
        widget.vehicleDetails['year'] != null &&
        _marketAnalysis.isEmpty;
  }

  Future<void> _performMarketAnalysis() async {
    if (!_shouldAnalyzeMarket()) return;

    setState(() {
      _isAnalyzing = true;
    });

    // Simulate AI market analysis
    await Future.delayed(Duration(seconds: 3));

    final make = widget.vehicleDetails['make'];
    final model = widget.vehicleDetails['model'];
    final year = widget.vehicleDetails['year'];
    final mileage = widget.vehicleDetails['mileage'] ?? 50000;
    final condition = widget.vehicleDetails['condition'] ?? 'Good';

    final analysis = _generateMarketAnalysis(
      make: make,
      model: model,
      year: year,
      mileage: mileage,
      condition: condition,
    );

    setState(() {
      _marketAnalysis = analysis;
      _isAnalyzing = false;
    });

    _updatePricingData();
  }

  Map<String, dynamic> _generateMarketAnalysis({
    required String make,
    required String model,
    required int year,
    required int mileage,
    required String condition,
  }) {
    // Base price calculation
    final currentYear = DateTime.now().year;
    final age = currentYear - year;
    final basePrice = _getBasePrice(make, model, year);

    // Depreciation and mileage adjustments
    final depreciationFactor = 1 - (age * 0.08);
    final mileageAdjustment =
        mileage > 100000 ? 0.85 : (mileage > 50000 ? 0.95 : 1.0);
    final conditionMultiplier = _getConditionMultiplier(condition);

    final estimatedPrice = (basePrice *
            depreciationFactor *
            mileageAdjustment *
            conditionMultiplier)
        .round();
    final lowRange = (estimatedPrice * 0.85).round();
    final highRange = (estimatedPrice * 1.15).round();

    return {
      'suggestedPrice': estimatedPrice,
      'priceRange': {
        'low': lowRange,
        'high': highRange,
      },
      'marketInsights': [
        'Similar vehicles in your area are priced between \$${_formatPrice(lowRange)} - \$${_formatPrice(highRange)}',
        'Your vehicle\'s $condition condition is ${condition == 'Excellent' ? 'above' : condition == 'Good' ? 'at' : 'below'} market average',
        'Current market demand for $make $model is ${_getMarketDemand(make, model)}',
        'Vehicles with similar mileage typically sell within ${_getDaysToSell(mileage)} days',
      ],
      'competitiveAnalysis': {
        'averagePrice': estimatedPrice,
        'totalListings': (15 + (DateTime.now().millisecond % 25)),
        'averageDaysOnMarket': _getDaysToSell(mileage),
      }
    };
  }

  int _getBasePrice(String make, String model, int year) {
    final basePrices = {
      'Toyota': {
        'Camry': 25000,
        'Corolla': 20000,
        'RAV4': 28000,
        'Highlander': 35000
      },
      'Honda': {'Civic': 22000, 'Accord': 26000, 'CR-V': 27000, 'Pilot': 33000},
      'Ford': {
        'F-150': 30000,
        'Mustang': 28000,
        'Explorer': 32000,
        'Escape': 25000
      },
      'BMW': {'3 Series': 35000, '5 Series': 45000, 'X3': 40000, 'X5': 55000},
      'Mercedes-Benz': {
        'C-Class': 38000,
        'E-Class': 50000,
        'GLC': 42000,
        'GLE': 58000
      },
    };

    return basePrices[make]?[model] ?? 25000;
  }

  double _getConditionMultiplier(String condition) {
    switch (condition) {
      case 'Excellent':
        return 1.1;
      case 'Very Good':
        return 1.05;
      case 'Good':
        return 1.0;
      case 'Fair':
        return 0.9;
      case 'Poor':
        return 0.75;
      default:
        return 1.0;
    }
  }

  String _getMarketDemand(String make, String model) {
    final popularModels = ['Camry', 'Civic', 'Accord', 'CR-V', 'RAV4', 'F-150'];
    return popularModels.contains(model) ? 'High' : 'Moderate';
  }

  int _getDaysToSell(int mileage) {
    if (mileage < 30000) return 25;
    if (mileage < 60000) return 35;
    if (mileage < 100000) return 45;
    return 60;
  }

  String _formatPrice(int price) {
    return price.toString().replaceAllMapped(
          RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
          (Match m) => '${m[1]},',
        );
  }

  void _updatePricingData() {
    final data = {
      'price': int.tryParse(_priceController.text.replaceAll(',', '')) ?? 0,
      'isFeatured': _isFeaturedListing,
      'marketAnalysis': _marketAnalysis,
    };
    widget.onPricingChanged(data);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppTheme.lightTheme.colorScheme.outline.withValues(alpha: 0.3),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CustomIconWidget(
                iconName: 'attach_money',
                color: AppTheme.lightTheme.colorScheme.primary,
                size: 24,
              ),
              SizedBox(width: 2.w),
              Text(
                'Pricing & Market Analysis',
                style: AppTheme.lightTheme.textTheme.titleMedium,
              ),
            ],
          ),
          SizedBox(height: 3.h),

          if (_isAnalyzing) ...[
            Container(
              height: 15.h,
              decoration: BoxDecoration(
                color: AppTheme.lightTheme.colorScheme.surface
                    .withValues(alpha: 0.5),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: AppTheme.lightTheme.colorScheme.outline
                      .withValues(alpha: 0.3),
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(
                    color: AppTheme.lightTheme.colorScheme.primary,
                  ),
                  SizedBox(height: 2.h),
                  Text(
                    'Analyzing market data...',
                    style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                      color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
          ] else if (_marketAnalysis.isNotEmpty) ...[
            // Market Analysis Results
            Container(
              padding: EdgeInsets.all(3.w),
              decoration: BoxDecoration(
                color: AppTheme.lightTheme.colorScheme.tertiary
                    .withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: AppTheme.lightTheme.colorScheme.tertiary
                      .withValues(alpha: 0.3),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      CustomIconWidget(
                        iconName: 'trending_up',
                        color: AppTheme.lightTheme.colorScheme.tertiary,
                        size: 20,
                      ),
                      SizedBox(width: 2.w),
                      Text(
                        'AI Market Analysis',
                        style:
                            AppTheme.lightTheme.textTheme.titleSmall?.copyWith(
                          color: AppTheme.lightTheme.colorScheme.tertiary,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 2.h),
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Suggested Price',
                              style: AppTheme.lightTheme.textTheme.labelMedium,
                            ),
                            Text(
                              '\$${_formatPrice(_marketAnalysis['suggestedPrice'])}',
                              style: AppTheme.lightTheme.textTheme.headlineSmall
                                  ?.copyWith(
                                color: AppTheme.lightTheme.colorScheme.tertiary,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Price Range',
                              style: AppTheme.lightTheme.textTheme.labelMedium,
                            ),
                            Text(
                              '\$${_formatPrice(_marketAnalysis['priceRange']['low'])} - \$${_formatPrice(_marketAnalysis['priceRange']['high'])}',
                              style: AppTheme.lightTheme.textTheme.titleMedium
                                  ?.copyWith(
                                color: AppTheme
                                    .lightTheme.colorScheme.onSurfaceVariant,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 2.h),
                  Text(
                    'Market Insights',
                    style: AppTheme.lightTheme.textTheme.labelMedium,
                  ),
                  SizedBox(height: 1.h),
                  ...((_marketAnalysis['marketInsights'] as List<String>?) ??
                          [])
                      .map((insight) {
                    return Padding(
                      padding: EdgeInsets.only(bottom: 1.h),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CustomIconWidget(
                            iconName: 'fiber_manual_record',
                            color: AppTheme.lightTheme.colorScheme.tertiary,
                            size: 8,
                          ),
                          SizedBox(width: 2.w),
                          Expanded(
                            child: Text(
                              insight,
                              style: AppTheme.lightTheme.textTheme.bodySmall
                                  ?.copyWith(
                                color: AppTheme
                                    .lightTheme.colorScheme.onSurfaceVariant,
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  }).toList(),
                ],
              ),
            ),
            SizedBox(height: 3.h),
          ],

          // Price Input
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Asking Price *',
                style: AppTheme.lightTheme.textTheme.labelMedium,
              ),
              SizedBox(height: 1.h),
              TextFormField(
                controller: _priceController,
                keyboardType: TextInputType.number,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                  TextInputFormatter.withFunction((oldValue, newValue) {
                    final text = newValue.text;
                    if (text.isEmpty) return newValue;

                    final number = int.tryParse(text.replaceAll(',', ''));
                    if (number == null) return oldValue;

                    final formatted = _formatPrice(number);
                    return TextEditingValue(
                      text: formatted,
                      selection:
                          TextSelection.collapsed(offset: formatted.length),
                    );
                  }),
                ],
                decoration: InputDecoration(
                  hintText: '25,000',
                  prefixText: '\$ ',
                  prefixIcon: Padding(
                    padding: EdgeInsets.all(3.w),
                    child: CustomIconWidget(
                      iconName: 'attach_money',
                      color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                      size: 20,
                    ),
                  ),
                ),
                onChanged: (value) => _updatePricingData(),
              ),
            ],
          ),
          SizedBox(height: 3.h),

          // Featured Listing Toggle
          Container(
            padding: EdgeInsets.all(3.w),
            decoration: BoxDecoration(
              color: _isFeaturedListing
                  ? AppTheme.lightTheme.colorScheme.primary
                      .withValues(alpha: 0.1)
                  : AppTheme.lightTheme.colorScheme.outline
                      .withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: _isFeaturedListing
                    ? AppTheme.lightTheme.colorScheme.primary
                        .withValues(alpha: 0.3)
                    : AppTheme.lightTheme.colorScheme.outline
                        .withValues(alpha: 0.3),
              ),
            ),
            child: Column(
              children: [
                Row(
                  children: [
                    CustomIconWidget(
                      iconName: 'star',
                      color: _isFeaturedListing
                          ? AppTheme.lightTheme.colorScheme.primary
                          : AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                      size: 24,
                    ),
                    SizedBox(width: 3.w),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Featured Listing',
                            style: AppTheme.lightTheme.textTheme.titleSmall
                                ?.copyWith(
                              color: _isFeaturedListing
                                  ? AppTheme.lightTheme.colorScheme.primary
                                  : AppTheme.lightTheme.colorScheme.onSurface,
                            ),
                          ),
                          Text(
                            'Get 3x more views and priority placement',
                            style: AppTheme.lightTheme.textTheme.bodySmall
                                ?.copyWith(
                              color: AppTheme
                                  .lightTheme.colorScheme.onSurfaceVariant,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Switch(
                      value: _isFeaturedListing,
                      onChanged: (value) {
                        setState(() {
                          _isFeaturedListing = value;
                        });
                        _updatePricingData();
                      },
                    ),
                  ],
                ),
                if (_isFeaturedListing) ...[
                  SizedBox(height: 2.h),
                  Container(
                    padding: EdgeInsets.all(2.w),
                    decoration: BoxDecoration(
                      color: AppTheme.lightTheme.colorScheme.primary
                          .withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      children: [
                        CustomIconWidget(
                          iconName: 'info',
                          color: AppTheme.lightTheme.colorScheme.primary,
                          size: 16,
                        ),
                        SizedBox(width: 2.w),
                        Expanded(
                          child: Text(
                            'Featured listing: \$9.99 for 30 days. Your listing will appear at the top of search results.',
                            style: AppTheme.lightTheme.textTheme.bodySmall
                                ?.copyWith(
                              color: AppTheme.lightTheme.colorScheme.primary,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ],
            ),
          ),

          if (_marketAnalysis.isNotEmpty && !_isAnalyzing) ...[
            SizedBox(height: 2.h),
            TextButton.icon(
              onPressed: _performMarketAnalysis,
              icon: CustomIconWidget(
                iconName: 'refresh',
                color: AppTheme.lightTheme.colorScheme.primary,
                size: 16,
              ),
              label: Text('Refresh Market Analysis'),
            ),
          ],
        ],
      ),
    );
  }

  @override
  void dispose() {
    _priceController.dispose();
    super.dispose();
  }
}
