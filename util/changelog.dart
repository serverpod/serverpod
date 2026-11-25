import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:cli_tools/better_command_runner.dart';
import 'package:config/config.dart';
import 'package:path/path.dart' as p;

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
  if (!File(p.join('util', '.serverpod_util_root')).existsSync()) {
    _fail(
      'Run this script from the root of the Serverpod repository, e.g. '
      '`dart run melos run changelog_add`.',
    );
  }

  final runner =
      BetterCommandRunner<OptionDefinition, void>(
          'dart run util/changelog.dart',
          'Manages the pending changelog entries in $_changelogDir.',
          globalOptions: const [],
        )
        ..addCommand(_AddCommand())
        ..addCommand(
          _SimpleCommand(
            'check',
            'Validate the pending entry files in $_changelogDir.',
            _check,
          ),
        )
        ..addCommand(
          _SimpleCommand(
            'preview',
            'Print the pending entries as they would be collected.',
            _preview,
          ),
        )
        ..addCommand(_CollectCommand());

  try {
    await runner.run(arguments);
  } on UsageException catch (e) {
    _fail('$e');
  }
}

enum _AddOption<V extends Object> implements OptionDefinition<V> {
  pr(
    IntOption(
      argName: 'pr',
      helpText: 'Pull request number. Detected with `gh` if omitted.',
      valueHelp: 'number',
      min: 1,
    ),
  ),
  author(
    StringOption(
      argName: 'author',
      helpText: 'GitHub login of the PR author. Detected with `gh` if omitted.',
      valueHelp: 'login',
    ),
  ),
  entry(
    MultiStringOption.noSplit(
      argName: 'entry',
      helpText:
          'Entry like "feat: Adds X". Repeatable. Prompted for if omitted.',
      valueHelp: 'text',
    ),
  );

  const _AddOption(this.option);

  @override
  final ConfigOptionBase<V> option;
}

class _AddCommand extends BetterCommand<_AddOption, void> {
  _AddCommand() : super(options: _AddOption.values);

  @override
  String get name => 'add';

  @override
  String get description =>
      'Add changelog entries for a pull request to $_changelogDir.';

  @override
  bool get takesArguments => false;

  @override
  Future<void> runWithConfig(Configuration<_AddOption> commandConfig) => _add(
    pr: commandConfig.optionalValue(_AddOption.pr)?.toString(),
    author: commandConfig.optionalValue(_AddOption.author),
    entries: commandConfig.optionalValue(_AddOption.entry) ?? const [],
  );
}

enum _CollectOption<V extends Object> implements OptionDefinition<V> {
  version(
    StringOption(
      argName: 'version',
      helpText: 'Version heading. Defaults to the $_versionFile file.',
      valueHelp: 'version',
    ),
  );

  const _CollectOption(this.option);

  @override
  final ConfigOptionBase<V> option;
}

class _CollectCommand extends BetterCommand<_CollectOption, void> {
  _CollectCommand() : super(options: _CollectOption.values);

  @override
  String get name => 'collect';

  @override
  String get description =>
      'Move the pending entries into $_changelogFile and delete the entry '
      'files.';

  @override
  bool get takesArguments => false;

  @override
  void runWithConfig(Configuration<_CollectOption> commandConfig) =>
      _collect(version: commandConfig.optionalValue(_CollectOption.version));
}

/// A command without options.
class _SimpleCommand extends BetterCommand<OptionDefinition, void> {
  _SimpleCommand(this.name, this.description, this._action);

  @override
  final String name;

  @override
  final String description;

  final void Function() _action;

  @override
  bool get takesArguments => false;

  @override
  void runWithConfig(Configuration<OptionDefinition> commandConfig) =>
      _action();
}

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

Future<void> _add({
  required String? pr,
  required String? author,
  required List<String> entries,
}) async {
  // Dart reports `/dev/null` as a terminal, so stdout has to be one too.
  final interactive = stdin.hasTerminal && stdout.hasTerminal;

  var detected = await _detectPullRequest(pr);

  final number = _resolve(
    label: 'Pull request number',
    value: pr,
    detected: detected?.number,
    interactive: interactive,
    validate: (value) => RegExp(r'^[1-9]\d*$').hasMatch(value)
        ? null
        : 'Expected a pull request number, e.g. 1234.',
  );

  if (author == null && detected?.number != number) {
    // A different PR than the branch's was entered, so look up its author.
    detected = await _detectPullRequest(number);
  }

  final login = author != null
      ? null
      : detected?.author ?? await _run('gh', ['api', 'user', '--jq', '.login']);
  final authorSlug = _authorSlug(
    _resolve(
      label: 'PR author GitHub login',
      value: author,
      detected: login == null ? null : _authorSlug(login),
      interactive: interactive,
      validate: (value) => _authorSlug(value).isNotEmpty
          ? null
          : 'Expected a GitHub login, e.g. john_doe.',
    ),
  );

  final added = <String>[];
  for (final entry in entries) {
    final normalized = _normalizeEntry(entry);
    final error = _validateEntry(normalized);
    if (error != null) _fail('Invalid entry "$entry": $error');
    added.add(normalized);
  }

  if (added.isEmpty) {
    if (!interactive) {
      _fail('No entries given. Pass at least one --entry "<type>: <Text>".');
    }
    added.addAll(_promptEntries());
  }

  if (added.isEmpty) _fail('No entries added.');

  final lines = added.map((entry) => '- $entry').join('\n');
  final existing = _entryFiles().where(
    (file) =>
        _fileNamePattern.firstMatch(p.basename(file.path))?.group(2) == number,
  );

  if (existing.isNotEmpty) {
    final file = existing.first;
    final content = file.readAsStringSync().trimRight();
    file.writeAsStringSync('$content\n$lines\n');
    stdout.writeln('Appended ${added.length} entries to ${file.path}');
  } else {
    final timestamp = _formatTimestamp(DateTime.now().toUtc());
    final file = File(
      p.join(_changelogDir, '$timestamp-PR$number-$authorSlug.md'),
    );
    file.writeAsStringSync('$lines\n');
    stdout.writeln('Created ${file.path}');
  }

  stdout.writeln('Commit the file together with the pull request changes.');
}

void _check() {
  final files = _loadEntryFiles();
  final count = files.fold(0, (sum, file) => sum + file.entries.length);
  stdout.writeln(
    'changelog.d: ${files.length} files with $count pending entries are valid.',
  );
}

void _preview() {
  final files = _loadEntryFiles();
  if (files.isEmpty) {
    stdout.writeln('No pending changelog entries.');
    return;
  }
  stdout.write(_buildSection('Unreleased', files));
}

void _collect({required String? version}) {
  final files = _loadEntryFiles();
  if (files.isEmpty) _fail('No pending changelog entries in $_changelogDir.');

  final heading = version ?? File(_versionFile).readAsStringSync().trim();
  if (heading.isEmpty) _fail('Empty version. Pass --version <version>.');

  final changelog = File(_changelogFile);
  final lines = changelog.readAsLinesSync();
  if (lines.any((line) => line.trim() == '## $heading')) {
    _fail(
      '$_changelogFile already has a "## $heading" section. Update '
      '$_versionFile to the version being released or pass --version.',
    );
  }

  // Insert above the latest release, keeping anything before it in place.
  var insertAt = lines.indexWhere((line) => line.startsWith('## '));
  if (insertAt == -1) insertAt = lines.length;

  final head = lines.take(insertAt).join('\n');
  final tail = lines.skip(insertAt).join('\n');
  final section = _buildSection(heading, files);

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
    'under "## $heading" and deleted them from $_changelogDir.\n'
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
    final name = p.basename(entity.path);
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
    final name = p.basename(entity.path);
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
  // `gh pr view` requires the pull request when given `--repo`.
  final selector = pr ?? await _currentBranchHead();
  if (selector == null) return null;

  final output = await _run('gh', [
    'pr',
    'view',
    selector,
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

/// The branch that the current branch is pushed to, as `<owner>:<branch>` when
/// pushed to a fork. Null if the branch was not pushed yet.
Future<String?> _currentBranchHead() async {
  final pushRef =
      await _run('git', ['rev-parse', '--abbrev-ref', '@{push}']) ??
      await _run('git', ['rev-parse', '--abbrev-ref', '@{upstream}']);
  if (pushRef == null) return null;

  // Both remote and branch names can contain slashes.
  final remotes = const LineSplitter().convert(
    await _run('git', ['remote']) ?? '',
  );
  final remote = remotes
      .where((remote) => pushRef.startsWith('$remote/'))
      .fold<String?>(
        null,
        (longest, remote) => longest == null || remote.length > longest.length
            ? remote
            : longest,
      );
  if (remote == null) return null;

  final url = await _run('git', ['remote', 'get-url', '--push', remote]);
  final owner = RegExp(r'[:/]([^/:]+)/[^/]+/?$').firstMatch(url ?? '')?[1];
  if (owner == null) return null;

  // The owner is only accepted for branches of forks.
  final branch = pushRef.substring(remote.length + 1);
  return owner == _repository.split('/').first ? branch : '$owner:$branch';
}

/// The file name form of a GitHub [login]. Bot logins have characters that
/// are not valid in file names, e.g. `app/copilot-swe-agent`.
String _authorSlug(String login) => login
    .replaceAll(RegExp('[^A-Za-z0-9_-]+'), '-')
    .replaceAll(RegExp(r'^[-_]+|-+$'), '');

/// Runs [executable] and returns its trimmed output, or null if it is not
/// installed or fails (e.g. no pull request for the branch yet).
Future<String?> _run(String executable, List<String> arguments) async {
  try {
    final result = await Process.run(executable, arguments);
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
