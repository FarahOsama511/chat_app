import 'package:chatapp/ui/features/auth/data/models/login_response_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../core/widgets/avatar_widget.dart';

class MemberChip extends StatelessWidget {
  final User contact;
  final VoidCallback onRemove;

  const MemberChip({super.key, required this.contact, required this.onRemove});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 6.h),
      decoration: BoxDecoration(
        color: colorScheme.primary.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          AvatarWidget(
            imageUrl: contact.image,
            name: contact.name,
            size: 20.w,
            borderRadius: 10.r,
          ),
          SizedBox(width: 6.w),
          Text(
            contact.name!.split(' ').first,
            style: textTheme.bodySmall?.copyWith(
              fontWeight: FontWeight.w600,
              color: colorScheme.primary,
            ),
          ),
          SizedBox(width: 4.w),
          GestureDetector(
            onTap: onRemove,
            child: Icon(
              Icons.close_rounded,
              size: 14.sp,
              color: colorScheme.primary,
            ),
          ),
        ],
      ),
    );
  }
}
