/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: public_member_api_docs
// ignore_for_file: implementation_imports
// ignore_for_file: use_super_parameters
// ignore_for_file: type_literal_in_constant_pattern

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:serverpod_client/serverpod_client.dart' as _i1;

abstract class ObjectFieldScopes extends _i1.SerializableEntity {
  ObjectFieldScopes._({
    this.id,
    required this.normal,
    this.api,
  });

  factory ObjectFieldScopes({
    int? id,
    required String normal,
    String? api,
  }) = _ObjectFieldScopesImpl;

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

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
  int? id;

  String normal;

  String? api;

  ObjectFieldScopes copyWith({
    int? id,
    String? normal,
    String? api,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      'normal': normal,
      if (api != null) 'api': api,
    };
  }
}

class _Undefined {}

class _ObjectFieldScopesImpl extends ObjectFieldScopes {
  _ObjectFieldScopesImpl({
    int? id,
    required String normal,
    String? api,
  }) : super._(
          id: id,
          normal: normal,
          api: api,
        );

  @override
  ObjectFieldScopes copyWith({
    Object? id = _Undefined,
    String? normal,
    Object? api = _Undefined,
  }) {
    return ObjectFieldScopes(
      id: id is int? ? id : this.id,
      normal: normal ?? this.normal,
      api: api is String? ? api : this.api,
    );
  }
}
