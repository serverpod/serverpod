import 'package:serverpod/serverpod.dart';

/// Responsible for initializing the generated future calls.
abstract class FutureCallInitializer {
  /// Initializes the generated future calls.
  void initialize(FutureCallManager futureCallManager, String serverId);
}
