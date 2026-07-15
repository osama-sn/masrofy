
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:masrofy/core/extensions/build_context.dart';
import 'package:masrofy/core/extensions/num_extension.dart';
import 'package:masrofy/core/themes/app_colors.dart';
import 'package:masrofy/core/themes/app_sizes.dart';
import 'package:masrofy/features/debts/models/debts_model.dart';

class DebtCard extends StatelessWidget {
  const DebtCard({
    super.key,
    required this.debt,
    required this.onTap,
  });

  final DebtModel debt;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDarkMode;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppSizes.rL),
      child: Container(
        padding: 16.allPadding,
        decoration: BoxDecoration(
          color: isDark ? AppColors.cardDark : Colors.white,
          borderRadius: BorderRadius.circular(AppSizes.rL),
          border: Border.all(
            color: isDark ? AppColors.borderDark : AppColors.borderLight,
          ),
        ),
        child: Column(
          children: [
            // Top Row: title & remaining
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Title & Creditor (Right)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(debt.title, style: context.textTheme.titleMedium),
                    4.verticalSpace,
                    Text(
                      debt.creditor,
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
                      '${debt.remainingAmount.toStringAsFixed(0)} EGP',
                      style: context.textTheme.titleMedium,
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
            // Bottom Row: progress & total
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Progress Bar & Percentage
                Expanded(
                  child: Row(
                    children: [
                      Text(
                        '${debt.percentage}%',
                        style: context.textTheme.labelSmall,
                      ),
                      8.horizontalSpace,
                      Expanded(
                        child: ClipRRect(
                          borderRadius: 10.r.radius,
                          child: LinearProgressIndicator(
                            value: debt.progress,
                            minHeight: 6.h,
                            backgroundColor: isDark
                                ? AppColors.borderDark
                                : AppColors.grey100,
                            valueColor: AlwaysStoppedAnimation<Color>(
                              AppColors.debt,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                24.horizontalSpace,
                // Total Amount
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${debt.totalAmount.toStringAsFixed(0)} EGP',
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
      ),
    );
  }
}
