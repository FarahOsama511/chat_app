import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'app_text_field.dart';
import 'avatar_widget.dart';

class MessageBottomSheet extends StatelessWidget {
  final String? avatarUrl;
  final String title;
  final String subtitle;
  final String lastMessage;
  final String time;
  final String? senderPrefix;
  final bool isOnline;
  final int? memberCount;

  const MessageBottomSheet({
    super.key,
    this.avatarUrl,
    required this.title,
    required this.subtitle,
    required this.lastMessage,
    required this.time,
    this.senderPrefix,
    this.isOnline = false,
    this.memberCount,
  });

  static void show(
    BuildContext context, {
    String? avatarUrl,
    required String title,
    required String subtitle,
    required String lastMessage,
    required String time,
    String? senderPrefix,
    bool isOnline = false,
    int? memberCount,
  }) {
    final colorScheme = Theme.of(context).colorScheme;
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: colorScheme.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24.r)),
      ),
      builder: (context) {
        return MessageBottomSheet(
          avatarUrl: avatarUrl,
          title: title,
          subtitle: subtitle,
          lastMessage: lastMessage,
          time: time,
          senderPrefix: senderPrefix,
          isOnline: isOnline,
          memberCount: memberCount,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom + 16.h,
        left: 20.w,
        right: 20.w,
        top: 20.h,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Drag handle
          Container(
            width: 40.w,
            height: 4.h,
            decoration: BoxDecoration(
              color: colorScheme.outline,
              borderRadius: BorderRadius.circular(2.r),
            ),
          ),
          SizedBox(height: 16.h),
          // User / Group Header Info
          Row(
            children: [
              AvatarWidget(imageUrl: avatarUrl, name: title, size: 44.w),
              SizedBox(width: 12.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: textTheme.titleMedium?.copyWith(
                        color: colorScheme.onSurface,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    Text(
                      subtitle,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: textTheme.bodySmall?.copyWith(
                        color: isOnline
                            ? colorScheme.tertiary
                            : colorScheme.outlineVariant,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 20.h),
          // Message preview card
          Container(
            padding: EdgeInsets.all(14.r),
            decoration: BoxDecoration(
              color: colorScheme.surfaceContainerHighest,
              borderRadius: BorderRadius.circular(16.r),
            ),
            child: Row(
              children: [
                Expanded(
                  child: RichText(
                    text: TextSpan(
                      children: [
                        if (senderPrefix != null && senderPrefix!.isNotEmpty)
                          TextSpan(
                            text: '$senderPrefix: ',
                            style: textTheme.bodyLarge?.copyWith(
                              fontWeight: FontWeight.w700,
                              color: colorScheme.primary,
                            ),
                          ),
                        TextSpan(
                          text: lastMessage,
                          style: textTheme.bodyLarge?.copyWith(
                            color: colorScheme.onSurface,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(width: 8.w),
                Text(
                  time,
                  style: textTheme.labelSmall?.copyWith(
                    color: colorScheme.outlineVariant,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 20.h),
          // Message input field and send button
          Row(
            children: [
              Expanded(
                child: AppTextField(
                  hintText: 'Type a message...',
                  borderRadius: 16.r,
                ),
              ),
              SizedBox(width: 10.w),
              IconButton.filled(
                onPressed: () => Navigator.pop(context),
                icon: Icon(Icons.send_rounded, size: 18.sp),
                style: IconButton.styleFrom(
                  backgroundColor: colorScheme.primary,
                  foregroundColor: colorScheme.onPrimary,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14.r),
                  ),
                  minimumSize: Size(46.w, 46.h),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
