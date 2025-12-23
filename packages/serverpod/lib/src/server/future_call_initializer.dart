import 'package:serverpod/serverpod.dart';

/// Responsible for initializing the generated future calls.
abstract class FutureCallInitializer {
  /// All registered future calls with their associated names.
  Map<String, FutureCall> registeredFutureCalls = {};

  /// Initializes the generated future calls.
  void initialize(FutureCallManager futureCallManager, String serverId);
}
