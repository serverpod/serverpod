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

/// Model with partitionBy using explicit LIST method.
abstract class PartitionedListMethod implements _i1.SerializableModel {
  PartitionedListMethod._({
    this.id,
    required this.category,
    required this.name,
    required this.value,
  });

  factory PartitionedListMethod({
    int? id,
    required String category,
    required String name,
    required int value,
  }) = _PartitionedListMethodImpl;

  factory PartitionedListMethod.fromJson(
    Map<String, dynamic> jsonSerialization,
  ) {
    return PartitionedListMethod(
      id: jsonSerialization['id'] as int?,
      category: jsonSerialization['category'] as String,
      name: jsonSerialization['name'] as String,
      value: jsonSerialization['value'] as int,
    );
  }

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
  int? id;

  String category;

  String name;

  int value;

  /// Returns a shallow copy of this [PartitionedListMethod]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  PartitionedListMethod copyWith({
    int? id,
    String? category,
    String? name,
    int? value,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'PartitionedListMethod',
      if (id != null) 'id': id,
      'category': category,
      'name': name,
      'value': value,
    };
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _PartitionedListMethodImpl extends PartitionedListMethod {
  _PartitionedListMethodImpl({
    int? id,
    required String category,
    required String name,
    required int value,
  }) : super._(
         id: id,
         category: category,
         name: name,
         value: value,
       );

  /// Returns a shallow copy of this [PartitionedListMethod]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  PartitionedListMethod copyWith({
    Object? id = _Undefined,
    String? category,
    String? name,
    int? value,
  }) {
    return PartitionedListMethod(
      id: id is int? ? id : this.id,
      category: category ?? this.category,
      name: name ?? this.name,
      value: value ?? this.value,
    );
  }
}
