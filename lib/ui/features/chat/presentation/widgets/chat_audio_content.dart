import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ChatAudioContent extends StatelessWidget {
  final String message;
  final bool isOutgoing;

  const ChatAudioContent({
    super.key,
    required this.message,
    required this.isOutgoing,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textColor = isOutgoing
        ? colorScheme.onPrimary
        : colorScheme.onSurface;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 40.w,
            height: 40.h,
            decoration: BoxDecoration(
              color: isOutgoing ? colorScheme.onPrimary : colorScheme.primary,
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Icon(
                Icons.play_arrow_rounded,
                size: 24.sp,
                color: isOutgoing ? colorScheme.primary : colorScheme.onPrimary,
              ),
            ),
          ),
          SizedBox(width: 12.w),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Visual simulated waveform bars
              Row(
                children: List.generate(
                  16,
                  (index) => Container(
                    margin: EdgeInsets.symmetric(horizontal: 1.5.w),
                    width: 3.w,
                    height: (index % 3 == 0)
                        ? 22.0.h
                        : (index % 2 == 0)
                        ? 14.0.h
                        : 8.0.h,
                    decoration: BoxDecoration(
                      color: isOutgoing
                          ? colorScheme.onPrimary.withValues(alpha: 0.8)
                          : colorScheme.primary.withValues(alpha: 0.7),
                      borderRadius: BorderRadius.circular(2.r),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 4.h),
              Text(
                'Audio message',
                style: Theme.of(context).textTheme.labelSmall?.copyWith(
                  fontWeight: FontWeight.w500,
                  color: textColor.withValues(alpha: 0.8),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
