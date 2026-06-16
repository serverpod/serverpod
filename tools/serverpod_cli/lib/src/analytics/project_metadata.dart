/// Local per-project analytics state persisted in `.dart_tool/serverpod/metadata.json`.
class ProjectMetadata {
  ProjectMetadata({
    required this.projectId,
    required this.projectCreatedAt,
    this.generateCallCount = 0,
    Map<String, int>? commandInvocations,
  }) : commandInvocations = Map<String, int>.from(commandInvocations ?? {});

  final String projectId;
  final DateTime projectCreatedAt;
  int generateCallCount;
  final Map<String, int> commandInvocations;

  Map<String, dynamic> toJson() => {
    'project_id': projectId,
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
      projectId: json['project_id'] as String,
      projectCreatedAt: DateTime.parse(json['project_created_at'] as String),
      generateCallCount: json['generate_call_count'] as int? ?? 0,
      commandInvocations: invocations,
    );
  }
}
