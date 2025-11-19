import 'package:test/test.dart';

import 'package:serverpod/serverpod.dart';

import '../test_tools/serverpod_test_tools.dart';
import 'test_exception_handler.dart';

void main() {
  const timeout = Duration(seconds: 3);
  var exceptionHandler = TestExceptionHandler();

  withServerpod(
    'Given withServerpod with a diagnostic event handler',
    experimentalFeatures: ExperimentalFeatures(
      diagnosticEventHandlers: [exceptionHandler],
    ),
    (sessionBuilder, endpoints) {
      test('when calling an endpoint method that submits an exception event '
          'then the diagnostic event handler gets called', () async {
        final result = await endpoints.diagnosticEventTest.submitExceptionEvent(
          sessionBuilder,
        );
        expect(result, 'success');

        final record = await exceptionHandler.events.first.timeout(timeout);
        expect(record.event.exception, isA<Exception>());
        expect(record.event.custom, equals({'customKey': 'customValue'}));
        expect(record.space, equals(OriginSpace.application));
        expect(record.context, isA<DiagnosticEventContext>());
        expect(
          record.context.toJson(),
          allOf([
            containsPair('serverId', 'default'),
            containsPair('serverRunMode', 'test'),
            containsPair('serverName', 'Server default'),
          ]),
        );
      });
    },
  );
}
