import 'package:test/test.dart';

import 'test_tools/serverpod_test_tools.dart';

void main() {
  withServerpod('Given Greeting endpoint', (sessionBuilder, endpoints) {
    test(
      'when calling `hello` with name then returned greeting includes name',
      () async {
        final greeting = await endpoints.greeting.hello(sessionBuilder, 'Bob');
        expect(greeting.message, 'Hello Bob');
      },
    );
  });
}
