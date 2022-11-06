/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: public_member_api_docs

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:serverpod_client/serverpod_client.dart' as _i1;
import 'protocol.dart' as _i2;

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

  String? module;

  String? endpoint;

  String? method;

  _i2.LogSettings logSettings;

  @override
  Map<String, dynamic> toJson() {
    return {
      'module': module,
      'endpoint': endpoint,
      'method': method,
      'logSettings': logSettings,
    };
  }
}
