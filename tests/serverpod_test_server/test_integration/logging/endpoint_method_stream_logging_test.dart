import 'dart:async';

import 'package:serverpod/serverpod.dart';
import 'package:serverpod_test_client/serverpod_test_client.dart';
import 'package:serverpod_test_server/test_util/builders/log_settings_builder.dart';
import 'package:serverpod_test_server/test_util/builders/runtime_settings_builder.dart';
import 'package:serverpod_test_server/test_util/logging_utils.dart';
import 'package:serverpod_test_server/test_util/test_serverpod.dart';
import 'package:test/test.dart';

Future<T> awaitFirstWithoutClosingStream<T>(Stream<T> stream) async {
  var completer = Completer<T>();
  stream.listen((event) {
    completer.complete(event);
  });
  return completer.future;
}

void main() async {
  var client = Client('http://localhost:8080/');
  late Serverpod server;
  late Session session;

  setUp(() async {
    server = IntegrationTestServer.create();
    await server.start();

    session = await server.createSession(enableLogging: false);
    await LoggingUtil.clearAllLogs(session);
  });

  tearDown(() async {
    await client.closeStreamingMethodConnections(exception: null);
    client.close();
    await await session.close();
    await server.shutdown(exitProcess: false);
  });

  group('Given that continuous logging is turned on', () {
    setUp(() async {
      var settings = RuntimeSettingsBuilder()
          .withLogSettings(LogSettingsBuilder()
              .withLogStreamingSessionsContinuously(true)
              .build())
          .build();
      await server.updateRuntimeSettings(settings);
    });

    test(
        'when sending a stream message without closing the connection then the log is created.',
        () async {
      var controller = StreamController<int>();
      var outputStream = client.logging.streamEmpty(controller.stream);

      controller.add(1);
      await awaitFirstWithoutClosingStream(outputStream);

      // Wait for the log to be written
      await Future.delayed(Duration(milliseconds: 100));

      var logs = await LoggingUtil.findAllLogs(session);

      expect(logs, hasLength(1));
      expect(logs.first.sessionLogEntry.isOpen, isTrue);
    });

    test(
        'when sending a stream message and closing the connection then the log is created.',
        () async {
      var controller = StreamController<int>();
      var outputStream = client.logging.streamEmpty(controller.stream);

      controller.add(1);
      await outputStream.first;

      // Wait for the log to be written
      await Future.delayed(Duration(milliseconds: 100));

      var logs = await LoggingUtil.findAllLogs(session);

      expect(logs, hasLength(1));
      expect(logs.first.sessionLogEntry.isOpen, isFalse);
    });

    test(
        'when sending a stream message and writing a log without closing then the log is attached to the log session.',
        () async {
      var controller = StreamController<int>();
      var outputStream = await client.logging.streamLogging(controller.stream);

      controller.add(1);
      await awaitFirstWithoutClosingStream(outputStream);

      // Wait for the log to be written
      await Future.delayed(Duration(milliseconds: 100));

      var logs = await LoggingUtil.findAllLogs(session);

      expect(logs, hasLength(1));
      expect(logs.first.logs, hasLength(1));
    });

    test(
        'when sending a stream message triggering a query without closing the stream then a query log is written.',
        () async {
      var controller = StreamController<int>();
      var outputStream = client.logging.streamQueryLogging(controller.stream);

      controller.add(1);
      await awaitFirstWithoutClosingStream(outputStream);

      // Wait for the log to be written
      await Future.delayed(Duration(milliseconds: 100));

      var logs = await LoggingUtil.findAllLogs(session);

      expect(logs, hasLength(1));
      expect(logs.first.queries, hasLength(1));
    });

    test(
        'but logging all sessions is turned off when sending a stream message without closing the connection no log entries are created.',
        () async {
      var settings = RuntimeSettingsBuilder()
          .withLogSettings(LogSettingsBuilder()
              .withLogAllSessions(false)
              .withLogStreamingSessionsContinuously(true)
              .build())
          .build();
      await server.updateRuntimeSettings(settings);

      var controller = StreamController<int>();
      var outputStream = client.logging.streamEmpty(controller.stream);

      controller.add(1);
      await awaitFirstWithoutClosingStream(outputStream);

      // Wait for the log to be written
      await Future.delayed(Duration(milliseconds: 100));

      var logs = await LoggingUtil.findAllLogs(session);

      expect(logs, isEmpty);
    });

    test(
        'when connecting to a stream method that throws an exception then session logs error.',
        () async {
      var stream = client.logging.streamException();

      await expectLater(
        stream,
        emitsError(isA<ConnectionClosedException>()),
      );

      // Wait for the log to be written
      await Future.delayed(Duration(milliseconds: 100));
      var logs = await LoggingUtil.findAllLogs(session);

      expect(logs, hasLength(1));
      var log = logs.firstOrNull;
      expect(log?.sessionLogEntry.error, isNotNull);
    });
  });

  group('Given that continuous logging is turned off', () {
    setUp(() async {
      var settings = RuntimeSettingsBuilder()
          .withLogSettings(LogSettingsBuilder()
              .withLogStreamingSessionsContinuously(false)
              .build())
          .build();
      await server.updateRuntimeSettings(settings);
    });

    test(
        'when sending a stream message without closing the connection no log entries are created.',
        () async {
      var controller = StreamController<int>();
      var outputStream = client.logging.streamEmpty(controller.stream);

      controller.add(1);
      await awaitFirstWithoutClosingStream(outputStream);

      // Wait for the log to be written
      await Future.delayed(Duration(milliseconds: 100));

      var logs = await LoggingUtil.findAllLogs(session);

      expect(logs, isEmpty);
    });

    test(
        'when sending a stream message and then closing the connection a log entry is created.',
        () async {
      var settings = RuntimeSettingsBuilder()
          .withLogSettings(LogSettingsBuilder()
              .withLogStreamingSessionsContinuously(false)
              .build())
          .build();

      await server.updateRuntimeSettings(settings);

      var controller = StreamController<int>();
      var outputStream = client.logging.streamEmpty(controller.stream);

      controller.add(1);
      await outputStream.first;

      // Wait for the log to be written
      await Future.delayed(Duration(milliseconds: 100));

      var logs = await LoggingUtil.findAllLogs(session);

      expect(logs, hasLength(1));
      expect(logs.first.sessionLogEntry.isOpen, isFalse);
    });

    test(
        'and logging all sessions is turned off when sending a stream message and closing the connection no log entries are created.',
        () async {
      var settings = RuntimeSettingsBuilder()
          .withLogSettings(LogSettingsBuilder()
              .withLogAllSessions(false)
              .withLogStreamingSessionsContinuously(false)
              .build())
          .build();
      await server.updateRuntimeSettings(settings);

      var controller = StreamController<int>();
      var outputStream = client.logging.streamEmpty(controller.stream);

      controller.add(1);
      await outputStream.first;

      // Wait for the log to be written
      await Future.delayed(Duration(milliseconds: 100));

      var logs = await LoggingUtil.findAllLogs(session);

      expect(logs, isEmpty);
    });
  });

  test(
      'Given that all logging is turned down when sending a stream message and then closing the connection no logs are written.',
      () async {
    var settings = RuntimeSettingsBuilder()
        .withLogSettings(LogSettingsBuilder().withLoggingTurnedDown().build())
        .build();

    await server.updateRuntimeSettings(settings);

    var controller = StreamController<int>();
    var outputStream = client.logging.streamEmpty(controller.stream);

    controller.add(1);
    await outputStream.first;

    // Wait for the log to potentially be written
    await Future.delayed(Duration(milliseconds: 100));

    var logs = await LoggingUtil.findAllLogs(session);

    expect(logs, isEmpty);
  });

  test(
      'Given that all logging is turned down but an override for the endpoint when sending a stream message to that endpoint and then closing the connection the logs are written.',
      () async {
    var settings = RuntimeSettingsBuilder()
        .withLogSettings(LogSettingsBuilder().withLoggingTurnedDown().build())
        .withLogSettingsOverride(
          endpoint: 'logging',
          logSettings: LogSettingsBuilder().build(),
        )
        .build();

    await server.updateRuntimeSettings(settings);

    var controller = StreamController<int>();
    var outputStream = client.logging.streamEmpty(controller.stream);

    controller.add(1);
    await outputStream.first;

    // Wait for the log to be written
    await Future.delayed(Duration(milliseconds: 100));

    var logs = await LoggingUtil.findAllLogs(session);

    expect(logs, hasLength(1));
    expect(logs.first.sessionLogEntry.isOpen, isFalse);
  });

  test(
      'Given that all logging is turned down but an override for the endpoint when sending a stream message to another endpoint and then closing the connection no logs are written.',
      () async {
    var settings = RuntimeSettingsBuilder()
        .withLogSettings(LogSettingsBuilder().withLoggingTurnedDown().build())
        .withLogSettingsOverride(
          endpoint: 'authentication',
          logSettings: LogSettingsBuilder().build(),
        )
        .build();

    await server.updateRuntimeSettings(settings);

    var controller = StreamController<int>();
    var outputStream = client.logging.streamEmpty(controller.stream);

    controller.add(1);
    await outputStream.first;

    // Wait for the log to be written
    await Future.delayed(Duration(milliseconds: 100));

    var logs = await LoggingUtil.findAllLogs(session);

    expect(logs, isEmpty);
  });

  test(
      'Given that all logging is turned down but an override for the endpoint and method is present when sending a stream message to that endpoint and method and then closing the connection the logs are written.',
      () async {
    var settings = RuntimeSettingsBuilder()
        .withLogSettings(LogSettingsBuilder().withLoggingTurnedDown().build())
        .withLogSettingsOverride(
          endpoint: 'logging',
          method: 'streamEmpty',
          logSettings: LogSettingsBuilder().build(),
        )
        .build();

    await server.updateRuntimeSettings(settings);

    var controller = StreamController<int>();
    var outputStream = client.logging.streamEmpty(controller.stream);

    controller.add(1);
    await outputStream.first;

    // Wait for the log to be written
    await Future.delayed(Duration(milliseconds: 100));

    var logs = await LoggingUtil.findAllLogs(session);

    expect(logs, hasLength(1));
    expect(logs.first.sessionLogEntry.isOpen, isFalse);
  });

  test(
      'Given that all logging is turned down but an override for another method is present when sending a stream message and then closing the connection no logs are written.',
      () async {
    var settings = RuntimeSettingsBuilder()
        .withLogSettings(LogSettingsBuilder().withLoggingTurnedDown().build())
        .withLogSettingsOverride(
          endpoint: 'logging',
          method: 'streamLogging',
          logSettings: LogSettingsBuilder().build(),
        )
        .build();

    await server.updateRuntimeSettings(settings);

    var controller = StreamController<int>();
    var outputStream = client.logging.streamEmpty(controller.stream);

    controller.add(1);
    await outputStream.first;

    // Wait for the log to be written
    await Future.delayed(Duration(milliseconds: 100));

    var logs = await LoggingUtil.findAllLogs(session);

    expect(logs, isEmpty);
  });
}
