import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:frontend_lsbtranslator/controllers/app_state_controller.dart';
import 'package:frontend_lsbtranslator/controllers/video_queue_controller.dart';
import 'package:frontend_lsbtranslator/ui/widgets/video_player_zone.dart';
import 'package:frontend_lsbtranslator/ui/widgets/subtitle_zone.dart';
import 'package:frontend_lsbtranslator/ui/widgets/controls_zone.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    // Configurar callback cuando la secuencia de video termine
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<VideoQueueController>().onSequenceCompleted = () {
        context.read<AppStateController>().setIdle();
      };
    });
  }

  void _handleProcessText(String text) async {
    final appState = context.read<AppStateController>();
    final videoQueue = context.read<VideoQueueController>();

    await appState.processText(text);

    if (appState.currentVideoUrls.isNotEmpty) {
      await videoQueue.playSequence(appState.currentVideoUrls);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      // SafeArea para dispositivos móviles
      body: SafeArea(
        child: Column(
          children: [
            // Zona del Avatar (Video Player)
            const Expanded(
              flex: 5,
              child: VideoPlayerZone(),
            ),
            
            // Zona de Subtítulos
            const SubtitleZone(),
            
            // Zona de Controles
            ControlsZone(
              onSubmitText: _handleProcessText,
            ),
          ],
        ),
      ),
      // Drawer oculto para contingencia ("Botones Rápidos")
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.blueAccent,
              ),
              child: Text(
                'Demo Safety - Contingencia',
                style: TextStyle(color: Colors.white, fontSize: 20),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.flash_on),
              title: const Text('Saludo Inicial'),
              onTap: () {
                Navigator.pop(context); // Cerrar drawer
                _handleProcessText("Hola, ¿cómo estás?");
              },
            ),
            ListTile(
              leading: const Icon(Icons.flash_on),
              title: const Text('Atención Ciudadana'),
              onTap: () {
                Navigator.pop(context);
                _handleProcessText("Bienvenido a la biblioteca municipal");
              },
            ),
            ListTile(
              leading: const Icon(Icons.flash_on),
              title: const Text('Despedida'),
              onTap: () {
                Navigator.pop(context);
                _handleProcessText("Gracias por su visita");
              },
            ),
          ],
        ),
      ),
      // Botón flotante muy discreto para abrir el drawer de contingencia (o deslizando)
      floatingActionButton: FloatingActionButton(
        mini: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        onPressed: () => _scaffoldKey.currentState?.openDrawer(),
        child: const Icon(Icons.settings_applications, color: Colors.white24),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.startTop,
    );
  }
}
