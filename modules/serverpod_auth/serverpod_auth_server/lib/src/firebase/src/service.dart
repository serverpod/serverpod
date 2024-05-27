import 'app.dart';

/// Services are exposed through instances, each of which is associated with a
/// FirebaseApp.
abstract class FirebaseService {
  /// The app associated with the Auth service instance.
  App get app;

  Future<void> delete();
}
