// Dummy file used for CI testing. To get the examples to run, generate a real
// firebase_options.dart file using the FlutterFire CLI.
import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;

class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    throw UnsupportedError(
      'This is a dummy file, used so that tests will pass.',
    );
  }
}
