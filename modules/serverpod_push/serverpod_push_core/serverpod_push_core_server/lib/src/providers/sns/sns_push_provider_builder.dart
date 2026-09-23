import 'package:http/http.dart' as http;

import '../../business/push_provider_builder.dart';
import 'sns_push_provider.dart';

/// Builds an [SnsPushProvider].
class SnsPushProviderBuilder extends PushProviderBuilder<SnsPushProvider> {
  /// AWS region the platform applications live in, e.g. `us-east-1`.
  final String region;

  /// IAM access key id used to sign SNS requests.
  final String accessKeyId;

  /// IAM secret access key used to sign SNS requests.
  final String secretAccessKey;

  /// Optional STS session token. Required for temporary credentials.
  final String? sessionToken;

  /// Platform application ARN for Android (FCM) device tokens.
  final String? androidPlatformApplicationArn;

  /// Platform application ARN for iOS device tokens.
  final String? iosPlatformApplicationArn;

  /// Platform application ARN for macOS device tokens.
  final String? macosPlatformApplicationArn;

  /// See [SnsApnsEnvironment].
  final SnsApnsEnvironment apnsEnvironment;

  /// Optional HTTP client. When omitted the provider owns its own client.
  final http.Client? httpClient;

  /// See [SnsPushProvider.maxConcurrentRequests].
  final int maxConcurrentRequests;

  /// See [SnsPushProvider.sendTimeout].
  final Duration sendTimeout;

  /// Overrides the regional SNS endpoint. Requests are still signed for [region].
  final Uri? endpoint;

  /// Creates a builder.
  const SnsPushProviderBuilder({
    required this.region,
    required this.accessKeyId,
    required this.secretAccessKey,
    this.sessionToken,
    this.androidPlatformApplicationArn,
    this.iosPlatformApplicationArn,
    this.macosPlatformApplicationArn,
    this.apnsEnvironment = SnsApnsEnvironment.production,
    this.httpClient,
    this.maxConcurrentRequests = 50,
    this.sendTimeout = const Duration(seconds: 30),
    this.endpoint,
  });

  @override
  SnsPushProvider build() {
    return SnsPushProvider(
      region: region,
      accessKeyId: accessKeyId,
      secretAccessKey: secretAccessKey,
      sessionToken: sessionToken,
      androidPlatformApplicationArn: androidPlatformApplicationArn,
      iosPlatformApplicationArn: iosPlatformApplicationArn,
      macosPlatformApplicationArn: macosPlatformApplicationArn,
      apnsEnvironment: apnsEnvironment,
      httpClient: httpClient,
      maxConcurrentRequests: maxConcurrentRequests,
      sendTimeout: sendTimeout,
      endpoint: endpoint,
    );
  }
}
