import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class SavedVehicleCardWidget extends StatefulWidget {
  final Map<String, dynamic> vehicle;
  final VoidCallback onTap;
  final VoidCallback onRemove;
  final VoidCallback onShare;

  const SavedVehicleCardWidget({
    Key? key,
    required this.vehicle,
    required this.onTap,
    required this.onRemove,
    required this.onShare,
  }) : super(key: key);

  @override
  State<SavedVehicleCardWidget> createState() => _SavedVehicleCardWidgetState();
}

class _SavedVehicleCardWidgetState extends State<SavedVehicleCardWidget>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 150),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 0.95,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _scaleAnimation,
      builder: (context, child) {
        return Transform.scale(
          scale: _scaleAnimation.value,
          child: Container(
            margin: EdgeInsets.only(bottom: 3.h),
            decoration: BoxDecoration(
              color: AppTheme.lightTheme.colorScheme.surface,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: AppTheme.shadowLight,
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: () {
                  HapticFeedback.lightImpact();
                  widget.onTap();
                },
                onTapDown: (_) => _animationController.forward(),
                onTapUp: (_) => _animationController.reverse(),
                onTapCancel: () => _animationController.reverse(),
                borderRadius: BorderRadius.circular(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildImageSection(),
                    _buildContentSection(),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildImageSection() {
    final images = widget.vehicle['images'] as List<String>? ?? [];
    final primaryImage = images.isNotEmpty
        ? images[0]
        : 'https://images.pexels.com/photos/116675/pexels-photo-116675.jpeg?auto=compress&cs=tinysrgb&w=800&h=600&fit=crop';

    return Stack(
      children: [
        ClipRRect(
          borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
          child: CustomImageWidget(
            imageUrl: primaryImage,
            width: double.infinity,
            height: 25.h,
            fit: BoxFit.cover,
          ),
        ),
        // Gradient overlay
        Positioned.fill(
          child: Container(
            decoration: BoxDecoration(
              borderRadius:
                  const BorderRadius.vertical(top: Radius.circular(16)),
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.transparent,
                  Colors.black.withValues(alpha: 0.1),
                ],
              ),
            ),
          ),
        ),
        // Top action buttons
        Positioned(
          top: 2.h,
          right: 3.w,
          child: Row(
            children: [
              _buildActionButton(
                icon: 'share',
                onPressed: widget.onShare,
              ),
              SizedBox(width: 2.w),
              _buildActionButton(
                icon: 'favorite',
                color: Colors.red,
                onPressed: widget.onRemove,
              ),
            ],
          ),
        ),
        // Price badge
        Positioned(
          bottom: 2.h,
          left: 3.w,
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
            decoration: BoxDecoration(
              color: AppTheme.lightTheme.colorScheme.primary,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              '\$${_formatPrice(widget.vehicle['price'])}',
              style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ),
        // Image indicator
        if (images.length > 1)
          Positioned(
            bottom: 2.h,
            right: 3.w,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 0.5.h),
              decoration: BoxDecoration(
                color: Colors.black54,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CustomIconWidget(
                    iconName: 'photo_library',
                    color: Colors.white,
                    size: 14,
                  ),
                  SizedBox(width: 1.w),
                  Text(
                    '${images.length}',
                    style: AppTheme.lightTheme.textTheme.labelSmall?.copyWith(
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildActionButton({
    required String icon,
    required VoidCallback onPressed,
    Color? color,
  }) {
    return GestureDetector(
      onTap: () {
        HapticFeedback.lightImpact();
        onPressed();
      },
      child: Container(
        padding: EdgeInsets.all(2.w),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.9),
          shape: BoxShape.circle,
        ),
        child: CustomIconWidget(
          iconName: icon,
          color: color ?? AppTheme.lightTheme.colorScheme.onSurface,
          size: 20,
        ),
      ),
    );
  }

  Widget _buildContentSection() {
    return Padding(
      padding: EdgeInsets.all(4.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Title and year
          Text(
            '${widget.vehicle['year']} ${widget.vehicle['make']} ${widget.vehicle['model']}',
            style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.w600,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          SizedBox(height: 1.h),

          // Details row
          Row(
            children: [
              _buildDetailChip(
                icon: 'speed',
                text: '${_formatMileage(widget.vehicle['mileage'])} mi',
              ),
              SizedBox(width: 2.w),
              _buildDetailChip(
                icon: 'local_gas_station',
                text: widget.vehicle['fuelType'] ?? 'Gas',
              ),
              SizedBox(width: 2.w),
              _buildDetailChip(
                icon: 'settings',
                text: widget.vehicle['transmission'] ?? 'Auto',
              ),
            ],
          ),
          SizedBox(height: 2.h),

          // Location and saved date
          Row(
            children: [
              CustomIconWidget(
                iconName: 'location_on',
                color: AppTheme.textSecondaryLight,
                size: 16,
              ),
              SizedBox(width: 1.w),
              Expanded(
                child: Text(
                  widget.vehicle['location'] ?? 'Unknown Location',
                  style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                    color: AppTheme.textSecondaryLight,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 0.5.h),
                decoration: BoxDecoration(
                  color: AppTheme.accentLight.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  'Saved ${_getTimeAgo(widget.vehicle['listedDate'])}',
                  style: AppTheme.lightTheme.textTheme.labelSmall?.copyWith(
                    color: AppTheme.accentLight,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 2.h),

          // Features preview
          if (widget.vehicle['features'] != null &&
              (widget.vehicle['features'] as List).isNotEmpty)
            _buildFeaturesPreview(),

          SizedBox(height: 2.h),

          // Action buttons
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () {
                    HapticFeedback.lightImpact();
                    // Contact seller
                  },
                  icon: CustomIconWidget(
                    iconName: 'phone',
                    color: AppTheme.lightTheme.colorScheme.primary,
                    size: 16,
                  ),
                  label: Text('Contact'),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppTheme.lightTheme.colorScheme.primary,
                    side: BorderSide(
                      color: AppTheme.lightTheme.colorScheme.primary,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ),
              SizedBox(width: 3.w),
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: widget.onTap,
                  icon: CustomIconWidget(
                    iconName: 'visibility',
                    color: Colors.white,
                    size: 16,
                  ),
                  label: Text('View Details'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.lightTheme.colorScheme.primary,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDetailChip({required String icon, required String text}) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 0.5.h),
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.surface,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: AppTheme.dividerLight,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          CustomIconWidget(
            iconName: icon,
            color: AppTheme.textSecondaryLight,
            size: 14,
          ),
          SizedBox(width: 1.w),
          Text(
            text,
            style: AppTheme.lightTheme.textTheme.labelSmall?.copyWith(
              color: AppTheme.textSecondaryLight,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFeaturesPreview() {
    final features = widget.vehicle['features'] as List<String>;
    final displayFeatures = features.take(3).toList();

    return Wrap(
      spacing: 2.w,
      runSpacing: 1.h,
      children: [
        ...displayFeatures.map((feature) => Container(
              padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 0.5.h),
              decoration: BoxDecoration(
                color: AppTheme.lightTheme.colorScheme.primary
                    .withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                feature,
                style: AppTheme.lightTheme.textTheme.labelSmall?.copyWith(
                  color: AppTheme.lightTheme.colorScheme.primary,
                ),
              ),
            )),
        if (features.length > 3)
          Container(
            padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 0.5.h),
            decoration: BoxDecoration(
              color: AppTheme.textSecondaryLight.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              '+${features.length - 3} more',
              style: AppTheme.lightTheme.textTheme.labelSmall?.copyWith(
                color: AppTheme.textSecondaryLight,
              ),
            ),
          ),
      ],
    );
  }

  String _formatPrice(int price) {
    if (price >= 1000000) {
      return '${(price / 1000000).toStringAsFixed(1)}M';
    } else if (price >= 1000) {
      return '${(price / 1000).toStringAsFixed(0)}K';
    }
    return price.toString();
  }

  String _formatMileage(int mileage) {
    if (mileage >= 1000) {
      return '${(mileage / 1000).toStringAsFixed(0)}K';
    }
    return mileage.toString();
  }

  String _getTimeAgo(DateTime date) {
    final difference = DateTime.now().difference(date);

    if (difference.inDays > 0) {
      return '${difference.inDays}d ago';
    } else if (difference.inHours > 0) {
      return '${difference.inHours}h ago';
    } else {
      return '${difference.inMinutes}m ago';
    }
  }
}
