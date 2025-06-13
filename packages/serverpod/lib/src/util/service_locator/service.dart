import 'package:serverpod/serverpod.dart';

/// Any service that implements this interface and is registered in the
/// [ServiceLocator] will be called when the server starts up.
///
/// This is useful for services that need to perform some initialization
/// before they can be used, such as establishing remote connections,
/// loading configuration files, or setting up background tasks.
abstract interface class InitializedService {
  /// Called during server start.
  Future<void> init(Serverpod serverpod);
}

/// Any service that implements this interface and is registered in the
/// [ServiceLocator] will be called when the server is shutting down.
///
/// This is useful for services that need to perform some cleanup
/// before the server stops running, such as storing state to disk or stopping
/// background tasks.
abstract interface class DisposableService {
  /// Called during server shutdown.
  Future<void> dispose(Serverpod serverpod);
}
