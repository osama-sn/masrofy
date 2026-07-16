import 'package:flutter/material.dart';
import 'package:masrofy/core/themes/app_colors.dart';

class IncomeCategory {
  final String key;
  final String label;
  final IconData icon;
  final Color color;

  const IncomeCategory({
    required this.key,
    required this.label,
    required this.icon,
    required this.color,
  });
}
class IncomeCategories {
  static const salary = IncomeCategory(
    key: 'salary',
    label: 'راتب',
    icon: Icons.business_center_rounded,
    color: AppColors.primary,
  );

  static const freelance = IncomeCategory(
    key: 'freelance',
    label: 'عمل حر',
    icon: Icons.laptop_mac_rounded,
    color: AppColors.purple,
  );

  static const investment = IncomeCategory(
    key: 'investment',
    label: 'استثمار',
    icon: Icons.trending_up_rounded,
    color: AppColors.cyan,
  );

  static const bonus = IncomeCategory(
    key: 'bonus',
    label: 'مكافأة',
    icon: Icons.card_giftcard_rounded,
    color: AppColors.accent,
  );

  static const other = IncomeCategory(
    key: 'other',
    label: 'أخرى',
    icon: Icons.more_horiz_rounded,
    color: AppColors.success,
  );

  static const values = [
    salary,
    freelance,
    investment,
    bonus,
    other,
  ];
}