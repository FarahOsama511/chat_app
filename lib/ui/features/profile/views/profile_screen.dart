import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/utils/cubit/theme/app_theme_cubit.dart';
import '../../../../data/models/user_profile.dart';
import '../../../core/widgets/app_divider.dart';
import '../widgets/profile_header_card.dart';
import '../widgets/settings_tile.dart';

class ProfileScreen extends StatefulWidget {
  final UserProfile profile;
  final VoidCallback? onLogout;

  const ProfileScreen({
    super.key,
    this.onLogout,
    this.profile = const UserProfile(
      id: 'u_me',
      name: 'Alex Morgan',
      avatarUrl:
          'https://images.unsplash.com/photo-1535713875002-d1d0cf377fde?w=150',
      statusQuote:
          '"Design is not just what it looks like — it\'s how it works."',
      email: 'alex.morgan@example.com',
      phone: '+1 (555) 234-5678',
    ),
  });

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  void _confirmLogout() {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: colorScheme.surface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.r),
        ),
        title: Text('Log Out', style: textTheme.titleLarge),
        content: Text(
          'Are you sure you want to log out of Chat?',
          style: textTheme.bodyMedium,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text(
              'Cancel',
              style: textTheme.bodyLarge?.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(ctx);
              widget.onLogout?.call();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: colorScheme.error,
              foregroundColor: colorScheme.onError,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.r),
              ),
            ),
            child: const Text('Log Out'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
      child: Column(
        children: [
          ProfileHeaderCard(profile: widget.profile),
          SizedBox(height: 20.h),
          // Settings Card Container
          Material(
            color: colorScheme.surface,
            borderRadius: BorderRadius.circular(20.r),
            clipBehavior: Clip.antiAlias,
            elevation: 1,
            shadowColor: colorScheme.shadow.withValues(alpha: 0.08),
            child: Column(
              children: [
                SettingsTile(
                  icon: Icons.edit_outlined,
                  title: 'Edit Profile',
                  subtitle: 'Update your name and photo',
                  onTap: () {},
                ),
                AppDivider(indent: 64.w, endIndent: 16.w),
                SettingsTile(
                  icon: Icons.notifications_none_rounded,
                  title: 'Notifications',
                  subtitle: 'Manage alerts and sounds',
                  onTap: () {},
                ),
                AppDivider(indent: 64.w, endIndent: 16.w),
                SettingsTile(
                  icon: Icons.shield_outlined,
                  title: 'Privacy & Security',
                  subtitle: 'Control who can see you',
                  onTap: () {},
                ),
                AppDivider(indent: 64.w, endIndent: 16.w),
                SettingsTile(
                  icon: isDark
                      ? Icons.dark_mode_rounded
                      : Icons.light_mode_rounded,
                  title: 'Appearance',
                  subtitle: isDark ? 'Dark theme active' : 'Light theme active',
                  trailing: Switch.adaptive(
                    value: isDark,
                    activeTrackColor: colorScheme.primary,
                    onChanged: (val) {
                      if (context.read<ThemeAppCubit>().currentTheme ==
                          AppTheme.light) {
                        context.read<ThemeAppCubit>().selectAppTheme(
                          AppTheme.dark,
                        );
                      } else {
                        context.read<ThemeAppCubit>().selectAppTheme(
                          AppTheme.light,
                        );
                      }
                    },
                  ),
                ),
                if (widget.onLogout != null) ...[
                  AppDivider(indent: 64.w, endIndent: 16.w),
                  SettingsTile(
                    icon: Icons.logout_rounded,
                    iconColor: colorScheme.error,
                    title: 'Log Out',
                    titleColor: colorScheme.error,
                    subtitle: 'Sign out of your account',
                    onTap: _confirmLogout,
                  ),
                ],
              ],
            ),
          ),
          SizedBox(height: 28.h),
        ],
      ),
    );
  }
}
