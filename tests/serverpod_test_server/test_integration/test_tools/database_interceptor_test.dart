import 'package:serverpod/serverpod.dart';
import 'package:test/test.dart';

import 'serverpod_test_tools.dart';

void main() {
  var interceptorCallCount = 0;

  final DatabaseInterceptor databaseInterceptor = (_, inner) {
    interceptorCallCount++;
    return inner;
  };

  withServerpod(
    'Given withServerpod with a database interceptor,',
    databaseInterceptor: databaseInterceptor,
    testServerOutputMode: TestServerOutputMode.silent,
    (sessionBuilder, _) {
      test(
        'when building a test session, '
        'then the database interceptor is called for that session.',
        () {
          var interceptorCallCountBeforeBuild = interceptorCallCount;

          sessionBuilder.build();

          expect(
            interceptorCallCount,
            interceptorCallCountBeforeBuild + 1,
          );
        },
      );
    },
  );
}
