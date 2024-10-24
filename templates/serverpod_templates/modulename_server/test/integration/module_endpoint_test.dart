import 'package:test/test.dart';

// Import the generated file, it contains everything you need.
import 'test_tools/serverpod_test_tools.dart';

void main() {
  withServerpod('Given Module endpoint', (sessionBuilder, endpoints) {
    test('when calling `hello` with name then returned greeting includes name',
        () async {
      final greeting = await endpoints.module.hello(sessionBuilder, 'Bob');
      expect(greeting, 'Hello Bob');
    });
  });
}
