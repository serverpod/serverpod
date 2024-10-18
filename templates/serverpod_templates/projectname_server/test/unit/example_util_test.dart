import 'package:test/test.dart';
import 'package:projectname_server/src/endpoints/example_endpoint.dart';

void main() {
  test(
      'Given ExampleUtil '
      'when calling buildGreeting '
      'then returns greeting', () async {
    final greeting = ExampleUtil.buildGreeting('Alice');
    expect(greeting, 'Hello Alice');
  });
}
