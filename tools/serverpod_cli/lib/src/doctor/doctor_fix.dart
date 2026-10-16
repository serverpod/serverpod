import 'dart:io';

import 'package:path/path.dart' as p;
import 'package:serverpod_cli/src/commands/upgrade/cli_installation.dart';
import 'package:serverpod_cli/src/doctor/doctor_check.dart';
import 'package:serverpod_cli/src/doctor/flutter_check.dart';

/// The comment `doctor --fix` leaves above its line in a shell startup file.
const envFileMarker = '# Added by `serverpod doctor --fix`.';

/// The directories `doctor --fix` puts first on PATH, in order.
///
/// Only Serverpod-managed locations qualify: a Flutter SDK the installer put
/// under [serverpodDirectory], and the `dart install` bin directory when PATH
/// does not already select the managed CLI. A Flutter the user manages is
/// theirs to put on PATH.
List<String> pathEntriesToAdd({
  required final List<DoctorCheckResult> results,
  required final CliInstallation installation,
  required final bool managedExecutableExists,
  required final String serverpodDirectory,
}) {
  final flutterRoot = results
      .where((r) => r.id == FlutterCheck.id && r.isReady)
      .map((r) => r.path)
      .firstOrNull;

  return [
    if (flutterRoot != null && p.isWithin(serverpodDirectory, flutterRoot))
      p.join(flutterRoot, 'bin'),
    if (managedExecutableExists && !installation.pathResolvesToManaged)
      installation.managedBinDirectory,
  ];
}

/// The startup file for the login [shell], or `null` for shells doctor does
/// not know how to edit.
File? startupFileFor({
  required final String? shell,
  required final String home,
}) => switch (shell == null ? null : p.basename(shell)) {
  'zsh' => File(p.join(home, '.zshrc')),
  'bash' => File(p.join(home, '.bashrc')),
  _ => null,
};

/// Writes [envFile] so that sourcing it puts [entries] first on PATH, each
/// once no matter how many times it is sourced.
void writeEnvFile(final File envFile, final List<String> entries) {
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
  envFile
    ..createSync(recursive: true)
    ..writeAsStringSync(buffer.toString());
}

/// The line that sources [envFile] from a startup file, relative to `$HOME`
/// when it is under [home] so the file survives a moved home directory.
String sourceLineFor(final File envFile, {required final String home}) {
  final path = p.isWithin(home, envFile.path)
      ? '\$HOME/${p.relative(envFile.path, from: home)}'
      : envFile.path;
  return '. "$path"';
}

/// Appends the line that sources [envFile] to [startupFile], unless it is
/// already there. Returns whether the file changed.
bool ensureSourced(
  final File startupFile,
  final File envFile, {
  required final String home,
}) {
  final line = sourceLineFor(envFile, home: home);
  if (startupFile.existsSync() &&
      startupFile.readAsStringSync().contains(line)) {
    return false;
  }

  startupFile
    ..createSync(recursive: true)
    ..writeAsStringSync('\n$envFileMarker\n$line\n', mode: FileMode.append);
  return true;
}

String _doubleQuote(final String value) =>
    '"${value.replaceAllMapped(RegExp(r'[\\"$`]'), (m) => '\\${m[0]}')}"';
