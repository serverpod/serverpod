import 'package:serverpod/serverpod.dart';

/// Test module startup hook used by host integration tests.
class TestModuleModule extends Module {
  /// Number of times [onStartup] has been invoked in this isolate.
  static int startupCount = 0;

  /// When non-null, [onStartup] throws this error.
  static Object? throwOnStartup;

  /// Resets test state between cases.
  static void reset() {
    startupCount = 0;
    throwOnStartup = null;
  }

  @override
  Future<void> onStartup(Session session) async {
    final error = throwOnStartup;
    if (error != null) {
      throw error;
    }
    startupCount++;
  }
}
