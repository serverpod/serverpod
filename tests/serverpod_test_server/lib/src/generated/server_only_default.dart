/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: implementation_imports
// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: non_constant_identifier_names
// ignore_for_file: public_member_api_docs
// ignore_for_file: type_literal_in_constant_pattern
// ignore_for_file: use_super_parameters

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:serverpod/serverpod.dart' as _i1;

abstract class ServerOnlyDefault
    implements _i1.SerializableModel, _i1.ProtocolSerialization {
  ServerOnlyDefault._({
    required this.normalField,
    int? serverOnlyField,
    String? serverOnlyStringField,
  })  : serverOnlyField = serverOnlyField ?? -1,
        serverOnlyStringField = serverOnlyStringField ?? 'Server only message';

  factory ServerOnlyDefault({
    required String normalField,
    int? serverOnlyField,
    String? serverOnlyStringField,
  }) = _ServerOnlyDefaultImpl;

  factory ServerOnlyDefault.fromJson(Map<String, dynamic> jsonSerialization) {
    return ServerOnlyDefault(
      normalField: jsonSerialization['normalField'] as String,
      serverOnlyField: jsonSerialization['serverOnlyField'] as int?,
      serverOnlyStringField:
          jsonSerialization['serverOnlyStringField'] as String?,
    );
  }

  String normalField;

  int? serverOnlyField;

  String? serverOnlyStringField;

  /// Returns a shallow copy of this [ServerOnlyDefault]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  ServerOnlyDefault copyWith({
    String? normalField,
    int? serverOnlyField,
    String? serverOnlyStringField,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      'normalField': normalField,
      if (serverOnlyField != null) 'serverOnlyField': serverOnlyField,
      if (serverOnlyStringField != null)
        'serverOnlyStringField': serverOnlyStringField,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {'normalField': normalField};
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _ServerOnlyDefaultImpl extends ServerOnlyDefault {
  _ServerOnlyDefaultImpl({
    required String normalField,
    int? serverOnlyField,
    String? serverOnlyStringField,
  }) : super._(
          normalField: normalField,
          serverOnlyField: serverOnlyField,
          serverOnlyStringField: serverOnlyStringField,
        );

  /// Returns a shallow copy of this [ServerOnlyDefault]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  ServerOnlyDefault copyWith({
    String? normalField,
    Object? serverOnlyField = _Undefined,
    Object? serverOnlyStringField = _Undefined,
  }) {
    return ServerOnlyDefault(
      normalField: normalField ?? this.normalField,
      serverOnlyField:
          serverOnlyField is int? ? serverOnlyField : this.serverOnlyField,
      serverOnlyStringField: serverOnlyStringField is String?
          ? serverOnlyStringField
          : this.serverOnlyStringField,
    );
  }
}
