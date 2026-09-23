import 'dart:convert';

import 'package:clock/clock.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:serverpod_push_core_server/serverpod_push_core_server.dart';
import 'package:test/test.dart';

void main() {
  const region = 'us-east-1';
  const androidApp = 'arn:aws:sns:us-east-1:123456789012:app/GCM/android-app';
  const iosApp = 'arn:aws:sns:us-east-1:123456789012:app/APNS/ios-app';
  const endpointArn =
      'arn:aws:sns:us-east-1:123456789012:endpoint/GCM/android-app/uuid-1';

  PushMessage message({final PushPriority priority = PushPriority.normal}) =>
      PushMessage(
        title: 'Hello',
        body: 'World',
        data: const {'k': 'v'},
        priority: priority,
      );

  PushSendRequest request({
    final DateTime? expiresAt,
    final String credential = 'device-token',
    final PushPlatform platform = PushPlatform.android,
    final Map<String, String> dataOverlay = const {
      pushDeliveryIdDataKey: 'delivery-1',
    },
  }) => PushSendRequest(
    target: PushDeviceTarget(
      provider: 'sns',
      credential: credential,
      platform: platform,
    ),
    dataOverlay: dataOverlay,
    expiresAt: expiresAt ?? DateTime.utc(2099, 1, 1),
  );

  SnsPushProvider provider({
    required final http.Client httpClient,
    final String? androidPlatformApplicationArn = androidApp,
    final String? iosPlatformApplicationArn = iosApp,
    final SnsApnsEnvironment apnsEnvironment = SnsApnsEnvironment.production,
    final String? sessionToken,
  }) {
    return SnsPushProvider(
      region: region,
      accessKeyId: 'AKIATEST',
      secretAccessKey: 'test-secret',
      sessionToken: sessionToken,
      androidPlatformApplicationArn: androidPlatformApplicationArn,
      iosPlatformApplicationArn: iosPlatformApplicationArn,
      apnsEnvironment: apnsEnvironment,
      httpClient: httpClient,
    );
  }

  test('identityKeyFor returns the credential unchanged.', () {
    final sns = provider(
      httpClient: MockClient((final _) async => http.Response('', 500)),
    );
    expect(sns.identityKeyFor('abc'), 'abc');
    expect(sns.identityKeyFor(endpointArn), endpointArn);
  });

  test('when credentials are empty then construction throws.', () {
    expect(
      () => SnsPushProvider(
        region: '',
        accessKeyId: 'AKIATEST',
        secretAccessKey: 'test-secret',
      ),
      throwsA(isA<PushMissingCredentialsException>()),
    );
  });

  test(
    'when expiresAt is in the past then send returns expired without HTTP.',
    () async {
      var httpCalls = 0;
      final sns = provider(
        httpClient: MockClient((final _) async {
          httpCalls += 1;
          return http.Response('', 500);
        }),
      );

      final results = await sns.send(
        message: message(),
        requests: [request(expiresAt: DateTime.utc(2000))],
      );

      expect(results.single.outcome, PushDeliveryOutcome.expired);
      expect(httpCalls, 0);
    },
  );

  test(
    'when the platform is web then the outcome is permanentFailure.',
    () async {
      var httpCalls = 0;
      final sns = provider(
        httpClient: MockClient((final _) async {
          httpCalls += 1;
          return http.Response('', 500);
        }),
      );

      final results = await sns.send(
        message: message(),
        requests: [request(platform: PushPlatform.web)],
      );

      expect(results.single.outcome, PushDeliveryOutcome.permanentFailure);
      expect(results.single.errorCode, 'UNSUPPORTED_PLATFORM');
      expect(httpCalls, 0);
    },
  );

  test(
    'when a token has no platform application then the outcome is permanentFailure.',
    () async {
      var httpCalls = 0;
      final sns = provider(
        androidPlatformApplicationArn: null,
        httpClient: MockClient((final _) async {
          httpCalls += 1;
          return http.Response('', 500);
        }),
      );

      final results = await sns.send(
        message: message(),
        requests: [request()],
      );

      expect(results.single.outcome, PushDeliveryOutcome.permanentFailure);
      expect(results.single.errorCode, 'MISSING_PLATFORM_APPLICATION');
      expect(httpCalls, 0);
    },
  );

  test(
    'when SNS accepts a publish then the outcome is accepted and the payload is FCM v1.',
    () async {
      final seen = <http.Request>[];
      final sns = provider(
        httpClient: _script(seen, (final fields) {
          if (fields['Action'] == 'CreatePlatformEndpoint') {
            return _xml(
              '<CreatePlatformEndpointResponse>'
              '<CreatePlatformEndpointResult>'
              '<EndpointArn>$endpointArn</EndpointArn>'
              '</CreatePlatformEndpointResult>'
              '</CreatePlatformEndpointResponse>',
            );
          }
          return _publishOk('msg-1');
        }),
      );

      final results = await withClock(
        Clock.fixed(DateTime.utc(2026, 1, 2, 3, 4, 5)),
        () => sns.send(
          message: message(priority: PushPriority.high),
          requests: [
            request(
              dataOverlay: const {
                'k': 'overlay',
                pushDeliveryIdDataKey: 'delivery-1',
              },
            ),
          ],
        ),
      );

      expect(results.single.outcome, PushDeliveryOutcome.accepted);
      expect(results.single.providerMessageId, 'msg-1');
      expect(seen, hasLength(2));
      expect(seen.first.url.host, 'sns.us-east-1.amazonaws.com');
      expect(seen.first.headers['authorization'], contains('AWS4-HMAC-SHA256'));
      expect(seen.first.headers['x-amz-date'], '20260102T030405Z');

      final created = _form(seen.first.body);
      expect(created['Action'], 'CreatePlatformEndpoint');
      expect(created['PlatformApplicationArn'], androidApp);
      expect(created['Token'], 'device-token');

      final published = _form(seen.last.body);
      expect(published['Action'], 'Publish');
      expect(published['TargetArn'], endpointArn);
      expect(published['MessageStructure'], 'json');
      expect(
        published['MessageAttributes.entry.1.Name'],
        'AWS.SNS.MOBILE.FCM.TTL',
      );

      final envelope =
          jsonDecode(published['Message']!) as Map<String, dynamic>;
      final gcm =
          jsonDecode(envelope['GCM']! as String) as Map<String, dynamic>;
      final fcm = (gcm['fcmV1Message'] as Map)['message'] as Map;
      expect(fcm.containsKey('token'), isFalse);
      expect((fcm['notification'] as Map)['title'], 'Hello');
      expect((fcm['data'] as Map)['k'], 'overlay');
      expect((fcm['data'] as Map)[pushDeliveryIdDataKey], 'delivery-1');
      expect((fcm['android'] as Map)['priority'], 'HIGH');
      expect((fcm['android'] as Map)['ttl'], endsWith('s'));
    },
  );

  test(
    'a second send for the same token does not create another endpoint.',
    () async {
      var creates = 0;
      final sns = provider(
        httpClient: MockClient((final request) async {
          final fields = _form(request.body);
          if (fields['Action'] == 'CreatePlatformEndpoint') {
            creates += 1;
            return _xml(
              '<CreatePlatformEndpointResponse>'
              '<CreatePlatformEndpointResult>'
              '<EndpointArn>$endpointArn</EndpointArn>'
              '</CreatePlatformEndpointResult>'
              '</CreatePlatformEndpointResponse>',
            );
          }
          return _publishOk('msg-2');
        }),
      );

      await sns.send(message: message(), requests: [request()]);
      final results = await sns.send(message: message(), requests: [request()]);

      expect(results.single.outcome, PushDeliveryOutcome.accepted);
      expect(creates, 1);
    },
  );

  test(
    'when the endpoint already exists then attributes are updated before publish.',
    () async {
      final seen = <String>[];
      final sns = provider(
        httpClient: MockClient((final request) async {
          final action = _form(request.body)['Action']!;
          seen.add(action);
          if (action == 'CreatePlatformEndpoint') {
            return http.Response(
              '<ErrorResponse><Error>'
              '<Code>InvalidParameter</Code>'
              '<Message>Invalid parameter: Token Reason: Endpoint $endpointArn '
              'already exists with the same Token, but different attributes.</Message>'
              '</Error></ErrorResponse>',
              400,
            );
          }
          if (action == 'SetEndpointAttributes') {
            final fields = _form(request.body);
            expect(fields['Attributes.entry.1.key'], 'Token');
            expect(fields['Attributes.entry.1.value'], 'device-token');
            expect(fields['Attributes.entry.2.key'], 'Enabled');
            expect(fields['Attributes.entry.2.value'], 'true');
            return _xml('<SetEndpointAttributesResponse/>');
          }
          return _publishOk('msg-3');
        }),
      );

      final results = await sns.send(message: message(), requests: [request()]);

      expect(results.single.outcome, PushDeliveryOutcome.accepted);
      expect(seen, [
        'CreatePlatformEndpoint',
        'SetEndpointAttributes',
        'Publish',
      ]);
    },
  );

  test(
    'an endpoint ARN credential is published without creating an endpoint.',
    () async {
      final seen = <String>[];
      final sns = provider(
        androidPlatformApplicationArn: null,
        httpClient: MockClient((final request) async {
          seen.add(_form(request.body)['Action']!);
          return _publishOk('msg-4');
        }),
      );

      final results = await sns.send(
        message: message(),
        requests: [request(credential: endpointArn)],
      );

      expect(results.single.outcome, PushDeliveryOutcome.accepted);
      expect(seen, ['Publish']);
    },
  );

  test('an iOS send uses the APNS payload and TTL attribute.', () async {
    final seen = <http.Request>[];
    final sns = provider(
      httpClient: _script(seen, (final fields) {
        if (fields['Action'] == 'CreatePlatformEndpoint') {
          expect(fields['PlatformApplicationArn'], iosApp);
          return _xml(
            '<CreatePlatformEndpointResponse>'
            '<CreatePlatformEndpointResult>'
            '<EndpointArn>arn:aws:sns:us-east-1:123456789012:endpoint/APNS/ios-app/u</EndpointArn>'
            '</CreatePlatformEndpointResult>'
            '</CreatePlatformEndpointResponse>',
          );
        }
        return _publishOk('msg-ios');
      }),
    );

    await sns.send(
      message: message(priority: PushPriority.high),
      requests: [
        request(credential: 'apns-token', platform: PushPlatform.ios),
      ],
    );

    final published = _form(seen.last.body);
    expect(
      published['MessageAttributes.entry.1.Name'],
      'AWS.SNS.MOBILE.APNS.TTL',
    );
    expect(
      published['MessageAttributes.entry.2.Name'],
      'AWS.SNS.MOBILE.APNS.PRIORITY',
    );
    expect(published['MessageAttributes.entry.2.Value.StringValue'], '10');
    final envelope = jsonDecode(published['Message']!) as Map<String, dynamic>;
    expect(envelope.containsKey('APNS'), isTrue);
    expect(envelope.containsKey('GCM'), isFalse);
    final apns =
        jsonDecode(envelope['APNS']! as String) as Map<String, dynamic>;
    expect((apns['aps'] as Map)['alert'], {'title': 'Hello', 'body': 'World'});
  });

  test('sandbox APNs uses the APNS_SANDBOX key.', () async {
    final seen = <http.Request>[];
    final sns = provider(
      apnsEnvironment: SnsApnsEnvironment.sandbox,
      httpClient: _script(seen, (final fields) {
        if (fields['Action'] == 'CreatePlatformEndpoint') {
          return _xml(
            '<CreatePlatformEndpointResponse>'
            '<CreatePlatformEndpointResult>'
            '<EndpointArn>arn:aws:sns:us-east-1:123456789012:endpoint/APNS_SANDBOX/ios-app/u</EndpointArn>'
            '</CreatePlatformEndpointResult>'
            '</CreatePlatformEndpointResponse>',
          );
        }
        return _publishOk('msg-sandbox');
      }),
    );

    await sns.send(
      message: message(),
      requests: [request(platform: PushPlatform.ios)],
    );

    final published = _form(seen.last.body);
    final envelope = jsonDecode(published['Message']!) as Map<String, dynamic>;
    expect(envelope.containsKey('APNS_SANDBOX'), isTrue);
    expect(
      published['MessageAttributes.entry.1.Name'],
      'AWS.SNS.MOBILE.APNS_SANDBOX.TTL',
    );
  });

  test(
    'when SNS returns EndpointDisabled then the outcome is invalidToken.',
    () async {
      final sns = provider(
        httpClient: _snsError(
          code: 'EndpointDisabled',
          message: 'Endpoint is disabled',
          status: 400,
        ),
      );

      final results = await sns.send(
        message: message(),
        requests: [request(credential: endpointArn)],
      );

      expect(results.single.outcome, PushDeliveryOutcome.invalidToken);
      expect(results.single.errorCode, 'EndpointDisabled');
    },
  );

  test(
    'when SNS returns Throttling then the outcome is rateLimited and retryAfter is parsed.',
    () async {
      final sns = provider(
        httpClient: _snsError(
          code: 'Throttling',
          message: 'Rate exceeded',
          status: 400,
          headers: {'retry-after': '12'},
        ),
      );

      final results = await sns.send(
        message: message(),
        requests: [request(credential: endpointArn)],
      );

      expect(results.single.outcome, PushDeliveryOutcome.rateLimited);
      expect(results.single.errorCode, 'Throttling');
      expect(results.single.retryAfter, const Duration(seconds: 12));
    },
  );

  test(
    'when SNS returns AuthorizationError then the outcome is retryable UNAUTHENTICATED.',
    () async {
      final sns = provider(
        httpClient: _snsError(
          code: 'AuthorizationError',
          message: 'not allowed',
          status: 403,
        ),
      );

      final results = await sns.send(
        message: message(),
        requests: [request(credential: endpointArn)],
      );

      expect(results.single.outcome, PushDeliveryOutcome.retryable);
      expect(results.single.errorCode, 'UNAUTHENTICATED');
    },
  );

  test(
    'when SNS returns AccessDenied then the outcome is retryable PERMISSION_DENIED.',
    () async {
      final sns = provider(
        httpClient: _snsError(
          code: 'AccessDeniedException',
          message: 'denied',
          status: 403,
        ),
      );

      final results = await sns.send(
        message: message(),
        requests: [request(credential: endpointArn)],
      );

      expect(results.single.outcome, PushDeliveryOutcome.retryable);
      expect(results.single.errorCode, 'PERMISSION_DENIED');
    },
  );

  test(
    'when SNS returns InvalidParameter then the outcome is permanentFailure.',
    () async {
      final sns = provider(
        httpClient: _snsError(
          code: 'InvalidParameter',
          message: 'Message structure is invalid',
          status: 400,
        ),
      );

      final results = await sns.send(
        message: message(),
        requests: [request(credential: endpointArn)],
      );

      expect(results.single.outcome, PushDeliveryOutcome.permanentFailure);
      expect(results.single.errorCode, 'InvalidParameter');
    },
  );

  test(
    'when the platform application is disabled then the outcome is retryable.',
    () async {
      final sns = provider(
        httpClient: _snsError(
          code: 'PlatformApplicationDisabled',
          message: 'Platform application is disabled',
          status: 400,
        ),
      );

      final results = await sns.send(
        message: message(),
        requests: [request(credential: endpointArn)],
      );

      expect(results.single.outcome, PushDeliveryOutcome.retryable);
      expect(results.single.errorCode, 'PlatformApplicationDisabled');
    },
  );

  test('when SNS returns 500 then the outcome is retryable.', () async {
    final sns = provider(
      httpClient: _snsError(
        code: 'InternalError',
        message: 'try again',
        status: 500,
      ),
    );

    final results = await sns.send(
      message: message(),
      requests: [request(credential: endpointArn)],
    );

    expect(results.single.outcome, PushDeliveryOutcome.retryable);
    expect(results.single.errorCode, 'InternalError');
  });

  test('payloadBytesFor measures the embedded platform payload.', () {
    final sns = provider(
      httpClient: MockClient((final _) async => http.Response('', 500)),
    );
    final bytes = sns.payloadBytesFor(
      PushMessage(
        data: const {'hello': 'world'},
        priority: PushPriority.normal,
      ),
      const {pushDeliveryIdDataKey: '00000000-0000-0000-0000-000000000000'},
    );
    expect(bytes, greaterThan(0));
    expect(bytes, lessThan(sns.maxPayloadBytes));

    final oversized = sns.payloadBytesFor(
      PushMessage(
        data: {'k': 'x' * 5000},
        priority: PushPriority.normal,
      ),
      const {},
    );
    expect(oversized, greaterThan(sns.maxPayloadBytes));
  });
}

MockClient _script(
  final List<http.Request> seen,
  final http.Response Function(Map<String, String> fields) handle,
) {
  return MockClient((final request) async {
    seen.add(request);
    return handle(_form(request.body));
  });
}

MockClient _snsError({
  required final String code,
  required final String message,
  required final int status,
  final Map<String, String> headers = const {},
}) {
  return MockClient((final request) async {
    final action = _form(request.body)['Action'];
    if (action == 'CreatePlatformEndpoint') {
      return _xml(
        '<CreatePlatformEndpointResponse>'
        '<CreatePlatformEndpointResult>'
        '<EndpointArn>arn:aws:sns:us-east-1:123456789012:endpoint/GCM/android-app/uuid-1</EndpointArn>'
        '</CreatePlatformEndpointResult>'
        '</CreatePlatformEndpointResponse>',
      );
    }
    return http.Response(
      '<ErrorResponse><Error><Code>$code</Code><Message>$message</Message></Error></ErrorResponse>',
      status,
      headers: headers,
    );
  });
}

http.Response _publishOk(final String messageId) {
  return _xml(
    '<PublishResponse><PublishResult><MessageId>$messageId</MessageId></PublishResult></PublishResponse>',
  );
}

http.Response _xml(final String body) => http.Response(body, 200);

Map<String, String> _form(final String body) {
  return {
    for (final pair in body.split('&'))
      Uri.decodeComponent(pair.substring(0, pair.indexOf('='))):
          Uri.decodeComponent(pair.substring(pair.indexOf('=') + 1)),
  };
}
