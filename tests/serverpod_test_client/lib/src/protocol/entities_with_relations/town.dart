/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: public_member_api_docs
// ignore_for_file: implementation_imports

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:serverpod_client/serverpod_client.dart' as _i1;
import '../protocol.dart' as _i2;

class Town extends _i1.SerializableEntity {
  Town({
    this.id,
    required this.name,
    this.mayorId,
    this.mayor,
  });

  factory Town.fromJson(
    Map<String, dynamic> jsonSerialization,
    _i1.SerializationManager serializationManager,
  ) {
    return Town(
      id: serializationManager.deserialize<int?>(jsonSerialization['id']),
      name: serializationManager.deserialize<String>(jsonSerialization['name']),
      mayorId:
          serializationManager.deserialize<int?>(jsonSerialization['mayorId']),
      mayor: serializationManager
          .deserialize<_i2.Citizen?>(jsonSerialization['mayor']),
    );
  }

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
  int? id;

  String name;

  int? mayorId;

  _i2.Citizen? mayor;

  @override
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'mayorId': mayorId,
      'mayor': mayor,
    };
  }
}
