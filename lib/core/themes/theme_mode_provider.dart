


import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';


final themeModeProvider = NotifierProvider<ThemeModeProvider, ThemeMode>(
  () => ThemeModeProvider(),
);
class ThemeModeProvider extends Notifier<ThemeMode> {

  @override
  ThemeMode build() {
    return ThemeMode.system;
  }
  void setThemeMode(ThemeMode mode) {
    state = mode;
  }

  void toggleThemeMode() {
    state = state == ThemeMode.light ? ThemeMode.dark : ThemeMode.light;
  }
}