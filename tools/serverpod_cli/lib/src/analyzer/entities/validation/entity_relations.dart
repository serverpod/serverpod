import 'package:serverpod_cli/src/analyzer/entities/checker/analyze_checker.dart';
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

  bool classNameExists(name) => findAllByClassName(name).isNotEmpty;

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

  bool isTableNameUnique(
    SerializableEntityDefinition? classDefinition,
    String tableName,
  ) {
    return _isKeyGloballyUnique(classDefinition, tableName, tableNames);
  }

  bool isIndexNameUnique(
    SerializableEntityDefinition? classDefinition,
    String indexName,
  ) {
    return _isKeyGloballyUnique(classDefinition, indexName, indexNames);
  }

  List<SerializableEntityDefinition> findAllByTableName(
    String tableName, {
    SerializableEntityDefinition? ignore,
  }) {
    return _filterIgnored(tableNames[tableName], ignore);
  }

  SerializableEntityDefinition? findByTableName(
    String tableName, {
    SerializableEntityDefinition? ignore,
  }) {
    var classes = findAllByTableName(tableName, ignore: ignore);
    if (classes.isEmpty) return null;
    return classes.first;
  }

  List<SerializableEntityDefinition> findAllByIndexName(
    String indexName, {
    SerializableEntityDefinition? ignore,
  }) {
    return _filterIgnored(indexNames[indexName], ignore);
  }

  SerializableEntityDefinition? findByIndexName(
    String indexName, {
    SerializableEntityDefinition? ignore,
  }) {
    var classes = findAllByIndexName(indexName, ignore: ignore);
    if (classes.isEmpty) return null;
    return classes.first;
  }

  List<SerializableEntityDefinition> findAllByClassName(
    String className, {
    SerializableEntityDefinition? ignore,
  }) {
    return _filterIgnored(classNames[className], ignore);
  }

  SerializableEntityDefinition? findByClassName(
    String className, {
    SerializableEntityDefinition? ignore,
  }) {
    var classes = findAllByClassName(className, ignore: ignore);
    if (classes.isEmpty) return null;
    return classes.first;
  }

  List<SerializableEntityDefinition> _filterIgnored(
    List<SerializableEntityDefinition>? list,
    SerializableEntityDefinition? ignore,
  ) {
    if (list == null) return [];
    return list.where((element) => element != ignore).toList();
  }

  List<SerializableEntityFieldDefinition> findNamedForeignRelationFields(
    ClassDefinition classDefinition,
    SerializableEntityFieldDefinition field,
  ) {
    var relationField = _extractRelationField(classDefinition, field);
    if (relationField == null) return [];

    var fieldRelation = relationField.relation;
    if (fieldRelation == null) return [];

    var relationName = fieldRelation.name;
    if (relationName == null) return [];

    String? foreignClassName = extractReferenceClassName(field);

    var foreignClasses = findAllByClassName(foreignClassName);
    if (foreignClasses.isEmpty) return [];

    var foreignClass = foreignClasses.first;
    if (foreignClass is! ClassDefinition) return [];

    return AnalyzeChecker.filterRelationByName(
      classDefinition,
      foreignClass,
      relationField.name,
      relationName,
    );
  }

  SerializableEntityFieldDefinition? _extractRelationField(
    ClassDefinition classDefinition,
    SerializableEntityFieldDefinition field,
  ) {
    var fieldRelation = field.relation;
    if (fieldRelation == null) return field;

    if (!fieldRelation.isForeignKeyOrigin) return field;
    if (fieldRelation is ForeignRelationDefinition) return field;
    if (fieldRelation is ObjectRelationDefinition) {
      return classDefinition.findField(
        fieldRelation.fieldName,
      );
    }

    return null;
  }

  bool _isKeyGloballyUnique(
    SerializableEntityDefinition? classDefinition,
    String key,
    Map<String, List<SerializableEntityDefinition>> map,
  ) {
    var classes = map[key];

    if (classDefinition == null && classes != null && classes.isNotEmpty) {
      return false;
    }

    return classes == null || classes.length == 1;
  }

  String extractReferenceClassName(SerializableEntityFieldDefinition field) {
    if (field.type.isListType) {
      return field.type.generics.first.className;
    }

    return field.type.className;
  }
}
