import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomBottomNavBar extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;

  const CustomBottomNavBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Container(
      decoration: BoxDecoration(
        color: colorScheme.surface,
        border: Border(top: BorderSide(color: colorScheme.outline, width: 1.w)),
      ),
      child: BottomNavigationBar(
        currentIndex: currentIndex,
        onTap: onTap,
        backgroundColor: colorScheme.surface,
        elevation: 0,
        type: BottomNavigationBarType.fixed,
        selectedItemColor: colorScheme.primary,
        unselectedItemColor: colorScheme.onSurfaceVariant,
        selectedLabelStyle: textTheme.bodySmall?.copyWith(
          fontWeight: FontWeight.w600,
        ),
        unselectedLabelStyle: textTheme.bodySmall?.copyWith(
          fontWeight: FontWeight.w500,
        ),
        items: [
          BottomNavigationBarItem(
            icon: Padding(
              padding: EdgeInsets.only(bottom: 2.h),
              child: Icon(Icons.chat_bubble_outline_rounded, size: 22.sp),
            ),
            activeIcon: Padding(
              padding: EdgeInsets.only(bottom: 2.h),
              child: Icon(Icons.chat_bubble_rounded, size: 22.sp),
            ),
            label: 'Chats',
          ),
          BottomNavigationBarItem(
            icon: Padding(
              padding: EdgeInsets.only(bottom: 2.h),
              child: Icon(Icons.group_outlined, size: 22.sp),
            ),
            activeIcon: Padding(
              padding: EdgeInsets.only(bottom: 2.h),
              child: Icon(Icons.group_rounded, size: 22.sp),
            ),
            label: 'Groups',
          ),
          BottomNavigationBarItem(
            icon: Padding(
              padding: EdgeInsets.only(bottom: 2.h),
              child: Icon(Icons.person_outline_rounded, size: 22.sp),
            ),
            activeIcon: Padding(
              padding: EdgeInsets.only(bottom: 2.h),
              child: Icon(Icons.person_rounded, size: 22.sp),
            ),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}
