import 'package:flutter/material.dart';

extension BuildContextExtension on BuildContext {
  ThemeData get theme => Theme.of(this);

  TextTheme get textTheme => theme.textTheme;

  ColorScheme get colorScheme => theme.colorScheme;

  ScaffoldMessengerState get messenger => ScaffoldMessenger.of(this);
  

  MediaQueryData get mediaQuery => MediaQuery.of(this);

  Size get screenSize => mediaQuery.size;


  double get screenWidth => screenSize.width;

  double get screenHeight => screenSize.height;

  bool get isDarkMode => theme.brightness == Brightness.dark;
  

}
