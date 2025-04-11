import 'package:test/test.dart';
import 'package:projectname_server/src/greeting_endpoint.dart';

void main() {
  test(
      'Given Greeter with default greeting'
      'when calling `call` with name '
      'then returned greeting includes name', () async {
    final greeting = Greeter().call('Alice');
    expect(greeting.message, 'Hello Alice');
  });

  test(
      'Given Greeter with custom greeting'
      'when calling `call` with name '
      'then returned greeting includes name and custom greeting', () async {
    final greeting = Greeter(greeting: 'Moin').call('Damian');
    expect(greeting.message, 'Moin Damian');
  });
}
