/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: implementation_imports
// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: non_constant_identifier_names
// ignore_for_file: public_member_api_docs
// ignore_for_file: type_literal_in_constant_pattern
// ignore_for_file: use_super_parameters

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:serverpod_client/serverpod_client.dart' as _i1;

abstract class DateTimeDefaultModel implements _i1.SerializableModel {
  DateTimeDefaultModel._({
    this.id,
    DateTime? dateTimeDefaultModelNow,
    DateTime? dateTimeDefaultModelStr,
    DateTime? dateTimeDefaultModelStrNull,
  })  : dateTimeDefaultModelNow = dateTimeDefaultModelNow ?? DateTime.now(),
        dateTimeDefaultModelStr = dateTimeDefaultModelStr ??
            DateTime.parse('2024-05-24T22:00:00.000Z'),
        dateTimeDefaultModelStrNull = dateTimeDefaultModelStrNull ??
            DateTime.parse('2024-05-24T22:00:00.000Z');

  factory DateTimeDefaultModel({
    int? id,
    DateTime? dateTimeDefaultModelNow,
    DateTime? dateTimeDefaultModelStr,
    DateTime? dateTimeDefaultModelStrNull,
  }) = _DateTimeDefaultModelImpl;

  factory DateTimeDefaultModel.fromJson(
      Map<String, dynamic> jsonSerialization) {
    return DateTimeDefaultModel(
      id: jsonSerialization['id'] as int?,
      dateTimeDefaultModelNow: _i1.DateTimeJsonExtension.fromJson(
          jsonSerialization['dateTimeDefaultModelNow']),
      dateTimeDefaultModelStr: _i1.DateTimeJsonExtension.fromJson(
          jsonSerialization['dateTimeDefaultModelStr']),
      dateTimeDefaultModelStrNull:
          jsonSerialization['dateTimeDefaultModelStrNull'] == null
              ? null
              : _i1.DateTimeJsonExtension.fromJson(
                  jsonSerialization['dateTimeDefaultModelStrNull']),
    );
  }

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
  int? id;

  DateTime dateTimeDefaultModelNow;

  DateTime dateTimeDefaultModelStr;

  DateTime? dateTimeDefaultModelStrNull;

  /// Returns a shallow copy of this [DateTimeDefaultModel]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  DateTimeDefaultModel copyWith({
    int? id,
    DateTime? dateTimeDefaultModelNow,
    DateTime? dateTimeDefaultModelStr,
    DateTime? dateTimeDefaultModelStrNull,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      'dateTimeDefaultModelNow': dateTimeDefaultModelNow.toJson(),
      'dateTimeDefaultModelStr': dateTimeDefaultModelStr.toJson(),
      if (dateTimeDefaultModelStrNull != null)
        'dateTimeDefaultModelStrNull': dateTimeDefaultModelStrNull?.toJson(),
    };
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _DateTimeDefaultModelImpl extends DateTimeDefaultModel {
  _DateTimeDefaultModelImpl({
    int? id,
    DateTime? dateTimeDefaultModelNow,
    DateTime? dateTimeDefaultModelStr,
    DateTime? dateTimeDefaultModelStrNull,
  }) : super._(
          id: id,
          dateTimeDefaultModelNow: dateTimeDefaultModelNow,
          dateTimeDefaultModelStr: dateTimeDefaultModelStr,
          dateTimeDefaultModelStrNull: dateTimeDefaultModelStrNull,
        );

  /// Returns a shallow copy of this [DateTimeDefaultModel]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  DateTimeDefaultModel copyWith({
    Object? id = _Undefined,
    DateTime? dateTimeDefaultModelNow,
    DateTime? dateTimeDefaultModelStr,
    Object? dateTimeDefaultModelStrNull = _Undefined,
  }) {
    return DateTimeDefaultModel(
      id: id is int? ? id : this.id,
      dateTimeDefaultModelNow:
          dateTimeDefaultModelNow ?? this.dateTimeDefaultModelNow,
      dateTimeDefaultModelStr:
          dateTimeDefaultModelStr ?? this.dateTimeDefaultModelStr,
      dateTimeDefaultModelStrNull: dateTimeDefaultModelStrNull is DateTime?
          ? dateTimeDefaultModelStrNull
          : this.dateTimeDefaultModelStrNull,
    );
  }
}
