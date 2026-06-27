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
    return SignClip(
      conceptId: json['id'] as String? ?? 'sin_id',
      videoUrl:
          json['video_url'] as String? ?? json['videoUrl'] as String? ?? '',
      textEquivalent: json['textEquivalent'] as String?,
    );
  }
}
