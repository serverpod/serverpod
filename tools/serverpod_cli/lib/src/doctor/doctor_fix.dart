import 'dart:io';

import 'package:path/path.dart' as p;
import 'package:serverpod_cli/src/commands/upgrade/cli_installation.dart';
import 'package:serverpod_cli/src/util/sdk_resolver.dart';

/// The comment `doctor --fix` leaves above its line in a shell startup file.
const envFileMarker = '# Added by `serverpod doctor --fix`.';

/// Where the installer puts the Flutter SDK it manages, under
/// [serverpodDirectory].
String managedFlutterRootIn(String serverpodDirectory) =>
    p.join(serverpodDirectory, 'flutter');

/// The directories `doctor --fix` puts first on PATH, in order.
///
/// Only Serverpod-managed locations qualify: the Flutter SDK the installer
/// put under [serverpodDirectory], and the `dart install` bin directory once
/// a managed CLI exists. A Flutter the user manages is theirs to put on PATH.
///
/// Decided from what is on disk, not from the current PATH: a rerun from a
/// shell that has not sourced the env file must produce the same entries.
List<String> pathEntriesToAdd({
  required CliInstallation installation,
  required bool managedExecutableExists,
  required String serverpodDirectory,
}) {
  final flutterRoot = managedFlutterRootIn(serverpodDirectory);
  return [
    if (isFlutterSdk(flutterRoot)) p.join(flutterRoot, 'bin'),
    if (managedExecutableExists) installation.managedBinDirectory,
  ];
}

/// The startup files to source the env file from for the login [shell], or
/// an empty list for shells doctor does not know how to edit.
///
/// Interactive shells read the rc file. Login shells, such as SSH sessions
/// and `bash -lc`, read a profile instead, and Ubuntu's stock `.bashrc`
/// returns early when not interactive, so the profile gets its own line.
/// bash reads only the first of `.bash_profile`, `.bash_login`, and
/// `.profile` that exists. Shells that are neither still need to source the
/// env file themselves.
List<File> startupFilesFor({
  required String? shell,
  required String home,
}) {
  File inHome(String name) => File(p.join(home, name));

  switch (shell == null ? null : p.basename(shell)) {
    case 'zsh':
      return [inHome('.zshrc'), inHome('.zprofile')];
    case 'bash':
      final profiles = ['.bash_profile', '.bash_login', '.profile'].map(inHome);
      return [
        inHome('.bashrc'),
        profiles.firstWhere(
          (f) => f.existsSync(),
          orElse: () => inHome('.profile'),
        ),
      ];
    default:
      return const [];
  }
}

/// Writes [envFile] so that sourcing it puts [entries] first on PATH, each
/// once no matter how many times it is sourced.
void writeEnvFile(File envFile, List<String> entries) {
  envFile
    ..createSync(recursive: true)
    ..writeAsStringSync(envFileContent(entries));
}

/// What [writeEnvFile] writes for [entries].
///
/// An entry already on PATH is left where it is rather than moved to the
/// front. That keeps sourcing idempotent, and it keeps the user's own PATH
/// order: a managed directory never silently overrides a newer SDK or a
/// version-manager shim the user placed ahead of it. [pathWith] applies the
/// same rule in Dart.
String envFileContent(List<String> entries) {
  final buffer = StringBuffer()
    ..writeln('# Serverpod environment, written by `serverpod doctor --fix`.')
    ..writeln('# Safe to source more than once.');
  for (final entry in entries) {
    final quoted = _doubleQuote(entry);
    buffer
      ..writeln('case ":\${PATH}:" in')
      ..writeln('  *:$quoted:*) ;;')
      ..writeln('  *) export PATH=$quoted:"\${PATH}" ;;')
      ..writeln('esac');
  }
  return buffer.toString();
}

/// The PATH a shell has after sourcing the env file for [entries] on top of
/// [currentPath]: the same rule as [envFileContent], so a check run against
/// it sees the executables a new shell will select.
String pathWith(List<String> entries, String currentPath) {
  var path = currentPath;
  for (final entry in entries) {
    final present = path.split(':').contains(entry);
    if (!present) path = path.isEmpty ? entry : '$entry:$path';
  }
  return path;
}

/// The line that sources [envFile] from a startup file, relative to `$HOME`
/// when it is under [home] so the file survives a moved home directory.
String sourceLineFor(File envFile, {required String home}) {
  final path = p.isWithin(home, envFile.path)
      ? '\$HOME/${p.relative(envFile.path, from: home)}'
      : envFile.path;
  return '. "$path"';
}

/// Whether [startupFile] already sources [envFile].
bool startupFileSources(
  File startupFile,
  File envFile, {
  required String home,
}) =>
    startupFile.existsSync() &&
    startupFile.readAsStringSync().contains(sourceLineFor(envFile, home: home));

/// Appends the line that sources [envFile] to [startupFile], unless it is
/// already there. Returns whether the file changed.
bool ensureSourced(
  File startupFile,
  File envFile, {
  required String home,
}) {
  if (startupFileSources(startupFile, envFile, home: home)) return false;
  final line = sourceLineFor(envFile, home: home);

  startupFile
    ..createSync(recursive: true)
    ..writeAsStringSync('\n$envFileMarker\n$line\n', mode: FileMode.append);
  return true;
}

String _doubleQuote(String value) =>
    '"${value.replaceAllMapped(RegExp(r'[\\"$`]'), (m) => '\\${m[0]}')}"';
