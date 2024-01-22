/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: public_member_api_docs
// ignore_for_file: implementation_imports
// ignore_for_file: use_super_parameters
// ignore_for_file: type_literal_in_constant_pattern

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:serverpod_client/serverpod_client.dart' as _i1;
import 'protocol.dart' as _i2;
import 'package:serverpod_serialization/serverpod_serialization.dart';

abstract class ObjectWithEnum extends _i1.SerializableEntity {
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

  factory ObjectWithEnum.fromJson(
    Map<String, dynamic> jsonSerialization,
    _i1.SerializationManager serializationManager,
  ) {
    return ObjectWithEnum(
      id: serializationManager.deserialize<int?>(jsonSerialization['id']),
      testEnum: serializationManager
          .deserialize<_i2.TestEnum>(jsonSerialization['testEnum']),
      nullableEnum: serializationManager
          .deserialize<_i2.TestEnum?>(jsonSerialization['nullableEnum']),
      enumList: serializationManager
          .deserialize<List<_i2.TestEnum>>(jsonSerialization['enumList']),
      nullableEnumList: serializationManager.deserialize<List<_i2.TestEnum?>>(
          jsonSerialization['nullableEnumList']),
      enumListList: serializationManager.deserialize<List<List<_i2.TestEnum>>>(
          jsonSerialization['enumListList']),
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
      enumList: enumList ?? this.enumList.clone(),
      nullableEnumList: nullableEnumList ?? this.nullableEnumList.clone(),
      enumListList: enumListList ?? this.enumListList.clone(),
    );
  }
}
