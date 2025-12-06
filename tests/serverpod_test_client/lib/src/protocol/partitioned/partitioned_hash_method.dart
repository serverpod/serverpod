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

/// Model with partitionBy using HASH method.
abstract class PartitionedHashMethod implements _i1.SerializableModel {
  PartitionedHashMethod._({
    this.id,
    required this.userId,
    required this.data,
  });

  factory PartitionedHashMethod({
    int? id,
    required int userId,
    required String data,
  }) = _PartitionedHashMethodImpl;

  factory PartitionedHashMethod.fromJson(
    Map<String, dynamic> jsonSerialization,
  ) {
    return PartitionedHashMethod(
      id: jsonSerialization['id'] as int?,
      userId: jsonSerialization['userId'] as int,
      data: jsonSerialization['data'] as String,
    );
  }

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
  int? id;

  int userId;

  String data;

  /// Returns a shallow copy of this [PartitionedHashMethod]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  PartitionedHashMethod copyWith({
    int? id,
    int? userId,
    String? data,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'PartitionedHashMethod',
      if (id != null) 'id': id,
      'userId': userId,
      'data': data,
    };
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _PartitionedHashMethodImpl extends PartitionedHashMethod {
  _PartitionedHashMethodImpl({
    int? id,
    required int userId,
    required String data,
  }) : super._(
         id: id,
         userId: userId,
         data: data,
       );

  /// Returns a shallow copy of this [PartitionedHashMethod]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  PartitionedHashMethod copyWith({
    Object? id = _Undefined,
    int? userId,
    String? data,
  }) {
    return PartitionedHashMethod(
      id: id is int? ? id : this.id,
      userId: userId ?? this.userId,
      data: data ?? this.data,
    );
  }
}
