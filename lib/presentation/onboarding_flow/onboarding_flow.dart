import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import '../../theme/app_theme.dart';
import './widgets/navigation_button_widget.dart';
import './widgets/onboarding_page_widget.dart';
import './widgets/page_indicator_widget.dart';
import './widgets/skip_button_widget.dart';

class OnboardingFlow extends StatefulWidget {
  const OnboardingFlow({Key? key}) : super(key: key);

  @override
  State<OnboardingFlow> createState() => _OnboardingFlowState();
}

class _OnboardingFlowState extends State<OnboardingFlow>
    with TickerProviderStateMixin {
  late PageController _pageController;
  late AnimationController _animationController;
  int _currentPage = 0;
  final int _totalPages = 3;

  // Mock data for onboarding screens
  final List<Map<String, dynamic>> _onboardingData = [
    {
      "title": "Discover Cars in 3D",
      "description":
          "Experience immersive 3D car browsing with rotating models and detailed views. See every angle before you buy.",
      "imageUrl":
          "https://images.pexels.com/photos/3802510/pexels-photo-3802510.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=2",
      "showAnimation": true,
    },
    {
      "title": "AI-Powered Recommendations",
      "description":
          "Get personalized car suggestions based on your preferences, budget, and driving needs with our smart AI engine.",
      "imageUrl":
          "https://images.pixabay.com/photo/2016/12/03/18/57/car-1880381_1280.jpg",
      "showAnimation": true,
    },
    {
      "title": "Smart Listing Creation",
      "description":
          "Create professional listings with AI-generated descriptions, damage detection, and competitive pricing suggestions.",
      "imageUrl":
          "https://images.unsplash.com/photo-1503376780353-7e6692767b70?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=1470&q=80",
      "showAnimation": true,
    },
  ];

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
  }

  @override
  void dispose() {
    _pageController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  void _onPageChanged(int page) {
    setState(() {
      _currentPage = page;
    });
    _animationController.forward().then((_) {
      _animationController.reset();
    });
  }

  void _nextPage() {
    if (_currentPage < _totalPages - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      _navigateToAuth();
    }
  }

  void _skipOnboarding() {
    _navigateToAuth();
  }

  void _navigateToAuth() {
    Navigator.pushReplacementNamed(context, '/authentication-screen');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.lightTheme.scaffoldBackgroundColor,
      body: Stack(
        children: [
          // Background gradient for depth
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  AppTheme.lightTheme.scaffoldBackgroundColor,
                  AppTheme.lightTheme.colorScheme.primary
                      .withValues(alpha: 0.02),
                ],
              ),
            ),
          ),

          // Skip button
          SkipButtonWidget(
            onPressed: _skipOnboarding,
          ),

          // Main content
          SafeArea(
            child: Column(
              children: [
                // Page view with onboarding screens
                Expanded(
                  flex: 8,
                  child: PageView.builder(
                    controller: _pageController,
                    onPageChanged: _onPageChanged,
                    itemCount: _totalPages,
                    itemBuilder: (context, index) {
                      final data = _onboardingData[index];
                      return OnboardingPageWidget(
                        title: data["title"] as String,
                        description: data["description"] as String,
                        imageUrl: data["imageUrl"] as String,
                        showAnimation: _currentPage == index &&
                            (data["showAnimation"] as bool? ?? false),
                      );
                    },
                  ),
                ),

                // Bottom section with indicators and navigation
                Expanded(
                  flex: 2,
                  child: Container(
                    padding:
                        EdgeInsets.symmetric(horizontal: 6.w, vertical: 2.h),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        // Page indicators
                        PageIndicatorWidget(
                          currentPage: _currentPage,
                          totalPages: _totalPages,
                        ),

                        // Navigation button
                        NavigationButtonWidget(
                          text: _currentPage == _totalPages - 1
                              ? 'Get Started'
                              : 'Next',
                          onPressed: _nextPage,
                          isPrimary: true,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
