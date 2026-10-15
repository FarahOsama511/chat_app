import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AvatarWidget extends StatelessWidget {
  final String? imageUrl;
  final String? name;
  final double size;
  final double borderRadius;
  final bool showBorder;
  final Color? borderColor;
  final double borderWidth;
  final IconData? fallbackIcon;

  const AvatarWidget({
    super.key,
    this.imageUrl,
    this.name,
    this.size = 48,
    this.borderRadius = 16,
    this.showBorder = false,
    this.borderColor,
    this.borderWidth = 2,
    this.fallbackIcon,
  });

  String _getInitials(String name) {
    final parts = name.trim().split(' ');
    if (parts.length >= 2) {
      return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
    } else if (parts.isNotEmpty && parts[0].isNotEmpty) {
      return parts[0][0].toUpperCase();
    }
    return '?';
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final effectiveSize = size.w;
    final effectiveRadius = borderRadius.r;

    Widget avatarContent;
    if (imageUrl != null && imageUrl!.isNotEmpty) {
      avatarContent = Image.network(
        imageUrl!,
        width: effectiveSize,
        height: effectiveSize,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) =>
            _buildFallback(colorScheme, textTheme, effectiveSize),
        loadingBuilder: (context, child, loadingProgress) {
          if (loadingProgress == null) return child;
          return Container(
            width: effectiveSize,
            height: effectiveSize,
            color: colorScheme.surfaceContainerHighest,
            child: Center(
              child: SizedBox(
                width: 14.w,
                height: 14.h,
                child: const CircularProgressIndicator(strokeWidth: 2),
              ),
            ),
          );
        },
      );
    } else {
      avatarContent = _buildFallback(colorScheme, textTheme, effectiveSize);
    }

    Widget avatar = ClipRRect(
      borderRadius: BorderRadius.circular(effectiveRadius),
      child: Container(
        width: effectiveSize,
        height: effectiveSize,
        decoration: BoxDecoration(
          color: colorScheme.surfaceContainerHighest,
          borderRadius: BorderRadius.circular(effectiveRadius),
          border: showBorder
              ? Border.all(
                  color: borderColor ?? colorScheme.primary,
                  width: borderWidth.w,
                )
              : null,
        ),
        child: avatarContent,
      ),
    );

    // if (isOnline) {
    //   avatar = Stack(
    //     clipBehavior: Clip.none,
    //     children: [
    //       avatar,
    //       Positioned(
    //         right: 0,
    //         bottom: 0,
    //         child: Container(
    //           width: 13.w,
    //           height: 13.h,
    //           decoration: BoxDecoration(
    //             color: colorScheme.tertiary,
    //             shape: BoxShape.circle,
    //             border: Border.all(color: colorScheme.surface, width: 2.w),
    //           ),
    //         ),
    //       ),
    //     ],
    //   );
    // }
    // if (memberCount != null) {
    //   avatar = Stack(
    //     clipBehavior: Clip.none,
    //     children: [
    //       avatar,
    //       Positioned(
    //         right: -2.w,
    //         bottom: -2.h,
    //         child: Container(
    //           padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.5.h),
    //           decoration: BoxDecoration(
    //             color: colorScheme.primary,
    //             borderRadius: BorderRadius.circular(8.r),
    //             border: Border.all(color: colorScheme.surface, width: 1.5.w),
    //           ),
    //           child: Row(
    //             mainAxisSize: MainAxisSize.min,
    //             children: [
    //               Icon(Icons.people, size: 9.sp, color: colorScheme.onPrimary),
    //               SizedBox(width: 2.w),
    //               Text(
    //                 '$memberCount',
    //                 style: textTheme.labelSmall?.copyWith(
    //                   fontSize: 10.sp,
    //                   fontWeight: FontWeight.w600,
    //                   color: colorScheme.onPrimary,
    //                 ),
    //               ),
    //             ],
    //           ),
    //         ),
    //       ),
    //     ],
    //   );
    // }

    return avatar;
  }

  Widget _buildFallback(
    ColorScheme colorScheme,
    TextTheme textTheme,
    double effectiveSize,
  ) {
    if (fallbackIcon != null) {
      return Center(
        child: Icon(
          fallbackIcon,
          size: effectiveSize * 0.45,
          color: colorScheme.primary,
        ),
      );
    }
    return Center(
      child: Text(
        name != null ? _getInitials(name!) : '?',
        style: textTheme.titleMedium?.copyWith(
          fontSize: effectiveSize * 0.38,
          fontWeight: FontWeight.w600,
          color: colorScheme.primary,
        ),
      ),
    );
  }
}
