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

/// Model with partitionBy using multiple columns.
abstract class PartitionedMultiColumn implements _i1.SerializableModel {
  PartitionedMultiColumn._({
    this.id,
    required this.source,
    required this.category,
    required this.value,
  });

  factory PartitionedMultiColumn({
    int? id,
    required String source,
    required String category,
    required int value,
  }) = _PartitionedMultiColumnImpl;

  factory PartitionedMultiColumn.fromJson(
    Map<String, dynamic> jsonSerialization,
  ) {
    return PartitionedMultiColumn(
      id: jsonSerialization['id'] as int?,
      source: jsonSerialization['source'] as String,
      category: jsonSerialization['category'] as String,
      value: jsonSerialization['value'] as int,
    );
  }

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
  int? id;

  String source;

  String category;

  int value;

  /// Returns a shallow copy of this [PartitionedMultiColumn]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  PartitionedMultiColumn copyWith({
    int? id,
    String? source,
    String? category,
    int? value,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'PartitionedMultiColumn',
      if (id != null) 'id': id,
      'source': source,
      'category': category,
      'value': value,
    };
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _PartitionedMultiColumnImpl extends PartitionedMultiColumn {
  _PartitionedMultiColumnImpl({
    int? id,
    required String source,
    required String category,
    required int value,
  }) : super._(
         id: id,
         source: source,
         category: category,
         value: value,
       );

  /// Returns a shallow copy of this [PartitionedMultiColumn]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  PartitionedMultiColumn copyWith({
    Object? id = _Undefined,
    String? source,
    String? category,
    int? value,
  }) {
    return PartitionedMultiColumn(
      id: id is int? ? id : this.id,
      source: source ?? this.source,
      category: category ?? this.category,
      value: value ?? this.value,
    );
  }
}
