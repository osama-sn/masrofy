import 'package:flutter/material.dart';

class CategoryReportModel {
  final String categoryId;
  final String label;
  final double amount;
  final double percentage; // 0.0 to 1.0
  final Color color;

  CategoryReportModel({
    required this.categoryId,
    required this.label,
    required this.amount,
    required this.percentage,
    required this.color,
  });
}
