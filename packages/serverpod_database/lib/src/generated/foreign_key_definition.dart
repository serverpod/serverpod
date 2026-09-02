/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: implementation_imports
// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: non_constant_identifier_names
// ignore_for_file: public_member_api_docs
// ignore_for_file: type_literal_in_constant_pattern
// ignore_for_file: use_super_parameters
// ignore_for_file: invalid_use_of_internal_member

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:serverpod_database/serverpod_database.dart' as _isd;
import 'package:serverpod_serialization/serverpod_serialization.dart' as _iss;

/// Represents a foreign key.
abstract class ForeignKeyDefinition
    implements _iss.SerializableModel, _iss.ProtocolSerialization {
  ForeignKeyDefinition._({
    required this.constraintName,
    required this.columns,
    required this.referenceTable,
    required this.referenceTableSchema,
    required this.referenceColumns,
    this.onUpdate,
    this.onDelete,
    this.matchType,
    this.deferrable,
  });

  factory ForeignKeyDefinition({
    required String constraintName,
    required List<String> columns,
    required String referenceTable,
    required String referenceTableSchema,
    required List<String> referenceColumns,
    _isd.ForeignKeyAction? onUpdate,
    _isd.ForeignKeyAction? onDelete,
    _isd.ForeignKeyMatchType? matchType,
    _isd.DeferrableConstraint? deferrable,
  }) = _ForeignKeyDefinitionImpl;

  factory ForeignKeyDefinition.fromJson(
    Map<String, dynamic> jsonSerialization,
  ) {
    return ForeignKeyDefinition(
      constraintName: jsonSerialization['constraintName'] as String,
      columns: _isd.Protocol().deserialize<List<String>>(
        jsonSerialization['columns'],
      ),
      referenceTable: jsonSerialization['referenceTable'] as String,
      referenceTableSchema: jsonSerialization['referenceTableSchema'] as String,
      referenceColumns: _isd.Protocol().deserialize<List<String>>(
        jsonSerialization['referenceColumns'],
      ),
      onUpdate: jsonSerialization['onUpdate'] == null
          ? null
          : _isd.ForeignKeyAction.fromJson(
              (jsonSerialization['onUpdate'] as int),
            ),
      onDelete: jsonSerialization['onDelete'] == null
          ? null
          : _isd.ForeignKeyAction.fromJson(
              (jsonSerialization['onDelete'] as int),
            ),
      matchType: jsonSerialization['matchType'] == null
          ? null
          : _isd.ForeignKeyMatchType.fromJson(
              (jsonSerialization['matchType'] as int),
            ),
      deferrable: jsonSerialization['deferrable'] == null
          ? null
          : _isd.DeferrableConstraint.fromJson(
              (jsonSerialization['deferrable'] as String),
            ),
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
  _isd.ForeignKeyAction? onUpdate;

  /// The action, when the referred row is deleted.
  _isd.ForeignKeyAction? onDelete;

  /// The match type of the foreign key
  _isd.ForeignKeyMatchType? matchType;

  /// Whether the constraint is deferrable and when it is checked by default.
  /// Null means the constraint is not deferrable.
  _isd.DeferrableConstraint? deferrable;

  /// Returns a shallow copy of this [ForeignKeyDefinition]
  /// with some or all fields replaced by the given arguments.
  @_iss.useResult
  ForeignKeyDefinition copyWith({
    String? constraintName,
    List<String>? columns,
    String? referenceTable,
    String? referenceTableSchema,
    List<String>? referenceColumns,
    _isd.ForeignKeyAction? onUpdate,
    _isd.ForeignKeyAction? onDelete,
    _isd.ForeignKeyMatchType? matchType,
    _isd.DeferrableConstraint? deferrable,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'serverpod.ForeignKeyDefinition',
      'constraintName': constraintName,
      'columns': columns.toJson(),
      'referenceTable': referenceTable,
      'referenceTableSchema': referenceTableSchema,
      'referenceColumns': referenceColumns.toJson(),
      if (onUpdate != null) 'onUpdate': onUpdate?.toJson(),
      if (onDelete != null) 'onDelete': onDelete?.toJson(),
      if (matchType != null) 'matchType': matchType?.toJson(),
      if (deferrable != null) 'deferrable': deferrable?.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'serverpod.ForeignKeyDefinition',
      'constraintName': constraintName,
      'columns': columns.toJson(),
      'referenceTable': referenceTable,
      'referenceTableSchema': referenceTableSchema,
      'referenceColumns': referenceColumns.toJson(),
      if (onUpdate != null) 'onUpdate': onUpdate?.toJson(),
      if (onDelete != null) 'onDelete': onDelete?.toJson(),
      if (matchType != null) 'matchType': matchType?.toJson(),
      if (deferrable != null) 'deferrable': deferrable?.toJson(),
    };
  }

  @override
  String toString() {
    return _iss.SerializationManager.encode(this);
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
    _isd.ForeignKeyAction? onUpdate,
    _isd.ForeignKeyAction? onDelete,
    _isd.ForeignKeyMatchType? matchType,
    _isd.DeferrableConstraint? deferrable,
  }) : super._(
         constraintName: constraintName,
         columns: columns,
         referenceTable: referenceTable,
         referenceTableSchema: referenceTableSchema,
         referenceColumns: referenceColumns,
         onUpdate: onUpdate,
         onDelete: onDelete,
         matchType: matchType,
         deferrable: deferrable,
       );

  /// Returns a shallow copy of this [ForeignKeyDefinition]
  /// with some or all fields replaced by the given arguments.
  @_iss.useResult
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
    Object? deferrable = _Undefined,
  }) {
    return ForeignKeyDefinition(
      constraintName: constraintName ?? this.constraintName,
      columns: columns ?? this.columns.map((e0) => e0).toList(),
      referenceTable: referenceTable ?? this.referenceTable,
      referenceTableSchema: referenceTableSchema ?? this.referenceTableSchema,
      referenceColumns:
          referenceColumns ?? this.referenceColumns.map((e0) => e0).toList(),
      onUpdate: onUpdate is _isd.ForeignKeyAction? ? onUpdate : this.onUpdate,
      onDelete: onDelete is _isd.ForeignKeyAction? ? onDelete : this.onDelete,
      matchType: matchType is _isd.ForeignKeyMatchType?
          ? matchType
          : this.matchType,
      deferrable: deferrable is _isd.DeferrableConstraint?
          ? deferrable
          : this.deferrable,
    );
  }
}
