import 'package:test/test.dart';
import 'package:modulename_server/src/endpoints/module_endpoint.dart';

void main() {
  test(
      'Given ModuleUtil '
      'when calling `buildGreeting` with name '
      'then returned greeting includes name', () async {
    final greeting = ModuleUtil.buildGreeting('Alice');
    expect(greeting, 'Hello Alice');
  });
}
