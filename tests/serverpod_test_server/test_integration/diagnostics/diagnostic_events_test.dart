import 'dart:async';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:test/test.dart';

import 'package:serverpod/serverpod.dart';

import 'package:serverpod_test_client/serverpod_test_client.dart';
import 'package:serverpod_test_server/src/futureCalls/test_exception_call.dart';
import 'package:serverpod_test_server/test_util/test_serverpod.dart';

import 'test_exception_handler.dart';

class ExceptionRoute extends ComponentRoute {
  @override
  Future<Component> build(Session session, HttpRequest request) async {
    throw UnimplementedError('ExceptionRoute not implemented');
  }
}

void main() {
  const timeout = Duration(seconds: 3);

  group(
      'Given a serverpod server with a diagnostic event handler, '
      'when starting serverpod with its web server port already in use', () {
    var exceptionHandler = TestExceptionHandler();
    late Serverpod pod;
    late DiagnosticEventRecord<ExceptionEvent> record;

    setUpAll(() async {
      exceptionHandler = TestExceptionHandler();

      final config = ServerpodConfig(
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
          diagnosticEventHandlers: [exceptionHandler],
        ),
      );
      pod.webServer.addRoute(ExceptionRoute(), '/exception');
      final result = pod
          .start(runInGuardedZone: false)
          .timeout(const Duration(seconds: 5));
      await expectLater(result, throwsA(isA<ExitException>()));
      record = await exceptionHandler.events.first.timeout(timeout);
    });

    tearDownAll(() async {
      await pod.shutdown(exitProcess: false);
      exceptionHandler.eventsStreamController.close();
    });

    test('then the diagnostic event handler gets called with a SocketException',
        () async {
      expect(record.event.exception, isA<SocketException>());
    });

    test('then the diagnostic event exception message is correct', () async {
      expect((record.event.exception as SocketException).message,
          contains('Failed to create server socket'));
    });

    test('then the diagnostic event space is framework', () async {
      expect(record.space, equals(OriginSpace.framework));
    });

    test('then the diagnostic event context is a DiagnosticEventContext',
        () async {
      expect(record.context.runtimeType, DiagnosticEventContext);
    });

    test('then the diagnostic event context has the expected content',
        () async {
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
          diagnosticEventHandlers: [exceptionHandler],
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
          diagnosticEventHandlers: [exceptionHandler],
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

      final record = await exceptionHandler.events.first.timeout(timeout);
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
      await expectLater(stream, emitsError(isA<ConnectionClosedException>()));

      await Future.delayed(const Duration(seconds: 1));

      final record = await exceptionHandler.events.first.timeout(timeout);

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

      final record = await exceptionHandler.events.first.timeout(timeout);
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
          diagnosticEventHandlers: [exceptionHandler],
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
      expect(record.event.exception, isA<UnimplementedError>());
      expect(record.space, equals(OriginSpace.application));
      expect(record.context, isA<WebCallOpContext>());
    });
  });

  group(
      'Given a serverpod server with a diagnostic event handler and a missing database, '
      'when starting serverpod', () {
    var exceptionHandler = TestExceptionHandler();
    late Serverpod pod;
    late DiagnosticEventRecord<ExceptionEvent> record;

    setUpAll(() async {
      exceptionHandler = TestExceptionHandler();

      final config = ServerpodConfig(
        database: DatabaseConfig(
          host: 'localhost',
          port: 9999,
          user: 'postgres',
          password: 'postgres',
          name: 'postgres',
        ),
        apiServer: ServerConfig(
          port: 8080,
          publicHost: 'localhost',
          publicPort: 8080,
          publicScheme: 'http',
        ),
      );
      pod = IntegrationTestServer.create(
        config: config,
        experimentalFeatures: ExperimentalFeatures(
          diagnosticEventHandlers: [exceptionHandler],
        ),
      );
      final result = pod
          .start(runInGuardedZone: false)
          .timeout(const Duration(seconds: 2));
      await expectLater(result, throwsA(isA<TimeoutException>()));
      record = await exceptionHandler.events.first.timeout(timeout);
    });

    tearDownAll(() async {
      await pod.shutdown(exitProcess: false);
      exceptionHandler.eventsStreamController.close();
    });

    test('then the diagnostic event handler gets called with a Exception',
        () async {
      expect(record.event.exception, isA<SocketException>());
    });

    test('then the diagnostic event exception message is correct', () async {
      expect((record.event.exception as SocketException).message,
          contains('Connection refused'));
    });

    test('then the diagnostic event message is correct', () async {
      expect(record.event.message,
          startsWith('Failed to connect to the database'));
    });

    test('then the diagnostic event space is framework', () async {
      expect(record.space, equals(OriginSpace.framework));
    });

    test('then the diagnostic event context is a DiagnosticEventContext',
        () async {
      expect(record.context.runtimeType, DiagnosticEventContext);
    });

    test('then the diagnostic event context has the expected content',
        () async {
      expect(
          record.context.toJson(),
          allOf([
            containsPair('serverId', 'default'),
            containsPair('serverName', ''),
            containsPair('serverRunMode', 'production'),
          ]));
    });
  });
}
