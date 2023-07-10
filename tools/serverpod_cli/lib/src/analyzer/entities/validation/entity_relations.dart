


import 'package:serverpod_cli/src/analyzer/entities/definitions.dart';

/// A collection of all parsed entities, and their potential collisions.
class EntityRelations {
  final List<SerializableEntityDefinition> entities;
  late final Map<String, List<SerializableEntityDefinition>> classNames;
  late final Map<String, List<SerializableEntityDefinition>> tableNames;
  late final Map<String, List<SerializableEntityDefinition>> indexNames;

  EntityRelations(this.entities) {
    classNames = _createClassNameMap(entities);
    tableNames = _createTableNameMap(entities);
    indexNames = _createIndexNameMap(entities);
  }

  Map<String, List<SerializableEntityDefinition>> _createTableNameMap(
    List<SerializableEntityDefinition> entities,
  ) {
    Map<String, List<SerializableEntityDefinition>> tableNames = {};
    for (var entity in entities) {
      if (entity is ClassDefinition) {
        var tableName = entity.tableName;
        if (tableName == null) continue;

        tableNames.update(
          tableName,
          (value) => value..add(entity),
          ifAbsent: () => [entity],
        );
      }
    }

    return tableNames;
  }

  Map<String, List<SerializableEntityDefinition>> _createClassNameMap(
    List<SerializableEntityDefinition> entities,
  ) {
    Map<String, List<SerializableEntityDefinition>> classNames = {};
    for (var entity in entities) {
      classNames.update(
        entity.className,
        (value) => value..add(entity),
        ifAbsent: () => [entity],
      );
    }

    return classNames;
  }

  Map<String, List<SerializableEntityDefinition>> _createIndexNameMap(
    List<SerializableEntityDefinition> entities,
  ) {
    Map<String, List<SerializableEntityDefinition>> indexNames = {};
    for (var entity in entities) {
      if (entity is ClassDefinition) {
        var indexes = entity.indexes;
        if (indexes == null) continue;

        for (var index in indexes) {
          indexNames.update(
            index.name,
            (value) => value..add(entity),
            ifAbsent: () => [entity],
          );
        }
      }
    }

    return indexNames;
  }
}