/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: implementation_imports
// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: non_constant_identifier_names
// ignore_for_file: public_member_api_docs
// ignore_for_file: type_literal_in_constant_pattern
// ignore_for_file: use_super_parameters

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:serverpod_client/serverpod_client.dart' as _i1;
import '../../long_identifiers/multiple_max_field_name.dart' as _i2;

abstract class RelationToMultipleMaxFieldName implements _i1.SerializableModel {
  RelationToMultipleMaxFieldName._({
    this.id,
    required this.name,
    this.multipleMaxFieldNames,
  });

  factory RelationToMultipleMaxFieldName({
    int? id,
    required String name,
    List<_i2.MultipleMaxFieldName>? multipleMaxFieldNames,
  }) = _RelationToMultipleMaxFieldNameImpl;

  factory RelationToMultipleMaxFieldName.fromJson(
      Map<String, dynamic> jsonSerialization) {
    return RelationToMultipleMaxFieldName(
      id: jsonSerialization['id'] as int?,
      name: jsonSerialization['name'] as String,
      multipleMaxFieldNames: (jsonSerialization['multipleMaxFieldNames']
              as List?)
          ?.map((e) =>
              _i2.MultipleMaxFieldName.fromJson((e as Map<String, dynamic>)))
          .toList(),
    );
  }

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
  int? id;

  String name;

  List<_i2.MultipleMaxFieldName>? multipleMaxFieldNames;

  /// Returns a shallow copy of this [RelationToMultipleMaxFieldName]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  RelationToMultipleMaxFieldName copyWith({
    int? id,
    String? name,
    List<_i2.MultipleMaxFieldName>? multipleMaxFieldNames,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      'name': name,
      if (multipleMaxFieldNames != null)
        'multipleMaxFieldNames':
            multipleMaxFieldNames?.toJson(valueToJson: (v) => v.toJson()),
    };
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _RelationToMultipleMaxFieldNameImpl
    extends RelationToMultipleMaxFieldName {
  _RelationToMultipleMaxFieldNameImpl({
    int? id,
    required String name,
    List<_i2.MultipleMaxFieldName>? multipleMaxFieldNames,
  }) : super._(
          id: id,
          name: name,
          multipleMaxFieldNames: multipleMaxFieldNames,
        );

  /// Returns a shallow copy of this [RelationToMultipleMaxFieldName]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  RelationToMultipleMaxFieldName copyWith({
    Object? id = _Undefined,
    String? name,
    Object? multipleMaxFieldNames = _Undefined,
  }) {
    return RelationToMultipleMaxFieldName(
      id: id is int? ? id : this.id,
      name: name ?? this.name,
      multipleMaxFieldNames:
          multipleMaxFieldNames is List<_i2.MultipleMaxFieldName>?
              ? multipleMaxFieldNames
              : this.multipleMaxFieldNames?.map((e0) => e0.copyWith()).toList(),
    );
  }
}
