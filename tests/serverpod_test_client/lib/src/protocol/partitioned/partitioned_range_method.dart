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

/// Model with partitionBy using RANGE method.
abstract class PartitionedRangeMethod implements _i1.SerializableModel {
  PartitionedRangeMethod._({
    this.id,
    required this.createdAt,
    required this.value,
  });

  factory PartitionedRangeMethod({
    int? id,
    required DateTime createdAt,
    required int value,
  }) = _PartitionedRangeMethodImpl;

  factory PartitionedRangeMethod.fromJson(
    Map<String, dynamic> jsonSerialization,
  ) {
    return PartitionedRangeMethod(
      id: jsonSerialization['id'] as int?,
      createdAt: _i1.DateTimeJsonExtension.fromJson(
        jsonSerialization['createdAt'],
      ),
      value: jsonSerialization['value'] as int,
    );
  }

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
  int? id;

  DateTime createdAt;

  int value;

  /// Returns a shallow copy of this [PartitionedRangeMethod]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  PartitionedRangeMethod copyWith({
    int? id,
    DateTime? createdAt,
    int? value,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'PartitionedRangeMethod',
      if (id != null) 'id': id,
      'createdAt': createdAt.toJson(),
      'value': value,
    };
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _PartitionedRangeMethodImpl extends PartitionedRangeMethod {
  _PartitionedRangeMethodImpl({
    int? id,
    required DateTime createdAt,
    required int value,
  }) : super._(
         id: id,
         createdAt: createdAt,
         value: value,
       );

  /// Returns a shallow copy of this [PartitionedRangeMethod]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  PartitionedRangeMethod copyWith({
    Object? id = _Undefined,
    DateTime? createdAt,
    int? value,
  }) {
    return PartitionedRangeMethod(
      id: id is int? ? id : this.id,
      createdAt: createdAt ?? this.createdAt,
      value: value ?? this.value,
    );
  }
}
