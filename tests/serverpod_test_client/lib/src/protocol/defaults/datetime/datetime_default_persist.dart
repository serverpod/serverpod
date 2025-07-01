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

abstract class DateTimeDefaultPersist implements _i1.SerializableModel {
  DateTimeDefaultPersist._({
    this.id,
    this.dateTimeDefaultPersistNow,
    this.dateTimeDefaultPersistStr,
  });

  factory DateTimeDefaultPersist({
    int? id,
    DateTime? dateTimeDefaultPersistNow,
    DateTime? dateTimeDefaultPersistStr,
  }) = _DateTimeDefaultPersistImpl;

  factory DateTimeDefaultPersist.fromJson(
      Map<String, dynamic> jsonSerialization) {
    return DateTimeDefaultPersist(
      id: jsonSerialization['id'] as int?,
      dateTimeDefaultPersistNow:
          jsonSerialization['dateTimeDefaultPersistNow'] == null
              ? null
              : _i1.DateTimeJsonExtension.fromJson(
                  jsonSerialization['dateTimeDefaultPersistNow']),
      dateTimeDefaultPersistStr:
          jsonSerialization['dateTimeDefaultPersistStr'] == null
              ? null
              : _i1.DateTimeJsonExtension.fromJson(
                  jsonSerialization['dateTimeDefaultPersistStr']),
    );
  }

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
  int? id;

  DateTime? dateTimeDefaultPersistNow;

  DateTime? dateTimeDefaultPersistStr;

  /// Returns a shallow copy of this [DateTimeDefaultPersist]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  DateTimeDefaultPersist copyWith({
    int? id,
    DateTime? dateTimeDefaultPersistNow,
    DateTime? dateTimeDefaultPersistStr,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      if (dateTimeDefaultPersistNow != null)
        'dateTimeDefaultPersistNow': dateTimeDefaultPersistNow?.toJson(),
      if (dateTimeDefaultPersistStr != null)
        'dateTimeDefaultPersistStr': dateTimeDefaultPersistStr?.toJson(),
    };
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _DateTimeDefaultPersistImpl extends DateTimeDefaultPersist {
  _DateTimeDefaultPersistImpl({
    int? id,
    DateTime? dateTimeDefaultPersistNow,
    DateTime? dateTimeDefaultPersistStr,
  }) : super._(
          id: id,
          dateTimeDefaultPersistNow: dateTimeDefaultPersistNow,
          dateTimeDefaultPersistStr: dateTimeDefaultPersistStr,
        );

  /// Returns a shallow copy of this [DateTimeDefaultPersist]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  DateTimeDefaultPersist copyWith({
    Object? id = _Undefined,
    Object? dateTimeDefaultPersistNow = _Undefined,
    Object? dateTimeDefaultPersistStr = _Undefined,
  }) {
    return DateTimeDefaultPersist(
      id: id is int? ? id : this.id,
      dateTimeDefaultPersistNow: dateTimeDefaultPersistNow is DateTime?
          ? dateTimeDefaultPersistNow
          : this.dateTimeDefaultPersistNow,
      dateTimeDefaultPersistStr: dateTimeDefaultPersistStr is DateTime?
          ? dateTimeDefaultPersistStr
          : this.dateTimeDefaultPersistStr,
    );
  }
}
