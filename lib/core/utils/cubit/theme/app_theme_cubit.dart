import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../helpers/sharedpref_helper.dart';
import 'app_theme_state.dart';

enum AppTheme { light, dark }

class ThemeAppCubit extends Cubit<ThemeAppState> {
  ThemeAppCubit() : super(AppInitialState()) {
    _loadTheme();
  }
  AppTheme currentTheme = AppTheme.dark;
  Future<void> selectAppTheme(AppTheme theme) async {
    currentTheme = theme;
    await SharedprefHelper.setData("Theme", currentTheme.name);
    emit(AppChangedTheme());
  }

  ThemeMode get getCurrentTheme {
    switch (currentTheme) {
      case AppTheme.light:
        return ThemeMode.light;
      case AppTheme.dark:
        return ThemeMode.dark;
    }
  }

  Future<void> _loadTheme() async {
    final themeName = SharedprefHelper.getData("Theme");
    if (themeName == null || themeName.isEmpty) {
      currentTheme = AppTheme.light;
    } else {
      currentTheme = AppTheme.values.firstWhere(
        (e) => e.name == themeName,
        orElse: () => AppTheme.light,
      );
    }

    emit(AppChangedTheme());
  }
}
