import 'session.dart';

/// Superclass for package startup hooks.
///
/// Extend this class and override [onStartup] to run initialization after
/// database migrations (and Redis connect) and before user-facing servers
/// start. At most one concrete [Module] subclass may be defined per package.
///
/// The [Session] passed to [onStartup] is the server's internal session: it
/// has no authentication context and logging is disabled. Do not close it or
/// retain it past the hook. Database and Redis may be unavailable depending
/// on project features.
///
/// This hook is for post-migration work only. Auth handlers, routes, and
/// other pre-start configuration still require configure APIs invoked before
/// `Serverpod.start`.
///
/// Invocation order when nested modules are present: the host package's
/// [Module] (if any), then each dependency module sorted by module name.
/// Order is not topological — modules must not assume dependency modules
/// have already run.
abstract class Module {
  /// Called once during `Serverpod.start` after migrations and Redis connect,
  /// before Insights and API/web servers start.
  ///
  /// Any thrown error fails server start. Side effects should be idempotent
  /// because the hook runs again after `shutdown` + `start`.
  Future<void> onStartup(Session session) async {}
}
