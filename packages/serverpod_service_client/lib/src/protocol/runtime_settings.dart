/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: implementation_imports
// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: non_constant_identifier_names
// ignore_for_file: public_member_api_docs
// ignore_for_file: type_literal_in_constant_pattern
// ignore_for_file: use_super_parameters

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:serverpod_client/serverpod_client.dart' as _i1;
import 'log_settings.dart' as _i2;
import 'log_settings_override.dart' as _i3;

/// Runtime settings of the server.
abstract class RuntimeSettings implements _i1.SerializableModel {
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
    required List<_i3.LogSettingsOverride> logSettingsOverrides,
    required bool logServiceCalls,
    required bool logMalformedCalls,
  }) = _RuntimeSettingsImpl;

  factory RuntimeSettings.fromJson(Map<String, dynamic> jsonSerialization) {
    return RuntimeSettings(
      id: jsonSerialization['id'] as int?,
      logSettings: _i2.LogSettings.fromJson(
          (jsonSerialization['logSettings'] as Map<String, dynamic>)),
      logSettingsOverrides: (jsonSerialization['logSettingsOverrides'] as List)
          .map((e) =>
              _i3.LogSettingsOverride.fromJson((e as Map<String, dynamic>)))
          .toList(),
      logServiceCalls: jsonSerialization['logServiceCalls'] as bool,
      logMalformedCalls: jsonSerialization['logMalformedCalls'] as bool,
    );
  }

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
  int? id;

  /// Log settings.
  _i2.LogSettings logSettings;

  /// List of log setting overrides.
  List<_i3.LogSettingsOverride> logSettingsOverrides;

  /// True if service calls to Serverpod Insights should be logged.
  bool logServiceCalls;

  /// True if malformed calls should be logged.
  bool logMalformedCalls;

  /// Returns a shallow copy of this [RuntimeSettings]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  RuntimeSettings copyWith({
    int? id,
    _i2.LogSettings? logSettings,
    List<_i3.LogSettingsOverride>? logSettingsOverrides,
    bool? logServiceCalls,
    bool? logMalformedCalls,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      'logSettings': logSettings.toJson(),
      'logSettingsOverrides':
          logSettingsOverrides.toJson(valueToJson: (v) => v.toJson()),
      'logServiceCalls': logServiceCalls,
      'logMalformedCalls': logMalformedCalls,
    };
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _RuntimeSettingsImpl extends RuntimeSettings {
  _RuntimeSettingsImpl({
    int? id,
    required _i2.LogSettings logSettings,
    required List<_i3.LogSettingsOverride> logSettingsOverrides,
    required bool logServiceCalls,
    required bool logMalformedCalls,
  }) : super._(
          id: id,
          logSettings: logSettings,
          logSettingsOverrides: logSettingsOverrides,
          logServiceCalls: logServiceCalls,
          logMalformedCalls: logMalformedCalls,
        );

  /// Returns a shallow copy of this [RuntimeSettings]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  RuntimeSettings copyWith({
    Object? id = _Undefined,
    _i2.LogSettings? logSettings,
    List<_i3.LogSettingsOverride>? logSettingsOverrides,
    bool? logServiceCalls,
    bool? logMalformedCalls,
  }) {
    return RuntimeSettings(
      id: id is int? ? id : this.id,
      logSettings: logSettings ?? this.logSettings.copyWith(),
      logSettingsOverrides: logSettingsOverrides ??
          this.logSettingsOverrides.map((e0) => e0.copyWith()).toList(),
      logServiceCalls: logServiceCalls ?? this.logServiceCalls,
      logMalformedCalls: logMalformedCalls ?? this.logMalformedCalls,
    );
  }
}
