import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:path/path.dart' as p;
import 'package:uuid/uuid.dart';

import 'project_metadata.dart';

/// Reads and writes `<serverDir>/.dart_tool/serverpod/metadata.json`.
class ProjectMetadataStore {
  static const metadataFileName = 'metadata.json';

  /// Serializes read-modify-write cycles so concurrent updates (e.g. the
  /// command-invocation counter and the generate counter racing during
  /// `generate`) don't clobber each other's increments.
  static Future<void> _lock = Future.value();

  static Future<T> _synchronized<T>(Future<T> Function() action) {
    final completer = Completer<void>();
    final previous = _lock;
    _lock = completer.future;
    return previous
        .then((_) => action())
        .whenComplete(completer.complete);
  }

  static String metadataDirectory(String serverDir) =>
      p.join(serverDir, '.dart_tool', 'serverpod');

  static String metadataFilePath(String serverDir) =>
      p.join(metadataDirectory(serverDir), metadataFileName);

  static Future<ProjectMetadata> loadOrCreate(String serverDir) =>
      _synchronized(() => _loadOrCreate(serverDir));

  static Future<ProjectMetadata> _loadOrCreate(String serverDir) async {
    final file = File(metadataFilePath(serverDir));
    if (await file.exists()) {
      final json =
          jsonDecode(await file.readAsString()) as Map<String, dynamic>;
      return ProjectMetadata.fromJson(json);
    }

    final createdAt = await _resolveProjectCreatedAt(serverDir);
    final metadata = ProjectMetadata(
      projectId: const Uuid().v4(),
      projectCreatedAt: createdAt,
    );
    if (await Directory(serverDir).exists()) {
      await _save(serverDir, metadata);
    }
    return metadata;
  }

  static Future<void> save(String serverDir, ProjectMetadata metadata) =>
      _synchronized(() => _save(serverDir, metadata));

  static Future<void> _save(String serverDir, ProjectMetadata metadata) async {
    final dir = Directory(metadataDirectory(serverDir));
    if (!await dir.exists()) {
      await dir.create(recursive: true);
    }

    final file = File(metadataFilePath(serverDir));
    final tempFile = File(
      '${file.path}.${DateTime.now().microsecondsSinceEpoch}.tmp',
    );
    await tempFile.writeAsString(
      const JsonEncoder.withIndent('  ').convert(metadata.toJson()),
    );
    await tempFile.rename(file.path);
  }

  static Future<DateTime> _resolveProjectCreatedAt(String serverDir) async {
    final generatorYaml = File(p.join(serverDir, 'config', 'generator.yaml'));
    if (await generatorYaml.exists()) {
      return _fileCreationTimeUtc(generatorYaml);
    }

    final pubspec = File(p.join(serverDir, 'pubspec.yaml'));
    if (await pubspec.exists()) {
      return _fileCreationTimeUtc(pubspec);
    }

    return DateTime.now().toUtc();
  }

  static DateTime _fileCreationTimeUtc(File file) {
    return file.statSync().changed.toUtc();
  }

  static int projectAgeDays(ProjectMetadata metadata) {
    final now = DateTime.now().toUtc();
    return now.difference(metadata.projectCreatedAt).inDays;
  }

  static Future<ProjectMetadata> incrementCommandInvocation(
    String serverDir,
    String commandName,
  ) {
    return _synchronized(() async {
      final metadata = await _loadOrCreate(serverDir);
      metadata.commandInvocations[commandName] =
          (metadata.commandInvocations[commandName] ?? 0) + 1;
      await _save(serverDir, metadata);
      return metadata;
    });
  }

  static Future<ProjectMetadata> incrementGenerateCallCount(
    String serverDir,
  ) {
    return _synchronized(() async {
      final metadata = await _loadOrCreate(serverDir);
      metadata.generateCallCount += 1;
      await _save(serverDir, metadata);
      return metadata;
    });
  }

  static Future<ProjectMetadata> initializeNewProject(
    String serverDir, {
    required DateTime projectCreatedAt,
  }) {
    return _synchronized(() async {
      final metadata = ProjectMetadata(
        projectId: const Uuid().v4(),
        projectCreatedAt: projectCreatedAt.toUtc(),
      );
      await _save(serverDir, metadata);
      return metadata;
    });
  }
}
