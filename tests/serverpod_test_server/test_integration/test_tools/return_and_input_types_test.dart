import 'package:serverpod/serverpod.dart';
import 'package:serverpod_test_server/src/generated/protocol.dart';
import 'package:test/test.dart';

import 'serverpod_test_tools.dart';

void main() {
  withServerpod(
    'Given TestToolsEndpoint',
    (sessionBuilder, endpoints) {
      test('when calling returnsString then echoes string', () async {
        final result =
            await endpoints.testTools.returnsString(sessionBuilder, "Hello");
        expect(result, 'Hello');
      });

      test('when calling returnsStream then returns a stream', () async {
        final result =
            await endpoints.testTools.returnsStream(sessionBuilder, 3).toList();
        expect(result, [0, 1, 2]);
      });

      test(
          'when calling returnsListFromInputStream then returns a list of the input stream',
          () async {
        final stream = Stream<int>.fromIterable([1, 2, 3, 4, 5]);
        final result = await endpoints.testTools
            .returnsListFromInputStream(sessionBuilder, stream);
        expect(result, [1, 2, 3, 4, 5]);
      });

      test(
          'when calling returnsSimpleDataListFromInputStream then returns a list of the input stream',
          () async {
        final stream = Stream<SimpleData>.fromIterable([
          SimpleData(num: 1),
          SimpleData(num: 2),
          SimpleData(num: 3),
        ]);
        final result = await endpoints.testTools
            .returnsSimpleDataListFromInputStream(sessionBuilder, stream);
        expect(result.map((s) => s.num), [1, 2, 3]);
      });

      test(
          'when calling returnsStreamFromInputStream then echoes the input stream back',
          () async {
        final stream = Stream<int>.fromIterable([1, 2, 3, 4, 5]);
        final result = endpoints.testTools
            .returnsStreamFromInputStream(sessionBuilder, stream);
        await expectLater(result, emitsInOrder([1, 2, 3, 4, 5]));
      });

      test(
          'when calling postNumberToSharedStream and listenForNumbersOnSharedStream with different sessions then number should be echoed',
          () async {
        var userSession1 = sessionBuilder.copyWith(
          authentication: AuthenticationOverride.authenticationInfo(
            1,
            {},
          ),
        );
        var userSession2 = sessionBuilder.copyWith(
          authentication: AuthenticationOverride.authenticationInfo(
            2,
            {},
          ),
        );

        var stream =
            endpoints.testTools.listenForNumbersOnSharedStream(userSession1);
        await flushEventQueue();

        await endpoints.testTools.postNumberToSharedStream(userSession2, 111);
        await endpoints.testTools.postNumberToSharedStream(userSession2, 222);

        await expectLater(stream.take(2), emitsInOrder([111, 222]));
      });

      test(
          'when calling postNumberToSharedStreamAndReturnStream without listening to the return stream then number should still be posted',
          () async {
        var stream =
            endpoints.testTools.listenForNumbersOnSharedStream(sessionBuilder);

        endpoints.testTools
            .postNumberToSharedStreamAndReturnStream(sessionBuilder, 111);

        await expectLater(stream.take(1), emitsInOrder([111]));
      });

      test('when calling echoSimpleData then should echo the object', () async {
        final data = SimpleData(num: 1);
        var result =
            await endpoints.testTools.echoSimpleData(sessionBuilder, data);
        expect(result.num, 1);
      });

      test('when calling echoSimpleDatas then should echo the object',
          () async {
        final data1 = SimpleData(num: 1);
        final data2 = SimpleData(num: 2);
        var result = await endpoints.testTools
            .echoSimpleDatas(sessionBuilder, [data1, data2]);
        expect(result[0].num, 1);
        expect(result[1].num, 2);
      });
    },
    runMode: ServerpodRunMode.production,
  );
}
