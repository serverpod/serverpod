import 'package:test/test.dart';

Future expectException(
    Future<void> Function() function, Matcher matcher) async {
  late var actualException;
  try {
    await function();
  } catch (e) {
    actualException = e;
  }
  expect(actualException, matcher);
}
