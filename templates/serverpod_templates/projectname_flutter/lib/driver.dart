import 'package:flutter_driver/driver_extension.dart';

import 'main.dart' as app;

void main() {
  enableFlutterDriverExtension(
    // Text entry emulation is disabled by default to allow manual usage of the
    // app, but will be required for agents to type through the app. Set this
    // parameter to true to switch from manual to automated usage.
    enableTextEntryEmulation: false,
  );
  app.main();
}
