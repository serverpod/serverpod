import 'package:test/test.dart';
import 'package:modulename_server/src/endpoints/module_endpoint.dart';

void main() {
  test(
      'Given ModuleUtil '
      'when calling buildGreeting '
      'then returns greeting', () async {
    final greeting = ModuleUtil.buildGreeting('Alice');
    expect(greeting, 'Hello Alice');
  });
}
