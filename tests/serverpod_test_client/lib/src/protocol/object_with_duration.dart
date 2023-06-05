/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: public_member_api_docs
// ignore_for_file: implementation_imports

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:serverpod_client/serverpod_client.dart' as _i1;

abstract class ObjectWithDuration extends _i1.SerializableEntity {
  const ObjectWithDuration._();

  const factory ObjectWithDuration({
    int? id,
    required Duration duration,
  }) = _ObjectWithDuration;

  factory ObjectWithDuration.fromJson(
    Map<String, dynamic> jsonSerialization,
    _i1.SerializationManager serializationManager,
  ) {
    return ObjectWithDuration(
      id: serializationManager.deserialize<int?>(jsonSerialization['id']),
      duration: serializationManager
          .deserialize<Duration>(jsonSerialization['duration']),
    );
  }

  ObjectWithDuration copyWith({
    int? id,
    Duration? duration,
  });

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
  int? get id;
  Duration get duration;
}

class _Undefined {}

class _ObjectWithDuration extends ObjectWithDuration {
  const _ObjectWithDuration({
    this.id,
    required this.duration,
  }) : super._();

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
  @override
  final int? id;

  @override
  final Duration duration;

  @override
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'duration': duration,
    };
  }

  @override
  bool operator ==(dynamic other) {
    return identical(
          this,
          other,
        ) ||
        (other is ObjectWithDuration &&
            (identical(
                  other.id,
                  id,
                ) ||
                other.id == id) &&
            (identical(
                  other.duration,
                  duration,
                ) ||
                other.duration == duration));
  }

  @override
  int get hashCode => Object.hash(
        id,
        duration,
      );

  @override
  ObjectWithDuration copyWith({
    Object? id = _Undefined,
    Duration? duration,
  }) {
    return ObjectWithDuration(
      id: id == _Undefined ? this.id : (id as int?),
      duration: duration ?? this.duration,
    );
  }
}
