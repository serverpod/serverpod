import 'dart:io';

import 'package:path/path.dart' as p;
import 'package:serverpod_cli/src/util/dart_install.dart';

/// The Serverpod CLI executable name, without platform extension.
const _executableName = 'serverpod';

/// Where the running `serverpod` command came from.
enum CliInstallationKind {
  /// The executable `dart install` manages, which an upgrade replaces.
  managed,

  /// A `serverpod` executable that `dart install` does not manage, typically
  /// a binstub left behind by `dart pub global activate`. An upgrade leaves it
  /// untouched.
  foreign,

  /// Not a `serverpod` executable at all, but `dart run` from a checkout.
  source,
}

/// The Serverpod CLI installations an upgrade involves.
///
/// The running executable, the one `dart install` writes, and the one `PATH`
/// resolves to are separate facts: a successful install says nothing about
/// which version runs the next time `serverpod` is typed.
class CliInstallation {
  final CliInstallationKind kind;

  /// The executable this process is running from.
  final String runningExecutable;

  /// The executable `dart install` writes, and that an upgrade replaces.
  final String managedExecutable;

  /// The first `serverpod` executable on `PATH`, or `null` if there is none.
  /// This runs the next time `serverpod` is typed.
  final String? executableOnPath;

  /// Whether typing `serverpod` runs the executable an upgrade replaces.
  final bool pathResolvesToManaged;

  const CliInstallation({
    required this.kind,
    required this.runningExecutable,
    required this.managedExecutable,
    required this.executableOnPath,
    required this.pathResolvesToManaged,
  });

  /// The directory `dart install` writes executables to.
  String get managedBinDirectory => p.dirname(managedExecutable);

  /// Whether an upgrade replaces the running executable.
  bool get upgradesRunningExecutable => kind == CliInstallationKind.managed;

  /// Inspects the process and environment to find these installations.
  static CliInstallation resolve() {
    final managedExecutable = dartInstalledExecutable(_executableName);
    final executableOnPath = findExecutableOnPath(_executableName);

    final canonicalManaged = _canonicalize(managedExecutable);

    return CliInstallation(
      kind: classifyInstallation(
        runningExecutable: _canonicalize(Platform.resolvedExecutable),
        installRoot: _canonicalize(dartInstallRoot),
      ),
      runningExecutable: Platform.resolvedExecutable,
      managedExecutable: managedExecutable,
      executableOnPath: executableOnPath,
      pathResolvesToManaged:
          executableOnPath != null &&
          isSameExecutable(_canonicalize(executableOnPath), canonicalManaged),
    );
  }
}

/// Determines which installation [runningExecutable] belongs to.
///
/// [installRoot] is the directory `dart install` owns, holding both the bin
/// entries and the app bundles they point at. Where in there the executable
/// sits differs by platform, since the bin entry is a symbolic link on Unix
/// and a batch file wrapper on Windows, so only containment is checked.
///
/// Both paths must be canonical, as produced by [CliInstallation.resolve].
CliInstallationKind classifyInstallation({
  required final String runningExecutable,
  required final String installRoot,
}) {
  if (p.isWithin(installRoot, runningExecutable)) {
    return CliInstallationKind.managed;
  }

  return p.equals(
        p.basenameWithoutExtension(runningExecutable),
        _executableName,
      )
      ? CliInstallationKind.foreign
      : CliInstallationKind.source;
}

/// Returns the first executable named [name] on `PATH`, the way a shell
/// resolves a bare command name, or `null` if there is none.
String? findExecutableOnPath(
  final String name, {
  final Map<String, String>? environment,
}) {
  final env = environment ?? Platform.environment;
  final pathVariable = env['PATH'];
  if (pathVariable == null || pathVariable.isEmpty) return null;

  final extensions = Platform.isWindows
      ? const ['.bat', '.exe', '.cmd']
      : const [''];

  for (final directory in pathVariable.split(Platform.isWindows ? ';' : ':')) {
    if (directory.isEmpty) continue;
    for (final extension in extensions) {
      final candidate = p.join(directory, '$name$extension');
      if (File(candidate).existsSync()) return candidate;
    }
  }

  return null;
}

/// Whether both paths point at the same executable, ignoring the platform
/// extension that distinguishes a binstub from the binary it wraps.
bool isSameExecutable(final String a, final String b) =>
    p.equals(p.dirname(a), p.dirname(b)) &&
    p.equals(p.basenameWithoutExtension(a), p.basenameWithoutExtension(b));

/// Resolves [path] to a comparable absolute path, following symbolic links.
String _canonicalize(final String path) {
  try {
    return File(path).resolveSymbolicLinksSync();
  } catch (_) {
    return p.canonicalize(path);
  }
}
