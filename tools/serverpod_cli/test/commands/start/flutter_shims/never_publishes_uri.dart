// Test shim for [FlutterProcess]: runs forever, emits machine-protocol
// progress events but never `app.debugPort`. Used to exercise the
// VM-service-URI startup timeout.
import 'dart:async';

Future<void> main() async {
  // Keep the process alive long enough for the timeout to fire.
  await Future<void>.delayed(const Duration(minutes: 1));
}
