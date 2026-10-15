import 'package:chatapp/core/utils/cubit/theme/app_theme_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'app_text_field.dart';
import 'avatar_widget.dart';

class AppBarHeader extends StatelessWidget implements PreferredSizeWidget {
  final bool isSearchOpen;
  final ValueChanged<bool> onSearchToggle;
  final ValueChanged<String>? onSearchChanged;
  final VoidCallback onProfileTap;
  final VoidCallback? onThemeToggle;
  final String? profileAvatarUrl;

  const AppBarHeader({
    super.key,
    required this.isSearchOpen,
    required this.onSearchToggle,
    this.onSearchChanged,
    required this.onProfileTap,
    this.onThemeToggle,
    this.profileAvatarUrl,
  });

  @override
  Size get preferredSize => Size.fromHeight(isSearchOpen ? 116.h : 64.h);

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      color: colorScheme.surface,
      padding: EdgeInsets.only(
        top: MediaQuery.of(context).padding.top + 8.h,
        left: 20.w,
        right: 20.w,
        bottom: 8.h,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Logo & Title
              Row(
                children: [
               Image.asset("assets/images/icon_app.png",width: 32.w,height: 32.h,),
                  SizedBox(width: 10.w),
                  Text(
                    'Chat',
                    style: textTheme.headlineMedium?.copyWith(
                      color: colorScheme.onSurface,
                    ),
                  ),
                ],
              ),
              // Action Buttons
              Row(
                children: [
                  IconButton(
                    onPressed: () => onSearchToggle(!isSearchOpen),
                    icon: Icon(
                      isSearchOpen ? Icons.close_rounded : Icons.search_rounded,
                      color: isSearchOpen
                          ? colorScheme.primary
                          : colorScheme.onSurface,
                      size: 22.sp,
                    ),
                    style: IconButton.styleFrom(
                      backgroundColor: isSearchOpen
                          ? colorScheme.primary.withValues(alpha: 0.1)
                          : colorScheme.surfaceContainerHighest,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.r),
                      ),
                      padding: EdgeInsets.all(8.r),
                      minimumSize: Size(36.w, 36.h),
                    ),
                  ),
                  SizedBox(width: 8.w),
                  IconButton(
                    onPressed: () {
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
                    icon: Icon(
                      isDark
                          ? Icons.light_mode_rounded
                          : Icons.dark_mode_rounded,
                      color: colorScheme.onSurface,
                      size: 20.sp,
                    ),
                    style: IconButton.styleFrom(
                      backgroundColor: colorScheme.surfaceContainerHighest,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.r),
                      ),
                      padding: EdgeInsets.all(8.r),
                      minimumSize: Size(36.w, 36.h),
                    ),
                  ),
                  SizedBox(width: 8.w),
                  GestureDetector(
                    onTap: onProfileTap,
                    child: AvatarWidget(
                      imageUrl: profileAvatarUrl,
                      name: 'Alex Morgan',
                      size: 34.w,
                      borderRadius: 17.r,
                      borderColor: colorScheme.primary,
                      borderWidth: 2,
                    ),
                  ),
                ],
              ),
            ],
          ),
          if (isSearchOpen) ...[
            SizedBox(height: 10.h),
            AppTextField(
              autofocus: true,
              hintText: 'Search chats, groups, or messages...',
              borderRadius: 12.r,
              onChanged: onSearchChanged,
              prefixIcon: Icon(
                Icons.search,
                size: 18.sp,
                color: colorScheme.primary,
              ),
              contentPadding: EdgeInsets.symmetric(
                vertical: 10.h,
                horizontal: 12.w,
              ),
            ),
          ],
        ],
      ),
    );
  }
}
