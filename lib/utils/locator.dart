import 'package:get_it/get_it.dart';
import 'package:frontend_lsbtranslator/services/sign_service.dart';

final locator = GetIt.instance;

void setupLocator() {
  // Utilizamos la implementación real del servicio (Fase 3 y 4 completadas)
  locator.registerLazySingleton<SignService>(() => SignService());
}
