/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: non_constant_identifier_names
// ignore_for_file: public_member_api_docs
// ignore_for_file: unused_import
// ignore_for_file: unnecessary_import
// ignore_for_file: overridden_fields

import 'package:serverpod_client/serverpod_client.dart';
import 'dart:typed_data';
import 'protocol.dart';

class RuntimeSettings extends SerializableEntity {
  @override
  String get className => 'RuntimeSettings';

  int? id;
  late LogSettings logSettings;
  late List<LogSettingsOverride> logSettingsOverrides;
  late bool logServiceCalls;
  late bool logMalformedCalls;

  RuntimeSettings({
    this.id,
    required this.logSettings,
    required this.logSettingsOverrides,
    required this.logServiceCalls,
    required this.logMalformedCalls,
  });

  RuntimeSettings.fromSerialization(Map<String, dynamic> serialization) {
    Map<String, dynamic> _data = unwrapSerializationData(serialization);
    id = _data['id'];
    logSettings = LogSettings.fromSerialization(_data['logSettings']);
    logSettingsOverrides = _data['logSettingsOverrides']!
        .map<LogSettingsOverride>(
            (Map<String, dynamic> a) => LogSettingsOverride.fromSerialization(a))
        ?.toList();
    logServiceCalls = _data['logServiceCalls']!;
    logMalformedCalls = _data['logMalformedCalls']!;
  }

  @override
  Map<String, dynamic> serialize() {
    return wrapSerializationData(<String, dynamic>{
      'id': id,
      'logSettings': logSettings.serialize(),
      'logSettingsOverrides': logSettingsOverrides
          .map((LogSettingsOverride a) => a.serialize())
          .toList(),
      'logServiceCalls': logServiceCalls,
      'logMalformedCalls': logMalformedCalls,
    });
  }
}
