import 'package:flutter_chat_app/repository/repository.dart';
import 'package:flutter_chat_app/services/authentication/fake_auth.dart';
import 'package:flutter_chat_app/services/authentication/firebase_auth.dart';
import 'package:flutter_chat_app/services/database/firestore_db.dart';
import 'package:flutter_chat_app/services/storage/firebase_storage.dart';
import 'package:get_it/get_it.dart';

late GetIt locator = GetIt.asNewInstance();

void setupLocator() {
  locator.registerLazySingleton(() => Repository());
  locator.registerLazySingleton(() => FirebaseAuthService());
  locator.registerLazySingleton(() => FakeAuthenticationService());
  locator.registerLazySingleton(() => FirestoreDBService());
  locator.registerLazySingleton(() => FirebaseStorageService());
}
