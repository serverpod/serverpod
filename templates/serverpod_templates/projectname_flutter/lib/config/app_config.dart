import 'dart:convert';

import 'package:flutter/services.dart';

/// Gets the Server URL from the current environment.
Future<String> getServerUrl() async {
  final config = await AppConfig.loadConfig();
  return config.apiUrl;
}

/// AppConfig loads the API server URL from the current environment.
///
/// If the SERVER_URL environment variable is set, it will be used as the API
/// server URL. Otherwise, it will be loaded from the assets/config.json file.
///
/// When the app is hosted on the server, the config.json file is fetched from
/// the server, allowing the server to change the API URL at runtime. This
/// ensures the app always uses the correct API URL, no matter which environment
/// it is running in.
class AppConfig {
  /// The API server URL to use when instantiating the client.
  final String apiUrl;

  /// Creates a new [AppConfig] instance.
  AppConfig({
    required this.apiUrl,
  });

  /// Loads the API server URL from the environment or assets/config.json file.
  static Future<AppConfig> loadConfig() async {
    const serverUrlFromEnv = String.fromEnvironment('SERVER_URL');
    if (serverUrlFromEnv.isNotEmpty) {
      return AppConfig(apiUrl: serverUrlFromEnv);
    }

    final config = await _loadJsonConfig();
    final apiUrl = config['apiUrl'] ?? 'http://$localhost:8080/';
    return AppConfig(apiUrl: apiUrl);
  }

  static Future<Map<String, dynamic>> _loadJsonConfig() async {
    final data = await rootBundle.loadString(
      'assets/config.json',
    );

    return jsonDecode(data);
  }
}
