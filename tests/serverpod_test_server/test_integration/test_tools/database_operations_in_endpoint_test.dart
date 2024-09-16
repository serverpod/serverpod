import 'package:serverpod/serverpod.dart';
import 'package:serverpod_test_server/src/generated/protocol.dart';
import 'package:test/test.dart';

import 'serverpod_test_tools.dart';

void main() {
  withServerpod(
    'Given TestToolsEndpoint',
    (endpoints, session) {
      test(
          'when calling createSimpleData then creates a SimpleData in the database',
          () async {
        await endpoints.testTools.createSimpleData(session, 123);

        final result = await SimpleData.db.find(session);
        expect(result.length, 1);
        expect(result.first.num, 123);
      });

      group('when two calls to createSimpleData with different sessions', () {
        late TestSession firstSession;
        late TestSession secondSession;
        setUp(() async {
          firstSession = session.copyWith(
            authentication: AuthenticationOverride.authenticationInfo(
              111,
              {},
            ),
          );
          secondSession = session.copyWith(
            authentication: AuthenticationOverride.authenticationInfo(
              222,
              {},
            ),
          );

          await endpoints.testTools.createSimpleData(firstSession, 111);
          await endpoints.testTools.createSimpleData(secondSession, 222);
        });

        test('then the first session can see the created data', () async {
          var fetchedSimpleDatas =
              await endpoints.testTools.getAllSimpleData(firstSession);
          expect(fetchedSimpleDatas.length, 2);
          expect(fetchedSimpleDatas[0].num, 111);
          expect(fetchedSimpleDatas[1].num, 222);
        });
        test('then the second session can see the created data', () async {
          var fetchedSimpleDatas =
              await endpoints.testTools.getAllSimpleData(secondSession);
          expect(fetchedSimpleDatas.length, 2);
          expect(fetchedSimpleDatas[0].num, 111);
          expect(fetchedSimpleDatas[1].num, 222);
        });
        test('then the original session can see the created data', () async {
          var fetchedSimpleDatas =
              await endpoints.testTools.getAllSimpleData(session);
          expect(fetchedSimpleDatas.length, 2);
          expect(fetchedSimpleDatas[0].num, 111);
          expect(fetchedSimpleDatas[1].num, 222);
        });
      });

      group('when calling getAllSimpleData', () {
        setUp(() async {
          await SimpleData.db.insert(session, [
            SimpleData(num: 111),
            SimpleData(num: 222),
          ]);
        });

        test('then returns all SimpleData in the database', () async {
          var result = await endpoints.testTools.getAllSimpleData(session);

          expect(result.length, 2);

          var nums = result.map((e) => e.num).toList();
          expect(nums, containsAll([111, 222]));
        });
      });
    },
    runMode: ServerpodRunMode.production,
  );
}
