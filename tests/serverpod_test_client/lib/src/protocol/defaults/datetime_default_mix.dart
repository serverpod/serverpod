/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: public_member_api_docs
// ignore_for_file: implementation_imports
// ignore_for_file: use_super_parameters
// ignore_for_file: type_literal_in_constant_pattern

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:serverpod_client/serverpod_client.dart' as _i1;

abstract class DateTimeDefaultMix implements _i1.SerializableModel {
  DateTimeDefaultMix._({
    this.id,
    DateTime? dateTimeDefaultAndDefaultModel,
    DateTime? dateTimeDefaultAndDefaultDatabase,
    DateTime? dateTimeDefaultModelAndDefaultDatabase,
  })  : dateTimeDefaultAndDefaultModel = dateTimeDefaultAndDefaultModel ??
            DateTime.parse('2024-05-10T22:00:00.000Z'),
        dateTimeDefaultAndDefaultDatabase = dateTimeDefaultAndDefaultDatabase ??
            DateTime.parse('2024-05-01T22:00:00.000Z'),
        dateTimeDefaultModelAndDefaultDatabase =
            dateTimeDefaultModelAndDefaultDatabase ??
                DateTime.parse('2024-05-01T22:00:00.000Z');

  factory DateTimeDefaultMix({
    int? id,
    DateTime? dateTimeDefaultAndDefaultModel,
    DateTime? dateTimeDefaultAndDefaultDatabase,
    DateTime? dateTimeDefaultModelAndDefaultDatabase,
  }) = _DateTimeDefaultMixImpl;

  factory DateTimeDefaultMix.fromJson(Map<String, dynamic> jsonSerialization) {
    return DateTimeDefaultMix(
      id: jsonSerialization['id'] as int?,
      dateTimeDefaultAndDefaultModel: _i1.DateTimeJsonExtension.fromJson(
          jsonSerialization['dateTimeDefaultAndDefaultModel']),
      dateTimeDefaultAndDefaultDatabase: _i1.DateTimeJsonExtension.fromJson(
          jsonSerialization['dateTimeDefaultAndDefaultDatabase']),
      dateTimeDefaultModelAndDefaultDatabase:
          _i1.DateTimeJsonExtension.fromJson(
              jsonSerialization['dateTimeDefaultModelAndDefaultDatabase']),
    );
  }

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
  int? id;

  DateTime dateTimeDefaultAndDefaultModel;

  DateTime dateTimeDefaultAndDefaultDatabase;

  DateTime dateTimeDefaultModelAndDefaultDatabase;

  DateTimeDefaultMix copyWith({
    int? id,
    DateTime? dateTimeDefaultAndDefaultModel,
    DateTime? dateTimeDefaultAndDefaultDatabase,
    DateTime? dateTimeDefaultModelAndDefaultDatabase,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      'dateTimeDefaultAndDefaultModel': dateTimeDefaultAndDefaultModel.toJson(),
      'dateTimeDefaultAndDefaultDatabase':
          dateTimeDefaultAndDefaultDatabase.toJson(),
      'dateTimeDefaultModelAndDefaultDatabase':
          dateTimeDefaultModelAndDefaultDatabase.toJson(),
    };
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _DateTimeDefaultMixImpl extends DateTimeDefaultMix {
  _DateTimeDefaultMixImpl({
    int? id,
    DateTime? dateTimeDefaultAndDefaultModel,
    DateTime? dateTimeDefaultAndDefaultDatabase,
    DateTime? dateTimeDefaultModelAndDefaultDatabase,
  }) : super._(
          id: id,
          dateTimeDefaultAndDefaultModel: dateTimeDefaultAndDefaultModel,
          dateTimeDefaultAndDefaultDatabase: dateTimeDefaultAndDefaultDatabase,
          dateTimeDefaultModelAndDefaultDatabase:
              dateTimeDefaultModelAndDefaultDatabase,
        );

  @override
  DateTimeDefaultMix copyWith({
    Object? id = _Undefined,
    DateTime? dateTimeDefaultAndDefaultModel,
    DateTime? dateTimeDefaultAndDefaultDatabase,
    DateTime? dateTimeDefaultModelAndDefaultDatabase,
  }) {
    return DateTimeDefaultMix(
      id: id is int? ? id : this.id,
      dateTimeDefaultAndDefaultModel:
          dateTimeDefaultAndDefaultModel ?? this.dateTimeDefaultAndDefaultModel,
      dateTimeDefaultAndDefaultDatabase: dateTimeDefaultAndDefaultDatabase ??
          this.dateTimeDefaultAndDefaultDatabase,
      dateTimeDefaultModelAndDefaultDatabase:
          dateTimeDefaultModelAndDefaultDatabase ??
              this.dateTimeDefaultModelAndDefaultDatabase,
    );
  }
}
