import 'package:path/path.dart' as p;

import 'package:serverpod_cli/src/generator/types.dart';

/// An abstract representation of a yaml file in the
/// protocol directory.
abstract class SerializableEntityDefinition {
  final String fileName;
  final String sourceFileName;
  final String className;
  final List<String> subDirParts;
  final bool serverOnly;

  SerializableEntityDefinition({
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
class ClassDefinition extends SerializableEntityDefinition {
  /// If set, the name of the table, this class should be stored in, in the
  /// database.
  final String? tableName;

  /// The fields of this class / exception.
  final List<SerializableEntityFieldDefinition> fields;

  /// The indexes that should be created for the table [tableName] representing
  /// this class.
  ///
  /// The index over the primary key `id` is not part of this list.
  final List<SerializableEntityIndexDefinition>? indexes;

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
    this.indexes,
    super.subDirParts,
    this.documentation,
  });

  SerializableEntityFieldDefinition? findField(String name) {
    return fields
        .cast()
        .firstWhere((element) => element.name == name, orElse: () => null);
  }
}

/// Describes a single field of a [ClassDefinition].
class SerializableEntityFieldDefinition {
  /// The name of the field.
  final String name;

  /// The type of the field.
  TypeDefinition type;

  /// The scope of the field.
  /// It tells us if the field should only be present
  /// in a certain context.
  ///
  /// See also:
  /// - [SerializableEntityFieldScope]
  final SerializableEntityFieldScope scope;

  /// If set the field is a relation to another table. The type of the relation
  /// [IdRelationDefinition], [ObjectRelationDefinition] or [ListRelationDefinition]
  /// determines where and how the relation is stored.
  RelationDefinition? relation;

  /// Returns true, if this field has a relation pointer, meaning that there is
  /// another field in the database that references this field or that this
  /// field is a reference to another field.
  bool get hasRelationPointer =>
      relation != null && relation is! IdRelationDefinition;

  /// The documentation of this field, line by line.
  final List<String>? documentation;

  /// Create a new [SerializableEntityFieldDefinition].
  SerializableEntityFieldDefinition({
    required this.name,
    required this.type,
    required this.scope,
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
    if (serverCode) return true;
    if (scope == SerializableEntityFieldScope.all ||
        scope == SerializableEntityFieldScope.api) {
      return true;
    }
    return false;
  }

  /// Returns true, if this field should be added to the serialization.
  /// [serverCode] specifies if it's code on the server or client side.
  ///
  /// See also:
  /// - [shouldIncludeField]
  /// - [shouldSerializeFieldForDatabase]
  bool shouldSerializeField(bool serverCode) {
    if (scope == SerializableEntityFieldScope.all ||
        scope == SerializableEntityFieldScope.api) {
      return true;
    }
    return false;
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
    assert(serverCode);
    if (scope == SerializableEntityFieldScope.all ||
        scope == SerializableEntityFieldScope.database) {
      return true;
    }
    return false;
  }
}

/// The scope where a field should be present.
enum SerializableEntityFieldScope {
  /// Only include the associated field in the database.
  database,

  /// Only include the associated field in the api.
  api,

  /// Include the associated field everywhere.
  all,
}

/// The definition of an index for a file, that is also stored in the database.
class SerializableEntityIndexDefinition {
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

  /// Create a new [SerializableEntityIndexDefinition].
  SerializableEntityIndexDefinition({
    required this.name,
    required this.type,
    required this.unique,
    required this.fields,
  });
}

/// A representation of a yaml file in the protocol directory defining an enum.
class EnumDefinition extends SerializableEntityDefinition {
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

abstract class RelationDefinition {}

/// Internal representation of an unresolved [ListRelationDefinition].
class UnresolvedListRelationDefinition extends RelationDefinition {}

/// Used for relations for fields of type [List] that has a reference pointer
/// to another Objects field name that holds the id of this object.
class ListRelationDefinition extends RelationDefinition {
  /// References the field in the other object holding the id of this object.
  String referenceFieldName;

  ListRelationDefinition({
    required this.referenceFieldName,
  });
}

/// Used for relations for fields that point to another field that holds the id
/// of another object.
class ObjectRelationDefinition extends RelationDefinition {
  /// If this field is a complex datatype with a parent relation in the database,
  /// then [scalarFieldName] contains the name of the field with the foreign key.
  final String scalarFieldName;

  ObjectRelationDefinition({
    required this.scalarFieldName,
  });
}

/// Internal representation of an unresolved [IdRelationDefinition].
class UnresolvedIdRelationDefinition extends RelationDefinition {
  /// References the column in the unresolved [parentTable] that this field should be joined on.
  String referenceFieldName;

  UnresolvedIdRelationDefinition({
    required this.referenceFieldName,
  });
}

/// Used for relations for fields that stores the id of another object.
class IdRelationDefinition extends RelationDefinition {
  /// If this column should have a foreign key,
  /// then [parentTable] contains the referenced table.
  /// For now, the foreign key only references the id column of the
  /// [parentTable].
  String parentTable;

  /// References the column in the [parentTable] that this field should be joined on.
  String referenceFieldName;

  IdRelationDefinition({
    required this.parentTable,
    required this.referenceFieldName,
  });
}
