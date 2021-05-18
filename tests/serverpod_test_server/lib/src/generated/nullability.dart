/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: non_constant_identifier_names
// ignore_for_file: public_member_api_docs

import 'package:serverpod_serialization/serverpod_serialization.dart';
// ignore: unused_import
import 'protocol.dart';

class Nullability extends SerializableEntity {
  @override
  String get className => 'Nullability';

  int? id;
  late int anInt;
  int? aNullableInt;
  late double aDouble;
  double? aNullableDouble;
  late bool aBool;
  bool? aNullableBool;
  late String aString;
  String? aNullableString;
  late DateTime aDateTime;
  DateTime? aNullableDateTime;
  late SimpleData anObject;
  SimpleData? aNullableObject;
  late List<int> anIntList;
  List<int>? aNullableIntList;
  late List<int?> aListWithNullableInts;
  List<int?>? aNullableListWithNullableInts;
  late List<SimpleData> anObjectList;
  List<SimpleData>? aNullableObjectList;
  late List<SimpleData?> aListWithNullableObjects;
  List<SimpleData?>? aNullableListWithNullableObjects;
  late List<DateTime> aDateTimeList;
  List<DateTime>? aNullableDateTimeList;
  late List<DateTime?> aListWithNullableDateTimes;
  List<DateTime?>? aNullableListWithNullableDateTimes;

  Nullability({
    this.id,
    required this.anInt,
    this.aNullableInt,
    required this.aDouble,
    this.aNullableDouble,
    required this.aBool,
    this.aNullableBool,
    required this.aString,
    this.aNullableString,
    required this.aDateTime,
    this.aNullableDateTime,
    required this.anObject,
    this.aNullableObject,
    required this.anIntList,
    this.aNullableIntList,
    required this.aListWithNullableInts,
    this.aNullableListWithNullableInts,
    required this.anObjectList,
    this.aNullableObjectList,
    required this.aListWithNullableObjects,
    this.aNullableListWithNullableObjects,
    required this.aDateTimeList,
    this.aNullableDateTimeList,
    required this.aListWithNullableDateTimes,
    this.aNullableListWithNullableDateTimes,
});

  Nullability.fromSerialization(Map<String, dynamic> serialization) {
    var _data = unwrapSerializationData(serialization);
    id = _data['id'];
    anInt = _data['anInt']!;
    aNullableInt = _data['aNullableInt'];
    aDouble = _data['aDouble']!;
    aNullableDouble = _data['aNullableDouble'];
    aBool = _data['aBool']!;
    aNullableBool = _data['aNullableBool'];
    aString = _data['aString']!;
    aNullableString = _data['aNullableString'];
    aDateTime = DateTime.tryParse(_data['aDateTime'])!;
    aNullableDateTime = _data['aNullableDateTime'] != null ? DateTime.tryParse(_data['aNullableDateTime']) : null;
    anObject = SimpleData.fromSerialization(_data['anObject']);
    aNullableObject = _data['aNullableObject'] != null ? SimpleData?.fromSerialization(_data['aNullableObject']) : null;
    anIntList = _data['anIntList']!.cast<int>();
    aNullableIntList = _data['aNullableIntList']?.cast<int>();
    aListWithNullableInts = _data['aListWithNullableInts']!.cast<int?>();
    aNullableListWithNullableInts = _data['aNullableListWithNullableInts']?.cast<int?>();
    anObjectList = _data['anObjectList']!.map<SimpleData>((a) => SimpleData.fromSerialization(a))?.toList();
    aNullableObjectList = _data['aNullableObjectList']?.map<SimpleData>((a) => SimpleData.fromSerialization(a))?.toList();
    aListWithNullableObjects = _data['aListWithNullableObjects']!.map<SimpleData?>((a) => a != null ? SimpleData?.fromSerialization(a) : null)?.toList();
    aNullableListWithNullableObjects = _data['aNullableListWithNullableObjects']?.map<SimpleData?>((a) => a != null ? SimpleData?.fromSerialization(a) : null)?.toList();
    aDateTimeList = _data['aDateTimeList']!.map<DateTime>((a) => DateTime.tryParse(a)!).toList();
    aNullableDateTimeList = _data['aNullableDateTimeList']?.map<DateTime>((a) => DateTime.tryParse(a)!).toList();
    aListWithNullableDateTimes = _data['aListWithNullableDateTimes']!.map<DateTime?>((a) => a != null ? DateTime.tryParse(a) : null).toList();
    aNullableListWithNullableDateTimes = _data['aNullableListWithNullableDateTimes']?.map<DateTime?>((a) => a != null ? DateTime.tryParse(a) : null).toList();
  }

  @override
  Map<String, dynamic> serialize() {
    return wrapSerializationData({
      'id': id,
      'anInt': anInt,
      'aNullableInt': aNullableInt,
      'aDouble': aDouble,
      'aNullableDouble': aNullableDouble,
      'aBool': aBool,
      'aNullableBool': aNullableBool,
      'aString': aString,
      'aNullableString': aNullableString,
      'aDateTime': aDateTime.toUtc().toIso8601String(),
      'aNullableDateTime': aNullableDateTime?.toUtc().toIso8601String(),
      'anObject': anObject.serialize(),
      'aNullableObject': aNullableObject?.serialize(),
      'anIntList': anIntList,
      'aNullableIntList': aNullableIntList,
      'aListWithNullableInts': aListWithNullableInts,
      'aNullableListWithNullableInts': aNullableListWithNullableInts,
      'anObjectList': anObjectList.map((SimpleData a) => a.serialize()).toList(),
      'aNullableObjectList': aNullableObjectList?.map((SimpleData a) => a.serialize()).toList(),
      'aListWithNullableObjects': aListWithNullableObjects.map((SimpleData? a) => a?.serialize()).toList(),
      'aNullableListWithNullableObjects': aNullableListWithNullableObjects?.map((SimpleData? a) => a?.serialize()).toList(),
      'aDateTimeList': aDateTimeList.map<String>((a) => a.toIso8601String()).toList(),
      'aNullableDateTimeList': aNullableDateTimeList?.map<String>((a) => a.toIso8601String()).toList(),
      'aListWithNullableDateTimes': aListWithNullableDateTimes.map<String?>((a) => a?.toIso8601String()).toList(),
      'aNullableListWithNullableDateTimes': aNullableListWithNullableDateTimes?.map<String?>((a) => a?.toIso8601String()).toList(),
    });
  }

  @override
  Map<String, dynamic> serializeAll() {
    return wrapSerializationData({
      'id': id,
      'anInt': anInt,
      'aNullableInt': aNullableInt,
      'aDouble': aDouble,
      'aNullableDouble': aNullableDouble,
      'aBool': aBool,
      'aNullableBool': aNullableBool,
      'aString': aString,
      'aNullableString': aNullableString,
      'aDateTime': aDateTime.toUtc().toIso8601String(),
      'aNullableDateTime': aNullableDateTime?.toUtc().toIso8601String(),
      'anObject': anObject.serialize(),
      'aNullableObject': aNullableObject?.serialize(),
      'anIntList': anIntList,
      'aNullableIntList': aNullableIntList,
      'aListWithNullableInts': aListWithNullableInts,
      'aNullableListWithNullableInts': aNullableListWithNullableInts,
      'anObjectList': anObjectList.map((SimpleData a) => a.serialize()).toList(),
      'aNullableObjectList': aNullableObjectList?.map((SimpleData a) => a.serialize()).toList(),
      'aListWithNullableObjects': aListWithNullableObjects.map((SimpleData? a) => a?.serialize()).toList(),
      'aNullableListWithNullableObjects': aNullableListWithNullableObjects?.map((SimpleData? a) => a?.serialize()).toList(),
      'aDateTimeList': aDateTimeList.map<String>((a) => a.toIso8601String()).toList(),
      'aNullableDateTimeList': aNullableDateTimeList?.map<String>((a) => a.toIso8601String()).toList(),
      'aListWithNullableDateTimes': aListWithNullableDateTimes.map<String?>((a) => a?.toIso8601String()).toList(),
      'aNullableListWithNullableDateTimes': aNullableListWithNullableDateTimes?.map<String?>((a) => a?.toIso8601String()).toList(),
    });
  }
}

