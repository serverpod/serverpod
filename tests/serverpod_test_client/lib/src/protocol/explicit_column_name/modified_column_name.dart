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
import 'package:serverpod_client/serverpod_client.dart' as _i1;

abstract class ModifiedColumnName implements _i1.SerializableModel {
  ModifiedColumnName._({
    this.id,
    required this.originalColumn,
    required this.modifiedColumn,
  });

  factory ModifiedColumnName({
    int? id,
    required String originalColumn,
    required String modifiedColumn,
  }) = _ModifiedColumnNameImpl;

  factory ModifiedColumnName.fromJson(Map<String, dynamic> jsonSerialization) {
    return ModifiedColumnName(
      id: jsonSerialization['id'] as int?,
      originalColumn: jsonSerialization['originalColumn'] as String,
      modifiedColumn: jsonSerialization['modifiedColumn'] as String,
    );
  }

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
  int? id;

  String originalColumn;

  String modifiedColumn;

  /// Returns a shallow copy of this [ModifiedColumnName]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  ModifiedColumnName copyWith({
    int? id,
    String? originalColumn,
    String? modifiedColumn,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'ModifiedColumnName',
      if (id != null) 'id': id,
      'originalColumn': originalColumn,
      'modifiedColumn': modifiedColumn,
    };
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _ModifiedColumnNameImpl extends ModifiedColumnName {
  _ModifiedColumnNameImpl({
    int? id,
    required String originalColumn,
    required String modifiedColumn,
  }) : super._(
         id: id,
         originalColumn: originalColumn,
         modifiedColumn: modifiedColumn,
       );

  /// Returns a shallow copy of this [ModifiedColumnName]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  ModifiedColumnName copyWith({
    Object? id = _Undefined,
    String? originalColumn,
    String? modifiedColumn,
  }) {
    return ModifiedColumnName(
      id: id is int? ? id : this.id,
      originalColumn: originalColumn ?? this.originalColumn,
      modifiedColumn: modifiedColumn ?? this.modifiedColumn,
    );
  }
}
