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

abstract class UpsertTestModel implements _i1.SerializableModel {
  UpsertTestModel._({
    this.id,
    required this.code,
    required this.category,
    required this.value,
  });

  factory UpsertTestModel({
    int? id,
    required String code,
    required String category,
    required int value,
  }) = _UpsertTestModelImpl;

  factory UpsertTestModel.fromJson(Map<String, dynamic> jsonSerialization) {
    return UpsertTestModel(
      id: jsonSerialization['id'] as int?,
      code: jsonSerialization['code'] as String,
      category: jsonSerialization['category'] as String,
      value: jsonSerialization['value'] as int,
    );
  }

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
  int? id;

  String code;

  String category;

  int value;

  /// Returns a shallow copy of this [UpsertTestModel]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  UpsertTestModel copyWith({
    int? id,
    String? code,
    String? category,
    int? value,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'UpsertTestModel',
      if (id != null) 'id': id,
      'code': code,
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

class _UpsertTestModelImpl extends UpsertTestModel {
  _UpsertTestModelImpl({
    int? id,
    required String code,
    required String category,
    required int value,
  }) : super._(
         id: id,
         code: code,
         category: category,
         value: value,
       );

  /// Returns a shallow copy of this [UpsertTestModel]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  UpsertTestModel copyWith({
    Object? id = _Undefined,
    String? code,
    String? category,
    int? value,
  }) {
    return UpsertTestModel(
      id: id is int? ? id : this.id,
      code: code ?? this.code,
      category: category ?? this.category,
      value: value ?? this.value,
    );
  }
}
