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
import 'simple_data.dart' as _i0zisc0t;
import 'test_enum.dart' as _ionapfu9;
import 'test_enum_stringified.dart' as _i7liykk2;

abstract class TypesRecord
    implements _is.SerializableModel, _is.ProtocolSerialization {
  TypesRecord._({
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
    this.aList,
    this.aMap,
    this.aSet,
    this.aSimpleData,
    this.aNamedModel,
    this.aPositionalAndNamedModel,
    this.aNestedRecord,
    this.aNestedContainers,
  });

  factory TypesRecord({
    (int,)? anInt,
    (bool,)? aBool,
    (double,)? aDouble,
    (DateTime,)? aDateTime,
    (String,)? aString,
    (_idt.ByteData,)? aByteData,
    (Duration,)? aDuration,
    (_is.UuidValue,)? aUuid,
    (Uri,)? aUri,
    (BigInt,)? aBigInt,
    (_ionapfu9.TestEnum,)? anEnum,
    (_i7liykk2.TestEnumStringified,)? aStringifiedEnum,
    (List<int>,)? aList,
    (Map<int, int>,)? aMap,
    (Set<int>,)? aSet,
    (_i0zisc0t.SimpleData,)? aSimpleData,
    ({_i0zisc0t.SimpleData namedModel})? aNamedModel,
    (_i0zisc0t.SimpleData, {_i0zisc0t.SimpleData namedModel})?
    aPositionalAndNamedModel,
    ((int, String), {(int, String) namedNestedRecord})? aNestedRecord,
    (
      (List<(_i0zisc0t.SimpleData,)>,), {
      (_i0zisc0t.SimpleData, Map<String, _i0zisc0t.SimpleData>)
      namedNestedRecord,
    })?
    aNestedContainers,
  }) = _TypesRecordImpl;

  factory TypesRecord.fromJson(Map<String, dynamic> jsonSerialization) {
    return TypesRecord(
      anInt: jsonSerialization['anInt'] == null
          ? null
          : _igqrxdcj.Protocol().deserialize<(int,)?>(
              (jsonSerialization['anInt'] as Map<String, dynamic>),
            ),
      aBool: jsonSerialization['aBool'] == null
          ? null
          : _igqrxdcj.Protocol().deserialize<(bool,)?>(
              (jsonSerialization['aBool'] as Map<String, dynamic>),
            ),
      aDouble: jsonSerialization['aDouble'] == null
          ? null
          : _igqrxdcj.Protocol().deserialize<(double,)?>(
              (jsonSerialization['aDouble'] as Map<String, dynamic>),
            ),
      aDateTime: jsonSerialization['aDateTime'] == null
          ? null
          : _igqrxdcj.Protocol().deserialize<(DateTime,)?>(
              (jsonSerialization['aDateTime'] as Map<String, dynamic>),
            ),
      aString: jsonSerialization['aString'] == null
          ? null
          : _igqrxdcj.Protocol().deserialize<(String,)?>(
              (jsonSerialization['aString'] as Map<String, dynamic>),
            ),
      aByteData: jsonSerialization['aByteData'] == null
          ? null
          : _igqrxdcj.Protocol().deserialize<(_idt.ByteData,)?>(
              (jsonSerialization['aByteData'] as Map<String, dynamic>),
            ),
      aDuration: jsonSerialization['aDuration'] == null
          ? null
          : _igqrxdcj.Protocol().deserialize<(Duration,)?>(
              (jsonSerialization['aDuration'] as Map<String, dynamic>),
            ),
      aUuid: jsonSerialization['aUuid'] == null
          ? null
          : _igqrxdcj.Protocol().deserialize<(_is.UuidValue,)?>(
              (jsonSerialization['aUuid'] as Map<String, dynamic>),
            ),
      aUri: jsonSerialization['aUri'] == null
          ? null
          : _igqrxdcj.Protocol().deserialize<(Uri,)?>(
              (jsonSerialization['aUri'] as Map<String, dynamic>),
            ),
      aBigInt: jsonSerialization['aBigInt'] == null
          ? null
          : _igqrxdcj.Protocol().deserialize<(BigInt,)?>(
              (jsonSerialization['aBigInt'] as Map<String, dynamic>),
            ),
      anEnum: jsonSerialization['anEnum'] == null
          ? null
          : _igqrxdcj.Protocol().deserialize<(_ionapfu9.TestEnum,)?>(
              (jsonSerialization['anEnum'] as Map<String, dynamic>),
            ),
      aStringifiedEnum: jsonSerialization['aStringifiedEnum'] == null
          ? null
          : _igqrxdcj.Protocol().deserialize<(_i7liykk2.TestEnumStringified,)?>(
              (jsonSerialization['aStringifiedEnum'] as Map<String, dynamic>),
            ),
      aList: jsonSerialization['aList'] == null
          ? null
          : _igqrxdcj.Protocol().deserialize<(List<int>,)?>(
              (jsonSerialization['aList'] as Map<String, dynamic>),
            ),
      aMap: jsonSerialization['aMap'] == null
          ? null
          : _igqrxdcj.Protocol().deserialize<(Map<int, int>,)?>(
              (jsonSerialization['aMap'] as Map<String, dynamic>),
            ),
      aSet: jsonSerialization['aSet'] == null
          ? null
          : _igqrxdcj.Protocol().deserialize<(Set<int>,)?>(
              (jsonSerialization['aSet'] as Map<String, dynamic>),
            ),
      aSimpleData: jsonSerialization['aSimpleData'] == null
          ? null
          : _igqrxdcj.Protocol().deserialize<(_i0zisc0t.SimpleData,)?>(
              (jsonSerialization['aSimpleData'] as Map<String, dynamic>),
            ),
      aNamedModel: jsonSerialization['aNamedModel'] == null
          ? null
          : _igqrxdcj.Protocol()
                .deserialize<({_i0zisc0t.SimpleData namedModel})?>(
                  (jsonSerialization['aNamedModel'] as Map<String, dynamic>),
                ),
      aPositionalAndNamedModel:
          jsonSerialization['aPositionalAndNamedModel'] == null
          ? null
          : _igqrxdcj.Protocol().deserialize<
              (_i0zisc0t.SimpleData, {_i0zisc0t.SimpleData namedModel})?
            >(
              (jsonSerialization['aPositionalAndNamedModel']
                  as Map<String, dynamic>),
            ),
      aNestedRecord: jsonSerialization['aNestedRecord'] == null
          ? null
          : _igqrxdcj.Protocol().deserialize<
              ((int, String), {(int, String) namedNestedRecord})?
            >((jsonSerialization['aNestedRecord'] as Map<String, dynamic>)),
      aNestedContainers: jsonSerialization['aNestedContainers'] == null
          ? null
          : _igqrxdcj.Protocol().deserialize<
              (
                (List<(_i0zisc0t.SimpleData,)>,), {
                (_i0zisc0t.SimpleData, Map<String, _i0zisc0t.SimpleData>)
                namedNestedRecord,
              })?
            >((jsonSerialization['aNestedContainers'] as Map<String, dynamic>)),
    );
  }

  (int,)? anInt;

  (bool,)? aBool;

  (double,)? aDouble;

  (DateTime,)? aDateTime;

  (String,)? aString;

  (_idt.ByteData,)? aByteData;

  (Duration,)? aDuration;

  (_is.UuidValue,)? aUuid;

  (Uri,)? aUri;

  (BigInt,)? aBigInt;

  (_ionapfu9.TestEnum,)? anEnum;

  (_i7liykk2.TestEnumStringified,)? aStringifiedEnum;

  (List<int>,)? aList;

  (Map<int, int>,)? aMap;

  (Set<int>,)? aSet;

  (_i0zisc0t.SimpleData,)? aSimpleData;

  ({_i0zisc0t.SimpleData namedModel})? aNamedModel;

  (_i0zisc0t.SimpleData, {_i0zisc0t.SimpleData namedModel})?
  aPositionalAndNamedModel;

  ((int, String), {(int, String) namedNestedRecord})? aNestedRecord;

  (
    (List<(_i0zisc0t.SimpleData,)>,), {
    (_i0zisc0t.SimpleData, Map<String, _i0zisc0t.SimpleData>) namedNestedRecord,
  })?
  aNestedContainers;

  /// Returns a shallow copy of this [TypesRecord]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  TypesRecord copyWith({
    (int,)? anInt,
    (bool,)? aBool,
    (double,)? aDouble,
    (DateTime,)? aDateTime,
    (String,)? aString,
    (_idt.ByteData,)? aByteData,
    (Duration,)? aDuration,
    (_is.UuidValue,)? aUuid,
    (Uri,)? aUri,
    (BigInt,)? aBigInt,
    (_ionapfu9.TestEnum,)? anEnum,
    (_i7liykk2.TestEnumStringified,)? aStringifiedEnum,
    (List<int>,)? aList,
    (Map<int, int>,)? aMap,
    (Set<int>,)? aSet,
    (_i0zisc0t.SimpleData,)? aSimpleData,
    ({_i0zisc0t.SimpleData namedModel})? aNamedModel,
    (_i0zisc0t.SimpleData, {_i0zisc0t.SimpleData namedModel})?
    aPositionalAndNamedModel,
    ((int, String), {(int, String) namedNestedRecord})? aNestedRecord,
    (
      (List<(_i0zisc0t.SimpleData,)>,), {
      (_i0zisc0t.SimpleData, Map<String, _i0zisc0t.SimpleData>)
      namedNestedRecord,
    })?
    aNestedContainers,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'TypesRecord',
      if (anInt != null) 'anInt': _igqrxdcj.Protocol().mapRecordToJson(anInt),
      if (aBool != null) 'aBool': _igqrxdcj.Protocol().mapRecordToJson(aBool),
      if (aDouble != null)
        'aDouble': _igqrxdcj.Protocol().mapRecordToJson(aDouble),
      if (aDateTime != null)
        'aDateTime': _igqrxdcj.Protocol().mapRecordToJson(aDateTime),
      if (aString != null)
        'aString': _igqrxdcj.Protocol().mapRecordToJson(aString),
      if (aByteData != null)
        'aByteData': _igqrxdcj.Protocol().mapRecordToJson(aByteData),
      if (aDuration != null)
        'aDuration': _igqrxdcj.Protocol().mapRecordToJson(aDuration),
      if (aUuid != null) 'aUuid': _igqrxdcj.Protocol().mapRecordToJson(aUuid),
      if (aUri != null) 'aUri': _igqrxdcj.Protocol().mapRecordToJson(aUri),
      if (aBigInt != null)
        'aBigInt': _igqrxdcj.Protocol().mapRecordToJson(aBigInt),
      if (anEnum != null)
        'anEnum': _igqrxdcj.Protocol().mapRecordToJson(anEnum),
      if (aStringifiedEnum != null)
        'aStringifiedEnum': _igqrxdcj.Protocol().mapRecordToJson(
          aStringifiedEnum,
        ),
      if (aList != null) 'aList': _igqrxdcj.Protocol().mapRecordToJson(aList),
      if (aMap != null) 'aMap': _igqrxdcj.Protocol().mapRecordToJson(aMap),
      if (aSet != null) 'aSet': _igqrxdcj.Protocol().mapRecordToJson(aSet),
      if (aSimpleData != null)
        'aSimpleData': _igqrxdcj.Protocol().mapRecordToJson(aSimpleData),
      if (aNamedModel != null)
        'aNamedModel': _igqrxdcj.Protocol().mapRecordToJson(aNamedModel),
      if (aPositionalAndNamedModel != null)
        'aPositionalAndNamedModel': _igqrxdcj.Protocol().mapRecordToJson(
          aPositionalAndNamedModel,
        ),
      if (aNestedRecord != null)
        'aNestedRecord': _igqrxdcj.Protocol().mapRecordToJson(aNestedRecord),
      if (aNestedContainers != null)
        'aNestedContainers': _igqrxdcj.Protocol().mapRecordToJson(
          aNestedContainers,
        ),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'TypesRecord',
      if (anInt != null) 'anInt': _igqrxdcj.Protocol().mapRecordToJson(anInt),
      if (aBool != null) 'aBool': _igqrxdcj.Protocol().mapRecordToJson(aBool),
      if (aDouble != null)
        'aDouble': _igqrxdcj.Protocol().mapRecordToJson(aDouble),
      if (aDateTime != null)
        'aDateTime': _igqrxdcj.Protocol().mapRecordToJson(aDateTime),
      if (aString != null)
        'aString': _igqrxdcj.Protocol().mapRecordToJson(aString),
      if (aByteData != null)
        'aByteData': _igqrxdcj.Protocol().mapRecordToJson(aByteData),
      if (aDuration != null)
        'aDuration': _igqrxdcj.Protocol().mapRecordToJson(aDuration),
      if (aUuid != null) 'aUuid': _igqrxdcj.Protocol().mapRecordToJson(aUuid),
      if (aUri != null) 'aUri': _igqrxdcj.Protocol().mapRecordToJson(aUri),
      if (aBigInt != null)
        'aBigInt': _igqrxdcj.Protocol().mapRecordToJson(aBigInt),
      if (anEnum != null)
        'anEnum': _igqrxdcj.Protocol().mapRecordToJson(anEnum),
      if (aStringifiedEnum != null)
        'aStringifiedEnum': _igqrxdcj.Protocol().mapRecordToJson(
          aStringifiedEnum,
        ),
      if (aList != null) 'aList': _igqrxdcj.Protocol().mapRecordToJson(aList),
      if (aMap != null) 'aMap': _igqrxdcj.Protocol().mapRecordToJson(aMap),
      if (aSet != null) 'aSet': _igqrxdcj.Protocol().mapRecordToJson(aSet),
      if (aSimpleData != null)
        'aSimpleData': _igqrxdcj.Protocol().mapRecordToJson(aSimpleData),
      if (aNamedModel != null)
        'aNamedModel': _igqrxdcj.Protocol().mapRecordToJson(aNamedModel),
      if (aPositionalAndNamedModel != null)
        'aPositionalAndNamedModel': _igqrxdcj.Protocol().mapRecordToJson(
          aPositionalAndNamedModel,
        ),
      if (aNestedRecord != null)
        'aNestedRecord': _igqrxdcj.Protocol().mapRecordToJson(aNestedRecord),
      if (aNestedContainers != null)
        'aNestedContainers': _igqrxdcj.Protocol().mapRecordToJson(
          aNestedContainers,
        ),
    };
  }

  @override
  String toString() {
    return _is.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _TypesRecordImpl extends TypesRecord {
  _TypesRecordImpl({
    (int,)? anInt,
    (bool,)? aBool,
    (double,)? aDouble,
    (DateTime,)? aDateTime,
    (String,)? aString,
    (_idt.ByteData,)? aByteData,
    (Duration,)? aDuration,
    (_is.UuidValue,)? aUuid,
    (Uri,)? aUri,
    (BigInt,)? aBigInt,
    (_ionapfu9.TestEnum,)? anEnum,
    (_i7liykk2.TestEnumStringified,)? aStringifiedEnum,
    (List<int>,)? aList,
    (Map<int, int>,)? aMap,
    (Set<int>,)? aSet,
    (_i0zisc0t.SimpleData,)? aSimpleData,
    ({_i0zisc0t.SimpleData namedModel})? aNamedModel,
    (_i0zisc0t.SimpleData, {_i0zisc0t.SimpleData namedModel})?
    aPositionalAndNamedModel,
    ((int, String), {(int, String) namedNestedRecord})? aNestedRecord,
    (
      (List<(_i0zisc0t.SimpleData,)>,), {
      (_i0zisc0t.SimpleData, Map<String, _i0zisc0t.SimpleData>)
      namedNestedRecord,
    })?
    aNestedContainers,
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
         aList: aList,
         aMap: aMap,
         aSet: aSet,
         aSimpleData: aSimpleData,
         aNamedModel: aNamedModel,
         aPositionalAndNamedModel: aPositionalAndNamedModel,
         aNestedRecord: aNestedRecord,
         aNestedContainers: aNestedContainers,
       );

  /// Returns a shallow copy of this [TypesRecord]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  @override
  TypesRecord copyWith({
    Object? anInt = _Undefined,
    Object? aBool = _Undefined,
    Object? aDouble = _Undefined,
    Object? aDateTime = _Undefined,
    Object? aString = _Undefined,
    Object? aByteData = _Undefined,
    Object? aDuration = _Undefined,
    Object? aUuid = _Undefined,
    Object? aUri = _Undefined,
    Object? aBigInt = _Undefined,
    Object? anEnum = _Undefined,
    Object? aStringifiedEnum = _Undefined,
    Object? aList = _Undefined,
    Object? aMap = _Undefined,
    Object? aSet = _Undefined,
    Object? aSimpleData = _Undefined,
    Object? aNamedModel = _Undefined,
    Object? aPositionalAndNamedModel = _Undefined,
    Object? aNestedRecord = _Undefined,
    Object? aNestedContainers = _Undefined,
  }) {
    return TypesRecord(
      anInt: anInt is (int,)?
          ? anInt
          : this.anInt == null
          ? null
          : (this.anInt!.$1,),
      aBool: aBool is (bool,)?
          ? aBool
          : this.aBool == null
          ? null
          : (this.aBool!.$1,),
      aDouble: aDouble is (double,)?
          ? aDouble
          : this.aDouble == null
          ? null
          : (this.aDouble!.$1,),
      aDateTime: aDateTime is (DateTime,)?
          ? aDateTime
          : this.aDateTime == null
          ? null
          : (this.aDateTime!.$1,),
      aString: aString is (String,)?
          ? aString
          : this.aString == null
          ? null
          : (this.aString!.$1,),
      aByteData: aByteData is (_idt.ByteData,)?
          ? aByteData
          : this.aByteData == null
          ? null
          : (this.aByteData!.$1.clone(),),
      aDuration: aDuration is (Duration,)?
          ? aDuration
          : this.aDuration == null
          ? null
          : (this.aDuration!.$1,),
      aUuid: aUuid is (_is.UuidValue,)?
          ? aUuid
          : this.aUuid == null
          ? null
          : (this.aUuid!.$1,),
      aUri: aUri is (Uri,)?
          ? aUri
          : this.aUri == null
          ? null
          : (this.aUri!.$1,),
      aBigInt: aBigInt is (BigInt,)?
          ? aBigInt
          : this.aBigInt == null
          ? null
          : (this.aBigInt!.$1,),
      anEnum: anEnum is (_ionapfu9.TestEnum,)?
          ? anEnum
          : this.anEnum == null
          ? null
          : (this.anEnum!.$1,),
      aStringifiedEnum: aStringifiedEnum is (_i7liykk2.TestEnumStringified,)?
          ? aStringifiedEnum
          : this.aStringifiedEnum == null
          ? null
          : (this.aStringifiedEnum!.$1,),
      aList: aList is (List<int>,)?
          ? aList
          : this.aList == null
          ? null
          : (this.aList!.$1.map((e1) => e1).toList(),),
      aMap: aMap is (Map<int, int>,)?
          ? aMap
          : this.aMap == null
          ? null
          : (
              this.aMap!.$1.map(
                (
                  key1,
                  value1,
                ) => MapEntry(
                  key1,
                  value1,
                ),
              ),
            ),
      aSet: aSet is (Set<int>,)?
          ? aSet
          : this.aSet == null
          ? null
          : (this.aSet!.$1.map((e1) => e1).toSet(),),
      aSimpleData: aSimpleData is (_i0zisc0t.SimpleData,)?
          ? aSimpleData
          : this.aSimpleData == null
          ? null
          : (this.aSimpleData!.$1.copyWith(),),
      aNamedModel: aNamedModel is ({_i0zisc0t.SimpleData namedModel})?
          ? aNamedModel
          : this.aNamedModel == null
          ? null
          : (
              namedModel: this.aNamedModel!.namedModel.copyWith(),
            ),
      aPositionalAndNamedModel:
          aPositionalAndNamedModel
              is (_i0zisc0t.SimpleData, {_i0zisc0t.SimpleData namedModel})?
          ? aPositionalAndNamedModel
          : this.aPositionalAndNamedModel == null
          ? null
          : (
              this.aPositionalAndNamedModel!.$1.copyWith(),
              namedModel: this.aPositionalAndNamedModel!.namedModel.copyWith(),
            ),
      aNestedRecord:
          aNestedRecord is ((int, String), {(int, String) namedNestedRecord})?
          ? aNestedRecord
          : this.aNestedRecord == null
          ? null
          : (
              (
                this.aNestedRecord!.$1.$1,
                this.aNestedRecord!.$1.$2,
              ),
              namedNestedRecord: (
                this.aNestedRecord!.namedNestedRecord.$1,
                this.aNestedRecord!.namedNestedRecord.$2,
              ),
            ),
      aNestedContainers:
          aNestedContainers
              is (
                (List<(_i0zisc0t.SimpleData,)>,), {
                (_i0zisc0t.SimpleData, Map<String, _i0zisc0t.SimpleData>)
                namedNestedRecord,
              })?
          ? aNestedContainers
          : this.aNestedContainers == null
          ? null
          : (
              (
                this.aNestedContainers!.$1.$1
                    .map((e2) => (e2.$1.copyWith(),))
                    .toList(),
              ),
              namedNestedRecord: (
                this.aNestedContainers!.namedNestedRecord.$1.copyWith(),
                this.aNestedContainers!.namedNestedRecord.$2.map(
                  (
                    key2,
                    value2,
                  ) => MapEntry(
                    key2,
                    value2.copyWith(),
                  ),
                ),
              ),
            ),
    );
  }
}
