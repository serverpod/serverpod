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
import 'dart:typed_data' as _idt;
import 'package:serverpod/serverpod.dart' as _is;
import 'package:serverpod_test_server/src/generated/protocol.dart' as _igqrxdcj;
import 'test_enum.dart' as _ionapfu9;
import 'test_enum_stringified.dart' as _i7liykk2;
import 'types.dart' as _iwxwszsz;

abstract class TypesSet
    implements _is.SerializableModel, _is.ProtocolSerialization {
  TypesSet._({
    this.anInt,
    this.aBool,
    this.aDouble,
    this.aDateTime,
    this.aString,
    this.aByteData,
    this.aDuration,
    this.aUuid,
    this.aBigInt,
    this.anEnum,
    this.aStringifiedEnum,
    this.anObject,
    this.aMap,
    this.aList,
    this.aRecord,
    this.aNullableRecord,
  });

  factory TypesSet({
    Set<int>? anInt,
    Set<bool>? aBool,
    Set<double>? aDouble,
    Set<DateTime>? aDateTime,
    Set<String>? aString,
    Set<_idt.ByteData>? aByteData,
    Set<Duration>? aDuration,
    Set<_is.UuidValue>? aUuid,
    Set<BigInt>? aBigInt,
    Set<_ionapfu9.TestEnum>? anEnum,
    Set<_i7liykk2.TestEnumStringified>? aStringifiedEnum,
    Set<_iwxwszsz.Types>? anObject,
    Set<Map<String, _iwxwszsz.Types>>? aMap,
    Set<List<_iwxwszsz.Types>>? aList,
    Set<(int,)>? aRecord,
    Set<(int,)?>? aNullableRecord,
  }) = _TypesSetImpl;

  factory TypesSet.fromJson(Map<String, dynamic> jsonSerialization) {
    return TypesSet(
      anInt: jsonSerialization['anInt'] == null
          ? null
          : _igqrxdcj.Protocol().deserialize<Set<int>>(
              jsonSerialization['anInt'],
            ),
      aBool: jsonSerialization['aBool'] == null
          ? null
          : _igqrxdcj.Protocol().deserialize<Set<bool>>(
              jsonSerialization['aBool'],
            ),
      aDouble: jsonSerialization['aDouble'] == null
          ? null
          : _igqrxdcj.Protocol().deserialize<Set<double>>(
              jsonSerialization['aDouble'],
            ),
      aDateTime: jsonSerialization['aDateTime'] == null
          ? null
          : _igqrxdcj.Protocol().deserialize<Set<DateTime>>(
              jsonSerialization['aDateTime'],
            ),
      aString: jsonSerialization['aString'] == null
          ? null
          : _igqrxdcj.Protocol().deserialize<Set<String>>(
              jsonSerialization['aString'],
            ),
      aByteData: jsonSerialization['aByteData'] == null
          ? null
          : _igqrxdcj.Protocol().deserialize<Set<_idt.ByteData>>(
              jsonSerialization['aByteData'],
            ),
      aDuration: jsonSerialization['aDuration'] == null
          ? null
          : _igqrxdcj.Protocol().deserialize<Set<Duration>>(
              jsonSerialization['aDuration'],
            ),
      aUuid: jsonSerialization['aUuid'] == null
          ? null
          : _igqrxdcj.Protocol().deserialize<Set<_is.UuidValue>>(
              jsonSerialization['aUuid'],
            ),
      aBigInt: jsonSerialization['aBigInt'] == null
          ? null
          : _igqrxdcj.Protocol().deserialize<Set<BigInt>>(
              jsonSerialization['aBigInt'],
            ),
      anEnum: jsonSerialization['anEnum'] == null
          ? null
          : _igqrxdcj.Protocol().deserialize<Set<_ionapfu9.TestEnum>>(
              jsonSerialization['anEnum'],
            ),
      aStringifiedEnum: jsonSerialization['aStringifiedEnum'] == null
          ? null
          : _igqrxdcj.Protocol()
                .deserialize<Set<_i7liykk2.TestEnumStringified>>(
                  jsonSerialization['aStringifiedEnum'],
                ),
      anObject: jsonSerialization['anObject'] == null
          ? null
          : _igqrxdcj.Protocol().deserialize<Set<_iwxwszsz.Types>>(
              jsonSerialization['anObject'],
            ),
      aMap: jsonSerialization['aMap'] == null
          ? null
          : _igqrxdcj.Protocol().deserialize<Set<Map<String, _iwxwszsz.Types>>>(
              jsonSerialization['aMap'],
            ),
      aList: jsonSerialization['aList'] == null
          ? null
          : _igqrxdcj.Protocol().deserialize<Set<List<_iwxwszsz.Types>>>(
              jsonSerialization['aList'],
            ),
      aRecord: jsonSerialization['aRecord'] == null
          ? null
          : _igqrxdcj.Protocol().deserialize<Set<(int,)>>(
              jsonSerialization['aRecord'],
            ),
      aNullableRecord: jsonSerialization['aNullableRecord'] == null
          ? null
          : _igqrxdcj.Protocol().deserialize<Set<(int,)?>>(
              jsonSerialization['aNullableRecord'],
            ),
    );
  }

  Set<int>? anInt;

  Set<bool>? aBool;

  Set<double>? aDouble;

  Set<DateTime>? aDateTime;

  Set<String>? aString;

  Set<_idt.ByteData>? aByteData;

  Set<Duration>? aDuration;

  Set<_is.UuidValue>? aUuid;

  Set<BigInt>? aBigInt;

  Set<_ionapfu9.TestEnum>? anEnum;

  Set<_i7liykk2.TestEnumStringified>? aStringifiedEnum;

  Set<_iwxwszsz.Types>? anObject;

  Set<Map<String, _iwxwszsz.Types>>? aMap;

  Set<List<_iwxwszsz.Types>>? aList;

  Set<(int,)>? aRecord;

  Set<(int,)?>? aNullableRecord;

  /// Returns a shallow copy of this [TypesSet]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  TypesSet copyWith({
    Set<int>? anInt,
    Set<bool>? aBool,
    Set<double>? aDouble,
    Set<DateTime>? aDateTime,
    Set<String>? aString,
    Set<_idt.ByteData>? aByteData,
    Set<Duration>? aDuration,
    Set<_is.UuidValue>? aUuid,
    Set<BigInt>? aBigInt,
    Set<_ionapfu9.TestEnum>? anEnum,
    Set<_i7liykk2.TestEnumStringified>? aStringifiedEnum,
    Set<_iwxwszsz.Types>? anObject,
    Set<Map<String, _iwxwszsz.Types>>? aMap,
    Set<List<_iwxwszsz.Types>>? aList,
    Set<(int,)>? aRecord,
    Set<(int,)?>? aNullableRecord,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'TypesSet',
      if (anInt != null) 'anInt': anInt?.toJson(),
      if (aBool != null) 'aBool': aBool?.toJson(),
      if (aDouble != null) 'aDouble': aDouble?.toJson(),
      if (aDateTime != null)
        'aDateTime': aDateTime?.toJson(valueToJson: (v) => v.toJson()),
      if (aString != null) 'aString': aString?.toJson(),
      if (aByteData != null)
        'aByteData': aByteData?.toJson(valueToJson: (v) => v.toJson()),
      if (aDuration != null)
        'aDuration': aDuration?.toJson(valueToJson: (v) => v.toJson()),
      if (aUuid != null) 'aUuid': aUuid?.toJson(valueToJson: (v) => v.toJson()),
      if (aBigInt != null)
        'aBigInt': aBigInt?.toJson(valueToJson: (v) => v.toJson()),
      if (anEnum != null)
        'anEnum': anEnum?.toJson(valueToJson: (v) => v.toJson()),
      if (aStringifiedEnum != null)
        'aStringifiedEnum': aStringifiedEnum?.toJson(
          valueToJson: (v) => v.toJson(),
        ),
      if (anObject != null)
        'anObject': anObject?.toJson(valueToJson: (v) => v.toJson()),
      if (aMap != null)
        'aMap': aMap?.toJson(
          valueToJson: (v) => v.toJson(valueToJson: (v) => v.toJson()),
        ),
      if (aList != null)
        'aList': aList?.toJson(
          valueToJson: (v) => v.toJson(valueToJson: (v) => v.toJson()),
        ),
      if (aRecord != null)
        'aRecord': _igqrxdcj.Protocol().mapContainerToJson(aRecord!),
      if (aNullableRecord != null)
        'aNullableRecord': _igqrxdcj.Protocol().mapContainerToJson(
          aNullableRecord!,
        ),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'TypesSet',
      if (anInt != null) 'anInt': anInt?.toJson(),
      if (aBool != null) 'aBool': aBool?.toJson(),
      if (aDouble != null) 'aDouble': aDouble?.toJson(),
      if (aDateTime != null)
        'aDateTime': aDateTime?.toJson(valueToJson: (v) => v.toJson()),
      if (aString != null) 'aString': aString?.toJson(),
      if (aByteData != null)
        'aByteData': aByteData?.toJson(valueToJson: (v) => v.toJson()),
      if (aDuration != null)
        'aDuration': aDuration?.toJson(valueToJson: (v) => v.toJson()),
      if (aUuid != null) 'aUuid': aUuid?.toJson(valueToJson: (v) => v.toJson()),
      if (aBigInt != null)
        'aBigInt': aBigInt?.toJson(valueToJson: (v) => v.toJson()),
      if (anEnum != null)
        'anEnum': anEnum?.toJson(valueToJson: (v) => v.toJson()),
      if (aStringifiedEnum != null)
        'aStringifiedEnum': aStringifiedEnum?.toJson(
          valueToJson: (v) => v.toJson(),
        ),
      if (anObject != null)
        'anObject': anObject?.toJson(valueToJson: (v) => v.toJsonForProtocol()),
      if (aMap != null)
        'aMap': aMap?.toJson(
          valueToJson: (v) =>
              v.toJson(valueToJson: (v) => v.toJsonForProtocol()),
        ),
      if (aList != null)
        'aList': aList?.toJson(
          valueToJson: (v) =>
              v.toJson(valueToJson: (v) => v.toJsonForProtocol()),
        ),
      if (aRecord != null)
        'aRecord': _igqrxdcj.Protocol().mapContainerToJson(aRecord!),
      if (aNullableRecord != null)
        'aNullableRecord': _igqrxdcj.Protocol().mapContainerToJson(
          aNullableRecord!,
        ),
    };
  }

  @override
  String toString() {
    return _is.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _TypesSetImpl extends TypesSet {
  _TypesSetImpl({
    Set<int>? anInt,
    Set<bool>? aBool,
    Set<double>? aDouble,
    Set<DateTime>? aDateTime,
    Set<String>? aString,
    Set<_idt.ByteData>? aByteData,
    Set<Duration>? aDuration,
    Set<_is.UuidValue>? aUuid,
    Set<BigInt>? aBigInt,
    Set<_ionapfu9.TestEnum>? anEnum,
    Set<_i7liykk2.TestEnumStringified>? aStringifiedEnum,
    Set<_iwxwszsz.Types>? anObject,
    Set<Map<String, _iwxwszsz.Types>>? aMap,
    Set<List<_iwxwszsz.Types>>? aList,
    Set<(int,)>? aRecord,
    Set<(int,)?>? aNullableRecord,
  }) : super._(
         anInt: anInt,
         aBool: aBool,
         aDouble: aDouble,
         aDateTime: aDateTime,
         aString: aString,
         aByteData: aByteData,
         aDuration: aDuration,
         aUuid: aUuid,
         aBigInt: aBigInt,
         anEnum: anEnum,
         aStringifiedEnum: aStringifiedEnum,
         anObject: anObject,
         aMap: aMap,
         aList: aList,
         aRecord: aRecord,
         aNullableRecord: aNullableRecord,
       );

  /// Returns a shallow copy of this [TypesSet]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  @override
  TypesSet copyWith({
    Object? anInt = _Undefined,
    Object? aBool = _Undefined,
    Object? aDouble = _Undefined,
    Object? aDateTime = _Undefined,
    Object? aString = _Undefined,
    Object? aByteData = _Undefined,
    Object? aDuration = _Undefined,
    Object? aUuid = _Undefined,
    Object? aBigInt = _Undefined,
    Object? anEnum = _Undefined,
    Object? aStringifiedEnum = _Undefined,
    Object? anObject = _Undefined,
    Object? aMap = _Undefined,
    Object? aList = _Undefined,
    Object? aRecord = _Undefined,
    Object? aNullableRecord = _Undefined,
  }) {
    return TypesSet(
      anInt: anInt is Set<int>? ? anInt : this.anInt?.map((e0) => e0).toSet(),
      aBool: aBool is Set<bool>? ? aBool : this.aBool?.map((e0) => e0).toSet(),
      aDouble: aDouble is Set<double>?
          ? aDouble
          : this.aDouble?.map((e0) => e0).toSet(),
      aDateTime: aDateTime is Set<DateTime>?
          ? aDateTime
          : this.aDateTime?.map((e0) => e0).toSet(),
      aString: aString is Set<String>?
          ? aString
          : this.aString?.map((e0) => e0).toSet(),
      aByteData: aByteData is Set<_idt.ByteData>?
          ? aByteData
          : this.aByteData?.map((e0) => e0.clone()).toSet(),
      aDuration: aDuration is Set<Duration>?
          ? aDuration
          : this.aDuration?.map((e0) => e0).toSet(),
      aUuid: aUuid is Set<_is.UuidValue>?
          ? aUuid
          : this.aUuid?.map((e0) => e0).toSet(),
      aBigInt: aBigInt is Set<BigInt>?
          ? aBigInt
          : this.aBigInt?.map((e0) => e0).toSet(),
      anEnum: anEnum is Set<_ionapfu9.TestEnum>?
          ? anEnum
          : this.anEnum?.map((e0) => e0).toSet(),
      aStringifiedEnum: aStringifiedEnum is Set<_i7liykk2.TestEnumStringified>?
          ? aStringifiedEnum
          : this.aStringifiedEnum?.map((e0) => e0).toSet(),
      anObject: anObject is Set<_iwxwszsz.Types>?
          ? anObject
          : this.anObject?.map((e0) => e0.copyWith()).toSet(),
      aMap: aMap is Set<Map<String, _iwxwszsz.Types>>?
          ? aMap
          : this.aMap
                ?.map(
                  (e0) => e0.map(
                    (
                      key1,
                      value1,
                    ) => MapEntry(
                      key1,
                      value1.copyWith(),
                    ),
                  ),
                )
                .toSet(),
      aList: aList is Set<List<_iwxwszsz.Types>>?
          ? aList
          : this.aList
                ?.map((e0) => e0.map((e1) => e1.copyWith()).toList())
                .toSet(),
      aRecord: aRecord is Set<(int,)>?
          ? aRecord
          : this.aRecord?.map((e0) => (e0.$1,)).toSet(),
      aNullableRecord: aNullableRecord is Set<(int,)?>?
          ? aNullableRecord
          : this.aNullableRecord
                ?.map((e0) => e0 == null ? null : (e0.$1,))
                .toSet(),
    );
  }
}
