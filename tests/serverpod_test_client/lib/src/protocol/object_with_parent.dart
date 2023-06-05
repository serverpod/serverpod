/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: public_member_api_docs
// ignore_for_file: implementation_imports

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:serverpod_client/serverpod_client.dart' as _i1;

abstract class ObjectWithParent extends _i1.SerializableEntity {
  const ObjectWithParent._();

  const factory ObjectWithParent({
    int? id,
    required int other,
  }) = _ObjectWithParent;

  factory ObjectWithParent.fromJson(
    Map<String, dynamic> jsonSerialization,
    _i1.SerializationManager serializationManager,
  ) {
    return ObjectWithParent(
      id: serializationManager.deserialize<int?>(jsonSerialization['id']),
      other: serializationManager.deserialize<int>(jsonSerialization['other']),
    );
  }

  ObjectWithParent copyWith({
    int? id,
    int? other,
  });

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
  int? get id;
  int get other;
}

class _Undefined {}

class _ObjectWithParent extends ObjectWithParent {
  const _ObjectWithParent({
    this.id,
    required this.other,
  }) : super._();

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
  @override
  final int? id;

  @override
  final int other;

  @override
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'other': other,
    };
  }

  @override
  bool operator ==(dynamic other) {
    return identical(
          this,
          other,
        ) ||
        (other is ObjectWithParent &&
            (identical(
                  other.id,
                  id,
                ) ||
                other.id == id) &&
            (identical(
                  other.other,
                  other,
                ) ||
                other.other == other));
  }

  @override
  int get hashCode => Object.hash(
        id,
        other,
      );

  @override
  ObjectWithParent copyWith({
    Object? id = _Undefined,
    int? other,
  }) {
    return ObjectWithParent(
      id: id == _Undefined ? this.id : (id as int?),
      other: other ?? this.other,
    );
  }
}
