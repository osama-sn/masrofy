import 'package:masrofy/features/home/models/category_report_model.dart';

class ReportData {
  final double totalIncome;
  final double totalExpense;
  final double netIncome;
  final double savingsRate;
  final double? incomeChange;
  final double? expenseChange;
  final List<CategoryReportModel> categoryItems;

  ReportData({
    required this.totalIncome,
    required this.totalExpense,
    required this.netIncome,
    required this.savingsRate,
    this.incomeChange,
    this.expenseChange,
    required this.categoryItems,
  });
}
