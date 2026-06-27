class SignClip {
  final String conceptId;
  final String videoUrl;
  final String textEquivalent;

  SignClip({
    required this.conceptId,
    required this.videoUrl,
    required this.textEquivalent,
  });

  @override
  String toString() => 'SignClip(conceptId: $conceptId, textEquivalent: $textEquivalent)';
}
