/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: public_member_api_docs
// ignore_for_file: implementation_imports

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:serverpod_client/serverpod_client.dart' as _i1;
import 'protocol.dart' as _i2;
import 'package:collection/collection.dart' as _i3;

/// Runtime settings of the server.
abstract class RuntimeSettings extends _i1.SerializableEntity {
  const RuntimeSettings._();

  const factory RuntimeSettings({
    int? id,
    required _i2.LogSettings logSettings,
    required List<_i2.LogSettingsOverride> logSettingsOverrides,
    required bool logServiceCalls,
    required bool logMalformedCalls,
  }) = _RuntimeSettings;

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

  RuntimeSettings copyWith({
    int? id,
    _i2.LogSettings? logSettings,
    List<_i2.LogSettingsOverride>? logSettingsOverrides,
    bool? logServiceCalls,
    bool? logMalformedCalls,
  });

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
  int? get id;

  /// Log settings.
  _i2.LogSettings get logSettings;

  /// List of log setting overrides.
  List<_i2.LogSettingsOverride> get logSettingsOverrides;

  /// True if service calls to Serverpod Insights should be logged.
  bool get logServiceCalls;

  /// True if malformed calls should be logged.
  bool get logMalformedCalls;
}

class _Undefined {}

/// Runtime settings of the server.
class _RuntimeSettings extends RuntimeSettings {
  const _RuntimeSettings({
    this.id,
    required this.logSettings,
    required this.logSettingsOverrides,
    required this.logServiceCalls,
    required this.logMalformedCalls,
  }) : super._();

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
  @override
  final int? id;

  /// Log settings.
  @override
  final _i2.LogSettings logSettings;

  /// List of log setting overrides.
  @override
  final List<_i2.LogSettingsOverride> logSettingsOverrides;

  /// True if service calls to Serverpod Insights should be logged.
  @override
  final bool logServiceCalls;

  /// True if malformed calls should be logged.
  @override
  final bool logMalformedCalls;

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

  @override
  bool operator ==(dynamic other) {
    return identical(
          this,
          other,
        ) ||
        (other is RuntimeSettings &&
            (identical(
                  other.id,
                  id,
                ) ||
                other.id == id) &&
            (identical(
                  other.logSettings,
                  logSettings,
                ) ||
                other.logSettings == logSettings) &&
            (identical(
                  other.logServiceCalls,
                  logServiceCalls,
                ) ||
                other.logServiceCalls == logServiceCalls) &&
            (identical(
                  other.logMalformedCalls,
                  logMalformedCalls,
                ) ||
                other.logMalformedCalls == logMalformedCalls) &&
            const _i3.DeepCollectionEquality().equals(
              logSettingsOverrides,
              other.logSettingsOverrides,
            ));
  }

  @override
  int get hashCode => Object.hash(
        id,
        logSettings,
        logServiceCalls,
        logMalformedCalls,
        const _i3.DeepCollectionEquality().hash(logSettingsOverrides),
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
      id: id == _Undefined ? this.id : (id as int?),
      logSettings: logSettings ?? this.logSettings,
      logSettingsOverrides: logSettingsOverrides ?? this.logSettingsOverrides,
      logServiceCalls: logServiceCalls ?? this.logServiceCalls,
      logMalformedCalls: logMalformedCalls ?? this.logMalformedCalls,
    );
  }
}
