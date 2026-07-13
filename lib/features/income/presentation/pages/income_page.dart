import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:masrofy/core/constants/app_assets.dart';
import 'package:masrofy/core/extensions/build_context.dart';
import 'package:masrofy/core/extensions/num_extension.dart';
import 'package:masrofy/core/extensions/widget_extension.dart';
import 'package:masrofy/core/themes/app_colors.dart';
import 'package:masrofy/core/themes/app_sizes.dart';
import 'package:masrofy/core/widgets/custom_app_scaffold.dart';

class IncomePage extends StatelessWidget {
  const IncomePage({super.key});

  @override
  Widget build(BuildContext context) {

    final List<Map<String, dynamic>> incomeSources = [
      {
        'title': 'الراتب الشهري',
        'subtitle': 'الشركة الحالية',
        'amount': '20,000',
        'frequency': 'كل شهر',
        'icon': Icons.business_center_rounded,
        'color': AppColors.primary,
      },
      {
        'title': 'عمل حر',
        'subtitle': 'مشاريع مستقلة',
        'amount': '5,000',
        'frequency': 'كل شهر',
        'icon': Icons.laptop_mac_rounded,
        'color': AppColors.primary,
      },
      {
        'title': 'استثمار',
        'subtitle': 'أرباح الاستثمار',
        'amount': '2,500',
        'frequency': 'كل 3 أشهر',
        'icon': Icons.trending_up_rounded,
        'color': AppColors.accent,
      },
      {
        'title': 'أخرى',
        'subtitle': 'دخل إضافي',
        'amount': '350',
        'frequency': 'عند الحاجة',
        'icon': Icons.more_horiz_rounded,
        'color': AppColors.purple,
      },
    ];

    return AppScaffold(
      isDark: context.isDarkMode,
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Header Row
            CustomAppBar(title: "مصادر الدخل"),
            AppSizes.m.verticalSpace,

            // Summary Card
            const _IncomeSummaryCard(),
            AppSizes.l.verticalSpace,

            // List of income sources
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: incomeSources.length,
              separatorBuilder: (context, index) => AppSizes.m.verticalSpace,
              itemBuilder: (context, index) {
                final item = incomeSources[index];
                return _IncomeSourceCard(
                  title: item['title'] as String,
                  subtitle: item['subtitle'] as String,
                  amount: item['amount'] as String,
                  frequency: item['frequency'] as String,
                  icon: item['icon'] as IconData,
                  color: item['color'] as Color,
                );
              },
            ),
          ],
        ).paddingAll(AppSizes.screenPadding),
      ),
    );
  }
}

class CustomAppBar extends StatelessWidget {
  const CustomAppBar({super.key, required this.title});
  final String title;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        IconButton(
          onPressed: () => context.pop(),
          icon: Icon(
            Icons.arrow_back_rounded,
            color: context.colorScheme.onSurface,
            size: AppSizes.iconM,
          ),
        ),
        Text(title, style: context.textTheme.titleLarge),
        IconButton(
          onPressed: () {},
          icon: Icon(
            Icons.add_rounded,
            color: context.colorScheme.onSurface,
            size: AppSizes.iconM,
          ),
        ),
      ],
    );
  }
}

class _IncomeSummaryCard extends StatelessWidget {
  const _IncomeSummaryCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: 16.allPadding,
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
                'إجمالي الدخل',
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
                  Text('27,850', style: context.textTheme.headlineMedium),
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
                    Icon(
                      Icons.keyboard_arrow_down_rounded,
                      color: Colors.white,
                      size: AppSizes.iconXS,
                    ),
                    AppSizes.xs.horizontalSpace,
                    Text('هذا الشهر', style: context.textTheme.bodySmall),
                  ],
                ),
              ),
            ],
          ).expanded(),
          // Right side: Income illustration image
          AppSizes.s.horizontalSpace,
          Image.asset(
            AppAssets.income,
            width: 120.w,
            height: 120.h,
            fit: BoxFit.contain,
          ),
        ],
      ),
    );
  }
}

class _IncomeSourceCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final String amount;
  final String frequency;
  final IconData icon;
  final Color color;

  const _IncomeSourceCard({
    required this.title,
    required this.subtitle,
    required this.amount,
    required this.frequency,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDarkMode;

    return Container(
      padding: AppSizes.m.allPadding,
      decoration: BoxDecoration(
        color: isDark ? AppColors.cardDark : Colors.white,
        borderRadius: AppSizes.rL.radius,
        border: Border.all(
          color: isDark ? AppColors.borderDark : AppColors.borderLight,
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Right side: Icon and text information
          Row(
            children: [
              Container(
                width: 44.w,
                height: 44.h,
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(AppSizes.rM),
                ),
                child: Icon(icon, color: color, size: AppSizes.iconM),
              ),
              AppSizes.m.horizontalSpace,
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: context.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  AppSizes.xs.verticalSpace,
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
          // Left side: Amount and frequency details
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '$amount EGP',
                style: context.textTheme.titleMedium?.copyWith(
                  color: AppColors.income,
                  fontWeight: FontWeight.bold,
                ),
              ),
              AppSizes.s.verticalSpace,
              Row(
                children: [
                  Icon(
                    Icons.calendar_today_outlined,
                    size: AppSizes.iconXS,
                    color: isDark
                        ? AppColors.textSecondaryDark
                        : AppColors.textSecondaryLight,
                  ),
                  AppSizes.xs.horizontalSpace,
                  Text(
                    frequency,
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
        ],
      ),
    );
  }
}
