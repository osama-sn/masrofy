import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:masrofy/core/routes/routes.dart';
import 'package:masrofy/core/themes/app_theme.dart';
import 'package:masrofy/core/themes/theme_mode_provider.dart';

class MyApp extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeModeProvider);
    final appRouter = ref.watch(routerProvider);
    return EasyLocalization(
      supportedLocales: [Locale('en'), Locale('ar')],
      path: 'assets/translations',

      child: ScreenUtilInit(
        designSize: Size(360, 690),

        builder: (context, child) {
          return MaterialApp.router(
            title: 'مصروفي',
            debugShowCheckedModeBanner: false,
            locale: Locale('ar'),
            supportedLocales: context.supportedLocales,
            localizationsDelegates: context.localizationDelegates,
            theme: AppTheme.light,
            darkTheme: AppTheme.dark,
            themeMode: themeMode,
            routerConfig: appRouter,
          );
        },
      ),
    );
  }
}
