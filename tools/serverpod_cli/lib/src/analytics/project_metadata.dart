/// Local per-clone analytics state persisted in the metadata file
/// (see [ProjectMetadataStore] for its location).
class ProjectMetadata {
  ProjectMetadata({
    required this.checkoutId,
    required this.projectCreatedAt,
    this.generateCallCount = 0,
    Map<String, int>? commandInvocations,
  }) : commandInvocations = Map<String, int>.from(commandInvocations ?? {});

  /// Random per-clone id. The durable, remote-derived `project_id` is computed
  /// on the fly (see `ProjectIdentity`) and is intentionally not stored here.
  final String checkoutId;
  final DateTime projectCreatedAt;
  int generateCallCount;
  final Map<String, int> commandInvocations;

  Map<String, dynamic> toJson() => {
    'checkout_id': checkoutId,
    'project_created_at': projectCreatedAt.toUtc().toIso8601String(),
    'generate_call_count': generateCallCount,
    'command_invocations': commandInvocations,
  };

  static ProjectMetadata fromJson(Map<String, dynamic> json) {
    final invocationsRaw = json['command_invocations'];
    final invocations = <String, int>{};
    if (invocationsRaw is Map) {
      for (final entry in invocationsRaw.entries) {
        final value = entry.value;
        if (entry.key is String && value is int) {
          invocations[entry.key as String] = value;
        }
      }
    }

    return ProjectMetadata(
      // Accept the legacy `project_id` key written by earlier CLI versions.
      checkoutId: (json['checkout_id'] ?? json['project_id']) as String,
      projectCreatedAt: DateTime.parse(json['project_created_at'] as String),
      generateCallCount: json['generate_call_count'] as int? ?? 0,
      commandInvocations: invocations,
    );
  }
}
