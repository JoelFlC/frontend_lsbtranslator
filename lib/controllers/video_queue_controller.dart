import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:frontend_lsbtranslator/models/sign_clip.dart';

class VideoQueueController extends ChangeNotifier {
  VideoPlayerController? _currentPlayer;
  VideoPlayerController? _nextPlayer;
  
  List<SignClip> _playlistClips = [];
  int _currentIndex = 0;
  bool _isPlayingSequence = false;
  
  VoidCallback? onSequenceCompleted;

  VideoPlayerController? get currentPlayer => _currentPlayer;
  bool get isPlayingSequence => _isPlayingSequence;
  SignClip? get currentClip => (_currentIndex >= 0 && _currentIndex < _playlistClips.length) 
      ? _playlistClips[_currentIndex] 
      : null;

  Future<void> playSequence(List<SignClip> clips) async {
    if (clips.isEmpty) return;
    
    stopAndClear(); // Limpiamos cualquier estado anterior
    
    _playlistClips = clips;
    _currentIndex = 0;
    _isPlayingSequence = true;
    notifyListeners();

    // Inicializar el primer video y precargar el segundo
    await _playCurrentIndex();
  }

  Future<void> _playCurrentIndex() async {
    if (_currentIndex >= _playlistClips.length) {
      _finishSequence();
      return;
    }

    // Si ya tenemos el siguiente preparado (por el doble buffer), lo usamos
    if (_nextPlayer != null) {
      final oldPlayer = _currentPlayer;
      _currentPlayer = _nextPlayer;
      _nextPlayer = null;
      
      oldPlayer?.removeListener(_videoListener);
      oldPlayer?.dispose();
    } else {
      // Si no, inicializamos el currentPlayer manualmente (ej: al inicio de la secuencia)
      final url = _playlistClips[_currentIndex].videoUrl;
      try {
        _currentPlayer = VideoPlayerController.networkUrl(Uri.parse(url));
        await _currentPlayer!.initialize();
      } catch (e) {
        debugPrint("Error inicializando video: $url - $e");
        _currentIndex++;
        await _playCurrentIndex();
        return;
      }
    }

    _currentPlayer!.addListener(_videoListener);
    await _currentPlayer!.play();
    notifyListeners();

    // Precargar el SIGUIENTE video de forma asíncrona (no bloquea el frame actual)
    _preloadNext();
  }
  
  Future<void> _preloadNext() async {
    final nextIndex = _currentIndex + 1;
    if (nextIndex >= _playlistClips.length) return; // No hay siguiente
    
    final nextUrl = _playlistClips[nextIndex].videoUrl;
    try {
      _nextPlayer = VideoPlayerController.networkUrl(Uri.parse(nextUrl));
      await _nextPlayer!.initialize();
      // No le damos play, solo queda listo en memoria
    } catch (e) {
      debugPrint("Error precargando siguiente video: $nextUrl - $e");
      _nextPlayer = null;
    }
  }

  void _videoListener() {
    if (_currentPlayer == null) return;
    
    // Chequear si el video actual terminó
    if (_currentPlayer!.value.position >= _currentPlayer!.value.duration &&
        _currentPlayer!.value.duration != Duration.zero) {
      _currentPlayer!.removeListener(_videoListener);
      _currentIndex++;
      _playCurrentIndex();
    }
  }

  void _finishSequence() {
    _isPlayingSequence = false;
    _currentPlayer?.dispose();
    _currentPlayer = null;
    _nextPlayer?.dispose();
    _nextPlayer = null;
    notifyListeners();
    
    if (onSequenceCompleted != null) {
      onSequenceCompleted!();
    }
  }

  void stopAndClear() {
    _isPlayingSequence = false;
    _playlistClips.clear();
    
    _currentPlayer?.removeListener(_videoListener);
    _currentPlayer?.dispose();
    _currentPlayer = null;
    
    _nextPlayer?.dispose();
    _nextPlayer = null;
    
    notifyListeners();
  }

  @override
  void dispose() {
    _currentPlayer?.removeListener(_videoListener);
    _currentPlayer?.dispose();
    _nextPlayer?.dispose();
    super.dispose();
  }
}
