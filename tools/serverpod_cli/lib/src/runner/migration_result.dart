/// The outcome of one of the runner's migration commands.
///
/// [message] carries no retry hint, which each caller phrases itself.
class MigrationResult {
  const MigrationResult({
    required this.message,
    this.isError = false,
    this.abortedForWarnings = false,
    this.created = false,
  });

  final String message;

  final bool isError;

  /// Whether the command stopped at warnings that `force: true` overrides.
  final bool abortedForWarnings;

  /// Whether the command wrote a server migration to disk.
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
