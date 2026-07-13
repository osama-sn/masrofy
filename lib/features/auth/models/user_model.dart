import 'package:firebase_auth/firebase_auth.dart';

class UserModel {
  final String uid;
  final String name;
  final String email;
  final String photoURL;

  UserModel({
    required this.uid,
    required this.name,
    required this.email,
    required this.photoURL,
  });
  // fromMap
  /// transform data from json api => dart obj => user model
  factory UserModel.fromFirestore(User user) {
    return UserModel(
      uid: user.uid,
      name: user.displayName ?? "",
      email: user.email ?? "",
      photoURL: user.photoURL ?? "",
    );
  }

  //to map
  // from Dart obj = usermodel => json api firbase can read it
  Map<String, dynamic> toMap() {
    return {'uid': uid, 'name': name, "email": email, "photoURL": photoURL};
  }
}
