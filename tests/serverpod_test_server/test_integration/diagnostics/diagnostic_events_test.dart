import 'dart:async';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:test/test.dart';

import 'package:serverpod/serverpod.dart';

import 'package:serverpod_test_client/serverpod_test_client.dart';
import 'package:serverpod_test_server/src/futureCalls/test_exception_call.dart';
import 'package:serverpod_test_server/test_util/test_serverpod.dart';

import 'test_exception_handler.dart';

class ExceptionRoute extends WidgetRoute {
  @override
  Future<Widget> build(Session session, HttpRequest request) async {
    throw UnimplementedError('ExceptionRoute not implemented');
  }
}

void main() {
  const timeout = Duration(seconds: 3);

  group('Given a serverpod server with a diagnostic event handler,', () {
    var exceptionHandler = TestExceptionHandler();
    Serverpod? pod;

    setUp(() async {
      exceptionHandler = TestExceptionHandler();
    });

    tearDown(() async {
      await pod?.shutdown(exitProcess: false);
      exceptionHandler.eventsStreamController.close();
    });

    test(
        'when starting serverpod with its web server port already in use '
        'then the diagnostic event handler gets called', () async {
      final config = ServerpodConfig(
        runMode: 'invalid',
        apiServer: ServerConfig(
          port: 8080,
          publicHost: 'localhost',
          publicPort: 8080,
          publicScheme: 'http',
        ),
        webServer: ServerConfig(
          port: 8080,
          publicHost: 'localhost',
          publicPort: 8081,
          publicScheme: 'http',
        ),
      );
      pod = IntegrationTestServer.create(
        config: config,
        experimentalFeatures: ExperimentalFeatures(
          unstableDiagnosticEventHandlers: [exceptionHandler],
        ),
      );
      pod?.webServer.addRoute(ExceptionRoute(), '/exception');
      final result = pod
          ?.start(runInGuardedZone: false)
          .timeout(const Duration(seconds: 5));
      await expectLater(result, throwsA(isA<ExitException>()));

      final record = await exceptionHandler.events.first.timeout(timeout);
      expect(record.event.exception, isA<Exception>());
      expect(record.space, equals(OriginSpace.framework));
      expect(record.context, isA<DiagnosticEventContext>());
      expect(
          record.context.toJson(),
          allOf([
            containsPair('serverId', 'default'),
            containsPair('serverName', 'Server default'),
            containsPair('serverRunMode', 'production'),
          ]));
    });
  });

  group(
      'Given a serverpod server with future calls and a diagnostic event handler',
      () {
    var client = Client('http://localhost:8080/');
    var exceptionHandler = TestExceptionHandler();
    late Serverpod pod;

    setUp(() async {
      exceptionHandler = TestExceptionHandler();
      pod = IntegrationTestServer.create(
        experimentalFeatures: ExperimentalFeatures(
        unstableDiagnosticEventHandlers: [exceptionHandler],
        ),
      );
      pod.registerFutureCall(TestExceptionCall(), 'testExceptionCall');
      await pod.start();
    });

    tearDown(() async {
      await pod.shutdown(exitProcess: false);
      exceptionHandler.eventsStreamController.close();
    });

    test(
        'when a client calls an endpoint method that schedules a future call that throws '
        'then the diagnostic event handler gets called', () async {
      await client.futureCalls.makeFutureCallThatThrows(SimpleData(num: 42));

      final record = await exceptionHandler.events.first
          .timeout(const Duration(seconds: 6));
      expect(record.event.exception, isA<Exception>());
      expect(record.space, equals(OriginSpace.application));
      expect(record.context, isA<FutureCallOpContext>());
    });
  });

  group('Given a serverpod server with a diagnostic event handler', () {
    var client = Client('http://localhost:8080/');
    var exceptionHandler = TestExceptionHandler();
    late Serverpod pod;

    setUp(() async {
      exceptionHandler = TestExceptionHandler();
      pod = IntegrationTestServer.create(
        experimentalFeatures: ExperimentalFeatures(
        unstableDiagnosticEventHandlers: [exceptionHandler],
        ),
      );
      await pod.start();
    });

    tearDown(() async {
      await pod.shutdown(exitProcess: false);
      exceptionHandler.eventsStreamController.close();
    });

    test(
        'when a client calls an endpoint method that throws an exception '
        'then the diagnostic event handler gets called', () async {
      final result = client.exceptionTest.throwNormalException();
      await expectLater(result, throwsA(isA<Exception>()));

      // expect(exceptionHandler.stream.length, 1);
      final record = await exceptionHandler.events.first.timeout(timeout);
      print(record.toString());

      expect(record.event.exception, isA<Exception>());
      expect(record.space, equals(OriginSpace.application));
      expect(record.context, isA<MethodCallOpContext>());
      expect(
          record.context.toJson(),
          allOf([
            containsPair('serverId', 'default'),
            containsPair('serverName', 'Server default'),
            containsPair('serverRunMode', 'production'),
            containsPair('operationType', 'OperationType.method'),
            contains('sessionId'),
            containsPair('userAuthInfo', null),
            contains('connectionInfo'),
            containsPair('uri', 'http://localhost:8080/exceptionTest'),
            containsPair('endpoint', 'exceptionTest'),
            containsPair('methodName', 'throwNormalException'),
          ]));
    });

    test(
        'when a client calls streaming method outStreamThrowsException '
        'then the diagnostic event handler gets called', () async {
      final stream = client.methodStreaming.outStreamThrowsException();
      // print('Stream: ${await stream.first}');
      await expectLater(stream, emitsError(isA<ConnectionClosedException>()));

      await Future.delayed(const Duration(seconds: 1));

      final record = await exceptionHandler.events.first.timeout(timeout);
      print(record.toString());

      expect(record.event.exception, isA<Exception>());
      expect(record.space, equals(OriginSpace.application));
      expect(record.context, isA<StreamOpContext>());
    });

    test(
        'when a client calls streaming method outStreamThrowsSerializableException '
        'then the diagnostic event handler gets called', () async {
      var stream =
          client.methodStreaming.outStreamThrowsSerializableException();
      await expectLater(stream, emitsError(isA<ExceptionWithData>()));

      final record = await exceptionHandler.events.first.timeout(timeout);
      expect(record.event.exception, isA<Exception>());
      expect(record.space, equals(OriginSpace.application));
      expect(record.context, isA<StreamOpContext>());
    });

    test(
        'when a client calls streaming method exceptionThrownBeforeStreamReturn '
        'then the diagnostic event handler gets called', () async {
      var stream = client.methodStreaming.exceptionThrownBeforeStreamReturn();
      await expectLater(stream, emitsError(isA<ConnectionClosedException>()));

      final record = await exceptionHandler.events.first.timeout(timeout);
      expect(record.event.exception, isA<Exception>());
      expect(record.space, equals(OriginSpace.application));
      expect(record.context, isA<StreamOpContext>());
    });

    test(
        'when a client calls streaming method exceptionThrownInStreamReturn '
        'then the diagnostic event handler gets called', () async {
      var stream = client.methodStreaming.exceptionThrownInStreamReturn();
      await expectLater(stream, emitsError(isA<ConnectionClosedException>()));

      final record = await exceptionHandler.events.first.timeout(timeout);
      expect(record.event.exception, isA<Exception>());
      expect(record.space, equals(OriginSpace.application));
      expect(record.context, isA<StreamOpContext>());
    });

    test(
        'when a client calls method url with malformed json '
        'then the diagnostic event handler gets called', () async {
      var response = http.post(
        Uri.parse('http://localhost:8080/simple/hello'),
        body: '{"name": [42]}',
      );
      await response;
      // print('Response: ${response.statusCode} ${response.body}');

      final record = await exceptionHandler.events.first.timeout(timeout);
      print(record.toString());
      expect(record.space, equals(OriginSpace.application));
      expect(record.context, isA<MethodCallOpContext>());
    });
  });

  group(
      'Given a serverpod server with a web route and a diagnostic event handler',
      () {
    var exceptionHandler = TestExceptionHandler();
    late Serverpod pod;

    setUp(() async {
      exceptionHandler = TestExceptionHandler();
      pod = IntegrationTestServer.create(
        experimentalFeatures: ExperimentalFeatures(
        unstableDiagnosticEventHandlers: [exceptionHandler],
        ),
      );
      pod.webServer.addRoute(ExceptionRoute(), '/exception');
      await pod.start();
    });

    tearDown(() async {
      await pod.shutdown(exitProcess: false);
      exceptionHandler.eventsStreamController.close();
    });

    test(
        'when a client calls web url with malformed json '
        'then the diagnostic event handler gets called', () async {
      var response = http.post(
        Uri.parse('http://localhost:8082/exception'),
      );
      await response;

      final record = await exceptionHandler.events.first.timeout(timeout);
      // print(record.toString());
      expect(record.event.exception, isA<UnimplementedError>());
      expect(record.space, equals(OriginSpace.application));
      expect(record.context, isA<WebCallOpContext>());
    });
  });
}
