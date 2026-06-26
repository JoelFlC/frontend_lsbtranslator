import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:frontend_lsbtranslator/utils/locator.dart';
import 'package:frontend_lsbtranslator/controllers/app_state_controller.dart';
import 'package:frontend_lsbtranslator/controllers/video_queue_controller.dart';
import 'package:frontend_lsbtranslator/ui/screens/home_screen.dart';

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
      ],
      child: const LsbTranslatorApp(),
    ),
  );
}

class LsbTranslatorApp extends StatelessWidget {
  const LsbTranslatorApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'LSB Traductor - Demo',
      debugShowCheckedModeBanner: false, // Ocultar banner de debug para la demo
      theme: ThemeData(
        brightness: Brightness.dark,
        primaryColor: Colors.blueAccent,
        scaffoldBackgroundColor: const Color(0xFF121212),
        colorScheme: const ColorScheme.dark(
          primary: Colors.blueAccent,
          secondary: Colors.tealAccent,
          surface: Color(0xFF1E1E1E),
        ),
        useMaterial3: true,
      ),
      home: const HomeScreen(),
    );
  }
}
