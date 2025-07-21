import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../../theme/app_theme.dart';

class OtpInputWidget extends StatefulWidget {
  final Function(String) onOtpCompleted;
  final bool isLoading;
  final String? errorMessage;

  const OtpInputWidget({
    Key? key,
    required this.onOtpCompleted,
    this.isLoading = false,
    this.errorMessage,
  }) : super(key: key);

  @override
  State<OtpInputWidget> createState() => _OtpInputWidgetState();
}

class _OtpInputWidgetState extends State<OtpInputWidget> {
  final List<TextEditingController> _controllers =
      List.generate(6, (index) => TextEditingController());
  final List<FocusNode> _focusNodes = List.generate(6, (index) => FocusNode());
  String _otp = '';

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_focusNodes.isNotEmpty) {
        _focusNodes[0].requestFocus();
      }
    });
  }

  @override
  void dispose() {
    for (var controller in _controllers) {
      controller.dispose();
    }
    for (var focusNode in _focusNodes) {
      focusNode.dispose();
    }
    super.dispose();
  }

  void _onChanged(String value, int index) {
    if (value.isNotEmpty) {
      if (index < 5) {
        _focusNodes[index + 1].requestFocus();
      } else {
        _focusNodes[index].unfocus();
      }
    }

    _updateOtp();
  }

  void _onBackspace(int index) {
    if (_controllers[index].text.isEmpty && index > 0) {
      _focusNodes[index - 1].requestFocus();
      _controllers[index - 1].clear();
    }
    _updateOtp();
  }

  void _updateOtp() {
    final otp = _controllers.map((controller) => controller.text).join();
    setState(() {
      _otp = otp;
    });

    if (otp.length == 6) {
      widget.onOtpCompleted(otp);
    }
  }

  void clearOtp() {
    for (var controller in _controllers) {
      controller.clear();
    }
    setState(() {
      _otp = '';
    });
    _focusNodes[0].requestFocus();
  }

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: List.generate(6, (index) {
            return Container(
                width: 12.w,
                height: 6.h,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                        color: widget.errorMessage != null
                            ? AppTheme.errorLight
                            : _controllers[index].text.isNotEmpty
                                ? AppTheme.lightTheme.colorScheme.primary
                                : AppTheme.lightTheme.colorScheme.outline,
                        width: _controllers[index].text.isNotEmpty ? 2 : 1),
                    color: widget.isLoading
                        ? AppTheme.lightTheme.colorScheme.surface
                            .withValues(alpha: 0.5)
                        : AppTheme.lightTheme.colorScheme.surface),
                child: TextFormField(
                    controller: _controllers[index],
                    focusNode: _focusNodes[index],
                    enabled: !widget.isLoading,
                    textAlign: TextAlign.center,
                    keyboardType: TextInputType.number,
                    maxLength: 1,
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                    ],
                    decoration: InputDecoration(
                        counterText: '',
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.zero),
                    style: AppTheme.lightTheme.textTheme.headlineSmall
                        ?.copyWith(
                            fontWeight: FontWeight.w600,
                            color: widget.errorMessage != null
                                ? AppTheme.errorLight
                                : AppTheme.lightTheme.colorScheme.onSurface),
                    onChanged: (value) => _onChanged(value, index),
                    onTap: () {
                      if (_controllers[index].text.isNotEmpty) {
                        _controllers[index].selection =
                            TextSelection.fromPosition(TextPosition(
                                offset: _controllers[index].text.length));
                      }
                    }));
          })),
      if (widget.errorMessage != null)
        Padding(
            padding: EdgeInsets.only(top: 1.h),
            child: Text(widget.errorMessage!,
                style: AppTheme.lightTheme.textTheme.bodySmall
                    ?.copyWith(color: AppTheme.errorLight),
                textAlign: TextAlign.center)),
    ]);
  }
}
