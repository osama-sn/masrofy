import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:masrofy/core/extensions/build_context.dart';
import 'package:masrofy/core/extensions/num_extension.dart';
import 'package:masrofy/core/themes/app_colors.dart';
import 'package:masrofy/core/themes/app_sizes.dart';
import 'package:masrofy/features/income/data/income_entry_model.dart';

class IncomeEntryCard extends StatelessWidget {
  const IncomeEntryCard({super.key, required this.entry, required this.onTap});

  final IncomeEntryModel entry;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDarkMode;
    final catInfo = _categoryInfo(entry.category);

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
        child: Row(
          textDirection: TextDirection.rtl,
          children: [
            // Category icon
            Container(
              width: 44.w,
              height: 44.h,
              decoration: BoxDecoration(
                color: catInfo.color.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(AppSizes.rM),
              ),
              child: Icon(
                catInfo.icon,
                color: catInfo.color,
                size: AppSizes.iconM,
              ),
            ),
            AppSizes.m.horizontalSpace,

            // Title & description
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    entry.title,
                    style: context.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  if (entry.description.isNotEmpty) ...[
                    AppSizes.xs.verticalSpace,
                    Text(
                      entry.description,
                      style: context.textTheme.bodySmall?.copyWith(
                        color: isDark
                            ? AppColors.textSecondaryDark
                            : AppColors.textSecondaryLight,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ],
              ),
            ),
            AppSizes.m.horizontalSpace,

            // Amount
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${_formatAmount(entry.amount)} EGP',
                  style: context.textTheme.titleMedium?.copyWith(
                    color: AppColors.income,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                AppSizes.xs.verticalSpace,
                Text(
                  catInfo.label,
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
      ),
    );
  }

  static _CategoryInfo _categoryInfo(String category) {
    switch (category) {
      case 'salary':
        return _CategoryInfo(
          icon: Icons.business_center_rounded,
          color: AppColors.primary,
          label: 'راتب',
        );
      case 'freelance':
        return _CategoryInfo(
          icon: Icons.laptop_mac_rounded,
          color: AppColors.purple,
          label: 'عمل حر',
        );
      case 'investment':
        return _CategoryInfo(
          icon: Icons.trending_up_rounded,
          color: AppColors.cyan,
          label: 'استثمار',
        );
      case 'bonus':
        return _CategoryInfo(
          icon: Icons.card_giftcard_rounded,
          color: AppColors.accent,
          label: 'مكافأة',
        );
      default:
        return _CategoryInfo(
          icon: Icons.more_horiz_rounded,
          color: AppColors.success,
          label: 'أخرى',
        );
    }
  }
}

class _CategoryInfo {
  final IconData icon;
  final Color color;
  final String label;

  const _CategoryInfo({
    required this.icon,
    required this.color,
    required this.label,
  });
}

String _formatAmount(double value) {
  final fixed = value % 1 == 0
      ? value.toStringAsFixed(0)
      : value.toStringAsFixed(2);
  return fixed.replaceAllMapped(
    RegExp(r'\B(?=(\d{3})+(?!\d))'),
    (match) => ',',
  );
}
