import 'package:http/http.dart' as http;
import 'package:serverpod_shared/serverpod_shared.dart';

import '../../business/push_provider_builder.dart';
import 'fcm_push_provider.dart';

/// Builds an [FcmPushProvider].
class FcmPushProviderBuilder extends PushProviderBuilder<FcmPushProvider> {
  /// Service-account credentials used to mint OAuth tokens.
  final FirebaseServiceAccountCredentials credentials;

  /// Optional HTTP client. When omitted the provider owns its own client.
  final http.Client? httpClient;

  /// See [FcmPushProvider.maxConcurrentRequests].
  final int maxConcurrentRequests;

  /// See [FcmPushProvider.sendTimeout].
  final Duration sendTimeout;

  /// Creates a builder.
  const FcmPushProviderBuilder({
    required this.credentials,
    this.httpClient,
    this.maxConcurrentRequests = 50,
    this.sendTimeout = const Duration(seconds: 30),
  });

  @override
  FcmPushProvider build() {
    return FcmPushProvider(
      credentials: credentials,
      httpClient: httpClient,
      maxConcurrentRequests: maxConcurrentRequests,
      sendTimeout: sendTimeout,
    );
  }
}
