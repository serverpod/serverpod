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

abstract class DateTimeDefaultMix implements _i1.SerializableModel {
  DateTimeDefaultMix._({
    this.id,
    DateTime? dateTimeDefaultAndDefaultModel,
    DateTime? dateTimeDefaultAndDefaultPersist,
    DateTime? dateTimeDefaultModelAndDefaultPersist,
  })  : dateTimeDefaultAndDefaultModel = dateTimeDefaultAndDefaultModel ??
            DateTime.parse('2024-05-10T22:00:00.000Z'),
        dateTimeDefaultAndDefaultPersist = dateTimeDefaultAndDefaultPersist ??
            DateTime.parse('2024-05-01T22:00:00.000Z'),
        dateTimeDefaultModelAndDefaultPersist =
            dateTimeDefaultModelAndDefaultPersist ??
                DateTime.parse('2024-05-01T22:00:00.000Z');

  factory DateTimeDefaultMix({
    int? id,
    DateTime? dateTimeDefaultAndDefaultModel,
    DateTime? dateTimeDefaultAndDefaultPersist,
    DateTime? dateTimeDefaultModelAndDefaultPersist,
  }) = _DateTimeDefaultMixImpl;

  factory DateTimeDefaultMix.fromJson(Map<String, dynamic> jsonSerialization) {
    return DateTimeDefaultMix(
      id: jsonSerialization['id'] as int?,
      dateTimeDefaultAndDefaultModel: _i1.DateTimeJsonExtension.fromJson(
          jsonSerialization['dateTimeDefaultAndDefaultModel']),
      dateTimeDefaultAndDefaultPersist: _i1.DateTimeJsonExtension.fromJson(
          jsonSerialization['dateTimeDefaultAndDefaultPersist']),
      dateTimeDefaultModelAndDefaultPersist: _i1.DateTimeJsonExtension.fromJson(
          jsonSerialization['dateTimeDefaultModelAndDefaultPersist']),
    );
  }

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
  int? id;

  DateTime dateTimeDefaultAndDefaultModel;

  DateTime dateTimeDefaultAndDefaultPersist;

  DateTime dateTimeDefaultModelAndDefaultPersist;

  /// Returns a shallow copy of this [DateTimeDefaultMix]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  DateTimeDefaultMix copyWith({
    int? id,
    DateTime? dateTimeDefaultAndDefaultModel,
    DateTime? dateTimeDefaultAndDefaultPersist,
    DateTime? dateTimeDefaultModelAndDefaultPersist,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      'dateTimeDefaultAndDefaultModel': dateTimeDefaultAndDefaultModel.toJson(),
      'dateTimeDefaultAndDefaultPersist':
          dateTimeDefaultAndDefaultPersist.toJson(),
      'dateTimeDefaultModelAndDefaultPersist':
          dateTimeDefaultModelAndDefaultPersist.toJson(),
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
    DateTime? dateTimeDefaultAndDefaultPersist,
    DateTime? dateTimeDefaultModelAndDefaultPersist,
  }) : super._(
          id: id,
          dateTimeDefaultAndDefaultModel: dateTimeDefaultAndDefaultModel,
          dateTimeDefaultAndDefaultPersist: dateTimeDefaultAndDefaultPersist,
          dateTimeDefaultModelAndDefaultPersist:
              dateTimeDefaultModelAndDefaultPersist,
        );

  /// Returns a shallow copy of this [DateTimeDefaultMix]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  DateTimeDefaultMix copyWith({
    Object? id = _Undefined,
    DateTime? dateTimeDefaultAndDefaultModel,
    DateTime? dateTimeDefaultAndDefaultPersist,
    DateTime? dateTimeDefaultModelAndDefaultPersist,
  }) {
    return DateTimeDefaultMix(
      id: id is int? ? id : this.id,
      dateTimeDefaultAndDefaultModel:
          dateTimeDefaultAndDefaultModel ?? this.dateTimeDefaultAndDefaultModel,
      dateTimeDefaultAndDefaultPersist: dateTimeDefaultAndDefaultPersist ??
          this.dateTimeDefaultAndDefaultPersist,
      dateTimeDefaultModelAndDefaultPersist:
          dateTimeDefaultModelAndDefaultPersist ??
              this.dateTimeDefaultModelAndDefaultPersist,
    );
  }
}
