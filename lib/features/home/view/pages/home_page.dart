import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:masrofy/core/constants/app_assets.dart';
import 'package:masrofy/core/extensions/build_context.dart';
import 'package:masrofy/core/extensions/num_extension.dart';
import 'package:masrofy/core/extensions/widget_extension.dart';
import 'package:masrofy/core/themes/app_colors.dart';
import 'package:masrofy/core/themes/app_sizes.dart';
import 'package:masrofy/core/widgets/custom_app_scaffold.dart';
import 'package:masrofy/features/home/view/widgets/home_appBar.dart';
import 'package:masrofy/features/home/view/widgets/overview_section.dart';
import 'package:masrofy/features/home/view/widgets/quick_tools.dart';
import 'package:masrofy/features/home/view/widgets/summery_card.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      isDark: context.isDarkMode,
      child: SingleChildScrollView(
        child: Column(
          children: [
            HomeAppBar().paddingAll(AppSizes.s),
            AppSizes.l.verticalSpace,
            SummeryCard().paddingAll(AppSizes.m),
            AppSizes.l.verticalSpace,
            QuickTools(),
            AppSizes.l.verticalSpace,
            OverviewSection()
          ],
        ),
      ),
    );
  }
}
