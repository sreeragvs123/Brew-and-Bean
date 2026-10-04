class ApiConstants {
  ApiConstants._();
 
  static const String host =
      String.fromEnvironment('API_BASE_URL', defaultValue: 'http://192.168.220.42:8080');

  static const String baseUrl = '$host/api';
}
