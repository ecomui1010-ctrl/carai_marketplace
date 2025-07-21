import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../../services/gemini_service.dart';

class AiDescriptionWidget extends StatefulWidget {
  final Function(String) onDescriptionChanged;
  final String description;
  final Map<String, dynamic> vehicleDetails;
  final bool hasPhotos;

  const AiDescriptionWidget({
    Key? key,
    required this.onDescriptionChanged,
    required this.description,
    required this.vehicleDetails,
    required this.hasPhotos,
  }) : super(key: key);

  @override
  State<AiDescriptionWidget> createState() => _AiDescriptionWidgetState();
}

class _AiDescriptionWidgetState extends State<AiDescriptionWidget> {
  final TextEditingController _descriptionController = TextEditingController();
  late final GeminiClient _geminiClient;
  bool _isGenerating = false;
  bool _isEditing = false;
  String? _lastError;

  @override
  void initState() {
    super.initState();
    _descriptionController.text = widget.description;

    try {
      final service = GeminiService();
      _geminiClient = GeminiClient(service.dio, service.authApiKey);
    } catch (e) {
      _lastError = 'Gemini API not configured. Please add GEMINI_API_KEY.';
    }
  }

  Future<void> _generateAiDescription() async {
    if (!widget.hasPhotos || widget.vehicleDetails['make'] == null) {
      return;
    }

    if (_lastError != null) {
      _showErrorDialog(_lastError!);
      return;
    }

    setState(() {
      _isGenerating = true;
      _lastError = null;
    });

    try {
      final make = widget.vehicleDetails['make'] ?? '';
      final model = widget.vehicleDetails['model'] ?? '';
      final year = widget.vehicleDetails['year']?.toString() ?? '';
      final mileage = widget.vehicleDetails['mileage']?.toString() ?? '';
      final condition = widget.vehicleDetails['condition'] ?? '';
      final fuelType = widget.vehicleDetails['fuelType'] ?? '';
      final transmission = widget.vehicleDetails['transmission'] ?? '';
      final color = widget.vehicleDetails['color'] ?? '';

      final prompt = _buildDescriptionPrompt(
        make: make,
        model: model,
        year: year,
        mileage: mileage,
        condition: condition,
        fuelType: fuelType,
        transmission: transmission,
        color: color,
      );

      final messages = [
        Message(role: 'user', content: prompt),
      ];

      final response = await _geminiClient.createChat(
        messages: messages,
        model: 'gemini-1.5-flash-002',
        maxTokens: 500,
        temperature: 0.7,
      );

      final aiDescription = response.text.trim();

      if (aiDescription.isNotEmpty) {
        setState(() {
          _descriptionController.text = aiDescription;
          _isGenerating = false;
        });
        widget.onDescriptionChanged(aiDescription);
      } else {
        throw Exception('Empty response from Gemini API');
      }
    } catch (e) {
      setState(() {
        _isGenerating = false;
        _lastError = _getErrorMessage(e);
      });

      // Fallback to local generation
      final fallbackDescription = _generateFallbackDescription(
        make: widget.vehicleDetails['make'] ?? '',
        model: widget.vehicleDetails['model'] ?? '',
        year: widget.vehicleDetails['year']?.toString() ?? '',
        mileage: widget.vehicleDetails['mileage']?.toString() ?? '',
        condition: widget.vehicleDetails['condition'] ?? '',
        fuelType: widget.vehicleDetails['fuelType'] ?? '',
        transmission: widget.vehicleDetails['transmission'] ?? '',
      );

      setState(() {
        _descriptionController.text = fallbackDescription;
      });
      widget.onDescriptionChanged(fallbackDescription);
    }
  }

  String _buildDescriptionPrompt({
    required String make,
    required String model,
    required String year,
    required String mileage,
    required String condition,
    required String fuelType,
    required String transmission,
    required String color,
  }) {
    return '''
Create a compelling and professional car listing description for a $year $make $model with the following details:
- Mileage: $mileage miles
- Condition: $condition
- Fuel Type: $fuelType
- Transmission: $transmission
- Color: $color

Please write a description that:
1. Highlights the vehicle's key selling points
2. Mentions the condition and mileage appropriately
3. Includes appeal for potential buyers
4. Keeps it concise (under 200 words)
5. Uses professional, friendly tone
6. Avoids excessive marketing language

Do not include pricing information or contact details.
''';
  }

  String _generateFallbackDescription({
    required String make,
    required String model,
    required String year,
    required String mileage,
    required String condition,
    required String fuelType,
    required String transmission,
  }) {
    final descriptions = [
      "This well-maintained $year $make $model is in $condition condition with $mileage miles on the odometer. Features a reliable $fuelType engine paired with $transmission transmission for smooth driving experience. Perfect for daily commuting or weekend adventures. Regular maintenance records available. Clean title, no accidents reported.",
      "Excellent $year $make $model available for immediate sale! With only $mileage miles, this vehicle has been carefully maintained and is in $condition condition. The $fuelType engine provides great fuel efficiency while the $transmission transmission ensures comfortable driving. All scheduled maintenance up to date. Serious inquiries only.",
      "Looking to sell my beloved $year $make $model with $mileage miles. This vehicle has served me well and is in $condition condition. Features include $fuelType engine and $transmission transmission. Always garaged, non-smoker owned. Recent service completed including oil change and inspection. Ready for its next owner!",
      "Beautiful $year $make $model for sale! This $condition vehicle has $mileage miles and runs perfectly. The $fuelType engine is fuel-efficient and the $transmission transmission shifts smoothly. Well-cared for with regular maintenance. Clean interior and exterior. Must see to appreciate the quality of this vehicle.",
    ];

    return descriptions[DateTime.now().millisecond % descriptions.length];
  }

  String _getErrorMessage(dynamic error) {
    if (error is GeminiException) {
      switch (error.statusCode) {
        case 400:
          return 'Invalid request. Please check vehicle details.';
        case 401:
          return 'API key invalid. Please check configuration.';
        case 403:
          return 'API access denied. Check your API quota.';
        case 429:
          return 'Too many requests. Please try again later.';
        case 500:
          return 'Server error. Please try again.';
        default:
          return 'Failed to generate description: ${error.message}';
      }
    }
    return 'Network error. Using fallback generation.';
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('AI Generation Error'),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('OK'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final canGenerate =
        widget.hasPhotos && widget.vehicleDetails['make'] != null;

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
                iconName: 'auto_awesome',
                color: AppTheme.lightTheme.colorScheme.primary,
                size: 24,
              ),
              SizedBox(width: 2.w),
              Expanded(
                child: Text(
                  'AI-Generated Description',
                  style: AppTheme.lightTheme.textTheme.titleMedium,
                ),
              ),
              if (canGenerate && !_isGenerating)
                TextButton.icon(
                  onPressed: _generateAiDescription,
                  icon: CustomIconWidget(
                    iconName: 'refresh',
                    color: AppTheme.lightTheme.colorScheme.primary,
                    size: 16,
                  ),
                  label: Text('Generate'),
                ),
            ],
          ),
          SizedBox(height: 2.h),

          // Error message
          if (_lastError != null) ...[
            Container(
              padding: EdgeInsets.all(3.w),
              decoration: BoxDecoration(
                color: Colors.orange.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  CustomIconWidget(
                    iconName: 'warning',
                    color: Colors.orange,
                    size: 20,
                  ),
                  SizedBox(width: 2.w),
                  Expanded(
                    child: Text(
                      _lastError!,
                      style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                        color: Colors.orange.shade700,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 2.h),
          ],

          if (!canGenerate) ...[
            Container(
              padding: EdgeInsets.all(3.w),
              decoration: BoxDecoration(
                color: AppTheme.lightTheme.colorScheme.outline
                    .withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  CustomIconWidget(
                    iconName: 'info',
                    color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                    size: 20,
                  ),
                  SizedBox(width: 2.w),
                  Expanded(
                    child: Text(
                      'Add photos and vehicle details to generate AI description',
                      style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                        color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ] else if (_isGenerating) ...[
            Container(
              height: 20.h,
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
                    'Gemini AI is analyzing your vehicle...',
                    style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                      color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                  SizedBox(height: 1.h),
                  Text(
                    'Creating personalized description',
                    style: AppTheme.lightTheme.textTheme.bodySmall,
                  ),
                ],
              ),
            ),
          ] else ...[
            Stack(
              children: [
                TextFormField(
                  controller: _descriptionController,
                  maxLines: 8,
                  enabled: _isEditing,
                  decoration: InputDecoration(
                    hintText: 'Vehicle description will appear here...',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(
                        color: AppTheme.lightTheme.colorScheme.outline
                            .withValues(alpha: 0.3),
                      ),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(
                        color: AppTheme.lightTheme.colorScheme.outline
                            .withValues(alpha: 0.3),
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(
                        color: AppTheme.lightTheme.colorScheme.primary,
                        width: 2,
                      ),
                    ),
                    fillColor: _isEditing
                        ? AppTheme.lightTheme.colorScheme.surface
                        : AppTheme.lightTheme.colorScheme.surface
                            .withValues(alpha: 0.5),
                    filled: true,
                  ),
                  onChanged: widget.onDescriptionChanged,
                ),
                if (!_isEditing && _descriptionController.text.isNotEmpty)
                  Positioned(
                    top: 8,
                    right: 8,
                    child: Container(
                      padding: EdgeInsets.symmetric(
                          horizontal: 2.w, vertical: 0.5.h),
                      decoration: BoxDecoration(
                        color: AppTheme.lightTheme.colorScheme.tertiary
                            .withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(6),
                        border: Border.all(
                          color: AppTheme.lightTheme.colorScheme.tertiary
                              .withValues(alpha: 0.3),
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          CustomIconWidget(
                            iconName: 'auto_awesome',
                            color: AppTheme.lightTheme.colorScheme.tertiary,
                            size: 12,
                          ),
                          SizedBox(width: 1.w),
                          Text(
                            'Gemini AI',
                            style: AppTheme.lightTheme.textTheme.labelSmall
                                ?.copyWith(
                              color: AppTheme.lightTheme.colorScheme.tertiary,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
              ],
            ),
            if (_descriptionController.text.isNotEmpty) ...[
              SizedBox(height: 2.h),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () {
                        setState(() {
                          _isEditing = !_isEditing;
                        });
                      },
                      icon: CustomIconWidget(
                        iconName: _isEditing ? 'check' : 'edit',
                        color: AppTheme.lightTheme.colorScheme.primary,
                        size: 16,
                      ),
                      label: Text(
                          _isEditing ? 'Save Changes' : 'Edit Description'),
                    ),
                  ),
                  SizedBox(width: 3.w),
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: _generateAiDescription,
                      icon: CustomIconWidget(
                        iconName: 'refresh',
                        color: AppTheme.lightTheme.colorScheme.primary,
                        size: 16,
                      ),
                      label: Text('Regenerate'),
                    ),
                  ),
                ],
              ),
            ],
          ],
          if (_descriptionController.text.isNotEmpty && !_isGenerating) ...[
            SizedBox(height: 2.h),
            Container(
              padding: EdgeInsets.all(3.w),
              decoration: BoxDecoration(
                color: AppTheme.lightTheme.colorScheme.tertiary
                    .withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  CustomIconWidget(
                    iconName: 'lightbulb',
                    color: AppTheme.lightTheme.colorScheme.tertiary,
                    size: 16,
                  ),
                  SizedBox(width: 2.w),
                  Expanded(
                    child: Text(
                      _lastError == null
                          ? 'Gemini AI analyzed your vehicle details to create this description. You can edit it anytime.'
                          : 'Generated using fallback system. For better results, configure Gemini API.',
                      style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                        color: AppTheme.lightTheme.colorScheme.tertiary,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  @override
  void dispose() {
    _descriptionController.dispose();
    super.dispose();
  }
}
