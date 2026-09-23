import 'package:serverpod_push_core_server/serverpod_push_core_server.dart';

/// In-memory [PushProvider] for tests.
class FakePushProvider implements PushProvider {
  /// Creates a fake provider.
  FakePushProvider({
    this.provider = 'fake',
    this.maxTargetsPerRequest = 100,
    this.maxConcurrentRequests = 10,
    this.sendTimeout = const Duration(seconds: 5),
    this.maxPayloadBytes = 4096,
    this.maxTimeToLive = const Duration(days: 28),
    this.identityTransform,
    this.onSend,
  });

  @override
  final String provider;

  @override
  Set<PushPlatform> get supportedPlatforms => PushPlatform.values.toSet();

  @override
  final int maxTargetsPerRequest;

  @override
  final int maxConcurrentRequests;

  @override
  final Duration sendTimeout;

  @override
  final int maxPayloadBytes;

  @override
  final Duration maxTimeToLive;

  /// Optional identity extractor. Defaults to the credential unchanged.
  final String Function(String credential)? identityTransform;

  /// Optional send override.
  final Future<List<PushSendResult>> Function({
    required PushMessage message,
    required List<PushSendRequest> requests,
  })?
  onSend;

  /// Recorded send calls.
  final calls = <({PushMessage message, List<PushSendRequest> requests})>[];

  @override
  String identityKeyFor(final String credential) {
    return identityTransform?.call(credential) ?? credential;
  }

  @override
  int payloadBytesFor(
    final PushMessage message,
    final Map<String, String> additionalData,
  ) {
    return (message.body?.length ?? 0) +
        (message.title?.length ?? 0) +
        message.data.values.fold<int>(0, (final s, final v) => s + v.length) +
        additionalData.values.fold<int>(0, (final s, final v) => s + v.length);
  }

  @override
  Future<List<PushSendResult>> send({
    required final PushMessage message,
    required final List<PushSendRequest> requests,
  }) async {
    calls.add((message: message, requests: requests));
    if (onSend != null) {
      return onSend!(message: message, requests: requests);
    }
    return [
      for (final request in requests)
        PushSendResult(
          target: request.target,
          outcome: PushDeliveryOutcome.accepted,
          providerMessageId: 'fake-${request.target.credential}',
        ),
    ];
  }

  @override
  Future<void> close() async {}
}
