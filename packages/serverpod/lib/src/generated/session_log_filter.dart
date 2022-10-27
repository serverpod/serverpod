/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: public_member_api_docs

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:serverpod/serverpod.dart' as _i1;

class SessionLogFilter extends _i1.SerializableEntity {
  SessionLogFilter({
    this.endpoint,
    this.method,
    this.futureCall,
    required this.slow,
    required this.error,
    required this.open,
    this.lastSessionLogId,
  });

  factory SessionLogFilter.fromJson(
    Map<String, dynamic> jsonSerialization,
    _i1.SerializationManager serializationManager,
  ) {
    return SessionLogFilter(
      endpoint: serializationManager
          .deserializeJson<String?>(jsonSerialization['endpoint']),
      method: serializationManager
          .deserializeJson<String?>(jsonSerialization['method']),
      futureCall: serializationManager
          .deserializeJson<String?>(jsonSerialization['futureCall']),
      slow:
          serializationManager.deserializeJson<bool>(jsonSerialization['slow']),
      error: serializationManager
          .deserializeJson<bool>(jsonSerialization['error']),
      open:
          serializationManager.deserializeJson<bool>(jsonSerialization['open']),
      lastSessionLogId: serializationManager
          .deserializeJson<int?>(jsonSerialization['lastSessionLogId']),
    );
  }

  String? endpoint;

  String? method;

  String? futureCall;

  bool slow;

  bool error;

  bool open;

  int? lastSessionLogId;

  @override
  Map<String, dynamic> toJson() {
    return {
      'endpoint': endpoint,
      'method': method,
      'futureCall': futureCall,
      'slow': slow,
      'error': error,
      'open': open,
      'lastSessionLogId': lastSessionLogId,
    };
  }

  @override
  Map<String, dynamic> allToJson() {
    return {
      'endpoint': endpoint,
      'method': method,
      'futureCall': futureCall,
      'slow': slow,
      'error': error,
      'open': open,
      'lastSessionLogId': lastSessionLogId,
    };
  }
}
