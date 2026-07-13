import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:masrofy/core/constants/app_assets.dart';
import 'package:masrofy/core/extensions/build_context.dart';
import 'package:masrofy/core/extensions/num_extension.dart';
import 'package:masrofy/core/extensions/widget_extension.dart';
import 'package:masrofy/core/themes/app_colors.dart';
import 'package:masrofy/core/themes/app_sizes.dart';

class ExpensesTab extends StatelessWidget {
  const ExpensesTab({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDarkMode;

    final List<Map<String, dynamic>> groups = [
      {
        'date': 'اليوم',
        'items': [
          {
            'title': 'مطعم',
            'subtitle': 'غداء مع الأصدقاء',
            'time': '12:30 م',
            'amount': '180',
            'icon': Icons.restaurant_rounded,
            'iconColor': AppColors.expense,
            'isHighlighted': true,
          },
          {
            'title': 'مواصلات',
            'subtitle': 'مترو',
            'time': '08:15 ص',
            'amount': '20',
            'icon': Icons.directions_car_rounded,
            'iconColor': AppColors.blue,
            'isHighlighted': false,
          },
          {
            'title': 'قهوة',
            'subtitle': 'ستاربكس',
            'time': '07:45 ص',
            'amount': '45',
            'icon': Icons.local_cafe_rounded,
            'iconColor': AppColors.orange,
            'isHighlighted': false,
          },
          {
            'title': 'تسوق',
            'subtitle': 'من السوبر ماركت',
            'time': '06:30 م',
            'amount': '215',
            'icon': Icons.shopping_bag_rounded,
            'iconColor': AppColors.success,
            'isHighlighted': false,
          },
        ],
      },
      {
        'date': 'أمس',
        'items': [
          {
            'title': 'فواتير',
            'subtitle': 'فاتورة الكهرباء',
            'time': '4:30 م',
            'amount': '350',
            'icon': Icons.electric_bolt_rounded,
            'iconColor': AppColors.purple,
            'isHighlighted': true,
          },
          {
            'title': 'تسوق',
            'subtitle': 'ملابس',
            'time': '2:15 م',
            'amount': '320',
            'icon': Icons.shopping_bag_rounded,
            'iconColor': AppColors.success,
            'isHighlighted': false,
          },
        ],
      },
    ];

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text("المعاملات", style: context.textTheme.titleLarge).center(),
          AppSizes.m.verticalSpace,

          // Summary Card
          const _ExpensesSummaryCard(),
          AppSizes.m.verticalSpace,

          // List of groups
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: groups.length,
            itemBuilder: (context, groupIndex) {
              final group = groups[groupIndex];
              final date = group['date'] as String;
              final items = group['items'] as List<Map<String, dynamic>>;

              return Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Group Date Label
                  Text(
                    date,
                    style: context.textTheme.bodySmall?.copyWith(
                      color: isDark
                          ? AppColors.textSecondaryDark
                          : AppColors.textSecondaryLight,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.right,
                  ).paddingAll(AppSizes.s),

                  // Group Card Wrapper
                  Container(
                    decoration: BoxDecoration(
                      color: isDark ? AppColors.cardDark : Colors.white,
                      borderRadius: AppSizes.rL.radius,
                      border: Border.all(
                        color: isDark
                            ? AppColors.borderDark
                            : AppColors.borderLight,
                      ),
                    ),
                    child: ListView.separated(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: items.length,
                      separatorBuilder: (context, index) => Divider(
                        height: 1,
                        thickness: 0.5,
                        color: isDark
                            ? AppColors.dividerDark
                            : AppColors.dividerLight,
                      ),
                      itemBuilder: (context, itemIndex) {
                        final item = items[itemIndex];
                        return _TransactionItem(
                          title: item['title'] as String,
                          subtitle: item['subtitle'] as String,
                          time: item['time'] as String,
                          amount: item['amount'] as String,
                          icon: item['icon'] as IconData,
                          iconColor: item['iconColor'] as Color,
                          isHighlighted: item['isHighlighted'] as bool,
                        );
                      },
                    ),
                  ),
                ],
              );
            },
          ),
        ],
      ).paddingAll(AppSizes.screenPadding),
    );
  }
}

class _ExpensesSummaryCard extends StatelessWidget {
  const _ExpensesSummaryCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: AppSizes.m.allPadding,
      decoration: BoxDecoration(
        gradient: AppColors.walletGradient,
        borderRadius: AppSizes.rXL.radius,
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withValues(alpha: 0.15),
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Left side: Text info & Period selector
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'إجمالي المصروفات',
                style: context.textTheme.bodyMedium?.copyWith(
                  color: Colors.white.withValues(alpha: 0.8),
                  fontWeight: FontWeight.w500,
                ),
              ),
              AppSizes.xs.verticalSpace,
              Row(
                crossAxisAlignment: CrossAxisAlignment.baseline,
                textBaseline: TextBaseline.alphabetic,
                children: [
                  Text('3,850', style: context.textTheme.headlineMedium),
                  AppSizes.s.horizontalSpace,
                  Text('EGP', style: context.textTheme.titleMedium),
                ],
              ),
              AppSizes.m.verticalSpace,
              // Period selection pill
              Container(
                padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 6.h),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.15),
                  borderRadius: AppSizes.rM.radius,
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.keyboard_arrow_down_rounded,
                      color: Colors.white,
                      size: 16,
                    ),
                    AppSizes.xs.horizontalSpace,
                    Text('هذا الشهر', style: context.textTheme.bodySmall),
                  ],
                ),
              ),
            ],
          ).expanded(),

          // Right side: Expenses illustration image
          AppSizes.s.horizontalSpace,
          Image.asset(
            AppAssets.goals,
            width: 120.w,
            height: 120.h,
            fit: BoxFit.contain,
          ),
        ],
      ),
    );
  }
}

class _TransactionItem extends StatelessWidget {
  final String title;
  final String subtitle;
  final String time;
  final String amount;
  final IconData icon;
  final Color iconColor;
  final bool isHighlighted;

  const _TransactionItem({
    required this.title,
    required this.subtitle,
    required this.time,
    required this.amount,
    required this.icon,
    required this.iconColor,
    required this.isHighlighted,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDarkMode;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: AppSizes.m, vertical: 12.h),
      child: Row(
        children: [
          // Right side: Icon + Text info
          Row(
            children: [
              Container(
                width: 40.w,
                height: 40.h,
                decoration: BoxDecoration(
                  color: iconColor.withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, color: iconColor, size: AppSizes.iconS),
              ),
              AppSizes.m.horizontalSpace,
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: context.textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  4.verticalSpace,
                  Text(
                    subtitle,
                    style: context.textTheme.bodySmall?.copyWith(
                      color: isDark
                          ? AppColors.textSecondaryDark
                          : AppColors.textSecondaryLight,
                    ),
                  ),
                ],
              ),
            ],
          ),

          const Spacer(),

          // Middle: Time
          Text(
            time,
            style: context.textTheme.bodySmall?.copyWith(
              color: isDark
                  ? AppColors.textSecondaryDark
                  : AppColors.textSecondaryLight,
            ),
          ),

          const Spacer(),

          // Left: Amount
          Text(
            '$amount EGP',
            style: context.textTheme.bodyLarge?.copyWith(
              color: isHighlighted
                  ? AppColors.expense
                  : (isDark
                        ? AppColors.textPrimaryDark
                        : AppColors.textPrimaryLight),
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
