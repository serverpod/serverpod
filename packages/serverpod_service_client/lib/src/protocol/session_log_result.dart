/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: public_member_api_docs

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:serverpod_client/serverpod_client.dart' as _i1;
import 'protocol.dart' as _i2;

class SessionLogResult extends _i1.SerializableEntity {
  SessionLogResult({required this.sessionLog});

  factory SessionLogResult.fromJson(
    Map<String, dynamic> jsonSerialization,
    _i1.SerializationManager serializationManager,
  ) {
    return SessionLogResult(
        sessionLog:
            serializationManager.deserializeJson<List<_i2.SessionLogInfo>>(
                jsonSerialization['sessionLog']));
  }

  List<_i2.SessionLogInfo> sessionLog;

  @override
  Map<String, dynamic> toJson() {
    return {'sessionLog': sessionLog};
  }
}
