/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: public_member_api_docs
// ignore_for_file: implementation_imports

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:serverpod/serverpod.dart' as _i1;
import '../protocol.dart' as _i2;

/// Represents a foreign key.
class ForeignKeyDefinition extends _i1.SerializableEntity {
  ForeignKeyDefinition({
    required this.constraintName,
    required this.columns,
    required this.referenceTable,
    required this.referenceColumns,
    this.onUpdate,
    this.onDelete,
    this.matchType,
  });

  factory ForeignKeyDefinition.fromJson(
    Map<String, dynamic> jsonSerialization,
    _i1.SerializationManager serializationManager,
  ) {
    return ForeignKeyDefinition(
      constraintName: serializationManager
          .deserialize<String>(jsonSerialization['constraintName']),
      columns: serializationManager
          .deserialize<List<String>>(jsonSerialization['columns']),
      referenceTable: serializationManager
          .deserialize<String>(jsonSerialization['referenceTable']),
      referenceColumns: serializationManager
          .deserialize<List<String>>(jsonSerialization['referenceColumns']),
      onUpdate: serializationManager
          .deserialize<_i2.ForeignKeyAction?>(jsonSerialization['onUpdate']),
      onDelete: serializationManager
          .deserialize<_i2.ForeignKeyAction?>(jsonSerialization['onDelete']),
      matchType: serializationManager.deserialize<_i2.ForeignKeyMatchType?>(
          jsonSerialization['matchType']),
    );
  }

  /// The name of the constraint.
  String constraintName;

  /// The constraint columns
  List<String> columns;

  /// The table of the reference.
  String referenceTable;

  /// The column of the reference in the [referenceTable].
  List<String> referenceColumns;

  /// The action, when the referred row is updated.
  _i2.ForeignKeyAction? onUpdate;

  /// The action, when the referred row is deleted.
  _i2.ForeignKeyAction? onDelete;

  /// The match type of the foreign key
  _i2.ForeignKeyMatchType? matchType;

  @override
  Map<String, dynamic> toJson() {
    return {
      'constraintName': constraintName,
      'columns': columns,
      'referenceTable': referenceTable,
      'referenceColumns': referenceColumns,
      'onUpdate': onUpdate,
      'onDelete': onDelete,
      'matchType': matchType,
    };
  }

  @override
  Map<String, dynamic> allToJson() {
    return {
      'constraintName': constraintName,
      'columns': columns,
      'referenceTable': referenceTable,
      'referenceColumns': referenceColumns,
      'onUpdate': onUpdate,
      'onDelete': onDelete,
      'matchType': matchType,
    };
  }
}
