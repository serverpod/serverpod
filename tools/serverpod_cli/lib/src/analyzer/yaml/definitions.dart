import 'package:path/path.dart' as p;

import 'package:serverpod_cli/src/util/extensions.dart';
import 'package:serverpod_cli/src/generator/types.dart';

/// An abstract representation of a yaml file in the
/// protocol directory.
abstract class ProtocolFileDefinition {
  final String fileName;
  final String className;
  final String? subDir;
  final bool serverOnly;

  ProtocolFileDefinition({
    required this.fileName,
    required this.className,
    required this.serverOnly,
    this.subDir,
  });

  /// Generate the file reference [String] to this file.
  String fileRef() {
    return p.posix
        // ignore: prefer_interpolation_to_compose_strings
        .joinAll(p.split('${(subDir + '/') ?? ''}$fileName.dart'));
  }
}

/// A representation of a yaml file in the
/// protocol directory defining a class or exception.
///
/// See also:
/// - [EnumDefinition]
class ClassDefinition extends ProtocolFileDefinition {
  /// If set, the name of the table, this class should be stored in,
  /// in the database.
  final String? tableName;

  /// The fields of this class / exception.
  final List<FieldDefinition> fields;

  /// The indexes that should be created for the table [tableName]
  /// representing this class.
  /// The index over the primary key `id` is not part of this list.
  final List<IndexDefinition>? indexes;

  /// The documentation of this class, line by line.
  final List<String>? documentation;

  /// `true` if this is an exception and not a class.
  final bool isException;

  /// Create a new [ClassDefinition].
  ClassDefinition({
    required super.fileName,
    required super.className,
    required this.fields,
    required super.serverOnly,
    required this.isException,
    this.tableName,
    this.indexes,
    super.subDir,
    this.documentation,
  });
}

/// Describes a single field of a [ClassDefinition].
class FieldDefinition {
  /// The name of the field.
  final String name;

  /// The type of the field.
  TypeDefinition type;

  /// The scope of the field.
  /// It tells us if the field should only be present
  /// in a certain context.
  ///
  /// See also:
  /// - [FieldScope]
  final FieldScope scope;

  /// If this column should have a foreign key,
  /// then [parentTable] contains the referenced table.
  /// For now, the foreign key only references the id column of the [parentTable].
  final String? parentTable;

  /// The documentation of this field, line by line.
  final List<String>? documentation;

  /// Create a new [FieldDefinition].
  FieldDefinition({
    required this.name,
    required this.type,
    required this.scope,
    this.parentTable,
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
    if (scope == FieldScope.all || scope == FieldScope.api) return true;
    return false;
  }

  /// Returns true, if this field should be added to the serialization.
  /// [serverCode] specifies if it's code on the server or client side.
  ///
  /// See also:
  /// - [shouldIncludeField]
  /// - [shouldSerializeFieldForDatabase]
  bool shouldSerializeField(bool serverCode) {
    if (scope == FieldScope.all || scope == FieldScope.api) return true;
    return false;
  }

  /// Returns true, if this field should be added to the serialization for the database.
  /// [serverCode] specifies if it's code on the server or client side.
  /// This method should only be called for server side code.
  ///
  /// See also:
  /// - [shouldIncludeField]
  /// - [shouldSerializeField]
  bool shouldSerializeFieldForDatabase(bool serverCode) {
    assert(serverCode);
    if (scope == FieldScope.all || scope == FieldScope.database) return true;
    return false;
  }
}

/// The scope where a field should be present.
enum FieldScope {
  /// Only include the associated field
  database,
  api,
  all,
}

/// The definition of an index for a file,
/// that is also stored in the database.
class IndexDefinition {
  /// The name of the index.
  final String name;

  /// The fields this index includes.
  /// ORDER MATTERS!
  final List<String> fields;

  /// The type of this index.
  /// Usually this is `btree`.
  final String type;

  /// Whether the [fields] of this index should be unique.
  final bool unique;

  /// Create a new [IndexDefinition].
  IndexDefinition({
    required this.name,
    required this.type,
    required this.unique,
    required this.fields,
  });
}

/// A representation of a yaml file in the
/// protocol directory defining an enum.
class EnumDefinition extends ProtocolFileDefinition {
  /// All the values of the enum.
  /// This also contains possible documentation for them.
  List<EnumValueDefinition> values;

  /// The documentation for this enum, line by line.
  final List<String>? documentation;

  /// Create a new [EnumDefinition].
  EnumDefinition({
    required super.fileName,
    required super.className,
    required this.values,
    required super.serverOnly,
    super.subDir,
    this.documentation,
  });
}

/// A representation of a single value of a [EnumDefinition].
class EnumValueDefinition {
  /// The name of the enums value.
  final String name;

  /// The documentation for this value, line by line.
  final List<String>? documentation;

  /// Create a new [EnumValueDefinition].
  EnumValueDefinition(this.name, [this.documentation]);
}
