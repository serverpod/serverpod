import 'dart:async';

import 'package:serverpod/protocol.dart' show FutureCallEntry;
import 'package:serverpod/serverpod.dart';
import 'package:serverpod_test_server/src/generated/protocol.dart';
import 'package:test/test.dart';

import '../test_tools/serverpod_test_tools.dart';
import '../utils/future_call_manager_builder.dart';

class CompleterTestCall extends FutureCall<SimpleData> {
  final Completer<void> completer = Completer<void>();

  @override
  Future<void> invoke(Session session, SimpleData? object) async {
    if (object != null) {
      var data = object;
      session.log('${data.num}');
    } else {
      session.log('null');
    }

    completer.complete();
  }
}

void main() async {
  withServerpod(
      'Given FutureCallManager with scheduled future call that is due',
      (sessionBuilder, _) {
    late FutureCallManager futureCallManager;
    late CompleterTestCall testCall;

    setUp(() async {
      futureCallManager =
          FutureCallManagerBuilder.fromTestSessionBuilder(sessionBuilder)
              .build();

      testCall = CompleterTestCall();

      futureCallManager.registerFutureCall(testCall, 'testCall');

      futureCallManager.scheduleFutureCall(
        'testCall',
        SimpleData(num: 4),
        DateTime.now().subtract(const Duration(seconds: 1)),
        '1',
        'alex',
      );
    });

    tearDown(() async {
      await futureCallManager.stop();
    });

    group('when running scheduled future calls', () {
      setUp(() async {
        await futureCallManager.runScheduledFutureCalls();
      });

      test('then call is executed', () async {
        expect(testCall.completer.future, completes);
      });

      test('then call is removed from database', () async {
        final futureCallEntries = await FutureCallEntry.db.find(
          sessionBuilder.build(),
        );

        expect(futureCallEntries, hasLength(0));
      });
    });
  });
}
