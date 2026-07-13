import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:masrofy/core/extensions/build_context.dart';
import 'package:masrofy/core/extensions/num_extension.dart';
import 'package:masrofy/core/extensions/widget_extension.dart';
import 'package:masrofy/core/themes/app_colors.dart';
import 'package:masrofy/core/themes/app_sizes.dart';
import 'package:masrofy/core/widgets/custom_app_scaffold.dart';
import 'package:masrofy/features/income/presentation/pages/income_page.dart';

class DebtsPage extends StatefulWidget {
  const DebtsPage({super.key});

  @override
  State<DebtsPage> createState() => _DebtsPageState();
}

class _DebtsPageState extends State<DebtsPage> {
  int _selectedTabIndex = 0; // 0: كل الديون, 1: متبقي, 2: مسددة

  final List<Map<String, dynamic>> _allDebts = [
    {
      'title': 'قرض شخصي',
      'subtitle': 'الأهلي',
      'remaining': '3,000',
      'total': '6,000',
      'percentage': 60,
      'progress': 0.6,
      'color': AppColors.expense,
      'isPaid': false,
    },
    {
      'title': 'بطاقة الائتمان',
      'subtitle': 'البنك التجاري الدولي',
      'remaining': '1,250',
      'total': '2,000',
      'percentage': 37,
      'progress': 0.37,
      'color': AppColors.blue,
      'isPaid': false,
    },
    {
      'title': 'دين لصديق',
      'subtitle': 'أحمد محمد',
      'remaining': '950',
      'total': '1,000',
      'percentage': 95,
      'progress': 0.95,
      'color': AppColors.success,
      'isPaid': false,
    },
    // Mock paid debt for demonstrating tab filtering
    {
      'title': 'دين لـ محمد',
      'subtitle': 'مسترد كامل',
      'remaining': '0',
      'total': '2,000',
      'percentage': 100,
      'progress': 1.0,
      'color': AppColors.success,
      'isPaid': true,
    },
  ];

  @override
  Widget build(BuildContext context) {
    final iconColor = context.colorScheme.onSurface;

    // Filter debts based on selected tab
    final filteredDebts = _allDebts.where((debt) {
      if (_selectedTabIndex == 1) {
        return !debt['isPaid'] &&
            double.parse((debt['remaining'] as String).replaceAll(',', '')) > 0;
      } else if (_selectedTabIndex == 2) {
        return debt['isPaid'] ||
            double.parse((debt['remaining'] as String).replaceAll(',', '')) ==
                0;
      }
      return !debt['isPaid']; // Default Tab 0 (كل الديون) shows active debts
    }).toList();

    return AppScaffold(
      isDark: context.isDarkMode,
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Header Row
            CustomAppBar(title: "الديون"),

            AppSizes.m.verticalSpace,

            // Red Coral Gradient Card
            const _DebtsSummaryCard(),
            AppSizes.l.verticalSpace,

            // Custom tab bar
            Row(
              textDirection: TextDirection.rtl,
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildTabItem('كل الديون', index: 0),
                _buildTabItem('متبقي', index: 1),
                _buildTabItem('مسددة', index: 2),
              ],
            ),
            AppSizes.l.verticalSpace,

            // List of Debts
            if (filteredDebts.isEmpty)
              Center(
                child: Column(
                  children: [
                    AppSizes.xxl.verticalSpace,
                    Icon(
                      Icons.account_balance_wallet_outlined,
                      size: AppSizes.iconXL,
                      color: AppColors.grey400,
                    ),
                    AppSizes.m.verticalSpace,
                    Text(
                      'لا توجد ديون حالياً',
                      style: context.textTheme.bodyMedium?.copyWith(
                        color: AppColors.grey500,
                      ),
                    ),
                  ],
                ),
              )
            else
              ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: filteredDebts.length,
                separatorBuilder: (context, index) => AppSizes.m.verticalSpace,
                itemBuilder: (context, index) {
                  final debt = filteredDebts[index];
                  return _DebtCard(
                    title: debt['title'] as String,
                    subtitle: debt['subtitle'] as String,
                    remaining: debt['remaining'] as String,
                    total: debt['total'] as String,
                    percentage: debt['percentage'] as int,
                    progressValue: debt['progress'] as double,
                    progressColor: debt['color'] as Color,
                  );
                },
              ),
          ],
        ).paddingAll(AppSizes.screenPadding),
      ),
    );
  }

  Widget _buildTabItem(String label, {required int index}) {
    final isSelected = _selectedTabIndex == index;
    final isDark = context.isDarkMode;

    return GestureDetector(
      onTap: () => setState(() => _selectedTabIndex = index),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            label,
            style: context.textTheme.titleSmall?.copyWith(
              color: isSelected
                  ? AppColors.expense
                  : (isDark
                        ? AppColors.textSecondaryDark
                        : AppColors.textSecondaryLight),
              fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
            ),
          ),
          AppSizes.xs.verticalSpace,
          Container(
            width: 60.w,
            height: 2.h,
            decoration: BoxDecoration(
              color: isSelected ? AppColors.expense : Colors.transparent,
              borderRadius: 1.r.radius,
            ),
          ),
        ],
      ),
    );
  }
}

class _DebtsSummaryCard extends StatelessWidget {
  const _DebtsSummaryCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: 16.allPadding,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFFF87171), Color(0xFFEF4444)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: AppSizes.rXL.radius,
        boxShadow: [
          BoxShadow(
            color: AppColors.expense.withValues(alpha: 0.15),
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Left side: Text details
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'إجمالي الديون',
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
                  Text(
                    '5,200',
                    style: context.textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  AppSizes.s.horizontalSpace,
                  Text(
                    'EGP',
                    style: context.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
              AppSizes.s.verticalSpace,
              Text(
                'متبقي',
                style: context.textTheme.bodySmall?.copyWith(
                  color: Colors.white.withValues(alpha: 0.9),
                ),
              ),
            ],
          ),
          // Right side: Circular progress indicator
          Column(
            children: [
              Stack(
                alignment: Alignment.center,
                children: [
                  SizedBox(
                    width: 54.w,
                    height: 54.h,
                    child: CircularProgressIndicator(
                      value: 0.45,
                      strokeWidth: 5.w,
                      color: Colors.white,
                      backgroundColor: Colors.white.withValues(alpha: 0.25),
                    ),
                  ),
                  Text(
                    '45%',
                    style: context.textTheme.bodySmall?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              AppSizes.s.verticalSpace,
              Text(
                'تم السداد',
                style: context.textTheme.bodySmall?.copyWith(
                  color: Colors.white.withValues(alpha: 0.9),
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _DebtCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final String remaining;
  final String total;
  final int percentage;
  final double progressValue;
  final Color progressColor;

  const _DebtCard({
    required this.title,
    required this.subtitle,
    required this.remaining,
    required this.total,
    required this.percentage,
    required this.progressValue,
    required this.progressColor,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDarkMode;

    return Container(
      padding: 16.allPadding,
      decoration: BoxDecoration(
        color: isDark ? AppColors.cardDark : Colors.white,
        borderRadius: AppSizes.rL.radius,
        border: Border.all(
          color: isDark ? AppColors.borderDark : AppColors.borderLight,
        ),
      ),
      child: Column(
        children: [
          // Top Row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Title & Subtitle (Right)
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(title, style: context.textTheme.titleMedium),
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
              // Remaining (Left)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '$remaining EGP',
                    style: context.textTheme.titleMedium?.copyWith(),
                  ),
                  2.verticalSpace,
                  Text(
                    'تبقي',
                    style: context.textTheme.labelSmall?.copyWith(
                      color: isDark
                          ? AppColors.textSecondaryDark
                          : AppColors.textSecondaryLight,
                    ),
                  ),
                ],
              ),
            ],
          ),
          12.verticalSpace,
          // Bottom Row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Progress Bar & Percentage (Right)
              Expanded(
                child: Row(
                  children: [
                    Text(
                      '$percentage%',
                      style: context.textTheme.labelSmall?.copyWith(),
                    ),
                    8.horizontalSpace,
                    Expanded(
                      child: ClipRRect(
                        borderRadius: 10.r.radius,
                        child: LinearProgressIndicator(
                          value: progressValue,
                          minHeight: 6.h,
                          backgroundColor: isDark
                              ? AppColors.borderDark
                              : AppColors.grey100,
                          valueColor: AlwaysStoppedAnimation<Color>(
                            progressColor,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              24.horizontalSpace,
              // Total Amount (Left)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '$total EGP',
                    style: context.textTheme.bodySmall?.copyWith(
                      color: isDark
                          ? AppColors.textSecondaryDark
                          : AppColors.textSecondaryLight,
                    ),
                  ),
                  2.verticalSpace,
                  Text(
                    'الإجمالي',
                    style: context.textTheme.labelSmall?.copyWith(
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
