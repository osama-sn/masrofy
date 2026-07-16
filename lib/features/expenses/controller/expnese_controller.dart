import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:masrofy/features/expenses/models/expense_entry_model.dart';
import 'package:masrofy/features/expenses/repository/expense_repo.dart';

class ExpneseController extends AsyncNotifier<List<ExpenseEntryModel>> {
  late final ExpenseRepository _repository;
  @override
  FutureOr<List<ExpenseEntryModel>> build() {
    _repository = ref.read(expenseRepositoryProvider);
    return _getExpenses();
  }

  Future<List<ExpenseEntryModel>> _getExpenses() async {
    return _repository.getExpenseEntries();
  }

  Future<void> addExpense(ExpenseEntryModel expense) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      await _repository.addExpense(expense);
      return _getExpenses();
    });
  }

  Future<void> updateEntry(ExpenseEntryModel expense) async {
    state = const AsyncValue.loading();

    state = await AsyncValue.guard(() async {
      await _repository.updateExpense(expense);
      return _getExpenses();
    });
  }

  Future<void> deleteEntry(String id) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      await _repository.delelteExpense(id);
      return _getExpenses();
    });
  }
}

final expenseControllerProvider =
    AsyncNotifierProvider<ExpneseController, List<ExpenseEntryModel>>(
      ExpneseController.new,
    );
