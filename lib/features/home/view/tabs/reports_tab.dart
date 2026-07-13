import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:masrofy/core/extensions/build_context.dart';
import 'package:masrofy/core/extensions/num_extension.dart';
import 'package:masrofy/core/extensions/widget_extension.dart';
import 'package:masrofy/core/themes/app_colors.dart';
import 'package:masrofy/core/themes/app_sizes.dart';

class ReportsTab extends StatelessWidget {
  const ReportsTab({super.key});

  @override
  Widget build(BuildContext context) {
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
              AppSizes.xl.horizontalSpace
            ],
          ),
          AppSizes.m.verticalSpace,

          // ── Period Filter Pill ──
          Align(
            alignment: Alignment.centerRight,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 8.h),
              decoration: BoxDecoration(
                color: isDark ? AppColors.cardDark : Colors.white,
                borderRadius: AppSizes.rM.radius,
                border: Border.all(
                  color: isDark ? AppColors.borderDark : AppColors.borderLight,
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'هذا الشهر',
                    style: context.textTheme.bodySmall
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
          AppSizes.m.verticalSpace,

          // ── 4 Stat Cards (2 × 2 Grid) ──
          Row(
            children: [
              _StatCard(
                label: 'إجمالي الدخل',
                amount: '27,850',
                changeText: '▲ 12%',
                changeColor: AppColors.income,
                subText: 'من الشهر الماضي',
              ),
              AppSizes.m.horizontalSpace,
              _StatCard(
                label: 'إجمالي المصروفات',
                amount: '15,400',
                changeText: '▼ 8%',
                changeColor: AppColors.expense,
                subText: 'من الشهر الماضي',
              ),
            ],
          ),
          AppSizes.m.verticalSpace,
          Row(
            children: [
              _StatCard(
                label: 'صافي الدخل',
                amount: '12,450',
                subText: '',
              ),
              AppSizes.m.horizontalSpace,
              _StatCard(
                label: 'معدل التوفير',
                amount: '45%',
                subText: 'من الدخل',
                isPercentage: true,
              ),
            ],
          ),
          AppSizes.l.verticalSpace,

          // ── Expenses by Category Section ──
          Container(
            padding: AppSizes.m.allPadding,
            decoration: BoxDecoration(
              color: isDark ? AppColors.cardDark : Colors.white,
              borderRadius: AppSizes.rXL.radius,
              border: Border.all(
                color: isDark ? AppColors.borderDark : AppColors.borderLight,
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
                  child: const _DonutChart(),
                ),
                AppSizes.l.verticalSpace,

                // Category Legend
                const _CategoryLegend(),
              ],
            ),
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
              Text(
                amount,
                style: context.textTheme.titleLarge
              ),
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
  const _DonutChart();

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: _DonutChartPainter(isDark: context.isDarkMode),
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

  _DonutChartPainter({required this.isDark});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2 - 12;
    const strokeWidth = 28.0;
    const gapAngle = 0.04; // small gap between segments

    // Category data: percentage, color
    final segments = [
      (0.30, AppColors.expense), // الطعام – 30%
      (0.25, AppColors.blue), // المواصلات – 25%
      (0.15, AppColors.accent), // الفواتير – 15%
      (0.12, AppColors.purple), // تسوق – 12%
      (0.10, AppColors.orange), // ترفيه – 10%
      (0.08, AppColors.grey400), // أخرى – 8%
    ];

    // Background ring
    final bgPaint = Paint()
      ..color = isDark ? AppColors.borderDark : AppColors.grey100
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;
    canvas.drawCircle(center, radius, bgPaint);

    // Draw segments
    var startAngle = -pi / 2; // start from top
    for (final (fraction, color) in segments) {
      final sweepAngle = 2 * pi * fraction - gapAngle;
      final paint = Paint()
        ..color = color
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
      isDark != oldDelegate.isDark;
}

// ── Category Legend ──
class _CategoryLegend extends StatelessWidget {
  const _CategoryLegend();

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDarkMode;

    final categories = [
      {
        'label': 'المواصلات',
        'color': AppColors.blue,
        'percentage': '25%',
        'amount': 'EGP 3,850',
      },
      {
        'label': 'الطعام',
        'color': AppColors.expense,
        'percentage': '30%',
        'amount': 'EGP 4,620',
      },
      {
        'label': 'الفواتير',
        'color': AppColors.accent,
        'percentage': '15%',
        'amount': 'EGP 2,310',
      },
      {
        'label': 'تسوق',
        'color': AppColors.purple,
        'percentage': '12%',
        'amount': 'EGP 1,848',
      },
      {
        'label': 'ترفيه',
        'color': AppColors.orange,
        'percentage': '10%',
        'amount': 'EGP 1,540',
      },
      {
        'label': 'أخرى',
        'color': AppColors.grey400,
        'percentage': '8%',
        'amount': 'EGP 1,232',
      },
    ];

    return Column(
      children: categories.map((cat) {
        return Padding(
          padding:  6.h.verticalPadding,
          child: Row(
            children: [
              // Color dot
              Container(
                width: 10.w,
                height: 10.h,
                decoration: BoxDecoration(
                  color: cat['color'] as Color,
                  shape: BoxShape.circle,
                ),
              ),
              AppSizes.s.horizontalSpace,
              // Category name
              Text(
                cat['label'] as String,
                style: context.textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w500,
                ),
              ).expanded(),
              // Percentage
              Text(
                cat['percentage'] as String,
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
                cat['amount'] as String,
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
