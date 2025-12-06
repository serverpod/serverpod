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

/// Model with simple partitionBy using default LIST method.
abstract class PartitionedSimple implements _i1.SerializableModel {
  PartitionedSimple._({
    this.id,
    required this.source,
    required this.value,
  });

  factory PartitionedSimple({
    int? id,
    required String source,
    required int value,
  }) = _PartitionedSimpleImpl;

  factory PartitionedSimple.fromJson(Map<String, dynamic> jsonSerialization) {
    return PartitionedSimple(
      id: jsonSerialization['id'] as int?,
      source: jsonSerialization['source'] as String,
      value: jsonSerialization['value'] as int,
    );
  }

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
  int? id;

  String source;

  int value;

  /// Returns a shallow copy of this [PartitionedSimple]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  PartitionedSimple copyWith({
    int? id,
    String? source,
    int? value,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'PartitionedSimple',
      if (id != null) 'id': id,
      'source': source,
      'value': value,
    };
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _PartitionedSimpleImpl extends PartitionedSimple {
  _PartitionedSimpleImpl({
    int? id,
    required String source,
    required int value,
  }) : super._(
         id: id,
         source: source,
         value: value,
       );

  /// Returns a shallow copy of this [PartitionedSimple]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  PartitionedSimple copyWith({
    Object? id = _Undefined,
    String? source,
    int? value,
  }) {
    return PartitionedSimple(
      id: id is int? ? id : this.id,
      source: source ?? this.source,
      value: value ?? this.value,
    );
  }
}
