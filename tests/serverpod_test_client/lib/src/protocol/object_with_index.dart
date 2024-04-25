/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: public_member_api_docs
// ignore_for_file: implementation_imports
// ignore_for_file: use_super_parameters
// ignore_for_file: type_literal_in_constant_pattern

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:serverpod_client/serverpod_client.dart' as _i1;

abstract class ObjectWithIndex extends _i1.SerializableEntity {
  ObjectWithIndex._({
    this.id,
    required this.indexed,
    required this.indexed2,
  });

  factory ObjectWithIndex({
    int? id,
    required int indexed,
    required int indexed2,
  }) = _ObjectWithIndexImpl;

  factory ObjectWithIndex.fromJson(Map<String, dynamic> jsonSerialization) {
    return ObjectWithIndex(
      id: jsonSerialization['id'] as int?,
      indexed: jsonSerialization['indexed'] as int,
      indexed2: jsonSerialization['indexed2'] as int,
    );
  }

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
  int? id;

  int indexed;

  int indexed2;

  ObjectWithIndex copyWith({
    int? id,
    int? indexed,
    int? indexed2,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      'indexed': indexed,
      'indexed2': indexed2,
    };
  }
}

class _Undefined {}

class _ObjectWithIndexImpl extends ObjectWithIndex {
  _ObjectWithIndexImpl({
    int? id,
    required int indexed,
    required int indexed2,
  }) : super._(
          id: id,
          indexed: indexed,
          indexed2: indexed2,
        );

  @override
  ObjectWithIndex copyWith({
    Object? id = _Undefined,
    int? indexed,
    int? indexed2,
  }) {
    return ObjectWithIndex(
      id: id is int? ? id : this.id,
      indexed: indexed ?? this.indexed,
      indexed2: indexed2 ?? this.indexed2,
    );
  }
}
