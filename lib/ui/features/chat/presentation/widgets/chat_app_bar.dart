import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import '../../../../../data/models/group_model.dart';
import '../../../../core/widgets/avatar_widget.dart';

class ChatAppBar extends StatelessWidget implements PreferredSizeWidget {
  final GroupModel group;
  final VoidCallback? onVideoCallTap;
  final VoidCallback? onMoreTap;

  const ChatAppBar({
    super.key,
    required this.group,
    this.onVideoCallTap,
    this.onMoreTap,
  });

  @override
  Size get preferredSize => Size.fromHeight(76.h);

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final isGroup = group.type == 'group';

    return Container(
      decoration: BoxDecoration(
        color: colorScheme.surface,
        border: Border(
          bottom: BorderSide(
            color: colorScheme.outline.withValues(alpha: 0.5),
            width: 1.w,
          ),
        ),
      ),
      child: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          child: SizedBox(
            child: Row(
              children: [
                // Back button
                InkWell(
                  onTap: () => context.pop(),
                  child: Padding(
                    padding: EdgeInsets.all(8.r),
                    child: Icon(
                      Icons.arrow_back_ios_new_rounded,
                      size: 20.sp,
                      color: colorScheme.onSurface,
                    ),
                  ),
                ),
                SizedBox(width: 4.w),

                // Avatar
                if (isGroup && (group.image == null || group.image!.isEmpty))
                  _buildGroupOverlappingAvatar(context)
                else
                  AvatarWidget(
                    imageUrl: group.image,
                    name: group.name ?? 'Chat',
                    size: 44.w,
                    borderRadius: 16.r,
                  ),

                SizedBox(width: 12.w),

                // Name and Presence / Subtitle
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        group.name ?? (isGroup ? 'Group' : 'Chat'),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.w600,
                          color: colorScheme.onSurface,
                        ),
                      ),
                      SizedBox(height: 2.h),
                      if (isGroup)
                        Text(
                          (group.description != null &&
                                  group.description!.isNotEmpty)
                              ? group.description!
                              : '5 members · 3 online',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: textTheme.labelSmall?.copyWith(
                            color: colorScheme.onSurfaceVariant,
                          ),
                        )
                      else
                        Row(
                          children: [
                            Container(
                              width: 7.w,
                              height: 7.h,
                              decoration: BoxDecoration(
                                color: colorScheme.tertiary,
                                shape: BoxShape.circle,
                              ),
                            ),
                            SizedBox(width: 6.w),
                            Text(
                              'Online',
                              style: textTheme.labelSmall?.copyWith(
                                fontWeight: FontWeight.w500,
                                color: colorScheme.tertiary,
                              ),
                            ),
                          ],
                        ),
                    ],
                  ),
                ),

                // Action: Video/Camera
                IconButton(
                  onPressed: onVideoCallTap,
                  icon: Icon(Icons.videocam_outlined, size: 22.sp),
                  color: colorScheme.onSurface,
                  tooltip: 'Video call',
                ),

                // Action: More
                IconButton(
                  onPressed: onMoreTap,
                  icon: Icon(Icons.more_vert_rounded, size: 22.sp),
                  color: colorScheme.onSurface,
                  tooltip: 'More options',
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildGroupOverlappingAvatar(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return SizedBox(
      width: 54.w,
      height: 44.h,
      child: Stack(
        children: [
          Positioned(
            left: 0,
            top: 0,
            child: Container(
              width: 36.w,
              height: 36.h,
              decoration: BoxDecoration(
                color: colorScheme.primary.withValues(alpha: 0.2),
                shape: BoxShape.circle,
                border: Border.all(color: colorScheme.surface, width: 2.w),
              ),
              child: Center(
                child: Text(
                  'G',
                  style: textTheme.bodySmall?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: colorScheme.primary,
                  ),
                ),
              ),
            ),
          ),
          Positioned(
            left: 18.w,
            top: 10.h,
            child: Container(
              width: 32.w,
              height: 32.h,
              decoration: BoxDecoration(
                color: colorScheme.secondary.withValues(alpha: 0.2),
                shape: BoxShape.circle,
                border: Border.all(color: colorScheme.surface, width: 2.w),
              ),
              child: Center(
                child: Text(
                  'C',
                  style: textTheme.bodySmall?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: colorScheme.secondary,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
