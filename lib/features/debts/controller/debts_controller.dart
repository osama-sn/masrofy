import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:masrofy/features/debts/models/debts_model.dart';
import 'package:masrofy/features/debts/repository/debts_repository.dart';

final debtsControllerProvider =
    AsyncNotifierProvider<DebtsController, List<DebtModel>>(
      DebtsController.new,
    );

class DebtsController extends AsyncNotifier<List<DebtModel>> {
  late final DebtsRepository _debtsRepository;
  @override
  Future<List<DebtModel>> build() async {
    _debtsRepository = ref.read(debtsRepositoryProvider);
    return _getDebts();
  }

  Future<List<DebtModel>> _getDebts() {
    return _debtsRepository.getDebts();
  }

  Future<void> refreshDebts() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      return _getDebts();
    });
  }

  Future<void> addDebt(DebtModel debt) async {
    state = const AsyncValue.loading();

    state = await AsyncValue.guard(() async {
      await _debtsRepository.addDebt(debt);

      return _getDebts();
    });
  }

  Future<void> deleteDebt(String id) async {
    state = const AsyncValue.loading();

    state = await AsyncValue.guard(() async {
      await _debtsRepository.deleteDebt(id);

      return _getDebts();
    });
  }

  Future<void> updateDebt(DebtModel debt) async {
    state = const AsyncValue.loading();

    state = await AsyncValue.guard(() async {
      await _debtsRepository.updateDebt(debt);

      return _getDebts();
    });
  }
}

