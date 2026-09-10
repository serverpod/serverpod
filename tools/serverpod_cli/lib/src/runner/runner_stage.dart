/// How far the runner has got.
enum RunnerStage {
  /// Provisioning: Docker, code generation, the first compile.
  starting,

  /// The server is up.
  running,

  /// The project failed to build. The watcher or `retryStart` recovers it.
  degraded,

  /// Shutting down.
  stopping;

  static RunnerStage byName(String? name) => values.firstWhere(
    (stage) => stage.name == name,
    orElse: () => RunnerStage.starting,
  );
}
