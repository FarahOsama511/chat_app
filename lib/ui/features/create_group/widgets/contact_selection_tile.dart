import 'package:chatapp/ui/features/auth/data/models/login_response_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../core/widgets/avatar_widget.dart';

class ContactSelectionTile extends StatelessWidget {
  final User member;
  final bool isSelected;
  final VoidCallback onTap;

  const ContactSelectionTile({
    super.key,
    required this.member,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Container(
      margin: EdgeInsets.only(bottom: 6.h),
      decoration: BoxDecoration(
        color: isSelected
            ? colorScheme.primary.withValues(alpha: 0.1)
            : colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(14.r),
      ),
      child: ListTile(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14.r)),
        contentPadding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 2.h),
        onTap: onTap,
        leading: AvatarWidget(
          imageUrl: member.image,
          name: member.name,
          size: 40.w,
          borderRadius: 12.r,
        ),
        title: Text(
          member.name ?? "",
          style: textTheme.bodyLarge?.copyWith(color: colorScheme.onSurface),
        ),
        trailing: Container(
          width: 22.w,
          height: 22.h,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: isSelected ? colorScheme.primary : Colors.transparent,
            border: Border.all(
              color: isSelected
                  ? colorScheme.primary
                  : colorScheme.outlineVariant,
              width: 1.5.w,
            ),
          ),
          child: isSelected
              ? Icon(Icons.check_rounded, size: 14.sp, color: colorScheme.onPrimary)
              : null,
        ),
      ),
    );
  }
}
