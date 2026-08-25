/// How far the runner has got.
///
/// Held by the runner rather than derived by each client, so a UI attaching
/// during a slow first compilation sees progress rather than an empty screen.
enum RunnerStage {
  /// Provisioning: Docker, code generation, the first compile.
  starting,

  /// The server is up.
  running,

  /// The project failed to generate or compile, so no server is running.
  ///
  /// The file watcher recovers in watch mode; otherwise `retryStart` does.
  degraded,

  /// Shutting down.
  stopping;

  static RunnerStage byName(String? name) => values.firstWhere(
    (stage) => stage.name == name,
    orElse: () => RunnerStage.starting,
  );
}
