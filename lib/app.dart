import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:masrofy/core/constants/app_assets.dart';
import 'package:masrofy/core/routes/app_routes.dart';
import 'package:masrofy/core/routes/routes.dart';
import 'package:masrofy/core/themes/app_sizes.dart';
import 'package:masrofy/core/themes/app_theme.dart';
import 'package:masrofy/core/themes/theme_mode_provider.dart';
import 'package:masrofy/core/widgets/custom_buttons.dart';

class MyApp extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeModeProvider);
    return EasyLocalization(
      supportedLocales: [Locale('en'), Locale('ar')],
      path: 'assets/translations',

      child: ScreenUtilInit(
        designSize: Size(360, 690),

        builder: (context, child) {
          return MaterialApp.router(
            title: 'My App',
            debugShowCheckedModeBanner: false,
            locale: context.locale,
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

class HomePage extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: Text('appTitle').tr(),
        actions: [
          IconButton(
            icon: Icon(isDark ? Icons.light_mode : Icons.dark_mode),

            onPressed: () {
              ref.read(themeModeProvider.notifier).toggleThemeMode();
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Center(
            child: Text(
              'description',
              style: Theme.of(context).textTheme.bodyMedium,
            ).tr(),
          ),
          SizedBox(height: AppSizes.m),
          Padding(
            padding: EdgeInsets.all(AppSizes.screenPadding),
            child: CustomButton(
              text: "changeLanguage".tr(),
              onPressed: () {
                context.setLocale(
                  context.locale.languageCode == 'en'
                      ? Locale('ar')
                      : Locale('en'),
                );
              },
              variant: ButtonVariant.outlined,
            ),
          ),
          SizedBox(height: AppSizes.m),
          Image.asset(AppAssets.goals, width: 200.w, height: 200.h),
          SizedBox(height: AppSizes.m),
          CustomButton(
            text: "Go to Settings",
            onPressed: () {
              context.go(AppRoutes.settings);
            },
            variant: ButtonVariant.primary,
          ),
        ],
      ),
    );
  }
}

class SettingsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Settings')),
      body: Center(child: Text('Settings Page')),
    );
  }
}
