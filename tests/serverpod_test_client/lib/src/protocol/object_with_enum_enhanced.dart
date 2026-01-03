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
import 'test_enum_enhanced.dart' as _i2;
import 'package:serverpod_test_client/src/protocol/protocol.dart' as _i3;

abstract class ObjectWithEnumEnhanced implements _i1.SerializableModel {
  ObjectWithEnumEnhanced._({
    this.id,
    required this.testEnumEnhanced,
    this.nullableEnumEnhanced,
    required this.enumEnhancedList,
  });

  factory ObjectWithEnumEnhanced({
    int? id,
    required _i2.TestEnumEnhanced testEnumEnhanced,
    _i2.TestEnumEnhanced? nullableEnumEnhanced,
    required List<_i2.TestEnumEnhanced> enumEnhancedList,
  }) = _ObjectWithEnumEnhancedImpl;

  factory ObjectWithEnumEnhanced.fromJson(
    Map<String, dynamic> jsonSerialization,
  ) {
    return ObjectWithEnumEnhanced(
      id: jsonSerialization['id'] as int?,
      testEnumEnhanced: _i2.TestEnumEnhanced.fromJson(
        (jsonSerialization['testEnumEnhanced'] as int),
      ),
      nullableEnumEnhanced: jsonSerialization['nullableEnumEnhanced'] == null
          ? null
          : _i2.TestEnumEnhanced.fromJson(
              (jsonSerialization['nullableEnumEnhanced'] as int),
            ),
      enumEnhancedList: _i3.Protocol().deserialize<List<_i2.TestEnumEnhanced>>(
        jsonSerialization['enumEnhancedList'],
      ),
    );
  }

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
  int? id;

  _i2.TestEnumEnhanced testEnumEnhanced;

  _i2.TestEnumEnhanced? nullableEnumEnhanced;

  List<_i2.TestEnumEnhanced> enumEnhancedList;

  /// Returns a shallow copy of this [ObjectWithEnumEnhanced]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  ObjectWithEnumEnhanced copyWith({
    int? id,
    _i2.TestEnumEnhanced? testEnumEnhanced,
    _i2.TestEnumEnhanced? nullableEnumEnhanced,
    List<_i2.TestEnumEnhanced>? enumEnhancedList,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'ObjectWithEnumEnhanced',
      if (id != null) 'id': id,
      'testEnumEnhanced': testEnumEnhanced.toJson(),
      if (nullableEnumEnhanced != null)
        'nullableEnumEnhanced': nullableEnumEnhanced?.toJson(),
      'enumEnhancedList': enumEnhancedList.toJson(
        valueToJson: (v) => v.toJson(),
      ),
    };
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _ObjectWithEnumEnhancedImpl extends ObjectWithEnumEnhanced {
  _ObjectWithEnumEnhancedImpl({
    int? id,
    required _i2.TestEnumEnhanced testEnumEnhanced,
    _i2.TestEnumEnhanced? nullableEnumEnhanced,
    required List<_i2.TestEnumEnhanced> enumEnhancedList,
  }) : super._(
         id: id,
         testEnumEnhanced: testEnumEnhanced,
         nullableEnumEnhanced: nullableEnumEnhanced,
         enumEnhancedList: enumEnhancedList,
       );

  /// Returns a shallow copy of this [ObjectWithEnumEnhanced]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  ObjectWithEnumEnhanced copyWith({
    Object? id = _Undefined,
    _i2.TestEnumEnhanced? testEnumEnhanced,
    Object? nullableEnumEnhanced = _Undefined,
    List<_i2.TestEnumEnhanced>? enumEnhancedList,
  }) {
    return ObjectWithEnumEnhanced(
      id: id is int? ? id : this.id,
      testEnumEnhanced: testEnumEnhanced ?? this.testEnumEnhanced,
      nullableEnumEnhanced: nullableEnumEnhanced is _i2.TestEnumEnhanced?
          ? nullableEnumEnhanced
          : this.nullableEnumEnhanced,
      enumEnhancedList:
          enumEnhancedList ?? this.enumEnhancedList.map((e0) => e0).toList(),
    );
  }
}
