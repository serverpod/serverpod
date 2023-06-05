/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: public_member_api_docs
// ignore_for_file: implementation_imports

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:serverpod_client/serverpod_client.dart' as _i1;
import 'protocol.dart' as _i2;
import 'package:collection/collection.dart' as _i3;

abstract class ObjectWithEnum extends _i1.SerializableEntity {
  const ObjectWithEnum._();

  const factory ObjectWithEnum({
    int? id,
    required _i2.TestEnum testEnum,
    _i2.TestEnum? nullableEnum,
    required List<_i2.TestEnum> enumList,
    required List<_i2.TestEnum?> nullableEnumList,
    required List<List<_i2.TestEnum>> enumListList,
  }) = _ObjectWithEnum;

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

  ObjectWithEnum copyWith({
    int? id,
    _i2.TestEnum? testEnum,
    _i2.TestEnum? nullableEnum,
    List<_i2.TestEnum>? enumList,
    List<_i2.TestEnum?>? nullableEnumList,
    List<List<_i2.TestEnum>>? enumListList,
  });

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
  int? get id;
  _i2.TestEnum get testEnum;
  _i2.TestEnum? get nullableEnum;
  List<_i2.TestEnum> get enumList;
  List<_i2.TestEnum?> get nullableEnumList;
  List<List<_i2.TestEnum>> get enumListList;
}

class _Undefined {}

class _ObjectWithEnum extends ObjectWithEnum {
  const _ObjectWithEnum({
    this.id,
    required this.testEnum,
    this.nullableEnum,
    required this.enumList,
    required this.nullableEnumList,
    required this.enumListList,
  }) : super._();

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
  @override
  final int? id;

  @override
  final _i2.TestEnum testEnum;

  @override
  final _i2.TestEnum? nullableEnum;

  @override
  final List<_i2.TestEnum> enumList;

  @override
  final List<_i2.TestEnum?> nullableEnumList;

  @override
  final List<List<_i2.TestEnum>> enumListList;

  @override
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'testEnum': testEnum,
      'nullableEnum': nullableEnum,
      'enumList': enumList,
      'nullableEnumList': nullableEnumList,
      'enumListList': enumListList,
    };
  }

  @override
  bool operator ==(dynamic other) {
    return identical(
          this,
          other,
        ) ||
        (other is ObjectWithEnum &&
            (identical(
                  other.id,
                  id,
                ) ||
                other.id == id) &&
            (identical(
                  other.testEnum,
                  testEnum,
                ) ||
                other.testEnum == testEnum) &&
            (identical(
                  other.nullableEnum,
                  nullableEnum,
                ) ||
                other.nullableEnum == nullableEnum) &&
            const _i3.DeepCollectionEquality().equals(
              enumList,
              other.enumList,
            ) &&
            const _i3.DeepCollectionEquality().equals(
              nullableEnumList,
              other.nullableEnumList,
            ) &&
            const _i3.DeepCollectionEquality().equals(
              enumListList,
              other.enumListList,
            ));
  }

  @override
  int get hashCode => Object.hash(
        id,
        testEnum,
        nullableEnum,
        const _i3.DeepCollectionEquality().hash(enumList),
        const _i3.DeepCollectionEquality().hash(nullableEnumList),
        const _i3.DeepCollectionEquality().hash(enumListList),
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
      id: id == _Undefined ? this.id : (id as int?),
      testEnum: testEnum ?? this.testEnum,
      nullableEnum: nullableEnum == _Undefined
          ? this.nullableEnum
          : (nullableEnum as _i2.TestEnum?),
      enumList: enumList ?? this.enumList,
      nullableEnumList: nullableEnumList ?? this.nullableEnumList,
      enumListList: enumListList ?? this.enumListList,
    );
  }
}
