/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: public_member_api_docs

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:serverpod_client/serverpod_client.dart' as _i1;

class ObjectFieldScopes extends _i1.SerializableEntity {
  ObjectFieldScopes({
    this.id,
    required this.normal,
    this.api,
  });

  factory ObjectFieldScopes.fromJson(
    Map<String, dynamic> jsonSerialization,
    _i1.SerializationManager serializationManager,
  ) {
    return ObjectFieldScopes(
      id: serializationManager.deserialize<int?>(jsonSerialization['id']),
      normal:
          serializationManager.deserialize<String>(jsonSerialization['normal']),
      api: serializationManager.deserialize<String?>(jsonSerialization['api']),
    );
  }

  int? id;

  String normal;

  String? api;

  @override
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'normal': normal,
      'api': api,
    };
  }
}
