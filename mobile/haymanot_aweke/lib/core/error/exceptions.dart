class ServerException implements Exception {
  final String message;
  ServerException(this.message);

  @override
  String toString() => 'ServerException: $message';
}

class CacheException implements Exception {}

class NetworkException implements Exception {
  final String message;
  NetworkException([this.message = 'No network connection detected.']);
}
