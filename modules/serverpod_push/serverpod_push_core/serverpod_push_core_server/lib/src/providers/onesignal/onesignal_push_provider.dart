import 'dart:async';
import 'dart:convert';

import 'package:clock/clock.dart';
import 'package:http/http.dart' as http;

import '../../business/exceptions.dart';
import '../../business/push_provider.dart';
import '../../business/push_send_request.dart';
import '../../generated/protocol.dart';

/// OneSignal create-notification [PushProvider].
///
/// Targets devices by OneSignal subscription id stored as
/// [PushDeviceTarget.credential]. Uses the REST Create Notification API:
/// `POST https://api.onesignal.com/notifications`.
class OneSignalPushProvider implements PushProvider {
  /// OneSignal provider id.
  static const providerId = 'onesignal';

  static final _sendUri = Uri.parse(
    'https://api.onesignal.com/notifications',
  );

  /// Creates a OneSignal provider.
  factory OneSignalPushProvider({
    required final String appId,
    required final String restApiKey,
    final http.Client? httpClient,
    final int maxConcurrentRequests = 50,
    final Duration sendTimeout = const Duration(seconds: 30),
  }) {
    if (appId.isEmpty || restApiKey.isEmpty) {
      throw const PushMissingCredentialsException(
        providerId,
        'appId and restApiKey are required to send via OneSignal.',
      );
    }
    final client = httpClient ?? http.Client();
    return OneSignalPushProvider._(
      appId: appId,
      restApiKey: restApiKey,
      httpClient: client,
      ownsHttpClient: httpClient == null,
      maxConcurrentRequests: maxConcurrentRequests,
      sendTimeout: sendTimeout,
    );
  }

  OneSignalPushProvider._({
    required final String appId,
    required final String restApiKey,
    required final http.Client httpClient,
    required final bool ownsHttpClient,
    required this.maxConcurrentRequests,
    required this.sendTimeout,
  }) : _appId = appId,
       _restApiKey = restApiKey,
       _httpClient = httpClient,
       _ownsHttpClient = ownsHttpClient;

  final String _appId;
  final String _restApiKey;
  final http.Client _httpClient;
  final bool _ownsHttpClient;

  @override
  String get provider => providerId;

  @override
  Set<PushPlatform> get supportedPlatforms => const {
    PushPlatform.android,
    PushPlatform.ios,
    PushPlatform.web,
    PushPlatform.macos,
  };

  @override
  int get maxTargetsPerRequest => 1;

  @override
  final int maxConcurrentRequests;

  @override
  final Duration sendTimeout;

  /// OneSignal caps `ttl` at 28 days (2_419_200 seconds).
  @override
  int get maxPayloadBytes => 4096;

  @override
  Duration get maxTimeToLive => const Duration(days: 28);

  @override
  String identityKeyFor(final String credential) => credential;

  @override
  int payloadBytesFor(
    final PushMessage message,
    final Map<String, String> additionalData,
  ) {
    return utf8.encode(jsonEncode(_mergedData(message, additionalData))).length;
  }

  @override
  Future<List<PushSendResult>> send({
    required final PushMessage message,
    required final List<PushSendRequest> requests,
  }) async {
    final results = <PushSendResult>[];
    for (final request in requests) {
      results.add(await _sendOne(message, request));
    }
    return results;
  }

  @override
  Future<void> close() async {
    if (_ownsHttpClient) {
      _httpClient.close();
    }
  }

  Future<PushSendResult> _sendOne(
    final PushMessage message,
    final PushSendRequest request,
  ) async {
    final now = clock.now().toUtc();
    if (!request.expiresAt.isAfter(now)) {
      return PushSendResult(
        target: request.target,
        outcome: PushDeliveryOutcome.expired,
      );
    }

    try {
      final ttl = request.expiresAt.difference(now);
      final body = jsonEncode(_notificationBody(message, request, ttl));

      final response = await _httpClient
          .post(
            _sendUri,
            headers: {
              'Authorization': 'Key $_restApiKey',
              'Content-Type': 'application/json; charset=utf-8',
            },
            body: body,
          )
          .timeout(sendTimeout);

      return _mapResponse(request.target, response);
    } on TimeoutException {
      return PushSendResult(
        target: request.target,
        outcome: PushDeliveryOutcome.retryable,
        errorCode: 'TIMEOUT',
        errorMessage: 'OneSignal send timed out after $sendTimeout.',
      );
    } on PushMissingCredentialsException {
      rethrow;
    } catch (e) {
      return PushSendResult(
        target: request.target,
        outcome: PushDeliveryOutcome.retryable,
        errorMessage: e.toString(),
      );
    }
  }

  Map<String, Object?> _notificationBody(
    final PushMessage message,
    final PushSendRequest request,
    final Duration ttl,
  ) {
    final data = _mergedData(message, request.dataOverlay);
    final ttlSeconds = ttl.inSeconds.clamp(0, maxTimeToLive.inSeconds);
    final priority = message.priority == PushPriority.high ? 10 : 5;

    return {
      'app_id': _appId,
      'include_subscription_ids': [request.target.credential],
      if (message.title != null) 'headings': {'en': message.title},
      if (message.body != null) 'contents': {'en': message.body},
      if (message.imageUrl != null) 'big_picture': message.imageUrl,
      if (message.collapseKey != null) 'collapse_id': message.collapseKey,
      if (data.isNotEmpty) 'data': data,
      'ttl': ttlSeconds,
      'priority': priority,
    };
  }

  PushSendResult _mapResponse(
    final PushDeviceTarget target,
    final http.Response response,
  ) {
    if (response.statusCode == 200) {
      return _mapSuccessBody(target, response.body);
    }

    final parsed = _parseErrorBody(response.body);
    final retryAfter = _retryAfter(response);

    if (response.statusCode == 429) {
      return PushSendResult(
        target: target,
        outcome: PushDeliveryOutcome.rateLimited,
        errorCode: parsed.errorCode ?? 'RATE_LIMITED',
        errorMessage: parsed.message,
        retryAfter: retryAfter,
      );
    }

    if (response.statusCode == 401 || response.statusCode == 403) {
      return PushSendResult(
        target: target,
        outcome: PushDeliveryOutcome.retryable,
        errorCode: parsed.errorCode ?? 'UNAUTHENTICATED',
        errorMessage: parsed.message,
      );
    }

    if (response.statusCode == 400) {
      if (_looksLikeInvalidSubscription(parsed.message, target.credential)) {
        return PushSendResult(
          target: target,
          outcome: PushDeliveryOutcome.invalidToken,
          errorCode: parsed.errorCode ?? 'INVALID_SUBSCRIPTION',
          errorMessage: parsed.message,
        );
      }
      return PushSendResult(
        target: target,
        outcome: PushDeliveryOutcome.permanentFailure,
        errorCode: parsed.errorCode ?? 'INVALID_ARGUMENT',
        errorMessage: parsed.message,
      );
    }

    if (response.statusCode >= 500) {
      return PushSendResult(
        target: target,
        outcome: PushDeliveryOutcome.retryable,
        errorCode: parsed.errorCode ?? 'UNAVAILABLE',
        errorMessage: parsed.message,
      );
    }

    if (response.statusCode >= 400 && response.statusCode < 500) {
      return PushSendResult(
        target: target,
        outcome: PushDeliveryOutcome.permanentFailure,
        errorCode: parsed.errorCode ?? 'FAILED_PRECONDITION',
        errorMessage: parsed.message,
      );
    }

    return PushSendResult(
      target: target,
      outcome: PushDeliveryOutcome.retryable,
      errorCode: parsed.errorCode,
      errorMessage: parsed.message,
    );
  }

  PushSendResult _mapSuccessBody(
    final PushDeviceTarget target,
    final String body,
  ) {
    try {
      final decoded = jsonDecode(body);
      if (decoded is! Map<String, dynamic>) {
        return PushSendResult(
          target: target,
          outcome: PushDeliveryOutcome.retryable,
          errorMessage: body,
        );
      }

      final id = decoded['id'];
      final messageId = id is String && id.isNotEmpty ? id : null;
      final errors = decoded['errors'];

      if (_errorsListInvalidSubscription(errors, target.credential) ||
          _errorsMapInvalidSubscription(errors, target.credential)) {
        return PushSendResult(
          target: target,
          outcome: PushDeliveryOutcome.invalidToken,
          errorCode: 'INVALID_SUBSCRIPTION',
          errorMessage: errors.toString(),
          providerMessageId: messageId,
        );
      }

      if (messageId == null) {
        return PushSendResult(
          target: target,
          outcome: PushDeliveryOutcome.invalidToken,
          errorCode: 'NO_SUBSCRIBERS',
          errorMessage: errors?.toString() ?? body,
        );
      }

      return PushSendResult(
        target: target,
        outcome: PushDeliveryOutcome.accepted,
        providerMessageId: messageId,
      );
    } catch (_) {
      return PushSendResult(
        target: target,
        outcome: PushDeliveryOutcome.retryable,
        errorMessage: body,
      );
    }
  }

  static bool _errorsListInvalidSubscription(
    final Object? errors,
    final String credential,
  ) {
    if (errors is! List) return false;
    final joined = errors
        .map((final e) => e.toString().toLowerCase())
        .join(' ');
    return joined.contains('not subscribed') ||
        joined.contains('invalid') ||
        joined.contains(credential.toLowerCase());
  }

  static bool _errorsMapInvalidSubscription(
    final Object? errors,
    final String credential,
  ) {
    if (errors is! Map) return false;
    for (final key in const [
      'invalid_player_ids',
      'invalid_subscription_ids',
      'invalid_aliases',
    ]) {
      final value = errors[key];
      if (value is List &&
          value.map((final e) => e.toString()).contains(credential)) {
        return true;
      }
      if (value is Map && value.containsKey(credential)) {
        return true;
      }
    }
    return false;
  }

  static bool _looksLikeInvalidSubscription(
    final String? message,
    final String credential,
  ) {
    if (message == null) return false;
    final lower = message.toLowerCase();
    return lower.contains('subscription') ||
        lower.contains('player') ||
        lower.contains(credential.toLowerCase());
  }

  static ({String? errorCode, String? message}) _parseErrorBody(
    final String body,
  ) {
    try {
      final decoded = jsonDecode(body);
      if (decoded is! Map<String, dynamic>) {
        return (errorCode: null, message: body);
      }
      final errors = decoded['errors'];
      if (errors is List && errors.isNotEmpty) {
        return (errorCode: null, message: errors.join('; '));
      }
      if (errors is String) {
        return (errorCode: null, message: errors);
      }
      if (errors is Map) {
        return (errorCode: null, message: errors.toString());
      }
      final message = decoded['message'] ?? decoded['error'];
      if (message is String) {
        return (errorCode: null, message: message);
      }
      return (errorCode: null, message: body);
    } catch (_) {
      return (errorCode: null, message: body);
    }
  }

  static Duration? _retryAfter(final http.Response response) {
    final header = response.headers['retry-after'];
    if (header == null || header.isEmpty) return null;
    final seconds = int.tryParse(header);
    if (seconds != null) return Duration(seconds: seconds);
    final date = DateTime.tryParse(header);
    if (date == null) return null;
    final delta = date.toUtc().difference(clock.now().toUtc());
    return delta.isNegative ? Duration.zero : delta;
  }

  static Map<String, String> _mergedData(
    final PushMessage message,
    final Map<String, String> additionalData,
  ) {
    return {
      ...message.data,
      ...additionalData,
    };
  }
}
