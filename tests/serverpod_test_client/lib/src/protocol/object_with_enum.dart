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
import 'test_enum.dart' as _i2;

abstract class ObjectWithEnum implements _i1.SerializableModel {
  ObjectWithEnum._({
    this.id,
    required this.testEnum,
    this.nullableEnum,
    required this.enumList,
    required this.nullableEnumList,
    required this.enumListList,
  });

  factory ObjectWithEnum({
    int? id,
    required _i2.TestEnum testEnum,
    _i2.TestEnum? nullableEnum,
    required List<_i2.TestEnum> enumList,
    required List<_i2.TestEnum?> nullableEnumList,
    required List<List<_i2.TestEnum>> enumListList,
  }) = _ObjectWithEnumImpl;

  factory ObjectWithEnum.fromJson(Map<String, dynamic> jsonSerialization) {
    return ObjectWithEnum(
      id: jsonSerialization['id'] as int?,
      testEnum: _i2.TestEnum.fromJson((jsonSerialization['testEnum'] as int)),
      nullableEnum: jsonSerialization['nullableEnum'] == null
          ? null
          : _i2.TestEnum.fromJson((jsonSerialization['nullableEnum'] as int)),
      enumList: (jsonSerialization['enumList'] as List)
          .map((e) => _i2.TestEnum.fromJson((e as int)))
          .toList(),
      nullableEnumList: (jsonSerialization['nullableEnumList'] as List)
          .map((e) => e == null ? null : _i2.TestEnum.fromJson((e as int)))
          .toList(),
      enumListList: (jsonSerialization['enumListList'] as List)
          .map((e) => (e as List)
              .map((e) => _i2.TestEnum.fromJson((e as int)))
              .toList())
          .toList(),
    );
  }

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
  int? id;

  _i2.TestEnum testEnum;

  _i2.TestEnum? nullableEnum;

  List<_i2.TestEnum> enumList;

  List<_i2.TestEnum?> nullableEnumList;

  List<List<_i2.TestEnum>> enumListList;

  /// Returns a shallow copy of this [ObjectWithEnum]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  ObjectWithEnum copyWith({
    int? id,
    _i2.TestEnum? testEnum,
    _i2.TestEnum? nullableEnum,
    List<_i2.TestEnum>? enumList,
    List<_i2.TestEnum?>? nullableEnumList,
    List<List<_i2.TestEnum>>? enumListList,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      'testEnum': testEnum.toJson(),
      if (nullableEnum != null) 'nullableEnum': nullableEnum?.toJson(),
      'enumList': enumList.toJson(valueToJson: (v) => v.toJson()),
      'nullableEnumList':
          nullableEnumList.toJson(valueToJson: (v) => v?.toJson()),
      'enumListList': enumListList.toJson(
          valueToJson: (v) => v.toJson(valueToJson: (v) => v.toJson())),
    };
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _ObjectWithEnumImpl extends ObjectWithEnum {
  _ObjectWithEnumImpl({
    int? id,
    required _i2.TestEnum testEnum,
    _i2.TestEnum? nullableEnum,
    required List<_i2.TestEnum> enumList,
    required List<_i2.TestEnum?> nullableEnumList,
    required List<List<_i2.TestEnum>> enumListList,
  }) : super._(
          id: id,
          testEnum: testEnum,
          nullableEnum: nullableEnum,
          enumList: enumList,
          nullableEnumList: nullableEnumList,
          enumListList: enumListList,
        );

  /// Returns a shallow copy of this [ObjectWithEnum]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  ObjectWithEnum copyWith({
    Object? id = _Undefined,
    _i2.TestEnum? testEnum,
    Object? nullableEnum = _Undefined,
    List<_i2.TestEnum>? enumList,
    List<_i2.TestEnum?>? nullableEnumList,
    List<List<_i2.TestEnum>>? enumListList,
  }) {
    return ObjectWithEnum(
      id: id is int? ? id : this.id,
      testEnum: testEnum ?? this.testEnum,
      nullableEnum:
          nullableEnum is _i2.TestEnum? ? nullableEnum : this.nullableEnum,
      enumList: enumList ?? this.enumList.map((e0) => e0).toList(),
      nullableEnumList:
          nullableEnumList ?? this.nullableEnumList.map((e0) => e0).toList(),
      enumListList: enumListList ??
          this.enumListList.map((e0) => e0.map((e1) => e1).toList()).toList(),
    );
  }
}
