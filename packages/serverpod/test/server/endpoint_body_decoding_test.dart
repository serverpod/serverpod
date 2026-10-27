import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:serverpod/serverpod.dart';
import 'package:serverpod/src/generated/protocol.dart' as internal;
import 'package:test/test.dart';

class _EchoEndpoint extends Endpoint {}

class _EchoEndpoints extends EndpointDispatch {
  @override
  void initializeEndpoints(Server server) {
    final endpoint = _EchoEndpoint()..initialize(server, 'echo', null);
    connectors['echo'] = EndpointConnector(
      name: 'echo',
      endpoint: endpoint,
      methodConnectors: {
        'echo': MethodConnector(
          name: 'echo',
          params: {
            'text': ParameterDescription(
              name: 'text',
              type: getType<String>(),
              nullable: false,
            ),
          },
          call: (session, params) async => params['text'] as String,
        ),
      },
    );
  }
}

void main() {
  group(
    'Given a started Serverpod with an echo endpoint and a 64 byte maximum request size,',
    () {
      late Serverpod pod;
      late Uri echoUri;

      setUp(() async {
        pod = Serverpod(
          [],
          internal.Protocol(),
          _EchoEndpoints(),
          config: ServerpodConfig(
            apiServer: ServerConfig(
              port: 0,
              publicScheme: 'http',
              publicHost: 'localhost',
              publicPort: 0,
            ),
            maxRequestSize: 64,
          ),
        );
        await pod.start(runInGuardedZone: false);
        echoUri = Uri.parse('http://localhost:${pod.server.port}/echo/echo');
      });

      tearDown(() async {
        await pod.shutdown(exitProcess: false);
      });

      test(
        'when a JSON body with non-ASCII text is posted, '
        'then the argument is decoded and echoed as UTF-8 JSON',
        () async {
          final response = await http.post(
            echoUri,
            body: jsonEncode({'text': 'Jørgen \u{1F600}'}),
            headers: {HttpHeaders.contentTypeHeader: 'application/json'},
          );

          expect(response.statusCode, HttpStatus.ok);
          expect(
            response.headers[HttpHeaders.contentTypeHeader],
            'application/json; charset=utf-8',
          );
          expect(
            jsonDecode(utf8.decode(response.bodyBytes)),
            'Jørgen \u{1F600}',
          );
        },
      );

      test(
        'when a malformed JSON body is posted, '
        'then the response is 400 with an invalid JSON message',
        () async {
          final response = await http.post(echoUri, body: '{"text": ');

          expect(response.statusCode, HttpStatus.badRequest);
          expect(response.body, 'Invalid JSON in body');
        },
      );

      test(
        'when a JSON array body is posted, '
        'then the response is 400 with an invalid JSON message',
        () async {
          final response = await http.post(echoUri, body: '[1]');

          expect(response.statusCode, HttpStatus.badRequest);
          expect(response.body, 'Invalid JSON in body');
        },
      );

      test(
        'when the literal null is posted, '
        'then the response is 400 with a missing parameter message',
        () async {
          final response = await http.post(echoUri, body: 'null');

          expect(response.statusCode, HttpStatus.badRequest);
          expect(response.body, 'Missing required query parameter: text');
        },
      );

      test(
        'when the body exceeds the maximum request size, '
        'then the response is 413',
        () async {
          final response = await http.post(
            echoUri,
            body: jsonEncode({'text': 'x' * 100}),
          );

          expect(response.statusCode, HttpStatus.requestEntityTooLarge);
        },
      );
    },
  );
}
