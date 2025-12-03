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
    print('[serverpodDirectoryFinder] Starting directory search');
    final start = startingDirectory?.call(arg) ?? Directory.current;
    print('[serverpodDirectoryFinder] Starting directory: ${start.path}');
    final condition = directoryContentCondition ?? isServerDirectory;
    print(
      '[serverpodDirectoryFinder] Using condition: ${condition == isServerDirectory ? "isServerDirectory" : "custom"}',
    );

    var candidates = <Directory>[];
    var visited = <String>{};

    // 1. Check current directory first (fast path)
    print(
      '[serverpodDirectoryFinder] Step 1: Checking current directory (fast path)',
    );
    if (condition(start)) {
      print(
        '[serverpodDirectoryFinder] ✓ Current directory is a server directory, returning immediately',
      );
      return start;
    }
    print(
      '[serverpodDirectoryFinder] ✗ Current directory is not a server directory',
    );

    // 2. Search child directories (depth 2)
    print(
      '[serverpodDirectoryFinder] Step 2: Searching child directories (max depth: 2)',
    );
    candidates.addAll(
      ServerDirectoryFinder._searchChildrenRecursive(
        start,
        maxDepth: 2,
        visited: visited,
        condition: condition,
      ),
    );
    print(
      '[serverpodDirectoryFinder] Found ${candidates.length} candidate(s) in child directories',
    );

    // Early return if we found candidates in children
    if (candidates.isNotEmpty) {
      print(
        '[serverpodDirectoryFinder] Early return: found candidates in children',
      );
      return _returnCandidates(candidates);
    }
    print(
      '[serverpodDirectoryFinder] No candidates found in children, continuing search',
    );

    // Determine if we should search upward/outward
    print(
      '[serverpodDirectoryFinder] Checking if starting directory is at repository boundary',
    );
    var atBoundary = ServerDirectoryFinder._isRepositoryBoundary(start);
    print('[serverpodDirectoryFinder] At boundary: $atBoundary');

    if (!atBoundary) {
      // 3. Check for standard naming pattern siblings
      print(
        '[serverpodDirectoryFinder] Step 3: Checking for sibling server directories',
      );
      var siblingServer = ServerDirectoryFinder._findSiblingServer(
        start,
        condition,
      );
      if (siblingServer != null) {
        print(
          '[serverpodDirectoryFinder] ✓ Found sibling server directory: ${siblingServer.path}',
        );
        // Found sibling match, return immediately
        return siblingServer;
      }
      print('[serverpodDirectoryFinder] ✗ No sibling server directory found');

      // 4. Search upward through parent directories
      print(
        '[serverpodDirectoryFinder] Step 4: Searching upward through parent directories (max levels: $maxUpwardLevels)',
      );
      var current = start.parent;
      for (var i = 0; i < maxUpwardLevels; i++) {
        print(
          '[serverpodDirectoryFinder] Upward search level $i: checking ${current.path}',
        );
        if (current.path == current.parent.path) {
          print(
            '[serverpodDirectoryFinder] Reached filesystem root, stopping upward search',
          );
          break;
        }

        print(
          '[serverpodDirectoryFinder] Checking if parent directory is a server directory',
        );
        if (condition(current)) {
          print(
            '[serverpodDirectoryFinder] ✓ Parent directory is a server directory: ${current.path}',
          );
          candidates.add(current);
        } else {
          print(
            '[serverpodDirectoryFinder] ✗ Parent directory is not a server directory',
          );
        }

        var isAtBoundary = ServerDirectoryFinder._isRepositoryBoundary(current);
        print(
          '[serverpodDirectoryFinder] Parent directory at boundary: $isAtBoundary',
        );

        // At boundaries (like .git), search deeper to find nested servers
        var searchDepth = isAtBoundary ? 2 : 1;
        print(
          '[serverpodDirectoryFinder] Searching children of parent (depth: $searchDepth)',
        );
        candidates.addAll(
          ServerDirectoryFinder._searchChildrenRecursive(
            current,
            maxDepth: searchDepth,
            visited: visited,
            condition: condition,
          ),
        );
        print(
          '[serverpodDirectoryFinder] Total candidates after level $i: ${candidates.length}',
        );

        if (isAtBoundary || candidates.isNotEmpty) {
          if (isAtBoundary) {
            print(
              '[serverpodDirectoryFinder] Stopping upward search: reached boundary',
            );
          } else {
            print(
              '[serverpodDirectoryFinder] Stopping upward search: found candidates',
            );
          }
          break;
        }

        current = current.parent;
      }
    } else {
      print(
        '[serverpodDirectoryFinder] Skipping upward/sibling search: starting directory is at boundary',
      );
    }

    // Remove duplicates and return result
    print(
      '[serverpodDirectoryFinder] Final step: processing ${candidates.length} candidate(s)',
    );
    return _returnCandidates(candidates);
  };
}

/// Helper function to handle candidate results.
/// Returns single directory, throws exception for multiple, or returns null.
Directory? _returnCandidates(List<Directory> candidates) {
  print('[_returnCandidates] Processing ${candidates.length} candidate(s)');
  // Remove duplicates by normalized path
  var uniquePaths = <String>{};
  var beforeDedup = candidates.length;
  candidates = candidates.where((dir) {
    var canonicalized = p.canonicalize(dir.path);
    if (uniquePaths.contains(canonicalized)) {
      print(
        '[_returnCandidates] Removing duplicate: ${dir.path} (canonical: $canonicalized)',
      );
      return false;
    }
    uniquePaths.add(canonicalized);
    return true;
  }).toList();
  if (candidates.length < beforeDedup) {
    print(
      '[_returnCandidates] Removed ${beforeDedup - candidates.length} duplicate(s), ${candidates.length} unique candidate(s) remaining',
    );
  }

  if (candidates.isEmpty) {
    print('[_returnCandidates] No candidates found, returning null');
    return null;
  } else if (candidates.length == 1) {
    print(
      '[_returnCandidates] Single candidate found: ${candidates.first.path}',
    );
    return candidates.first;
  } else {
    print(
      '[_returnCandidates] Multiple candidates found (${candidates.length}), throwing AmbiguousSearchException',
    );
    for (var i = 0; i < candidates.length; i++) {
      print('[_returnCandidates]   Candidate ${i + 1}: ${candidates[i].path}');
    }
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
    print('[findOrPrompt] Starting findOrPrompt');
    print(
      '[findOrPrompt] Start directory: ${startDir?.path ?? "null (using current)"}',
    );
    print('[findOrPrompt] Interactive mode: $interactive');
    try {
      var result = _finder(startDir);
      if (result != null) {
        print('[findOrPrompt] ✓ Found server directory: ${result.path}');
        log.debug('Found server directory: ${result.path}');
        return result;
      }

      // No server directory found
      var startPath = startDir?.path ?? Directory.current.path;
      print(
        '[findOrPrompt] ✗ No server directory found starting from: $startPath',
      );
      throw ServerpodProjectNotFoundException(
        'No Serverpod server project detected in or near $startPath.\n'
        'Make sure you are in a Serverpod project directory.',
      );
    } on AmbiguousSearchException catch (e) {
      // Multiple server directories found
      print(
        '[findOrPrompt] AmbiguousSearchException: ${e.matches.length} matches found',
      );
      for (var i = 0; i < e.matches.length; i++) {
        print('[findOrPrompt]   Match ${i + 1}: ${e.matches[i].path}');
      }
      if (!interactive) {
        print('[findOrPrompt] Non-interactive mode: throwing exception');
        throw ServerpodProjectNotFoundException(
          'Multiple Serverpod projects detected:\n'
          '${e.matches.map((d) => '  - ${d.path}').join('\n')}\n'
          'Please navigate to one of these directories or use the --directory flag.',
        );
      }
      print('[findOrPrompt] Interactive mode: prompting user for selection');
      return await _promptUserSelection(e.matches);
    }
  }

  /// Searches for Serverpod server directories from the given starting point.
  ///
  /// Returns the found directory, or null if none found.
  /// Throws [AmbiguousSearchException] if multiple directories are found.
  static Directory? search(Directory start) {
    print('[search] Starting search from: ${start.path}');
    var result = _finder(start);
    if (result != null) {
      print('[search] ✓ Found: ${result.path}');
    } else {
      print('[search] ✗ Not found');
    }
    return result;
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
    print('[_findSiblingServer] Checking for sibling server directory');
    print('[_findSiblingServer] Current directory: ${dir.path}');
    var dirName = p.basename(dir.path);
    var parent = dir.parent;
    print(
      '[_findSiblingServer] Directory name: $dirName, parent: ${parent.path}',
    );

    // Check each sibling pattern until we find a match
    for (var pattern in _siblingPatterns) {
      print('[_findSiblingServer] Checking pattern: $pattern');
      if (dirName.endsWith(pattern)) {
        print(
          '[_findSiblingServer] ✓ Directory name ends with pattern: $pattern',
        );
        var baseName = dirName.substring(0, dirName.length - pattern.length);
        var serverDir = Directory(p.join(parent.path, '${baseName}_server'));
        print(
          '[_findSiblingServer] Constructed server directory path: ${serverDir.path}',
        );
        if (serverDir.existsSync()) {
          print(
            '[_findSiblingServer] Server directory exists, checking condition',
          );
          if (condition(serverDir)) {
            print(
              '[_findSiblingServer] ✓ Server directory matches condition: ${serverDir.path}',
            );
            return serverDir;
          } else {
            print(
              '[_findSiblingServer] ✗ Server directory exists but does not match condition',
            );
          }
        } else {
          print('[_findSiblingServer] ✗ Server directory does not exist');
        }
        break; // Found a pattern match, no need to check others
      } else {
        print(
          '[_findSiblingServer] ✗ Directory name does not end with pattern: $pattern',
        );
      }
    }

    print('[_findSiblingServer] No sibling server directory found');
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
    print(
      '[_searchChildrenRecursive] Searching in: ${dir.path} (maxDepth: $maxDepth)',
    );
    if (maxDepth < 0) {
      print('[_searchChildrenRecursive] Max depth < 0, returning empty');
      return [];
    }

    var canonicalizedPath = p.canonicalize(dir.path);
    if (visited.contains(canonicalizedPath)) {
      print(
        '[_searchChildrenRecursive] Already visited: $canonicalizedPath, skipping',
      );
      return [];
    }
    visited.add(canonicalizedPath);
    print('[_searchChildrenRecursive] Marked as visited: $canonicalizedPath');

    var results = <Directory>[];

    try {
      var children = dir.listSync(followLinks: false);
      print(
        '[_searchChildrenRecursive] Found ${children.length} child(ren) in ${dir.path}',
      );
      for (var entity in children) {
        if (entity is! Directory) {
          print(
            '[_searchChildrenRecursive] Skipping non-directory: ${entity.path}',
          );
          continue;
        }

        print(
          '[_searchChildrenRecursive] Checking child directory: ${entity.path}',
        );
        if (condition(entity)) {
          print(
            '[_searchChildrenRecursive] ✓ Child directory matches condition: ${entity.path}',
          );
          results.add(entity);
        } else {
          print(
            '[_searchChildrenRecursive] ✗ Child directory does not match condition',
          );
          if (maxDepth > 0) {
            print(
              '[_searchChildrenRecursive] Recursing into child (remaining depth: ${maxDepth - 1})',
            );
            var subResults = _searchChildrenRecursive(
              entity,
              maxDepth: maxDepth - 1,
              visited: visited,
              condition: condition,
            );
            print(
              '[_searchChildrenRecursive] Recursion returned ${subResults.length} result(s)',
            );
            results.addAll(subResults);
          } else {
            print(
              '[_searchChildrenRecursive] Max depth reached, not recursing',
            );
          }
        }
      }
      print(
        '[_searchChildrenRecursive] Total results from ${dir.path}: ${results.length}',
      );
    } on FileSystemException catch (e) {
      print(
        '[_searchChildrenRecursive] FileSystemException accessing ${dir.path}: $e',
      );
      // skip directories that cannot be accessed
    }

    return results;
  }

  /// Prompts the user to select from multiple server directories.
  static Future<Directory> _promptUserSelection(
    List<Directory> candidates,
  ) async {
    print(
      '[_promptUserSelection] Prompting user to select from ${candidates.length} candidate(s)',
    );
    var options = candidates.map((dir) => Option(dir.path)).toList();

    var selected = await select(
      'Multiple Serverpod server projects found. Select one:',
      options: options,
      logger: log,
    );

    // Find the directory that matches the selected option
    var index = options.indexWhere((opt) => opt.name == selected.name);
    print(
      '[_promptUserSelection] User selected option ${index + 1}: ${candidates[index].path}',
    );
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
    print(
      '[_isRepositoryBoundary] Checking if directory is a boundary: ${dir.path}',
    );
    try {
      var gitDir = Directory(p.join(dir.path, '.git'));
      if (gitDir.existsSync()) {
        print(
          '[_isRepositoryBoundary] ✓ Boundary detected: .git directory exists',
        );
        return true;
      }
      print('[_isRepositoryBoundary] No .git directory');

      var melosFile = File(p.join(dir.path, 'melos.yaml'));
      if (melosFile.existsSync()) {
        print('[_isRepositoryBoundary] ✓ Boundary detected: melos.yaml exists');
        return true;
      }
      print('[_isRepositoryBoundary] No melos.yaml file');

      var pubspecFile = File(p.join(dir.path, 'pubspec.yaml'));
      if (pubspecFile.existsSync()) {
        print(
          '[_isRepositoryBoundary] pubspec.yaml exists, checking for workspace:',
        );
        try {
          var content = pubspecFile.readAsStringSync();
          if (content.contains('workspace:')) {
            print(
              '[_isRepositoryBoundary] ✓ Boundary detected: pubspec.yaml contains workspace:',
            );
            return true;
          }
          print(
            '[_isRepositoryBoundary] pubspec.yaml does not contain workspace:',
          );
        } on FileSystemException catch (e) {
          print(
            '[_isRepositoryBoundary] FileSystemException reading pubspec.yaml: $e',
          );
          // skip files that cannot be read
        }
      } else {
        print('[_isRepositoryBoundary] No pubspec.yaml file');
      }

      var homeDir =
          Platform.environment['HOME'] ?? Platform.environment['USERPROFILE'];
      if (homeDir != null) {
        var canonicalDir = p.canonicalize(dir.path);
        var canonicalHome = p.canonicalize(homeDir);
        if (canonicalDir == canonicalHome) {
          print(
            '[_isRepositoryBoundary] ✓ Boundary detected: directory is home directory ($canonicalDir)',
          );
          return true;
        }
        print(
          '[_isRepositoryBoundary] Not home directory (dir: $canonicalDir, home: $canonicalHome)',
        );
      } else {
        print(
          '[_isRepositoryBoundary] No HOME/USERPROFILE environment variable',
        );
      }

      // Stop at first level within top-level directories to prevent
      // cross-contamination between concurrent or leftover of previous tests
      final topLevelDirectories = [
        p.canonicalize('/'),
        p.canonicalize(Directory.systemTemp.path),
      ];
      var canonicalParent = p.canonicalize(dir.parent.path);
      if (topLevelDirectories.contains(canonicalParent)) {
        print(
          '[_isRepositoryBoundary] ✓ Boundary detected: parent is top-level directory ($canonicalParent)',
        );
        return true;
      }
      print(
        '[_isRepositoryBoundary] Parent is not a top-level directory (dir: $canonicalParent, top-level directories: ${topLevelDirectories.join(', ')})',
      );

      print('[_isRepositoryBoundary] ✗ Not a boundary');
      return false;
    } on FileSystemException catch (e) {
      print(
        '[_isRepositoryBoundary] FileSystemException checking boundary: $e, treating as boundary',
      );
      return true;
    }
  }
}
