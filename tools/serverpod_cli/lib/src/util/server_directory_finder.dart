import 'dart:io';

import 'package:cli_tools/cli_tools.dart';
import 'package:path/path.dart' as p;
import 'package:serverpod_cli/src/config/config.dart';
import 'package:serverpod_cli/src/util/directory.dart';
import 'package:serverpod_cli/src/util/serverpod_cli_logger.dart';

/// A function that finds a directory based on a starting point.
typedef DirectoryFinder<T> = Directory? Function(T arg);

/// A callback to validate directory contents.
typedef DirectoryContentCondition = bool Function(Directory directory);

/// Exception thrown when multiple matching directories are found.
class AmbiguousSearchException implements Exception {
  final List<Directory> matches;

  AmbiguousSearchException(this.matches);

  String get message =>
      'Ambiguous search, multiple candidates found:\n${matches.map((d) => '  - ${d.path}').join('\n')}';

  @override
  String toString() => message;
}

/// Returns a [DirectoryFinder] function that implements the algorithm
/// for finding Serverpod server directories.
///
/// If [startingDirectory] is not provided or returns null,
/// the current directory is used as starting directory.
///
/// If [directoryContentCondition] is provided, it is called with each
/// directory found. If it returns false, the directory is not considered a match.
///
/// The search strategy (stops at first successful tier):
/// 1. Checks the current directory (returns immediately if match)
/// 2. Searches child directories (depth 2, returns if any found)
/// 3. Checks for sibling directories with standard naming patterns (returns if found, only if not at boundary)
/// 4. Searches upward through parent directories (max [maxUpwardLevels] or until boundary)
///    - At each parent level, checks its children for server directories
///
/// The search stops at repository boundaries (e.g., .git directory) to avoid
/// escaping the project and triggering permission checks on system directories.
///
/// If multiple matching directories are found then an
/// [AmbiguousSearchException] is thrown.
///
/// If a single matching directory is found then it is returned, otherwise null.
DirectoryFinder<T> serverpodDirectoryFinder<T>({
  Directory? Function(T arg)? startingDirectory,
  DirectoryContentCondition? directoryContentCondition,
  int maxUpwardLevels = 5,
}) {
  return (T arg) {
    final start = startingDirectory?.call(arg) ?? Directory.current;
    final condition = directoryContentCondition ?? isServerDirectory;

    var candidates = <Directory>[];
    var visited = <String>{};

    // 1. Check current directory first (fast path)
    if (condition(start)) {
      return start;
    }

    // 2. Search child directories (depth 2)
    candidates.addAll(
      ServerDirectoryFinder._searchChildrenRecursive(
        start,
        maxDepth: 2,
        visited: visited,
        condition: condition,
      ),
    );

    // Early return if we found candidates in children
    if (candidates.isNotEmpty) {
      return _returnCandidates(candidates);
    }

    // Determine if we should search upward/outward
    var atBoundary = ServerDirectoryFinder._isRepositoryBoundary(start);

    if (!atBoundary) {
      // 3. Check for standard naming pattern siblings
      var siblingServer = ServerDirectoryFinder._findSiblingServer(
        start,
        condition,
      );
      if (siblingServer != null) {
        // Found sibling match, return immediately
        return siblingServer;
      }

      // 4. Search upward through parent directories
      var current = start.parent;
      for (var i = 0; i < maxUpwardLevels; i++) {
        if (current.path == current.parent.path) break;

        if (condition(current)) {
          candidates.add(current);
        }

        var isAtBoundary = ServerDirectoryFinder._isRepositoryBoundary(current);

        // At boundaries (like .git), search deeper to find nested servers
        var searchDepth = isAtBoundary ? 2 : 1;
        candidates.addAll(
          ServerDirectoryFinder._searchChildrenRecursive(
            current,
            maxDepth: searchDepth,
            visited: visited,
            condition: condition,
          ),
        );

        if (isAtBoundary || candidates.isNotEmpty) break;

        current = current.parent;
      }
    }

    // Remove duplicates and return result
    return _returnCandidates(candidates);
  };
}

/// Helper function to handle candidate results.
/// Returns single directory, throws exception for multiple, or returns null.
Directory? _returnCandidates(List<Directory> candidates) {
  // Remove duplicates by normalized path
  var uniquePaths = <String>{};
  candidates = candidates.where((dir) {
    var normalized = p.normalize(dir.path);
    if (uniquePaths.contains(normalized)) {
      return false;
    }
    uniquePaths.add(normalized);
    return true;
  }).toList();

  if (candidates.isEmpty) {
    return null;
  } else if (candidates.length == 1) {
    return candidates.first;
  } else {
    throw AmbiguousSearchException(candidates);
  }
}

/// Finds Serverpod server directories from anywhere within a project structure.
class ServerDirectoryFinder {
  /// Standard Serverpod sibling directory suffixes.
  /// Used to find server directories from client/flutter directories.
  static const _siblingPatterns = ['_flutter', '_client'];

  /// The directory finder function configured for Serverpod server directories.
  static final DirectoryFinder<Directory?> _finder =
      serverpodDirectoryFinder<Directory?>(
        startingDirectory: (arg) => arg,
        directoryContentCondition: isServerDirectory,
      );

  /// Finds a server directory, prompting the user if multiple are found.
  ///
  /// Throws [ServerpodProjectNotFoundException] if no server directory is found
  /// or if multiple are found and [interactive] is false.
  static Future<Directory> findOrPrompt({
    Directory? startDir,
    // Optional interactive property in case someone wanted to run these CLI commands in a CI/CD environment.
    bool interactive = true,
  }) async {
    try {
      var result = _finder(startDir);
      if (result != null) {
        log.debug('Found server directory: ${result.path}');
        return result;
      }

      // No server directory found
      var startPath = startDir?.path ?? Directory.current.path;
      throw ServerpodProjectNotFoundException(
        'No Serverpod server project detected in or near $startPath.\n'
        'Make sure you are in a Serverpod project directory.',
      );
    } on AmbiguousSearchException catch (e) {
      // Multiple server directories found
      if (!interactive) {
        throw ServerpodProjectNotFoundException(
          'Multiple Serverpod projects detected:\n'
          '${e.matches.map((d) => '  - ${d.path}').join('\n')}\n'
          'Please navigate to one of these directories or use the --directory flag.',
        );
      }
      return await _promptUserSelection(e.matches);
    }
  }

  /// Searches for Serverpod server directories from the given starting point.
  ///
  /// Returns the found directory, or null if none found.
  /// Throws [AmbiguousSearchException] if multiple directories are found.
  static Directory? search(Directory start) {
    return _finder(start);
  }

  /// Attempts to find a sibling server directory based on naming conventions.
  ///
  /// Checks for standard Serverpod naming patterns:
  /// - myapp_flutter → myapp_server
  /// - myapp_client → myapp_server
  static Directory? _findSiblingServer(
    Directory dir,
    DirectoryContentCondition condition,
  ) {
    var dirName = p.basename(dir.path);
    var parent = dir.parent;

    // Check each sibling pattern until we find a match
    for (var pattern in _siblingPatterns) {
      if (dirName.endsWith(pattern)) {
        var baseName = dirName.substring(0, dirName.length - pattern.length);
        var serverDir = Directory(p.join(parent.path, '${baseName}_server'));
        if (serverDir.existsSync() && condition(serverDir)) {
          return serverDir;
        }
        break; // Found a pattern match, no need to check others
      }
    }

    return null;
  }

  /// Recursively searches child directories for server directories.
  ///
  /// [maxDepth] controls how deep to search (0 = only immediate children).
  /// [visited] tracks directories we've already checked to avoid cycles.
  static List<Directory> _searchChildrenRecursive(
    Directory dir, {
    required int maxDepth,
    required Set<String> visited,
    required DirectoryContentCondition condition,
  }) {
    if (maxDepth < 0) return [];

    var normalizedPath = p.normalize(dir.path);
    if (visited.contains(normalizedPath)) return [];
    visited.add(normalizedPath);

    var results = <Directory>[];

    try {
      var children = dir.listSync(followLinks: false);
      for (var entity in children) {
        if (entity is! Directory) continue;

        if (condition(entity)) {
          results.add(entity);
        } else if (maxDepth > 0) {
          results.addAll(
            _searchChildrenRecursive(
              entity,
              maxDepth: maxDepth - 1,
              visited: visited,
              condition: condition,
            ),
          );
        }
      }
    } on FileSystemException catch (_) {
      // skip directories that cannot be accessed
    }

    return results;
  }

  /// Prompts the user to select from multiple server directories.
  static Future<Directory> _promptUserSelection(
    List<Directory> candidates,
  ) async {
    var options = candidates.map((dir) => Option(dir.path)).toList();

    var selected = await select(
      'Multiple Serverpod server projects found. Select one:',
      options: options,
      logger: log,
    );

    // Find the directory that matches the selected option
    var index = options.indexWhere((opt) => opt.name == selected.name);
    return candidates[index];
  }

  /// Checks if a directory is a repository or workspace boundary.
  ///
  /// Boundaries include:
  /// - Git repository root (.git directory)
  /// - Dart/Flutter workspace (melos.yaml, pubspec.yaml with workspace definition)
  /// - User's home directory
  ///
  /// This prevents the search from escaping the project and accessing
  /// system directories that may trigger permission prompts.
  static bool _isRepositoryBoundary(Directory dir) {
    try {
      var gitDir = Directory(p.join(dir.path, '.git'));
      if (gitDir.existsSync()) return true;

      var melosFile = File(p.join(dir.path, 'melos.yaml'));
      if (melosFile.existsSync()) return true;

      var pubspecFile = File(p.join(dir.path, 'pubspec.yaml'));
      if (pubspecFile.existsSync()) {
        try {
          var content = pubspecFile.readAsStringSync();
          if (content.contains('workspace:')) return true;
        } on FileSystemException catch (_) {
          // skip files that cannot be read
        }
      }
      var homeDir =
          Platform.environment['HOME'] ?? Platform.environment['USERPROFILE'];
      if (homeDir != null && p.normalize(dir.path) == p.normalize(homeDir)) {
        return true;
      }

      // Stop at first level within top-level directories to prevent
      // cross-contamination between concurrent or leftover of previous tests
      final topLevelDirectories = [Directory.systemTemp.path, '/'];
      if (topLevelDirectories.contains(p.normalize(dir.parent.path))) {
        return true;
      }

      return false;
    } on FileSystemException catch (_) {
      return true;
    }
  }
}
