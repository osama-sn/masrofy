import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:masrofy/features/goals/models/goal_modal.dart';
import 'package:masrofy/features/goals/repository/goal_repository.dart';

class GoalsController extends AsyncNotifier<List<GoalModal>> {
  late final GoalRepository goalsRepo;
  @override
  FutureOr<List<GoalModal>> build() {
    goalsRepo = ref.read(goalRepositoryProvider);
    return _getGoals();
  }

  Future<List<GoalModal>> _getGoals() {
    return goalsRepo.getGoals();
  }

  Future<void> addGoal(GoalModal goal) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      await goalsRepo.addGoal(goal);
      return _getGoals();
    });
  }

  Future<void> deleteGoal(String id) async {
    state = const AsyncValue.loading();

    state = await AsyncValue.guard(() async {
      await goalsRepo.deleteGoal(id);

      return _getGoals();
    });
  }

  Future<void> updateGoal(GoalModal goal) async {
    state = const AsyncValue.loading();

    state = await AsyncValue.guard(() async {
      await goalsRepo.updateGoal(goal);

      return _getGoals();
    });
  }
}

final goalsConrollerProvider =
    AsyncNotifierProvider<GoalsController, List<GoalModal>>(
      GoalsController.new,
    );
