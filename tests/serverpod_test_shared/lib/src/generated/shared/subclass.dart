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
import 'package:serverpod_test_shared/serverpod_test_shared.dart' as _i1;
import 'package:serverpod_serialization/serverpod_serialization.dart' as _i2;

abstract class SharedSubclass extends _i1.SharedModel
    implements _i2.SerializableModel {
  SharedSubclass._({
    super.id,
    required super.name,
    super.data,
    super.createdAt,
    required this.sharedSubclassField,
    required this.sharedEnumField,
  });

  factory SharedSubclass({
    _i2.UuidValue? id,
    required String name,
    int? data,
    DateTime? createdAt,
    required String sharedSubclassField,
    required _i1.SharedEnum sharedEnumField,
  }) = _SharedSubclassImpl;

  factory SharedSubclass.fromJson(Map<String, dynamic> jsonSerialization) {
    return SharedSubclass(
      id: jsonSerialization['id'] == null
          ? null
          : _i2.UuidValueJsonExtension.fromJson(jsonSerialization['id']),
      name: jsonSerialization['name'] as String,
      data: jsonSerialization['data'] as int?,
      createdAt: jsonSerialization['createdAt'] == null
          ? null
          : _i2.DateTimeJsonExtension.fromJson(jsonSerialization['createdAt']),
      sharedSubclassField: jsonSerialization['sharedSubclassField'] as String,
      sharedEnumField: _i1.SharedEnum.fromJson(
        (jsonSerialization['sharedEnumField'] as String),
      ),
    );
  }

  String sharedSubclassField;

  _i1.SharedEnum sharedEnumField;

  /// Returns a shallow copy of this [SharedSubclass]
  /// with some or all fields replaced by the given arguments.
  @override
  @_i2.useResult
  SharedSubclass copyWith({
    _i2.UuidValue? id,
    String? name,
    Object? data,
    DateTime? createdAt,
    String? sharedSubclassField,
    _i1.SharedEnum? sharedEnumField,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'SharedSubclass',
      'id': id.toJson(),
      'name': name,
      if (data != null) 'data': data,
      'createdAt': createdAt.toJson(),
      'sharedSubclassField': sharedSubclassField,
      'sharedEnumField': sharedEnumField.toJson(),
    };
  }

  @override
  String toString() {
    return _i2.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _SharedSubclassImpl extends SharedSubclass {
  _SharedSubclassImpl({
    _i2.UuidValue? id,
    required String name,
    int? data,
    DateTime? createdAt,
    required String sharedSubclassField,
    required _i1.SharedEnum sharedEnumField,
  }) : super._(
         id: id,
         name: name,
         data: data,
         createdAt: createdAt,
         sharedSubclassField: sharedSubclassField,
         sharedEnumField: sharedEnumField,
       );

  /// Returns a shallow copy of this [SharedSubclass]
  /// with some or all fields replaced by the given arguments.
  @_i2.useResult
  @override
  SharedSubclass copyWith({
    _i2.UuidValue? id,
    String? name,
    Object? data = _Undefined,
    DateTime? createdAt,
    String? sharedSubclassField,
    _i1.SharedEnum? sharedEnumField,
  }) {
    return SharedSubclass(
      id: id ?? this.id,
      name: name ?? this.name,
      data: data is int? ? data : this.data,
      createdAt: createdAt ?? this.createdAt,
      sharedSubclassField: sharedSubclassField ?? this.sharedSubclassField,
      sharedEnumField: sharedEnumField ?? this.sharedEnumField,
    );
  }
}
