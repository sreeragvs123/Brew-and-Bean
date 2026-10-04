class ApiConstants {
  ApiConstants._();

  /// Set at build time:  --dart-define=API_BASE_URL=https://your-server.com
  /// The default 10.0.2.2 is how the Android emulator reaches your computer.
  static const String host =
      String.fromEnvironment('API_BASE_URL', defaultValue: 'http://10.0.2.2:8080');

  static const String baseUrl = '$host/api';
}
