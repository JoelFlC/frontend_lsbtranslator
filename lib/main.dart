import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:frontend_lsbtranslator/utils/locator.dart';
import 'package:frontend_lsbtranslator/controllers/app_state_controller.dart';
import 'package:frontend_lsbtranslator/controllers/video_queue_controller.dart';
import 'package:frontend_lsbtranslator/controllers/theme_controller.dart';
import 'package:frontend_lsbtranslator/ui/screens/home_screen.dart';
import 'package:frontend_lsbtranslator/ui/theme/app_theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Inicialización de Firebase (el bloque try-catch permite correr la UI si faltan las credenciales al inicio)
  try {
    await Firebase.initializeApp();
  } catch (e) {
    debugPrint("Advertencia: Firebase no se inicializó correctamente (¿faltan credenciales?). Error: $e");
  }

  // Inicialización de Inyección de Dependencias
  setupLocator();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AppStateController()),
        ChangeNotifierProvider(create: (_) => VideoQueueController()),
        ChangeNotifierProvider(create: (_) => ThemeController()),
      ],
      child: const LsbTranslatorApp(),
    ),
  );
}

class LsbTranslatorApp extends StatelessWidget {
  const LsbTranslatorApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeController>(
      builder: (context, themeController, child) {
        return MaterialApp(
          title: 'BankConnect LSB',
          debugShowCheckedModeBanner: false,
          theme: AppTheme.lightTheme,
          darkTheme: AppTheme.darkTheme,
          themeMode: themeController.themeMode,
          home: const HomeScreen(),
        );
      },
    );
  }
}
