import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../../data/models/room_messages_response_model.dart';
import '../../../../core/widgets/avatar_widget.dart';
import 'chat_audio_content.dart';
import 'chat_file_content.dart';
import 'chat_image_content.dart';
import 'chat_text_content.dart';
import 'chat_video_content.dart';

class ChatBubble extends StatelessWidget {
  final MessageItemModel message;
  final bool isGroup;

  const ChatBubble({super.key, required this.message, this.isGroup = false});

  String _formatTime(String? dateStr) {
    if (dateStr == null || dateStr.isEmpty) return '';
    try {
      final dateTime = DateTime.parse(dateStr).toLocal();
      final hour = dateTime.hour % 12 == 0 ? 12 : dateTime.hour % 12;
      final minute = dateTime.minute.toString().padLeft(2, '0');
      final period = dateTime.hour >= 12 ? 'PM' : 'AM';
      return '$hour:$minute $period';
    } catch (_) {
      return dateStr;
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    if (message.isMe) {
      return _buildOutgoingMessage(context, colorScheme);
    } else {
      return _buildIncomingMessage(context, colorScheme);
    }
  }

  Widget _buildIncomingMessage(BuildContext context, ColorScheme colorScheme) {
    final senderName = message.sender?.name;
    final initials = (senderName != null && senderName.trim().isNotEmpty)
        ? senderName
              .trim()
              .split(' ')
              .map((e) => e.isNotEmpty ? e[0] : '')
              .take(2)
              .join()
              .toUpperCase()
        : 'U';

    final senderImage = message.sender?.image;

    return Padding(
      padding: EdgeInsets.only(bottom: 16.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          // Avatar
          if (senderImage != null && senderImage.isNotEmpty)
            AvatarWidget(
              imageUrl: senderImage,
              name: senderName ?? 'User',
              size: 36.w,
              borderRadius: 18.r,
            )
          else
            Container(
              width: 36.w,
              height: 36.h,
              decoration: BoxDecoration(
                color: colorScheme.primary.withValues(alpha: 0.15),
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Text(
                  initials,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: colorScheme.primary,
                  ),
                ),
              ),
            ),
          SizedBox(width: 8.w),

          // Message Content
          Flexible(
            child: ConstrainedBox(
              constraints: BoxConstraints(maxWidth: 272.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (isGroup &&
                      senderName != null &&
                      senderName.isNotEmpty) ...[
                    Padding(
                      padding: EdgeInsets.only(left: 4.w, bottom: 4.h),
                      child: Text(
                        senderName,
                        style: Theme.of(context).textTheme.labelSmall?.copyWith(
                          fontWeight: FontWeight.w600,
                          color: colorScheme.primary,
                        ),
                      ),
                    ),
                  ],

                  // Bubble
                  Container(
                    decoration: BoxDecoration(
                      color: colorScheme.surface,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(8.r),
                        topRight: Radius.circular(18.r),
                        bottomRight: Radius.circular(18.r),
                        bottomLeft: Radius.circular(18.r),
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: colorScheme.shadow.withValues(alpha: 0.05),
                          blurRadius: 10.r,
                          offset: Offset(0, 3.h),
                        ),
                      ],
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(8.r),
                        topRight: Radius.circular(18.r),
                        bottomRight: Radius.circular(18.r),
                        bottomLeft: Radius.circular(18.r),
                      ),
                      child: _buildContent(
                        context,
                        isOutgoing: false,
                      ),
                    ),
                  ),

                  SizedBox(height: 4.h),

                  // Metadata: Timestamp
                  Padding(
                    padding: EdgeInsets.only(left: 4.w),
                    child: Text(
                      _formatTime(message.createdAt),
                      style: Theme.of(context).textTheme.labelSmall?.copyWith(
                        color: colorScheme.outlineVariant,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOutgoingMessage(BuildContext context, ColorScheme colorScheme) {
    return Padding(
      padding: EdgeInsets.only(bottom: 16.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          // Bubble
          Container(
            decoration: BoxDecoration(
              color: colorScheme.primary,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(18.r),
                topRight: Radius.circular(8.r),
                bottomRight: Radius.circular(18.r),
                bottomLeft: Radius.circular(18.r),
              ),
            ),
            child: _buildContent(
              context,
              isOutgoing: true,
            ),
          ),

          SizedBox(height: 4.h),

          // Metadata: Time
          Padding(
            padding: EdgeInsets.only(right: 4.w),
            child: Text(
              _formatTime(message.createdAt),
              style: Theme.of(context).textTheme.labelSmall?.copyWith(
                color: colorScheme.outlineVariant,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContent(
    BuildContext context, {
    required bool isOutgoing,
  }) {
    final type = message.type?.toLowerCase() ?? 'text';
    final content = message.message ?? '';

    switch (type) {
      case 'image':
        return ChatImageContent(
          message: content,
          isOutgoing: isOutgoing,
        );
      case 'audio':
        return ChatAudioContent(
          message: content,
          isOutgoing: isOutgoing,
        );
      case 'video':
        return ChatVideoContent(
          message: content,
          isOutgoing: isOutgoing,
        );
      case 'file':
        return ChatFileContent(
          message: content,
          isOutgoing: isOutgoing,
        );
      case 'text':
      default:
        return ChatTextContent(
          message: content,
          isOutgoing: isOutgoing,
        );
    }
  }
}
