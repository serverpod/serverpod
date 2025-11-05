import 'dart:io';

import 'package:path/path.dart' as p;
import 'package:serverpod_cli/src/config/config.dart';
import 'package:serverpod_cli/src/util/directory.dart';
import 'package:serverpod_cli/src/util/serverpod_cli_logger.dart';

/// The status of a server directory search.
enum SearchStatus {
  found,
  multipleFound,
  notFound,
}

/// The result of searching for a Serverpod server directory.
class SearchResult {
  /// The found server directory, if exactly one was found.
  final Directory? directory;

  /// All candidate server directories found during the search.
  final List<Directory> candidates;

  final SearchStatus status;

  const SearchResult._({
    this.directory,
    required this.candidates,
    required this.status,
  });

  factory SearchResult.single(Directory directory) {
    return SearchResult._(
      directory: directory,
      candidates: [directory],
      status: SearchStatus.found,
    );
  }

  factory SearchResult.multiple(List<Directory> candidates) {
    return SearchResult._(
      candidates: candidates,
      status: SearchStatus.multipleFound,
    );
  }

  factory SearchResult.notFound() {
    return const SearchResult._(
      candidates: [],
      status: SearchStatus.notFound,
    );
  }
}

/// Finds Serverpod server directories from anywhere within a project structure.
class ServerDirectoryFinder {
  /// Finds a server directory, prompting the user if multiple are found.
  ///
  /// Throws [ServerpodProjectNotFoundException] if no server directory is found
  /// or if multiple are found and [interactive] is false.
  static Future<Directory> findOrPrompt({
    Directory? startDir,
    // Optional interactive property in case someone wanted to run these CLI commands in a CI/CD environment.
    bool interactive = true,
  }) async {
    var result = search(startDir ?? Directory.current);

    switch (result.status) {
      case SearchStatus.found:
        log.debug('Found server directory: ${result.directory!.path}');
        return result.directory!;

      case SearchStatus.multipleFound:
        if (!interactive) {
          throw ServerpodProjectNotFoundException(
            'Multiple Serverpod projects detected:\n'
            '${result.candidates.map((d) => '  - ${d.path}').join('\n')}\n'
            'Please navigate to one of these directories or use the --directory flag.',
          );
        }
        return await _promptUserSelection(result.candidates);

      case SearchStatus.notFound:
        var startPath = startDir?.path ?? Directory.current.path;
        throw ServerpodProjectNotFoundException(
          'No Serverpod server project detected in or near $startPath.\n'
          'Make sure you are in a Serverpod project directory.',
        );
    }
  }

  /// Searches for Serverpod server directories from the given starting point.
  ///
  /// The search strategy:
  /// 1. Checks the current directory
  /// 2. Searches child directories (depth 2)
  /// 3. Checks for sibling directories with standard naming patterns (only if not at boundary)
  /// 4. Searches upward through parent directories (max 5 levels or until boundary)
  /// 5. At each parent level, checks its children for server directories
  ///
  /// The search stops at repository boundaries (e.g., .git directory) to avoid
  /// escaping the project and triggering permission checks on system directories.
  static SearchResult search(Directory start) {
    var candidates = <Directory>[];
    var visited = <String>{};

    if (isServerDirectory(start)) {
      return SearchResult.single(start);
    }

    candidates.addAll(
      _searchChildrenRecursive(start, maxDepth: 2, visited: visited),
    );

    var atBoundary = _isRepositoryBoundary(start);

    if (!atBoundary) {
      var siblingServer = _findSiblingServer(start);
      if (siblingServer != null) {
        candidates.add(siblingServer);
      }

      var current = start.parent;
      for (var i = 0; i < 5; i++) {
        if (current.path == current.parent.path) break;

        if (isServerDirectory(current)) {
          candidates.add(current);
        }

        var isAtBoundary = _isRepositoryBoundary(current);

        var searchDepth = isAtBoundary ? 2 : 1;
        candidates.addAll(
          _searchChildrenRecursive(current, maxDepth: searchDepth, visited: visited),
        );

        if (isAtBoundary) break;

        current = current.parent;
      }
    }

    // Remove duplicates by path
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
      return SearchResult.notFound();
    } else if (candidates.length == 1) {
      return SearchResult.single(candidates.first);
    } else {
      return SearchResult.multiple(candidates);
    }
  }

  /// Attempts to find a sibling server directory based on naming conventions.
  static Directory? _findSiblingServer(Directory dir) {
    var dirName = p.basename(dir.path);
    var parent = dir.parent;

    String? baseName;
    if (dirName.endsWith('_flutter')) {
      baseName = dirName.substring(0, dirName.length - 8);
    } else if (dirName.endsWith('_client')) {
      baseName = dirName.substring(0, dirName.length - 7);
    } else if (dirName.endsWith('_app')) {
      baseName = dirName.substring(0, dirName.length - 4);
    }

    if (baseName != null) {
      var serverDir = Directory(p.join(parent.path, '${baseName}_server'));
      if (serverDir.existsSync() && isServerDirectory(serverDir)) {
        return serverDir;
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

        if (isServerDirectory(entity)) {
          results.add(entity);
        } else if (maxDepth > 0) {
          results.addAll(
            _searchChildrenRecursive(
              entity,
              maxDepth: maxDepth - 1,
              visited: visited,
            ),
          );
        }
      }
    } catch (_) {}

    return results;
  }

  /// Prompts the user to select from multiple server directories.
  static Future<Directory> _promptUserSelection(
    List<Directory> candidates,
  ) async {
    log.info('Multiple Serverpod server projects found:');
    for (var i = 0; i < candidates.length; i++) {
      log.info('  ${i + 1}. ${candidates[i].path}');
    }

    stdout.write('\nSelect project (1-${candidates.length}): ');
    var input = stdin.readLineSync();
    var selection = int.tryParse(input ?? '');

    if (selection == null || selection < 1 || selection > candidates.length) {
      throw const ServerpodProjectNotFoundException('Invalid selection');
    }

    return candidates[selection - 1];
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
        } catch (_) {}
      }
      var homeDir = Platform.environment['HOME'] ??
          Platform.environment['USERPROFILE'];
      if (homeDir != null && p.normalize(dir.path) == p.normalize(homeDir)) {
        return true;
      }
      return false;
    } catch (_) {
      return true;
    }
  }
}
