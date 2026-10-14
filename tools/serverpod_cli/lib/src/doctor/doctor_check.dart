import 'package:pub_semver/pub_semver.dart';

/// The outcome of one `serverpod doctor` check.
enum DoctorStatus {
  /// The tool is present, compatible, and the one PATH selects.
  ready,

  /// The tool could not be found.
  missing,

  /// The tool is present but its version is outside the supported range.
  incompatible,

  /// The tool is present but PATH or its setup selects the wrong one.
  misconfigured,

  /// The probe failed or timed out, so nothing is known either way.
  unknown,
}

/// The one-character marker a report shows in front of a check.
extension DoctorStatusMarker on DoctorStatus {
  String get marker => switch (this) {
    DoctorStatus.ready => '✓',
    DoctorStatus.misconfigured => '!',
    DoctorStatus.unknown => '?',
    DoctorStatus.missing || DoctorStatus.incompatible => '✗',
  };
}

/// What one check found, with the evidence and the fix when not
/// [DoctorStatus.ready].
class DoctorCheckResult {
  /// Stable identifier for scripts consuming `--json`.
  final String id;

  /// Human-readable name of the checked tool.
  final String title;

  final DoctorStatus status;

  /// The detected version, when there is one.
  final String? version;

  /// The executable or SDK root the check selected, when there is one.
  final String? path;

  /// One line of evidence for [status].
  final String message;

  /// What to do about a status other than [DoctorStatus.ready].
  final String? remedy;

  const DoctorCheckResult({
    required this.id,
    required this.title,
    required this.status,
    required this.message,
    this.version,
    this.path,
    this.remedy,
  });

  bool get isReady => status == DoctorStatus.ready;

  Map<String, Object?> toJson() => {
    'id': id,
    'title': title,
    'status': status.name,
    if (version != null) 'version': version,
    if (path != null) 'path': path,
    'message': message,
    if (remedy != null) 'remedy': remedy,
  };
}

/// Parses [version] leniently, returning `null` for anything unparsable.
Version? tryParseVersion(final String? version) {
  if (version == null) return null;
  try {
    return Version.parse(version.trim());
  } on FormatException {
    return null;
  }
}
