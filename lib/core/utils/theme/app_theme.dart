import 'package:chatapp/core/utils/theme/dark_theme.dart';
import 'package:chatapp/core/utils/theme/light_theme.dart';
import 'package:flutter/material.dart';

abstract class AppTheme {
  static ThemeData getLightTheme() => lightTheme;
  static ThemeData getDarkTheme() => darkTheme;
}
