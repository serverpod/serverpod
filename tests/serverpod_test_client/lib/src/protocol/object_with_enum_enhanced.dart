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
import 'package:serverpod_client/serverpod_client.dart' as _isc;
import 'package:serverpod_test_client/src/protocol/protocol.dart' as _iza9lbb5;
import 'test_enum_enhanced.dart' as _it39smib;
import 'test_enum_enhanced_by_name.dart' as _izw460bh;

abstract class ObjectWithEnumEnhanced
    implements _isc.SerializableModel, _isc.ProtocolSerialization {
  ObjectWithEnumEnhanced._({
    this.id,
    required this.byIndex,
    this.nullableByIndex,
    required this.byIndexList,
    required this.byName,
    this.nullableByName,
    required this.byNameList,
  });

  factory ObjectWithEnumEnhanced({
    int? id,
    required _it39smib.TestEnumEnhanced byIndex,
    _it39smib.TestEnumEnhanced? nullableByIndex,
    required List<_it39smib.TestEnumEnhanced> byIndexList,
    required _izw460bh.TestEnumEnhancedByName byName,
    _izw460bh.TestEnumEnhancedByName? nullableByName,
    required List<_izw460bh.TestEnumEnhancedByName> byNameList,
  }) = _ObjectWithEnumEnhancedImpl;

  factory ObjectWithEnumEnhanced.fromJson(
    Map<String, dynamic> jsonSerialization,
  ) {
    return ObjectWithEnumEnhanced(
      id: jsonSerialization['id'] as int?,
      byIndex: _it39smib.TestEnumEnhanced.fromJson(
        (jsonSerialization['byIndex'] as int),
      ),
      nullableByIndex: jsonSerialization['nullableByIndex'] == null
          ? null
          : _it39smib.TestEnumEnhanced.fromJson(
              (jsonSerialization['nullableByIndex'] as int),
            ),
      byIndexList: _iza9lbb5.Protocol()
          .deserialize<List<_it39smib.TestEnumEnhanced>>(
            jsonSerialization['byIndexList'],
          ),
      byName: _izw460bh.TestEnumEnhancedByName.fromJson(
        (jsonSerialization['byName'] as String),
      ),
      nullableByName: jsonSerialization['nullableByName'] == null
          ? null
          : _izw460bh.TestEnumEnhancedByName.fromJson(
              (jsonSerialization['nullableByName'] as String),
            ),
      byNameList: _iza9lbb5.Protocol()
          .deserialize<List<_izw460bh.TestEnumEnhancedByName>>(
            jsonSerialization['byNameList'],
          ),
    );
  }

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
  int? id;

  _it39smib.TestEnumEnhanced byIndex;

  _it39smib.TestEnumEnhanced? nullableByIndex;

  List<_it39smib.TestEnumEnhanced> byIndexList;

  _izw460bh.TestEnumEnhancedByName byName;

  _izw460bh.TestEnumEnhancedByName? nullableByName;

  List<_izw460bh.TestEnumEnhancedByName> byNameList;

  /// Returns a shallow copy of this [ObjectWithEnumEnhanced]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  ObjectWithEnumEnhanced copyWith({
    int? id,
    _it39smib.TestEnumEnhanced? byIndex,
    _it39smib.TestEnumEnhanced? nullableByIndex,
    List<_it39smib.TestEnumEnhanced>? byIndexList,
    _izw460bh.TestEnumEnhancedByName? byName,
    _izw460bh.TestEnumEnhancedByName? nullableByName,
    List<_izw460bh.TestEnumEnhancedByName>? byNameList,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'ObjectWithEnumEnhanced',
      if (id != null) 'id': id,
      'byIndex': byIndex.toJson(),
      if (nullableByIndex != null) 'nullableByIndex': nullableByIndex?.toJson(),
      'byIndexList': byIndexList.toJson(valueToJson: (v) => v.toJson()),
      'byName': byName.toJson(),
      if (nullableByName != null) 'nullableByName': nullableByName?.toJson(),
      'byNameList': byNameList.toJson(valueToJson: (v) => v.toJson()),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'ObjectWithEnumEnhanced',
      if (id != null) 'id': id,
      'byIndex': byIndex.toJson(),
      if (nullableByIndex != null) 'nullableByIndex': nullableByIndex?.toJson(),
      'byIndexList': byIndexList.toJson(valueToJson: (v) => v.toJson()),
      'byName': byName.toJson(),
      if (nullableByName != null) 'nullableByName': nullableByName?.toJson(),
      'byNameList': byNameList.toJson(valueToJson: (v) => v.toJson()),
    };
  }

  @override
  String toString() {
    return _isc.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _ObjectWithEnumEnhancedImpl extends ObjectWithEnumEnhanced {
  _ObjectWithEnumEnhancedImpl({
    int? id,
    required _it39smib.TestEnumEnhanced byIndex,
    _it39smib.TestEnumEnhanced? nullableByIndex,
    required List<_it39smib.TestEnumEnhanced> byIndexList,
    required _izw460bh.TestEnumEnhancedByName byName,
    _izw460bh.TestEnumEnhancedByName? nullableByName,
    required List<_izw460bh.TestEnumEnhancedByName> byNameList,
  }) : super._(
         id: id,
         byIndex: byIndex,
         nullableByIndex: nullableByIndex,
         byIndexList: byIndexList,
         byName: byName,
         nullableByName: nullableByName,
         byNameList: byNameList,
       );

  /// Returns a shallow copy of this [ObjectWithEnumEnhanced]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  @override
  ObjectWithEnumEnhanced copyWith({
    Object? id = _Undefined,
    _it39smib.TestEnumEnhanced? byIndex,
    Object? nullableByIndex = _Undefined,
    List<_it39smib.TestEnumEnhanced>? byIndexList,
    _izw460bh.TestEnumEnhancedByName? byName,
    Object? nullableByName = _Undefined,
    List<_izw460bh.TestEnumEnhancedByName>? byNameList,
  }) {
    return ObjectWithEnumEnhanced(
      id: id is int? ? id : this.id,
      byIndex: byIndex ?? this.byIndex,
      nullableByIndex: nullableByIndex is _it39smib.TestEnumEnhanced?
          ? nullableByIndex
          : this.nullableByIndex,
      byIndexList: byIndexList ?? this.byIndexList.map((e0) => e0).toList(),
      byName: byName ?? this.byName,
      nullableByName: nullableByName is _izw460bh.TestEnumEnhancedByName?
          ? nullableByName
          : this.nullableByName,
      byNameList: byNameList ?? this.byNameList.map((e0) => e0).toList(),
    );
  }
}
