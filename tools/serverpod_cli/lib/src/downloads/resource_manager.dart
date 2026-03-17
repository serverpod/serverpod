import 'dart:io';

import 'package:archive/archive.dart';
import 'package:cli_tools/cli_tools.dart';
import 'package:collection/collection.dart';
import 'package:http/http.dart' as http;
import 'package:path/path.dart' as p;
import 'package:serverpod_cli/src/downloads/resource_manager_constants.dart';
import 'package:serverpod_cli/src/generated/version.dart';
import 'package:serverpod_cli/src/shared/environment.dart';
import 'package:serverpod_cli/src/util/serverpod_cli_logger.dart';
import 'package:uuid/uuid.dart';

final resourceManager = ResourceManager();

class ResourceManager {
  static int? _runCount;

  Directory get localStorageDirectory =>
      Directory(p.join(LocalStorageManager.homeDirectory.path, '.serverpod'));

  Directory get versionedDir =>
      Directory(p.join(localStorageDirectory.path, templateVersion));

  Directory get templateDirectory {
    if (productionMode) {
      return Directory(p.join(versionedDir.path, 'serverpod_template'));
    } else {
      return Directory(
        p.join(serverpodHome, 'templates', 'serverpod_templates'),
      );
    }
  }

  String? get uniqueUserId {
    const uuidFilePath = 'uuid';
    try {
      var userIdFile = File(p.join(localStorageDirectory.path, uuidFilePath));
      var userId = userIdFile.readAsStringSync();
      return userId;
    } catch (e) {
      // Failed to read userId from file, it's probably not created.
    }

    var userId = const Uuid().v4();
    try {
      var userIdFile = File(p.join(localStorageDirectory.path, uuidFilePath));
      userIdFile.createSync(recursive: true);
      userIdFile.writeAsStringSync(userId);
    } catch (e) {
      // Failed to write userId to file. Return null to indicate that the UUID
      // is not available for this session.
      return null;
    }

    return userId;
  }

  int get runCount {
    if (_runCount != null) {
      return _runCount!;
    }

    var count = _readCurrentRunCount() + 1;
    _atomicSaveRunCount(count);
    _deleteOldRunCountFiles();
    _runCount = count;
    return count;
  }

  static const _runCountPrefix = 'run_count_';

  List<File>? _cachedPreviousRunCountFiles;
  List<File> get _previousRunCountFiles {
    if (_cachedPreviousRunCountFiles != null) {
      return _cachedPreviousRunCountFiles!;
    }
    try {
      if (localStorageDirectory.existsSync()) {
        _importOldRunCountIfExists();
        _cachedPreviousRunCountFiles = localStorageDirectory
            .listSync()
            .whereType<File>()
            .where((file) => p.basename(file.path).startsWith(_runCountPrefix))
            .toList();
      }
    } catch (e) {
      // Failed to list directory. Assume no files exist.
    }
    _cachedPreviousRunCountFiles ??= [];
    return _cachedPreviousRunCountFiles!;
  }

  /// Import the old run count if it exists to prevent invoking the welcome
  /// and check-in pages for already seen users.
  void _importOldRunCountIfExists() {
    try {
      var oldCountFile = File(p.join(localStorageDirectory.path, 'run_count'));
      var oldRunCountInt = int.parse(oldCountFile.readAsStringSync());
      _atomicSaveRunCount(oldRunCountInt);
      oldCountFile.deleteSync();
    } catch (e) {
      // Failed to import old run count file. Might not exist anymore.
    }
  }

  /// Read the current run count by finding the max 'run_count_*' file.
  int _readCurrentRunCount() {
    var maxCount = _previousRunCountFiles
        .map((file) => p.basename(file.path).substring(_runCountPrefix.length))
        .map(int.parse)
        .maxOrNull;
    return maxCount ?? 0;
  }

  /// Atomically save the new count by creating a new file. This prevents losing
  ///  the count if the process is terminated while saving the new count.
  void _atomicSaveRunCount(int count) {
    try {
      if (!localStorageDirectory.existsSync()) {
        localStorageDirectory.createSync(recursive: true);
      }
      var newFileName = '$_runCountPrefix$count';
      var newFile = File(p.join(localStorageDirectory.path, newFileName));
      newFile.createSync();
    } catch (e) {
      // Failed to save run count. The count won't persist to the next
      // run, but we still track it for this session.
    }
  }

  /// Delete all cached 'run_count_*' files from previous runs.
  void _deleteOldRunCountFiles() {
    try {
      for (var file in _previousRunCountFiles) {
        file.deleteSync();
      }
    } catch (e) {
      // Failed to delete old files. Not critical, since the next run will just
      // pick the max count from all existing files and clean up the old ones.
    }
  }

  Future<void> storeLatestCliVersion(
    PackageVersionData cliVersionData, {
    String? localStoragePath,
  }) async {
    localStoragePath ??= localStorageDirectory.path;

    try {
      await LocalStorageManager.storeJsonFile(
        fileName: ResourceManagerConstants.latestVersionFilePath,
        json: cliVersionData.toJson(),
        localStoragePath: localStoragePath,
      );
    } catch (e) {
      // Failed to store latest cli version to file.
      // Silently ignore since users can't do anything about it.
    }
  }

  Future<PackageVersionData?> tryFetchLatestCliVersion({
    String? localStoragePath,
  }) async {
    localStoragePath ??= localStorageDirectory.path;

    void deleteFile(File file) {
      try {
        file.deleteSync();
      } catch (_) {
        // Failed to delete file.
        // Silently ignore since users can't do anything about it.
      }
    }

    try {
      return await LocalStorageManager.tryFetchAndDeserializeJsonFile(
        fileName: ResourceManagerConstants.latestVersionFilePath,
        localStoragePath: localStoragePath,
        fromJson: PackageVersionData.fromJson,
      );
    } on ReadException catch (e) {
      deleteFile(e.file);
    } on DeserializationException catch (e) {
      deleteFile(e.file);
    }

    return null;
  }

  String get packageDownloadUrl =>
      'https://pub.dev/packages/serverpod_templates/versions/$templateVersion.tar.gz';

  bool get isTemplatesInstalled {
    if (!versionedDir.existsSync() && productionMode) return false;

    return templateDirectory.existsSync();
  }

  Future<void> installTemplates() async {
    log.info('Downloading templates for version $templateVersion');
    if (!versionedDir.existsSync()) versionedDir.createSync(recursive: true);

    var response = await http.get(Uri.parse(packageDownloadUrl));
    var data = response.bodyBytes;

    // var outFile = File(p.join(versionedDir.path, 'serverpod_templates.tar.gz'));
    // outFile.writeAsBytesSync(data);

    // Const constructor was introduced in version 4.0.0 of archive package.
    // At the time this was written, that version was 2 days old and we don't
    // want to force a constraint on the package for this.
    // ignore: prefer_const_constructors
    var unzipped = GZipDecoder().decodeBytes(data);
    var archive = TarDecoder().decodeBytes(unzipped);

    for (var file in archive) {
      var outFileName = p.join(templateDirectory.path, file.name);
      if (file.isFile) {
        var outFile = File(outFileName);
        outFile = await outFile.create(recursive: true);
        await outFile.writeAsBytes(file.content);
      } else {
        await Directory(outFileName).create(recursive: true);
      }
    }
    log.info('Download complete.');
  }
}
