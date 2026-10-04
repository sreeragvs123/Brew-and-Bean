/// Thrown by the data layer when the server answers with an error.
class ServerException implements Exception {
  final String message;
  const ServerException(this.message);
}
