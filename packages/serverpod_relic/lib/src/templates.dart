import 'dart:io';
import 'package:mustache_template/mustache.dart';
import 'package:path/path.dart';

final Templates templates = Templates();

class Templates {
  final Map<String, Template> _templates = {};

  Future<void> loadAll() async {
    var dir = Directory('web/templates');
    for (var entity in await dir.list().toList()) {
      if (entity is File && extension(entity.path).toLowerCase() == '.html') {
        var file = entity;
        var name = basenameWithoutExtension(file.path);
        var data = await file.readAsString();

        print('loaded template: $name');
        _templates[name] = Template(
          data,
          name: name,
        );
      }
    }
    print('Templates loaded');
    print('');
  }

  Template? operator [](String name) {
    return _templates[name];
  }
}