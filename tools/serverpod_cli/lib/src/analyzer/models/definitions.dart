import 'package:path/path.dart' as p;
import 'package:serverpod_cli/src/generator/types.dart';
import 'package:serverpod_service_client/serverpod_service_client.dart';

/// An abstract representation of a yaml file in the
/// protocol directory.
sealed class SerializableModelDefinition {
  final String fileName;
  final String sourceFileName;
  final String className;
  final List<String> subDirParts;
  final bool serverOnly;
  final TypeDefinition type;

  SerializableModelDefinition({
    required this.fileName,
    required this.sourceFileName,
    required this.className,
    required this.serverOnly,
    required this.type,
    this.subDirParts = const [],
  });

  /// Generate the file reference [String] to this file.
  String fileRef() {
    return p.posix
        // ignore: prefer_interpolation_to_compose_strings
        .joinAll([...subDirParts, '$fileName.dart']);
  }
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

  /// Create a new [ClassDefinition].
  ClassDefinition({
    required super.fileName,
    required super.sourceFileName,
    required super.className,
    required this.fields,
    required super.serverOnly,
    required super.type,
    super.subDirParts,
    this.documentation,
  });

  SerializableModelFieldDefinition? findField(String name) {
    return fields.where((element) => element.name == name).firstOrNull;
  }
}

/// A [ClassDefinition] specialization that represents a model class.
final class ModelClassDefinition extends ClassDefinition {
  /// If set, the name of the table, this class should be stored in, in the
  /// database.
  final String? tableName;

  /// The indexes that should be created for the table [tableName] representing
  /// this class.
  ///
  /// The index over the primary key `id` is not part of this list.
  final List<SerializableModelIndexDefinition> indexes;

  final bool manageMigration;

  /// If set to true the class is sealed.
  final bool isSealed;

  /// If set to a List of [InheritanceDefinitions] the class is a parent class and stores the child classes.
  List<InheritanceDefinition> childClasses;

  /// If set to [InheritanceDefinitions] the class extends another class and stores the [ClassDefinition] of it's parent.
  InheritanceDefinition? extendsClass;

  List<ModelClassDefinition>? _descendantClasses;

  /// Create a new [ModelClassDefinition].
  ModelClassDefinition({
    required super.fileName,
    required super.sourceFileName,
    required super.className,
    required super.fields,
    required super.serverOnly,
    required this.manageMigration,
    required super.type,
    required this.isSealed,
    List<InheritanceDefinition>? childClasses,
    this.extendsClass,
    this.tableName,
    this.indexes = const [],
    super.subDirParts,
    super.documentation,
  }) : childClasses = childClasses ?? <InheritanceDefinition>[];

  /// Returns the `SerializableModelFieldDefinition` of the 'id' field.
  /// If the field is not present, an error is thrown.
  SerializableModelFieldDefinition get idField =>
      findField(defaultPrimaryKeyName)!;

  /// Returns the `ModelClassDefinition` of the parent class.
  /// If there is no parent class, `null` is returned.
  ModelClassDefinition? get parentClass {
    var extendsClass = this.extendsClass;
    if (extendsClass is! ResolvedInheritanceDefinition) return null;

    return extendsClass.classDefinition;
  }

  /// Returns a list of all fields in the parent class.
  /// If there is no parent class, an empty list is returned.
  List<SerializableModelFieldDefinition> get inheritedFields =>
      parentClass?.fieldsIncludingInherited ?? [];

  /// Returns a list of all fields in this class, including inherited fields.
  /// It ensures that the 'id' field, if present, is always included at the beginning of the list.
  List<SerializableModelFieldDefinition> get fieldsIncludingInherited {
    bool hasIdField = fields.any((element) => element.name == 'id');

    return [
      if (hasIdField) fields.firstWhere((element) => element.name == 'id'),
      ...inheritedFields,
      ...fields.where((element) => element.name != 'id'),
    ];
  }

  /// Returns `true` if this class is a parent class or sealed.
  bool get isParentClass => childClasses.isNotEmpty || isSealed;

  /// Returns the top node of the sealed hierarchy. If the class is the top node it returns itself.
  /// If the class is not part of a sealed hierarchy, `null` is returned.
  ClassDefinition? get sealedTopNode {
    var parent = parentClass;
    if (parent != null) {
      var parentsSealedTopNode = parent.sealedTopNode;
      if (parentsSealedTopNode != null) return parentsSealedTopNode;
    }

    if (isSealed) return this;

    return null;
  }

  /// Returns `true` if this class is the top node of a sealed hierarchy.
  bool get isSealedTopNode => sealedTopNode == this;

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
  List<ModelClassDefinition> get descendantClasses {
    return _descendantClasses ??= _computeDescendantClasses();
  }

  List<ModelClassDefinition> _computeDescendantClasses() {
    List<ModelClassDefinition> descendants = [];

    var resolvedChildClasses =
        childClasses.whereType<ResolvedInheritanceDefinition>();

    for (var child in resolvedChildClasses) {
      descendants.add(child.classDefinition);
      descendants.addAll(child.classDefinition.descendantClasses);
    }

    return descendants;
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
    super.documentation,
    super.subDirParts,
  });
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

  /// Indexes that this field is part of.
  List<SerializableModelIndexDefinition> indexes = [];

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
  });

  /// Returns true, if classes should include this field.
  /// [serverCode] specifies if it's a code on the server or client side.
  ///
  /// See also:
  /// - [shouldSerializeField]
  /// - [shouldSerializeFieldForDatabase]
  bool shouldIncludeField(bool serverCode) {
    return scope == ModelFieldScopeDefinition.all ||
        (serverCode && scope == ModelFieldScopeDefinition.serverOnly);
  }

  /// Returns true, if this field should be added to the serialization.
  /// [serverCode] specifies if it's code on the server or client side.
  ///
  /// See also:
  /// - [shouldIncludeField]
  /// - [shouldSerializeFieldForDatabase]
  bool shouldSerializeField(bool serverCode) {
    return scope == ModelFieldScopeDefinition.all;
  }

  /// Returns true, if this field should be added to the serialization for the
  /// database.
  /// [serverCode] specifies if it's code on the server or client side.
  /// This method should only be called for server side code.
  ///
  /// See also:
  /// - [shouldIncludeField]
  /// - [shouldSerializeField]
  bool shouldSerializeFieldForDatabase(bool serverCode) {
    return shouldPersist;
  }

  /// Returns true, if this is serialized field that should be hidden.
  /// [serverCode] specifies if it's code on the server or client side.
  bool hiddenSerializableField(bool serverCode) {
    return serverCode &&
        shouldPersist &&
        scope == ModelFieldScopeDefinition.none;
  }
}

/// The scope of a field.
enum ModelFieldScopeDefinition {
  all,
  serverOnly,
  none,
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
    this.vectorDistanceFunction,
    this.parameters,
  });

  /// Whether the index is of vector type.
  bool get isVectorIndex => VectorIndexType.values.any((e) => e.name == type);
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
  });
}

/// A representation of a single value of a [EnumDefinition].
class ProtocolEnumValueDefinition {
  /// The name of the enums value.
  final String name;

  /// The documentation for this value, line by line.
  final List<String>? documentation;

  /// Create a new [ProtocolEnumValueDefinition].
  ProtocolEnumValueDefinition(this.name, [this.documentation]);
}

abstract class InheritanceDefinition {}

class UnresolvedInheritanceDefinition extends InheritanceDefinition {
  final String className;

  UnresolvedInheritanceDefinition(this.className);
}

class ResolvedInheritanceDefinition extends InheritanceDefinition {
  final ModelClassDefinition classDefinition;

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

const String defaultPrimaryKeyName = 'id';

/// Int for the default primary key type.
const String defaultIntSerial = 'serial';

/// DateTime
const String defaultDateTimeValueNow = 'now';

/// bool
const String defaultBooleanTrue = 'true';
const String defaultBooleanFalse = 'false';

/// UuidValue
const String defaultUuidValueRandom = 'random';
const String defaultUuidValueRandomV7 = 'random_v7';

/// Allowed types for vector indexes.
enum VectorIndexType {
  hnsw,
  ivfflat,
}
