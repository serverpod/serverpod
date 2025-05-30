import 'package:serverpod_auth_api_tokens_server/src/module_util.dart';
import 'package:test/test.dart';

void main() {
  test(
      'Given ModuleUtil '
      'when calling `buildGreeting` with name '
      'then returned greeting includes name', () async {
    final greeting = ModuleUtil.buildGreeting('Alice');
    expect(greeting, 'Hello Alice');
  });
}
