import 'package:serverpod_cli/src/util/model_helper.dart';
import 'package:source_span/source_span.dart';
import 'package:yaml/yaml.dart';

import 'package:serverpod_cli/analyzer.dart';
import 'package:serverpod_cli/src/analyzer/code_analysis_collector.dart';
import 'package:serverpod_cli/src/analyzer/models/checker/analyze_checker.dart';
import 'package:serverpod_cli/src/analyzer/models/converter/converter.dart';
import 'package:serverpod_cli/src/analyzer/models/definitions.dart';
import 'package:serverpod_cli/src/analyzer/models/validation/keywords.dart';
import 'package:serverpod_cli/src/analyzer/models/validation/restrictions/scope.dart';
import 'package:serverpod_cli/src/config/serverpod_feature.dart';
import 'package:serverpod_cli/src/util/string_validators.dart';
import 'package:serverpod_shared/serverpod_shared.dart';

import 'model_relations.dart';

const _globallyRestrictedKeywords = [
  'toJson',
  'toJsonForProtocol',
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
  'toJsonForDatabase',
  'tableName',
  'include',
  'db',
  'table',
];

/// We reserve 7 characters to enable deterministic generation of the following
/// suffixes:
/// - "_id_seq" suffix for the default value for serial fields stored in the
/// server generated table definition.
/// - "_fk_{index}" suffix for foreign key constraints.
const _reservedTableSuffixChars = 7;

/// We reserve 2 characters to enable implicit foreign key field generation
/// without truncation since we append "id" as a suffix of on the field name.
const _reservedColumnSuffixChars = 2;

const _maxTableNameLength =
    DatabaseConstants.pgsqlMaxNameLimitation - _reservedTableSuffixChars;
const _maxColumnNameLength =
    DatabaseConstants.pgsqlMaxNameLimitation - _reservedColumnSuffixChars;

class Restrictions {
  final GeneratorConfig config;
  String documentType;
  YamlMap documentContents;
  SerializableModelDefinition? documentDefinition;
  ParsedModelsCollection parsedModels;

  Restrictions({
    required this.config,
    required this.documentType,
    required this.documentContents,
    this.documentDefinition,
    required this.parsedModels,
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

    var duplicateExtraClass =
        config.extraClasses.cast<TypeDefinition?>().firstWhere(
              (extraClass) => extraClass?.className == className,
              orElse: () => null,
            );

    if (duplicateExtraClass != null) {
      return [
        SourceSpanSeverityException(
          'The $documentType name "$className" is already used by a custom class (${duplicateExtraClass.url}).',
          span,
        )
      ];
    }

    var classesByName = parsedModels.classNames[className]?.where(
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

  List<SourceSpanSeverityException> validateTableNameKey(
    String parentNodeName,
    String _,
    SourceSpan? span,
  ) {
    if (!config.isFeatureEnabled(ServerpodFeature.database)) {
      return [
        SourceSpanSeverityException(
            'The "table" property cannot be used when the database feature is disabled.',
            span,
            severity: SourceSpanSeverity.warning)
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

    if (!parsedModels.isTableNameUnique(documentDefinition, tableName)) {
      var otherClass = parsedModels.findByTableName(
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

    if (tableName.length > _maxTableNameLength) {
      return [
        SourceSpanSeverityException(
          'The table name "$tableName" exceeds the $_maxTableNameLength character table name limitation.',
          span,
        )
      ];
    }

    var currentModel = parsedModels.findByTableName(tableName);

    if (currentModel is ClassDefinition) {
      var ancestorWithTable = _findTableClassInParentClasses(currentModel);

      if (ancestorWithTable != null) {
        return [
          SourceSpanSeverityException(
            'The "table" property is not allowed because another class, "${ancestorWithTable.className}", in the class hierarchy already has one defined. Only one table definition is allowed when using inheritance.',
            span,
          )
        ];
      }
    }
    return [];
  }

  List<SourceSpanSeverityException> validateExtendingClassName(
    String parentNodeName,
    dynamic parentClassName,
    SourceSpan? span,
  ) {
    if (parentClassName is! String) {
      return [
        SourceSpanSeverityException(
          'The "${Keyword.extendsClass} type must be a String.',
          span,
        )
      ];
    }

    var parentClass = parsedModels.findByClassName(parentClassName);

    if (parentClass == null) {
      return [
        SourceSpanSeverityException(
          'The class "$parentClassName" was not found in any model.',
          span,
        )
      ];
    }

    if (parentClass.moduleAlias != defaultModuleAlias) {
      return [
        SourceSpanSeverityException(
          'You can only extend classes from your own project.',
          span,
        )
      ];
    }

    var currentModel =
        parsedModels.findByClassName(documentDefinition!.className);

    if (currentModel is ClassDefinition) {
      var ancestorServerOnlyClass =
          _findServerOnlyClassInParentClasses(currentModel);

      if (!documentDefinition!.serverOnly && ancestorServerOnlyClass != null) {
        return [
          SourceSpanSeverityException(
            'Cannot extend a "serverOnly" class in the inheritance chain ("${ancestorServerOnlyClass.className}") unless class is marked as "serverOnly".',
            span,
          )
        ];
      }
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
    if (!parsedModels.isIndexNameUnique(documentDefinition, indexName)) {
      var collision = parsedModels.findByIndexName(
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

    if (indexName.length > DatabaseConstants.pgsqlMaxNameLimitation) {
      return [
        SourceSpanSeverityException(
          'The index name "$indexName" exceeds the ${DatabaseConstants.pgsqlMaxNameLimitation} character index name limitation.',
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

    if (fieldName.length > _maxColumnNameLength) {
      return [
        SourceSpanSeverityException(
          'The field name "$fieldName" exceeds the $_maxColumnNameLength character field name limitation.',
          span,
        )
      ];
    }

    if (def is ClassDefinition) {
      var currentModel = parsedModels.findByClassName(def.className);

      if (currentModel is ClassDefinition) {
        var fieldWithDuplicatedName =
            _findFieldWithDuplicatedName(currentModel, fieldName);
        var parentClassWithDuplicatedFieldName =
            _findAncestorWithDuplicatedFieldName(currentModel, fieldName);

        if (fieldWithDuplicatedName != null &&
            parentClassWithDuplicatedFieldName != null) {
          return [
            SourceSpanSeverityException(
              'The field name "$fieldName" is already defined in an inherited class ("${parentClassWithDuplicatedFieldName.className}").',
              span,
            )
          ];
        }
      }
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

    var foreignFields = parsedModels.findNamedForeignRelationFields(
      classDefinition,
      field,
    );

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

    var parentClasses = parsedModels.tableNames[foreignKeyRelation.parentTable];

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

    var foreignFields = parsedModels.findNamedForeignRelationFields(
      classDefinition,
      field,
    );

    if (foreignFields.isEmpty) return false;
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

    if (content is! String) {
      return [
        SourceSpanSeverityException(
          'The "parent" value must be a String.',
          span,
        )
      ];
    }

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

    if (!parsedModels.tableNames.containsKey(content)) {
      return [
        SourceSpanSeverityException(
          'The parent table "$content" was not found in any model.',
          span,
        )
      ];
    }

    return [];
  }

  List<SourceSpanSeverityException> validateFieldType(
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

    var field = classDefinition.findField(parentNodeName);
    if (field == null) return errors;

    errors.addAll(_validateFieldDataType(field.type, span));

    // Abort further validation if the field data type has errors.
    if (errors.isNotEmpty) return errors;

    var fieldClassDefinitions = _extractAllClassDefinitionsFromType(field.type);
    for (var classDefinition in fieldClassDefinitions) {
      if (classDefinition.serverOnly &&
          !ScopeValueRestriction.serverOnlyClassAllowedScopes
              .contains(field.scope)) {
        errors.add(
          SourceSpanSeverityException(
            'The type "${classDefinition.className}" is a server only class and can only be used fields with scope ${ScopeValueRestriction.serverOnlyClassAllowedScopes.map((e) => e.name)} (e.g $parentNodeName: ${classDefinition.className}, scope=${ScopeValueRestriction.serverOnlyClassAllowedScopes.first.name}).',
            span?.subspan(
              span.text.indexOf(classDefinition.className),
              span.text.indexOf(classDefinition.className) +
                  classDefinition.className.length,
            ),
          ),
        );
      }
    }

    if (field.isSymbolicRelation) {
      errors.addAll(_validateFieldRelationType(
        parentNodeName: parentNodeName,
        type: type,
        field: field,
        span: span,
      ));
    }

    return errors;
  }

  List<SourceSpanSeverityException> _validateFieldDataType(
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
    if (moduleAlias != null && _isUnresolvedModuleType(fieldType)) {
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
        errors.addAll(_validateFieldDataType(fieldType.generics.first, span));
        errors.addAll(_validateFieldDataType(fieldType.generics.last, span));
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
        errors.addAll(_validateFieldDataType(fieldType.generics.first, span));
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

  List<SourceSpanSeverityException> _validateFieldRelationType({
    required String parentNodeName,
    required String type,
    required SerializableModelFieldDefinition field,
    required SourceSpan? span,
  }) {
    String? parsedType = parsedModels.extractReferenceClassName(field);
    var referenceClass = parsedModels.findByClassName(parsedType);

    var errors = <SourceSpanSeverityException>[];
    if (!type.endsWith('?')) {
      errors.add(SourceSpanSeverityException(
        'Fields with a model relations must be nullable (e.g. $parentNodeName: $type?).',
        span,
      ));
    }

    if (referenceClass is! ClassDefinition) {
      errors.add(SourceSpanSeverityException(
        'Only classes can be used in relations, "$parsedType" is not a class.',
        span,
      ));
    }

    if (referenceClass is ClassDefinition &&
        !_hasTableDefined(referenceClass)) {
      errors.add(SourceSpanSeverityException(
        'The class "$parsedType" must have a "table" property defined to be used in a relation.',
        span,
      ));
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
              'The field name "$field" is not added to the class or has an !persist scope.',
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
      var referenceClass = parsedModels
          .findAllByClassName(field.type.generics.first.className)
          .firstOrNull;

      if (referenceClass != null &&
          referenceClass.moduleAlias != definition.moduleAlias) {
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

    var field = classDefinition.findField(parentNodeName);
    if (field == null) return [];

    var foreignFields = parsedModels.findNamedForeignRelationFields(
      classDefinition,
      field,
    );

    var foreignClassName = parsedModels.extractReferenceClassName(
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

      if (!StringValidators.isValidEnumName(node.value)) {
        return SourceSpanSeverityException(
          'Enum values must be valid dart enums.',
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

  List<SourceSpanSeverityException> validateDefaultKey(
    String parentNodeName,
    String relation,
    SourceSpan? span,
  ) {
    var definition = documentDefinition;
    if (definition is! ClassDefinition) return [];

    var field = definition.findField(parentNodeName);
    if (field == null) return [];

    var errors = <SourceSpanSeverityException>[];

    if (field.type.defaultValueType == null) {
      errors.add(
        SourceSpanSeverityException(
          'The "default" key is not supported for "${field.type.className}" types',
          span,
        ),
      );
    }

    return errors;
  }

  List<SourceSpanSeverityException> validateDefaultModelKey(
    String parentNodeName,
    String relation,
    SourceSpan? span,
  ) {
    var definition = documentDefinition;
    if (definition is! ClassDefinition) return [];

    var field = definition.findField(parentNodeName);
    if (field == null) return [];

    var errors = <SourceSpanSeverityException>[];

    if (field.type.defaultValueType == null) {
      errors.add(
        SourceSpanSeverityException(
          'The "defaultModel" key is not supported for "${field.type.className}" types',
          span,
        ),
      );
    }

    return errors;
  }

  List<SourceSpanSeverityException> validateDefaultPersistKey(
    String parentNodeName,
    String relation,
    SourceSpan? span,
  ) {
    var definition = documentDefinition;
    if (definition is! ClassDefinition) return [];

    var field = definition.findField(parentNodeName);
    if (field == null) return [];

    var errors = <SourceSpanSeverityException>[];

    if (field.type.defaultValueType == null) {
      errors.add(
        SourceSpanSeverityException(
          'The "defaultPersist" key is not supported for "${field.type.className}" types',
          span,
        ),
      );
    }

    if (field.hasOnlyDatabaseDefaults && !field.type.nullable) {
      errors.add(
        SourceSpanSeverityException(
          'When setting only the "defaultPersist" key, its type should be nullable',
          span,
        ),
      );
    }

    /// We perform this check here instead of using [mutuallyExclusiveKeys] because our
    /// concern is specifically whether the field should be persisted in the database.
    /// Using "persist" is allowed, while using "!persist" is not allowed.
    if (!field.shouldPersist) {
      errors.add(
        SourceSpanSeverityException(
          'The "defaultPersist" property is mutually exclusive with the "!persist" property.',
          span,
        ),
      );
    }

    return errors;
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
    return whiteListedTypes.contains(type.className) ||
        _isModelType(type) ||
        _isCustomType(type);
  }

  bool _isUnsupportedType(TypeDefinition type) {
    return blackListedTypes.contains(type.className);
  }

  bool _isUnresolvedModuleType(TypeDefinition type) {
    if (!type.isModuleType) return false;

    var moduleAlias = type.moduleAlias;
    if (moduleAlias == null) return false;

    return !parsedModels.moduleNames.contains(moduleAlias);
  }

  bool _isModelType(TypeDefinition type) {
    var className = type.className;

    var definitions = parsedModels.classNames[className];

    if (definitions == null) return false;
    if (definitions.isEmpty) return false;

    var referenceClasses = definitions.whereType<ClassDefinition>();

    if (referenceClasses.isNotEmpty) {
      var moduleAlias = type.moduleAlias;
      return referenceClasses.any((e) => e.moduleAlias == moduleAlias);
    }

    return true;
  }

  bool _isCustomType(TypeDefinition type) {
    return config.extraClasses.any((c) => c.className == type.className);
  }

  bool _hasTableDefined(SerializableModelDefinition classDefinition) {
    if (classDefinition is! ClassDefinition) return false;

    return classDefinition.tableName != null;
  }

  Set<ClassDefinition> _extractAllClassDefinitionsFromType(
    TypeDefinition fieldType,
  ) {
    var classDefinitions = <ClassDefinition>{};

    if (fieldType.generics.isNotEmpty) {
      for (var generic in fieldType.generics) {
        classDefinitions.addAll(_extractAllClassDefinitionsFromType(generic));
      }
    }

    var className = fieldType.className;
    var definition = parsedModels.findByClassName(className);

    if (definition is ClassDefinition) classDefinitions.add(definition);

    return classDefinitions;
  }

  ClassDefinition? _getParentClass(ClassDefinition currentClass) {
    if (currentClass.extendsClass is! ResolvedInheritanceDefinition) {
      return null;
    }

    return (currentClass.extendsClass as ResolvedInheritanceDefinition)
        .classDefinition;
  }

  /// Traverses up the class hierarchy from [currentModel], applying [predicate] to each parent.
  /// Returns the first non-null result from [predicate], or `null` if no match is found.
  ///
  /// ```dart
  /// var serverOnlyAncestor = _findInParentHierarchy(
  ///   currentModel,
  ///  (ClassDefinition ancestor) => ancestor.serverOnly ? ancestor : null,
  /// );
  /// ```
  T? _findInParentHierarchy<T>(
    ClassDefinition currentModel,
    T? Function(ClassDefinition) predicate,
  ) {
    var parentModel = _getParentClass(currentModel);

    while (parentModel != null) {
      var result = predicate(parentModel);
      if (result != null) return result;

      parentModel = _getParentClass(parentModel);
    }

    return null;
  }

  ClassDefinition? _findTableClassInParentClasses(
    ClassDefinition currentModel,
  ) {
    return _findInParentHierarchy(
      currentModel,
      (ClassDefinition ancestor) =>
          ancestor.tableName != null ? ancestor : null,
    );
  }

  ClassDefinition? _findServerOnlyClassInParentClasses(
    ClassDefinition currentModel,
  ) {
    return _findInParentHierarchy(
      currentModel,
      (ClassDefinition ancestor) => ancestor.serverOnly ? ancestor : null,
    );
  }

  ClassDefinition? _findAncestorWithDuplicatedFieldName(
    ClassDefinition currentModel,
    String fieldName,
  ) {
    return _findInParentHierarchy(
      currentModel,
      (ClassDefinition ancestor) {
        var parentFieldNames = ancestor.fields.map((field) => field.name);

        if (parentFieldNames.contains(fieldName)) {
          return ancestor;
        }

        return null;
      },
    );
  }

  SerializableModelFieldDefinition? _findFieldWithDuplicatedName(
    ClassDefinition currentModel,
    String fieldName,
  ) {
    return _findInParentHierarchy(
      currentModel,
      (ClassDefinition ancestor) {
        return ancestor.fields
            .where((field) => field.name == fieldName)
            .firstOrNull;
      },
    );
  }
}
