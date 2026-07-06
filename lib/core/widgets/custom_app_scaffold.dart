
import 'package:flutter/material.dart';
import 'package:masrofy/core/extensions/widget_extension.dart';
import 'package:masrofy/core/themes/app_colors.dart';

class AppScaffold extends StatelessWidget {
  const AppScaffold({
    super.key,
    required this.isDark,
    required this.child
  });

  final bool isDark;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
       colors: isDark
                ? [
                    AppColors.backgroundDark,
                    AppColors.surfaceDark,
                    AppColors.backgroundDark,
                  ]
                : [
                    const Color(0xFFE8F5E9),
                    AppColors.backgroundLight,
                    AppColors.backgroundLight,
                  ],
          )
        ),
        child: child.safeArea(),
      ),
    );
  }
}
