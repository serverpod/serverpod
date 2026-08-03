import 'dart:io';

import 'package:path/path.dart' as p;
import 'package:uuid/uuid.dart';
import 'package:yaml/yaml.dart';

/// Resolves anonymous project / checkout identity for analytics without sending
/// any path, URL, or repository name off the machine.
class ProjectIdentity {
  const ProjectIdentity._();

  /// Directory holding the per-clone analytics metadata file.
  ///
  /// In a git checkout this is the shared git common dir, so every worktree of
  /// a clone reads and writes one centralized file (never a per-leaf copy), and
  /// the data is inherently never committed. Outside a repo it falls back to
  /// the gitignored `<serverDir>/.dart_tool/serverpod` directory.
  static String metadataDirectory(String serverDir) {
    final commonDir = gitCommonDir(serverDir);
    if (commonDir != null) return p.join(commonDir, 'serverpod');
    return p.join(serverDir, '.dart_tool', 'serverpod');
  }

  /// Durable project id shared by every checkout of the same repository.
  ///
  /// Derived as `UUIDv5(url-namespace, <normalized remote URL>)`. The remote
  /// URL never leaves the machine — only the irreversible hash. Returns `null`
  /// when there is no resolvable git remote, in which case callers fall back to
  /// the per-clone checkout id.
  static String? durableProjectId(String serverDir) {
    final commonDir = gitCommonDir(serverDir);
    if (commonDir == null) return null;
    final url = _readRemoteUrl(commonDir);
    if (url == null) return null;
    final normalized = normalizeRemoteUrl(url);
    if (normalized == null) return null;
    return const Uuid().v5(Namespace.url.value, normalized);
  }

  /// Resolves the shared git common directory for [serverDir], or `null` when
  /// [serverDir] is not inside a git working tree.
  ///
  /// Walks up to the nearest `.git`. A `.git` directory is the common dir
  /// itself; a `.git` *file* points at a worktree git dir whose `commondir`
  /// references the shared parent — that parent is returned so all worktrees
  /// converge on one location. Lookup stops at a nearer Dart workspace or the
  /// user's home directory so an unrelated outer checkout is not adopted.
  /// Reads git's own files; never spawns `git`.
  static String? gitCommonDir(String serverDir) {
    final dotGit = _findDotGit(serverDir);
    if (dotGit == null) return null;

    switch (FileSystemEntity.typeSync(dotGit)) {
      case FileSystemEntityType.directory:
        return dotGit;
      case FileSystemEntityType.file:
        final gitDir = _readGitdirPointer(dotGit);
        if (gitDir == null) return null;
        final commonDirFile = File(p.join(gitDir, 'commondir'));
        if (!commonDirFile.existsSync()) return gitDir;
        var commonDir = commonDirFile.readAsStringSync().trim();
        if (!p.isAbsolute(commonDir)) {
          commonDir = p.normalize(p.join(gitDir, commonDir));
        }
        return commonDir;
      default:
        return null;
    }
  }

  static String? _findDotGit(String startDir) {
    var dir = _canonicalDirectory(startDir);
    final home = _userHomeDirectory();
    final isInsideHome =
        home != null && (p.equals(home, dir) || p.isWithin(home, dir));
    var isStartDirectory = true;

    while (true) {
      if (isInsideHome && p.equals(dir, home)) return null;

      final dotGit = p.join(dir, '.git');
      if (FileSystemEntity.typeSync(dotGit) != FileSystemEntityType.notFound) {
        return dotGit;
      }

      if (!isStartDirectory && _isDartWorkspace(dir)) return null;

      final parent = p.dirname(dir);
      if (parent == dir) return null;
      dir = parent;
      isStartDirectory = false;
    }
  }

  static String? _userHomeDirectory() {
    final home =
        Platform.environment['HOME'] ?? Platform.environment['USERPROFILE'];
    if (home == null || home.isEmpty) return null;
    return _canonicalDirectory(home);
  }

  static String _canonicalDirectory(String directory) {
    final absolute = p.normalize(p.absolute(directory));
    try {
      return p.canonicalize(Directory(absolute).resolveSymbolicLinksSync());
    } on FileSystemException {
      return absolute;
    }
  }

  static bool _isDartWorkspace(String directory) {
    final pubspec = File(p.join(directory, 'pubspec.yaml'));
    if (!pubspec.existsSync()) return false;

    try {
      final yaml = loadYaml(pubspec.readAsStringSync());
      return yaml is YamlMap && yaml.containsKey('workspace');
    } on FileSystemException {
      return false;
    } on FormatException {
      return false;
    }
  }

  static String? _readGitdirPointer(String dotGitFile) {
    final match = RegExp(
      r'gitdir:\s*(.+)',
    ).firstMatch(File(dotGitFile).readAsStringSync());
    if (match == null) return null;
    var gitDir = match.group(1)!.trim();
    if (!p.isAbsolute(gitDir)) {
      gitDir = p.normalize(p.join(p.dirname(dotGitFile), gitDir));
    }
    return gitDir;
  }

  static String? _readRemoteUrl(String commonDir) {
    final configFile = File(p.join(commonDir, 'config'));
    if (!configFile.existsSync()) return null;

    String? originUrl;
    String? firstUrl;
    String? currentRemote;
    for (final raw in configFile.readAsLinesSync()) {
      final line = raw.trim();
      final section = RegExp(r'^\[remote "([^"]+)"\]$').firstMatch(line);
      if (section != null) {
        currentRemote = section.group(1);
        continue;
      }
      if (line.startsWith('[')) {
        currentRemote = null;
        continue;
      }
      if (currentRemote == null) continue;
      final url = RegExp(r'^url\s*=\s*(.+)$').firstMatch(line);
      if (url != null) {
        final value = url.group(1)!.trim();
        firstUrl ??= value;
        if (currentRemote == 'origin') originUrl = value;
      }
    }
    return originUrl ?? firstUrl;
  }

  /// Normalizes a git remote URL so SSH and HTTPS forms of the same repo
  /// collapse to one canonical string. Returns `null` for empty input.
  ///
  /// `git@github.com:org/repo.git` and `https://github.com/org/repo` both
  /// reduce to `github.com/org/repo`. Credentials are stripped.
  static String? normalizeRemoteUrl(String url) {
    var s = url.trim();
    if (s.isEmpty) return null;

    // scp-like syntax: git@github.com:org/repo(.git)
    final scp = RegExp(r'^[^@/]+@([^:/]+):(.+)$').firstMatch(s);
    if (scp != null) {
      s = '${scp.group(1)}/${scp.group(2)}';
    } else {
      s = s.replaceFirst(RegExp(r'^[a-zA-Z][a-zA-Z0-9+.-]*://'), '');
      s = s.replaceFirst(RegExp(r'^[^@/]+@'), '');
    }
    s = s.toLowerCase();
    s = s.replaceFirst(RegExp(r'\.git$'), '');
    s = s.replaceFirst(RegExp(r'/+$'), '');
    return s.isEmpty ? null : s;
  }
}
