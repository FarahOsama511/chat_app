import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ChatVideoContent extends StatelessWidget {
  final String message;
  final bool isOutgoing;

  const ChatVideoContent({
    super.key,
    required this.message,
    required this.isOutgoing,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      width: 240.w,
      height: 140.h,
      decoration: BoxDecoration(
        color: isOutgoing
            ? colorScheme.shadow.withValues(alpha: 0.3)
            : colorScheme.shadow.withValues(alpha: 0.08),
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          Container(
            width: 48.w,
            height: 48.h,
            decoration: BoxDecoration(
              color: colorScheme.shadow.withValues(alpha: 0.5),
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Icon(
                Icons.play_arrow_rounded,
                size: 30.sp,
                color: colorScheme.onPrimary,
              ),
            ),
          ),
          Positioned(
            left: 10.w,
            bottom: 8.h,
            child: Row(
              children: [
                Icon(
                  Icons.videocam_rounded,
                  size: 14.sp,
                  color: colorScheme.onPrimary.withValues(alpha: 0.7),
                ),
                SizedBox(width: 4.w),
                Text(
                  'Video',
                  style: Theme.of(context).textTheme.labelSmall?.copyWith(
                    color: colorScheme.onPrimary.withValues(alpha: 0.7),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
