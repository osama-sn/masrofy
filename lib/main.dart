import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:masrofy/app.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:masrofy/firebase_options.dart';
import 'package:google_sign_in/google_sign_in.dart';

const _googleServerClientId =
    '112425784821-ofr24pmras0mqd9loqi6kehh8q4camr6.apps.googleusercontent.com';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await GoogleSignIn.instance.initialize(serverClientId: _googleServerClientId);
  runApp(ProviderScope(child: MyApp()));
}
