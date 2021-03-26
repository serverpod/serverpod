/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: non_constant_identifier_names

import 'package:serverpod_client/serverpod_client.dart';
// ignore: unused_import
import 'protocol.dart';

class SessionLogResult extends SerializableEntity {
  String get className => 'SessionLogResult';

  int? id;
  List<SessionLogInfo>? sessionLog;

  SessionLogResult({
    this.id,
    this.sessionLog,
});

  SessionLogResult.fromSerialization(Map<String, dynamic> serialization) {
    var _data = unwrapSerializationData(serialization);
    id = _data['id'];
    sessionLog = _data['sessionLog']?.map<SessionLogInfo>((a) => SessionLogInfo.fromSerialization(a))?.toList();
  }

  Map<String, dynamic> serialize() {
    return wrapSerializationData({
      'id': id,
      'sessionLog': sessionLog?.map((SessionLogInfo a) => a.serialize()).toList(),
    });
  }
}

