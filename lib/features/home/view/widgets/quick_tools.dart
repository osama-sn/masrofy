import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:masrofy/core/extensions/build_context.dart';
import 'package:masrofy/core/extensions/num_extension.dart';
import 'package:masrofy/core/extensions/widget_extension.dart';
import 'package:masrofy/core/routes/app_routes.dart';
import 'package:masrofy/core/themes/app_colors.dart';
import 'package:masrofy/core/themes/app_sizes.dart';

class QuickTools extends StatelessWidget {
  const QuickTools({super.key});

  @override
  Widget build(BuildContext context) {
    final tools = [
      {
        'label': "الأهداف",
        'icon': Icons.track_changes_rounded,
        'color': AppColors.purple,
        'route': AppRoutes.goals,
      },
      {
        'label': "الديون",
        'icon': Icons.account_balance_wallet_rounded,
        'color': AppColors.warning,
        'route': AppRoutes.depts,
      },
      {
        'label': "الدخل",
        'icon': Icons.trending_up_rounded,
        'color': AppColors.income,
        'route': '',
      },
      {
        'label': "المصاريف",
        'icon': Icons.shopping_bag_rounded,
        'color': AppColors.expense,
        'route': '',
      },
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Align(
          alignment: Alignment.centerRight,
          child: Text("أدوات سريعه", style: context.textTheme.titleMedium),
        ),
        AppSizes.m.verticalSpace,

        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: tools.map((tool) {
            final color = tool['color'] as Color;
            final route = tool['route'] as String;

            return Container(
              width: 76.w,
              height: 80.h,
              decoration: BoxDecoration(
                color: context.isDarkMode ? AppColors.cardDark : Colors.white,
                borderRadius: AppSizes.rL.radius,
                border: Border.all(
                  color: context.isDarkMode
                      ? AppColors.borderDark
                      : AppColors.grey200,
                  width: 1,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.03),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: InkWell(
                onTap: () {
                  if (route.isNotEmpty) {
                    context.push(route);
                  }
                },
                borderRadius: AppSizes.rL.radius,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: 44.w,
                      height: 44.h,
                      decoration: BoxDecoration(
                        color: color.withValues(alpha: 0.1),
                        shape: BoxShape.circle,
                      ),
                      alignment: Alignment.center,
                      child: Icon(
                        tool['icon'] as IconData,
                        color: color,
                        size: AppSizes.iconM,
                      ),
                    ),
                    AppSizes.xs.verticalSpace,
                    Text(
                      tool['label'] as String,
                      style: context.textTheme.bodySmall?.copyWith(
                        color: context.isDarkMode
                            ? AppColors.textPrimaryDark
                            : AppColors.grey700,
                      ),
                    ),
                  ],
                ),
              ),
            );
          }).toList(),
        ),
      ],
    ).paddingHorizontal(AppSizes.m);
  }
}
