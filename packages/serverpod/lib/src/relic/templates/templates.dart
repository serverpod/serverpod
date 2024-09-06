import 'dart:io';

import 'package:mustache_template/mustache.dart';
import 'package:path/path.dart';
import 'package:path/path.dart' as path;
import 'package:serverpod/src/relic/util/log_utils.dart';

/// Loads and caches templates.
class Templates {
  final Map<String, Template> _templates = {};

  /// Loads all templates from web/templates
  Future<void> loadAll({
    Directory? directory,
  }) async {
    var templatesDirectory =
        directory ?? Directory(path.joinAll(['web', 'templates']));

    if (!await templatesDirectory.exists()) return;

    for (var entity in await templatesDirectory.list().toList()) {
      if (entity is File && extension(entity.path).toLowerCase() == '.html') {
        var file = entity;
        var name = basenameWithoutExtension(file.path);
        var data = await file.readAsString();

        _templates[name] = Template(
          data,
          name: name,
        );
      }
    }

    if (isEmpty) {
      logDebug(
        'No webserver relic templates found, template directory path: "${templatesDirectory.path}".',
      );
    }
  }

  /// Retrieves a cached template.
  Template? operator [](String name) {
    return _templates[name];
  }

  /// Returns true if no templates are loaded.
  bool get isEmpty => _templates.isEmpty;
}
