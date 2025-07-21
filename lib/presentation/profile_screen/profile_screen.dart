import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final ScrollController _scrollController = ScrollController();

  final Map<String, dynamic> _userProfile = {
    'name': 'John Smith',
    'email': 'john.smith@email.com',
    'phone': '+1 (555) 123-4567',
    'location': 'San Francisco, CA',
    'memberSince': '2023',
    'verified': true,
    'rating': 4.8,
    'reviewCount': 24,
    'avatar':
        'https://images.pexels.com/photos/1239291/pexels-photo-1239291.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1',
  };

  final List<Map<String, dynamic>> _menuItems = [
    {
      'icon': 'person',
      'title': 'Edit Profile',
      'subtitle': 'Update your personal information',
      'route': '/edit-profile',
    },
    {
      'icon': 'directions_car',
      'title': 'My Listings',
      'subtitle': '3 active listings',
      'route': '/my-listings',
    },
    {
      'icon': 'favorite',
      'title': 'Saved Vehicles',
      'subtitle': '12 saved vehicles',
      'route': '/saved-screen',
    },
    {
      'icon': 'history',
      'title': 'Purchase History',
      'subtitle': '2 previous purchases',
      'route': '/purchase-history',
    },
    {
      'icon': 'payment',
      'title': 'Payment Methods',
      'subtitle': 'Manage your payment options',
      'route': '/payment-methods',
    },
    {
      'icon': 'notifications',
      'title': 'Notifications',
      'subtitle': 'Customize your alerts',
      'route': '/notification-settings',
    },
    {
      'icon': 'security',
      'title': 'Privacy & Security',
      'subtitle': 'Manage your account security',
      'route': '/privacy-settings',
    },
    {
      'icon': 'help',
      'title': 'Help & Support',
      'subtitle': 'Get help or contact us',
      'route': '/help-support',
    },
    {
      'icon': 'info',
      'title': 'About',
      'subtitle': 'App version and information',
      'route': '/about',
    },
    {
      'icon': 'logout',
      'title': 'Sign Out',
      'subtitle': 'Sign out from your account',
      'route': null,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.lightTheme.scaffoldBackgroundColor,
      body: CustomScrollView(
        controller: _scrollController,
        slivers: [
          _buildSliverAppBar(),
          SliverToBoxAdapter(
            child: Column(
              children: [
                _buildProfileHeader(),
                SizedBox(height: 3.h),
                _buildStatsSection(),
                SizedBox(height: 4.h),
                _buildMenuSection(),
                SizedBox(height: 3.h),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSliverAppBar() {
    return SliverAppBar(
      expandedHeight: 20.h,
      floating: false,
      pinned: true,
      backgroundColor: AppTheme.lightTheme.colorScheme.primary,
      leading: IconButton(
        icon: CustomIconWidget(
          iconName: 'arrow_back',
          color: Colors.white,
          size: 24,
        ),
        onPressed: () => Navigator.pop(context),
      ),
      actions: [
        IconButton(
          icon: CustomIconWidget(
            iconName: 'more_vert',
            color: Colors.white,
            size: 24,
          ),
          onPressed: _showProfileOptions,
        ),
      ],
      flexibleSpace: FlexibleSpaceBar(
        title: Text(
          'Profile',
          style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
            color: Colors.white,
            fontWeight: FontWeight.w600,
          ),
        ),
        background: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                AppTheme.lightTheme.colorScheme.primary,
                AppTheme.lightTheme.colorScheme.primary.withValues(alpha: 0.8),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildProfileHeader() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
      padding: EdgeInsets.all(4.w),
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
      child: Column(
        children: [
          Row(
            children: [
              Stack(
                children: [
                  Container(
                    width: 20.w,
                    height: 20.w,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: AppTheme.lightTheme.colorScheme.primary,
                        width: 3,
                      ),
                    ),
                    child: ClipOval(
                      child: CustomImageWidget(
                        imageUrl: _userProfile['avatar'],
                        width: 20.w,
                        height: 20.w,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  if (_userProfile['verified'])
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: Container(
                        padding: EdgeInsets.all(1.w),
                        decoration: BoxDecoration(
                          color: AppTheme.accentLight,
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: Colors.white,
                            width: 2,
                          ),
                        ),
                        child: CustomIconWidget(
                          iconName: 'verified',
                          color: Colors.white,
                          size: 16,
                        ),
                      ),
                    ),
                ],
              ),
              SizedBox(width: 4.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            _userProfile['name'],
                            style: AppTheme.lightTheme.textTheme.titleLarge
                                ?.copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        if (_userProfile['verified'])
                          Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: 2.w, vertical: 0.5.h),
                            decoration: BoxDecoration(
                              color:
                                  AppTheme.accentLight.withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              'Verified',
                              style: AppTheme.lightTheme.textTheme.labelSmall
                                  ?.copyWith(
                                color: AppTheme.accentLight,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                      ],
                    ),
                    SizedBox(height: 0.5.h),
                    Row(
                      children: [
                        CustomIconWidget(
                          iconName: 'star',
                          color: Colors.amber,
                          size: 16,
                        ),
                        SizedBox(width: 1.w),
                        Text(
                          '${_userProfile['rating']} (${_userProfile['reviewCount']} reviews)',
                          style:
                              AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                            color: AppTheme.textSecondaryLight,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 0.5.h),
                    Row(
                      children: [
                        CustomIconWidget(
                          iconName: 'location_on',
                          color: AppTheme.textSecondaryLight,
                          size: 14,
                        ),
                        SizedBox(width: 1.w),
                        Text(
                          _userProfile['location'],
                          style:
                              AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                            color: AppTheme.textSecondaryLight,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 0.5.h),
                    Text(
                      'Member since ${_userProfile['memberSince']}',
                      style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                        color: AppTheme.textSecondaryLight,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 3.h),
          Row(
            children: [
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () {
                    Navigator.pushNamed(context, '/edit-profile');
                  },
                  icon: CustomIconWidget(
                    iconName: 'edit',
                    color: Colors.white,
                    size: 16,
                  ),
                  label: Text('Edit Profile'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.lightTheme.colorScheme.primary,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ),
              SizedBox(width: 3.w),
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () {
                    _shareProfile();
                  },
                  icon: CustomIconWidget(
                    iconName: 'share',
                    color: AppTheme.lightTheme.colorScheme.primary,
                    size: 16,
                  ),
                  label: Text('Share'),
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
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatsSection() {
    final stats = [
      {'title': 'Listings', 'value': '3', 'icon': 'directions_car'},
      {'title': 'Saved', 'value': '12', 'icon': 'favorite'},
      {'title': 'Reviews', 'value': '24', 'icon': 'star'},
      {'title': 'Years', 'value': '2', 'icon': 'calendar_today'},
    ];

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 4.w),
      padding: EdgeInsets.all(4.w),
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
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: stats.map((stat) => _buildStatItem(stat)).toList(),
      ),
    );
  }

  Widget _buildStatItem(Map<String, dynamic> stat) {
    return Column(
      children: [
        Container(
          padding: EdgeInsets.all(3.w),
          decoration: BoxDecoration(
            color:
                AppTheme.lightTheme.colorScheme.primary.withValues(alpha: 0.1),
            shape: BoxShape.circle,
          ),
          child: CustomIconWidget(
            iconName: stat['icon'],
            color: AppTheme.lightTheme.colorScheme.primary,
            size: 20,
          ),
        ),
        SizedBox(height: 1.h),
        Text(
          stat['value'],
          style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        Text(
          stat['title'],
          style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
            color: AppTheme.textSecondaryLight,
          ),
        ),
      ],
    );
  }

  Widget _buildMenuSection() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 4.w),
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
      child: ListView.separated(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: _menuItems.length,
        separatorBuilder: (context, index) => Divider(
          height: 1,
          color: AppTheme.dividerLight,
          indent: 16.w,
        ),
        itemBuilder: (context, index) {
          final item = _menuItems[index];
          return _buildMenuItem(item);
        },
      ),
    );
  }

  Widget _buildMenuItem(Map<String, dynamic> item) {
    final isSignOut = item['title'] == 'Sign Out';

    return ListTile(
      leading: Container(
        padding: EdgeInsets.all(2.w),
        decoration: BoxDecoration(
          color: isSignOut
              ? Colors.red.withValues(alpha: 0.1)
              : AppTheme.lightTheme.colorScheme.primary.withValues(alpha: 0.1),
          shape: BoxShape.circle,
        ),
        child: CustomIconWidget(
          iconName: item['icon'],
          color:
              isSignOut ? Colors.red : AppTheme.lightTheme.colorScheme.primary,
          size: 20,
        ),
      ),
      title: Text(
        item['title'],
        style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
          color: isSignOut ? Colors.red : null,
        ),
      ),
      subtitle: Text(
        item['subtitle'],
        style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
          color: AppTheme.textSecondaryLight,
        ),
      ),
      trailing: CustomIconWidget(
        iconName: 'chevron_right',
        color: AppTheme.textSecondaryLight,
        size: 20,
      ),
      onTap: () => _handleMenuTap(item),
    );
  }

  void _handleMenuTap(Map<String, dynamic> item) {
    HapticFeedback.lightImpact();

    if (item['title'] == 'Sign Out') {
      _showSignOutDialog();
    } else if (item['route'] != null) {
      Navigator.pushNamed(context, item['route']);
    }
  }

  void _showProfileOptions() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        decoration: BoxDecoration(
          color: AppTheme.lightTheme.colorScheme.surface,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 12.w,
              height: 0.5.h,
              margin: EdgeInsets.only(top: 2.h),
              decoration: BoxDecoration(
                color: AppTheme.dividerLight,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            SizedBox(height: 3.h),
            ListTile(
              leading: CustomIconWidget(
                iconName: 'share',
                color: AppTheme.lightTheme.colorScheme.primary,
                size: 24,
              ),
              title: Text('Share Profile'),
              onTap: () {
                Navigator.pop(context);
                _shareProfile();
              },
            ),
            ListTile(
              leading: CustomIconWidget(
                iconName: 'qr_code',
                color: AppTheme.lightTheme.colorScheme.primary,
                size: 24,
              ),
              title: Text('QR Code'),
              onTap: () {
                Navigator.pop(context);
                _showQRCode();
              },
            ),
            ListTile(
              leading: CustomIconWidget(
                iconName: 'report',
                color: Colors.red,
                size: 24,
              ),
              title: Text('Report Issue'),
              onTap: () {
                Navigator.pop(context);
                _reportIssue();
              },
            ),
            SizedBox(height: 2.h),
          ],
        ),
      ),
    );
  }

  void _showSignOutDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Sign Out'),
        content: Text('Are you sure you want to sign out?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pushReplacementNamed(context, '/authentication-screen');
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            child: Text('Sign Out'),
          ),
        ],
      ),
    );
  }

  void _shareProfile() {
    HapticFeedback.lightImpact();
    // Implement share functionality
  }

  void _showQRCode() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Profile QR Code'),
        content: Container(
          width: 50.w,
          height: 50.w,
          decoration: BoxDecoration(
            color: Colors.grey[200],
            borderRadius: BorderRadius.circular(12),
          ),
          child: Center(
            child: CustomIconWidget(
              iconName: 'qr_code',
              color: AppTheme.textSecondaryLight,
              size: 100,
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Close'),
          ),
        ],
      ),
    );
  }

  void _reportIssue() {
    // Implement report functionality
  }
}
