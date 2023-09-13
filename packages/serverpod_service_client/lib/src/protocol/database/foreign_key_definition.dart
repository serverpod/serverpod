/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: public_member_api_docs
// ignore_for_file: implementation_imports

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:serverpod_client/serverpod_client.dart' as _i1;
import '../protocol.dart' as _i2;

/// Represents a foreign key.
abstract class ForeignKeyDefinition extends _i1.SerializableEntity {
  ForeignKeyDefinition._({
    required this.constraintName,
    required this.columns,
    required this.referenceTable,
    required this.referenceTableSchema,
    required this.referenceColumns,
    this.onUpdate,
    this.onDelete,
    this.matchType,
  });

  factory ForeignKeyDefinition({
    required String constraintName,
    required List<String> columns,
    required String referenceTable,
    required String referenceTableSchema,
    required List<String> referenceColumns,
    _i2.ForeignKeyAction? onUpdate,
    _i2.ForeignKeyAction? onDelete,
    _i2.ForeignKeyMatchType? matchType,
  }) = _ForeignKeyDefinitionImpl;

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
      referenceTableSchema: serializationManager
          .deserialize<String>(jsonSerialization['referenceTableSchema']),
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

  /// The schema of the referenced table.
  String referenceTableSchema;

  /// The column of the reference in the [referenceTable].
  List<String> referenceColumns;

  /// The action, when the referred row is updated.
  _i2.ForeignKeyAction? onUpdate;

  /// The action, when the referred row is deleted.
  _i2.ForeignKeyAction? onDelete;

  /// The match type of the foreign key
  _i2.ForeignKeyMatchType? matchType;

  ForeignKeyDefinition copyWith({
    String? constraintName,
    List<String>? columns,
    String? referenceTable,
    String? referenceTableSchema,
    List<String>? referenceColumns,
    _i2.ForeignKeyAction? onUpdate,
    _i2.ForeignKeyAction? onDelete,
    _i2.ForeignKeyMatchType? matchType,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      'constraintName': constraintName,
      'columns': columns,
      'referenceTable': referenceTable,
      'referenceTableSchema': referenceTableSchema,
      'referenceColumns': referenceColumns,
      'onUpdate': onUpdate,
      'onDelete': onDelete,
      'matchType': matchType,
    };
  }
}

class _Undefined {}

class _ForeignKeyDefinitionImpl extends ForeignKeyDefinition {
  _ForeignKeyDefinitionImpl({
    required String constraintName,
    required List<String> columns,
    required String referenceTable,
    required String referenceTableSchema,
    required List<String> referenceColumns,
    _i2.ForeignKeyAction? onUpdate,
    _i2.ForeignKeyAction? onDelete,
    _i2.ForeignKeyMatchType? matchType,
  }) : super._(
          constraintName: constraintName,
          columns: columns,
          referenceTable: referenceTable,
          referenceTableSchema: referenceTableSchema,
          referenceColumns: referenceColumns,
          onUpdate: onUpdate,
          onDelete: onDelete,
          matchType: matchType,
        );

  @override
  ForeignKeyDefinition copyWith({
    String? constraintName,
    List<String>? columns,
    String? referenceTable,
    String? referenceTableSchema,
    List<String>? referenceColumns,
    Object? onUpdate = _Undefined,
    Object? onDelete = _Undefined,
    Object? matchType = _Undefined,
  }) {
    return ForeignKeyDefinition(
      constraintName: constraintName ?? this.constraintName,
      columns: columns ?? this.columns.clone(),
      referenceTable: referenceTable ?? this.referenceTable,
      referenceTableSchema: referenceTableSchema ?? this.referenceTableSchema,
      referenceColumns: referenceColumns ?? this.referenceColumns.clone(),
      onUpdate: onUpdate is _i2.ForeignKeyAction? ? onUpdate : this.onUpdate,
      onDelete: onDelete is _i2.ForeignKeyAction? ? onDelete : this.onDelete,
      matchType:
          matchType is _i2.ForeignKeyMatchType? ? matchType : this.matchType,
    );
  }
}
