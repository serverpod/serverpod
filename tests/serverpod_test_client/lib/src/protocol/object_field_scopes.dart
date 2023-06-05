/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: public_member_api_docs
// ignore_for_file: implementation_imports

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:serverpod_client/serverpod_client.dart' as _i1;

class _Undefined {}

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

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
  final int? id;

  final String normal;

  final String? api;

  late Function({
    int? id,
    String? normal,
    String? api,
  }) copyWith = _copyWith;

  @override
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'normal': normal,
      'api': api,
    };
  }

  @override
  bool operator ==(dynamic other) {
    return identical(
          this,
          other,
        ) ||
        (other is ObjectFieldScopes &&
            (identical(
                  other.id,
                  id,
                ) ||
                other.id == id) &&
            (identical(
                  other.normal,
                  normal,
                ) ||
                other.normal == normal) &&
            (identical(
                  other.api,
                  api,
                ) ||
                other.api == api));
  }

  @override
  int get hashCode => Object.hash(
        id,
        normal,
        api,
      );

  ObjectFieldScopes _copyWith({
    Object? id = _Undefined,
    String? normal,
    Object? api = _Undefined,
  }) {
    return ObjectFieldScopes(
      id: id == _Undefined ? this.id : (id as int?),
      normal: normal ?? this.normal,
      api: api == _Undefined ? this.api : (api as String?),
    );
  }
}
