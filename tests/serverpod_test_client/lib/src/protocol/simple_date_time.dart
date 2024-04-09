/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: public_member_api_docs
// ignore_for_file: implementation_imports
// ignore_for_file: use_super_parameters
// ignore_for_file: type_literal_in_constant_pattern

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:serverpod_client/serverpod_client.dart' as _i1;
import 'package:serverpod_serialization/serverpod_serialization.dart' as _i2;

/// Just some simple data.
abstract class SimpleDateTime extends _i1.SerializableEntity {
  SimpleDateTime._({
    this.id,
    required this.dateTime,
  });

  factory SimpleDateTime({
    int? id,
    required DateTime dateTime,
  }) = _SimpleDateTimeImpl;

  factory SimpleDateTime.fromJson(Map<String, dynamic> jsonSerialization) {
    return SimpleDateTime(
      id: jsonSerialization['id'] as int?,
      dateTime:
          _i2.DateTimeExt.getDateTime<DateTime>(jsonSerialization['dateTime'])!,
    );
  }

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
  int? id;

  /// The only field of [SimpleDateTime]
  DateTime dateTime;

  SimpleDateTime copyWith({
    int? id,
    DateTime? dateTime,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      'dateTime': dateTime.toJson(),
    };
  }
}

class _Undefined {}

class _SimpleDateTimeImpl extends SimpleDateTime {
  _SimpleDateTimeImpl({
    int? id,
    required DateTime dateTime,
  }) : super._(
          id: id,
          dateTime: dateTime,
        );

  @override
  SimpleDateTime copyWith({
    Object? id = _Undefined,
    DateTime? dateTime,
  }) {
    return SimpleDateTime(
      id: id is int? ? id : this.id,
      dateTime: dateTime ?? this.dateTime,
    );
  }
}
