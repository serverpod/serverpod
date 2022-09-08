import 'dart:io';

import 'package:yaml/yaml.dart';
import 'package:yaml/src/error_listener.dart';
import 'package:source_span/source_span.dart';

import '../util/string_validators.dart';
import 'class_generator_dart.dart';
import 'config.dart';
import 'protocol_definition.dart';
import 'serverpod_error_collector.dart';

List<ClassDefinition> performAnalyzeClasses({
  bool verbose = true,
  ServerpodErrorCollector? errorCollector,
}) {
  var classDefinitions = <ClassDefinition>[];
  errorCollector ??= ServerpodErrorCollector();

  // Get list of all files in protocol source directory.
  var sourceDir = Directory(config.protocolSourcePath);
  var sourceFileList = sourceDir.listSync();
  sourceFileList.sort((a, b) => a.path.compareTo(b.path));

  for (var entity in sourceFileList) {
    if (entity is! File || !entity.path.endsWith('.yaml')) {
      if (verbose) print('  - skipping file: ${entity.path}');
      continue;
    }
    // Process a file.
    if (verbose) print('  - processing file: ${entity.path}');

    var yaml = entity.readAsStringSync();
    var analyzer = ClassAnalyzer(
      yaml: yaml,
      sourceFileName: entity.path,
      outFileName: _transformFileNameWithoutPathOrExtension(entity.path),
      errorCollector: errorCollector,
    );
    var classDefinition = analyzer.analyze();
    if (classDefinition != null) {
      classDefinitions.add(classDefinition);
    }
  }

  return classDefinitions;
}

String _transformFileNameWithoutPathOrExtension(String path) {
  var pathComponents = path.split(Platform.pathSeparator);
  var fileName = pathComponents.last;
  fileName = fileName.substring(0, fileName.length - 5);
  return fileName;
}

class ClassAnalyzer {
  final String yaml;
  final String sourceFileName;
  final String outFileName;
  final ServerpodErrorCollector errorCollector;

  ClassAnalyzer({
    required this.yaml,
    required this.sourceFileName,
    required this.outFileName,
    required this.errorCollector,
  });

  ClassDefinition? analyze() {
    var yamlErrorCollector = ErrorCollector();

    var document = loadYamlDocument(
      yaml,
      sourceUrl: Uri.file(sourceFileName),
      errorListener: yamlErrorCollector,
    );

    errorCollector.addErrors(yamlErrorCollector.errors);

    if (errorCollector.errors.isNotEmpty) {
      return null;
    }

    var documentContents = document.contents;

    // Validate document is a map.
    if (documentContents is! YamlMap) {
      errorCollector.addError(SourceSpanException(
        'The top level object in the class yaml file must be a Map.',
        documentContents.span,
      ));
      return null;
    }

    // Validate class name exists and is correct.
    var classNameNode = documentContents.nodes['class'];
    if (classNameNode == null) {
      errorCollector.addError(SourceSpanException(
        'No "class" property is defined.',
        documentContents.span,
      ));
      return null;
    }

    var className = classNameNode.value;
    if (className is! String) {
      errorCollector.addError(SourceSpanException(
        'The "class" property must be a String.',
        classNameNode.span,
      ));
      return null;
    }

    if (!StringValidators.isValidClassName(className)) {
      errorCollector.addError(SourceSpanException(
        'The "class" property must be a valid class name (e.g. CamelCaseString).',
        classNameNode.span,
      ));
      return null;
    }

    // Validate table name.
    String? tableName;
    var tableNameNode = documentContents.nodes['table'];
    if (tableNameNode != null) {
      tableName = tableNameNode.value;
      if (tableName is! String) {
        errorCollector.addError(SourceSpanException(
          'The "table" property must be a String.',
          tableNameNode.span,
        ));
        tableName = null;
      }
      if (tableName != null && !StringValidators.isValidTableName(tableName)) {
        errorCollector.addError(SourceSpanException(
          'The "table" property must be lower_snake_case.',
          tableNameNode.span,
        ));
        tableName = null;
      }
    }

    // Validate fields map exists.
    var fieldsNode = documentContents.nodes['fields'];
    if (fieldsNode == null) {
      errorCollector.addError(SourceSpanException(
        'No "fields" property is defined.',
        documentContents.span,
      ));
      return null;
    }

    if (fieldsNode is! YamlMap) {
      errorCollector.addError(SourceSpanException(
        'The "fields" property must be a Map.',
        documentContents.span,
      ));
      return null;
    }

    // Validate and add fields.
    var fields = <FieldDefinition>[];

    // Add default id field, if object has database table.
    if (tableName != null) {
      fields.add(FieldDefinition('id', 'int?'));
    }

    for (var fieldNameNode in fieldsNode.nodes.keys) {
      // Validate field name.
      if (fieldNameNode is! YamlScalar) {
        errorCollector.addError(SourceSpanException(
          'Keys of "fields" Map must be of type String.',
          fieldNameNode.span,
        ));
        continue;
      }
      var fieldName = fieldNameNode.value;
      if (fieldName is! String) {
        errorCollector.addError(SourceSpanException(
          'Keys of "fields" Map must be of type String.',
          fieldNameNode.span,
        ));
        continue;
      }
      if (!StringValidators.isValidFieldName(fieldName)) {
        errorCollector.addError(SourceSpanException(
          'Keys of "fields" Map must be valid Dart variable names (e.g. camelCaseString).',
          fieldNameNode.span,
        ));
        continue;
      }

      // Field name checks out, let's validate the argument.
      var fieldDescriptionNode = fieldsNode.nodes[fieldNameNode];
      if (fieldDescriptionNode == null) {
        errorCollector.addError(SourceSpanException(
          'Field description is missing.',
          fieldNameNode.span,
        ));
        continue;
      }

      var fieldDescription = fieldDescriptionNode.value;
      if (fieldDescription is! String) {
        errorCollector.addError(SourceSpanException(
          'Field description must be of type String.',
          fieldDescriptionNode.span,
        ));
        continue;
      }

      FieldDefinition fieldDefinition;
      try {
        fieldDefinition = FieldDefinition(fieldName, fieldDescription);
        fields.add(fieldDefinition);
      } catch (e) {
        errorCollector.addError(SourceSpanException(
          'Field description is invalid.',
          fieldDescriptionNode.span,
        ));
        continue;
      }

      // TODO: Better type checks.
    }

    var validDatabaseFieldNames = <String>{};
    for (var field in fields) {
      if (field.scope != FieldScope.api) {
        validDatabaseFieldNames.add(field.name);
      }
    }

    // Validate indexes.
    List<IndexDefinition>? indexes;

    var indexesNode = documentContents.nodes['indexes'];
    if (indexesNode != null) {
      if (indexesNode is! YamlMap) {
        errorCollector.addError(SourceSpanException(
          'The "indexes" property must be a Map.',
          indexesNode.span,
        ));
        return null;
      }

      indexes = [];

      indexLoop:
      for (var indexNameNode in indexesNode.nodes.keys) {
        // Validate index name.
        if (indexNameNode is! YamlScalar) {
          errorCollector.addError(SourceSpanException(
            'Keys of "indexes" Map must be of type String.',
            indexNameNode.span,
          ));
          continue;
        }

        var indexName = indexNameNode.value;
        if (indexName is! String) {
          errorCollector.addError(SourceSpanException(
            'Keys of "indexes" Map must be of type String.',
            indexNameNode.span,
          ));
          continue;
        }

        if (!StringValidators.isValidTableIndexName(indexName)) {
          errorCollector.addError(SourceSpanException(
            'The index name must be in lower_snake_case.',
            indexNameNode.span,
          ));
          continue;
        }

        // Validate index description.
        var indexDescriptionNode = indexesNode.nodes[indexNameNode];
        if (indexDescriptionNode == null) {
          errorCollector.addError(SourceSpanException(
            'The index is missing a description.',
            indexNameNode.span,
          ));
          continue;
        }
        if (indexDescriptionNode is! YamlMap) {
          errorCollector.addError(SourceSpanException(
            'The index description mus be of type Map.',
            indexDescriptionNode.span,
          ));
          continue;
        }

        // Validate index fields.
        var fieldsNode = indexDescriptionNode.nodes['fields'];
        if (fieldsNode == null) {
          errorCollector.addError(SourceSpanException(
            'The "fields" property must be defined for an index.',
            indexDescriptionNode.span,
          ));
          continue;
        }
        var fieldsStr = fieldsNode.value;
        if (fieldsStr is! String) {
          errorCollector.addError(SourceSpanException(
            'The "fields" property must be of type String.',
            fieldsNode.span,
          ));
          continue;
        }

        var fieldNames =
            fieldsStr.split(',').map((String str) => str.trim()).toList();
        if (fieldNames.isEmpty) {
          errorCollector.addError(SourceSpanException(
            'The "fields" property must be defined.',
            fieldsNode.span,
          ));
          continue;
        }
        for (var fieldName in fieldNames) {
          if (!validDatabaseFieldNames.contains(fieldName)) {
            errorCollector.addError(SourceSpanException(
              'The field name "$fieldName" is not added to the class or has an api scope.',
              fieldsNode.span,
            ));
            continue indexLoop;
          }
        }

        // Validate index type.
        String type;
        var typeNode = indexDescriptionNode.nodes['type'];
        if (typeNode == null) {
          type = 'btree';
        } else {
          var typeStr = typeNode.value;
          if (typeStr is! String) {
            errorCollector.addError(SourceSpanException(
              'The "type" property must be of type String.',
              typeNode.span,
            ));
            continue;
          }

          // TODO: Validate types
          type = typeStr;
        }

        // Validate unique index.
        bool unique;
        var uniqueNode = indexDescriptionNode.nodes['unique'];
        if (uniqueNode == null) {
          unique = false;
        } else {
          var uniqueStr = uniqueNode.value;
          if (uniqueStr is! String) {
            errorCollector.addError(SourceSpanException(
              'The "unique" property must be of type String.',
              uniqueNode.span,
            ));
            continue;
          }
          if (uniqueStr == 'true') {
            unique = true;
          } else if (uniqueStr == 'false') {
            unique = false;
          } else {
            errorCollector.addError(SourceSpanException(
              'The "unique" property must be either "true" or "false"',
              uniqueNode.span,
            ));
            continue;
          }
        }

        var indexDefinition = IndexDefinition.parsed(
          name: indexName,
          type: type,
          unique: unique,
          fields: fieldNames,
        );
        indexes.add(indexDefinition);
      }
    }

    return ClassDefinition(
      className: className,
      tableName: tableName,
      fileName: outFileName,
      fields: fields,
      indexes: indexes,
    );
  }
}
