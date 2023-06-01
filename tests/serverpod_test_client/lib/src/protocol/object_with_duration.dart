/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: public_member_api_docs
// ignore_for_file: implementation_imports

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:serverpod_client/serverpod_client.dart' as _i1;

class ObjectWithDuration extends _i1.SerializableEntity {
  ObjectWithDuration({
    this.id,
    required this.duration,
  });

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

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
  final int? id;

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
    return identical(this, other) ||
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

  ObjectWithDuration copyWith({
    int? id,
    Duration? duration,
  }) {
    return ObjectWithDuration(
      id: id ?? this.id,
      duration: duration ?? this.duration,
    );
  }
}
