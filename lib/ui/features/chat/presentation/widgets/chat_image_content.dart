import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ChatImageContent extends StatelessWidget {
  final String message;
  final bool isOutgoing;

  const ChatImageContent({
    super.key,
    required this.message,
    required this.isOutgoing,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final url = message;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (url.startsWith('http'))
          Image.network(
            url,
            width: 260.w,
            height: 180.h,
            fit: BoxFit.cover,
            loadingBuilder: (context, child, loadingProgress) {
              if (loadingProgress == null) return child;
              return Container(
                width: 260.w,
                height: 180.h,
                color: isOutgoing
                    ? colorScheme.onPrimary.withValues(alpha: 0.15)
                    : colorScheme.surfaceContainerHighest,
                child: Center(
                  child: SizedBox(
                    width: 24.w,
                    height: 24.h,
                    child: const CircularProgressIndicator(strokeWidth: 2),
                  ),
                ),
              );
            },
            errorBuilder: (context, error, stackTrace) => Container(
              width: 260.w,
              height: 150.h,
              color: isOutgoing
                  ? colorScheme.onPrimary.withValues(alpha: 0.15)
                  : colorScheme.surfaceContainerHighest,
              child: Center(
                child: Icon(
                  Icons.broken_image_rounded,
                  size: 36.sp,
                  color: colorScheme.outlineVariant,
                ),
              ),
            ),
          )
        else
          Container(
            width: 260.w,
            height: 150.h,
            color: isOutgoing
                ? colorScheme.onPrimary.withValues(alpha: 0.15)
                : colorScheme.surfaceContainerHighest,
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.photo_rounded,
                    size: 40.sp,
                    color: isOutgoing
                        ? colorScheme.onPrimary.withValues(alpha: 0.7)
                        : colorScheme.outlineVariant,
                  ),
                  SizedBox(height: 6.h),
                  Text(
                    'Photo',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: isOutgoing
                          ? colorScheme.onPrimary.withValues(alpha: 0.7)
                          : colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
          ),
      ],
    );
  }
}
