import 'dart:io';

import 'package:mustache_template/mustache.dart';
import 'package:path/path.dart';

/// Global access to all templates loaded when starting the webserver.
final Templates templates = Templates();

/// Loads and caches templates.
class Templates {
  final Map<String, Template> _templates = {};

  /// Loads all templates from web/templates
  Future<void> loadAll() async {
    var dir = Directory('web/templates');
    for (var entity in await dir.list().toList()) {
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
  }

  /// Retrieves a cached template.
  Template? operator [](String name) {
    return _templates[name];
  }
}
