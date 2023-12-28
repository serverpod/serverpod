import 'package:serverpod_cli/analyzer.dart';
import 'package:serverpod_cli/src/analyzer/code_analysis_collector.dart';
import 'package:serverpod_cli/src/analyzer/models/checker/analyze_checker.dart';
import 'package:serverpod_cli/src/analyzer/models/definitions.dart';
import 'package:serverpod_cli/src/util/string_validators.dart';
import 'package:source_span/source_span.dart';
import 'package:yaml/yaml.dart';

import 'package:serverpod_cli/src/analyzer/models/converter/converter.dart';

import 'model_relations.dart';

const _globallyRestrictedKeywords = [
  'toJson',
  'fromJson',
  'toString',
  'hashCode',
  'runtimeType',
  'noSuchMethod',
  'abstract',
  'else',
  'import',
  'super',
  'as',
  'enum',
  'in',
  'switch',
  'assert',
  'export',
  'interface',
  'sync',
  'async',
  'extend',
  'is',
  'this',
  'await',
  'extension',
  'library',
  'throw',
  'break',
  'external',
  'mixin',
  'true',
  'case',
  'factory',
  'new',
  'try',
  'class',
  'final',
  'catch',
  'false',
  'null',
  'typedef',
  'on',
  'var',
  'const',
  'finally',
  'operator',
  'void',
  'continue',
  'for',
  'part',
  'while',
  'covariant',
  'function',
  'rethrow',
  'with',
  'default',
  'get',
  'return',
  'yield',
  'deferred',
  'hide',
  'set',
  'do',
  'if',
  'show',
  'dynamic',
  'implements',
  'static'
];

const _databaseModelReservedFieldNames = [
  'count',
  'insert',
  'update',
  'deleteRow',
  'delete',
  'findById',
  'findSingleRow',
  'find',
  'setColumn',
  'allToJson',
  'toJsonForDatabase',
  'tableName',
  'include',
  'db',
  'table',
];

class Restrictions {
  String documentType;
  YamlMap documentContents;
  SerializableModelDefinition? documentDefinition;
  ModelRelations? modelRelations;

  Restrictions({
    required this.documentType,
    required this.documentContents,
    this.documentDefinition,
    this.modelRelations,
  });

  List<SourceSpanSeverityException> validateClassName(
    String parentNodeName,
    dynamic className,
    SourceSpan? span,
  ) {
    if (className is! String) {
      return [
        SourceSpanSeverityException(
          'The "$documentType" type must be a String.',
          span,
        )
      ];
    }

    if (!StringValidators.isValidClassName(className)) {
      return [
        SourceSpanSeverityException(
          'The "$documentType" type must be a valid class name (e.g. PascalCaseString).',
          span,
        )
      ];
    }

    var reservedClassNames = const {'List', 'Map', 'String', 'DateTime'};
    if (reservedClassNames.contains(className)) {
      return [
        SourceSpanSeverityException(
          'The class name "$className" is reserved and cannot be used.',
          span,
        )
      ];
    }

    var classesByName = modelRelations?.classNames[className]?.where(
        (model) => model.moduleAlias == documentDefinition?.moduleAlias);

    if (classesByName != null && classesByName.length > 1) {
      return [
        SourceSpanSeverityException(
          'The $documentType name "$className" is already used by another model class.',
          span,
        )
      ];
    }

    return [];
  }

  List<SourceSpanSeverityException> validateTableName(
    String parentNodeName,
    dynamic tableName,
    SourceSpan? span,
  ) {
    if (tableName is! String) {
      return [
        SourceSpanSeverityException(
            'The "table" property must be a snake_case_string.', span)
      ];
    }

    if (!StringValidators.isValidTableName(tableName)) {
      return [
        SourceSpanSeverityException(
          'The "table" property must be a snake_case_string.',
          span,
        )
      ];
    }

    var relationships = modelRelations;
    if (relationships == null) return [];

    if (!relationships.isTableNameUnique(documentDefinition, tableName)) {
      var otherClass = relationships.findByTableName(
        tableName,
        ignore: documentDefinition,
      );

      return [
        SourceSpanSeverityException(
          'The table name "$tableName" is already in use by the class "${otherClass?.className}".',
          span,
        )
      ];
    }

    return [];
  }

  List<SourceSpanSeverityException> validateParentKey(
    String parentNodeName,
    String _,
    SourceSpan? span,
  ) {
    var errors = <SourceSpanSeverityException>[];
    var definition = documentDefinition;

    if (definition is! ClassDefinition) return errors;

    var field = definition.findField(parentNodeName);
    if (field == null) return errors;

    if (!field.type.isIdType) {
      errors.add(SourceSpanSeverityException(
        'The "parent" property should be omitted on model relations.',
        span,
      ));
    }

    return errors;
  }

  List<SourceSpanSeverityException> validateDatabaseActionKey(
    String parentNodeName,
    String key,
    SourceSpan? span,
  ) {
    var definition = documentDefinition;
    if (definition is! ClassDefinition) return [];

    var field = definition.findField(parentNodeName);

    if (field?.relation?.isForeignKeyOrigin == false) {
      return [
        SourceSpanSeverityException(
          'The "$key" property can only be set on the side holding the foreign key.',
          span,
        )
      ];
    }

    return [];
  }

  List<SourceSpanSeverityException> validateOptionalKey(
    String parentNodeName,
    String _,
    SourceSpan? span,
  ) {
    var errors = <SourceSpanSeverityException>[];
    var definition = documentDefinition;

    if (definition is! ClassDefinition) return errors;

    var field = definition.findField(parentNodeName);
    if (field == null) return errors;

    if (field.type.isIdType) {
      errors.add(SourceSpanSeverityException(
        'The "optional" property should be omitted on id fields.',
        span,
      ));
    }

    return errors;
  }

  List<SourceSpanSeverityException> validateTableIndexName(
    String parentNodeName,
    String indexName,
    SourceSpan? span,
  ) {
    if (!StringValidators.isValidTableIndexName(indexName)) {
      return [
        SourceSpanSeverityException(
          'Invalid format for index "$indexName", must follow the format lower_snake_case.',
          span,
        )
      ];
    }
    var relationships = modelRelations;
    if (relationships == null) return [];
    if (!relationships.isIndexNameUnique(documentDefinition, indexName)) {
      var collision = relationships.findByIndexName(
        indexName,
        ignore: documentDefinition,
      );

      return [
        SourceSpanSeverityException(
          'The index name "$indexName" is already used by the model class "${collision?.className}".',
          span,
        )
      ];
    }

    return [];
  }

  List<SourceSpanSeverityException> validateFieldName(
    String parentNodeName,
    String fieldName,
    SourceSpan? span,
  ) {
    if (StringValidators.isInvalidFieldValueInfoSeverity(fieldName)) {
      return [
        SourceSpanSeverityException(
          'Field names should be valid Dart variable names (e.g. camelCaseString).',
          span,
          severity: SourceSpanSeverity.info,
        )
      ];
    }

    if (!StringValidators.isValidFieldName(fieldName)) {
      return [
        SourceSpanSeverityException(
          'Field names must be valid Dart variable names (e.g. camelCaseString).',
          span,
        )
      ];
    }

    var def = documentDefinition;
    if (def is ClassDefinition && def.tableName != null && fieldName == 'id') {
      return [
        SourceSpanSeverityException(
          'The field name "id" is not allowed when a table is defined (the "id" field will be auto generated).',
          span,
        )
      ];
    }

    if (def is ClassDefinition &&
        def.tableName != null &&
        _databaseModelReservedFieldNames.contains(fieldName)) {
      return [
        SourceSpanSeverityException(
          'The field name "$fieldName" is reserved and cannot be used.',
          span,
        )
      ];
    }

    if (_globallyRestrictedKeywords.contains(fieldName)) {
      return [
        SourceSpanSeverityException(
          'The field name "$fieldName" is reserved and cannot be used.',
          span,
        )
      ];
    }

    return [];
  }

  List<SourceSpanSeverityException> validateRelationFieldKey(
    String parentNodeName,
    String _,
    SourceSpan? span,
  ) {
    var classDefinition = documentDefinition;

    if (classDefinition is! ClassDefinition) return [];

    var field = classDefinition.findField(parentNodeName);
    if (field == null) return [];

    if (field.type.isListType) {
      return [
        SourceSpanSeverityException(
          'The "field" property can only be used on an object relation.',
          span,
        )
      ];
    }

    if (field.type.isIdType) {
      return [
        SourceSpanSeverityException(
          'The "field" property can only be used on an object relation.',
          span,
        )
      ];
    }

    var foreignFields = modelRelations?.findNamedForeignRelationFields(
      classDefinition,
      field,
    );
    if (foreignFields == null) return [];

    if (_isForeignKeyDefinedOnBothSides(field, foreignFields)) {
      return [
        SourceSpanSeverityException(
          'Only one side of the relation is allowed to store the foreign key, remove the specified "field" reference from one side.',
          span,
        )
      ];
    }

    return [];
  }

  bool _isForeignKeyDefinedOnAnySide(
    SerializableModelFieldDefinition field,
    List<SerializableModelFieldDefinition> foreignFields,
  ) {
    bool isForeignFieldForeignKeyOrigin = _isForeignFieldForeignKeyOrigin(
      foreignFields,
    );

    var isLocalFieldForeignKeyOrigin =
        field.relation?.isForeignKeyOrigin == true;

    return isLocalFieldForeignKeyOrigin || isForeignFieldForeignKeyOrigin;
  }

  bool _isImplicitManyToManyRelation(
    SerializableModelFieldDefinition field,
    SerializableModelFieldDefinition foreignField,
  ) {
    if (!field.type.isListType) return false;
    if (!foreignField.type.isListType) return false;

    return true;
  }

  bool _isForeignKeyDefinedOnBothSides(
    SerializableModelFieldDefinition field,
    List<SerializableModelFieldDefinition> foreignFields,
  ) {
    bool isForeignFieldForeignKeyOrigin = _isForeignFieldForeignKeyOrigin(
      foreignFields,
    );

    var isLocalFieldForeignKeyOrigin =
        field.relation?.isForeignKeyOrigin == true;

    return isLocalFieldForeignKeyOrigin && isForeignFieldForeignKeyOrigin;
  }

  bool _isForeignFieldForeignKeyOrigin(
    List<SerializableModelFieldDefinition> foreignFields,
  ) {
    var isForeignFieldForeignKeyOrigin = foreignFields.any(
      (element) => element.relation?.isForeignKeyOrigin == true,
    );
    return isForeignFieldForeignKeyOrigin;
  }

  List<SourceSpanSeverityException> validateRelationFieldName(
    String parentNodeName,
    dynamic fieldName,
    SourceSpan? span,
  ) {
    if (fieldName is! String) return [];

    var classDefinition = documentDefinition;
    if (classDefinition is! ClassDefinition) return [];

    var foreignKeyField = classDefinition.findField(fieldName);
    if (foreignKeyField == null) {
      return [
        SourceSpanSeverityException(
          'The field "$fieldName" was not found in the class.',
          span,
        )
      ];
    }

    if (!foreignKeyField.shouldPersist) {
      return [
        SourceSpanSeverityException(
          'The field "$fieldName" is not persisted and cannot be used in a relation.',
          span,
        )
      ];
    }

    var foreignKeyRelation = foreignKeyField.relation;
    if (foreignKeyRelation is! ForeignRelationDefinition) return [];

    var field = classDefinition.findField(parentNodeName);
    var relation = field?.relation;
    if (relation is UnresolvableObjectRelationDefinition &&
        relation.reason == UnresolvableReason.relationAlreadyDefinedForField) {
      return [
        SourceSpanSeverityException(
          'The field "${foreignKeyField.name}" already has a relation and cannot be used as relation field.',
          span,
        )
      ];
    }

    var parentClasses =
        modelRelations?.tableNames[foreignKeyRelation.parentTable];

    if (parentClasses == null || parentClasses.isEmpty) return [];

    var parentClass = parentClasses.first;
    if (parentClass is! ClassDefinition) return [];

    var referenceField =
        parentClass.findField(foreignKeyRelation.foreignFieldName);

    if (foreignKeyField.type.className != referenceField?.type.className) {
      return [
        SourceSpanSeverityException(
          'The field "$fieldName" is of type "${foreignKeyField.type.className}" but reference field "${foreignKeyRelation.foreignFieldName}" is of type "${referenceField?.type.className}".',
          span,
        )
      ];
    }

    var isLocalFieldForeignKeyOrigin =
        field?.relation?.isForeignKeyOrigin == true;

    if (isLocalFieldForeignKeyOrigin &&
        _isOneToOneObjectRelation(field, classDefinition) &&
        !_hasUniqueFieldIndex(foreignKeyField)) {
      return [
        SourceSpanSeverityException(
          'The field "${foreignKeyField.name}" does not have a unique index which is required to be used in a one-to-one relation.',
          span,
        )
      ];
    }

    return [];
  }

  bool _isOneToOneObjectRelation(
    SerializableModelFieldDefinition? field,
    ClassDefinition classDefinition,
  ) {
    if (field == null) return false;

    if (field.type.isListType) return false;

    var foreignFields = modelRelations?.findNamedForeignRelationFields(
      classDefinition,
      field,
    );

    if (foreignFields == null || foreignFields.isEmpty) return false;
    if (foreignFields.any((element) => element.type.isListType)) return false;

    return true;
  }

  bool _hasUniqueFieldIndex(
    SerializableModelFieldDefinition? field,
  ) {
    if (field == null) return false;

    var fieldIndexesWithUnique = field.indexes.where((index) => index.unique);

    return fieldIndexesWithUnique.any((index) => index.fields.length == 1);
  }

  List<SourceSpanSeverityException> validateRelationInterdependencies(
    String parentNodeName,
    dynamic content,
    SourceSpan? span,
  ) {
    var errors = <SourceSpanSeverityException>[];
    var definition = documentDefinition;

    if (definition is! ClassDefinition) return errors;

    var field = definition.findField(parentNodeName);
    if (field == null) return errors;
    var type = field.type.className;

    if (AnalyzeChecker.isIdType(type) &&
        !AnalyzeChecker.isParentDefined(content)) {
      errors.add(SourceSpanSeverityException(
        'The "parent" property must be defined on id fields.',
        span,
      ));
    }

    return errors;
  }

  List<SourceSpanSeverityException> validateParentName(
    String parentNodeName,
    dynamic content,
    SourceSpan? span,
  ) {
    if (content == null) return [];

    var definition = documentDefinition;
    if (definition is ClassDefinition && definition.tableName == null) {
      return [
        SourceSpanSeverityException(
          'The "table" property must be defined in the class to set a parent on a field.',
          span,
        )
      ];
    }

    if (!StringValidators.isValidTableIndexName(content)) {
      return [
        SourceSpanSeverityException(
          'The parent must reference a valid table name (e.g. parent=table_name). "$content" is not a valid parent name.',
          span,
        )
      ];
    }

    var relations = modelRelations;
    if (relations != null && !relations.tableNames.containsKey(content)) {
      return [
        SourceSpanSeverityException(
          'The parent table "$content" was not found in any model.',
          span,
        )
      ];
    }

    return [];
  }

  List<SourceSpanSeverityException> validateFieldDataType(
    String parentNodeName,
    dynamic type,
    SourceSpan? span,
  ) {
    if (type is! String) {
      return [
        SourceSpanSeverityException(
          'The field must have a datatype defined (e.g. field: String).',
          span,
        )
      ];
    }

    var errors = <SourceSpanSeverityException>[];

    var classDefinition = documentDefinition;
    if (classDefinition is! ClassDefinition) return errors;

    var fieldType = classDefinition.findField(parentNodeName)?.type;

    if (fieldType == null) return errors;

    errors.addAll(validateFieldType(fieldType, span));

    var field = classDefinition.findField(parentNodeName);
    if (field == null || !field.isSymbolicRelation) return errors;

    if (!type.endsWith('?')) {
      errors.add(SourceSpanSeverityException(
        'Fields with a model relations must be nullable (e.g. $parentNodeName: $type?).',
        span,
      ));
    }

    var localModelRelations = modelRelations;
    if (localModelRelations == null) return errors;

    String? parsedType = localModelRelations.extractReferenceClassName(field);

    var referenceClassExists = localModelRelations.classNameExists(parsedType);
    if (!referenceClassExists) {
      errors.add(SourceSpanSeverityException(
        'The class "$parsedType" was not found in any model.',
        span,
      ));
      return errors;
    }

    var referenceClass = localModelRelations.findByClassName(parsedType);

    if (referenceClass is! ClassDefinition) {
      errors.add(SourceSpanSeverityException(
        'Only classes can be used in relations, "$parsedType" is not a class.',
        span,
      ));
      return errors;
    }

    if (!_hasTableDefined(referenceClass)) {
      errors.add(SourceSpanSeverityException(
        'The class "$parsedType" must have a "table" property defined to be used in a relation.',
        span,
      ));
    }

    return errors;
  }

  List<SourceSpanSeverityException> validateFieldType(
    TypeDefinition fieldType,
    SourceSpan? span,
  ) {
    var typeText = span?.text;
    if (typeText != null && _isNoValidationType(typeText)) return [];

    var errors = <SourceSpanSeverityException>[];

    if (_isUnsupportedType(fieldType)) {
      errors.add(SourceSpanSeverityException(
        'The datatype "${fieldType.className}" is not supported in models.',
        span,
      ));
      return errors;
    }

    var moduleAlias = fieldType.moduleAlias;
    if (_isUnresolvedModuleType(fieldType) && moduleAlias != null) {
      errors.add(SourceSpanSeverityException(
        'The referenced module "$moduleAlias" is not found.',
        span?.subspan(
          span.text.indexOf(moduleAlias),
          span.text.indexOf(moduleAlias) + moduleAlias.length,
        ),
      ));
      return errors;
    }

    if (!_isValidType(fieldType)) {
      var typeName = fieldType.className;
      errors.add(SourceSpanSeverityException(
        'The field has an invalid datatype "$typeName".',
        span?.subspan(
          span.text.indexOf(typeName),
          span.text.indexOf(typeName) + typeName.length,
        ),
      ));
    }

    if (fieldType.isMapType) {
      if (fieldType.generics.length == 2) {
        errors.addAll(validateFieldType(fieldType.generics.first, span));
        errors.addAll(validateFieldType(fieldType.generics.last, span));
      } else {
        errors.add(
          SourceSpanSeverityException(
            'The Map type must have two generic types defined (e.g. Map<String, String>).',
            span,
          ),
        );
      }
    } else if (fieldType.isListType) {
      if (fieldType.generics.length == 1) {
        errors.addAll(validateFieldType(fieldType.generics.first, span));
      } else {
        errors.add(
          SourceSpanSeverityException(
            'The List type must have one generic type defined (e.g. List<String>).',
            span,
          ),
        );
      }
    } else if (fieldType.generics.isNotEmpty) {
      errors.add(
        SourceSpanSeverityException(
          'The type "${fieldType.className}" cannot have generic types defined.',
          span,
        ),
      );
    }

    return errors;
  }

  List<SourceSpanSeverityException> validateIndexFieldsValue(
    String parentNodeName,
    dynamic content,
    SourceSpan? span,
  ) {
    if (content is! String) {
      return [
        SourceSpanSeverityException(
          'The "fields" property must have at least one field, (e.g. fields: fieldName).',
          span,
        )
      ];
    }

    if (documentDefinition is! ClassDefinition) return [];
    var definition = documentDefinition as ClassDefinition;

    var fields = definition.fields;
    var indexFields = convertIndexList(content);

    var validDatabaseFieldNames = fields
        .where((field) => field.shouldPersist)
        .fold(<String>{}, (output, field) => output..add(field.name));

    var missingFieldErrors = indexFields
        .where((field) => !validDatabaseFieldNames.contains(field))
        .map((field) => SourceSpanSeverityException(
              'The field name "$field" is not added to the class or has an api scope.',
              span,
            ));

    var duplicatesCount = _duplicatesCount(indexFields);

    var duplicateFieldErrors = duplicatesCount.entries
        .where((entry) => entry.value > 1)
        .map((entry) => SourceSpanSeverityException(
              'Duplicated field name "name", can only reference a field once per index.',
              span,
            ));

    return [...missingFieldErrors, ...duplicateFieldErrors];
  }

  List<SourceSpanSeverityException> validateIndexType(
    String parentNodeName,
    dynamic content,
    SourceSpan? span,
  ) {
    var validIndexTypes = {'btree', 'hash', 'gin', 'gist', 'spgist', 'brin'};

    if (content is! String || !validIndexTypes.contains(content)) {
      return [
        SourceSpanSeverityException(
          'The "type" property must be one of: ${validIndexTypes.join(', ')}.',
          span,
        )
      ];
    }

    return [];
  }

  List<SourceSpanSeverityException> validateRelationKey(
    String parentNodeName,
    String relation,
    SourceSpan? span,
  ) {
    var definition = documentDefinition;

    if (definition is! ClassDefinition) return [];

    if (definition.tableName == null) {
      return [
        SourceSpanSeverityException(
          'The "table" property must be defined in the class to set a relation on a field.',
          span,
        )
      ];
    }

    var field = definition.findField(parentNodeName);

    if (field == null) return [];

    if (field.type.isListType) {
      var referenceClass = modelRelations
          ?.findAllByClassName(field.type.generics.first.className)
          .firstOrNull;

      if (referenceClass?.moduleAlias != definition.moduleAlias) {
        return [
          SourceSpanSeverityException(
            'A List relation is not allowed on module tables.',
            span,
          )
        ];
      }
    }

    return [];
  }

  List<SourceSpanSeverityException> validatePersistKey(
    String parentNodeName,
    String relation,
    SourceSpan? span,
  ) {
    var definition = documentDefinition;
    if (definition is! ClassDefinition) return [];

    var errors = <SourceSpanSeverityException>[];

    if (definition.tableName == null) {
      errors.add(SourceSpanSeverityException(
        'The "persist" property requires a table to be set on the class.',
        span,
      ));
    }

    var field = definition.findField(parentNodeName);
    if (definition.tableName != null && field?.shouldPersist != false) {
      errors.add(SourceSpanSeverityException(
        'Fields are persisted by default, the property can be removed.',
        span,
        severity: SourceSpanSeverity.hint,
        tags: [SourceSpanTag.unnecessary],
      ));
    }

    return errors;
  }

  List<SourceSpanSeverityException> validateRelationName(
    String parentNodeName,
    dynamic name,
    SourceSpan? span,
  ) {
    var classDefinition = documentDefinition;
    if (classDefinition is! ClassDefinition) return [];

    if (name is! String) {
      return [
        SourceSpanSeverityException(
          'The property must be a String.',
          span,
        )
      ];
    }

    var localModelRelations = modelRelations;
    if (localModelRelations == null) return [];

    var field = classDefinition.findField(parentNodeName);
    if (field == null) return [];

    var foreignFields = localModelRelations.findNamedForeignRelationFields(
      classDefinition,
      field,
    );

    var foreignClassName = localModelRelations.extractReferenceClassName(
      field,
    );
    if (foreignFields.isEmpty) {
      return [
        SourceSpanSeverityException(
          'There is no named relation with name "$name" on the class "$foreignClassName".',
          span,
        )
      ];
    }

    if (foreignFields.length > 1) {
      return [
        SourceSpanSeverityException(
          'Unable to resolve ambiguous relation, there are several named relations with name "$name" on the class "$foreignClassName".',
          span,
        )
      ];
    }

    if (_isImplicitManyToManyRelation(field, foreignFields.first)) {
      return [
        SourceSpanSeverityException(
          'A named relation to another list field is not supported.',
          span,
        )
      ];
    }

    if (!_isForeignKeyDefinedOnAnySide(field, foreignFields)) {
      return [
        SourceSpanSeverityException(
          'The relation is ambiguous, unable to resolve which side should hold the relation. Use the field reference syntax to resolve the ambiguity. E.g. relation(name=$name, field=${parentNodeName}Id)',
          span,
        )
      ];
    }

    var isLocalFieldForeignKeyOrigin =
        field.relation?.isForeignKeyOrigin == true;
    if (!isLocalFieldForeignKeyOrigin &&
        _isOneToOneObjectRelation(field, classDefinition) &&
        !_hasUniqueFieldIndex(foreignFields.first)) {
      return [
        SourceSpanSeverityException(
          'The referenced field "${foreignFields.first.name}" does not have a unique index which is required to be used in a one-to-one relation.',
          span,
        )
      ];
    }

    return [];
  }

  List<SourceSpanSeverityException> validateEnumValues(
    String parentNodeName,
    dynamic content,
    SourceSpan? span,
  ) {
    if (content is! YamlList) {
      return [
        SourceSpanSeverityException(
          'The "values" property must be a list of strings.',
          span,
        )
      ];
    }

    var enumCount = _duplicatesCount(content);

    var nodeExceptions = content.nodes.map((node) {
      var enumValue = node.value;
      if (node is! YamlScalar || enumValue is! String) {
        return SourceSpanSeverityException(
          'The "values" property must be a list of strings.',
          node.span,
        );
      }

      if (StringValidators.isInvalidFieldValueInfoSeverity(node.value)) {
        return SourceSpanSeverityException(
          'Enum values should be lowerCamelCase.',
          node.span,
          severity: SourceSpanSeverity.info,
        );
      }

      if (!StringValidators.isValidFieldName(node.value)) {
        return SourceSpanSeverityException(
          'Enum values must be lowerCamelCase.',
          node.span,
        );
      }

      if (enumCount[enumValue] != 1) {
        return SourceSpanSeverityException(
          'Enum values must be unique.',
          node.span,
        );
      }

      if (_globallyRestrictedKeywords.contains(enumValue)) {
        return SourceSpanSeverityException(
          'The enum value "$enumValue" is reserved and cannot be used.',
          node.span,
        );
      }

      return null;
    });

    return nodeExceptions.whereType<SourceSpanSeverityException>().toList();
  }

  Map<dynamic, int> _duplicatesCount(List<dynamic> list) {
    Map<dynamic, int> valueCount = {};
    for (var listValue in list) {
      valueCount.update(listValue, (value) => value + 1, ifAbsent: () => 1);
    }

    return valueCount;
  }

  var whiteListedTypes = [
    'String',
    'bool',
    'int',
    'double',
    'DateTime',
    'Duration',
    'UuidValue',
    'ByteData',
    'List',
    'Map',
  ];

  var blackListedTypes = [
    'dynamic',
  ];

  bool _isNoValidationType(String type) {
    return type.startsWith('package:') || type.startsWith('project:');
  }

  bool _isValidType(TypeDefinition type) {
    return whiteListedTypes.contains(type.className) || _isModelType(type);
  }

  bool _isUnsupportedType(TypeDefinition type) {
    return blackListedTypes.contains(type.className);
  }

  bool _isUnresolvedModuleType(TypeDefinition type) {
    if (!type.isModuleType) return false;

    var moduleAlias = type.moduleAlias;
    if (moduleAlias == null) return false;

    var relationalData = modelRelations;
    if (relationalData == null) return true;

    return !relationalData.moduleNames.contains(moduleAlias);
  }

  bool _isModelType(TypeDefinition type) {
    var className = type.className;

    var definitions = modelRelations?.classNames[className];

    if (definitions == null) return false;
    if (definitions.isEmpty) return false;

    var referenceClasses = definitions.whereType<ClassDefinition>();

    if (referenceClasses.isNotEmpty) {
      var moduleAlias = type.moduleAlias;
      return referenceClasses.any((e) => e.moduleAlias == moduleAlias);
    }

    return true;
  }

  bool _hasTableDefined(SerializableModelDefinition classDefinition) {
    if (classDefinition is! ClassDefinition) return false;

    return classDefinition.tableName != null;
  }
}

class StringValueRestriction {
  List<SourceSpanSeverityException> validate(
    String parentNodeName,
    dynamic value,
    SourceSpan? span,
  ) {
    if (value is! String) {
      return [
        SourceSpanSeverityException(
          'The property must be a String.',
          span,
        )
      ];
    }

    return [];
  }
}

class EnumValueRestriction<T extends Enum> {
  List<T> enums;

  EnumValueRestriction({
    required this.enums,
  });

  List<SourceSpanSeverityException> validate(
    String parentNodeName,
    dynamic enumValue,
    SourceSpan? span,
  ) {
    var options = enums.map((v) => v.name);

    var errors = <SourceSpanSeverityException>[
      SourceSpanSeverityException(
        '"$enumValue" is not a valid property. Valid properties are $options.',
        span,
      )
    ];

    if (enumValue is! String) return errors;

    var isEnumValue = enums.any(
      (e) => e.name.toLowerCase() == enumValue.toLowerCase(),
    );

    if (!isEnumValue) return errors;

    return [];
  }
}

class BooleanValueRestriction {
  List<SourceSpanSeverityException> validate(
    String parentNodeName,
    dynamic value,
    SourceSpan? span,
  ) {
    if (value is bool) return [];

    var errors = [
      SourceSpanSeverityException(
        'The value must be a boolean.',
        span,
      )
    ];

    if (value is! String) return errors;

    var boolValue = value.toLowerCase();
    if (!(boolValue == 'true' || boolValue == 'false')) {
      return errors;
    }

    return [];
  }
}
