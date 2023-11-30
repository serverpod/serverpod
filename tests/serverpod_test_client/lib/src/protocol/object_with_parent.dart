/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: public_member_api_docs
// ignore_for_file: implementation_imports
// ignore_for_file: use_super_parameters
// ignore_for_file: type_literal_in_constant_pattern

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:serverpod_client/serverpod_client.dart' as _i1;

abstract class ObjectWithParent extends _i1.SerializableEntity {
  ObjectWithParent._({
    this.id,
    required this.other,
    this.more,
  });

  factory ObjectWithParent({
    int? id,
    required int other,
    int? more,
  }) = _ObjectWithParentImpl;

  factory ObjectWithParent.fromJson(
    Map<String, dynamic> jsonSerialization,
    _i1.SerializationManager serializationManager,
  ) {
    return ObjectWithParent(
      id: serializationManager.deserialize<int?>(jsonSerialization['id']),
      other: serializationManager.deserialize<int>(jsonSerialization['other']),
      more: serializationManager.deserialize<int?>(jsonSerialization['more']),
    );
  }

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
  int? id;

  int other;

  int? more;

  ObjectWithParent copyWith({
    int? id,
    int? other,
    int? more,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'other': other,
      'more': more,
    };
  }
}

class _Undefined {}

class _ObjectWithParentImpl extends ObjectWithParent {
  _ObjectWithParentImpl({
    int? id,
    required int other,
    int? more,
  }) : super._(
          id: id,
          other: other,
          more: more,
        );

  @override
  ObjectWithParent copyWith({
    Object? id = _Undefined,
    int? other,
    Object? more = _Undefined,
  }) {
    return ObjectWithParent(
      id: id is int? ? id : this.id,
      other: other ?? this.other,
      more: more is int? ? more : this.more,
    );
  }
}
