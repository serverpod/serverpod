import 'package:http/http.dart' as http;

import '../../business/push_provider_builder.dart';
import 'onesignal_push_provider.dart';

/// Builds an [OneSignalPushProvider].
class OneSignalPushProviderBuilder
    extends PushProviderBuilder<OneSignalPushProvider> {
  /// OneSignal App ID.
  final String appId;

  /// OneSignal REST API key.
  final String restApiKey;

  /// Optional HTTP client. When omitted the provider owns its own client.
  final http.Client? httpClient;

  /// See [OneSignalPushProvider.maxConcurrentRequests].
  final int maxConcurrentRequests;

  /// See [OneSignalPushProvider.sendTimeout].
  final Duration sendTimeout;

  /// Creates a builder.
  const OneSignalPushProviderBuilder({
    required this.appId,
    required this.restApiKey,
    this.httpClient,
    this.maxConcurrentRequests = 50,
    this.sendTimeout = const Duration(seconds: 30),
  });

  @override
  OneSignalPushProvider build() {
    return OneSignalPushProvider(
      appId: appId,
      restApiKey: restApiKey,
      httpClient: httpClient,
      maxConcurrentRequests: maxConcurrentRequests,
      sendTimeout: sendTimeout,
    );
  }
}
