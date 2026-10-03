/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: implementation_imports
// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: non_constant_identifier_names
// ignore_for_file: public_member_api_docs
// ignore_for_file: type_literal_in_constant_pattern
// ignore_for_file: use_super_parameters
// ignore_for_file: invalid_use_of_internal_member
// ignore_for_file: depend_on_referenced_packages

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'dart:typed_data' as _idt;
import 'package:serverpod/serverpod.dart' as _is;
import 'package:serverpod_serialization/undefined_sentinel.dart' as _issu;
import 'package:serverpod_test_server/src/generated/protocol.dart' as _igqrxdcj;
import 'test_enum.dart' as _ionapfu9;
import 'test_enum_stringified.dart' as _i7liykk2;
import 'types.dart' as _iwxwszsz;

abstract class TypesList
    implements _is.SerializableModel, _is.ProtocolSerialization {
  TypesList._({
    this.anInt,
    this.aBool,
    this.aDouble,
    this.aDateTime,
    this.aString,
    this.aByteData,
    this.aDuration,
    this.aUuid,
    this.aUri,
    this.aBigInt,
    this.anEnum,
    this.aStringifiedEnum,
    this.anObject,
    this.aMap,
    this.aList,
    this.aRecord,
    this.aNullableRecord,
    this.anEnumRecord,
    this.anEnum2Record,
  });

  factory TypesList({
    List<int>? anInt,
    List<bool>? aBool,
    List<double>? aDouble,
    List<DateTime>? aDateTime,
    List<String>? aString,
    List<_idt.ByteData>? aByteData,
    List<Duration>? aDuration,
    List<_is.UuidValue>? aUuid,
    List<Uri>? aUri,
    List<BigInt>? aBigInt,
    List<_ionapfu9.TestEnum>? anEnum,
    List<_i7liykk2.TestEnumStringified>? aStringifiedEnum,
    List<_iwxwszsz.Types>? anObject,
    List<Map<String, _iwxwszsz.Types>>? aMap,
    List<List<_iwxwszsz.Types>>? aList,
    List<(int,)>? aRecord,
    List<(int,)?>? aNullableRecord,
    List<(_ionapfu9.TestEnum,)>? anEnumRecord,
    List<(_i7liykk2.TestEnumStringified,)>? anEnum2Record,
  }) = _TypesListImpl;

  factory TypesList.fromJson(Map<String, dynamic> jsonSerialization) {
    return TypesList(
      anInt: jsonSerialization['anInt'] == null
          ? null
          : _igqrxdcj.Protocol().deserialize<List<int>>(
              jsonSerialization['anInt'],
            ),
      aBool: jsonSerialization['aBool'] == null
          ? null
          : _igqrxdcj.Protocol().deserialize<List<bool>>(
              jsonSerialization['aBool'],
            ),
      aDouble: jsonSerialization['aDouble'] == null
          ? null
          : _igqrxdcj.Protocol().deserialize<List<double>>(
              jsonSerialization['aDouble'],
            ),
      aDateTime: jsonSerialization['aDateTime'] == null
          ? null
          : _igqrxdcj.Protocol().deserialize<List<DateTime>>(
              jsonSerialization['aDateTime'],
            ),
      aString: jsonSerialization['aString'] == null
          ? null
          : _igqrxdcj.Protocol().deserialize<List<String>>(
              jsonSerialization['aString'],
            ),
      aByteData: jsonSerialization['aByteData'] == null
          ? null
          : _igqrxdcj.Protocol().deserialize<List<_idt.ByteData>>(
              jsonSerialization['aByteData'],
            ),
      aDuration: jsonSerialization['aDuration'] == null
          ? null
          : _igqrxdcj.Protocol().deserialize<List<Duration>>(
              jsonSerialization['aDuration'],
            ),
      aUuid: jsonSerialization['aUuid'] == null
          ? null
          : _igqrxdcj.Protocol().deserialize<List<_is.UuidValue>>(
              jsonSerialization['aUuid'],
            ),
      aUri: jsonSerialization['aUri'] == null
          ? null
          : _igqrxdcj.Protocol().deserialize<List<Uri>>(
              jsonSerialization['aUri'],
            ),
      aBigInt: jsonSerialization['aBigInt'] == null
          ? null
          : _igqrxdcj.Protocol().deserialize<List<BigInt>>(
              jsonSerialization['aBigInt'],
            ),
      anEnum: jsonSerialization['anEnum'] == null
          ? null
          : _igqrxdcj.Protocol().deserialize<List<_ionapfu9.TestEnum>>(
              jsonSerialization['anEnum'],
            ),
      aStringifiedEnum: jsonSerialization['aStringifiedEnum'] == null
          ? null
          : _igqrxdcj.Protocol()
                .deserialize<List<_i7liykk2.TestEnumStringified>>(
                  jsonSerialization['aStringifiedEnum'],
                ),
      anObject: jsonSerialization['anObject'] == null
          ? null
          : _igqrxdcj.Protocol().deserialize<List<_iwxwszsz.Types>>(
              jsonSerialization['anObject'],
            ),
      aMap: jsonSerialization['aMap'] == null
          ? null
          : _igqrxdcj.Protocol()
                .deserialize<List<Map<String, _iwxwszsz.Types>>>(
                  jsonSerialization['aMap'],
                ),
      aList: jsonSerialization['aList'] == null
          ? null
          : _igqrxdcj.Protocol().deserialize<List<List<_iwxwszsz.Types>>>(
              jsonSerialization['aList'],
            ),
      aRecord: jsonSerialization['aRecord'] == null
          ? null
          : _igqrxdcj.Protocol().deserialize<List<(int,)>>(
              jsonSerialization['aRecord'],
            ),
      aNullableRecord: jsonSerialization['aNullableRecord'] == null
          ? null
          : _igqrxdcj.Protocol().deserialize<List<(int,)?>>(
              jsonSerialization['aNullableRecord'],
            ),
      anEnumRecord: jsonSerialization['anEnumRecord'] == null
          ? null
          : _igqrxdcj.Protocol().deserialize<List<(_ionapfu9.TestEnum,)>>(
              jsonSerialization['anEnumRecord'],
            ),
      anEnum2Record: jsonSerialization['anEnum2Record'] == null
          ? null
          : _igqrxdcj.Protocol()
                .deserialize<List<(_i7liykk2.TestEnumStringified,)>>(
                  jsonSerialization['anEnum2Record'],
                ),
    );
  }

  List<int>? anInt;

  List<bool>? aBool;

  List<double>? aDouble;

  List<DateTime>? aDateTime;

  List<String>? aString;

  List<_idt.ByteData>? aByteData;

  List<Duration>? aDuration;

  List<_is.UuidValue>? aUuid;

  List<Uri>? aUri;

  List<BigInt>? aBigInt;

  List<_ionapfu9.TestEnum>? anEnum;

  List<_i7liykk2.TestEnumStringified>? aStringifiedEnum;

  List<_iwxwszsz.Types>? anObject;

  List<Map<String, _iwxwszsz.Types>>? aMap;

  List<List<_iwxwszsz.Types>>? aList;

  List<(int,)>? aRecord;

  List<(int,)?>? aNullableRecord;

  List<(_ionapfu9.TestEnum,)>? anEnumRecord;

  List<(_i7liykk2.TestEnumStringified,)>? anEnum2Record;

  /// Returns a shallow copy of this [TypesList]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  TypesList copyWith({
    List<int>? anInt = const _issu.$UndefinedList<int>(),
    List<bool>? aBool = const _issu.$UndefinedList<bool>(),
    List<double>? aDouble = const _issu.$UndefinedList<double>(),
    List<DateTime>? aDateTime = const _issu.$UndefinedList<DateTime>(),
    List<String>? aString = const _issu.$UndefinedList<String>(),
    List<_idt.ByteData>? aByteData =
        const _issu.$UndefinedList<_idt.ByteData>(),
    List<Duration>? aDuration = const _issu.$UndefinedList<Duration>(),
    List<_is.UuidValue>? aUuid = const _issu.$UndefinedList<_is.UuidValue>(),
    List<Uri>? aUri = const _issu.$UndefinedList<Uri>(),
    List<BigInt>? aBigInt = const _issu.$UndefinedList<BigInt>(),
    List<_ionapfu9.TestEnum>? anEnum =
        const _issu.$UndefinedList<_ionapfu9.TestEnum>(),
    List<_i7liykk2.TestEnumStringified>? aStringifiedEnum =
        const _issu.$UndefinedList<_i7liykk2.TestEnumStringified>(),
    List<_iwxwszsz.Types>? anObject =
        const _issu.$UndefinedList<_iwxwszsz.Types>(),
    List<Map<String, _iwxwszsz.Types>>? aMap =
        const _issu.$UndefinedList<Map<String, _iwxwszsz.Types>>(),
    List<List<_iwxwszsz.Types>>? aList =
        const _issu.$UndefinedList<List<_iwxwszsz.Types>>(),
    List<(int,)>? aRecord = const _issu.$UndefinedList<(int,)>(),
    List<(int,)?>? aNullableRecord = const _issu.$UndefinedList<(int,)?>(),
    List<(_ionapfu9.TestEnum,)>? anEnumRecord =
        const _issu.$UndefinedList<(_ionapfu9.TestEnum,)>(),
    List<(_i7liykk2.TestEnumStringified,)>? anEnum2Record =
        const _issu.$UndefinedList<(_i7liykk2.TestEnumStringified,)>(),
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'TypesList',
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
      if (aUri != null) 'aUri': aUri?.toJson(valueToJson: (v) => v.toJson()),
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
      if (anEnumRecord != null)
        'anEnumRecord': _igqrxdcj.Protocol().mapContainerToJson(anEnumRecord!),
      if (anEnum2Record != null)
        'anEnum2Record': _igqrxdcj.Protocol().mapContainerToJson(
          anEnum2Record!,
        ),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'TypesList',
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
      if (aUri != null) 'aUri': aUri?.toJson(valueToJson: (v) => v.toJson()),
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
      if (anEnumRecord != null)
        'anEnumRecord': _igqrxdcj.Protocol().mapContainerToJson(anEnumRecord!),
      if (anEnum2Record != null)
        'anEnum2Record': _igqrxdcj.Protocol().mapContainerToJson(
          anEnum2Record!,
        ),
    };
  }

  @override
  String toString() {
    return _is.SerializationManager.encode(this);
  }
}

class _TypesListImpl extends TypesList {
  _TypesListImpl({
    List<int>? anInt,
    List<bool>? aBool,
    List<double>? aDouble,
    List<DateTime>? aDateTime,
    List<String>? aString,
    List<_idt.ByteData>? aByteData,
    List<Duration>? aDuration,
    List<_is.UuidValue>? aUuid,
    List<Uri>? aUri,
    List<BigInt>? aBigInt,
    List<_ionapfu9.TestEnum>? anEnum,
    List<_i7liykk2.TestEnumStringified>? aStringifiedEnum,
    List<_iwxwszsz.Types>? anObject,
    List<Map<String, _iwxwszsz.Types>>? aMap,
    List<List<_iwxwszsz.Types>>? aList,
    List<(int,)>? aRecord,
    List<(int,)?>? aNullableRecord,
    List<(_ionapfu9.TestEnum,)>? anEnumRecord,
    List<(_i7liykk2.TestEnumStringified,)>? anEnum2Record,
  }) : super._(
         anInt: anInt,
         aBool: aBool,
         aDouble: aDouble,
         aDateTime: aDateTime,
         aString: aString,
         aByteData: aByteData,
         aDuration: aDuration,
         aUuid: aUuid,
         aUri: aUri,
         aBigInt: aBigInt,
         anEnum: anEnum,
         aStringifiedEnum: aStringifiedEnum,
         anObject: anObject,
         aMap: aMap,
         aList: aList,
         aRecord: aRecord,
         aNullableRecord: aNullableRecord,
         anEnumRecord: anEnumRecord,
         anEnum2Record: anEnum2Record,
       );

  /// Returns a shallow copy of this [TypesList]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  @override
  TypesList copyWith({
    List<int>? anInt = const _issu.$UndefinedList<int>(),
    List<bool>? aBool = const _issu.$UndefinedList<bool>(),
    List<double>? aDouble = const _issu.$UndefinedList<double>(),
    List<DateTime>? aDateTime = const _issu.$UndefinedList<DateTime>(),
    List<String>? aString = const _issu.$UndefinedList<String>(),
    List<_idt.ByteData>? aByteData =
        const _issu.$UndefinedList<_idt.ByteData>(),
    List<Duration>? aDuration = const _issu.$UndefinedList<Duration>(),
    List<_is.UuidValue>? aUuid = const _issu.$UndefinedList<_is.UuidValue>(),
    List<Uri>? aUri = const _issu.$UndefinedList<Uri>(),
    List<BigInt>? aBigInt = const _issu.$UndefinedList<BigInt>(),
    List<_ionapfu9.TestEnum>? anEnum =
        const _issu.$UndefinedList<_ionapfu9.TestEnum>(),
    List<_i7liykk2.TestEnumStringified>? aStringifiedEnum =
        const _issu.$UndefinedList<_i7liykk2.TestEnumStringified>(),
    List<_iwxwszsz.Types>? anObject =
        const _issu.$UndefinedList<_iwxwszsz.Types>(),
    List<Map<String, _iwxwszsz.Types>>? aMap =
        const _issu.$UndefinedList<Map<String, _iwxwszsz.Types>>(),
    List<List<_iwxwszsz.Types>>? aList =
        const _issu.$UndefinedList<List<_iwxwszsz.Types>>(),
    List<(int,)>? aRecord = const _issu.$UndefinedList<(int,)>(),
    List<(int,)?>? aNullableRecord = const _issu.$UndefinedList<(int,)?>(),
    List<(_ionapfu9.TestEnum,)>? anEnumRecord =
        const _issu.$UndefinedList<(_ionapfu9.TestEnum,)>(),
    List<(_i7liykk2.TestEnumStringified,)>? anEnum2Record =
        const _issu.$UndefinedList<(_i7liykk2.TestEnumStringified,)>(),
  }) {
    return TypesList(
      anInt: anInt is _issu.UndefinedSentinel
          ? this.anInt?.map((e0) => e0).toList()
          : anInt,
      aBool: aBool is _issu.UndefinedSentinel
          ? this.aBool?.map((e0) => e0).toList()
          : aBool,
      aDouble: aDouble is _issu.UndefinedSentinel
          ? this.aDouble?.map((e0) => e0).toList()
          : aDouble,
      aDateTime: aDateTime is _issu.UndefinedSentinel
          ? this.aDateTime?.map((e0) => e0).toList()
          : aDateTime,
      aString: aString is _issu.UndefinedSentinel
          ? this.aString?.map((e0) => e0).toList()
          : aString,
      aByteData: aByteData is _issu.UndefinedSentinel
          ? this.aByteData?.map((e0) => e0.clone()).toList()
          : aByteData,
      aDuration: aDuration is _issu.UndefinedSentinel
          ? this.aDuration?.map((e0) => e0).toList()
          : aDuration,
      aUuid: aUuid is _issu.UndefinedSentinel
          ? this.aUuid?.map((e0) => e0).toList()
          : aUuid,
      aUri: aUri is _issu.UndefinedSentinel
          ? this.aUri?.map((e0) => e0).toList()
          : aUri,
      aBigInt: aBigInt is _issu.UndefinedSentinel
          ? this.aBigInt?.map((e0) => e0).toList()
          : aBigInt,
      anEnum: anEnum is _issu.UndefinedSentinel
          ? this.anEnum?.map((e0) => e0).toList()
          : anEnum,
      aStringifiedEnum: aStringifiedEnum is _issu.UndefinedSentinel
          ? this.aStringifiedEnum?.map((e0) => e0).toList()
          : aStringifiedEnum,
      anObject: anObject is _issu.UndefinedSentinel
          ? this.anObject?.map((e0) => e0.copyWith()).toList()
          : anObject,
      aMap: aMap is _issu.UndefinedSentinel
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
                .toList()
          : aMap,
      aList: aList is _issu.UndefinedSentinel
          ? this.aList
                ?.map((e0) => e0.map((e1) => e1.copyWith()).toList())
                .toList()
          : aList,
      aRecord: aRecord is _issu.UndefinedSentinel
          ? this.aRecord?.map((e0) => (e0.$1,)).toList()
          : aRecord,
      aNullableRecord: aNullableRecord is _issu.UndefinedSentinel
          ? this.aNullableRecord
                ?.map((e0) => e0 == null ? null : (e0.$1,))
                .toList()
          : aNullableRecord,
      anEnumRecord: anEnumRecord is _issu.UndefinedSentinel
          ? this.anEnumRecord?.map((e0) => (e0.$1,)).toList()
          : anEnumRecord,
      anEnum2Record: anEnum2Record is _issu.UndefinedSentinel
          ? this.anEnum2Record?.map((e0) => (e0.$1,)).toList()
          : anEnum2Record,
    );
  }
}
