import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AppDivider extends StatelessWidget {
  final double indent;
  final double endIndent;
  final double height;
  final double thickness;

  const AppDivider({
    super.key,
    this.indent = 76,
    this.endIndent = 20,
    this.height = 1,
    this.thickness = 0.8,
  });

  @override
  Widget build(BuildContext context) {
    return Divider(
      height: height.h,
      thickness: thickness.h,
      indent: indent.w,
      endIndent: endIndent.w,
      color: Theme.of(context).dividerColor,
    );
  }
}
