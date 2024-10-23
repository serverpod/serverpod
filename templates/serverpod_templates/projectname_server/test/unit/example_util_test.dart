import 'package:test/test.dart';
import 'package:projectname_server/src/endpoints/example_endpoint.dart';

void main() {
  test(
      'Given ExampleUtil '
      'when calling `buildGreeting` with name '
      'then returned greeting includes name', () async {
    final greeting = ExampleUtil.buildGreeting('Alice');
    expect(greeting, 'Hello Alice');
  });
}
