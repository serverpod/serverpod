/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: public_member_api_docs
// ignore_for_file: implementation_imports

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:serverpod_client/serverpod_client.dart' as _i1;

/// Information about a server method.
abstract class MethodInfo extends _i1.SerializableEntity {
  const MethodInfo._();

  const factory MethodInfo({
    int? id,
    required String endpoint,
    required String method,
  }) = _MethodInfo;

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

  MethodInfo copyWith({
    int? id,
    String? endpoint,
    String? method,
  });

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
  int? get id;

  /// The endpoint of this method.
  String get endpoint;

  /// The name of this method.
  String get method;
}

class _Undefined {}

/// Information about a server method.
class _MethodInfo extends MethodInfo {
  const _MethodInfo({
    this.id,
    required this.endpoint,
    required this.method,
  }) : super._();

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
  @override
  final int? id;

  /// The endpoint of this method.
  @override
  final String endpoint;

  /// The name of this method.
  @override
  final String method;

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

  @override
  MethodInfo copyWith({
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
