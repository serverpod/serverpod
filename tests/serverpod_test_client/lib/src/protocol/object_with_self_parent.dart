/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: public_member_api_docs
// ignore_for_file: implementation_imports

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:serverpod_client/serverpod_client.dart' as _i1;

abstract class ObjectWithSelfParent extends _i1.SerializableEntity {
  const ObjectWithSelfParent._();

  const factory ObjectWithSelfParent({
    int? id,
    int? other,
  }) = _ObjectWithSelfParent;

  factory ObjectWithSelfParent.fromJson(
    Map<String, dynamic> jsonSerialization,
    _i1.SerializationManager serializationManager,
  ) {
    return ObjectWithSelfParent(
      id: serializationManager.deserialize<int?>(jsonSerialization['id']),
      other: serializationManager.deserialize<int?>(jsonSerialization['other']),
    );
  }

  ObjectWithSelfParent copyWith({
    int? id,
    int? other,
  });

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
  int? get id;
  int? get other;
}

class _Undefined {}

class _ObjectWithSelfParent extends ObjectWithSelfParent {
  const _ObjectWithSelfParent({
    this.id,
    this.other,
  }) : super._();

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
  @override
  final int? id;

  @override
  final int? other;

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
        (other is ObjectWithSelfParent &&
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
  ObjectWithSelfParent copyWith({
    Object? id = _Undefined,
    Object? other = _Undefined,
  }) {
    return ObjectWithSelfParent(
      id: id == _Undefined ? this.id : (id as int?),
      other: other == _Undefined ? this.other : (other as int?),
    );
  }
}
