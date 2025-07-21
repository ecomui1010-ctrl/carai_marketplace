import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import './widgets/biometric_prompt_widget.dart';
import './widgets/otp_input_widget.dart';
import './widgets/phone_input_widget.dart';
import './widgets/resend_otp_widget.dart';

class AuthenticationScreen extends StatefulWidget {
  const AuthenticationScreen({Key? key}) : super(key: key);

  @override
  State<AuthenticationScreen> createState() => _AuthenticationScreenState();
}

class _AuthenticationScreenState extends State<AuthenticationScreen>
    with TickerProviderStateMixin {
  late TabController _tabController;
  final PageController _pageController = PageController();

  // Controllers
  final TextEditingController _phoneController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  // State variables
  bool _isPhoneValid = false;
  bool _isLoading = false;
  bool _isOtpSent = false;
  bool _showBiometricPrompt = false;
  String? _otpError;
  String _currentPhoneNumber = '';

  // Mock data for demonstration
  final List<Map<String, dynamic>> _mockUsers = [
    {
      "phone": "+15551234567",
      "otp": "123456",
      "isRegistered": true,
      "name": "John Doe"
    },
    {
      "phone": "+15559876543",
      "otp": "654321",
      "isRegistered": false,
      "name": "New User"
    },
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _pageController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  Future<void> _sendOtp() async {
    if (!_isPhoneValid || _isLoading) return;

    setState(() {
      _isLoading = true;
      _otpError = null;
    });

    try {
      // Simulate API call delay
      await Future.delayed(Duration(seconds: 2));

      _currentPhoneNumber = _phoneController.text;

      // Check if phone number exists in mock data
      final user = _mockUsers.firstWhere(
        (user) => user['phone'] == _currentPhoneNumber,
        orElse: () => _mockUsers[1], // Default to new user
      );

      setState(() {
        _isOtpSent = true;
        _isLoading = false;
      });

      _pageController.nextPage(
        duration: Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );

      // Show success message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('OTP sent to $_currentPhoneNumber'),
          backgroundColor: AppTheme.successLight,
        ),
      );
    } catch (e) {
      setState(() {
        _isLoading = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to send OTP. Please try again.'),
          backgroundColor: AppTheme.errorLight,
        ),
      );
    }
  }

  Future<void> _verifyOtp(String otp) async {
    setState(() {
      _isLoading = true;
      _otpError = null;
    });

    try {
      // Simulate API call delay
      await Future.delayed(Duration(seconds: 1));

      // Find user and verify OTP
      final user = _mockUsers.firstWhere(
        (user) => user['phone'] == _currentPhoneNumber,
        orElse: () => _mockUsers[1],
      );

      if (otp == user['otp']) {
        // OTP is correct
        HapticFeedback.lightImpact();

        setState(() {
          _isLoading = false;
          _showBiometricPrompt = true;
        });
      } else {
        // OTP is incorrect
        setState(() {
          _isLoading = false;
          _otpError = 'Invalid OTP. Please try again.';
        });

        HapticFeedback.heavyImpact();
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
        _otpError = 'Verification failed. Please try again.';
      });
    }
  }

  Future<void> _resendOtp() async {
    setState(() {
      _isLoading = true;
      _otpError = null;
    });

    try {
      // Simulate API call delay
      await Future.delayed(Duration(seconds: 1));

      setState(() {
        _isLoading = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('OTP resent to $_currentPhoneNumber'),
          backgroundColor: AppTheme.successLight,
        ),
      );
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _onBiometricSuccess() {
    HapticFeedback.lightImpact();
    _navigateToHome();
  }

  void _skipBiometric() {
    _navigateToHome();
  }

  void _navigateToHome() {
    Navigator.pushNamedAndRemoveUntil(
      context,
      '/home-screen',
      (route) => false,
    );
  }

  void _goBack() {
    if (_showBiometricPrompt) {
      setState(() {
        _showBiometricPrompt = false;
      });
    } else if (_isOtpSent) {
      setState(() {
        _isOtpSent = false;
        _otpError = null;
      });
      _pageController.previousPage(
        duration: Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      Navigator.pop(context);
    }
  }

  Widget _buildLogo() {
    return Container(
      width: 25.w,
      height: 25.w,
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.primary,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: AppTheme.shadowLight,
            blurRadius: 20,
            offset: Offset(0, 10),
          ),
        ],
      ),
      child: CustomIconWidget(
        iconName: 'directions_car',
        size: 12.w,
        color: AppTheme.lightTheme.colorScheme.onPrimary,
      ),
    );
  }

  Widget _buildPhoneInputScreen() {
    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(horizontal: 6.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(height: 8.h),
          _buildLogo(),
          SizedBox(height: 4.h),
          Text(
            'Welcome to CarAI',
            style: AppTheme.lightTheme.textTheme.headlineMedium?.copyWith(
              fontWeight: FontWeight.w700,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 1.h),
          Text(
            'Enter your phone number to get started',
            style: AppTheme.lightTheme.textTheme.bodyLarge?.copyWith(
              color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 6.h),
          Form(
            key: _formKey,
            child: PhoneInputWidget(
              controller: _phoneController,
              onValidationChanged: (isValid) {
                setState(() {
                  _isPhoneValid = isValid;
                });
              },
              isLoading: _isLoading,
            ),
          ),
          SizedBox(height: 4.h),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: _isPhoneValid && !_isLoading ? _sendOtp : null,
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(vertical: 2.h),
                backgroundColor: _isPhoneValid
                    ? AppTheme.lightTheme.colorScheme.primary
                    : AppTheme.lightTheme.colorScheme.outline,
              ),
              child: _isLoading
                  ? SizedBox(
                      width: 6.w,
                      height: 6.w,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(
                          AppTheme.lightTheme.colorScheme.onPrimary,
                        ),
                      ),
                    )
                  : Text(
                      'Send OTP',
                      style: AppTheme.lightTheme.textTheme.bodyLarge?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: AppTheme.lightTheme.colorScheme.onPrimary,
                      ),
                    ),
            ),
          ),
          SizedBox(height: 3.h),
          Text(
            'By continuing, you agree to our Terms of Service and Privacy Policy',
            style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
              color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildOtpVerificationScreen() {
    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(horizontal: 6.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(height: 8.h),
          _buildLogo(),
          SizedBox(height: 4.h),
          Text(
            'Verify Your Phone',
            style: AppTheme.lightTheme.textTheme.headlineMedium?.copyWith(
              fontWeight: FontWeight.w700,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 1.h),
          Text(
            'Enter the 6-digit code sent to\n$_currentPhoneNumber',
            style: AppTheme.lightTheme.textTheme.bodyLarge?.copyWith(
              color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 6.h),
          OtpInputWidget(
            onOtpCompleted: _verifyOtp,
            isLoading: _isLoading,
            errorMessage: _otpError,
          ),
          SizedBox(height: 4.h),
          ResendOtpWidget(
            onResend: _resendOtp,
            isLoading: _isLoading,
          ),
          SizedBox(height: 6.h),
          Text(
            'Mock Credentials:\nPhone: +15551234567, OTP: 123456\nPhone: +15559876543, OTP: 654321',
            style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
              color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
              fontStyle: FontStyle.italic,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.lightTheme.scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          onPressed: _goBack,
          icon: CustomIconWidget(
            iconName: 'arrow_back_ios',
            size: 24,
            color: AppTheme.lightTheme.colorScheme.onSurface,
          ),
        ),
        systemOverlayStyle: SystemUiOverlayStyle.dark,
      ),
      body: SafeArea(
        child: Stack(
          children: [
            PageView(
              controller: _pageController,
              physics: NeverScrollableScrollPhysics(),
              children: [
                _buildPhoneInputScreen(),
                _buildOtpVerificationScreen(),
              ],
            ),
            if (_showBiometricPrompt)
              Container(
                color: Colors.black.withValues(alpha: 0.5),
                child: Center(
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 8.w),
                    child: BiometricPromptWidget(
                      onBiometricSuccess: _onBiometricSuccess,
                      onSkip: _skipBiometric,
                      isLoading: _isLoading,
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
