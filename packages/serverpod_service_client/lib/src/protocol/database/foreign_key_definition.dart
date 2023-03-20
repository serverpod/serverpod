/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: public_member_api_docs
// ignore_for_file: implementation_imports

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:serverpod_client/serverpod_client.dart' as _i1;
import '../protocol.dart' as _i2;

class ForeignKeyDefinition extends _i1.SerializableEntity {
  ForeignKeyDefinition({
    required this.constraintName,
    required this.column,
    required this.referenceTable,
    required this.referenceColumn,
    this.onUpdate,
    this.onDelete,
  });

  factory ForeignKeyDefinition.fromJson(
    Map<String, dynamic> jsonSerialization,
    _i1.SerializationManager serializationManager,
  ) {
    return ForeignKeyDefinition(
      constraintName: serializationManager
          .deserialize<String>(jsonSerialization['constraintName']),
      column:
          serializationManager.deserialize<String>(jsonSerialization['column']),
      referenceTable: serializationManager
          .deserialize<String>(jsonSerialization['referenceTable']),
      referenceColumn: serializationManager
          .deserialize<String>(jsonSerialization['referenceColumn']),
      onUpdate: serializationManager
          .deserialize<_i2.ForeignKeyAction?>(jsonSerialization['onUpdate']),
      onDelete: serializationManager
          .deserialize<_i2.ForeignKeyAction?>(jsonSerialization['onDelete']),
    );
  }

  /// The name of the constraint.
  String constraintName;

  /// The constraint column
  String column;

  /// The table of the reference.
  String referenceTable;

  /// The column of the reference in the [referenceTable].
  String referenceColumn;

  /// The action, when the referred row is updated.
  _i2.ForeignKeyAction? onUpdate;

  /// The action, when the referred row is deleted.
  _i2.ForeignKeyAction? onDelete;

  @override
  Map<String, dynamic> toJson() {
    return {
      'constraintName': constraintName,
      'column': column,
      'referenceTable': referenceTable,
      'referenceColumn': referenceColumn,
      'onUpdate': onUpdate,
      'onDelete': onDelete,
    };
  }
}
