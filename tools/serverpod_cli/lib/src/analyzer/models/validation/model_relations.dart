import 'package:path/path.dart' as path;
import 'package:serverpod_cli/src/analyzer/models/checker/analyze_checker.dart';
import 'package:serverpod_cli/src/analyzer/models/definitions.dart';
import 'package:serverpod_cli/src/util/model_helper.dart';

typedef ModelWithDocumentPath = ({
  String documentPath,
  SerializableModelDefinition model
});

/// A collection of all parsed models, and their potential collisions.
class ParsedModelsCollection {
  late final Set<String> modules;
  late final Map<String, List<SerializableModelDefinition>> classNames;
  late final Map<String, List<SerializableModelDefinition>> tableNames;
  late final Map<String, List<SerializableModelDefinition>> indexNames;
  late final Map<String, List<ModelWithDocumentPath>> generatedFilePaths;

  ParsedModelsCollection(
    List<({String documentPath, SerializableModelDefinition model})>
        modelWithPath,
  ) {
    var models = modelWithPath.map((e) => e.model).toList();
    modules = models.map((e) => e.type.moduleAlias).nonNulls.toSet();
    classNames = _createClassNameMap(models);
    tableNames = _createTableNameMap(models);
    indexNames = _createIndexNameMap(models);
    generatedFilePaths = _createGenerateFilePathMap(modelWithPath);
  }

  Set<String> get moduleNames => modules;

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

  Map<String, List<ModelWithDocumentPath>> _createGenerateFilePathMap(
    List<ModelWithDocumentPath> models,
  ) {
    Map<String, List<ModelWithDocumentPath>> filePaths = {};
    for (var (:documentPath, :model) in models
        .where((e) => e.model.type.moduleAlias == defaultModuleAlias)) {
      filePaths.update(
        _buildGeneratedFilePath(model),
        (value) => value..add((documentPath: documentPath, model: model)),
        ifAbsent: () => [(documentPath: documentPath, model: model)],
      );
    }

    return filePaths;
  }

  String _buildGeneratedFilePath(SerializableModelDefinition model) {
    return path.joinAll([...model.subDirParts, '${model.fileName}.dart']);
  }

  bool isFilePathUnique(
    SerializableModelDefinition classDefinition,
  ) {
    return generatedFilePaths[_buildGeneratedFilePath(classDefinition)]
            ?.length ==
        1;
  }

  ModelWithDocumentPath? findByGeneratedFilePath(
    SerializableModelDefinition model, {
    SerializableModelDefinition? ignore,
  }) {
    var entries = generatedFilePaths[_buildGeneratedFilePath(model)];
    var filteredEntries = entries?.where((e) => e.model != ignore).toList();
    return filteredEntries?.firstOrNull;
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
