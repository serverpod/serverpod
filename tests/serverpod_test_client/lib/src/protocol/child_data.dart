/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: public_member_api_docs
// ignore_for_file: implementation_imports

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:serverpod_client/serverpod_client.dart' as _i1;

class ChildData extends _i1.SerializableEntity {
  ChildData({
    this.id,
    required this.description,
    required this.createdBy,
    this.modifiedBy,
  });

  factory ChildData.fromJson(
    Map<String, dynamic> jsonSerialization,
    _i1.SerializationManager serializationManager,
  ) {
    return ChildData(
      id: serializationManager.deserialize<int?>(jsonSerialization['id']),
      description: serializationManager
          .deserialize<String>(jsonSerialization['description']),
      createdBy:
          serializationManager.deserialize<int>(jsonSerialization['createdBy']),
      modifiedBy: serializationManager
          .deserialize<int?>(jsonSerialization['modifiedBy']),
    );
  }

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
  int? id;

  String description;

  int createdBy;

  int? modifiedBy;

  @override
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'description': description,
      'createdBy': createdBy,
      'modifiedBy': modifiedBy,
    };
  }
}
