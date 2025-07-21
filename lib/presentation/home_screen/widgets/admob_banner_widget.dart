import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../../services/admob_service.dart';

class AdMobBannerWidget extends StatefulWidget {
  final AdSize adSize;
  final EdgeInsets? margin;

  const AdMobBannerWidget({
    super.key,
    this.adSize = AdSize.banner,
    this.margin,
  });

  @override
  State<AdMobBannerWidget> createState() => _AdMobBannerWidgetState();
}

class _AdMobBannerWidgetState extends State<AdMobBannerWidget> {
  BannerAd? _bannerAd;
  bool _isAdLoaded = false;
  bool _isAdFailed = false;

  @override
  void initState() {
    super.initState();
    _loadAd();
  }

  void _loadAd() async {
    try {
      _bannerAd = await AdMobService.createBannerAd(
        adSize: widget.adSize,
        onAdLoaded: (Ad ad) {
          if (mounted) {
            setState(() {
              _isAdLoaded = true;
              _isAdFailed = false;
            });
          }
        },
        onAdFailedToLoad: (Ad ad, LoadAdError error) {
          ad.dispose();
          if (mounted) {
            setState(() {
              _isAdLoaded = false;
              _isAdFailed = true;
            });
          }
        },
      );

      await _bannerAd?.load();
    } catch (e) {
      if (mounted) {
        setState(() {
          _isAdLoaded = false;
          _isAdFailed = true;
        });
      }
    }
  }

  @override
  void dispose() {
    _bannerAd?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final margin =
        widget.margin ?? EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h);

    if (_isAdFailed) {
      return Container(margin: margin, child: _buildFallbackAd());
    }

    if (!_isAdLoaded || _bannerAd == null) {
      return Container(margin: margin, child: _buildAdPlaceholder());
    }

    return Container(
      margin: margin,
      child: _buildLoadedAd(),
    );
  }

  Widget _buildLoadedAd() {
    return Container(
      width: double.infinity,
      height: _bannerAd!.size.height.toDouble(),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: AppTheme.shadowLight,
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: AdWidget(ad: _bannerAd!),
      ),
    );
  }

  Widget _buildAdPlaceholder() {
    return Container(
      width: double.infinity,
      height: widget.adSize.height.toDouble(),
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppTheme.dividerLight,
          width: 1,
        ),
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              width: 6.w,
              height: 6.w,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                valueColor: AlwaysStoppedAnimation<Color>(
                  AppTheme.lightTheme.colorScheme.primary,
                ),
              ),
            ),
            SizedBox(height: 1.h),
            Text(
              'Loading Ad...',
              style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                color: AppTheme.textSecondaryLight,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFallbackAd() {
    return Container(
      width: double.infinity,
      height: widget.adSize.height.toDouble(),
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppTheme.dividerLight,
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: AppTheme.shadowLight,
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: Stack(
          children: [
            // Background gradient
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    AppTheme.lightTheme.colorScheme.primary
                        .withValues(alpha: 0.1),
                    AppTheme.accentLight.withValues(alpha: 0.1),
                  ],
                ),
              ),
            ),

            // Content
            Padding(
              padding: EdgeInsets.all(3.w),
              child: Row(
                children: [
                  // Icon
                  Container(
                    width: 12.w,
                    height: 12.w,
                    decoration: BoxDecoration(
                      color: AppTheme.accentLight,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: CustomIconWidget(
                      iconName: 'local_offer',
                      color: Colors.white,
                      size: 24,
                    ),
                  ),

                  SizedBox(width: 3.w),

                  // Text content
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Discover Great Deals',
                          style: AppTheme.lightTheme.textTheme.titleSmall
                              ?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        SizedBox(height: 0.5.h),
                        Text(
                          'Find your perfect car with exclusive offers',
                          style:
                              AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                            color: AppTheme.textSecondaryLight,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),

                  SizedBox(width: 2.w),

                  // CTA button
                  Container(
                    padding:
                        EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
                    decoration: BoxDecoration(
                      color: AppTheme.lightTheme.colorScheme.primary,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      'Explore',
                      style:
                          AppTheme.lightTheme.textTheme.labelMedium?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // "Ad" label
            Positioned(
              top: 1.w,
              left: 1.w,
              child: Container(
                padding:
                    EdgeInsets.symmetric(horizontal: 1.5.w, vertical: 0.2.h),
                decoration: BoxDecoration(
                  color: AppTheme.textSecondaryLight.withValues(alpha: 0.8),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  'Ad',
                  style: AppTheme.lightTheme.textTheme.labelSmall?.copyWith(
                    color: Colors.white,
                    fontSize: 8.sp,
                  ),
                ),
              ),
            ),

            // Retry button
            Positioned(
              top: 1.w,
              right: 1.w,
              child: GestureDetector(
                onTap: () {
                  setState(() {
                    _isAdFailed = false;
                    _isAdLoaded = false;
                  });
                  _loadAd();
                },
                child: Container(
                  padding: EdgeInsets.all(1.w),
                  decoration: BoxDecoration(
                    color: Colors.black26,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: CustomIconWidget(
                    iconName: 'refresh',
                    color: Colors.white,
                    size: 12,
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
