import 'dart:convert';

import 'package:flutter/services.dart';

class AppConfig {
  final String? apiUrl;

  AppConfig({
    required this.apiUrl,
  });

  static Future<AppConfig> loadConfig() async {
    final config = await _loadJsonConfig();
    final String? apiUrl = config['apiUrl'];

    return AppConfig(apiUrl: apiUrl);
  }

  static Future<Map<String, dynamic>> _loadJsonConfig() async {
    final data = await rootBundle.loadString(
      'assets/config.json',
    );

    return jsonDecode(data);
  }
}
