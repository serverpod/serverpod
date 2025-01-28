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

abstract class DateTimeDefault implements _i1.SerializableModel {
  DateTimeDefault._({
    this.id,
    DateTime? dateTimeDefaultNow,
    DateTime? dateTimeDefaultStr,
    DateTime? dateTimeDefaultStrNull,
  })  : dateTimeDefaultNow = dateTimeDefaultNow ?? DateTime.now(),
        dateTimeDefaultStr =
            dateTimeDefaultStr ?? DateTime.parse('2024-05-24T22:00:00.000Z'),
        dateTimeDefaultStrNull = dateTimeDefaultStrNull ??
            DateTime.parse('2024-05-24T22:00:00.000Z');

  factory DateTimeDefault({
    int? id,
    DateTime? dateTimeDefaultNow,
    DateTime? dateTimeDefaultStr,
    DateTime? dateTimeDefaultStrNull,
  }) = _DateTimeDefaultImpl;

  factory DateTimeDefault.fromJson(Map<String, dynamic> jsonSerialization) {
    return DateTimeDefault(
      id: jsonSerialization['id'] as int?,
      dateTimeDefaultNow: _i1.DateTimeJsonExtension.fromJson(
          jsonSerialization['dateTimeDefaultNow']),
      dateTimeDefaultStr: _i1.DateTimeJsonExtension.fromJson(
          jsonSerialization['dateTimeDefaultStr']),
      dateTimeDefaultStrNull:
          jsonSerialization['dateTimeDefaultStrNull'] == null
              ? null
              : _i1.DateTimeJsonExtension.fromJson(
                  jsonSerialization['dateTimeDefaultStrNull']),
    );
  }

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
  int? id;

  DateTime dateTimeDefaultNow;

  DateTime dateTimeDefaultStr;

  DateTime? dateTimeDefaultStrNull;

  /// Returns a shallow copy of this [DateTimeDefault]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  DateTimeDefault copyWith({
    int? id,
    DateTime? dateTimeDefaultNow,
    DateTime? dateTimeDefaultStr,
    DateTime? dateTimeDefaultStrNull,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      'dateTimeDefaultNow': dateTimeDefaultNow.toJson(),
      'dateTimeDefaultStr': dateTimeDefaultStr.toJson(),
      if (dateTimeDefaultStrNull != null)
        'dateTimeDefaultStrNull': dateTimeDefaultStrNull?.toJson(),
    };
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _DateTimeDefaultImpl extends DateTimeDefault {
  _DateTimeDefaultImpl({
    int? id,
    DateTime? dateTimeDefaultNow,
    DateTime? dateTimeDefaultStr,
    DateTime? dateTimeDefaultStrNull,
  }) : super._(
          id: id,
          dateTimeDefaultNow: dateTimeDefaultNow,
          dateTimeDefaultStr: dateTimeDefaultStr,
          dateTimeDefaultStrNull: dateTimeDefaultStrNull,
        );

  /// Returns a shallow copy of this [DateTimeDefault]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  DateTimeDefault copyWith({
    Object? id = _Undefined,
    DateTime? dateTimeDefaultNow,
    DateTime? dateTimeDefaultStr,
    Object? dateTimeDefaultStrNull = _Undefined,
  }) {
    return DateTimeDefault(
      id: id is int? ? id : this.id,
      dateTimeDefaultNow: dateTimeDefaultNow ?? this.dateTimeDefaultNow,
      dateTimeDefaultStr: dateTimeDefaultStr ?? this.dateTimeDefaultStr,
      dateTimeDefaultStrNull: dateTimeDefaultStrNull is DateTime?
          ? dateTimeDefaultStrNull
          : this.dateTimeDefaultStrNull,
    );
  }
}
