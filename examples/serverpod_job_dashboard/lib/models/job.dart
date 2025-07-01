import 'package:flutter/material.dart';

enum JobStatus {
  pending('Pending', Icons.schedule, Colors.orange),
  running('Running', Icons.play_circle, Colors.blue),
  completed('Completed', Icons.check_circle, Colors.green),
  failed('Failed', Icons.error, Colors.red),
  paused('Paused', Icons.pause_circle, Colors.grey),
  cancelled('Cancelled', Icons.cancel, Colors.black),
  retrying('Retrying', Icons.replay, Colors.purple);

  const JobStatus(this.display, this.icon, this.color);
  final String display;
  final IconData icon;
  final Color color;
}

enum JobPriority {
  low('Low', Colors.green, 1),
  medium('Medium', Colors.blue, 2),
  high('High', Colors.orange, 3),
  critical('Critical', Colors.red, 4);

  const JobPriority(this.display, this.color, this.level);
  final String display;
  final Color color;
  final int level;
}

class Job {
  final String id;
  final String name;
  final String description;
  final JobStatus status;
  final JobPriority priority;
  final DateTime createdAt;
  final DateTime? startedAt;
  final DateTime? completedAt;
  final DateTime? nextRunAt;
  final int retryCount;
  final int maxRetries;
  final double progress;
  final String? errorMessage;
  final Map<String, dynamic> metadata;
  final List<String> tags;
  final String? assignedTo;
  final Duration? estimatedDuration;

  const Job({
    required this.id,
    required this.name,
    required this.description,
    required this.status,
    required this.priority,
    required this.createdAt,
    this.startedAt,
    this.completedAt,
    this.nextRunAt,
    this.retryCount = 0,
    this.maxRetries = 3,
    this.progress = 0.0,
    this.errorMessage,
    this.metadata = const {},
    this.tags = const [],
    this.assignedTo,
    this.estimatedDuration,
  });

  Job copyWith({
    String? id,
    String? name,
    String? description,
    JobStatus? status,
    JobPriority? priority,
    DateTime? createdAt,
    DateTime? startedAt,
    DateTime? completedAt,
    DateTime? nextRunAt,
    int? retryCount,
    int? maxRetries,
    double? progress,
    String? errorMessage,
    Map<String, dynamic>? metadata,
    List<String>? tags,
    String? assignedTo,
    Duration? estimatedDuration,
  }) {
    return Job(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      status: status ?? this.status,
      priority: priority ?? this.priority,
      createdAt: createdAt ?? this.createdAt,
      startedAt: startedAt ?? this.startedAt,
      completedAt: completedAt ?? this.completedAt,
      nextRunAt: nextRunAt ?? this.nextRunAt,
      retryCount: retryCount ?? this.retryCount,
      maxRetries: maxRetries ?? this.maxRetries,
      progress: progress ?? this.progress,
      errorMessage: errorMessage ?? this.errorMessage,
      metadata: metadata ?? this.metadata,
      tags: tags ?? this.tags,
      assignedTo: assignedTo ?? this.assignedTo,
      estimatedDuration: estimatedDuration ?? this.estimatedDuration,
    );
  }

  Duration get duration {
    if (startedAt == null) return Duration.zero;
    final endTime = completedAt ?? DateTime.now();
    return endTime.difference(startedAt!);
  }

  Duration get estimatedRemaining {
    if (status != JobStatus.running || estimatedDuration == null) {
      return Duration.zero;
    }
    final elapsed = duration;
    final total = estimatedDuration!;
    final remaining = total - elapsed;
    return remaining.isNegative ? Duration.zero : remaining;
  }

  bool get canRetry => status == JobStatus.failed && retryCount < maxRetries;
  bool get canPause => status == JobStatus.running;
  bool get canResume => status == JobStatus.paused;
  bool get canCancel =>
      status == JobStatus.pending ||
      status == JobStatus.running ||
      status == JobStatus.paused;
  bool get canReschedule =>
      status == JobStatus.failed || status == JobStatus.cancelled;
  bool get isActive =>
      status == JobStatus.running || status == JobStatus.retrying;
  bool get isCompleted => status == JobStatus.completed;
  bool get hasError => status == JobStatus.failed;
  bool get isWaiting => status == JobStatus.pending;

  String get progressText {
    if (status == JobStatus.completed) return '100%';
    if (status == JobStatus.pending) return '0%';
    return '${(progress * 100).toInt()}%';
  }

  String get durationText {
    if (duration.inHours > 0) {
      return '${duration.inHours}h ${duration.inMinutes % 60}m';
    } else if (duration.inMinutes > 0) {
      return '${duration.inMinutes}m ${duration.inSeconds % 60}s';
    } else {
      return '${duration.inSeconds}s';
    }
  }

  String get estimatedRemainingText {
    if (estimatedRemaining.inHours > 0) {
      return '${estimatedRemaining.inHours}h ${estimatedRemaining.inMinutes % 60}m remaining';
    } else if (estimatedRemaining.inMinutes > 0) {
      return '${estimatedRemaining.inMinutes}m ${estimatedRemaining.inSeconds % 60}s remaining';
    } else if (estimatedRemaining.inSeconds > 0) {
      return '${estimatedRemaining.inSeconds}s remaining';
    } else {
      return 'Completing...';
    }
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Job && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() {
    return 'Job(id: $id, name: $name, status: $status)';
  }
}
