import 'package:flutter/material.dart';
import 'package:masrofy/core/themes/app_colors.dart';

class ExpenseCategory {
  final String id;
  final String nameAr;
  final IconData icon;
  final Color color;

  const ExpenseCategory({
    required this.id,
    required this.nameAr,
    required this.icon,
    required this.color,
  });


  static const List<ExpenseCategory> categories = [
    ExpenseCategory(
      id: 'food',
      nameAr: 'طعام وشراب',
      icon: Icons.fastfood_rounded,
      color: AppColors.success,
    ),
    ExpenseCategory(
      id: 'shopping',
      nameAr: 'تسوق',
      icon: Icons.shopping_bag_rounded,
      color: AppColors.orange,
    ),
    ExpenseCategory(
      id: 'transport',
      nameAr: 'مواصلات',
      icon: Icons.directions_car_rounded,
      color: AppColors.blue,
    ),
    ExpenseCategory(
      id: 'bills',
      nameAr: 'فواتير وتثبيتات',
      icon: Icons.receipt_rounded,
      color: AppColors.error,
    ),
    ExpenseCategory(
      id: 'entertainment',
      nameAr: 'ترفيه وخروجات',
      icon: Icons.sports_esports_rounded,
      color: AppColors.purple,
    ),
    ExpenseCategory(
      id: 'health',
      nameAr: 'صحة وعلاج',
      icon: Icons.local_hospital_rounded,
      color: AppColors.cyan,
    ),
    ExpenseCategory(
      id: 'other',
      nameAr: 'أخرى',
      icon: Icons.more_horiz_rounded,
      color: AppColors.grey500,
    ),
  ];

  static ExpenseCategory getById(String id) {
    return categories.firstWhere(
      (cat) => cat.id == id,
      orElse: () => categories.last, // Fallback to 'other'
    );
  }
}
