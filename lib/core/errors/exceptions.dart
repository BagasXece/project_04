class ServerException implements Exception {
  final String message;
  ServerException([this.message = 'Terjadi kesalahan server']);

  @override
  String toString() => 'ServerException: $message';
}