import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class PhoneInputWidget extends StatefulWidget {
  final TextEditingController controller;
  final Function(bool) onValidationChanged;
  final bool isLoading;

  const PhoneInputWidget({
    Key? key,
    required this.controller,
    required this.onValidationChanged,
    this.isLoading = false,
  }) : super(key: key);

  @override
  State<PhoneInputWidget> createState() => _PhoneInputWidgetState();
}

class _PhoneInputWidgetState extends State<PhoneInputWidget> {
  String _selectedCountryCode = '+1';
  bool _isValid = false;

  final List<Map<String, String>> _countryCodes = [
    {'code': '+1', 'country': 'US', 'flag': '🇺🇸'},
    {'code': '+44', 'country': 'UK', 'flag': '🇬🇧'},
    {'code': '+91', 'country': 'IN', 'flag': '🇮🇳'},
    {'code': '+86', 'country': 'CN', 'flag': '🇨🇳'},
    {'code': '+49', 'country': 'DE', 'flag': '🇩🇪'},
    {'code': '+33', 'country': 'FR', 'flag': '🇫🇷'},
    {'code': '+81', 'country': 'JP', 'flag': '🇯🇵'},
    {'code': '+82', 'country': 'KR', 'flag': '🇰🇷'},
  ];

  @override
  void initState() {
    super.initState();
    widget.controller.addListener(_validatePhoneNumber);
  }

  @override
  void dispose() {
    widget.controller.removeListener(_validatePhoneNumber);
    super.dispose();
  }

  void _validatePhoneNumber() {
    final phoneNumber = widget.controller.text.replaceAll(RegExp(r'[^\d]'), '');
    bool isValid = false;

    switch (_selectedCountryCode) {
      case '+1':
        isValid = phoneNumber.length == 10;
        break;
      case '+44':
        isValid = phoneNumber.length >= 10 && phoneNumber.length <= 11;
        break;
      case '+91':
        isValid = phoneNumber.length == 10;
        break;
      default:
        isValid = phoneNumber.length >= 8 && phoneNumber.length <= 15;
    }

    if (_isValid != isValid) {
      setState(() {
        _isValid = isValid;
      });
      widget.onValidationChanged(isValid);
    }
  }

  String _formatPhoneNumber(String value) {
    final digitsOnly = value.replaceAll(RegExp(r'[^\d]'), '');

    if (_selectedCountryCode == '+1' && digitsOnly.length <= 10) {
      if (digitsOnly.length >= 6) {
        return '(${digitsOnly.substring(0, 3)}) ${digitsOnly.substring(3, 6)}-${digitsOnly.substring(6)}';
      } else if (digitsOnly.length >= 3) {
        return '(${digitsOnly.substring(0, 3)}) ${digitsOnly.substring(3)}';
      }
    }

    return digitsOnly;
  }

  void _showCountryPicker() {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppTheme.lightTheme.colorScheme.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Container(
        height: 50.h,
        padding: EdgeInsets.symmetric(vertical: 2.h),
        child: Column(
          children: [
            Container(
              width: 12.w,
              height: 0.5.h,
              decoration: BoxDecoration(
                color: AppTheme.lightTheme.colorScheme.outline,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            SizedBox(height: 2.h),
            Text(
              'Select Country',
              style: AppTheme.lightTheme.textTheme.titleLarge,
            ),
            SizedBox(height: 2.h),
            Expanded(
              child: ListView.builder(
                itemCount: _countryCodes.length,
                itemBuilder: (context, index) {
                  final country = _countryCodes[index];
                  return ListTile(
                    leading: Text(
                      country['flag']!,
                      style: TextStyle(fontSize: 24),
                    ),
                    title: Text(
                      '${country['country']} ${country['code']}',
                      style: AppTheme.lightTheme.textTheme.bodyLarge,
                    ),
                    selected: _selectedCountryCode == country['code'],
                    selectedTileColor: AppTheme.lightTheme.colorScheme.primary
                        .withValues(alpha: 0.1),
                    onTap: () {
                      setState(() {
                        _selectedCountryCode = country['code']!;
                      });
                      widget.controller.clear();
                      Navigator.pop(context);
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Phone Number',
          style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(height: 1.h),
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: _isValid
                  ? AppTheme.lightTheme.colorScheme.primary
                  : AppTheme.lightTheme.colorScheme.outline,
              width: _isValid ? 2 : 1,
            ),
          ),
          child: Row(
            children: [
              InkWell(
                onTap: widget.isLoading ? null : _showCountryPicker,
                borderRadius:
                    BorderRadius.horizontal(left: Radius.circular(12)),
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
                  decoration: BoxDecoration(
                    border: Border(
                      right: BorderSide(
                        color: AppTheme.lightTheme.colorScheme.outline,
                        width: 1,
                      ),
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        _countryCodes.firstWhere(
                          (country) => country['code'] == _selectedCountryCode,
                        )['flag']!,
                        style: TextStyle(fontSize: 20),
                      ),
                      SizedBox(width: 2.w),
                      Text(
                        _selectedCountryCode,
                        style:
                            AppTheme.lightTheme.textTheme.bodyLarge?.copyWith(
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      SizedBox(width: 1.w),
                      CustomIconWidget(
                        iconName: 'keyboard_arrow_down',
                        size: 20,
                        color: AppTheme.lightTheme.colorScheme.onSurface,
                      ),
                    ],
                  ),
                ),
              ),
              Expanded(
                child: TextFormField(
                  controller: widget.controller,
                  enabled: !widget.isLoading,
                  keyboardType: TextInputType.phone,
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                    LengthLimitingTextInputFormatter(15),
                    TextInputFormatter.withFunction((oldValue, newValue) {
                      final formatted = _formatPhoneNumber(newValue.text);
                      return TextEditingValue(
                        text: formatted,
                        selection:
                            TextSelection.collapsed(offset: formatted.length),
                      );
                    }),
                  ],
                  decoration: InputDecoration(
                    hintText: _selectedCountryCode == '+1'
                        ? '(555) 123-4567'
                        : 'Enter phone number',
                    border: InputBorder.none,
                    contentPadding:
                        EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
                    suffixIcon: _isValid
                        ? Padding(
                            padding: EdgeInsets.only(right: 3.w),
                            child: CustomIconWidget(
                              iconName: 'check_circle',
                              size: 20,
                              color: AppTheme.successLight,
                            ),
                          )
                        : null,
                  ),
                  style: AppTheme.lightTheme.textTheme.bodyLarge,
                ),
              ),
            ],
          ),
        ),
        if (widget.controller.text.isNotEmpty && !_isValid)
          Padding(
            padding: EdgeInsets.only(top: 0.5.h, left: 2.w),
            child: Text(
              'Please enter a valid phone number',
              style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                color: AppTheme.errorLight,
              ),
            ),
          ),
      ],
    );
  }
}
