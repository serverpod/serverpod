/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: public_member_api_docs
// ignore_for_file: implementation_imports

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:serverpod/serverpod.dart' as _i1;
import 'protocol.dart' as _i2;

class _Undefined {}

/// Information about an override for log settings for either an entire
/// endpoint or a specific method.
class LogSettingsOverride extends _i1.SerializableEntity {
  LogSettingsOverride({
    this.module,
    this.endpoint,
    this.method,
    required this.logSettings,
  });

  factory LogSettingsOverride.fromJson(
    Map<String, dynamic> jsonSerialization,
    _i1.SerializationManager serializationManager,
  ) {
    return LogSettingsOverride(
      module: serializationManager
          .deserialize<String?>(jsonSerialization['module']),
      endpoint: serializationManager
          .deserialize<String?>(jsonSerialization['endpoint']),
      method: serializationManager
          .deserialize<String?>(jsonSerialization['method']),
      logSettings: serializationManager
          .deserialize<_i2.LogSettings>(jsonSerialization['logSettings']),
    );
  }

  /// Module to override settings for, null for main project.
  final String? module;

  /// Endpoint to override settings for.
  final String? endpoint;

  /// Method to override settings for.
  final String? method;

  /// Log settings override.
  final _i2.LogSettings logSettings;

  late Function({
    String? module,
    String? endpoint,
    String? method,
    _i2.LogSettings? logSettings,
  }) copyWith = _copyWith;

  @override
  Map<String, dynamic> toJson() {
    return {
      'module': module,
      'endpoint': endpoint,
      'method': method,
      'logSettings': logSettings,
    };
  }

  @override
  bool operator ==(dynamic other) {
    return identical(
          this,
          other,
        ) ||
        (other is LogSettingsOverride &&
            (identical(
                  other.module,
                  module,
                ) ||
                other.module == module) &&
            (identical(
                  other.endpoint,
                  endpoint,
                ) ||
                other.endpoint == endpoint) &&
            (identical(
                  other.method,
                  method,
                ) ||
                other.method == method) &&
            (identical(
                  other.logSettings,
                  logSettings,
                ) ||
                other.logSettings == logSettings));
  }

  @override
  int get hashCode => Object.hash(
        module,
        endpoint,
        method,
        logSettings,
      );

  LogSettingsOverride _copyWith({
    Object? module = _Undefined,
    Object? endpoint = _Undefined,
    Object? method = _Undefined,
    _i2.LogSettings? logSettings,
  }) {
    return LogSettingsOverride(
      module: module == _Undefined ? this.module : (module as String?),
      endpoint: endpoint == _Undefined ? this.endpoint : (endpoint as String?),
      method: method == _Undefined ? this.method : (method as String?),
      logSettings: logSettings ?? this.logSettings,
    );
  }
}
