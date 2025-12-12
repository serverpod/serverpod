import 'dart:convert';

import 'package:flutter/services.dart';

class AppConfig {
  final String? apiUrl;

  AppConfig({
    required this.apiUrl,
  });

  static Future<AppConfig> loadConfig() async {
    final config = await _loadJsonConfig();

    return AppConfig(apiUrl: config.get<String>('apiUrl'));
  }

  static Future<Map<String, dynamic>> _loadJsonConfig() async {
    final data = await rootBundle.loadString(
      'assets/config.json',
    );

    return jsonDecode(data);
  }
}

extension on Map<String, dynamic> {
  T? get<T>(String key) {
    final value = this[key];
    return value as T?;
  }
}
