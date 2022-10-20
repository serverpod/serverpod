/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:serverpod_serialization/serverpod_serialization.dart' as _i1;

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
      id: serializationManager.deserializeJson<int?>(jsonSerialization['id']),
      normal: serializationManager
          .deserializeJson<String>(jsonSerialization['normal']),
      api: serializationManager
          .deserializeJson<String?>(jsonSerialization['api']),
    );
  }

  int? id;

  String normal;

  String? api;

  @override
  String get className => 'ObjectFieldScopes';
  @override
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'normal': normal,
      'api': api,
    };
  }
}
