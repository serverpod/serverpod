import 'package:serverpod/protocol.dart'
    show FutureCallClaimEntry, FutureCallEntry;
import 'package:serverpod/serverpod.dart';
import 'package:serverpod_test_server/test_util/test_tags.dart';
import 'package:serverpod_test_sqlite_server/src/generated/protocol.dart';
import 'package:serverpod_test_sqlite_server/src/generated/future_calls.dart';
import 'package:test/test.dart';

import '../test_tools/serverpod_test_tools.dart';

void main() {
  withServerpod(
    'Given future call execution is enabled and a scheduled recurring future call, ',
    rollbackDatabase: RollbackDatabase.disabled,
    testGroupTagsOverride: [TestTags.concurrencyOneTestTag],
    configOverride: (config) => config.copyWith(
      futureCallExecutionEnabled: true,
      futureCall: const FutureCallConfig(
        concurrencyLimit: 1,
        scanInterval: Duration(milliseconds: 100),
      ),
    ),
    (sessionBuilder, endpoints) {
      late Session session;
      late Serverpod pod;
      const firstValue = 1017;
      const callName = 'test-sqlite-call';

      setUp(() async {
        session = sessionBuilder.build();
        pod = session.serverpod;

        pod.futureCalls
            .callRecurring(identifier: callName)
            .every(const Duration(seconds: 1))
            .insertSimpleDataCall
            .persistIncrementedSimpleData(SimpleData(num: firstValue));
      });

      tearDown(() async {
        await FutureCallClaimEntry.db.deleteWhere(
          session,
          where: (t) => t.futureCallId > 0,
        );
        await FutureCallEntry.db.deleteWhere(
          session,
          where: (t) => t.identifier.equals(callName),
        );
        await SimpleData.db.deleteWhere(
          session,
          where: (t) => t.num.inSet({firstValue, firstValue + 1}),
        );
        await session.close();
      });

      test(
        'then it executes successfully and persists the expected data.',
        () async {
          await Future.delayed(const Duration(seconds: 3));

          final persistedSimpleData = await SimpleData.db.find(
            session,
            where: (t) => t.num.equals(firstValue + 1),
          );

          expect(persistedSimpleData, isNotEmpty);
          expect(persistedSimpleData.first.num, firstValue + 1);
        },
      );
    },
  );
}
