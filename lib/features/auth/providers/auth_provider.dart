import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:masrofy/features/auth/repository/auth_repository.dart';

class AuthController extends AsyncNotifier<void> {
  late final AuthRepository _authRepository;
  @override
  FutureOr<void> build() {
    _authRepository = ref.watch(authRepoProvider);
  }

  Future<bool> signInWithGoogle() async {
    state = const AsyncValue.loading();
    final result = await AsyncValue.guard(
      () => _authRepository.signInWithGoogle(),
    );
    if (result.hasError) {
      state = AsyncValue.error(result.error!, result.stackTrace!);
      return false;
    }
    state = AsyncValue.data(null);
    return result.value != null;
  }

  Future<void> signOut() async {
    state = const AsyncValue.loading();
    final result = await AsyncValue.guard(() => _authRepository.signOut());
    if (result.hasError) {
      state = AsyncValue.error(result.error!, result.stackTrace!);
    } else {
      state = AsyncValue.data(null);
    }
  }
}





final authControllerProvider = AsyncNotifierProvider<AuthController,void>(AuthController.new);





































// import 'dart:async';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:masrofy/features/auth/repository/auth_repository.dart';



// final authViewModelProvider = AsyncNotifierProvider<AuthViewModel, void>(
//   AuthViewModel.new,
// );

// class AuthViewModel extends AsyncNotifier<void> {
//   late final AuthRepository _repository;

//   @override
//   FutureOr<void> build() {
//     _repository = ref.watch(authRepositoryProvider);
//   }

//   Future<bool> signInWithGoogle() async {
//     state = const AsyncValue.loading();
//     final result = await AsyncValue.guard(() => _repository.signInWithGoogle());

//     if (result.hasError) {
//       state = AsyncValue.error(result.error!, result.stackTrace!);
//       return false;
//     }

//     state = const AsyncValue.data(null);
//     return result.value != null;
//   }

//   Future<void> signOut() async {
//     state = const AsyncValue.loading();
//     final result = await AsyncValue.guard(() => _repository.signOut());

//     if (result.hasError) {
//       state = AsyncValue.error(result.error!, result.stackTrace!);
//     } else {
//       state = const AsyncValue.data(null);
//     }
//   }
// }
