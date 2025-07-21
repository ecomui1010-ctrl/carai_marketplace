import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class ActionButtonsWidget extends StatelessWidget {
  final VoidCallback? onCallSeller;
  final VoidCallback? onChat;
  final VoidCallback? onScheduleVisit;
  final VoidCallback? onVirtualTestDrive;

  const ActionButtonsWidget({
    Key? key,
    this.onCallSeller,
    this.onChat,
    this.onScheduleVisit,
    this.onVirtualTestDrive,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.surface,
        boxShadow: [
          BoxShadow(
            color: AppTheme.lightTheme.colorScheme.shadow,
            blurRadius: 12,
            offset: Offset(0, -4),
          ),
        ],
      ),
      child: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Virtual Test Drive Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: onVirtualTestDrive,
                icon: CustomIconWidget(
                  iconName: 'drive_eta',
                  color: AppTheme.lightTheme.colorScheme.onPrimary,
                  size: 20,
                ),
                label: Text('Virtual Test Drive'),
                style: AppTheme.lightTheme.elevatedButtonTheme.style?.copyWith(
                  backgroundColor: WidgetStateProperty.all(
                    AppTheme.lightTheme.colorScheme.tertiary,
                  ),
                  padding: WidgetStateProperty.all(
                    EdgeInsets.symmetric(vertical: 2.h),
                  ),
                ),
              ),
            ),
            SizedBox(height: 2.h),

            // Primary Action Buttons Row
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: onCallSeller,
                    icon: CustomIconWidget(
                      iconName: 'phone',
                      color: AppTheme.lightTheme.colorScheme.primary,
                      size: 20,
                    ),
                    label: Text('Call'),
                    style:
                        AppTheme.lightTheme.outlinedButtonTheme.style?.copyWith(
                      padding: WidgetStateProperty.all(
                        EdgeInsets.symmetric(vertical: 2.h),
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 3.w),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: onChat,
                    icon: CustomIconWidget(
                      iconName: 'chat',
                      color: AppTheme.lightTheme.colorScheme.onPrimary,
                      size: 20,
                    ),
                    label: Text('Chat'),
                    style:
                        AppTheme.lightTheme.elevatedButtonTheme.style?.copyWith(
                      padding: WidgetStateProperty.all(
                        EdgeInsets.symmetric(vertical: 2.h),
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 3.w),
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: onScheduleVisit,
                    icon: CustomIconWidget(
                      iconName: 'schedule',
                      color: AppTheme.lightTheme.colorScheme.primary,
                      size: 20,
                    ),
                    label: Text('Visit'),
                    style:
                        AppTheme.lightTheme.outlinedButtonTheme.style?.copyWith(
                      padding: WidgetStateProperty.all(
                        EdgeInsets.symmetric(vertical: 2.h),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
