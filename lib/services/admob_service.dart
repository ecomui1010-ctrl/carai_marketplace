import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class AdMobService {
  static final AdMobService _instance = AdMobService._internal();
  factory AdMobService() => _instance;
  AdMobService._internal();

  static bool _initialized = false;

  // Test Ad Unit IDs
  static String get bannerAdUnitId {
    if (kIsWeb) {
      return 'ca-app-pub-3940256099942544/6300978111'; // Test banner for web
    } else if (Platform.isAndroid) {
      return 'ca-app-pub-3940256099942544/6300978111'; // Test banner for Android
    } else if (Platform.isIOS) {
      return 'ca-app-pub-3940256099942544/2934735716'; // Test banner for iOS
    } else {
      throw UnsupportedError('Unsupported platform');
    }
  }

  static String get interstitialAdUnitId {
    if (kIsWeb) {
      return 'ca-app-pub-3940256099942544/1033173712'; // Test interstitial for web
    } else if (Platform.isAndroid) {
      return 'ca-app-pub-3940256099942544/1033173712'; // Test interstitial for Android
    } else if (Platform.isIOS) {
      return 'ca-app-pub-3940256099942544/4411468910'; // Test interstitial for iOS
    } else {
      throw UnsupportedError('Unsupported platform');
    }
  }

  static String get rewardedAdUnitId {
    if (kIsWeb) {
      return 'ca-app-pub-3940256099942544/5224354917'; // Test rewarded for web
    } else if (Platform.isAndroid) {
      return 'ca-app-pub-3940256099942544/5224354917'; // Test rewarded for Android
    } else if (Platform.isIOS) {
      return 'ca-app-pub-3940256099942544/1712485313'; // Test rewarded for iOS
    } else {
      throw UnsupportedError('Unsupported platform');
    }
  }

  static Future<void> initialize() async {
    if (_initialized) return;

    try {
      await MobileAds.instance.initialize();
      _initialized = true;
    } catch (e) {
      if (kDebugMode) {
        print('AdMob initialization failed: $e');
      }
    }
  }

  static bool get isInitialized => _initialized;

  static Future<BannerAd> createBannerAd({
    AdSize adSize = AdSize.banner,
    void Function(Ad, LoadAdError)? onAdFailedToLoad,
    void Function(Ad)? onAdLoaded,
  }) async {
    await initialize();

    return BannerAd(
      adUnitId: bannerAdUnitId,
      size: adSize,
      request: const AdRequest(),
      listener: BannerAdListener(
        onAdLoaded: onAdLoaded ??
            (Ad ad) {
              if (kDebugMode) {
                print('Banner ad loaded');
              }
            },
        onAdFailedToLoad: onAdFailedToLoad ??
            (Ad ad, LoadAdError error) {
              if (kDebugMode) {
                print('Banner ad failed to load: $error');
              }
              ad.dispose();
            },
        onAdOpened: (Ad ad) {
          if (kDebugMode) {
            print('Banner ad opened');
          }
        },
        onAdClosed: (Ad ad) {
          if (kDebugMode) {
            print('Banner ad closed');
          }
        },
      ),
    );
  }

  static Future<InterstitialAd?> loadInterstitialAd() async {
    await initialize();

    InterstitialAd? interstitialAd;

    await InterstitialAd.load(
      adUnitId: interstitialAdUnitId,
      request: const AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (InterstitialAd ad) {
          interstitialAd = ad;
          if (kDebugMode) {
            print('Interstitial ad loaded');
          }
        },
        onAdFailedToLoad: (LoadAdError error) {
          if (kDebugMode) {
            print('Interstitial ad failed to load: $error');
          }
        },
      ),
    );

    return interstitialAd;
  }

  static Future<RewardedAd?> loadRewardedAd() async {
    await initialize();

    RewardedAd? rewardedAd;

    await RewardedAd.load(
      adUnitId: rewardedAdUnitId,
      request: const AdRequest(),
      rewardedAdLoadCallback: RewardedAdLoadCallback(
        onAdLoaded: (RewardedAd ad) {
          rewardedAd = ad;
          if (kDebugMode) {
            print('Rewarded ad loaded');
          }
        },
        onAdFailedToLoad: (LoadAdError error) {
          if (kDebugMode) {
            print('Rewarded ad failed to load: $error');
          }
        },
      ),
    );

    return rewardedAd;
  }
}
