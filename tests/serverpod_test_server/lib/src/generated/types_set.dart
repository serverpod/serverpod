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
    Set<int>? anInt = const _is.$UndefinedSet<int>(),
    Set<bool>? aBool = const _is.$UndefinedSet<bool>(),
    Set<double>? aDouble = const _is.$UndefinedSet<double>(),
    Set<DateTime>? aDateTime = const _is.$UndefinedSet<DateTime>(),
    Set<String>? aString = const _is.$UndefinedSet<String>(),
    Set<_idt.ByteData>? aByteData = const _is.$UndefinedSet<_idt.ByteData>(),
    Set<Duration>? aDuration = const _is.$UndefinedSet<Duration>(),
    Set<_is.UuidValue>? aUuid = const _is.$UndefinedSet<_is.UuidValue>(),
    Set<BigInt>? aBigInt = const _is.$UndefinedSet<BigInt>(),
    Set<_ionapfu9.TestEnum>? anEnum =
        const _is.$UndefinedSet<_ionapfu9.TestEnum>(),
    Set<_i7liykk2.TestEnumStringified>? aStringifiedEnum =
        const _is.$UndefinedSet<_i7liykk2.TestEnumStringified>(),
    Set<_iwxwszsz.Types>? anObject = const _is.$UndefinedSet<_iwxwszsz.Types>(),
    Set<Map<String, _iwxwszsz.Types>>? aMap =
        const _is.$UndefinedSet<Map<String, _iwxwszsz.Types>>(),
    Set<List<_iwxwszsz.Types>>? aList =
        const _is.$UndefinedSet<List<_iwxwszsz.Types>>(),
    Set<(int,)>? aRecord = const _is.$UndefinedSet<(int,)>(),
    Set<(int,)?>? aNullableRecord = const _is.$UndefinedSet<(int,)?>(),
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
    Set<int>? anInt = const _is.$UndefinedSet<int>(),
    Set<bool>? aBool = const _is.$UndefinedSet<bool>(),
    Set<double>? aDouble = const _is.$UndefinedSet<double>(),
    Set<DateTime>? aDateTime = const _is.$UndefinedSet<DateTime>(),
    Set<String>? aString = const _is.$UndefinedSet<String>(),
    Set<_idt.ByteData>? aByteData = const _is.$UndefinedSet<_idt.ByteData>(),
    Set<Duration>? aDuration = const _is.$UndefinedSet<Duration>(),
    Set<_is.UuidValue>? aUuid = const _is.$UndefinedSet<_is.UuidValue>(),
    Set<BigInt>? aBigInt = const _is.$UndefinedSet<BigInt>(),
    Set<_ionapfu9.TestEnum>? anEnum =
        const _is.$UndefinedSet<_ionapfu9.TestEnum>(),
    Set<_i7liykk2.TestEnumStringified>? aStringifiedEnum =
        const _is.$UndefinedSet<_i7liykk2.TestEnumStringified>(),
    Set<_iwxwszsz.Types>? anObject = const _is.$UndefinedSet<_iwxwszsz.Types>(),
    Set<Map<String, _iwxwszsz.Types>>? aMap =
        const _is.$UndefinedSet<Map<String, _iwxwszsz.Types>>(),
    Set<List<_iwxwszsz.Types>>? aList =
        const _is.$UndefinedSet<List<_iwxwszsz.Types>>(),
    Set<(int,)>? aRecord = const _is.$UndefinedSet<(int,)>(),
    Set<(int,)?>? aNullableRecord = const _is.$UndefinedSet<(int,)?>(),
  }) {
    return TypesSet(
      anInt: anInt is _is.UndefinedSentinel
          ? this.anInt?.map((e0) => e0).toSet()
          : anInt,
      aBool: aBool is _is.UndefinedSentinel
          ? this.aBool?.map((e0) => e0).toSet()
          : aBool,
      aDouble: aDouble is _is.UndefinedSentinel
          ? this.aDouble?.map((e0) => e0).toSet()
          : aDouble,
      aDateTime: aDateTime is _is.UndefinedSentinel
          ? this.aDateTime?.map((e0) => e0).toSet()
          : aDateTime,
      aString: aString is _is.UndefinedSentinel
          ? this.aString?.map((e0) => e0).toSet()
          : aString,
      aByteData: aByteData is _is.UndefinedSentinel
          ? this.aByteData?.map((e0) => e0.clone()).toSet()
          : aByteData,
      aDuration: aDuration is _is.UndefinedSentinel
          ? this.aDuration?.map((e0) => e0).toSet()
          : aDuration,
      aUuid: aUuid is _is.UndefinedSentinel
          ? this.aUuid?.map((e0) => e0).toSet()
          : aUuid,
      aBigInt: aBigInt is _is.UndefinedSentinel
          ? this.aBigInt?.map((e0) => e0).toSet()
          : aBigInt,
      anEnum: anEnum is _is.UndefinedSentinel
          ? this.anEnum?.map((e0) => e0).toSet()
          : anEnum,
      aStringifiedEnum: aStringifiedEnum is _is.UndefinedSentinel
          ? this.aStringifiedEnum?.map((e0) => e0).toSet()
          : aStringifiedEnum,
      anObject: anObject is _is.UndefinedSentinel
          ? this.anObject?.map((e0) => e0.copyWith()).toSet()
          : anObject,
      aMap: aMap is _is.UndefinedSentinel
          ? this.aMap
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
                .toSet()
          : aMap,
      aList: aList is _is.UndefinedSentinel
          ? this.aList
                ?.map((e0) => e0.map((e1) => e1.copyWith()).toList())
                .toSet()
          : aList,
      aRecord: aRecord is _is.UndefinedSentinel
          ? this.aRecord?.map((e0) => (e0.$1,)).toSet()
          : aRecord,
      aNullableRecord: aNullableRecord is _is.UndefinedSentinel
          ? this.aNullableRecord
                ?.map((e0) => e0 == null ? null : (e0.$1,))
                .toSet()
          : aNullableRecord,
    );
  }
}
