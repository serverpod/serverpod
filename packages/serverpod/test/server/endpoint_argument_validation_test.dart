import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:serverpod/serverpod.dart';
import 'package:serverpod/src/generated/protocol.dart' as internal;
import 'package:test/test.dart';

class _ArgumentsEndpoint extends Endpoint {}

MethodConnector _singleArgumentMethod<T>(String name) => MethodConnector(
  name: name,
  params: {
    'value': ParameterDescription(
      name: 'value',
      type: getType<T>(),
      nullable: false,
    ),
  },
  call: (session, params) async => params['value'].toString(),
);

class _ArgumentsEndpoints extends EndpointDispatch {
  @override
  void initializeEndpoints(Server server) {
    final endpoint = _ArgumentsEndpoint()
      ..initialize(server, 'arguments', null);
    connectors['arguments'] = EndpointConnector(
      name: 'arguments',
      endpoint: endpoint,
      methodConnectors: {
        'int': _singleArgumentMethod<int>('int'),
        'dateTime': _singleArgumentMethod<DateTime>('dateTime'),
        'uuid': _singleArgumentMethod<UuidValue>('uuid'),
        'throwing': MethodConnector(
          name: 'throwing',
          params: {},
          call: (session, params) async => throw StateError('endpoint failed'),
        ),
      },
    );
  }
}

void main() {
  group('Given a started Serverpod with typed endpoint arguments,', () {
    late Serverpod pod;

    Future<http.Response> post(String method, Object? value) => http.post(
      Uri.parse('http://localhost:${pod.server.port}/arguments/$method'),
      body: jsonEncode({'value': value}),
      headers: {HttpHeaders.contentTypeHeader: 'application/json'},
    );

    setUp(() async {
      pod = Serverpod(
        [],
        internal.Protocol(),
        _ArgumentsEndpoints(),
        config: ServerpodConfig(
          apiServer: ServerConfig(
            port: 0,
            publicScheme: 'http',
            publicHost: 'localhost',
            publicPort: 0,
          ),
        ),
      );
      await pod.start(runInGuardedZone: false);
    });

    tearDown(() async {
      await pod.shutdown(exitProcess: false);
    });

    test(
      'when a String is posted for an int argument, '
      'then the response is 400 without the value',
      () async {
        final response = await post('int', 'not an int');

        expect(response.statusCode, HttpStatus.badRequest);
        expect(response.body, 'Invalid value for parameter: value');
      },
    );

    test(
      'when a malformed date is posted for a DateTime argument, '
      'then the response is 400 without the value',
      () async {
        final response = await post('dateTime', 'not-a-date');

        expect(response.statusCode, HttpStatus.badRequest);
        expect(response.body, 'Invalid value for parameter: value');
      },
    );

    test(
      'when a malformed UUID is posted for a UuidValue argument, '
      'then the response is 400 without the value',
      () async {
        final response = await post('uuid', 'not-a-uuid');

        expect(response.statusCode, HttpStatus.badRequest);
        expect(response.body, 'Invalid value for parameter: value');
      },
    );

    test(
      'when a valid int is posted for an int argument, '
      'then the response is 200',
      () async {
        final response = await post('int', 42);

        expect(response.statusCode, HttpStatus.ok);
        expect(jsonDecode(response.body), '42');
      },
    );

    test(
      'when the endpoint method throws, '
      'then the response is 500',
      () async {
        final response = await http.post(
          Uri.parse('http://localhost:${pod.server.port}/arguments/throwing'),
          body: '{}',
        );

        expect(response.statusCode, HttpStatus.internalServerError);
      },
    );
  });
}
