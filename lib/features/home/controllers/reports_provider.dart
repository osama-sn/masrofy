import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:masrofy/features/expenses/controller/expnese_controller.dart';
import 'package:masrofy/features/expenses/models/expense_entry_model.dart';
import 'package:masrofy/features/expenses/models/expnese_category.dart';
import 'package:masrofy/features/home/models/category_report_model.dart';
import 'package:masrofy/features/home/models/report_data_items.dart';
import 'package:masrofy/features/income/controller/income_controller.dart';
import 'package:masrofy/features/income/data/income_entry_model.dart';

enum ReportsFilter { thisMonth, lastMonth, thisYear, all }

class ReportsFilterNotifier extends Notifier<ReportsFilter> {
  @override
  ReportsFilter build() {
    return ReportsFilter.thisMonth;
  }

  void setFilter(ReportsFilter filter) {
    state = filter;
  }
}

final reportsFilterProvider =
    NotifierProvider<ReportsFilterNotifier, ReportsFilter>(
      ReportsFilterNotifier.new,
    );

class ReportsNotifier extends AsyncNotifier<ReportData> {
  @override
  FutureOr<ReportData> build() async {
    final filter = ref.watch(reportsFilterProvider);
    final incomeData = await ref.watch(incomeControllerProvider.future);
    final expenseData = await ref.watch(expenseControllerProvider.future);

    final now = DateTime.now();
    final int currentMonth = now.month;
    final int currentYear = now.year;
    // last month and year
    final prevData = DateTime(now.year, now.month - 1);
    final int prevMonth = prevData.month;
    final int prevYear = prevData.year;
    // last prev month and year
    final prevPrevData = DateTime(now.year, now.month - 2);
    final int prevPrevMonth = prevData.month;
    final int prevPrevYear = prevData.year;

    List<IncomeEntryModel> currentIncome = [];
    List<IncomeEntryModel> prevIncome = [];
    List<ExpenseEntryModel> currentExpenses = [];
    List<ExpenseEntryModel> prevExpenses = [];

    switch (filter) {
      case ReportsFilter.thisMonth:
        currentIncome = incomeData
            .where((e) => e.month == currentMonth && e.year == currentYear)
            .toList();
        prevIncome = incomeData
            .where((e) => e.month == prevMonth && e.year == prevYear)
            .toList();
        currentExpenses = expenseData
            .where((e) => e.month == currentMonth && e.year == currentYear)
            .toList();
        prevExpenses = expenseData
            .where((e) => e.month == prevMonth && e.year == prevYear)
            .toList();
        break;
      case ReportsFilter.lastMonth:
        currentIncome = incomeData
            .where((e) => e.month == prevMonth && e.year == prevYear)
            .toList();
        prevIncome = incomeData
            .where((e) => e.month == prevPrevMonth && e.year == prevPrevYear)
            .toList();
        currentExpenses = expenseData
            .where((e) => e.month == prevMonth && e.year == prevYear)
            .toList();
        prevExpenses = expenseData
            .where((e) => e.month == prevPrevMonth && e.year == prevPrevYear)
            .toList();
        break;
      case ReportsFilter.thisYear:
        currentIncome = incomeData.where((e) => e.year == currentYear).toList();
        prevIncome = incomeData
            .where((e) => e.year == currentYear - 1)
            .toList();
        currentExpenses = expenseData
            .where((e) => e.year == currentYear)
            .toList();
        prevExpenses = expenseData
            .where((e) => e.year == currentYear - 1)
            .toList();
        break;
      case ReportsFilter.all:
        currentIncome = incomeData;
        currentExpenses = expenseData;
        break;
    }
    final totalIncome = currentIncome.fold<double>(
      0.0,
      (sum, e) => sum + e.amount,
    );
    final totalExpense = currentExpenses.fold<double>(
      0.0,
      (sum, e) => sum + e.amount,
    );
    final netIncome = totalIncome - totalExpense;
    final savingsRate = totalIncome > 0 ? (netIncome / totalIncome) * 100 : 0.0;
    double? incomeChange;
    double? expenseChange;
    if (filter != ReportsFilter.all) {
      final prevIncomeSum = prevIncome.fold<double>(
        0.0,
        (sum, e) => sum + e.amount,
      );
      final prevExpenseSum = prevExpenses.fold<double>(
        0.0,
        (sum, e) => sum + e.amount,
      );
      if (prevIncomeSum > 0) {
        incomeChange = ((totalIncome - prevIncomeSum) / prevIncomeSum * 100);
      }
      if (prevExpenseSum > 0) {
        expenseChange =
            ((totalExpense - prevExpenseSum) / prevExpenseSum) * 100;
      }
    }

    final Map<String, dynamic> categorySums = {};
    for (var entry in currentExpenses) {
      categorySums[entry.category] =
          (categorySums[entry.category] ?? 0.0) + entry.amount;
    }
    final categoryItems = categorySums.entries.map((entry) {
      final category = ExpenseCategory.getById(entry.key);
      return CategoryReportModel(
        categoryId: entry.key,
        label: category.nameAr,
        amount: entry.value,
        percentage: totalExpense > 0 ? entry.value / totalExpense : 0.0,
        color: category.color,
      );
    }).toList()..sort((a, b) => b.amount.compareTo(a.amount));

    return ReportData(
      totalIncome: totalIncome,
      totalExpense: totalExpense,
      netIncome: netIncome,
      savingsRate: savingsRate,
      categoryItems: categoryItems,
    );
  }
}

final reportsDataProvider = AsyncNotifierProvider<ReportsNotifier, ReportData>(
  ReportsNotifier.new,
);
