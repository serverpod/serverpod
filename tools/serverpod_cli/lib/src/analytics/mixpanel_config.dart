import 'dart:io';

/// MixPanel configuration for CLI analytics.
///
/// API token should be provided via environment variable:
/// - MIXPANEL_TOKEN: MixPanel project token
class MixPanelConfig {
  /// MixPanel project token from environment variable.
  /// Returns empty string if not set (analytics will be disabled).
  static String get token => Platform.environment['MIXPANEL_TOKEN'] ?? '';

  /// Whether MixPanel is enabled (has token).
  static bool get enabled => token.isNotEmpty;
}
