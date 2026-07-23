import 'package:path/path.dart' as p;
import 'package:serverpod_cli/src/analyzer/models/serialization_data_type.dart';
import 'package:serverpod_cli/src/generator/types.dart';
import 'package:serverpod_database/serverpod_database.dart';
import 'package:serverpod_shared/serverpod_shared.dart';

export 'package:serverpod_database/src/definition/default_keywords.dart';

/// An abstract representation of a yaml file in the
/// protocol directory.
sealed class SerializableModelDefinition {
  final String fileName;
  final String sourceFileName;
  final String className;
  final List<String> subDirParts;
  final bool serverOnly;
  final TypeDefinition type;
  final String? sharedPackageName;

  SerializableModelDefinition({
    required this.fileName,
    required this.sourceFileName,
    required this.className,
    required this.serverOnly,
    required this.type,
    this.subDirParts = const [],
    this.sharedPackageName,
  });

  /// Generate the file reference [String] to this file.
  String fileRef() {
    var path = p.posix.joinAll([...subDirParts, '$fileName.dart']);

    // If on Windows, paths could appear with backslashes in the import clause.
    // Normalize to forward slashes.
    return p.split(path).join('/');
  }

  /// Whether this model is declared in a shared package. Such models are not
  /// generated on the server or client side, but on its own shared package.
  bool get isSharedModel => sharedPackageName != null;
}

/// A representation of a yaml file in the protocol directory defining a class
/// or exception.
///
/// See also:
/// - [EnumDefinition]
sealed class ClassDefinition extends SerializableModelDefinition {
  /// The fields of this class / exception.
  List<SerializableModelFieldDefinition> fields;

  /// The documentation of this class, line by line.
  final List<String>? documentation;

  /// If set to true the class is sealed.
  final bool isSealed;

  /// If set to [InheritanceDefinition] the class extends another class and
  /// stores the [ClassDefinition] of its parent.
  InheritanceDefinition? extendsClass;

  /// If set to a List of [InheritanceDefinition] the class is a parent class
  /// that stores the child classes.
  List<InheritanceDefinition> childClasses;

  /// Create a new [ClassDefinition].
  ClassDefinition({
    required super.fileName,
    required super.sourceFileName,
    required super.className,
    required this.fields,
    required super.serverOnly,
    required super.type,
    required this.isSealed,
    List<InheritanceDefinition>? childClasses,
    this.extendsClass,
    super.subDirParts,
    super.sharedPackageName,
    this.documentation,
  }) : childClasses = childClasses ?? <InheritanceDefinition>[];

  SerializableModelFieldDefinition? findField(String name) {
    return fields.where((element) => element.name == name).firstOrNull;
  }

  /// Returns the `ClassDefinition` of the parent class.
  /// If there is no parent class, `null` is returned.
  ClassDefinition? get parentClass {
    var extendsClass = this.extendsClass;
    if (extendsClass is! ResolvedInheritanceDefinition) return null;

    var classDefinition = extendsClass.classDefinition;
    if (classDefinition.runtimeType != runtimeType) return null;
    return classDefinition;
  }

  /// Returns a list of all fields in the parent class.
  /// If there is no parent class, an empty list is returned.
  List<SerializableModelFieldDefinition> get inheritedFields =>
      parentClass?.fieldsIncludingInherited.toList() ?? [];

  /// Returns a list of all fields in this class, including inherited fields.
  /// Non-tail fields are ordered top-down through the inheritance chain. Tail
  /// fields are ordered bottom-up so that root parent tail fields appear last.
  List<SerializableModelFieldDefinition> get fieldsIncludingInherited {
    return _fieldsWithTailFieldsLast(
      inheritedFields: inheritedFields,
      fields: fields,
    );
  }

  /// Returns `true` if this class is a parent class or sealed.
  bool get isParentClass => childClasses.isNotEmpty || isSealed;

  /// Returns the top node of the sealed hierarchy. If the class is the top node
  /// it returns itself. If the class is not part of a sealed hierarchy, `null`
  /// is returned.
  ClassDefinition? get sealedTopNode {
    final parent = parentClass;
    if (parent != null) {
      final parentsSealedTopNode = parent.sealedTopNode;
      if (parentsSealedTopNode != null) return parentsSealedTopNode;
    }

    if (isSealed) return this;

    return null;
  }

  /// Returns `true` if this class is the top node of a sealed hierarchy.
  bool get isSealedTopNode => identical(sealedTopNode, this);

  /// Returns `true` if all parent classes are sealed.
  /// Returns `true` if the class does not have a parent class.
  bool get everyParentIsSealed {
    var parent = parentClass;
    if (parent == null) return true;

    if (!parent.isSealed) {
      return false;
    }

    return parent.everyParentIsSealed;
  }

  /// Returns a list of all descendant classes.
  /// This includes all child classes and their descendants.
  /// If the class has no child classes, an empty list is returned.
  List<ClassDefinition> get descendantClasses {
    List<ClassDefinition> descendants = [];

    for (var child in childClasses) {
      if (child is! ResolvedInheritanceDefinition) continue;
      var classDefinition = child.classDefinition;
      if (classDefinition.runtimeType != runtimeType) continue;

      descendants.add(classDefinition);
      descendants.addAll(classDefinition.descendantClasses);
    }

    return descendants;
  }

  /// Returns the type name used in validation messages.
  String get typeName => switch (this) {
    ModelClassDefinition() => 'model',
    ExceptionClassDefinition() => 'exception',
  };
}

/// A [ClassDefinition] specialization that represents a model class.
final class ModelClassDefinition extends ClassDefinition {
  /// If set, the name of the table, this class should be stored in, in the
  /// database.
  final String? tableName;

  /// Determines where table-backed database code should be generated.
  final ModelDatabaseDefinition database;

  /// The indexes that should be created for the table [tableName] representing
  /// this class.
  ///
  /// The index over the primary key `id` is not part of this list.
  final List<SerializableModelIndexDefinition> indexes;

  final bool manageMigration;

  /// If set to true the class is immutable.
  final bool isImmutable;

  /// If set to true, this class is a base for table-backed subclasses and may
  /// declare relations without having a table itself.
  final bool isTableBase;

  /// If set, the default data type used for serialization of the JSON columns in this class.
  /// It can be overridden for each field.
  final SerializationDataType? serializationDataType;

  /// Create a new [ModelClassDefinition].
  ModelClassDefinition({
    required super.fileName,
    required super.sourceFileName,
    required super.className,
    required super.fields,
    required super.serverOnly,
    required this.manageMigration,
    required super.type,
    required super.isSealed,
    required this.isImmutable,
    this.isTableBase = false,
    super.childClasses,
    super.extendsClass,
    this.database = ModelDatabaseDefinition.server,
    this.tableName,
    this.serializationDataType,
    this.indexes = const [],
    super.subDirParts,
    super.documentation,
    super.sharedPackageName,
  });

  @override
  ModelClassDefinition? get parentClass =>
      super.parentClass as ModelClassDefinition?;

  @override
  ModelClassDefinition? get sealedTopNode =>
      super.sealedTopNode as ModelClassDefinition?;

  @override
  List<ModelClassDefinition> get descendantClasses =>
      super.descendantClasses.cast<ModelClassDefinition>().toList();

  /// Returns the `SerializableModelFieldDefinition` of the 'id' field.
  /// If the field is not present, an error is thrown.
  SerializableModelFieldDefinition get idField =>
      findField(defaultPrimaryKeyName)!;

  /// Returns true if database code should be generated for the specified side.
  bool shouldGenerateTableCode(bool serverCode) {
    if (tableName == null) return false;

    return switch (database) {
      ModelDatabaseDefinition.server => serverCode,
      ModelDatabaseDefinition.client => !serverCode,
      ModelDatabaseDefinition.all => true,
    };
  }

  /// Returns a list of all fields in the parent class.
  /// If there is no parent class, an empty list is returned.
  /// Excludes the id field, as it is re-declared on child classes.
  @override
  List<SerializableModelFieldDefinition> get inheritedFields => super
      .inheritedFields
      .where((element) => tableName == null || element.name != 'id')
      .toList();

  /// Returns `true` if the 'id' field is inherited from a parent class.
  bool get isIdInherited =>
      parentClass?.fieldsIncludingInherited.any((f) => f.name == 'id') ?? false;

  /// Returns a list of all fields in this class, including inherited fields.
  /// It ensures that the 'id' field, if present on this class, is always
  /// included at the beginning of the list. Non-tail fields are ordered
  /// top-down through the inheritance chain. Tail fields are ordered bottom-up
  /// so that root parent tail fields appear last.
  @override
  List<SerializableModelFieldDefinition> get fieldsIncludingInherited {
    final idField = fields
        .where((element) => element.name == defaultPrimaryKeyName)
        .firstOrNull;

    return _fieldsWithTailFieldsLast(
      firstField: idField,
      inheritedFields: inheritedFields,
      fields: fields.where((element) => element.name != defaultPrimaryKeyName),
    );
  }

  /// Returns a list of all indexes declared in the parent class.
  /// If there is no parent class, an empty list is returned.
  /// Inherited indexes act as index generators for child classes.
  /// They are created with the table name as prefix to the original name.
  List<SerializableModelIndexDefinition> get inheritedIndexes {
    var inherited = parentClass?.indexesIncludingInherited ?? [];
    if (tableName == null) return inherited;
    return [
      for (var index in inherited) index.copyWithPrefix(tableName!),
    ];
  }

  /// Returns a list of all indexes in this class, including inherited indexes.
  List<SerializableModelIndexDefinition> get indexesIncludingInherited {
    return [
      ...inheritedIndexes,
      ...indexes,
    ];
  }
}

/// A [ClassDefinition] specialization that represents an exception.
final class ExceptionClassDefinition extends ClassDefinition {
  /// Create a new [ExceptionClassDefinition].
  ExceptionClassDefinition({
    required super.className,
    required super.fields,
    required super.fileName,
    required super.serverOnly,
    required super.sourceFileName,
    required super.type,
    required super.isSealed,
    super.childClasses,
    super.extendsClass,
    super.documentation,
    super.subDirParts,
    super.sharedPackageName,
  });

  @override
  ExceptionClassDefinition? get parentClass =>
      super.parentClass as ExceptionClassDefinition?;

  @override
  ExceptionClassDefinition? get sealedTopNode =>
      super.sealedTopNode as ExceptionClassDefinition?;

  @override
  List<ExceptionClassDefinition> get descendantClasses =>
      super.descendantClasses.cast<ExceptionClassDefinition>().toList();
}

/// Describes a single field of a [ClassDefinition].
class SerializableModelFieldDefinition {
  /// The name of the field.
  final String name;

  /// The type of the field.
  TypeDefinition type;

  /// The scope of the field.
  /// It tells us if the field should only be present
  /// in a certain context.
  ///
  /// See also:
  /// - [ModelFieldScopeDefinition]
  final ModelFieldScopeDefinition scope;

  final bool shouldPersist;

  // default model value
  final dynamic defaultModelValue;

  // default valdatabase
  final dynamic defaultPersistValue;

  /// returns true if one of the defaults its not null
  bool get hasDefaults =>
      defaultModelValue != null || defaultPersistValue != null;

  /// returns true if only has database default
  bool get hasOnlyDatabaseDefaults =>
      defaultModelValue == null && defaultPersistValue != null;

  /// If set the field is a relation to another table. The type of the relation
  /// [ForeignRelationDefinition], [ObjectRelationDefinition] or [ListRelationDefinition]
  /// determines where and how the relation is stored.
  RelationDefinition? relation;

  /// Returns true, if this field has a relation pointer to/from another field
  /// with relation type [ForeignRelationDefinition]. This means that this field
  /// relation does not propagate to the database, but instead is managed by
  /// the other field.
  bool get isSymbolicRelation =>
      relation != null && relation is! ForeignRelationDefinition;

  /// The documentation of this field, line by line.
  final List<String>? documentation;

  /// Whether this nullable field should be required in constructor parameters.
  /// When true, nullable fields will be marked as required named parameters.
  final bool isRequired;

  /// When true, this field is placed at the end of the combined field list
  /// when inherited. Tail fields from child classes appear before tail fields
  /// from parent classes.
  final bool isTail;

  /// Name of the column in the database
  final String? _columnNameOverride;

  /// Name of the column to be used when referencing the database.
  ///
  /// This will be the [_columnNameOverride] if set, with fallback to the [name]
  String get columnName => _columnNameOverride ?? name;

  /// Whether this field has a column name override.
  bool get hasColumnNameOverride => _columnNameOverride != null;

  final String? _jsonKeyOverride;

  /// Key to use for JSON serialization/deserialization.
  ///
  /// This will be the [_jsonKeyOverride] if set, with fallback to the [name]
  String get jsonKey => _jsonKeyOverride ?? name;

  bool get hasJsonKeyOverride => _jsonKeyOverride != null;

  /// Indexes that this field is part of.
  List<SerializableModelIndexDefinition> indexes = [];

  /// Prefix field names for a composite unique index, or an empty list for a
  /// single-column unique index. `null` means this field is not unique.
  final List<String>? uniquePerFieldNames;

  /// Whether this field should have a unique index auto-generated for it.
  bool get shouldCreateUniqueIndex => uniquePerFieldNames != null;

  /// Create a new [SerializableModelFieldDefinition].
  SerializableModelFieldDefinition({
    required this.name,
    required this.type,
    required this.scope,
    required this.shouldPersist,
    this.defaultModelValue,
    this.defaultPersistValue,
    this.relation,
    this.documentation,
    this.isRequired = false,
    this.isTail = false,
    String? columnNameOverride,
    String? jsonKeyOverride,
    this.uniquePerFieldNames,
  }) : _columnNameOverride = columnNameOverride,
       _jsonKeyOverride = jsonKeyOverride;

  /// Returns true, if classes should include this field.
  /// [serverCode] specifies if it's a code on the server or client side.
  ///
  /// See also:
  /// - [shouldSerializeField]
  bool shouldIncludeField(bool serverCode) {
    return scope == ModelFieldScopeDefinition.all ||
        (serverCode && scope == ModelFieldScopeDefinition.serverOnly);
  }

  /// Returns true, if this field should be added to the serialization.
  /// [serverCode] specifies if it's code on the server or client side.
  ///
  /// See also:
  /// - [shouldIncludeField]
  bool shouldSerializeField(bool serverCode) {
    return scope == ModelFieldScopeDefinition.all;
  }

  /// Whether this field is persisted in the database but hidden from the
  /// protocol (`toJsonForProtocol`) output.
  ///
  /// This is only about persisted [ModelFieldScopeDefinition.none] fields, such
  /// as the implicit relation FKs generated for object relations. Those are
  /// stored in the database and kept in [SerializableModel.toJson], but must be
  /// omitted from protocol serialization.
  ///
  /// Note this is unrelated to `!persist` (`shouldPersist == false`): a
  /// `!persist` field with `scope: all` is *not* stored in the database but
  /// *is* sent over the wire. On the client, only implicit one-to-many child
  /// keys qualify as hidden.
  bool hiddenSerializableField(bool serverCode) {
    if (serverCode) {
      return shouldPersist && scope == ModelFieldScopeDefinition.none;
    }
    if (!shouldPersist || scope != ModelFieldScopeDefinition.none) {
      return false;
    }
    final relation = this.relation;
    return relation is ForeignRelationDefinition &&
        relation.containerField == null;
  }

  /// Whether code generation should emit this field on the in-memory model
  /// and *Implicit* copy/fromJson helpers.
  ///
  /// On the client, [modelHasTable] must be [true] when the model class is
  /// table-backed for this code side (e.g. [ModelClassDefinition.shouldGenerateTableCode]).
  bool shouldIncludeHiddenFieldInModelClass(
    bool serverCode, {
    bool modelHasTable = true,
  }) {
    if (!hiddenSerializableField(serverCode)) {
      return false;
    }
    if (serverCode) {
      return true;
    }
    return modelHasTable;
  }

  /// When [shouldCreateUniqueIndex] is true, the btree unique index that is
  /// auto-created for this field on [tableName]; otherwise `null`.
  SerializableModelIndexDefinition? autoGeneratedUniqueIndexDefinition(
    String tableName,
    List<SerializableModelFieldDefinition> allFields,
  ) {
    if (!shouldCreateUniqueIndex) return null;

    var indexColumnNames = [
      for (var perFieldName in uniquePerFieldNames!)
        _resolveUniqueIndexColumnName(perFieldName, allFields),
      columnName,
    ];

    return SerializableModelIndexDefinition(
      name: _autoGeneratedUniqueIndexName(tableName, indexColumnNames),
      type: 'btree',
      unique: true,
      fields: indexColumnNames,
    );
  }

  /// Resolves a `per` field name to its database column name. Falls back to the
  /// name itself when no matching field exists; that case is an authoring error
  /// reported separately by validation, so the generated name is never used.
  static String _resolveUniqueIndexColumnName(
    String fieldName,
    List<SerializableModelFieldDefinition> allFields,
  ) {
    for (var field in allFields) {
      if (field.name == fieldName) return field.columnName;
    }
    return fieldName;
  }

  /// Builds the auto-generated unique index name, keeping it within the
  /// PostgreSQL identifier limit.
  ///
  /// Composite indexes can easily exceed the limit, so when the full
  /// `<table>__<col>__…__unique_idx` name is too long the middle is replaced
  /// with a deterministic digest while the readable head and the
  /// `__unique_idx` suffix are preserved.
  static String _autoGeneratedUniqueIndexName(
    String tableName,
    List<String> indexColumnNames,
  ) {
    const suffix = '__unique_idx';
    var baseName = '${tableName}__${indexColumnNames.join('__')}';

    return truncateIdentifier(
          baseName,
          DatabaseConstants.pgsqlMaxNameLimitation - suffix.length,
          hashLength: 10,
        ) +
        suffix;
  }
}

/// The scope of a field.
enum ModelFieldScopeDefinition {
  all,
  serverOnly,
  none,
}

/// The side that should generate table-backed database code for a model.
enum ModelDatabaseDefinition {
  server,
  client,
  all,
}

/// The definition of an index for a file, that is also stored in the database.
class SerializableModelIndexDefinition {
  /// The name of the index.
  final String name;

  /// The fields this index includes.
  /// The order of the fields matters.
  final List<String> fields;

  /// The type of this index.
  /// Usually this is `btree`.
  final String type;

  /// Whether the [fields] of this index should be unique.
  final bool unique;

  /// The gin index operator class, if it is a gin index.
  final GinOperatorClass? ginOperatorClass;

  /// The vector index distance function, if it is a vector index.
  final VectorDistanceFunction? vectorDistanceFunction;

  /// The parameters of the index, if any. Used for Vector indexes.
  final Map<String, String>? parameters;

  /// Create a new [SerializableModelIndexDefinition].
  SerializableModelIndexDefinition({
    required this.name,
    required this.type,
    required this.unique,
    required this.fields,
    this.ginOperatorClass,
    this.vectorDistanceFunction,
    this.parameters,
  });

  /// Whether the index is of GIN type.
  bool get isGinIndex => type == 'gin';

  /// Whether the index is of vector type.
  bool get isVectorIndex => VectorIndexType.values.any((e) => e.name == type);

  /// Copy the index with a new name that is prefixed with [prefix].
  SerializableModelIndexDefinition copyWithPrefix(String prefix) {
    return SerializableModelIndexDefinition(
      name: '${prefix}_$name',
      type: type,
      unique: unique,
      fields: fields,
      ginOperatorClass: ginOperatorClass,
      vectorDistanceFunction: vectorDistanceFunction,
      parameters: parameters,
    );
  }
}

/// Represents a single property on an enhanced enum.
class EnumPropertyDefinition {
  /// The name of the property.
  final String name;

  /// The type of the property (e.g., 'int', 'String', 'bool').
  final String type;

  /// Whether this property is required (no default value).
  final bool isRequired;

  /// Default value if property is optional.
  final dynamic defaultValue;

  /// Documentation for this property.
  final List<String>? documentation;

  EnumPropertyDefinition({
    required this.name,
    required this.type,
    this.isRequired = true,
    this.defaultValue,
    this.documentation,
  });
}

/// A representation of a yaml file in the protocol directory defining an enum.
class EnumDefinition extends SerializableModelDefinition {
  /// The type of serialization this enum should use.
  final EnumSerialization serialized;

  /// The default value of the enum when parsing of the enum fails.
  final ProtocolEnumValueDefinition? defaultValue;

  /// All the values of the enum.
  /// This also contains possible documentation for them.
  List<ProtocolEnumValueDefinition> values;

  /// The documentation for this enum, line by line.
  final List<String>? documentation;

  /// Properties for enhanced enums with custom fields.
  final List<EnumPropertyDefinition> properties;

  /// Create a new [EnumDefinition].
  EnumDefinition({
    required super.fileName,
    required super.sourceFileName,
    required super.className,
    required this.serialized,
    required this.defaultValue,
    required this.values,
    required super.serverOnly,
    required super.type,
    super.subDirParts,
    this.documentation,
    this.properties = const [],
    super.sharedPackageName,
  });

  /// Whether this is an enhanced enum with properties.
  bool get isEnhanced => properties.isNotEmpty;
}

/// A representation of a single value of a [EnumDefinition].
class ProtocolEnumValueDefinition {
  /// The name of the enums value.
  final String name;

  /// The documentation for this value, line by line.
  final List<String>? documentation;

  /// Property values for enhanced enums.
  final Map<String, dynamic> propertyValues;

  /// Create a new [ProtocolEnumValueDefinition].
  ProtocolEnumValueDefinition(
    this.name, [
    this.documentation,
    this.propertyValues = const {},
  ]);
}

abstract class InheritanceDefinition {}

class UnresolvedInheritanceDefinition extends InheritanceDefinition {
  final String className;

  UnresolvedInheritanceDefinition(this.className);
}

class ResolvedInheritanceDefinition<T extends ClassDefinition>
    extends InheritanceDefinition {
  final T classDefinition;

  ResolvedInheritanceDefinition(this.classDefinition);
}

sealed class RelationDefinition {
  String? name;

  bool isForeignKeyOrigin;

  RelationDefinition(this.name, this.isForeignKeyOrigin);
}

/// Internal representation of an unresolved [ListRelationDefinition].
class UnresolvedListRelationDefinition extends RelationDefinition {
  final bool nullableRelation;

  UnresolvedListRelationDefinition({
    String? name,
    required this.nullableRelation,
  }) : super(name, false);
}

/// Used for relations for fields of type [List] that has a reference pointer
/// to another Objects field name that holds the id of this object.
class ListRelationDefinition extends RelationDefinition {
  /// References the field in the current object that points to the foreign table.
  /// Normally this is the primary key.
  String fieldName;

  /// References the field in the other object holding the id of this object.
  String foreignFieldName;

  /// Type of the id of the table that owns the [foreignFieldName] field.
  TypeDefinition foreignKeyOwnerIdType;

  /// References the field in the other object holding the data for the relation.
  /// Meaning either an object of the type of the current object.
  /// If this is null then there is no link from the other side.
  SerializableModelFieldDefinition? foreignContainerField;

  final bool nullableRelation;

  /// If true, the foreign field is implicit.
  final bool implicitForeignField;

  ListRelationDefinition({
    String? name,
    required this.fieldName,
    required this.foreignFieldName,
    required this.foreignKeyOwnerIdType,
    this.foreignContainerField,
    required this.nullableRelation,
    this.implicitForeignField = false,
  }) : super(name, false);
}

/// Used for relations for fields that point to another field that holds the id
/// of another object.
class ObjectRelationDefinition extends RelationDefinition {
  /// If this column should have a foreign key,
  /// then [parentTable] contains the referenced table.
  /// For now, the foreign key only references the id column of the
  /// [parentTable].
  String parentTable;

  /// Type of the primary key of the [parentTable]. It is the type that the
  /// generator needs to build attach/detach methods. It is not the type of
  /// the [foreignFieldName].
  TypeDefinition parentTableIdType;

  /// References the field in the current object that points to the foreign table.
  final String fieldName;

  /// References the column in the unresolved [parentTable] that this field should be joined on.
  String foreignFieldName;

  /// References the field in the other object that holds the data for the relation.
  /// Meaning either an object or a list of objects of the type of the current object.
  /// If this is null then there is no link from the other side.
  SerializableModelFieldDefinition? foreignContainerField;

  final bool nullableRelation;

  ObjectRelationDefinition({
    String? name,
    required this.parentTableIdType,
    required this.parentTable,
    required this.fieldName,
    required this.foreignFieldName,
    this.foreignContainerField,
    required bool isForeignKeyOrigin,
    required this.nullableRelation,
  }) : super(name, isForeignKeyOrigin);
}

enum UnresolvableReason {
  relationAlreadyDefinedForField,
}

/// Stores information about a relation that could not be resolved.
/// This is used to report errors to the user in the analyzer.
class UnresolvableObjectRelationDefinition extends RelationDefinition {
  final UnresolvedObjectRelationDefinition objectRelationDefinition;
  final UnresolvableReason reason;

  UnresolvableObjectRelationDefinition(
    this.objectRelationDefinition,
    this.reason,
  ) : super(
        objectRelationDefinition.name,
        objectRelationDefinition.isForeignKeyOrigin,
      );
}

class UnresolvedObjectRelationDefinition extends RelationDefinition {
  /// References the field in the current object that points to the foreign table.
  final String? fieldName;

  /// On delete behavior in the database.
  final ForeignKeyAction onDelete;

  /// On update behavior in the database.
  final ForeignKeyAction onUpdate;

  /// Only used for implicit relations, toggles if the relation id is nullable.
  final bool nullableRelation;

  UnresolvedObjectRelationDefinition({
    String? name,
    required this.fieldName,
    required this.onDelete,
    required this.onUpdate,
    required bool isForeignKeyOrigin,
    this.nullableRelation = false,
  }) : super(name, isForeignKeyOrigin);
}

/// Internal representation of an unresolved [ForeignRelationDefinition].
class UnresolvedForeignRelationDefinition extends RelationDefinition {
  /// References the column in the unresolved [parentTable] that this field should be joined on.
  String foreignFieldName;

  /// On delete behavior in the database.
  final ForeignKeyAction onDelete;

  /// On update behavior in the database.
  final ForeignKeyAction onUpdate;

  UnresolvedForeignRelationDefinition({
    String? name,
    required this.foreignFieldName,
    required this.onDelete,
    required this.onUpdate,
  }) : super(name, true);
}

/// Used for relations for fields that stores the id of another object.
class ForeignRelationDefinition extends RelationDefinition {
  /// If this column should have a foreign key,
  /// then [parentTable] contains the referenced table.
  /// For now, the foreign key only references the id column of the
  /// [parentTable].
  String parentTable;

  /// References the column in the [parentTable] that this field should be joined on.
  String foreignFieldName;

  /// References the field in the current object that hold the data for the relation.
  /// Meaning either an object or a list of objects of the type of the [parentTable].
  /// If this is null then there is no link from this side.
  SerializableModelFieldDefinition? containerField;

  /// References the field on the other side that hold the data for the links the relation.
  /// Meaning either an object or a list of objects of the type of the current object.
  /// If this is null then there is no link from the other side.
  SerializableModelFieldDefinition? foreignContainerField;

  /// On delete behavior in the database.
  final ForeignKeyAction onDelete;

  /// On update behavior in the database.
  final ForeignKeyAction onUpdate;

  ForeignRelationDefinition({
    String? name,
    required this.parentTable,
    required this.foreignFieldName,
    this.containerField,
    this.foreignContainerField,
    this.onDelete = onDeleteDefault,
    this.onUpdate = onUpdateDefault,
  }) : super(name, true);
}

const ForeignKeyAction onDeleteDefault = ForeignKeyAction.noAction;

const ForeignKeyAction onDeleteDefaultOld = ForeignKeyAction.cascade;

const ForeignKeyAction onUpdateDefault = ForeignKeyAction.noAction;

List<SerializableModelFieldDefinition> _fieldsWithTailFieldsLast({
  SerializableModelFieldDefinition? firstField,
  required Iterable<SerializableModelFieldDefinition> inheritedFields,
  required Iterable<SerializableModelFieldDefinition> fields,
}) => [
  ?firstField,
  ...inheritedFields.where((field) => !field.isTail),
  ...fields.where((field) => !field.isTail),
  ...fields.where((field) => field.isTail),
  ...inheritedFields.where((field) => field.isTail),
];
