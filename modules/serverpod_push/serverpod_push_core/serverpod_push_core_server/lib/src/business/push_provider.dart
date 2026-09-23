import '../generated/protocol.dart';
import 'push_send_request.dart';

/// Data-overlay key the store writes with the delivery id so a client can
/// call `acknowledge`.
const pushDeliveryIdDataKey = '_spDeliveryId';

/// A push transport. Implementations send [PushMessage]s and never throw for
/// per-target failures — those come back as [PushSendResult]s.
abstract interface class PushProvider {
  /// Stable provider id, e.g. `'fcm'`, `'apns'`, `'webpush'`.
  String get provider;

  /// Platforms this provider can address.
  Set<PushPlatform> get supportedPlatforms;

  /// Maximum number of [PushSendRequest]s a single [send] call should carry.
  int get maxTargetsPerRequest;

  /// Maximum number of in-flight [send] calls this process should make.
  int get maxConcurrentRequests;

  /// Hard upper bound on a single [send] call. Asserted against the store's
  /// `claimTimeout` at registration: a send that can outlive the claim is a
  /// duplicate-delivery generator.
  Duration get sendTimeout;

  /// Provider payload ceiling, measured on the provider's own wire format —
  /// not on the serialized Dart [PushMessage]. Enqueue validates against this
  /// for every provider the audience actually spans.
  int get maxPayloadBytes;

  /// Provider ceiling on message lifetime (FCM: 4 weeks). `timeToLive` above
  /// this is rejected at enqueue rather than turning into a 400 at send time.
  Duration get maxTimeToLive;

  /// The stable identity of the device behind [credential]. Uniqueness and
  /// re-registration are keyed off this, not off the credential itself.
  ///
  /// FCM/APNs return the credential unchanged. Web Push returns only the
  /// subscription's `endpoint`, because a browser rotates `p256dh`/`auth`
  /// while the endpoint stays stable — hashing the whole credential would
  /// register a second row for the same browser on every key rotation.
  String identityKeyFor(String credential);

  /// Measures [message] plus [additionalData] on this provider's wire format.
  int payloadBytesFor(PushMessage message, Map<String, String> additionalData);

  /// One request carries one message and N per-target requests.
  ///
  /// Never throws for per-target failures — those come back as outcomes.
  /// Returns results in request order, one per request.
  Future<List<PushSendResult>> send({
    required PushMessage message,
    required List<PushSendRequest> requests,
  });

  /// Releases any sockets or cached credentials.
  Future<void> close();
}
