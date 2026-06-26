import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class VideoQueueController extends ChangeNotifier {
  VideoPlayerController? _currentPlayer;
  List<String> _playlistUrls = [];
  int _currentIndex = 0;
  bool _isPlayingSequence = false;
  
  VoidCallback? onSequenceCompleted;

  VideoPlayerController? get currentPlayer => _currentPlayer;
  bool get isPlayingSequence => _isPlayingSequence;

  Future<void> playSequence(List<String> urls) async {
    if (urls.isEmpty) return;
    
    _playlistUrls = urls;
    _currentIndex = 0;
    _isPlayingSequence = true;
    notifyListeners();

    await _playCurrentIndex();
  }

  Future<void> _playCurrentIndex() async {
    if (_currentIndex >= _playlistUrls.length) {
      _finishSequence();
      return;
    }

    final url = _playlistUrls[_currentIndex];
    
    // Disponer el reproductor anterior si existe
    if (_currentPlayer != null) {
      final oldPlayer = _currentPlayer;
      _currentPlayer = null;
      // Esperamos un frame para evitar crashes visuales
      notifyListeners(); 
      oldPlayer?.dispose();
    }

    try {
      _currentPlayer = VideoPlayerController.networkUrl(Uri.parse(url));
      await _currentPlayer!.initialize();
      _currentPlayer!.addListener(_videoListener);
      await _currentPlayer!.play();
      notifyListeners();
    } catch (e) {
      debugPrint("Error inicializando video: $url - $e");
      // Si falla, saltamos silenciosamente al siguiente
      _currentIndex++;
      await _playCurrentIndex();
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
    notifyListeners();
    if (onSequenceCompleted != null) {
      onSequenceCompleted!();
    }
  }

  void stopAndClear() {
    _isPlayingSequence = false;
    _playlistUrls.clear();
    _currentPlayer?.removeListener(_videoListener);
    _currentPlayer?.dispose();
    _currentPlayer = null;
    notifyListeners();
  }

  @override
  void dispose() {
    _currentPlayer?.removeListener(_videoListener);
    _currentPlayer?.dispose();
    super.dispose();
  }
}
