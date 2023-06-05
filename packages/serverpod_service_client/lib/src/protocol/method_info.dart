/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: public_member_api_docs
// ignore_for_file: implementation_imports

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:serverpod_client/serverpod_client.dart' as _i1;

class _Undefined {}

/// Information about a server method.
class MethodInfo extends _i1.SerializableEntity {
  MethodInfo({
    this.id,
    required this.endpoint,
    required this.method,
  });

  factory MethodInfo.fromJson(
    Map<String, dynamic> jsonSerialization,
    _i1.SerializationManager serializationManager,
  ) {
    return MethodInfo(
      id: serializationManager.deserialize<int?>(jsonSerialization['id']),
      endpoint: serializationManager
          .deserialize<String>(jsonSerialization['endpoint']),
      method:
          serializationManager.deserialize<String>(jsonSerialization['method']),
    );
  }

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
  final int? id;

  /// The endpoint of this method.
  final String endpoint;

  /// The name of this method.
  final String method;

  late Function({
    int? id,
    String? endpoint,
    String? method,
  }) copyWith = _copyWith;

  @override
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'endpoint': endpoint,
      'method': method,
    };
  }

  @override
  bool operator ==(dynamic other) {
    return identical(
          this,
          other,
        ) ||
        (other is MethodInfo &&
            (identical(
                  other.id,
                  id,
                ) ||
                other.id == id) &&
            (identical(
                  other.endpoint,
                  endpoint,
                ) ||
                other.endpoint == endpoint) &&
            (identical(
                  other.method,
                  method,
                ) ||
                other.method == method));
  }

  @override
  int get hashCode => Object.hash(
        id,
        endpoint,
        method,
      );

  MethodInfo _copyWith({
    Object? id = _Undefined,
    String? endpoint,
    String? method,
  }) {
    return MethodInfo(
      id: id == _Undefined ? this.id : (id as int?),
      endpoint: endpoint ?? this.endpoint,
      method: method ?? this.method,
    );
  }
}
