import 'dart:io';

import 'package:source_span/source_span.dart';
import 'package:yaml/src/error_listener.dart';
import 'package:yaml/yaml.dart';
import 'package:path/path.dart' as p;
import '../util/string_validators.dart';
import '../util/extensions.dart';
import '../util/yaml_docs.dart';
import 'class_generator_dart.dart';
import 'code_analysis_collector.dart';
import 'config.dart';
import 'protocol_definition.dart';
import 'types.dart';

List<ProtocolFileDefinition> performAnalyzeClasses({
  bool verbose = true,
  required CodeAnalysisCollector collector,
}) {
  var classDefinitions = <ProtocolFileDefinition>[];

  // Get list of all files in protocol source directory.
  var sourceDir = Directory(config.protocolSourcePath);
  var sourceFileList = sourceDir.listSync(recursive: true);
  sourceFileList.sort((a, b) => a.path.compareTo(b.path));

  for (var entity in sourceFileList) {
    if (entity is! File || !entity.path.endsWith('.yaml')) {
      if (verbose) print('  - skipping file: ${entity.path}');
      continue;
    }
    var otherDir = entity.path
        .replaceAll(config.protocolSourcePath, '')
        .split(Platform.pathSeparator)
        .skipWhile((value) => value.isEmpty);
    String? subDirectory;
    if (otherDir.length > 1) {
      subDirectory = p.joinAll(otherDir.take(otherDir.length - 1));
      print('- subDirectory: ${p.joinAll(otherDir.take(otherDir.length - 1))}');
    }
    // Process a file.
    if (verbose) print('  - processing file: ${entity.path}');
    var yaml = entity.readAsStringSync();
    var analyzer = ClassAnalyzer(
      yaml: yaml,
      sourceFileName: entity.path,
      outFileName: _transformFileNameWithoutPathOrExtension(entity.path),
      collector: collector,
      subDirectory: subDirectory,
    );
    var classDefinition = analyzer.analyze();
    if (classDefinition != null) {
      classDefinitions.add(classDefinition);
    }
  }

  //Detect protocol references
  for (var classDefinition in classDefinitions) {
    if (classDefinition is ClassDefinition) {
      for (var fieldDefinition in classDefinition.fields) {
        fieldDefinition.type =
            fieldDefinition.type.applyProtocolReferences(classDefinitions);
      }
    }
  }

  // Detect enum fields
  for (var classDefinition in classDefinitions) {
    if (classDefinition is ClassDefinition) {
      for (var fieldDefinition in classDefinition.fields) {
        if (fieldDefinition.type.url == 'protocol' &&
            classDefinitions
                .whereType<EnumDefinition>()
                .any((e) => e.className == fieldDefinition.type.className)) {
          fieldDefinition.type.isEnum = true;
        }
      }
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
  final String? subDirectory;
  final CodeAnalysisCollector collector;

  ClassAnalyzer({
    required this.yaml,
    required this.sourceFileName,
    required this.outFileName,
    this.subDirectory,
    required this.collector,
  });

  ProtocolFileDefinition? analyze() {
    var yamlErrorCollector = ErrorCollector();

    YamlDocument document;
    try {
      document = loadYamlDocument(
        yaml,
        sourceUrl: Uri.file(sourceFileName),
        errorListener: yamlErrorCollector,
      );
    } catch (e) {
      if (e is SourceSpanException) {
        collector.addError(e);
        return null;
      }
      rethrow;
    }

    collector.addErrors(yamlErrorCollector.errors);

    if (yamlErrorCollector.errors.isNotEmpty) {
      return null;
    }

    var documentContents = document.contents;

    // Validate document is a map.
    if (documentContents is! YamlMap) {
      collector.addError(SourceSpanException(
        'The top level object in the class yaml file must be a Map.',
        documentContents.span,
      ));
      return null;
    }
    var docsExtractor = YamlDocumentationExtractor(yaml);

    if (documentContents.nodes['class'] != null) {
      return _analyzeClassFile(documentContents, docsExtractor);
    }
    if (documentContents.nodes['enum'] != null) {
      return _analyzeEnumFile(documentContents, docsExtractor);
    }

    collector.addError(SourceSpanException(
      'No "class" or "enum" property is defined.',
      documentContents.span,
    ));
    return null;
  }

  ProtocolFileDefinition? _analyzeClassFile(
      YamlMap documentContents, YamlDocumentationExtractor docsExtractor) {
    if (!_containsOnlyValidKeys(
      documentContents,
      {'class', 'table', 'fields', 'indexes', 'view'},
    )) {
      return null;
    }

    // Validate class name exists and is correct.
    var classNameNode = documentContents.nodes['class'];
    if (classNameNode == null) {
      collector.addError(SourceSpanException(
        'No "class" property is defined.',
        documentContents.span,
      ));
      return null;
    }
    var classDocumentation = docsExtractor
        .getDocumentation(documentContents.key('class')!.span.start);

    var className = classNameNode.value;
    if (className is! String) {
      collector.addError(SourceSpanException(
        'The "class" property must be a String.',
        classNameNode.span,
      ));
      return null;
    }

    if (!StringValidators.isValidClassName(className)) {
      collector.addError(SourceSpanException(
        'The "class" property must be a valid class name (e.g. CamelCaseString).',
        classNameNode.span,
      ));
      return null;
    }

    //Validate only table or view name can be defined
    var tableNameNode = documentContents.nodes['table'];
    var viewNameNode = documentContents.nodes['view'];

    if (tableNameNode != null && viewNameNode != null) {
      collector.addError(SourceSpanException(
        'Only one of "table" or "view" can be defined.',
        documentContents.span,
      ));
      return null;
    }

    // Validate table name.
    String? tableName;
    if (tableNameNode != null) {
      tableName = tableNameNode.value;
      if (tableName is! String) {
        collector.addError(SourceSpanException(
          'The "table" property must be a String.',
          tableNameNode.span,
        ));
        tableName = null;
      }
      if (tableName != null && !StringValidators.isValidTableName(tableName)) {
        collector.addError(SourceSpanException(
          'The "table" property must be lower_snake_case.',
          tableNameNode.span,
        ));
        tableName = null;
      }
    }

    // Validate view name.
    String? viewName;
    if (viewNameNode != null) {
      viewName = viewNameNode.value;
      if (viewName is! String) {
        collector.addError(SourceSpanException(
          'The "view" property must be a String.',
          viewNameNode.span,
        ));
      }
      if (viewName != null && !StringValidators.isValidViewName(viewName)) {
        collector.addError(SourceSpanException(
          'The "view" property must be lower_snake_case.',
          viewNameNode.span,
        ));
        tableName = null;
      }
    }

    // Validate fields map exists.
    var fieldsNode = documentContents.nodes['fields'];
    if (fieldsNode == null) {
      collector.addError(SourceSpanException(
        'No "fields" property is defined.',
        documentContents.span,
      ));
      return null;
    }

    if (fieldsNode is! YamlMap) {
      collector.addError(SourceSpanException(
        'The "fields" property must be a Map.',
        documentContents.span,
      ));
      return null;
    }

    // Validate and add fields.
    var fields = <FieldDefinition>[];

    // Add default id field, if object has database table.
    if (tableName != null) {
      fields.add(FieldDefinition(
        name: 'id',
        type: TypeDefinition.int.asNullable,
        scope: FieldScope.all,
        documentation: [
          '/// The database id, set if the object has been inserted into the',
          '/// database or if it has been fetched from the database. Otherwise,',
          '/// the id will be null.',
        ],
      ));
    }

    for (var fieldNameNode in fieldsNode.nodes.keys) {
      // Validate field name.
      if (fieldNameNode is! YamlScalar) {
        collector.addError(SourceSpanException(
          'Keys of "fields" Map must be of type String.',
          fieldNameNode.span,
        ));
        continue;
      }
      var fieldDocumentation =
          docsExtractor.getDocumentation(fieldNameNode.span.start);
      var fieldName = fieldNameNode.value;
      if (fieldName is! String) {
        collector.addError(SourceSpanException(
          'Keys of "fields" Map must be of type String.',
          fieldNameNode.span,
        ));
        continue;
      }
      if (!StringValidators.isValidFieldName(fieldName)) {
        collector.addError(SourceSpanException(
          'Keys of "fields" Map must be valid Dart variable names (e.g. camelCaseString).',
          fieldNameNode.span,
        ));
        continue;
      }

      // Field name checks out, let's validate the argument.
      var fieldDescriptionNode = fieldsNode.nodes[fieldNameNode];
      if (fieldDescriptionNode == null) {
        collector.addError(SourceSpanException(
          'Field description is missing.',
          fieldNameNode.span,
        ));
        continue;
      }

      var fieldDescription = fieldDescriptionNode.value;
      if (fieldDescription is! String) {
        collector.addError(SourceSpanException(
          'Field description must be of type String.',
          fieldDescriptionNode.span,
        ));
        continue;
      }

      try {
        fieldDescription = fieldDescription.replaceAll(' ', '');
        var typeResult = parseAndAnalyzeType(
          fieldDescription,
          sourceSpan: fieldDescriptionNode.span,
        );

        var fieldOptions =
            fieldDescription.substring(typeResult.parsedPosition).split(',');

        if (fieldOptions
                .where((option) => option == 'database' || option == 'api')
                .length >
            1) {
          collector.addError(SourceSpanException(
            'The field scope (database or api) must at most be set once.',
            fieldDescriptionNode.span,
          ));
          continue;
        }

        var scope = fieldOptions.any((option) => option == 'database')
            ? FieldScope.database
            : fieldOptions.any((option) => option == 'api')
                ? FieldScope.api
                : FieldScope.all;

        if (fieldOptions.where((option) => option.startsWith('parent')).length >
            1) {
          collector.addError(SourceSpanException(
            'Only one parent must be set.',
            fieldDescriptionNode.span,
          ));
          continue;
        }

        var parentTable = fieldOptions
            .whereType<String?>()
            .firstWhere(
              (option) => option?.startsWith('parent=') ?? false,
              orElse: () => null,
            )
            ?.substring(7);

        if (parentTable != null &&
            !StringValidators.isValidTableIndexName(parentTable)) {
          collector.addError(SourceSpanException(
            '$tableName is no valid parent name.',
            fieldDescriptionNode.span,
          ));
          continue;
        }

        var isEnum =
            fieldOptions.whereType<String?>().any((option) => option == 'enum');

        var fieldDefinition = FieldDefinition(
          name: fieldName,
          scope: scope,
          type: typeResult.type..isEnum = isEnum,
          parentTable: parentTable,
          documentation: fieldDocumentation,
        );

        fields.add(fieldDefinition);
      } catch (e) {
        collector.addError(SourceSpanException(
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
        collector.addError(SourceSpanException(
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
          collector.addError(SourceSpanException(
            'Keys of "indexes" Map must be of type String.',
            indexNameNode.span,
          ));
          continue;
        }

        var indexName = indexNameNode.value;
        if (indexName is! String) {
          collector.addError(SourceSpanException(
            'Keys of "indexes" Map must be of type String.',
            indexNameNode.span,
          ));
          continue;
        }

        if (!StringValidators.isValidTableIndexName(indexName)) {
          collector.addError(SourceSpanException(
            'The index name must be in lower_snake_case.',
            indexNameNode.span,
          ));
          continue;
        }

        // Validate index description.
        var indexDescriptionNode = indexesNode.nodes[indexNameNode];
        if (indexDescriptionNode == null) {
          collector.addError(SourceSpanException(
            'The index is missing a description.',
            indexNameNode.span,
          ));
          continue;
        }
        if (indexDescriptionNode is! YamlMap) {
          collector.addError(SourceSpanException(
            'The index description mus be of type Map.',
            indexDescriptionNode.span,
          ));
          continue;
        }

        // Validate index fields.
        var fieldsNode = indexDescriptionNode.nodes['fields'];
        if (fieldsNode == null) {
          collector.addError(SourceSpanException(
            'The "fields" property must be defined for an index.',
            indexDescriptionNode.span,
          ));
          continue;
        }
        var fieldsStr = fieldsNode.value;
        if (fieldsStr is! String) {
          collector.addError(SourceSpanException(
            'The "fields" property must be of type String.',
            fieldsNode.span,
          ));
          continue;
        }

        var fieldNames =
            fieldsStr.split(',').map((String str) => str.trim()).toList();
        if (fieldNames.isEmpty) {
          collector.addError(SourceSpanException(
            'The "fields" property must be defined.',
            fieldsNode.span,
          ));
          continue;
        }
        for (var fieldName in fieldNames) {
          if (!validDatabaseFieldNames.contains(fieldName)) {
            collector.addError(SourceSpanException(
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
            collector.addError(SourceSpanException(
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
          var uniqueVal = uniqueNode.value;
          if (uniqueVal is! bool) {
            collector.addError(SourceSpanException(
              'The "unique" property must be of type bool.',
              uniqueNode.span,
            ));
            continue;
          }
          unique = uniqueVal;
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
      viewName: viewName,
      fileName: outFileName,
      fields: fields,
      indexes: indexes,
      subDir: subDirectory,
      documentation: classDocumentation,
    );
  }

  ProtocolFileDefinition? _analyzeEnumFile(
      YamlMap documentContents, YamlDocumentationExtractor docsExtractor) {
    if (!_containsOnlyValidKeys(
      documentContents,
      {'enum', 'values'},
    )) {
      return null;
    }

    // Validate class name exists and is correct.
    var classNameNode = documentContents.nodes['enum'];
    if (classNameNode == null) {
      collector.addError(SourceSpanException(
        'No "enum" property is defined.',
        documentContents.span,
      ));
      return null;
    }
    var enumDocumentation = docsExtractor
        .getDocumentation(documentContents.key('enum')!.span.start);

    var className = classNameNode.value;
    if (className is! String) {
      collector.addError(SourceSpanException(
        'The "enum" property must be a String.',
        classNameNode.span,
      ));
      return null;
    }

    if (!StringValidators.isValidClassName(className)) {
      collector.addError(SourceSpanException(
        'The "enum" property must be a valid class name (e.g. CamelCaseString).',
        classNameNode.span,
      ));
      return null;
    }

    // Validate enum values.
    var valuesNode = documentContents.nodes['values'];
    if (valuesNode == null) {
      collector.addError(SourceSpanException(
        'An enum must have a "values" property.',
        documentContents.span,
      ));
      return null;
    }

    if (valuesNode is! YamlList) {
      collector.addError(SourceSpanException(
        'The "values" property must be a List.',
        valuesNode.span,
      ));
      return null;
    }
    var values = <EnumValueDefinition>[];
    for (var valueNode in valuesNode.nodes) {
      if (valueNode is! YamlScalar) {
        collector.addError(SourceSpanException(
          'The list value must be of type String.',
          valueNode.span,
        ));
        return null;
      }

      var value = valueNode.value;
      if (value is! String) {
        collector.addError(SourceSpanException(
          'The list value must be of type String.',
          valueNode.span,
        ));
        return null;
      }

      if (!StringValidators.isValidFieldName(value)) {
        collector.addError(SourceSpanException(
          'Enum values must be lowerCamelCase.',
          valueNode.span,
        ));
        return null;
      }
      var start = valueNode.span.start;
      // 2 is the length of '- ' in '- enumValue'
      var valueDocumentation = docsExtractor.getDocumentation(SourceLocation(
          start.offset - 2,
          column: start.column - 2,
          line: start.line,
          sourceUrl: start.sourceUrl));

      values.add(EnumValueDefinition(value, valueDocumentation));
    }

    return EnumDefinition(
      fileName: outFileName,
      className: className,
      values: values,
      documentation: enumDocumentation,
    );
  }

  bool _containsOnlyValidKeys(YamlMap documentMap, Set<String> validKeys) {
    for (var keyNode in documentMap.nodes.keys) {
      if (keyNode is! YamlScalar) {
        collector.addError(SourceSpanException(
          'Key must be of type String.',
          keyNode.span,
        ));
        return false;
      }
      var key = keyNode.value;
      if (key is! String) {
        collector.addError(SourceSpanException(
          'Key must be of type String.',
          keyNode.span,
        ));
        return false;
      }
      if (!validKeys.contains(key)) {
        collector.addError(SourceSpanException(
          'This key is not recognized. Valid keys are $validKeys',
          keyNode.span,
        ));
        return false;
      }
    }

    return true;
  }
}
