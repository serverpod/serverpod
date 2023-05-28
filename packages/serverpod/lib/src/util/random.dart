import 'dart:math';

String generateString({int len = 16}) {
  const chars =
      'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';
  final rnd = Random();
  return String.fromCharCodes(
    Iterable.generate(
      len,
      (_) => chars.codeUnitAt(rnd.nextInt(chars.length)),
    ),
  );
}
