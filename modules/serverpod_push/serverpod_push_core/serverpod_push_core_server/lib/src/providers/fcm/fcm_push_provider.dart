import 'dart:async';
import 'dart:convert';

import 'package:clock/clock.dart';
import 'package:http/http.dart' as http;
import 'package:serverpod_shared/serverpod_shared.dart';

import '../../business/exceptions.dart';
import '../../business/push_provider.dart';
import '../../business/push_send_request.dart';
import '../../generated/protocol.dart';
import 'fcm_oauth_token_source.dart';

/// Firebase Cloud Messaging HTTP v1 [PushProvider].
class FcmPushProvider implements PushProvider {
  /// FCM provider id.
  static const providerId = 'fcm';

  /// Creates an FCM provider.
  factory FcmPushProvider({
    required final FirebaseServiceAccountCredentials credentials,
    final http.Client? httpClient,
    final int maxConcurrentRequests = 50,
    final Duration sendTimeout = const Duration(seconds: 30),
  }) {
    if (!credentials.canSign) {
      throw const PushMissingCredentialsException(
        providerId,
        'client_email and private_key are required to send via FCM.',
      );
    }
    final client = httpClient ?? http.Client();
    return FcmPushProvider._(
      credentials: credentials,
      httpClient: client,
      ownsHttpClient: httpClient == null,
      tokens: FcmOauthTokenSource(
        credentials: credentials,
        httpClient: client,
      ),
      maxConcurrentRequests: maxConcurrentRequests,
      sendTimeout: sendTimeout,
    );
  }

  FcmPushProvider._({
    required final FirebaseServiceAccountCredentials credentials,
    required final http.Client httpClient,
    required final bool ownsHttpClient,
    required final FcmOauthTokenSource tokens,
    required this.maxConcurrentRequests,
    required this.sendTimeout,
  }) : _credentials = credentials,
       _httpClient = httpClient,
       _ownsHttpClient = ownsHttpClient,
       _tokens = tokens;

  final FirebaseServiceAccountCredentials _credentials;
  final http.Client _httpClient;
  final bool _ownsHttpClient;
  final FcmOauthTokenSource _tokens;

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
    final data = _mergedData(message, additionalData);
    return utf8.encode(jsonEncode(data)).length;
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
      final token = await _tokens.accessToken();
      final ttl = request.expiresAt.difference(now);
      final body = jsonEncode({
        'message': _fcmMessage(message, request, ttl),
      });

      final response = await _httpClient
          .post(
            Uri.parse(
              'https://fcm.googleapis.com/v1/projects/'
              '${_credentials.projectId}/messages:send',
            ),
            headers: {
              'Authorization': 'Bearer $token',
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
        errorMessage: 'FCM send timed out after $sendTimeout.',
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

  Map<String, Object?> _fcmMessage(
    final PushMessage message,
    final PushSendRequest request,
    final Duration ttl,
  ) {
    final data = _mergedData(message, request.dataOverlay);
    final ttlSeconds = ttl.inSeconds.clamp(0, maxTimeToLive.inSeconds);
    final androidPriority = message.priority == PushPriority.high
        ? 'HIGH'
        : 'NORMAL';
    final apnsPriority = message.priority == PushPriority.high ? '10' : '5';

    return {
      'token': request.target.credential,
      if (message.title != null || message.body != null || message.imageUrl != null)
        'notification': {
          if (message.title != null) 'title': message.title,
          if (message.body != null) 'body': message.body,
          if (message.imageUrl != null) 'image': message.imageUrl,
        },
      if (data.isNotEmpty) 'data': data,
      'android': {
        if (message.collapseKey != null) 'collapse_key': message.collapseKey,
        'priority': androidPriority,
        'ttl': '${ttlSeconds}s',
      },
      'apns': {
        'headers': {
          'apns-expiration':
              (request.expiresAt.millisecondsSinceEpoch ~/ 1000).toString(),
          'apns-priority': apnsPriority,
          if (message.collapseKey != null)
            'apns-collapse-id': message.collapseKey,
        },
      },
    };
  }

  PushSendResult _mapResponse(
    final PushDeviceTarget target,
    final http.Response response,
  ) {
    if (response.statusCode == 200) {
      String? messageId;
      try {
        final decoded = jsonDecode(response.body);
        if (decoded is Map<String, dynamic>) {
          messageId = decoded['name'] as String?;
        }
      } catch (_) {}
      return PushSendResult(
        target: target,
        outcome: PushDeliveryOutcome.accepted,
        providerMessageId: messageId,
      );
    }

    final parsed = _parseFcmError(response.body);
    final errorCode = parsed.errorCode;
    final status = parsed.status;
    final retryAfter = _retryAfter(response);

    if (response.statusCode == 404 || errorCode == 'UNREGISTERED') {
      return PushSendResult(
        target: target,
        outcome: PushDeliveryOutcome.invalidToken,
        errorCode: errorCode ?? status ?? 'UNREGISTERED',
        errorMessage: parsed.message,
      );
    }

    if (response.statusCode == 429 || errorCode == 'QUOTA_EXCEEDED') {
      return PushSendResult(
        target: target,
        outcome: PushDeliveryOutcome.rateLimited,
        errorCode: errorCode ?? status ?? 'QUOTA_EXCEEDED',
        errorMessage: parsed.message,
        retryAfter: retryAfter,
      );
    }

    if (response.statusCode == 401 ||
        response.statusCode == 403 ||
        status == 'UNAUTHENTICATED' ||
        status == 'PERMISSION_DENIED') {
      return PushSendResult(
        target: target,
        outcome: PushDeliveryOutcome.retryable,
        errorCode: status ?? errorCode ?? 'UNAUTHENTICATED',
        errorMessage: parsed.message,
      );
    }

    if (response.statusCode == 400 || errorCode == 'INVALID_ARGUMENT') {
      return PushSendResult(
        target: target,
        outcome: PushDeliveryOutcome.permanentFailure,
        errorCode: errorCode ?? status ?? 'INVALID_ARGUMENT',
        errorMessage: parsed.message,
      );
    }

    if (response.statusCode >= 500) {
      return PushSendResult(
        target: target,
        outcome: PushDeliveryOutcome.retryable,
        errorCode: errorCode ?? status ?? 'UNAVAILABLE',
        errorMessage: parsed.message,
      );
    }

    if (response.statusCode >= 400 && response.statusCode < 500) {
      return PushSendResult(
        target: target,
        outcome: PushDeliveryOutcome.permanentFailure,
        errorCode: errorCode ?? status ?? 'FAILED_PRECONDITION',
        errorMessage: parsed.message,
      );
    }

    return PushSendResult(
      target: target,
      outcome: PushDeliveryOutcome.retryable,
      errorCode: errorCode ?? status,
      errorMessage: parsed.message,
    );
  }

  static ({String? errorCode, String? status, String? message}) _parseFcmError(
    final String body,
  ) {
    try {
      final decoded = jsonDecode(body);
      if (decoded is! Map<String, dynamic>) {
        return (errorCode: null, status: null, message: body);
      }
      final error = decoded['error'];
      if (error is! Map<String, dynamic>) {
        return (errorCode: null, status: null, message: body);
      }
      String? fcmCode;
      final details = error['details'];
      if (details is List) {
        for (final detail in details) {
          if (detail is Map<String, dynamic> && detail['errorCode'] is String) {
            fcmCode = detail['errorCode'] as String;
            break;
          }
        }
      }
      return (
        errorCode: fcmCode,
        status: error['status'] as String?,
        message: error['message'] as String? ?? body,
      );
    } catch (_) {
      return (errorCode: null, status: null, message: body);
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
