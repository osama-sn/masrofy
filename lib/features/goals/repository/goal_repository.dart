import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:masrofy/core/service/firabase_service.dart';
import 'package:masrofy/features/goals/models/goal_modal.dart';

class GoalRepository {
  // firestore
  // firebaseauth => user id
  final FirebaseFirestore _firestore;
  final FirebaseAuth _auth;

  GoalRepository({
    required FirebaseFirestore firestore,
    required FirebaseAuth auth,
  }) : _firestore = firestore,
       _auth = auth;

  CollectionReference<Map<String, dynamic>> get _goalsCollection {
    final uid = _auth.currentUser!.uid;
    return _firestore.collection("users").doc(uid).collection("goals");
  }

  // add goal
  Future<void> addGoal(GoalModal goal) async {
    await _goalsCollection.add(goal.toMap());
  }

  // update
  Future<void> updateGoal(GoalModal goal) async {
    await _goalsCollection.doc(goal.id).update(goal.toMap());
  }

  // delete
  Future<void> deleteGoal(String goalId) async {
    await _goalsCollection.doc(goalId).delete();
  }

  Future<List<GoalModal>> getGoals() async {
    final snapshot = await _goalsCollection.get();
    return snapshot.docs
        .map((doc) => GoalModal.fromMap(doc.id, doc.data()))
        .toList();
  }
}

final goalRepositoryProvider = Provider<GoalRepository>(
  (ref) => GoalRepository(
    auth: ref.watch(firebaseAuthProvider),
    firestore: ref.watch(firestoreProvider),
  ),
);
