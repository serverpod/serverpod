import 'dart:io';

/// PostHog configuration for CLI analytics.
///
/// API keys should be provided via environment variables:
/// - POSTHOG_API_KEY: PostHog project API key
/// - POSTHOG_HOST: PostHog host (defaults to https://eu.i.posthog.com)
class PostHogConfig {
  /// Default PostHog host (EU instance)
  static const String defaultHost = 'https://eu.i.posthog.com';

  /// PostHog project API key from environment variable.
  /// Returns empty string if not set (analytics will be disabled).
  static String get apiKey => Platform.environment['POSTHOG_API_KEY'] ?? '';

  /// PostHog host from environment variable or default.
  static String get host => Platform.environment['POSTHOG_HOST'] ?? defaultHost;

  /// Whether PostHog is enabled (has API key).
  static bool get enabled => apiKey.isNotEmpty;
}
