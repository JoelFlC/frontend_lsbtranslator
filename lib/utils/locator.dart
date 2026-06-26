import 'package:get_it/get_it.dart';
import 'package:frontend_lsbtranslator/services/mock_sign_service.dart';
import 'package:frontend_lsbtranslator/services/sign_service.dart';

final locator = GetIt.instance;

void setupLocator() {
  // Cambiar aquí entre MockSignService y la implementación real
  locator.registerLazySingleton<SignService>(() => MockSignService());
}
