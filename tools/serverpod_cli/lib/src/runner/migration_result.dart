/// The outcome of one of [RunnerApi]'s migration commands.
///
/// Carries no retry instruction. [abortedForWarnings] flags only the missing
/// confirmation, and each surface phrases the retry in its own terms.
class MigrationResult {
  const MigrationResult({
    required this.message,
    this.isError = false,
    this.abortedForWarnings = false,
    this.created = false,
  });

  /// Human-readable description of what happened.
  final String message;

  /// Whether the command failed.
  final bool isError;

  /// Whether the command's only failure was unconfirmed warnings.
  ///
  /// The runner never prompts. A caller that wants to proceed anyway asks its
  /// own user and retries with `force: true`.
  final bool abortedForWarnings;

  /// Whether a migration was written to disk, so a caller can suggest applying
  /// it.
  final bool created;

  Map<String, Object?> toJson() => {
    'message': message,
    'isError': isError,
    'abortedForWarnings': abortedForWarnings,
    'created': created,
  };

  static MigrationResult fromJson(Map<String, Object?> json) => MigrationResult(
    message: json['message'] as String? ?? '',
    isError: json['isError'] as bool? ?? false,
    abortedForWarnings: json['abortedForWarnings'] as bool? ?? false,
    created: json['created'] as bool? ?? false,
  );
}
