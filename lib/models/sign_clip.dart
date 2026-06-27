class SignClip {
  final String conceptId;
  final String videoUrl;
  final String? textEquivalent;

  SignClip({
    required this.conceptId,
    required this.videoUrl,
    this.textEquivalent,
  });

  @override
  String toString() =>
      'SignClip(conceptId: $conceptId, textEquivalent: $textEquivalent)';
  factory SignClip.fromJson(Map<String, dynamic> json) {
    String parsedVideoUrl =
        json['video_url'] as String? ?? json['videoUrl'] as String? ?? '';
        
    // Interceptar el fallback temporal del backend
    if (parsedVideoUrl.contains('ejemplo.com/fallback.mp4')) {
      parsedVideoUrl = 'https://res.cloudinary.com/djtvg1k6l/video/upload/v1782538519/Venir_a_la_ventanilla_azagvn.mp4';
    }

    return SignClip(
      conceptId: json['id'] as String? ?? 'sin_id',
      videoUrl: parsedVideoUrl,
      textEquivalent: json['textEquivalent'] as String?,
    );
  }
}
