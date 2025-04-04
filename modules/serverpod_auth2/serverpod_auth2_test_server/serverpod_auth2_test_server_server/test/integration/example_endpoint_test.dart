import 'package:test/test.dart';

// Import the generated test helper file, it contains everything you need.
import 'test_tools/serverpod_test_tools.dart';

void main() {
  // This is an example test that uses the `withServerpod` test helper.
  // `withServerpod` enables you to call your endpoints directly from the test like regular functions.
  // Note that after adding or modifying an endpoint, you will need to run
  // `serverpod generate` to update the test tools code.
  // Refer to the docs for more information on how to use the test helper.
  withServerpod('Given Example endpoint', (sessionBuilder, endpoints) {
    test('when calling `hello` with name then returned greeting includes name',
        () async {
      // Call the endpoint method by using the `endpoints` parameter and
      // pass `sessionBuilder` as a first argument. Refer to the docs on
      // how to use the `sessionBuilder` to set up different test scenarios.
      final greeting = await endpoints.example.hello(sessionBuilder, 'Bob');
      expect(greeting, 'Hello Bob');
    });
  });
}
