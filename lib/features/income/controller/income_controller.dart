import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:masrofy/features/income/data/income_entry_model.dart';
import 'package:masrofy/features/income/repository/income_repository.dart';

final incomeControllerProvider =
    AsyncNotifierProvider<IncomeController, List<IncomeEntryModel>>(
      IncomeController.new,
    );

class IncomeController extends AsyncNotifier<List<IncomeEntryModel>> {
  @override
  Future<List<IncomeEntryModel>> build() async {
    return _getEntries();
  }

  Future<List<IncomeEntryModel>> _getEntries() {
    return ref.read(incomeRepositoryProvider).getIncomeEntries();
  }

  Future<void> addEntry(IncomeEntryModel entry) async {
    state = const AsyncValue.loading();

    state = await AsyncValue.guard(() async {
      await ref.read(incomeRepositoryProvider).addIncomeEntry(entry);

      return _getEntries();
    });
  }

  Future<void> updateEntry(IncomeEntryModel entry) async {
    state = const AsyncValue.loading();

    state = await AsyncValue.guard(() async {
      await ref.read(incomeRepositoryProvider).updateIncomeEntry(entry);

      return _getEntries();
    });
  }

  Future<void> deleteEntry(String id) async {
    state = const AsyncValue.loading();

    state = await AsyncValue.guard(() async {
      await ref.read(incomeRepositoryProvider).deleteIncomeEntry(id);

      return _getEntries();
    });
  }
}
