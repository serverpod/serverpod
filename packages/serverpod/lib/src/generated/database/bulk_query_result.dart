/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: public_member_api_docs
// ignore_for_file: implementation_imports

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:serverpod/serverpod.dart' as _i1;
import '../protocol.dart' as _i2;

class BulkQueryResult extends _i1.SerializableEntity {
  BulkQueryResult({
    required this.headers,
    required this.data,
    required this.numAffectedRows,
    required this.duration,
  });

  factory BulkQueryResult.fromJson(
    Map<String, dynamic> jsonSerialization,
    _i1.SerializationManager serializationManager,
  ) {
    return BulkQueryResult(
      headers: serializationManager.deserialize<
          List<_i2.BulkQueryColumnDescription>>(jsonSerialization['headers']),
      data: serializationManager.deserialize<String>(jsonSerialization['data']),
      numAffectedRows: serializationManager
          .deserialize<int>(jsonSerialization['numAffectedRows']),
      duration: serializationManager
          .deserialize<Duration>(jsonSerialization['duration']),
    );
  }

  List<_i2.BulkQueryColumnDescription> headers;

  String data;

  int numAffectedRows;

  Duration duration;

  @override
  Map<String, dynamic> toJson() {
    return {
      'headers': headers,
      'data': data,
      'numAffectedRows': numAffectedRows,
      'duration': duration,
    };
  }

  @override
  Map<String, dynamic> allToJson() {
    return {
      'headers': headers,
      'data': data,
      'numAffectedRows': numAffectedRows,
      'duration': duration,
    };
  }
}
