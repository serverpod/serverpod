/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: public_member_api_docs
// ignore_for_file: implementation_imports

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:serverpod_client/serverpod_client.dart' as _i1;

class ObjectWithIndex extends _i1.SerializableEntity {
  ObjectWithIndex({
    this.id,
    required this.indexed,
    required this.indexed2,
  });

  factory ObjectWithIndex.fromJson(
    Map<String, dynamic> jsonSerialization,
    _i1.SerializationManager serializationManager,
  ) {
    return ObjectWithIndex(
      id: serializationManager.deserialize<int?>(jsonSerialization['id']),
      indexed:
          serializationManager.deserialize<int>(jsonSerialization['indexed']),
      indexed2:
          serializationManager.deserialize<int>(jsonSerialization['indexed2']),
    );
  }

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
  int? id;

  int indexed;

  int indexed2;

  @override
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'indexed': indexed,
      'indexed2': indexed2,
    };
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other is ObjectWithIndex &&
            (identical(
                  other.id,
                  id,
                ) ||
                other.id == id) &&
            (identical(
                  other.indexed,
                  indexed,
                ) ||
                other.indexed == indexed) &&
            (identical(
                  other.indexed2,
                  indexed2,
                ) ||
                other.indexed2 == indexed2));
  }

  @override
  int get hashCode => Object.hash(
        id,
        indexed,
        indexed2,
      );

  ObjectWithIndex copyWith({
    int? id,
    int? indexed,
    int? indexed2,
  }) {
    return ObjectWithIndex(
      id: id ?? this.id,
      indexed: indexed ?? this.indexed,
      indexed2: indexed2 ?? this.indexed2,
    );
  }
}
