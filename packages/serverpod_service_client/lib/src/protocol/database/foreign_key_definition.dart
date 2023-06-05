/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: public_member_api_docs
// ignore_for_file: implementation_imports

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:serverpod_client/serverpod_client.dart' as _i1;
import '../protocol.dart' as _i2;
import 'package:collection/collection.dart' as _i3;

class _Undefined {}

/// Represents a foreign key.
class ForeignKeyDefinition extends _i1.SerializableEntity {
  ForeignKeyDefinition({
    required this.constraintName,
    required this.columns,
    required this.referenceTable,
    required this.referenceTableSchema,
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
  final String constraintName;

  /// The constraint columns
  final List<String> columns;

  /// The table of the reference.
  final String referenceTable;

  /// The schema of the referenced table.
  final String referenceTableSchema;

  /// The column of the reference in the [referenceTable].
  final List<String> referenceColumns;

  /// The action, when the referred row is updated.
  final _i2.ForeignKeyAction? onUpdate;

  /// The action, when the referred row is deleted.
  final _i2.ForeignKeyAction? onDelete;

  /// The match type of the foreign key
  final _i2.ForeignKeyMatchType? matchType;

  late Function({
    String? constraintName,
    List<String>? columns,
    String? referenceTable,
    String? referenceTableSchema,
    List<String>? referenceColumns,
    _i2.ForeignKeyAction? onUpdate,
    _i2.ForeignKeyAction? onDelete,
    _i2.ForeignKeyMatchType? matchType,
  }) copyWith = _copyWith;

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

  @override
  bool operator ==(dynamic other) {
    return identical(
          this,
          other,
        ) ||
        (other is ForeignKeyDefinition &&
            (identical(
                  other.constraintName,
                  constraintName,
                ) ||
                other.constraintName == constraintName) &&
            (identical(
                  other.referenceTable,
                  referenceTable,
                ) ||
                other.referenceTable == referenceTable) &&
            (identical(
                  other.referenceTableSchema,
                  referenceTableSchema,
                ) ||
                other.referenceTableSchema == referenceTableSchema) &&
            (identical(
                  other.onUpdate,
                  onUpdate,
                ) ||
                other.onUpdate == onUpdate) &&
            (identical(
                  other.onDelete,
                  onDelete,
                ) ||
                other.onDelete == onDelete) &&
            (identical(
                  other.matchType,
                  matchType,
                ) ||
                other.matchType == matchType) &&
            const _i3.DeepCollectionEquality().equals(
              columns,
              other.columns,
            ) &&
            const _i3.DeepCollectionEquality().equals(
              referenceColumns,
              other.referenceColumns,
            ));
  }

  @override
  int get hashCode => Object.hash(
        constraintName,
        referenceTable,
        referenceTableSchema,
        onUpdate,
        onDelete,
        matchType,
        const _i3.DeepCollectionEquality().hash(columns),
        const _i3.DeepCollectionEquality().hash(referenceColumns),
      );

  ForeignKeyDefinition _copyWith({
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
      columns: columns ?? this.columns,
      referenceTable: referenceTable ?? this.referenceTable,
      referenceTableSchema: referenceTableSchema ?? this.referenceTableSchema,
      referenceColumns: referenceColumns ?? this.referenceColumns,
      onUpdate: onUpdate == _Undefined
          ? this.onUpdate
          : (onUpdate as _i2.ForeignKeyAction?),
      onDelete: onDelete == _Undefined
          ? this.onDelete
          : (onDelete as _i2.ForeignKeyAction?),
      matchType: matchType == _Undefined
          ? this.matchType
          : (matchType as _i2.ForeignKeyMatchType?),
    );
  }
}
