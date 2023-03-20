/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: public_member_api_docs
// ignore_for_file: implementation_imports

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:serverpod/serverpod.dart' as _i1;

/// The definition of a (desired) index in the database.
class IndexDefinition extends _i1.SerializableEntity {
  IndexDefinition({
    required this.indexName,
    required this.fields,
    required this.type,
    required this.isUnique,
  });

  factory IndexDefinition.fromJson(
    Map<String, dynamic> jsonSerialization,
    _i1.SerializationManager serializationManager,
  ) {
    return IndexDefinition(
      indexName: serializationManager
          .deserialize<String>(jsonSerialization['indexName']),
      fields: serializationManager
          .deserialize<List<String>>(jsonSerialization['fields']),
      type: serializationManager.deserialize<String>(jsonSerialization['type']),
      isUnique:
          serializationManager.deserialize<bool>(jsonSerialization['isUnique']),
    );
  }

  /// The user defined name of the index
  String indexName;

  /// The fields, that are a part of this index.
  List<String> fields;

  /// The type of the index
  String type;

  /// Whether the index is unique.
  bool isUnique;

  @override
  Map<String, dynamic> toJson() {
    return {
      'indexName': indexName,
      'fields': fields,
      'type': type,
      'isUnique': isUnique,
    };
  }

  @override
  Map<String, dynamic> allToJson() {
    return {
      'indexName': indexName,
      'fields': fields,
      'type': type,
      'isUnique': isUnique,
    };
  }
}
