import 'package:serverpod/serverpod.dart';
import 'package:serverpod_test_server/src/generated/protocol.dart';
import 'package:test/test.dart';

import 'serverpod_test_tools.dart';

void main() {
  withServerpod(
    (endpoints, session) {
      group('Given TestToolsEndpoint', () {
        test(
            'when calling createSimpleData then creates a SimpleData in the database',
            () async {
          await endpoints.testTools.createSimpleData(session, 123);

          final result = await SimpleData.db.find(session);
          expect(result.length, 1);
          expect(result.first.num, 123);
        });

        test(
            'when two calls to createSimpleData with different sessions then all sessions can see the created data',
            () async {
          var firstSession = await session.copyWith(
            getAuthenticationInfo: () => AuthenticationInfo(111, {}),
          );
          var secondSession = await session.copyWith(
            getAuthenticationInfo: () => AuthenticationInfo(222, {}),
          );

          await endpoints.testTools.createSimpleData(firstSession, 111);
          await endpoints.testTools.createSimpleData(secondSession, 222);

          var fetchedSimpleDatas =
              await endpoints.testTools.getAllSimpleData(firstSession);

          expect(fetchedSimpleDatas.length, 2);
          expect(fetchedSimpleDatas[0].num, 111);
          expect(fetchedSimpleDatas[1].num, 222);

          final firstSessionResult = await SimpleData.db.find(firstSession);
          expect(firstSessionResult.length, 2);
          expect(firstSessionResult[0].num, 111);
          expect(firstSessionResult[1].num, 222);

          final secondSessionResult = await SimpleData.db.find(secondSession);
          expect(secondSessionResult.length, 2);
          expect(secondSessionResult[0].num, 111);
          expect(secondSessionResult[1].num, 222);

          final originalSessionResult = await SimpleData.db.find(session);
          expect(originalSessionResult.length, 2);
          expect(originalSessionResult[0].num, 111);
          expect(originalSessionResult[1].num, 222);
        });

        group('when calling getAllSimpleData', () {
          setUp(() async {
            await SimpleData.db
                .insert(session, [SimpleData(num: 111), SimpleData(num: 222)]);
          });

          test('then returns all SimpleData in the database', () async {
            var result = await endpoints.testTools.getAllSimpleData(session);

            expect(result.length, 2);

            var nums = result.map((e) => e.num).toList();
            expect(nums, containsAll([111, 222]));
          });
        });
      });
    },
    runMode: ServerpodRunMode.production,
  );
}
