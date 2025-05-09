import 'dart:math';

String generatePassword() {
  return Random().nextInt(1 << 31).toString();
}
