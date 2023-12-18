import 'package:serverpod_cli/src/analyzer/entities/checker/analyze_checker.dart';
import 'package:serverpod_cli/src/analyzer/entities/definitions.dart';

/// A collection of all parsed entities, and their potential collisions.
class ModelRelations {
  final List<SerializableModelDefinition> models;
  late final Map<String, List<SerializableModelDefinition>> classNames;
  late final Map<String, List<SerializableModelDefinition>> tableNames;
  late final Map<String, List<SerializableModelDefinition>> indexNames;

  ModelRelations(this.models) {
    classNames = _createClassNameMap(models);
    tableNames = _createTableNameMap(models);
    indexNames = _createIndexNameMap(models);
  }

  bool classNameExists(name) => findAllByClassName(name).isNotEmpty;

  Map<String, List<SerializableModelDefinition>> _createTableNameMap(
    List<SerializableModelDefinition> models,
  ) {
    Map<String, List<SerializableModelDefinition>> tableNames = {};
    for (var model in models) {
      if (model is ClassDefinition) {
        var tableName = model.tableName;
        if (tableName == null) continue;

        tableNames.update(
          tableName,
          (value) => value..add(model),
          ifAbsent: () => [model],
        );
      }
    }

    return tableNames;
  }

  Map<String, List<SerializableModelDefinition>> _createClassNameMap(
    List<SerializableModelDefinition> models,
  ) {
    Map<String, List<SerializableModelDefinition>> classNames = {};
    for (var model in models) {
      classNames.update(
        model.className,
        (value) => value..add(model),
        ifAbsent: () => [model],
      );
    }

    return classNames;
  }

  Map<String, List<SerializableModelDefinition>> _createIndexNameMap(
    List<SerializableModelDefinition> models,
  ) {
    Map<String, List<SerializableModelDefinition>> indexNames = {};
    for (var model in models) {
      if (model is ClassDefinition) {
        var indexes = model.indexes;

        for (var index in indexes) {
          indexNames.update(
            index.name,
            (value) => value..add(model),
            ifAbsent: () => [model],
          );
        }
      }
    }

    return indexNames;
  }

  bool isTableNameUnique(
    SerializableModelDefinition? classDefinition,
    String tableName,
  ) {
    return _isKeyGloballyUnique(classDefinition, tableName, tableNames);
  }

  bool isIndexNameUnique(
    SerializableModelDefinition? classDefinition,
    String indexName,
  ) {
    return _isKeyGloballyUnique(classDefinition, indexName, indexNames);
  }

  List<SerializableModelDefinition> findAllByTableName(
    String tableName, {
    SerializableModelDefinition? ignore,
  }) {
    return _filterIgnored(tableNames[tableName], ignore);
  }

  SerializableModelDefinition? findByTableName(
    String tableName, {
    SerializableModelDefinition? ignore,
  }) {
    var classes = findAllByTableName(tableName, ignore: ignore);
    if (classes.isEmpty) return null;
    return classes.first;
  }

  List<SerializableModelDefinition> findAllByIndexName(
    String indexName, {
    SerializableModelDefinition? ignore,
  }) {
    return _filterIgnored(indexNames[indexName], ignore);
  }

  SerializableModelDefinition? findByIndexName(
    String indexName, {
    SerializableModelDefinition? ignore,
  }) {
    var classes = findAllByIndexName(indexName, ignore: ignore);
    if (classes.isEmpty) return null;
    return classes.first;
  }

  List<SerializableModelDefinition> findAllByClassName(
    String className, {
    SerializableModelDefinition? ignore,
  }) {
    return _filterIgnored(classNames[className], ignore);
  }

  SerializableModelDefinition? findByClassName(
    String className, {
    SerializableModelDefinition? ignore,
  }) {
    var classes = findAllByClassName(className, ignore: ignore);
    if (classes.isEmpty) return null;
    return classes.first;
  }

  List<SerializableModelDefinition> _filterIgnored(
    List<SerializableModelDefinition>? list,
    SerializableModelDefinition? ignore,
  ) {
    if (list == null) return [];
    return list.where((element) => element != ignore).toList();
  }

  List<SerializableModelFieldDefinition> findNamedForeignRelationFields(
    ClassDefinition classDefinition,
    SerializableModelFieldDefinition field,
  ) {
    var relationField = _extractRelationField(classDefinition, field);
    if (relationField == null) return [];

    var fieldRelation = relationField.relation;
    if (fieldRelation == null) return [];

    var relationName = fieldRelation.name;
    if (relationName == null) return [];

    List<SerializableModelDefinition> foreignClasses;

    var relation = field.relation;
    if (field.type.isIdType && relation is ForeignRelationDefinition) {
      foreignClasses = findAllByTableName(relation.parentTable);
    } else {
      String? foreignClassName = extractReferenceClassName(field);
      foreignClasses = findAllByClassName(foreignClassName);
    }

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

  SerializableModelFieldDefinition? _extractRelationField(
    ClassDefinition classDefinition,
    SerializableModelFieldDefinition field,
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
    SerializableModelDefinition? classDefinition,
    String key,
    Map<String, List<SerializableModelDefinition>> map,
  ) {
    var classes = map[key];

    if (classDefinition == null && classes != null && classes.isNotEmpty) {
      return false;
    }

    return classes == null || classes.length == 1;
  }

  String extractReferenceClassName(SerializableModelFieldDefinition field) {
    if (field.type.isListType) {
      return field.type.generics.first.className;
    }

    return field.type.className;
  }
}
