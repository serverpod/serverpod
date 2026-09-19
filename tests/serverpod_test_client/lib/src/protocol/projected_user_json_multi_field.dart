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

abstract class ProjectedUserJsonMultiField
    implements _isc.SerializableModel, _isc.ProtocolSerialization {
  ProjectedUserJsonMultiField._({
    this.id,
    required this.name,
    this.jsonFieldText,
    this.jsonFieldValue,
    this.jsonFieldMapA,
    this.jsonFieldListA,
    this.jsonFieldDateValue,
  });

  factory ProjectedUserJsonMultiField({
    _isc.UuidValue? id,
    required String name,
    String? jsonFieldText,
    int? jsonFieldValue,
    Map<String, int>? jsonFieldMapA,
    List<int>? jsonFieldListA,
    DateTime? jsonFieldDateValue,
  }) = _ProjectedUserJsonMultiFieldImpl;

  factory ProjectedUserJsonMultiField.fromJson(
    Map<String, dynamic> jsonSerialization,
  ) {
    return ProjectedUserJsonMultiField(
      id: jsonSerialization['id'] == null
          ? null
          : _isc.UuidValueJsonExtension.fromJson(jsonSerialization['id']),
      name: jsonSerialization['name'] as String,
      jsonFieldText:
          (jsonSerialization['jsonFieldText'] ??
                  (jsonSerialization['jsonField'] as Map?)?['text'])
              as String?,
      jsonFieldValue:
          (jsonSerialization['jsonFieldValue'] ??
                  (jsonSerialization['jsonField'] as Map?)?['value'])
              as int?,
      jsonFieldMapA:
          (jsonSerialization['jsonFieldMapA'] ??
                  (jsonSerialization['jsonField'] as Map?)?['mapA']) ==
              null
          ? null
          : _iza9lbb5.Protocol().deserialize<Map<String, int>>(
              (jsonSerialization['jsonFieldMapA'] ??
                  (jsonSerialization['jsonField'] as Map?)?['mapA']),
            ),
      jsonFieldListA:
          (jsonSerialization['jsonFieldListA'] ??
                  (jsonSerialization['jsonField'] as Map?)?['listA']) ==
              null
          ? null
          : _iza9lbb5.Protocol().deserialize<List<int>>(
              (jsonSerialization['jsonFieldListA'] ??
                  (jsonSerialization['jsonField'] as Map?)?['listA']),
            ),
      jsonFieldDateValue:
          (jsonSerialization['jsonFieldDateValue'] ??
                  (jsonSerialization['jsonField'] as Map?)?['dateValue']) ==
              null
          ? null
          : _isc.DateTimeJsonExtension.fromJson(
              (jsonSerialization['jsonFieldDateValue'] ??
                  (jsonSerialization['jsonField'] as Map?)?['dateValue']),
            ),
    );
  }

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
  _isc.UuidValue? id;

  String name;

  String? jsonFieldText;

  int? jsonFieldValue;

  Map<String, int>? jsonFieldMapA;

  List<int>? jsonFieldListA;

  DateTime? jsonFieldDateValue;

  /// Returns a shallow copy of this [ProjectedUserJsonMultiField]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  ProjectedUserJsonMultiField copyWith({
    _isc.UuidValue? id,
    String? name,
    String? jsonFieldText,
    int? jsonFieldValue,
    Map<String, int>? jsonFieldMapA,
    List<int>? jsonFieldListA,
    DateTime? jsonFieldDateValue,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'ProjectedUserJsonMultiField',
      if (id != null) 'id': id?.toJson(),
      'name': name,
      if (jsonFieldText != null) 'jsonFieldText': jsonFieldText,
      if (jsonFieldValue != null) 'jsonFieldValue': jsonFieldValue,
      if (jsonFieldMapA != null) 'jsonFieldMapA': jsonFieldMapA?.toJson(),
      if (jsonFieldListA != null) 'jsonFieldListA': jsonFieldListA?.toJson(),
      if (jsonFieldDateValue != null)
        'jsonFieldDateValue': jsonFieldDateValue?.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'ProjectedUserJsonMultiField',
      if (id != null) 'id': id?.toJson(),
      'name': name,
      if (jsonFieldText != null) 'jsonFieldText': jsonFieldText,
      if (jsonFieldValue != null) 'jsonFieldValue': jsonFieldValue,
      if (jsonFieldMapA != null) 'jsonFieldMapA': jsonFieldMapA?.toJson(),
      if (jsonFieldListA != null) 'jsonFieldListA': jsonFieldListA?.toJson(),
      if (jsonFieldDateValue != null)
        'jsonFieldDateValue': jsonFieldDateValue?.toJson(),
    };
  }

  @override
  String toString() {
    return _isc.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _ProjectedUserJsonMultiFieldImpl extends ProjectedUserJsonMultiField {
  _ProjectedUserJsonMultiFieldImpl({
    _isc.UuidValue? id,
    required String name,
    String? jsonFieldText,
    int? jsonFieldValue,
    Map<String, int>? jsonFieldMapA,
    List<int>? jsonFieldListA,
    DateTime? jsonFieldDateValue,
  }) : super._(
         id: id,
         name: name,
         jsonFieldText: jsonFieldText,
         jsonFieldValue: jsonFieldValue,
         jsonFieldMapA: jsonFieldMapA,
         jsonFieldListA: jsonFieldListA,
         jsonFieldDateValue: jsonFieldDateValue,
       );

  /// Returns a shallow copy of this [ProjectedUserJsonMultiField]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  @override
  ProjectedUserJsonMultiField copyWith({
    Object? id = _Undefined,
    String? name,
    Object? jsonFieldText = _Undefined,
    Object? jsonFieldValue = _Undefined,
    Object? jsonFieldMapA = _Undefined,
    Object? jsonFieldListA = _Undefined,
    Object? jsonFieldDateValue = _Undefined,
  }) {
    return ProjectedUserJsonMultiField(
      id: id is _isc.UuidValue? ? id : this.id,
      name: name ?? this.name,
      jsonFieldText: jsonFieldText is String?
          ? jsonFieldText
          : this.jsonFieldText,
      jsonFieldValue: jsonFieldValue is int?
          ? jsonFieldValue
          : this.jsonFieldValue,
      jsonFieldMapA: jsonFieldMapA is Map<String, int>?
          ? jsonFieldMapA
          : this.jsonFieldMapA?.map(
              (
                key0,
                value0,
              ) => MapEntry(
                key0,
                value0,
              ),
            ),
      jsonFieldListA: jsonFieldListA is List<int>?
          ? jsonFieldListA
          : this.jsonFieldListA?.map((e0) => e0).toList(),
      jsonFieldDateValue: jsonFieldDateValue is DateTime?
          ? jsonFieldDateValue
          : this.jsonFieldDateValue,
    );
  }
}
