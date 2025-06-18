import 'package:serverpod_cli/analyzer.dart';
import 'package:serverpod_cli/src/analyzer/code_analysis_collector.dart';
import 'package:serverpod_cli/src/analyzer/models/checker/analyze_checker.dart';
import 'package:serverpod_cli/src/analyzer/models/converter/converter.dart';
import 'package:serverpod_cli/src/analyzer/models/definitions.dart';
import 'package:serverpod_cli/src/analyzer/models/validation/keywords.dart';
import 'package:serverpod_cli/src/analyzer/models/validation/restrictions/scope.dart';
import 'package:serverpod_cli/src/config/serverpod_feature.dart';
import 'package:serverpod_cli/src/util/model_helper.dart';
import 'package:serverpod_cli/src/util/string_validators.dart';
import 'package:serverpod_service_client/serverpod_service_client.dart';
import 'package:serverpod_shared/serverpod_shared.dart';
import 'package:source_span/source_span.dart';
import 'package:yaml/yaml.dart';

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

    const reservedClassNames = {
      'List',
      'Set',
      'Map',
      'String',
      'DateTime',
      'Client',
      'Endpoints',
      'Protocol',
      'Vector',
      'HalfVector',
      'SparseVector',
      'Bit',
      '_Record',
    };
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

    var classesByName = parsedModels.classNames[className]?.where((model) =>
        model.type.moduleAlias == documentDefinition?.type.moduleAlias);

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

    if (currentModel is ModelClassDefinition) {
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

    if (parentClass.type.moduleAlias != defaultModuleAlias) {
      return [
        SourceSpanSeverityException(
          'You can only extend classes from your own project.',
          span,
        )
      ];
    }

    var currentModel =
        parsedModels.findByClassName(documentDefinition!.className);

    if (currentModel is ModelClassDefinition) {
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
    var definition = documentDefinition;

    if (definition is! ClassDefinition) return [];

    var field = definition.findField(parentNodeName);
    if (field == null) return [];

    if (field.type.isIdType) {
      return [
        SourceSpanSeverityException(
          'The "optional" property should be omitted on id fields.',
          span,
        ),
      ];
    }

    return [];
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
    if (def is ModelClassDefinition &&
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

    if (def is ModelClassDefinition) {
      var currentModel = parsedModels.findByClassName(def.className);

      if (currentModel is ModelClassDefinition) {
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

    if (classDefinition is! ModelClassDefinition) return [];

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
    if (classDefinition is! ModelClassDefinition) return [];

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
    ModelClassDefinition classDefinition,
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

  List<SourceSpanSeverityException> validateIndexUniqueKey(
    String parentNodeName,
    dynamic content,
    SourceSpan? span,
  ) {
    var definition = documentDefinition;
    if (definition is! ModelClassDefinition) return [];

    var index =
        definition.indexes.firstWhere((index) => index.name == parentNodeName);

    if (index.isVectorIndex) {
      return [
        SourceSpanSeverityException(
          'The "unique" property cannot be used with vector indexes of '
          'type "${index.type}".',
          span,
        )
      ];
    }

    return [];
  }

  List<SourceSpanSeverityException> validateIndexDistanceFunctionKey(
    String parentNodeName,
    dynamic content,
    SourceSpan? span,
  ) {
    var definition = documentDefinition;
    if (definition is! ModelClassDefinition) return [];

    var index =
        definition.indexes.firstWhere((index) => index.name == parentNodeName);

    if (!index.isVectorIndex) {
      return [
        SourceSpanSeverityException(
          'The "${Keyword.distanceFunction}" property can only be used with vector '
          'indexes of type "${VectorIndexType.values.map((e) => e.name).join(", ")}".',
          span,
        )
      ];
    }

    return [];
  }

  List<SourceSpanSeverityException> validateIndexParametersKey(
    String parentNodeName,
    dynamic content,
    SourceSpan? span,
  ) {
    var definition = documentDefinition;
    if (definition is! ModelClassDefinition) return [];

    var index =
        definition.indexes.firstWhere((index) => index.name == parentNodeName);

    if (!index.isVectorIndex) {
      return [
        SourceSpanSeverityException(
          'The "${Keyword.parameters}" property can only be used with vector indexes '
          'of type "${VectorIndexType.values.map((e) => e.name).join(", ")}".',
          span,
        )
      ];
    }

    return [];
  }

  List<SourceSpanSeverityException> validateRelationInterdependencies(
    String parentNodeName,
    dynamic content,
    SourceSpan? span,
  ) {
    var classDefinition = documentDefinition;
    if (classDefinition is! ClassDefinition) return const [];

    var field = classDefinition.findField(parentNodeName);
    if (field == null) return const [];

    if (field.type.isIdType && !AnalyzeChecker.isParentDefined(content)) {
      return [
        SourceSpanSeverityException(
          'The "parent" property must be defined on id fields.',
          span,
        )
      ];
    }

    var relation = field.relation;
    if (relation is! ObjectRelationDefinition) return const [];

    if (!AnalyzeChecker.isFieldDefined(content) &&
        !classDefinition.serverOnly &&
        field.scope == ModelFieldScopeDefinition.serverOnly &&
        !relation.nullableRelation) {
      return [
        SourceSpanSeverityException(
          'The relation with scope "${field.scope.name}" requires the relation to be optional.',
          span,
        )
      ];
    }

    return const [];
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
    if (definition is ModelClassDefinition && definition.tableName == null) {
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

    if ((classDefinition is ModelClassDefinition) &&
        (classDefinition.tableName != null) &&
        (parentNodeName == defaultPrimaryKeyName)) {
      var typeClassName = field.type.className;
      var supportedTypes = SupportedIdType.all.map((e) => e.type.className);

      if (!supportedTypes.contains(typeClassName)) {
        errors.add(
          SourceSpanSeverityException(
            'The type "$typeClassName" is not a valid id type. Valid options '
            'are: ${supportedTypes.toSet().join(', ')}.',
            span,
          ),
        );
      } else if (!field.hasDefaults) {
        errors.add(
          SourceSpanSeverityException(
            'The type "$typeClassName" must have a default value. Use '
            'either the "${Keyword.defaultModelKey}" key or the '
            '"${Keyword.defaultPersistKey}" key to set it.',
            span,
          ),
        );
      } else if (field.type.className == 'int' && !field.type.nullable) {
        errors.add(
          SourceSpanSeverityException(
            'The type "$typeClassName" must be nullable for the field '
            '"$parentNodeName". Use the "?" operator to make it nullable '
            '(e.g. $parentNodeName: $typeClassName?).',
            span,
          ),
        );
      }
    }

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
        span?.text.contains(typeName) == true
            ? span?.subspan(
                span.text.indexOf(typeName),
                span.text.indexOf(typeName) + typeName.length,
              )
            : span,
      ));
    }

    if (fieldType.isVectorType) {
      if (fieldType.vectorDimension == null) {
        errors.add(SourceSpanSeverityException(
          'The vector type must have an integer dimension defined between '
          'parentheses after the type name (e.g. Vector(512)).',
          span,
        ));
      } else if (fieldType.vectorDimension! < 1) {
        errors.add(SourceSpanSeverityException(
          'Invalid vector dimension "${fieldType.vectorDimension}". Vector '
          'dimension must be an integer number greater than 0.',
          span,
        ));
      }
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
    } else if (fieldType.isSetType) {
      if (fieldType.generics.length == 1) {
        errors.addAll(_validateFieldDataType(fieldType.generics.first, span));
      } else {
        errors.add(
          SourceSpanSeverityException(
            'The Set type must have one generic type defined (e.g. Set<String>).',
            span,
          ),
        );
      }
    } else if (fieldType.isRecordType) {
      if (fieldType.generics.isNotEmpty) {
        errors.addAll(
          fieldType.generics.expand(
            (field) => _validateFieldDataType(field, span),
          ),
        );
      } else {
        // The current parser would not create a `Record` type without generics (fields), but we guard against it just in case that ever changes
        errors.add(
          SourceSpanSeverityException(
            'A record type must have at least one field defined (e.g. (int,)).',
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

    var definition = documentDefinition;
    if (definition is! ModelClassDefinition) return [];

    var fields = definition.fieldsIncludingInherited;
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

    var hasVectorField = fields
        .where((f) => indexFields.contains(f.name))
        .map((f) => f.type.isVectorType)
        .toSet();

    var vectorErrors = [
      if (hasVectorField.length > 1)
        SourceSpanSeverityException(
          'Mixing vector and non-vector fields in the same index is not allowed.',
          span,
        ),
      if (hasVectorField.any((e) => e) && indexFields.length > 1)
        SourceSpanSeverityException(
          'Only one vector field is allowed in an index.',
          span,
        ),
    ];

    return [...missingFieldErrors, ...duplicateFieldErrors, ...vectorErrors];
  }

  List<SourceSpanSeverityException> validateIndexDistanceFunctionValue(
    String parentNodeName,
    dynamic content,
    SourceSpan? span,
  ) {
    if (content == null) return [];
    if (content is! String) {
      return [
        SourceSpanSeverityException(
          'The "${Keyword.distanceFunction}" property must be a String.',
          span,
        )
      ];
    }

    var definition = documentDefinition;
    if (definition is! ModelClassDefinition) return [];

    var index = definition.indexes.firstWhere((e) => e.name == parentNodeName);
    var field = definition.findField(index.fields.first);
    if (field == null) return [];

    var validFunctionsPerClassName = {
      for (var className in {'Vector', 'SparseVector'})
        className: {
          VectorDistanceFunction.l2,
          VectorDistanceFunction.innerProduct,
          VectorDistanceFunction.cosine,
          VectorDistanceFunction.l1,
        },
      'HalfVector': {
        VectorDistanceFunction.l2,
        VectorDistanceFunction.innerProduct,
        VectorDistanceFunction.cosine,
        if (index.type == 'hnsw') VectorDistanceFunction.l1,
      },
      'Bit': {
        VectorDistanceFunction.jaccard,
        VectorDistanceFunction.hamming,
      },
    };

    var validFunctions =
        validFunctionsPerClassName[field.type.className]?.map((e) => e.name);
    if (validFunctions != null && !validFunctions.contains(content)) {
      return [
        SourceSpanSeverityException(
          'Invalid distance function "$content". Allowed values are: '
          '"${validFunctions.join('", "')}".',
          span,
        )
      ];
    }

    return [];
  }

  List<SourceSpanSeverityException> validateIndexParametersValue(
    String parentNodeName,
    dynamic content,
    SourceSpan? span,
  ) {
    var errors = <SourceSpanSeverityException>[];

    if (content is! YamlMap) {
      return [
        SourceSpanSeverityException(
          'The "parameters" property must be a map.',
          span,
        )
      ];
    }

    var definition = documentDefinition;
    if (definition is! ModelClassDefinition) return [];

    var index =
        definition.indexes.firstWhere((index) => index.name == parentNodeName);
    if (!index.isVectorIndex) return [];

    Map<String, Set<String>> allowedParamsByType = {
      'hnsw': {'m', 'ef_construction'},
      'ivfflat': {'lists'},
    };

    Map<String, Type> parameterTypes = {
      'm': int,
      'ef_construction': int,
      'lists': int,
    };

    var allowedParams = allowedParamsByType[index.type] ?? <String>{};
    var unknownKeys = content.keys.toSet().difference(allowedParams);
    if (unknownKeys.isNotEmpty) {
      errors.add(SourceSpanSeverityException(
        'Unknown parameters for ${index.type} index: "${unknownKeys.join('", "')}". '
        'Allowed parameters are: "${allowedParams.join('", "')}".',
        span,
      ));
    }

    for (var key in content.keys) {
      var value = content[key];
      if (allowedParams.contains(key) &&
          parameterTypes.containsKey(key) &&
          value != null &&
          value.runtimeType != parameterTypes[key]) {
        errors.add(SourceSpanSeverityException(
          'The "$key" parameter must be a '
          '${parameterTypes[key]!.toString().toLowerCase()}.',
          span,
        ));
      }
    }

    // If either 'm' or 'ef_construction' parameters are present, validate the
    // HNSW index constraint that ef_construction >= 2 * m.
    if (index.type == 'hnsw' &&
        content['m'] is int? &&
        content['ef_construction'] is int?) {
      var m = content['m'] as int? ?? 16;
      var efConstruction = content['ef_construction'] as int? ?? 64;

      if (efConstruction < 2 * m) {
        String suggestion;
        if (!content.containsKey('m')) {
          suggestion = 'Set "ef_construction" >= ${2 * m} or declare "m" with '
              'a value <= ${efConstruction ~/ 2}';
        } else if (!content.containsKey('ef_construction')) {
          suggestion = 'Set "m" <= ${efConstruction ~/ 2} or declare '
              '"ef_construction" with a value >= ${2 * m}';
        } else {
          suggestion = 'Set "m" <= ${efConstruction ~/ 2} or increase '
              '"ef_construction" to a value >= ${2 * m}';
        }
        errors.add(SourceSpanSeverityException(
          'The "ef_construction" parameter must be greater than or equal to '
          '2 * m. $suggestion.',
          span,
        ));
      }
    }

    return errors;
  }

  List<SourceSpanSeverityException> validateIndexType(
    String parentNodeName,
    dynamic content,
    SourceSpan? span,
  ) {
    var validIndexTypes = {'btree', 'hash', 'gin', 'gist', 'spgist', 'brin'};

    var definition = documentDefinition;
    if (definition is ModelClassDefinition) {
      var indexFields = definition.fieldsIncludingInherited.where(
        (f) => f.indexes.where((e) => e.name == parentNodeName).isNotEmpty,
      );

      var index = definition.indexes.where((e) => e.name == parentNodeName);
      if (indexFields.any((e) => e.type.className == 'SparseVector') &&
          index.first.type != 'hnsw') {
        return [
          SourceSpanSeverityException(
            'Only "hnsw" index type is supported for "SparseVector" fields.',
            span,
          )
        ];
      }

      if (indexFields.any((e) => e.type.isVectorType)) {
        validIndexTypes = VectorIndexType.values.map((e) => e.name).toSet();
      }
    }

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

    if (definition is! ModelClassDefinition) return [];

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
          referenceClass.type.moduleAlias != definition.type.moduleAlias) {
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

  List<SourceSpanSeverityException> validateScopeKey(
    String parentNodeName,
    String key,
    SourceSpan? span,
  ) {
    var definition = documentDefinition;
    if (definition is! ClassDefinition) return [];

    var errors = <SourceSpanSeverityException>[];

    if ((definition is ModelClassDefinition) &&
        (definition.tableName != null) &&
        (parentNodeName == defaultPrimaryKeyName)) {
      errors.add(SourceSpanSeverityException(
        'The "${Keyword.scope}" key is not allowed on the "id" field.',
        span,
      ));
    }

    return errors;
  }

  List<SourceSpanSeverityException> validatePersistKey(
    String parentNodeName,
    String relation,
    SourceSpan? span,
  ) {
    var definition = documentDefinition;
    if (definition is! ModelClassDefinition) return [];

    var errors = <SourceSpanSeverityException>[];

    if (definition.tableName == null) {
      errors.add(SourceSpanSeverityException(
        'The "persist" property requires a table to be set on the class.',
        span,
      ));
    } else if (parentNodeName == defaultPrimaryKeyName) {
      return [
        SourceSpanSeverityException(
          'The "${Keyword.persist}" key is not allowed on the "id" field.',
          span,
        ),
      ];
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
    if (classDefinition is! ModelClassDefinition) return [];

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

  List<SourceSpanSeverityException> validateEnumDefaultValue(
    String parentNodeName,
    dynamic content,
    SourceSpan? span,
  ) {
    if (content is! String) {
      return [
        SourceSpanSeverityException(
          'The "default" property must be a String.',
          span,
        )
      ];
    }

    var definition = documentDefinition;
    if (definition is! EnumDefinition) return [];
    final values = definition.values;
    if (values.any((value) => value.name == content)) return [];
    return [
      SourceSpanSeverityException(
        '"$content" is not a valid default value. Allowed values are: ${values.map((e) => e.name).join(', ')}.',
        span,
      )
    ];
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

    if ((definition is ModelClassDefinition) &&
        (definition.tableName != null) &&
        (parentNodeName == defaultPrimaryKeyName)) {
      var besidePersistKey = (field.type.className == 'int')
          ? 'Either omit the default key or use the'
          : 'Use either the "${Keyword.defaultModelKey}" key or the';
      errors.add(
        SourceSpanSeverityException(
          'The "${Keyword.defaultKey}" key is not allowed on the "id" field. '
          '$besidePersistKey "${Keyword.defaultPersistKey}" key instead.',
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
    'Uri',
    'BigInt',
    'ByteData',
    'Vector',
    'HalfVector',
    'SparseVector',
    'Bit',
    'List',
    'Map',
    'Set',
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
        _isCustomType(type) ||
        _isRecordType(type);
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
      return referenceClasses.any((e) => e.type.moduleAlias == moduleAlias);
    }

    return true;
  }

  bool _isCustomType(TypeDefinition type) {
    return config.extraClasses.any((c) => c.className == type.className);
  }

  bool _isRecordType(TypeDefinition type) {
    return type.isRecordType && type.generics.every(_isValidType);
  }

  bool _hasTableDefined(SerializableModelDefinition classDefinition) {
    if (classDefinition is! ModelClassDefinition) return false;

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

  ModelClassDefinition? _getParentClass(ModelClassDefinition currentClass) {
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
    ModelClassDefinition currentModel,
    T? Function(ModelClassDefinition) predicate,
  ) {
    var parentModel = _getParentClass(currentModel);

    while (parentModel != null) {
      var result = predicate(parentModel);
      if (result != null) return result;

      parentModel = _getParentClass(parentModel);
    }

    return null;
  }

  ModelClassDefinition? _findTableClassInParentClasses(
    ModelClassDefinition currentModel,
  ) {
    return _findInParentHierarchy(
      currentModel,
      (ModelClassDefinition ancestor) =>
          ancestor.tableName != null ? ancestor : null,
    );
  }

  ModelClassDefinition? _findServerOnlyClassInParentClasses(
    ModelClassDefinition currentModel,
  ) {
    return _findInParentHierarchy(
      currentModel,
      (ModelClassDefinition ancestor) => ancestor.serverOnly ? ancestor : null,
    );
  }

  ModelClassDefinition? _findAncestorWithDuplicatedFieldName(
    ModelClassDefinition currentModel,
    String fieldName,
  ) {
    return _findInParentHierarchy(
      currentModel,
      (ModelClassDefinition ancestor) {
        var parentFieldNames = ancestor.fields.map((field) => field.name);

        if (parentFieldNames.contains(fieldName)) {
          return ancestor;
        }

        return null;
      },
    );
  }

  SerializableModelFieldDefinition? _findFieldWithDuplicatedName(
    ModelClassDefinition currentModel,
    String fieldName,
  ) {
    return _findInParentHierarchy(
      currentModel,
      (ModelClassDefinition ancestor) {
        return ancestor.fields
            .where((field) => field.name == fieldName)
            .firstOrNull;
      },
    );
  }
}
