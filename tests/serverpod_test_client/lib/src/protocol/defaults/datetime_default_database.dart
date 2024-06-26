/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: public_member_api_docs
// ignore_for_file: implementation_imports
// ignore_for_file: use_super_parameters
// ignore_for_file: type_literal_in_constant_pattern

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:serverpod_client/serverpod_client.dart' as _i1;

abstract class DateTimeDefaultDatabase implements _i1.SerializableModel {
  DateTimeDefaultDatabase._({
    this.id,
    this.dateTimeDefaultDatabaseNow,
    this.dateTimeDefaultDatabaseStr,
  });

  factory DateTimeDefaultDatabase({
    int? id,
    DateTime? dateTimeDefaultDatabaseNow,
    DateTime? dateTimeDefaultDatabaseStr,
  }) = _DateTimeDefaultDatabaseImpl;

  factory DateTimeDefaultDatabase.fromJson(
      Map<String, dynamic> jsonSerialization) {
    return DateTimeDefaultDatabase(
      id: jsonSerialization['id'] as int?,
      dateTimeDefaultDatabaseNow:
          jsonSerialization['dateTimeDefaultDatabaseNow'] == null
              ? null
              : _i1.DateTimeJsonExtension.fromJson(
                  jsonSerialization['dateTimeDefaultDatabaseNow']),
      dateTimeDefaultDatabaseStr:
          jsonSerialization['dateTimeDefaultDatabaseStr'] == null
              ? null
              : _i1.DateTimeJsonExtension.fromJson(
                  jsonSerialization['dateTimeDefaultDatabaseStr']),
    );
  }

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
  int? id;

  DateTime? dateTimeDefaultDatabaseNow;

  DateTime? dateTimeDefaultDatabaseStr;

  DateTimeDefaultDatabase copyWith({
    int? id,
    DateTime? dateTimeDefaultDatabaseNow,
    DateTime? dateTimeDefaultDatabaseStr,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      if (dateTimeDefaultDatabaseNow != null)
        'dateTimeDefaultDatabaseNow': dateTimeDefaultDatabaseNow?.toJson(),
      if (dateTimeDefaultDatabaseStr != null)
        'dateTimeDefaultDatabaseStr': dateTimeDefaultDatabaseStr?.toJson(),
    };
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _DateTimeDefaultDatabaseImpl extends DateTimeDefaultDatabase {
  _DateTimeDefaultDatabaseImpl({
    int? id,
    DateTime? dateTimeDefaultDatabaseNow,
    DateTime? dateTimeDefaultDatabaseStr,
  }) : super._(
          id: id,
          dateTimeDefaultDatabaseNow: dateTimeDefaultDatabaseNow,
          dateTimeDefaultDatabaseStr: dateTimeDefaultDatabaseStr,
        );

  @override
  DateTimeDefaultDatabase copyWith({
    Object? id = _Undefined,
    Object? dateTimeDefaultDatabaseNow = _Undefined,
    Object? dateTimeDefaultDatabaseStr = _Undefined,
  }) {
    return DateTimeDefaultDatabase(
      id: id is int? ? id : this.id,
      dateTimeDefaultDatabaseNow: dateTimeDefaultDatabaseNow is DateTime?
          ? dateTimeDefaultDatabaseNow
          : this.dateTimeDefaultDatabaseNow,
      dateTimeDefaultDatabaseStr: dateTimeDefaultDatabaseStr is DateTime?
          ? dateTimeDefaultDatabaseStr
          : this.dateTimeDefaultDatabaseStr,
    );
  }
}
