/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: public_member_api_docs
// ignore_for_file: implementation_imports

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:serverpod/serverpod.dart' as _i1;
import 'protocol.dart' as _i2;

/// Information about an override for log settings for either an entire
/// endpoint or a specific method.
abstract class LogSettingsOverride extends _i1.SerializableEntity {
  LogSettingsOverride._({
    this.module,
    this.endpoint,
    this.method,
    required this.logSettings,
  });

  factory LogSettingsOverride({
    String? module,
    String? endpoint,
    String? method,
    required _i2.LogSettings logSettings,
  }) = _LogSettingsOverrideImpl;

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
  String? module;

  /// Endpoint to override settings for.
  String? endpoint;

  /// Method to override settings for.
  String? method;

  /// Log settings override.
  _i2.LogSettings logSettings;

  LogSettingsOverride copyWith({
    String? module,
    String? endpoint,
    String? method,
    _i2.LogSettings? logSettings,
  });
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
  Map<String, dynamic> allToJson() {
    return {
      'module': module,
      'endpoint': endpoint,
      'method': method,
      'logSettings': logSettings,
    };
  }
}

class _Undefined {}

class _LogSettingsOverrideImpl extends LogSettingsOverride {
  _LogSettingsOverrideImpl({
    String? module,
    String? endpoint,
    String? method,
    required _i2.LogSettings logSettings,
  }) : super._(
          module: module,
          endpoint: endpoint,
          method: method,
          logSettings: logSettings,
        );

  @override
  LogSettingsOverride copyWith({
    Object? module = _Undefined,
    Object? endpoint = _Undefined,
    Object? method = _Undefined,
    _i2.LogSettings? logSettings,
  }) {
    return LogSettingsOverride(
      module: module is! String? ? this.module : module,
      endpoint: endpoint is! String? ? this.endpoint : endpoint,
      method: method is! String? ? this.method : method,
      logSettings: logSettings ?? this.logSettings.copyWith(),
    );
  }
}
