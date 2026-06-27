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

    return SignClip(
      conceptId: json['id'] as String? ?? 'sin_id',
      videoUrl: parsedVideoUrl,
      textEquivalent: json['textEquivalent'] as String?,
    );
  }
}
