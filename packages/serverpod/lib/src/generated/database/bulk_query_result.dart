/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: public_member_api_docs
// ignore_for_file: implementation_imports
// ignore_for_file: use_super_parameters
// ignore_for_file: type_literal_in_constant_pattern

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:serverpod/serverpod.dart' as _i1;
import '../protocol.dart' as _i2;

abstract class BulkQueryResult extends _i1.SerializableModel {
  BulkQueryResult._({
    required this.headers,
    required this.data,
    required this.numAffectedRows,
    required this.duration,
  });

  factory BulkQueryResult({
    required List<_i2.BulkQueryColumnDescription> headers,
    required String data,
    required int numAffectedRows,
    required Duration duration,
  }) = _BulkQueryResultImpl;

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

  BulkQueryResult copyWith({
    List<_i2.BulkQueryColumnDescription>? headers,
    String? data,
    int? numAffectedRows,
    Duration? duration,
  });
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

class _BulkQueryResultImpl extends BulkQueryResult {
  _BulkQueryResultImpl({
    required List<_i2.BulkQueryColumnDescription> headers,
    required String data,
    required int numAffectedRows,
    required Duration duration,
  }) : super._(
          headers: headers,
          data: data,
          numAffectedRows: numAffectedRows,
          duration: duration,
        );

  @override
  BulkQueryResult copyWith({
    List<_i2.BulkQueryColumnDescription>? headers,
    String? data,
    int? numAffectedRows,
    Duration? duration,
  }) {
    return BulkQueryResult(
      headers: headers ?? this.headers.clone(),
      data: data ?? this.data,
      numAffectedRows: numAffectedRows ?? this.numAffectedRows,
      duration: duration ?? this.duration,
    );
  }
}
