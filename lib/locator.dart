import 'package:flutter_chat_app/repository/user_repository.dart';
import 'package:flutter_chat_app/services/authentication/fake_auth.dart';
import 'package:flutter_chat_app/services/authentication/firebase_auth.dart';
import 'package:flutter_chat_app/services/database/firestore_db.dart';
import 'package:get_it/get_it.dart';

late GetIt locator = GetIt.asNewInstance();

void setupLocator() {
  locator.registerLazySingleton(() => UserRepository());
  locator.registerLazySingleton(() => FirebaseAuthService());
  locator.registerLazySingleton(() => FakeAuthenticationService());
  locator.registerLazySingleton(() => FirestoreDBService());
}
