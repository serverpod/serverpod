/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: public_member_api_docs

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:serverpod_client/serverpod_client.dart' as _i1;
import 'protocol.dart' as _i2;

class RuntimeSettings extends _i1.SerializableEntity {
  RuntimeSettings({
    this.id,
    required this.logSettings,
    required this.logSettingsOverrides,
    required this.logServiceCalls,
    required this.logMalformedCalls,
  });

  factory RuntimeSettings.fromJson(
    Map<String, dynamic> jsonSerialization,
    _i1.SerializationManager serializationManager,
  ) {
    return RuntimeSettings(
      id: serializationManager.deserializeJson<int?>(jsonSerialization['id']),
      logSettings: serializationManager
          .deserializeJson<_i2.LogSettings>(jsonSerialization['logSettings']),
      logSettingsOverrides:
          serializationManager.deserializeJson<List<_i2.LogSettingsOverride>>(
              jsonSerialization['logSettingsOverrides']),
      logServiceCalls: serializationManager
          .deserializeJson<bool>(jsonSerialization['logServiceCalls']),
      logMalformedCalls: serializationManager
          .deserializeJson<bool>(jsonSerialization['logMalformedCalls']),
    );
  }

  int? id;

  _i2.LogSettings logSettings;

  List<_i2.LogSettingsOverride> logSettingsOverrides;

  bool logServiceCalls;

  bool logMalformedCalls;

  @override
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'logSettings': logSettings,
      'logSettingsOverrides': logSettingsOverrides,
      'logServiceCalls': logServiceCalls,
      'logMalformedCalls': logMalformedCalls,
    };
  }
}
