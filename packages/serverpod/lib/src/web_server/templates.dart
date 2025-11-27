import 'dart:io';

import 'package:mustache_template/mustache.dart';
import 'package:path/path.dart';

/// Global access to all templates loaded when starting the webserver.
final Templates templates = Templates();

/// Loads and caches templates.
class Templates {
  final Map<String, Template> _templates = {};

  /// Loads all templates from web/templates recursively
  Future<void> loadAll(Directory templateDirectory) async {
    if (!await templateDirectory.exists()) return;

    await _loadTemplatesRecursively(templateDirectory, '');
  }

  /// Recursively loads templates from subdirectories
  Future<void> _loadTemplatesRecursively(
    Directory dir,
    String relativePath,
  ) async {
    await for (var entity in dir.list()) {
      if (entity is File && extension(entity.path).toLowerCase() == '.html') {
        var file = entity;
        var fileName = basenameWithoutExtension(file.path);

        // Create template key with relative path
        var templateKey = relativePath.isEmpty
            ? fileName
            : '$relativePath/$fileName';

        var data = await file.readAsString();

        _templates[templateKey] = Template(
          data,
          name: templateKey,
        );
      } else if (entity is Directory) {
        var subDirName = basename(entity.path);
        var newRelativePath = relativePath.isEmpty
            ? subDirName
            : '$relativePath/$subDirName';
        await _loadTemplatesRecursively(entity, newRelativePath);
      }
    }
  }

  /// Retrieves a cached template.
  Template? operator [](String name) {
    return _templates[name];
  }

  /// Returns true if no templates are loaded.
  bool get isEmpty => _templates.isEmpty;
}
