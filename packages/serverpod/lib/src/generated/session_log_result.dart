/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: non_constant_identifier_names

import 'package:serverpod_serialization/serverpod_serialization.dart';
// ignore: unused_import
import 'protocol.dart';

class SessionLogResult extends SerializableEntity {
  @override
  String get className => 'SessionLogResult';

  int? id;
  late List<SessionLogInfo> sessionLog;

  SessionLogResult({
    this.id,
    required this.sessionLog,
});

  SessionLogResult.fromSerialization(Map<String, dynamic> serialization) {
    var _data = unwrapSerializationData(serialization);
    id = _data['id'];
    sessionLog = _data['sessionLog']!.map<SessionLogInfo>((a) => SessionLogInfo.fromSerialization(a))?.toList();
  }

  @override
  Map<String, dynamic> serialize() {
    return wrapSerializationData({
      'id': id,
      'sessionLog': sessionLog.map((SessionLogInfo a) => a.serialize()).toList(),
    });
  }

  @override
  Map<String, dynamic> serializeAll() {
    return wrapSerializationData({
      'id': id,
      'sessionLog': sessionLog.map((SessionLogInfo a) => a.serialize()).toList(),
    });
  }
}

