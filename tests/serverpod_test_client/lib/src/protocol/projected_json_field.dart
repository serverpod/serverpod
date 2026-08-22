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

abstract class ProjectedJsonField
    implements _isc.SerializableModel, _isc.ProtocolSerialization {
  ProjectedJsonField._({
    required this.text,
    required this.value,
    required this.valueA,
    required this.valueB,
    this.valueC,
    required this.dateValue,
    required this.list,
    required this.listA,
    required this.listB,
    required this.listC,
    required this.listD,
    required this.map,
    required this.mapA,
    required this.mapB,
    required this.mapC,
  });

  factory ProjectedJsonField({
    required String text,
    required int value,
    required bool valueA,
    required double valueB,
    String? valueC,
    required DateTime dateValue,
    required List<String> list,
    required List<int> listA,
    required List<bool> listB,
    required List<double> listC,
    required List<String> listD,
    required Map<String, String> map,
    required Map<String, int> mapA,
    required Map<String, bool> mapB,
    required Map<String, double> mapC,
  }) = _ProjectedJsonFieldImpl;

  factory ProjectedJsonField.fromJson(Map<String, dynamic> jsonSerialization) {
    return ProjectedJsonField(
      text: jsonSerialization['text'] as String,
      value: jsonSerialization['value'] as int,
      valueA: _isc.BoolJsonExtension.fromJson(jsonSerialization['valueA']),
      valueB: (jsonSerialization['valueB'] as num).toDouble(),
      valueC: jsonSerialization['valueC'] as String?,
      dateValue: _isc.DateTimeJsonExtension.fromJson(
        jsonSerialization['dateValue'],
      ),
      list: _iza9lbb5.Protocol().deserialize<List<String>>(
        jsonSerialization['list'],
      ),
      listA: _iza9lbb5.Protocol().deserialize<List<int>>(
        jsonSerialization['listA'],
      ),
      listB: _iza9lbb5.Protocol().deserialize<List<bool>>(
        jsonSerialization['listB'],
      ),
      listC: _iza9lbb5.Protocol().deserialize<List<double>>(
        jsonSerialization['listC'],
      ),
      listD: _iza9lbb5.Protocol().deserialize<List<String>>(
        jsonSerialization['listD'],
      ),
      map: _iza9lbb5.Protocol().deserialize<Map<String, String>>(
        jsonSerialization['map'],
      ),
      mapA: _iza9lbb5.Protocol().deserialize<Map<String, int>>(
        jsonSerialization['mapA'],
      ),
      mapB: _iza9lbb5.Protocol().deserialize<Map<String, bool>>(
        jsonSerialization['mapB'],
      ),
      mapC: _iza9lbb5.Protocol().deserialize<Map<String, double>>(
        jsonSerialization['mapC'],
      ),
    );
  }

  String text;

  int value;

  bool valueA;

  double valueB;

  String? valueC;

  DateTime dateValue;

  List<String> list;

  List<int> listA;

  List<bool> listB;

  List<double> listC;

  List<String> listD;

  Map<String, String> map;

  Map<String, int> mapA;

  Map<String, bool> mapB;

  Map<String, double> mapC;

  /// Returns a shallow copy of this [ProjectedJsonField]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  ProjectedJsonField copyWith({
    String? text,
    int? value,
    bool? valueA,
    double? valueB,
    String? valueC,
    DateTime? dateValue,
    List<String>? list,
    List<int>? listA,
    List<bool>? listB,
    List<double>? listC,
    List<String>? listD,
    Map<String, String>? map,
    Map<String, int>? mapA,
    Map<String, bool>? mapB,
    Map<String, double>? mapC,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'ProjectedJsonField',
      'text': text,
      'value': value,
      'valueA': valueA,
      'valueB': valueB,
      if (valueC != null) 'valueC': valueC,
      'dateValue': dateValue.toJson(),
      'list': list.toJson(),
      'listA': listA.toJson(),
      'listB': listB.toJson(),
      'listC': listC.toJson(),
      'listD': listD.toJson(),
      'map': map.toJson(),
      'mapA': mapA.toJson(),
      'mapB': mapB.toJson(),
      'mapC': mapC.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'ProjectedJsonField',
      'text': text,
      'value': value,
      'valueA': valueA,
      'valueB': valueB,
      if (valueC != null) 'valueC': valueC,
      'dateValue': dateValue.toJson(),
      'list': list.toJson(),
      'listA': listA.toJson(),
      'listB': listB.toJson(),
      'listC': listC.toJson(),
      'listD': listD.toJson(),
      'map': map.toJson(),
      'mapA': mapA.toJson(),
      'mapB': mapB.toJson(),
      'mapC': mapC.toJson(),
    };
  }

  @override
  String toString() {
    return _isc.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _ProjectedJsonFieldImpl extends ProjectedJsonField {
  _ProjectedJsonFieldImpl({
    required String text,
    required int value,
    required bool valueA,
    required double valueB,
    String? valueC,
    required DateTime dateValue,
    required List<String> list,
    required List<int> listA,
    required List<bool> listB,
    required List<double> listC,
    required List<String> listD,
    required Map<String, String> map,
    required Map<String, int> mapA,
    required Map<String, bool> mapB,
    required Map<String, double> mapC,
  }) : super._(
         text: text,
         value: value,
         valueA: valueA,
         valueB: valueB,
         valueC: valueC,
         dateValue: dateValue,
         list: list,
         listA: listA,
         listB: listB,
         listC: listC,
         listD: listD,
         map: map,
         mapA: mapA,
         mapB: mapB,
         mapC: mapC,
       );

  /// Returns a shallow copy of this [ProjectedJsonField]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  @override
  ProjectedJsonField copyWith({
    String? text,
    int? value,
    bool? valueA,
    double? valueB,
    Object? valueC = _Undefined,
    DateTime? dateValue,
    List<String>? list,
    List<int>? listA,
    List<bool>? listB,
    List<double>? listC,
    List<String>? listD,
    Map<String, String>? map,
    Map<String, int>? mapA,
    Map<String, bool>? mapB,
    Map<String, double>? mapC,
  }) {
    return ProjectedJsonField(
      text: text ?? this.text,
      value: value ?? this.value,
      valueA: valueA ?? this.valueA,
      valueB: valueB ?? this.valueB,
      valueC: valueC is String? ? valueC : this.valueC,
      dateValue: dateValue ?? this.dateValue,
      list: list ?? this.list.map((e0) => e0).toList(),
      listA: listA ?? this.listA.map((e0) => e0).toList(),
      listB: listB ?? this.listB.map((e0) => e0).toList(),
      listC: listC ?? this.listC.map((e0) => e0).toList(),
      listD: listD ?? this.listD.map((e0) => e0).toList(),
      map:
          map ??
          this.map.map(
            (
              key0,
              value0,
            ) => MapEntry(
              key0,
              value0,
            ),
          ),
      mapA:
          mapA ??
          this.mapA.map(
            (
              key0,
              value0,
            ) => MapEntry(
              key0,
              value0,
            ),
          ),
      mapB:
          mapB ??
          this.mapB.map(
            (
              key0,
              value0,
            ) => MapEntry(
              key0,
              value0,
            ),
          ),
      mapC:
          mapC ??
          this.mapC.map(
            (
              key0,
              value0,
            ) => MapEntry(
              key0,
              value0,
            ),
          ),
    );
  }
}
