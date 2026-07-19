import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:masrofy/core/extensions/build_context.dart';
import 'package:masrofy/core/extensions/num_extension.dart';
import 'package:masrofy/core/extensions/widget_extension.dart';
import 'package:masrofy/core/themes/app_colors.dart';
import 'package:masrofy/core/themes/app_sizes.dart';
import 'package:masrofy/features/home/controllers/reports_provider.dart';
import 'package:masrofy/features/home/models/category_report_model.dart';

class ReportsTab extends ConsumerWidget {
  const ReportsTab({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controller = ref.watch(reportsDataProvider);
    final filter = ref.watch(reportsFilterProvider);
    final isDark = context.isDarkMode;
    final iconColor = context.colorScheme.onSurface;

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // ── Header ──
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                onPressed: () {},
                icon: Icon(
                  Icons.menu_rounded,
                  color: iconColor,
                  size: AppSizes.iconM,
                ),
              ),
              Text(
                'الملخص والإحصائيات',
                style: context.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              // Placeholder for symmetry
              AppSizes.xl.horizontalSpace,
            ],
          ),
          AppSizes.m.verticalSpace,

          // ── Period Filter Pill ──
          Align(
            alignment: Alignment.centerRight,
            child: PopupMenuButton<ReportsFilter>(
              initialValue: filter,
              onSelected: (filter) {
                ref.read(reportsFilterProvider.notifier).setFilter(filter);
              },
              itemBuilder: (context) => ReportsFilter.values.map((filter) {
                return PopupMenuItem<ReportsFilter>(
                  value: filter,
                  child: Text(filter.name, style: context.textTheme.bodyMedium),
                );
              }).toList(),
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 8.h),
                decoration: BoxDecoration(
                  color: isDark ? AppColors.cardDark : Colors.white,
                  borderRadius: BorderRadius.circular(AppSizes.rM),
                  border: Border.all(
                    color: isDark
                        ? AppColors.borderDark
                        : AppColors.borderLight,
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  textDirection: TextDirection.rtl,
                  children: [
                    Text(
                      filter.name,
                      style: context.textTheme.bodySmall?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    AppSizes.xs.horizontalSpace,
                    Icon(
                      Icons.keyboard_arrow_down_rounded,
                      size: AppSizes.iconS,
                      color: isDark
                          ? AppColors.textSecondaryDark
                          : AppColors.textSecondaryLight,
                    ),
                  ],
                ),
              ),
            ),
          ),
          AppSizes.m.verticalSpace,
          controller.when(
            error: (error, stackTrace) =>
                Text("حدث خطأ ما ").center().paddingAll(AppSizes.xl),
            loading: () => CircularProgressIndicator.adaptive()
                .center()
                .paddingAll(AppSizes.xl),

            data: (data) {
              String? getChangeText(double? change) {
                if (change == null || change == 0.0) return null;
                final sign = change > 0 ? '▲' : '▼';
                return '$sign ${change.abs().toStringAsFixed(1)}%';
              }

              Color getChangeColor(double? change, bool isIncome) {
                if (change == null) return Colors.transparent;
                if (isIncome) {
                  return change >= 0 ? AppColors.income : AppColors.expense;
                } else {
                  return change >= 0 ? AppColors.expense : AppColors.income;
                }
              }

              final subText = filter == ReportsFilter.thisYear
                  ? 'من العام الماضي'
                  : 'من الشهر الماضي';

              return Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Row(
                    children: [
                      _StatCard(
                        label: 'إجمالي الدخل',
                        amount: data.totalIncome.formatAmount,
                        changeText: getChangeText(data.incomeChange),
                        changeColor: getChangeColor(data.incomeChange, true),
                        subText: data.incomeChange != null ? subText : '',
                      ),
                      AppSizes.m.horizontalSpace,
                      _StatCard(
                        label: 'إجمالي المصروفات',
                        amount: data.totalExpense.formatAmount,
                        changeText: getChangeText(data.expenseChange),
                        changeColor: getChangeColor(data.expenseChange, false),
                        subText: data.expenseChange != null ? subText : '',
                      ),
                    ],
                  ),
                  AppSizes.m.verticalSpace,
                  Row(
                    children: [
                      _StatCard(
                        label: 'صافي الدخل',
                        amount: data.netIncome.formatAmount,
                        subText: '',
                      ),
                      AppSizes.m.horizontalSpace,
                      _StatCard(
                        label: 'معدل التوفير',
                        amount: data.savingsRate.toStringAsFixed(0) + "%",
                        subText: 'من الدخل',
                        isPercentage: true,
                      ),
                    ],
                  ),
                  AppSizes.l.verticalSpace,
                  Container(
                    padding: AppSizes.m.allPadding,
                    decoration: BoxDecoration(
                      color: isDark ? AppColors.cardDark : Colors.white,
                      borderRadius: AppSizes.rXL.radius,
                      border: Border.all(
                        color: isDark
                            ? AppColors.borderDark
                            : AppColors.borderLight,
                      ),
                    ),
                    child: Column(
                      children: [
                        // Section Title
                        Text(
                          'المصروفات حسب الفئة',
                          style: context.textTheme.titleMedium,
                          textAlign: TextAlign.center,
                        ),
                        AppSizes.l.verticalSpace,

                        // Donut Chart
                        SizedBox(
                          width: 200.w,
                          height: 200.h,
                          child: _DonutChart(data.categoryItems),
                        ),
                        AppSizes.l.verticalSpace,

                        // Category Legend
                        _CategoryLegend(data.categoryItems),
                      ],
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

// ── Stat Card ──
class _StatCard extends StatelessWidget {
  final String label;
  final String amount;
  final String? changeText;
  final Color? changeColor;
  final String subText;
  final bool isPercentage;

  const _StatCard({
    required this.label,
    required this.amount,
    this.changeText,
    this.changeColor,
    required this.subText,
    this.isPercentage = false,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDarkMode;

    return Container(
      padding: 14.allPadding,
      decoration: BoxDecoration(
        color: isDark ? AppColors.cardDark : Colors.white,
        borderRadius: BorderRadius.circular(AppSizes.rL),
        border: Border.all(
          color: isDark ? AppColors.borderDark : AppColors.borderLight,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Text(
            label,
            style: context.textTheme.bodySmall?.copyWith(
              color: isDark
                  ? AppColors.textSecondaryDark
                  : AppColors.textSecondaryLight,
            ),
          ),
          AppSizes.s.verticalSpace,
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              if (!isPercentage)
                Text(
                  'EGP ',
                  style: context.textTheme.bodySmall?.copyWith(
                    color: isDark
                        ? AppColors.textSecondaryDark
                        : AppColors.textSecondaryLight,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              Text(amount, style: context.textTheme.titleLarge),
            ],
          ),
          if (changeText != null) ...[
            AppSizes.s.verticalSpace,
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text(
                  changeText!,
                  style: context.textTheme.labelSmall?.copyWith(
                    color: changeColor,
                  ),
                ),
              ],
            ),
          ],
          if (subText.isNotEmpty) ...[
            4.verticalSpace,
            Text(
              subText,
              style: context.textTheme.labelSmall?.copyWith(
                color: isDark
                    ? AppColors.textSecondaryDark
                    : AppColors.textSecondaryLight,
              ),
            ),
          ],
        ],
      ),
    ).expanded();
  }
}

// ── Donut Chart (Custom Painter) ──
class _DonutChart extends StatelessWidget {
  final List<CategoryReportModel> categoryItems;
  const _DonutChart(this.categoryItems);

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: _DonutChartPainter(
        isDark: context.isDarkMode,
        categoryItems: categoryItems,
      ),
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'إجمالي',
              style: context.textTheme.bodySmall?.copyWith(
                color: context.isDarkMode
                    ? AppColors.textSecondaryDark
                    : AppColors.textSecondaryLight,
              ),
            ),
            4.verticalSpace,
            Text(
              '15,400',
              style: context.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _DonutChartPainter extends CustomPainter {
  final bool isDark;
  final List<CategoryReportModel> categoryItems;

  _DonutChartPainter({required this.isDark, required this.categoryItems});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2 - 12;
    const strokeWidth = 28.0;
    const gapAngle = 0.04; // small gap between segments

    // Background ring
    final bgPaint = Paint()
      ..color = isDark ? AppColors.borderDark : AppColors.grey100
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;
    canvas.drawCircle(center, radius, bgPaint);

    if (categoryItems.isEmpty) {
      return;
    }

    // Draw segments
    var startAngle = -pi / 2; // start from top
    for (final item in categoryItems) {
      if (item.percentage <= 0) continue;
      final sweepAngle = 2 * pi * item.percentage - gapAngle;
      if (sweepAngle <= 0) continue;

      final paint = Paint()
        ..color = item.color
        ..style = PaintingStyle.stroke
        ..strokeWidth = strokeWidth
        ..strokeCap = StrokeCap.round;

      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius),
        startAngle,
        sweepAngle,
        false,
        paint,
      );
      startAngle += sweepAngle + gapAngle;
    }
  }

  @override
  bool shouldRepaint(covariant _DonutChartPainter oldDelegate) =>
      isDark != oldDelegate.isDark ||
      categoryItems != oldDelegate.categoryItems;
}

// ── Category Legend ──
class _CategoryLegend extends StatelessWidget {
  final List<CategoryReportModel> categoryItems;
  const _CategoryLegend(this.categoryItems);

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDarkMode;
    if (categoryItems.isEmpty) {
      return Padding(
        padding: EdgeInsets.symmetric(vertical: 16.h),
        child: Text(
          'لا توجد مصروفات مسجلة لهذه الفترة',
          style: context.textTheme.bodyMedium?.copyWith(
            color: isDark
                ? AppColors.textSecondaryDark
                : AppColors.textSecondaryLight,
          ),
          textAlign: TextAlign.center,
        ),
      );
    }

    return Column(
      children: categoryItems.map((cat) {
        return Padding(
          padding: 6.h.verticalPadding,
          child: Row(
            children: [
              // Color dot
              Container(
                width: 10.w,
                height: 10.h,
                decoration: BoxDecoration(
                  color: cat.color,
                  shape: BoxShape.circle,
                ),
              ),
              AppSizes.s.horizontalSpace,
              // Category name
              Text(
                cat.label,
                style: context.textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w500,
                ),
              ).expanded(),
              // Percentage
              Text(
                "${(cat.percentage * 100).toStringAsFixed(0)} %",
                style: context.textTheme.bodySmall?.copyWith(
                  color: isDark
                      ? AppColors.textSecondaryDark
                      : AppColors.textSecondaryLight,
                  fontWeight: FontWeight.bold,
                ),
              ),
              AppSizes.m.horizontalSpace,
              // Amount
              Text(
                "EGP ${cat.amount.formatAmount}",
                style: context.textTheme.bodySmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }
}
