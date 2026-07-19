import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:masrofy/core/extensions/build_context.dart';
import 'package:masrofy/core/extensions/num_extension.dart';
import 'package:masrofy/core/extensions/widget_extension.dart';
import 'package:masrofy/core/themes/app_colors.dart';
import 'package:masrofy/core/themes/app_sizes.dart';
import 'package:masrofy/features/home/controllers/statistics_providers.dart';

class OverviewSection extends ConsumerWidget {
  const OverviewSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final todayExpense = ref.watch(todyaExpenseProvider);
    final income = ref.watch(thisMonthIncomProvider);
    final debts = ref.watch(unpaidDebtsProvider);
    final goals = ref.watch(goalsProgressProvider);
    final overviewItems = [
      {
        'title': "مصاريف اليوم",
        'value': todayExpense.formatAmount,
        'currency': 'ج م',
        'icon': Icons.account_balance_wallet_outlined,
        'hasFilter': true,
        'filterColor': AppColors.error,
        'color': AppColors.error,
        'valueColor': context.isDarkMode
            ? AppColors.textPrimaryDark
            : AppColors.grey800,
      },
      {
        'title': "دخل الشهر الحالي",
        'value': income.formatAmount,
        'currency': 'ج م',
        'icon': Icons.account_balance_wallet_outlined,
        'hasFilter': false,
        'color': AppColors.success,
        'valueColor': AppColors.success,
      },
      {
        'title': "إجمالي الديون",
        'value': debts.formatAmount,
        'currency': 'ج م',
        'icon': Icons.account_balance_wallet_outlined,
        'hasFilter': true,
        'filterColor': AppColors.warning,
        'color': AppColors.warning,
        'valueColor': AppColors.error,
      },
      {
        'title': "الأهداف المكتملة",
        'value': '${goals.completed} / ${goals.total}',
        'currency': '',
        'icon': Icons.track_changes_rounded,
        'hasFilter': false,
        'color': AppColors.saving,
        'valueColor': AppColors.saving,
      },
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Align(
          alignment: Alignment.centerRight,
          child: Text("نظرة عامة", style: context.textTheme.titleMedium),
        ),
        AppSizes.m.verticalSpace,
        Container(
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
                blurRadius: 12,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: overviewItems.length,
            separatorBuilder: (context, index) => Divider(
              height: 1,
              thickness: 0.5,
              color: context.isDarkMode
                  ? AppColors.dividerDark
                  : AppColors.grey200,
            ),
            itemBuilder: (context, index) {
              final item = overviewItems[index];
              Widget iconWidget = Container(
                width: 36.w,
                height: 36.h,
                decoration: BoxDecoration(
                  color: (item['color'] as Color).withValues(alpha: 0.12),
                  borderRadius: AppSizes.rL.radius,
                ),
                child: Icon(
                  item['icon'] as IconData,
                  size: 20.sp,
                  color: item['color'] as Color,
                ),
              );
              return Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: AppSizes.m,
                  vertical: 14.h,
                ),
                child: Row(
                  children: [
                    Row(
                      children: [
                        Container(
                          width: 32.w,
                          height: 32.h,
                          decoration: BoxDecoration(
                            color: (item['color'] as Color).withValues(
                              alpha: 0.08,
                            ),
                            shape: BoxShape.circle,
                          ),
                          alignment: Alignment.center,
                          child: iconWidget,
                        ),
                        12.horizontalSpace,
                        Text(
                          item['title'] as String,
                          style: context.textTheme.bodyMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: context.isDarkMode
                                ? AppColors.textPrimaryDark
                                : AppColors.grey700,
                          ),
                        ),
                      ],
                    ),
                    const Spacer(),
                    Row(
                      children: [
                        Text(
                          item['value'] as String,
                          style: context.textTheme.titleMedium?.copyWith(
                            color: item['valueColor'] as Color,
                          ),
                        ),
                        if ((item['currency'] as String).isNotEmpty) ...[
                          4.horizontalSpace,
                          Text(
                            item['currency'] as String,
                            style: context.textTheme.bodySmall?.copyWith(
                              color: item['valueColor'] as Color,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    ).paddingHorizontal(AppSizes.m);
  }
}
