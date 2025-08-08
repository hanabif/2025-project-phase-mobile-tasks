import 'dart:convert';

class TokenStorage {
  static final TokenStorage _instance = TokenStorage._internal();
  String? _token;

  factory TokenStorage() => _instance;

  TokenStorage._internal();

  void saveToken(String token) {
    _token = token;
    print('Token saved ✅: $token');
  }

  String? get token => _token;

  /// ✅ Extracts the userId from token payload
  String? get userId {
    if (_token == null) return null;
    final parts = _token!.split('.');
    if (parts.length != 3) return null;

    try {
      final payload = base64Url.normalize(parts[1]);
      final decoded = json.decode(utf8.decode(base64Url.decode(payload)));
      return decoded['id'] ?? decoded['userId']; // based on your backend
    } catch (e) {
      print('Error decoding token: $e');
      return null;
    }
  }
}
