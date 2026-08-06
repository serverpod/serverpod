// Test shim: alive but silent. Exercises the no-URI-arrives path.
import 'dart:async';

Future<void> main() async {
  await Future<void>.delayed(const Duration(minutes: 1));
}
