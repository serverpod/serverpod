import 'package:firebase_dart/core.dart';
import 'package:meta/meta.dart';

/// Represents initialized Firebase application and provides access to the
/// app's services.
@internal
class App {
  final FirebaseOptions options;

  /// Do not call this constructor directly. Instead, use
  /// [FirebaseAdmin.initializeApp] to create an app.
  App(Map<String, dynamic> map) : options = FirebaseOptions.fromMap(map);
}
