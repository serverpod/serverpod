/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: public_member_api_docs
// ignore_for_file: implementation_imports

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:serverpod_client/serverpod_client.dart' as _i1;
import 'protocol.dart' as _i2;

/// Runtime settings of the server.
abstract class RuntimeSettings extends _i1.SerializableEntity {
  RuntimeSettings._({
    this.id,
    required this.logSettings,
    required this.logSettingsOverrides,
    required this.logServiceCalls,
    required this.logMalformedCalls,
  });

  factory RuntimeSettings({
    int? id,
    required _i2.LogSettings logSettings,
    required List<_i2.LogSettingsOverride> logSettingsOverrides,
    required bool logServiceCalls,
    required bool logMalformedCalls,
  }) = _RuntimeSettingsImpl;

  factory RuntimeSettings.fromJson(
    Map<String, dynamic> jsonSerialization,
    _i1.SerializationManager serializationManager,
  ) {
    return RuntimeSettings(
      id: serializationManager.deserialize<int?>(jsonSerialization['id']),
      logSettings: serializationManager
          .deserialize<_i2.LogSettings>(jsonSerialization['logSettings']),
      logSettingsOverrides:
          serializationManager.deserialize<List<_i2.LogSettingsOverride>>(
              jsonSerialization['logSettingsOverrides']),
      logServiceCalls: serializationManager
          .deserialize<bool>(jsonSerialization['logServiceCalls']),
      logMalformedCalls: serializationManager
          .deserialize<bool>(jsonSerialization['logMalformedCalls']),
    );
  }

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
  int? id;

  /// Log settings.
  _i2.LogSettings logSettings;

  /// List of log setting overrides.
  List<_i2.LogSettingsOverride> logSettingsOverrides;

  /// True if service calls to Serverpod Insights should be logged.
  bool logServiceCalls;

  /// True if malformed calls should be logged.
  bool logMalformedCalls;

  RuntimeSettings copyWith({
    int? id,
    _i2.LogSettings? logSettings,
    List<_i2.LogSettingsOverride>? logSettingsOverrides,
    bool? logServiceCalls,
    bool? logMalformedCalls,
  });
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

class _Undefined {}

class _RuntimeSettingsImpl extends RuntimeSettings {
  _RuntimeSettingsImpl({
    int? id,
    required _i2.LogSettings logSettings,
    required List<_i2.LogSettingsOverride> logSettingsOverrides,
    required bool logServiceCalls,
    required bool logMalformedCalls,
  }) : super._(
          id: id,
          logSettings: logSettings,
          logSettingsOverrides: logSettingsOverrides,
          logServiceCalls: logServiceCalls,
          logMalformedCalls: logMalformedCalls,
        );

  @override
  RuntimeSettings copyWith({
    Object? id = _Undefined,
    _i2.LogSettings? logSettings,
    List<_i2.LogSettingsOverride>? logSettingsOverrides,
    bool? logServiceCalls,
    bool? logMalformedCalls,
  }) {
    return RuntimeSettings(
      id: id is int? ? id : this.id,
      logSettings: logSettings ?? this.logSettings.copyWith(),
      logSettingsOverrides:
          logSettingsOverrides ?? this.logSettingsOverrides.clone(),
      logServiceCalls: logServiceCalls ?? this.logServiceCalls,
      logMalformedCalls: logMalformedCalls ?? this.logMalformedCalls,
    );
  }
}
