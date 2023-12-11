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

  SerializableModelDefinition({
    required this.fileName,
    required this.sourceFileName,
    required this.className,
    required this.serverOnly,
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
class ClassDefinition extends SerializableModelDefinition {
  /// If set, the name of the table, this class should be stored in, in the
  /// database.
  final String? tableName;

  /// The fields of this class / exception.
  List<SerializableModelFieldDefinition> fields;

  /// The indexes that should be created for the table [tableName] representing
  /// this class.
  ///
  /// The index over the primary key `id` is not part of this list.
  final List<SerializableModelIndexDefinition> indexes;

  /// The documentation of this class, line by line.
  final List<String>? documentation;

  /// `true` if this is an exception and not a class.
  final bool isException;

  /// Create a new [ClassDefinition].
  ClassDefinition({
    required super.fileName,
    required super.sourceFileName,
    required super.className,
    required this.fields,
    required super.serverOnly,
    required this.isException,
    this.tableName,
    this.indexes = const [],
    super.subDirParts,
    this.documentation,
  });

  SerializableModelFieldDefinition? findField(String name) {
    return fields
        .cast()
        .firstWhere((element) => element.name == name, orElse: () => null);
  }
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

  /// Create a new [SerializableModelIndexDefinition].
  SerializableModelIndexDefinition({
    required this.name,
    required this.type,
    required this.unique,
    required this.fields,
  });
}

/// A representation of a yaml file in the protocol directory defining an enum.
class EnumDefinition extends SerializableModelDefinition {
  /// The type of serialization this enum should use.
  final EnumSerialization serialized;

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
    required this.values,
    required super.serverOnly,
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

abstract class RelationDefinition {
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
  String fieldName;

  /// References the field in the other object holding the id of this object.
  String foreignFieldName;

  final bool nullableRelation;

  /// If true, the foreign field is implicit.
  final bool implicitForeignField;

  ListRelationDefinition({
    String? name,
    required this.fieldName,
    required this.foreignFieldName,
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

  /// References the field in the current object that points to the foreign table.
  final String fieldName;

  /// References the column in the unresolved [parentTable] that this field should be joined on.
  String foreignFieldName;

  final bool nullableRelation;

  ObjectRelationDefinition({
    String? name,
    required this.parentTable,
    required this.fieldName,
    required this.foreignFieldName,
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

  /// On delete behavior in the database.
  final ForeignKeyAction onDelete;

  /// On update behavior in the database.
  final ForeignKeyAction onUpdate;

  ForeignRelationDefinition({
    String? name,
    required this.parentTable,
    required this.foreignFieldName,
    this.onDelete = onDeleteDefault,
    this.onUpdate = onUpdateDefault,
  }) : super(name, true);
}

const ForeignKeyAction onDeleteDefault = ForeignKeyAction.noAction;

const ForeignKeyAction onDeleteDefaultOld = ForeignKeyAction.cascade;

const ForeignKeyAction onUpdateDefault = ForeignKeyAction.noAction;

const String defaultPrimaryKeyName = 'id';
