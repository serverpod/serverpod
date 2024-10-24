import 'package:serverpod/serverpod.dart';
import 'package:test/test.dart';

import 'serverpod_test_tools.dart';

void main() {
  withServerpod(
    'Given calling endpoint returning Future',
    (sessionBuilder, endpoints) {
      group('when using the same session between two calls', () {
        late UuidValue sessionId1;
        late UuidValue sessionId2;

        setUp(() async {
          sessionId1 =
              await endpoints.testTools.returnsSessionId(sessionBuilder);
          sessionId2 =
              await endpoints.testTools.returnsSessionId(sessionBuilder);
        });

        test('then session id is unique in each endpoint call', () async {
          expect(sessionId1, isNot(sessionId2));
        });
      });

      test(
          "when method is returning the session's `endpoint` and `method` properties then the correct name and method is returned",
          () async {
        var [endpoint, method] = await endpoints.testTools
            .returnsSessionEndpointAndMethod(sessionBuilder);
        expect(endpoint, 'testTools');
        expect(method, 'returnsSessionEndpointAndMethod');
      });
    },
  );

  withServerpod(
    'Given calling endpoint returning Stream',
    (sessionBuilder, endpoints) {
      group('when using the same session between two calls', () {
        late Stream<UuidValue> sessionId1Stream;
        late Stream<UuidValue> sessionId2Stream;

        setUp(() async {
          sessionId1Stream = await endpoints.testTools
              .returnsSessionIdFromStream(sessionBuilder);
          sessionId2Stream = await endpoints.testTools
              .returnsSessionIdFromStream(sessionBuilder);
        });

        test('then session id is unique in each endpoint call', () async {
          var sessionId1 = await sessionId1Stream.first;
          var sessionId2 = await sessionId2Stream.first;
          expect(sessionId1, isNot(sessionId2));
        });
      });

      test(
          "when method is returning the session's `endpoint` and `method` properties then the correct name and method is returned",
          () async {
        var [endpoint, method] = await endpoints.testTools
            .returnsSessionEndpointAndMethodFromStream(sessionBuilder)
            .take(2)
            .toList();

        expect(endpoint, 'testTools');
        expect(method, 'returnsSessionEndpointAndMethodFromStream');
      });
    },
  );
}
