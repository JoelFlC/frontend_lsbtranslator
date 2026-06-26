abstract class SignService {
  /// Traduce texto en español a una lista de URLs de videos en LSB.
  Future<List<String>> translateTextToLsbUrls(String text);
}
