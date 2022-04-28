/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: non_constant_identifier_names
// ignore_for_file: public_member_api_docs
// ignore_for_file: unused_import
// ignore_for_file: unnecessary_import
// ignore_for_file: overridden_fields

import 'package:serverpod_serialization/serverpod_serialization.dart';
import 'dart:typed_data';
import 'protocol.dart';

class LogSettingsOverride extends SerializableEntity {
  @override
  String get className => 'LogSettingsOverride';

  int? id;
  String? module;
  String? endpoint;
  String? method;
  late LogSettings logSettings;

  LogSettingsOverride({
    this.id,
    this.module,
    this.endpoint,
    this.method,
    required this.logSettings,
  });

  LogSettingsOverride.fromSerialization(Map<String, dynamic> serialization) {
    Map<String, dynamic> _data = unwrapSerializationData(serialization);
    id = _data['id'];
    module = _data['module'];
    endpoint = _data['endpoint'];
    method = _data['method'];
    logSettings = LogSettings.fromSerialization(_data['logSettings']);
  }

  @override
  Map<String, dynamic> serialize() {
    return wrapSerializationData(<String, dynamic>{
      'id': id,
      'module': module,
      'endpoint': endpoint,
      'method': method,
      'logSettings': logSettings.serialize(),
    });
  }

  @override
  Map<String, dynamic> serializeAll() {
    return wrapSerializationData(<String, dynamic>{
      'id': id,
      'module': module,
      'endpoint': endpoint,
      'method': method,
      'logSettings': logSettings.serialize(),
    });
  }
}
