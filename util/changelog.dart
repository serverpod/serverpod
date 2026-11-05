import 'dart:convert';
import 'dart:io';

/// Manages the pending changelog entries in `changelog.d`.
///
/// See `changelog.d/README.md` for the process. Run from the repository root,
/// usually through the melos scripts:
///
/// - `add`: creates (or extends) the entry file for a pull request. Missing
///   values are detected with the GitHub CLI or prompted for.
/// - `check`: validates the names and contents of the pending entry files.
/// - `preview`: prints the pending entries as they would be collected.
/// - `collect`: moves the pending entries into `CHANGELOG.md` under a new
///   version heading and deletes the entry files.
Future<void> main(List<String> arguments) async {
  if (!File('util/.serverpod_util_root').existsSync()) {
    _fail(
      'Run this script from the root of the Serverpod repository, e.g. '
      '`dart run melos run changelog_add`.',
    );
  }

  if (arguments.isEmpty || const {'-h', '--help'}.contains(arguments.first)) {
    stdout.writeln(_usage);
    return;
  }

  final command = arguments.first;
  final options = _Options.parse(arguments.skip(1).toList());

  switch (command) {
    case 'add':
      await _add(options);
    case 'check':
      _check(options);
    case 'preview':
      _preview(options);
    case 'collect':
      _collect(options);
    default:
      _fail('Unknown command "$command".\n\n$_usage');
  }
}

const _usage = '''
Usage: dart run util/changelog.dart <command> [options]

Commands:
  add       Add changelog entries for a pull request to changelog.d.
              --pr <number>     Pull request number. Detected with `gh` if omitted.
              --author <login>  GitHub login of the PR author. Detected with `gh` if omitted.
              --entry <text>    Entry like "feat: Adds X". Repeatable. Prompted for if omitted.
  check     Validate the pending entry files in changelog.d.
  preview   Print the pending entries as they would be collected.
  collect   Move the pending entries into CHANGELOG.md and delete the entry files.
              --version <v>     Version heading. Defaults to the SERVERPOD_VERSION file.''';

const _changelogDir = 'changelog.d';
const _changelogFile = 'CHANGELOG.md';
const _versionFile = 'SERVERPOD_VERSION';

/// Pull requests target upstream even when `gh` defaults to a fork.
const _repository = 'serverpod/serverpod';

/// The PR title types (see `.github/workflows/title-validation.yaml`) that can
/// describe a user-facing change.
const _entryTypes = ['feat', 'fix', 'perf', 'refactor', 'docs', 'chore'];

/// The PR title types that are always internal and never get an entry.
const _internalTypes = ['build', 'ci', 'revert', 'style', 'test'];

final _entryPattern = RegExp('^(${_entryTypes.join('|')}): [A-Z]');
final _fileNamePattern = RegExp(
  r'^(\d{14})-PR([1-9]\d*)-([A-Za-z0-9][A-Za-z0-9_-]*)\.md$',
);

Future<void> _add(_Options options) async {
  options.ensureOnly(const {'pr', 'author', 'entry'});
  // Dart reports `/dev/null` as a terminal, so stdout has to be one too.
  final interactive = stdin.hasTerminal && stdout.hasTerminal;

  final prOption = options.single('pr');
  var detected = await _detectPullRequest(prOption);

  final pr = _resolve(
    label: 'Pull request number',
    value: prOption,
    detected: detected?.number,
    interactive: interactive,
    validate: (value) => RegExp(r'^[1-9]\d*$').hasMatch(value)
        ? null
        : 'Expected a pull request number, e.g. 1234.',
  );

  final authorOption = options.single('author');
  if (authorOption == null && detected?.number != pr) {
    // A different PR than the branch's was entered, so look up its author.
    detected = await _detectPullRequest(pr);
  }

  final author = _resolve(
    label: 'PR author GitHub login',
    value: authorOption,
    detected: authorOption != null
        ? null
        : detected?.author ?? await _gh(['api', 'user', '--jq', '.login']),
    interactive: interactive,
    validate: (value) => RegExp(r'^[A-Za-z0-9][A-Za-z0-9_-]*$').hasMatch(value)
        ? null
        : 'Expected a GitHub login, e.g. john_doe.',
  );

  final entries = <String>[];
  for (final entry in options.all('entry')) {
    final normalized = _normalizeEntry(entry);
    final error = _validateEntry(normalized);
    if (error != null) _fail('Invalid entry "$entry": $error');
    entries.add(normalized);
  }

  if (entries.isEmpty) {
    if (!interactive) {
      _fail('No entries given. Pass at least one --entry "<type>: <Text>".');
    }
    entries.addAll(_promptEntries());
  }

  if (entries.isEmpty) _fail('No entries added.');

  final lines = entries.map((entry) => '- $entry').join('\n');
  final existing = _entryFiles().where(
    (file) => _fileNamePattern.firstMatch(_baseName(file.path))?.group(2) == pr,
  );

  if (existing.isNotEmpty) {
    final file = existing.first;
    final content = file.readAsStringSync().trimRight();
    file.writeAsStringSync('$content\n$lines\n');
    stdout.writeln('Appended ${entries.length} entries to ${file.path}');
  } else {
    final timestamp = _formatTimestamp(DateTime.now().toUtc());
    final file = File('$_changelogDir/$timestamp-PR$pr-$author.md');
    file.writeAsStringSync('$lines\n');
    stdout.writeln('Created ${file.path}');
  }

  stdout.writeln('Commit the file together with the pull request changes.');
}

void _check(_Options options) {
  options.ensureOnly(const {});
  final files = _loadEntryFiles();
  final count = files.fold(0, (sum, file) => sum + file.entries.length);
  stdout.writeln(
    'changelog.d: ${files.length} files with $count pending entries are valid.',
  );
}

void _preview(_Options options) {
  options.ensureOnly(const {});
  final files = _loadEntryFiles();
  if (files.isEmpty) {
    stdout.writeln('No pending changelog entries.');
    return;
  }
  stdout.write(_buildSection('Unreleased', files));
}

void _collect(_Options options) {
  options.ensureOnly(const {'version'});
  final files = _loadEntryFiles();
  if (files.isEmpty) _fail('No pending changelog entries in $_changelogDir.');

  final version =
      options.single('version') ?? File(_versionFile).readAsStringSync().trim();
  if (version.isEmpty) _fail('Empty version. Pass --version <version>.');

  final changelog = File(_changelogFile);
  final lines = changelog.readAsLinesSync();
  if (lines.any((line) => line.trim() == '## $version')) {
    _fail(
      '$_changelogFile already has a "## $version" section. Update '
      '$_versionFile to the version being released or pass --version.',
    );
  }

  // Insert above the latest release, keeping anything before it in place.
  var insertAt = lines.indexWhere((line) => line.startsWith('## '));
  if (insertAt == -1) insertAt = lines.length;

  final head = lines.take(insertAt).join('\n');
  final tail = lines.skip(insertAt).join('\n');
  final section = _buildSection(version, files);

  changelog.writeAsStringSync(
    [
      if (head.trim().isNotEmpty) '${head.trimRight()}\n\n',
      section,
      if (tail.isNotEmpty) '\n$tail\n',
    ].join(),
  );

  for (final file in files) {
    file.file.deleteSync();
  }

  final count = files.fold(0, (sum, file) => sum + file.entries.length);
  stdout.writeln(
    'Added $count entries from ${files.length} files to $_changelogFile '
    'under "## $version" and deleted them from $_changelogDir.\n'
    'Review the section, group the entries and add the release highlights '
    'before committing.',
  );
}

String _buildSection(String version, List<_EntryFile> files) {
  final entries = files.expand((file) => file.entries).join('\n');
  return '## $version\n\n$entries\n';
}

/// Loads and validates every pending entry file, sorted by timestamp.
///
/// Exits with all the problems found if any file is invalid, so that a release
/// never collects a partial changelog or leaves files behind.
List<_EntryFile> _loadEntryFiles() {
  final errors = <String>[];
  final files = <_EntryFile>[];

  for (final entity in _entities()) {
    final name = _baseName(entity.path);
    if (entity is! File) {
      errors.add('$name: unexpected directory.');
      continue;
    }

    final match = _fileNamePattern.firstMatch(name);
    if (match == null) {
      errors.add(
        '$name: must be named <yyyyMMddHHmmss>-PR<number>-<author>.md.',
      );
      continue;
    }

    final timestamp = match.group(1)!;
    if (!_isValidTimestamp(timestamp)) {
      errors.add('$name: "$timestamp" is not a valid yyyyMMddHHmmss time.');
    }

    final entries = <String>[];
    final lines = const LineSplitter().convert(entity.readAsStringSync());
    for (var i = 0; i < lines.length; i++) {
      final line = lines[i];
      if (line.trim().isEmpty) continue;

      // Indented lines continue the previous entry, e.g. when wrapped.
      if (line.startsWith(RegExp(r'\s')) && entries.isNotEmpty) {
        entries.add(line.trimRight());
        continue;
      }

      final error = line.startsWith('- ')
          ? _validateEntry(line.substring(2))
          : 'expected a list item starting with "- ".';
      if (error != null) {
        errors.add('$name:${i + 1}: $error');
      } else {
        entries.add(line.trimRight());
      }
    }

    if (entries.isEmpty && !errors.any((e) => e.startsWith('$name:'))) {
      errors.add('$name: has no entries.');
    }

    files.add(
      _EntryFile(
        file: entity,
        timestamp: timestamp,
        pr: int.parse(match.group(2)!),
        entries: entries,
      ),
    );
  }

  if (errors.isNotEmpty) {
    _fail(
      'Invalid changelog entries in $_changelogDir '
      '(see $_changelogDir/README.md):\n${errors.map((e) => '  $e').join('\n')}',
    );
  }

  return files..sort((a, b) {
    final byTime = a.timestamp.compareTo(b.timestamp);
    if (byTime != 0) return byTime;
    final byPr = a.pr.compareTo(b.pr);
    if (byPr != 0) return byPr;
    return a.file.path.compareTo(b.file.path);
  });
}

/// Every pending entry, skipping the README and hidden files.
List<FileSystemEntity> _entities() {
  return Directory(_changelogDir).listSync().where((entity) {
    final name = _baseName(entity.path);
    return name != 'README.md' && !name.startsWith('.');
  }).toList();
}

List<File> _entryFiles() => _entities().whereType<File>().toList();

String? _validateEntry(String entry) {
  if (_entryPattern.hasMatch(entry)) return null;

  final type = entry.split(':').first.trim();
  if (_internalTypes.contains(type)) {
    return '"$type" changes are internal and do not get a changelog entry '
        '(see $_changelogDir/README.md).';
  }

  return 'expected "<type>: <Description>", where <type> is one of '
      '${_entryTypes.join(', ')} and the description starts with an '
      'uppercase letter.';
}

String _normalizeEntry(String entry) {
  final trimmed = entry.trim();
  return trimmed.startsWith('- ') ? trimmed.substring(2).trim() : trimmed;
}

List<String> _promptEntries() {
  stdout.writeln(
    'Enter the changelog entries, one per line, as "<type>: <Description>" '
    '(e.g. "feat: Adds X"). Leave empty to finish.',
  );

  final entries = <String>[];
  while (true) {
    stdout.write('> ');
    final line = stdin.readLineSync();
    if (line == null || line.trim().isEmpty) return entries;

    final entry = _normalizeEntry(line);
    final error = _validateEntry(entry);
    if (error != null) {
      stderr.writeln('Invalid entry: $error');
      continue;
    }
    entries.add(entry);
  }
}

/// Returns [value] if given, otherwise prompts with [detected] as the default
/// when [interactive], or uses [detected] as is.
String _resolve({
  required String label,
  required String? value,
  required String? detected,
  required bool interactive,
  required String? Function(String value) validate,
}) {
  if (value != null) {
    final error = validate(value);
    if (error != null) _fail('$label: $error');
    return value;
  }

  if (!interactive) {
    if (detected == null) {
      _fail('$label could not be detected with the GitHub CLI. Pass it.');
    }
    return detected;
  }

  while (true) {
    stdout.write(detected == null ? '$label: ' : '$label [$detected]: ');
    final input = stdin.readLineSync()?.trim() ?? '';
    final answer = input.isEmpty ? detected : input;
    if (answer == null) continue;

    final error = validate(answer);
    if (error == null) return answer;
    stderr.writeln(error);
  }
}

/// Looks up the pull request (and its author) for [pr], or for the current
/// branch when [pr] is null.
Future<({String number, String author})?> _detectPullRequest(String? pr) async {
  final output = await _gh([
    'pr',
    'view',
    ?pr,
    '--repo',
    _repository,
    '--json',
    'number,author',
    '--jq',
    r'"\(.number) \(.author.login)"',
  ]);
  final parts = output?.split(' ');
  if (parts == null || parts.length != 2) return null;
  return (number: parts[0], author: parts[1]);
}

/// Runs the GitHub CLI and returns its trimmed output, or null if it is not
/// installed or fails (e.g. no pull request for the branch yet).
Future<String?> _gh(List<String> arguments) async {
  try {
    final result = await Process.run('gh', arguments);
    if (result.exitCode != 0) return null;
    final output = (result.stdout as String).trim();
    return output.isEmpty ? null : output;
  } on ProcessException {
    return null;
  }
}

String _formatTimestamp(DateTime time) {
  String two(int value) => value.toString().padLeft(2, '0');
  return '${time.year.toString().padLeft(4, '0')}${two(time.month)}'
      '${two(time.day)}${two(time.hour)}${two(time.minute)}${two(time.second)}';
}

bool _isValidTimestamp(String timestamp) {
  final time = DateTime.utc(
    int.parse(timestamp.substring(0, 4)),
    int.parse(timestamp.substring(4, 6)),
    int.parse(timestamp.substring(6, 8)),
    int.parse(timestamp.substring(8, 10)),
    int.parse(timestamp.substring(10, 12)),
    int.parse(timestamp.substring(12, 14)),
  );
  // DateTime normalizes out-of-range parts, e.g. month 13 to next January.
  return _formatTimestamp(time) == timestamp;
}

String _baseName(String path) => path.split(RegExp(r'[/\\]')).last;

Never _fail(String message) {
  stderr.writeln(message);
  exit(1);
}

class _EntryFile {
  _EntryFile({
    required this.file,
    required this.timestamp,
    required this.pr,
    required this.entries,
  });

  final File file;
  final String timestamp;
  final int pr;
  final List<String> entries;
}

/// Minimal `--name value` / `--name=value` parser, so the script needs no
/// dependencies beyond the SDK.
class _Options {
  _Options(this._values);

  factory _Options.parse(List<String> arguments) {
    final values = <String, List<String>>{};
    for (var i = 0; i < arguments.length; i++) {
      final argument = arguments[i];
      if (!argument.startsWith('--')) {
        _fail('Unexpected argument "$argument".\n\n$_usage');
      }

      final separator = argument.indexOf('=');
      final String name;
      final String value;
      if (separator != -1) {
        name = argument.substring(2, separator);
        value = argument.substring(separator + 1);
      } else {
        name = argument.substring(2);
        if (i + 1 >= arguments.length) _fail('Missing value for --$name.');
        value = arguments[++i];
      }
      values.putIfAbsent(name, () => []).add(value);
    }
    return _Options(values);
  }

  final Map<String, List<String>> _values;

  void ensureOnly(Set<String> allowed) {
    for (final name in _values.keys) {
      if (!allowed.contains(name)) _fail('Unknown option --$name.\n\n$_usage');
    }
  }

  String? single(String name) {
    final values = _values[name];
    if (values == null) return null;
    if (values.length > 1) _fail('--$name can only be given once.');
    return values.single;
  }

  List<String> all(String name) => _values[name] ?? const [];
}
