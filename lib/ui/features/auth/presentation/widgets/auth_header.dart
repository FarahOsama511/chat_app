import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AuthHeader extends StatelessWidget {
  const AuthHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Image.asset("assets/images/icon_app.png",width: 100.w,height: 100.h,),
        SizedBox(height: 10.h),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Chat',
              style: textTheme.headlineMedium?.copyWith(fontSize: 25.sp)
            ),
            SizedBox(width: 4.w),
            Container(
              width: 8.w,
              height: 8.h,
              margin: EdgeInsets.only(top: 14.h),
              decoration: BoxDecoration(
                color: colorScheme.primary,
                shape: BoxShape.circle,
              ),
            ),
          ],
        ),
        SizedBox(height: 8.h),
        // Subtitle
        Text(
          'Welcome back! Sign in to continue chatting',
          textAlign: TextAlign.center,
          style: textTheme.bodySmall?.copyWith(
            color: colorScheme.onSurfaceVariant,
          ),
        ),
      ],
    );
  }
}
