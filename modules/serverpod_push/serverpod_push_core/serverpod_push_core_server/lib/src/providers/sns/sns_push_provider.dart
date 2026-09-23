import 'dart:async';
import 'dart:convert';
import 'dart:math' show max;

import 'package:clock/clock.dart';
import 'package:http/http.dart' as http;

import '../../business/exceptions.dart';
import '../../business/push_provider.dart';
import '../../business/push_send_request.dart';
import '../../generated/protocol.dart';
import 'aws_sig_v4.dart';

/// APNs environment of the iOS and macOS platform applications.
///
/// SNS will not deliver an `APNS` payload to a sandbox endpoint, or an
/// `APNS_SANDBOX` payload to a production endpoint. The platform application
/// ARN does not say which one it is.
enum SnsApnsEnvironment {
  /// Production APNs. Message key `APNS`.
  production,

  /// Sandbox APNs. Message key `APNS_SANDBOX`.
  sandbox,
}

/// Amazon SNS mobile-push [PushProvider].
///
/// [PushDeviceTarget.credential] is either a device token (an FCM registration
/// token or an APNs device token) or an existing platform endpoint ARN
/// (`arn:aws:sns:…:endpoint/…`). A token is resolved with
/// `CreatePlatformEndpoint` against the platform application ARN for
/// [PushDeviceTarget.platform], then published. Endpoint creation is
/// idempotent; the "already exists with different attributes" error is
/// recovered with `SetEndpointAttributes` so a rotated token replaces the
/// stale one instead of failing the send.
///
/// `identityKeyFor` returns the credential unchanged. Both a device token and
/// an endpoint ARN are stable identities.
///
/// Auth failures are reported as `UNAUTHENTICATED` or `PERMISSION_DENIED` so
/// the store's circuit breaker opens. `EndpointDisabled` and `NotFound` are
/// `invalidToken`. A request whose `expiresAt` has already passed returns
/// `expired` without a network call.
///
/// | SNS error | Outcome |
/// | --- | --- |
/// | HTTP 200 | `accepted` |
/// | `EndpointDisabled`, `NotFound` | `invalidToken` |
/// | `Throttling`, HTTP 429 | `rateLimited` |
/// | auth failures, HTTP 401 | `retryable` (`UNAUTHENTICATED`) |
/// | `AccessDenied`, HTTP 403 | `retryable` (`PERMISSION_DENIED`) |
/// | `InvalidParameter` and other HTTP 4xx | `permanentFailure` |
/// | `PlatformApplicationDisabled`, HTTP 500/503 | `retryable` |
class SnsPushProvider implements PushProvider {
  /// SNS provider id.
  static const providerId = 'sns';

  static const _service = 'sns';
  static const _apiVersion = '2010-03-31';
  static final _endpointArnPattern = RegExp(
    r'^arn:aws[a-z0-9-]*:sns:[a-z0-9-]+:\d{12}:endpoint/.+',
  );
  static final _arnInMessage = RegExp(
    r'arn:aws[a-z0-9-]*:sns:[a-z0-9-]+:\d{12}:endpoint/\S+',
  );

  /// Creates an SNS provider.
  ///
  /// [androidPlatformApplicationArn], [iosPlatformApplicationArn], and
  /// [macosPlatformApplicationArn] are required only for sends whose
  /// credential is a device token on that platform. Sends whose credential is
  /// already an endpoint ARN do not need them.
  ///
  /// [endpoint] overrides the regional API URL (`https://sns.{region}.amazonaws.com/`),
  /// for LocalStack or a VPC endpoint. Requests are still signed for [region].
  factory SnsPushProvider({
    required final String region,
    required final String accessKeyId,
    required final String secretAccessKey,
    final String? sessionToken,
    final String? androidPlatformApplicationArn,
    final String? iosPlatformApplicationArn,
    final String? macosPlatformApplicationArn,
    final SnsApnsEnvironment apnsEnvironment = SnsApnsEnvironment.production,
    final http.Client? httpClient,
    final int maxConcurrentRequests = 50,
    final Duration sendTimeout = const Duration(seconds: 30),
    final Uri? endpoint,
  }) {
    if (region.isEmpty || accessKeyId.isEmpty || secretAccessKey.isEmpty) {
      throw const PushMissingCredentialsException(
        providerId,
        'region, accessKeyId, and secretAccessKey are required to send via SNS.',
      );
    }
    if (region.contains('/') || region.contains(' ')) {
      throw ArgumentError.value(region, 'region', 'Invalid AWS region.');
    }
    _requirePlatformArn(
      androidPlatformApplicationArn,
      'androidPlatformApplicationArn',
    );
    _requirePlatformArn(
      iosPlatformApplicationArn,
      'iosPlatformApplicationArn',
    );
    _requirePlatformArn(
      macosPlatformApplicationArn,
      'macosPlatformApplicationArn',
    );

    final client = httpClient ?? http.Client();
    final token = sessionToken == null || sessionToken.isEmpty
        ? null
        : sessionToken;
    return SnsPushProvider._(
      region: region,
      accessKeyId: accessKeyId,
      secretAccessKey: secretAccessKey,
      sessionToken: token,
      androidPlatformApplicationArn: androidPlatformApplicationArn,
      iosPlatformApplicationArn: iosPlatformApplicationArn,
      macosPlatformApplicationArn: macosPlatformApplicationArn,
      apnsEnvironment: apnsEnvironment,
      endpoint: endpoint ?? Uri.parse('https://sns.$region.amazonaws.com/'),
      httpClient: client,
      ownsHttpClient: httpClient == null,
      maxConcurrentRequests: maxConcurrentRequests,
      sendTimeout: sendTimeout,
    );
  }

  SnsPushProvider._({
    required final String region,
    required final String accessKeyId,
    required final String secretAccessKey,
    required final String? sessionToken,
    required final String? androidPlatformApplicationArn,
    required final String? iosPlatformApplicationArn,
    required final String? macosPlatformApplicationArn,
    required final SnsApnsEnvironment apnsEnvironment,
    required final Uri endpoint,
    required final http.Client httpClient,
    required final bool ownsHttpClient,
    required this.maxConcurrentRequests,
    required this.sendTimeout,
  }) : _region = region,
       _accessKeyId = accessKeyId,
       _secretAccessKey = secretAccessKey,
       _sessionToken = sessionToken,
       _androidPlatformApplicationArn = androidPlatformApplicationArn,
       _iosPlatformApplicationArn = iosPlatformApplicationArn,
       _macosPlatformApplicationArn = macosPlatformApplicationArn,
       _apnsEnvironment = apnsEnvironment,
       _endpoint = endpoint,
       _httpClient = httpClient,
       _ownsHttpClient = ownsHttpClient;

  final String _region;
  final String _accessKeyId;
  final String _secretAccessKey;
  final String? _sessionToken;
  final String? _androidPlatformApplicationArn;
  final String? _iosPlatformApplicationArn;
  final String? _macosPlatformApplicationArn;
  final SnsApnsEnvironment _apnsEnvironment;
  final Uri _endpoint;
  final http.Client _httpClient;
  final bool _ownsHttpClient;

  final Map<String, String> _endpointArns = {};
  final Map<String, Future<String>> _endpointInFlight = {};

  @override
  String get provider => providerId;

  @override
  Set<PushPlatform> get supportedPlatforms => const {
    PushPlatform.android,
    PushPlatform.ios,
    PushPlatform.macos,
  };

  @override
  int get maxTargetsPerRequest => 1;

  @override
  final int maxConcurrentRequests;

  @override
  final Duration sendTimeout;

  /// FCM and APNs both reject platform payloads above 4 KB. SNS itself allows
  /// 256 KB, but the embedded GCM/APNS string is what the platform enforces.
  @override
  int get maxPayloadBytes => 4096;

  /// FCM's ceiling, which SNS applies on the Android path. Longer values
  /// become `INVALID_ARGUMENT` at Google rather than a clean enqueue error.
  @override
  Duration get maxTimeToLive => const Duration(days: 28);

  @override
  String identityKeyFor(final String credential) => credential;

  @override
  int payloadBytesFor(
    final PushMessage message,
    final Map<String, String> additionalData,
  ) {
    final merged = _mergedData(message, additionalData);
    final gcm = utf8.encode(_gcmPayload(message, merged, maxTimeToLive)).length;
    final apns = utf8.encode(_apnsPayload(message, merged)).length;
    return max(gcm, apns);
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
    _endpointArns.clear();
    _endpointInFlight.clear();
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

    final deadline = now.add(sendTimeout);
    try {
      final credential = request.target.credential;
      final hadArn = _endpointArnPattern.hasMatch(credential);
      final arn = await _endpointArn(request, deadline);
      final published = await _publish(message, request, arn, deadline);
      if (!hadArn && published.outcome == PushDeliveryOutcome.invalidToken) {
        _endpointArns.remove(_cacheKey(request, arn));
      }
      return published;
    } on TimeoutException {
      return PushSendResult(
        target: request.target,
        outcome: PushDeliveryOutcome.retryable,
        errorCode: 'TIMEOUT',
        errorMessage: 'SNS send timed out after $sendTimeout.',
      );
    } on _SnsCallException catch (e) {
      return e.result;
    } catch (e) {
      return PushSendResult(
        target: request.target,
        outcome: PushDeliveryOutcome.retryable,
        errorMessage: e.toString(),
      );
    }
  }

  Future<String> _endpointArn(
    final PushSendRequest request,
    final DateTime deadline,
  ) {
    final credential = request.target.credential;
    if (_endpointArnPattern.hasMatch(credential)) {
      return Future.value(credential);
    }

    if (request.target.platform == PushPlatform.web) {
      throw _SnsCallException(
        PushSendResult(
          target: request.target,
          outcome: PushDeliveryOutcome.permanentFailure,
          errorCode: 'UNSUPPORTED_PLATFORM',
          errorMessage: 'Amazon SNS does not deliver Web Push.',
        ),
      );
    }

    final applicationArn = _platformApplicationArn(request.target.platform);
    if (applicationArn == null) {
      throw _SnsCallException(
        PushSendResult(
          target: request.target,
          outcome: PushDeliveryOutcome.permanentFailure,
          errorCode: 'MISSING_PLATFORM_APPLICATION',
          errorMessage:
              'No SNS platform application ARN is configured for '
              '${request.target.platform.name}.',
        ),
      );
    }

    final key = '$applicationArn\n$credential';
    final cached = _endpointArns[key];
    if (cached != null) return Future.value(cached);

    return _endpointInFlight[key] ??=
        _createEndpoint(
              request,
              applicationArn,
              deadline,
            )
            .then((final arn) {
              _endpointArns[key] = arn;
              return arn;
            })
            .whenComplete(() {
              _endpointInFlight.remove(key);
            });
  }

  String _cacheKey(final PushSendRequest request, final String arn) {
    final applicationArn = _platformApplicationArn(request.target.platform);
    if (applicationArn == null) return arn;
    return '$applicationArn\n${request.target.credential}';
  }

  String? _platformApplicationArn(final PushPlatform platform) {
    return switch (platform) {
      PushPlatform.android => _androidPlatformApplicationArn,
      PushPlatform.ios => _iosPlatformApplicationArn,
      PushPlatform.macos => _macosPlatformApplicationArn,
      PushPlatform.web => null,
    };
  }

  Future<String> _createEndpoint(
    final PushSendRequest request,
    final String applicationArn,
    final DateTime deadline,
  ) async {
    final response = await _post(
      fields: {
        'Action': 'CreatePlatformEndpoint',
        'Version': _apiVersion,
        'PlatformApplicationArn': applicationArn,
        'Token': request.target.credential,
      },
      deadline: deadline,
    );
    final arn = _xmlTag(response.body, 'EndpointArn');
    if (response.statusCode >= 200 &&
        response.statusCode < 300 &&
        arn != null) {
      return arn;
    }

    final existing = _existingEndpointArn(response);
    if (existing != null) {
      await _enableEndpoint(request, existing, deadline);
      return existing;
    }

    throw _SnsCallException(_mapError(request.target, response));
  }

  Future<void> _enableEndpoint(
    final PushSendRequest request,
    final String endpointArn,
    final DateTime deadline,
  ) async {
    final response = await _post(
      fields: {
        'Action': 'SetEndpointAttributes',
        'Version': _apiVersion,
        'EndpointArn': endpointArn,
        'Attributes.entry.1.key': 'Token',
        'Attributes.entry.1.value': request.target.credential,
        'Attributes.entry.2.key': 'Enabled',
        'Attributes.entry.2.value': 'true',
      },
      deadline: deadline,
    );
    if (response.statusCode >= 200 && response.statusCode < 300) return;
    throw _SnsCallException(_mapError(request.target, response));
  }

  Future<PushSendResult> _publish(
    final PushMessage message,
    final PushSendRequest request,
    final String endpointArn,
    final DateTime deadline,
  ) async {
    final now = clock.now().toUtc();
    if (!request.expiresAt.isAfter(now)) {
      return PushSendResult(
        target: request.target,
        outcome: PushDeliveryOutcome.expired,
      );
    }

    final ttl = request.expiresAt.difference(now);
    final response = await _post(
      fields: _publishFields(message, request, endpointArn, ttl),
      deadline: deadline,
    );
    if (response.statusCode >= 200 &&
        response.statusCode < 300 &&
        _xmlTag(response.body, 'Code') == null) {
      return PushSendResult(
        target: request.target,
        outcome: PushDeliveryOutcome.accepted,
        providerMessageId: _xmlTag(response.body, 'MessageId'),
      );
    }
    return _mapError(request.target, response);
  }

  Map<String, String> _publishFields(
    final PushMessage message,
    final PushSendRequest request,
    final String endpointArn,
    final Duration ttl,
  ) {
    final merged = _mergedData(message, request.dataOverlay);
    final ttlSeconds = ttl.inSeconds.clamp(0, maxTimeToLive.inSeconds);
    final fields = <String, String>{
      'Action': 'Publish',
      'Version': _apiVersion,
      'TargetArn': endpointArn,
      'MessageStructure': 'json',
      'Message': _snsMessage(message, request, merged, ttl),
    };

    final attributes = switch (request.target.platform) {
      PushPlatform.android => [
        ('AWS.SNS.MOBILE.FCM.TTL', ttlSeconds.toString()),
      ],
      PushPlatform.ios || PushPlatform.macos => [
        (_apnsAttribute('TTL'), ttlSeconds.toString()),
        (
          _apnsAttribute('PRIORITY'),
          message.priority == PushPriority.high ? '10' : '5',
        ),
        if (message.collapseKey != null)
          (_apnsAttribute('COLLAPSE_ID'), message.collapseKey!),
      ],
      PushPlatform.web => const <(String, String)>[],
    };

    for (var i = 0; i < attributes.length; i++) {
      final (name, value) = attributes[i];
      final index = i + 1;
      fields['MessageAttributes.entry.$index.Name'] = name;
      fields['MessageAttributes.entry.$index.Value.DataType'] = 'String';
      fields['MessageAttributes.entry.$index.Value.StringValue'] = value;
    }
    return fields;
  }

  String _apnsAttribute(final String name) {
    final platform = _apnsEnvironment == SnsApnsEnvironment.sandbox
        ? 'APNS_SANDBOX'
        : 'APNS';
    return 'AWS.SNS.MOBILE.$platform.$name';
  }

  String _snsMessage(
    final PushMessage message,
    final PushSendRequest request,
    final Map<String, String> data,
    final Duration ttl,
  ) {
    final fallback = message.body ?? message.title ?? '';
    final platformKey = switch (request.target.platform) {
      PushPlatform.android => 'GCM',
      PushPlatform.ios || PushPlatform.macos =>
        _apnsEnvironment == SnsApnsEnvironment.sandbox
            ? 'APNS_SANDBOX'
            : 'APNS',
      PushPlatform.web => 'default',
    };
    final platformPayload = switch (request.target.platform) {
      PushPlatform.android => _gcmPayload(message, data, ttl),
      PushPlatform.ios || PushPlatform.macos => _apnsPayload(message, data),
      PushPlatform.web => fallback,
    };
    return jsonEncode({
      'default': fallback,
      if (platformKey != 'default') platformKey: platformPayload,
    });
  }

  /// FCM HTTP v1 payload embedded in SNS's `GCM` key. SNS injects the device
  /// token from the endpoint, so this object has no `token` field.
  static String _gcmPayload(
    final PushMessage message,
    final Map<String, String> data,
    final Duration ttl,
  ) {
    final ttlSeconds = ttl.inSeconds.clamp(0, 28 * 24 * 60 * 60);
    final priority = message.priority == PushPriority.high ? 'HIGH' : 'NORMAL';
    return jsonEncode({
      'fcmV1Message': {
        'message': {
          if (message.title != null ||
              message.body != null ||
              message.imageUrl != null)
            'notification': {
              if (message.title != null) 'title': message.title,
              if (message.body != null) 'body': message.body,
              if (message.imageUrl != null) 'image': message.imageUrl,
            },
          if (data.isNotEmpty) 'data': data,
          'android': {
            'priority': priority,
            'ttl': '${ttlSeconds}s',
            if (message.collapseKey != null)
              'collapse_key': message.collapseKey,
          },
        },
      },
    });
  }

  static String _apnsPayload(
    final PushMessage message,
    final Map<String, String> data,
  ) {
    final hasAlert = message.title != null || message.body != null;
    return jsonEncode({
      'aps': {
        if (hasAlert)
          'alert': {
            if (message.title != null) 'title': message.title,
            if (message.body != null) 'body': message.body,
          },
        if (!hasAlert) 'content-available': 1,
        if (message.imageUrl != null) 'mutable-content': 1,
      },
      for (final entry in data.entries)
        if (entry.key != 'aps') entry.key: entry.value,
      if (message.imageUrl != null) 'imageUrl': message.imageUrl,
    });
  }

  Future<http.Response> _post({
    required final Map<String, String> fields,
    required final DateTime deadline,
  }) {
    final remaining = deadline.difference(clock.now().toUtc());
    if (remaining <= Duration.zero) {
      throw TimeoutException('SNS send timed out after $sendTimeout.');
    }

    final body = AwsSigV4.encodeForm(fields);
    final headers = AwsSigV4.signedHeaders(
      method: 'POST',
      uri: _endpoint,
      body: body,
      accessKeyId: _accessKeyId,
      secretAccessKey: _secretAccessKey,
      region: _region,
      service: _service,
      now: clock.now().toUtc(),
      sessionToken: _sessionToken,
    );
    return _httpClient
        .post(_endpoint, headers: headers, body: body)
        .timeout(remaining);
  }

  PushSendResult _mapError(
    final PushDeviceTarget target,
    final http.Response response,
  ) {
    final code = _normalizeCode(_xmlTag(response.body, 'Code'));
    final message = _xmlTag(response.body, 'Message') ?? response.body;
    final retryAfter = _retryAfter(response);

    if (_throttlingCodes.contains(code) || response.statusCode == 429) {
      return PushSendResult(
        target: target,
        outcome: PushDeliveryOutcome.rateLimited,
        errorCode: code ?? 'THROTTLING',
        errorMessage: message,
        retryAfter: retryAfter,
      );
    }

    if (code == 'EndpointDisabled' ||
        code == 'NotFound' ||
        response.statusCode == 404) {
      return PushSendResult(
        target: target,
        outcome: PushDeliveryOutcome.invalidToken,
        errorCode: code ?? 'NOT_FOUND',
        errorMessage: message,
      );
    }

    if (_unauthenticatedCodes.contains(code) || response.statusCode == 401) {
      return PushSendResult(
        target: target,
        outcome: PushDeliveryOutcome.retryable,
        errorCode: 'UNAUTHENTICATED',
        errorMessage: message,
      );
    }

    if (_permissionDeniedCodes.contains(code) || response.statusCode == 403) {
      return PushSendResult(
        target: target,
        outcome: PushDeliveryOutcome.retryable,
        errorCode: 'PERMISSION_DENIED',
        errorMessage: message,
      );
    }

    if (response.statusCode >= 500 ||
        code == 'InternalError' ||
        code == 'InternalFailure' ||
        code == 'ServiceUnavailable' ||
        code == 'PlatformApplicationDisabled') {
      return PushSendResult(
        target: target,
        outcome: PushDeliveryOutcome.retryable,
        errorCode: code ?? 'UNAVAILABLE',
        errorMessage: message,
      );
    }

    if (response.statusCode >= 400 && response.statusCode < 500) {
      return PushSendResult(
        target: target,
        outcome: PushDeliveryOutcome.permanentFailure,
        errorCode: code ?? 'FAILED_PRECONDITION',
        errorMessage: message,
      );
    }

    return PushSendResult(
      target: target,
      outcome: PushDeliveryOutcome.retryable,
      errorCode: code,
      errorMessage: message,
    );
  }

  String? _existingEndpointArn(final http.Response response) {
    final code = _normalizeCode(_xmlTag(response.body, 'Code'));
    if (code != 'InvalidParameter') return null;
    final message = _xmlTag(response.body, 'Message');
    if (message == null || !message.toLowerCase().contains('already exists')) {
      return null;
    }
    final match = _arnInMessage.firstMatch(message);
    if (match == null) return null;
    return match.group(0)!.replaceAll(RegExp(r'[.,)]+$'), '');
  }

  static String? _normalizeCode(final String? code) {
    if (code == null || code.isEmpty) return null;
    final hash = code.lastIndexOf('#');
    final bare = hash >= 0 ? code.substring(hash + 1) : code;
    const suffix = 'Exception';
    if (bare.endsWith(suffix) && bare.length > suffix.length) {
      return bare.substring(0, bare.length - suffix.length);
    }
    return bare;
  }

  static String? _xmlTag(final String body, final String tag) {
    final match = RegExp('<$tag>([\\s\\S]*?)</$tag>').firstMatch(body);
    if (match == null) return null;
    final text = _decodeXml(match.group(1)!).trim();
    return text.isEmpty ? null : text;
  }

  static String _decodeXml(final String value) {
    return value
        .replaceAll('&lt;', '<')
        .replaceAll('&gt;', '>')
        .replaceAll('&quot;', '"')
        .replaceAll('&apos;', "'")
        .replaceAll('&amp;', '&');
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

  static void _requirePlatformArn(final String? arn, final String name) {
    if (arn == null) return;
    if (arn.isEmpty || !arn.startsWith('arn:') || !arn.contains(':sns:')) {
      throw ArgumentError.value(
        arn,
        name,
        'Expected an SNS platform application ARN.',
      );
    }
  }

  static const _throttlingCodes = {
    'Throttling',
    'Throttled',
    'TooManyRequests',
    'KMSThrottling',
  };

  static const _unauthenticatedCodes = {
    'AuthorizationError',
    'InvalidClientTokenId',
    'SignatureDoesNotMatch',
    'ExpiredToken',
    'IncompleteSignature',
    'MissingAuthenticationToken',
    'AuthFailure',
    'InvalidSecurity',
    'UnrecognizedClient',
  };

  static const _permissionDeniedCodes = {
    'AccessDenied',
    'OptInRequired',
    'UnauthorizedOperation',
  };
}

/// A per-target SNS failure raised inside [SnsPushProvider.send] so the
/// request loop can turn it into a [PushSendResult] without an HTTP call.
class _SnsCallException implements Exception {
  final PushSendResult result;

  const _SnsCallException(this.result);
}
