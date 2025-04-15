import 'package:mocktail/mocktail.dart';
import 'package:serverpod/serverpod.dart';
import 'package:serverpod/src/server/command_line_args.dart';

class MockServer extends Mock implements Server {}

class MockServerpod extends Mock implements Serverpod {}

class MockCommandLineArgs extends Mock implements CommandLineArgs {}

class MockSerializationManager extends Mock implements SerializationManager {}

class MockFutureCall extends Mock implements FutureCall<SerializableModel> {}

abstract class OnCompleted {
  void call();
}

class MockOnCompleted extends Mock implements OnCompleted {}

// TODO test in full database environment, create in
// tests/serverpod_test_server/test_integration
// tests/serverpod_test_server/test_integration/logging/endpoint_method_call_logging_test.dart:23
// server = IntegrationTestServer.create();
// register a future call - create a new one in the test project, it can have a
// - completer which is completed once it has been run
//   schedule it in a past point in time
// - call start on future call manager
// - assert task has run
// - assert db table row is deleted
