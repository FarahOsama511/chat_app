import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ChatFileContent extends StatelessWidget {
  final String message;
  final bool isOutgoing;

  const ChatFileContent({
    super.key,
    required this.message,
    required this.isOutgoing,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final fileName = message.isNotEmpty
        ? message.split(RegExp(r'[/\\]')).last
        : 'Attachment file';

    final textColor = isOutgoing
        ? colorScheme.onPrimary
        : colorScheme.onSurface;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 12.h),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 40.w,
            height: 40.h,
            decoration: BoxDecoration(
              color: isOutgoing
                  ? colorScheme.onPrimary.withValues(alpha: 0.2)
                  : colorScheme.primary.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(10.r),
            ),
            child: Icon(
              Icons.insert_drive_file_rounded,
              size: 22.sp,
              color: isOutgoing ? colorScheme.onPrimary : colorScheme.primary,
            ),
          ),
          SizedBox(width: 12.w),
          ConstrainedBox(
            constraints: BoxConstraints(maxWidth: 150.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  fileName,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: textColor,
                  ),
                ),
                SizedBox(height: 2.h),
                Text(
                  'Document',
                  style: Theme.of(context).textTheme.labelSmall?.copyWith(
                    color: textColor.withValues(alpha: 0.7),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(width: 8.w),
          Icon(
            Icons.arrow_circle_down_rounded,
            size: 22.sp,
            color: isOutgoing
                ? colorScheme.onPrimary.withValues(alpha: 0.7)
                : colorScheme.primary,
          ),
        ],
      ),
    );
  }
}
