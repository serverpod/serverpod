/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: public_member_api_docs
// ignore_for_file: implementation_imports
// ignore_for_file: use_super_parameters
// ignore_for_file: type_literal_in_constant_pattern

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:serverpod_client/serverpod_client.dart' as _i1;

/// Information about a server method.
abstract class MethodInfo implements _i1.SerializableModel {
  MethodInfo._({
    this.id,
    required this.endpoint,
    required this.method,
  });

  factory MethodInfo({
    int? id,
    required String endpoint,
    required String method,
  }) = _MethodInfoImpl;

  factory MethodInfo.fromJson(Map<String, dynamic> jsonSerialization) {
    return MethodInfo(
      id: jsonSerialization['id'] as int?,
      endpoint: jsonSerialization['endpoint'] as String,
      method: jsonSerialization['method'] as String,
    );
  }

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
  int? id;

  /// The endpoint of this method.
  String endpoint;

  /// The name of this method.
  String method;

  MethodInfo copyWith({
    int? id,
    String? endpoint,
    String? method,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      'endpoint': endpoint,
      'method': method,
    };
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _MethodInfoImpl extends MethodInfo {
  _MethodInfoImpl({
    int? id,
    required String endpoint,
    required String method,
  }) : super._(
          id: id,
          endpoint: endpoint,
          method: method,
        );

  @override
  MethodInfo copyWith({
    Object? id = _Undefined,
    String? endpoint,
    String? method,
  }) {
    return MethodInfo(
      id: id is int? ? id : this.id,
      endpoint: endpoint ?? this.endpoint,
      method: method ?? this.method,
    );
  }
}
