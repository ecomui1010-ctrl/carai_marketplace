import 'package:flutter/material.dart';
import '../presentation/onboarding_flow/onboarding_flow.dart';
import '../presentation/authentication_screen/authentication_screen.dart';
import '../presentation/vehicle_detail_screen/vehicle_detail_screen.dart';
import '../presentation/home_screen/home_screen.dart';
import '../presentation/search_screen/search_screen.dart';
import '../presentation/sell_vehicle_screen/sell_vehicle_screen.dart';
import '../presentation/profile_screen/profile_screen.dart';
import '../presentation/saved_vehicles_screen/saved_vehicles_screen.dart';

class AppRoutes {
  // TODO: Add your routes here
  static const String initial = '/';
  static const String onboardingFlow = '/onboarding-flow';
  static const String authenticationScreen = '/authentication-screen';
  static const String vehicleDetailScreen = '/vehicle-detail-screen';
  static const String homeScreen = '/home-screen';
  static const String searchScreen = '/search-screen';
  static const String sellVehicleScreen = '/sell-vehicle-screen';
  static const String profileScreen = '/profile-screen';
  static const String savedScreen = '/saved-screen';

  static Map<String, WidgetBuilder> routes = {
    initial: (context) => const OnboardingFlow(),
    onboardingFlow: (context) => const OnboardingFlow(),
    authenticationScreen: (context) => const AuthenticationScreen(),
    vehicleDetailScreen: (context) => const VehicleDetailScreen(),
    homeScreen: (context) => const HomeScreen(),
    searchScreen: (context) => const SearchScreen(),
    sellVehicleScreen: (context) => const SellVehicleScreen(),
    profileScreen: (context) => const ProfileScreen(),
    savedScreen: (context) => const SavedVehiclesScreen(),
    // TODO: Add your other routes here
  };
}
