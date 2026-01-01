import 'dart:io';

import 'package:cli_tools/cli_tools.dart';

import '../util/serverpod_cli_logger.dart';

/// {@template migration_registry_file}
/// The [MigrationRegistryFile] class is a wrapper around the migration registry file.
/// It provides a simple interface to read and write the migration registry file.
///
/// The migration registry file is a file that contains the list of migrations
/// that have been applied to the database.
///
/// The migration registry file is located in the [MigrationGenerator]
/// directory.
/// {@endtemplate}
class MigrationRegistryFile {
  /// {@macro migration_registry_file}
  MigrationRegistryFile(this.path) : file = File(path);

  /// Path to the migration registry file.
  final String path;

  /// [File] representing the migration registry file.
  final File file;

  /// The start marker for conflicts.
  static const String startMarker = '<<<<<<< HEAD';

  /// The middle marker for conflicts.
  static const String middleMarker = '=======';

  /// The end marker for conflicts.
  static const String endMarker = '>>>>>>>';

  /// Cached contents of the file.
  String? _cachedContent;

  /// Contents of the file.
  String get content => _cachedContent ?? file.readAsStringSync();

  /// Caches the contents of the file.
  void cacheContent() => _cachedContent = file.readAsStringSync();

  /// Invalidates the cached content, forcing a re-read on next access.
  void invalidateCache() => _cachedContent = null;

  /// The list of migrations in the registry file.
  List<String> get migrations => _parseMigrationList(content);

  /// Splits a string into a list of strings, using the given splitter.
  List<String> _splitContent(String section, Pattern splitter) =>
      section.split(splitter).map((s) => s.trim()).toList();

  /// Extracts common, local, and incoming migrations from the [registryContent].
  ///
  /// Returns a tuple of common, local, and incoming migrations.
  ///
  /// If the file does not have a merge conflict, only common migrations are returned.
  ///
  /// Common migrations are the migrations that are present in both the local
  /// and incoming changes.
  ///
  /// Local migrations are the migrations that are present in the local changes
  /// but not in the incoming changes.
  ///
  /// Incoming migrations are the migrations that are present in the incoming
  /// changes but not in the local changes.
  ({List<String> common, List<String> local, List<String> incoming})
  extractMigrations() {
    // Cache the contents of the file for the duration of the method.
    cacheContent();

    // If the file does not have a merge conflict, only common migrations are returned.
    if (!hasMergeConflict) {
      final common = migrations;
      invalidateCache();
      return (common: common, local: [], incoming: []);
    }

    // The content is split into three parts: common, local, and incoming.
    try {
      final commonAndRest = _splitContent(content, startMarker);
      if (commonAndRest.length != 2) {
        throw const FormatException(
          'Malformed merge conflict: invalid start marker',
        );
      }
      final [commonPart, rest] = commonAndRest;

      final localAndRestIncoming = _splitContent(rest, middleMarker);
      if (localAndRestIncoming.length != 2) {
        throw const FormatException(
          'Malformed merge conflict: invalid middle marker',
        );
      }
      final [localPart, restIncoming] = localAndRestIncoming;

      final incomingAndEnd = _splitContent(restIncoming, endMarker);
      if (incomingAndEnd.length != 2) {
        throw const FormatException(
          'Malformed merge conflict: invalid end marker',
        );
      }
      final [incomingPart, _] = incomingAndEnd;

      return (
        common: _parseMigrationList(commonPart),
        local: _parseMigrationList(localPart),
        incoming: _parseMigrationList(incomingPart),
      );
    } on Exception catch (e) {
      log.error(e.toString());
      throw ExitException(ExitException.codeError);
    } finally {
      invalidateCache();
    }
  }

  /// True if the file has a merge conflict.
  bool get hasMergeConflict =>
      content.contains(startMarker) &&
      content.contains(middleMarker) &&
      content.contains(endMarker);

  /// Parses the migration list from the file.
  List<String> _parseMigrationList(String part) {
    return part
        .split('\n')
        .map((m) => m.trim())
        .where(
          (m) =>
              m.isNotEmpty &&
              // Ignore comments
              !m.startsWith('#') &&
              // Ignore conflict markers
              !m.contains(startMarker) &&
              !m.contains(endMarker) &&
              !m.contains(middleMarker),
        )
        .toList();
  }

  /// Updates the registry file with the given [migrationVersions].
  Future<void> update(List<String> migrationVersions) async {
    var out = StringBuffer()
      ..write('''
### AUTOMATICALLY GENERATED DO NOT MODIFY
###
### This file is generated by Serverpod when creating a migration, do not modify it
### manually. If a collision is detected in this file when doing a code merge, resolve
### the conflict by removing and recreating the conflicting migration.

''')
      ..writeAll(migrationVersions, '\n')
      ..write('\n');

    await file.writeAsString(out.toString());

    invalidateCache();
  }
}
