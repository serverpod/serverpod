/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: implementation_imports
// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: non_constant_identifier_names
// ignore_for_file: public_member_api_docs
// ignore_for_file: type_literal_in_constant_pattern
// ignore_for_file: use_super_parameters

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:serverpod/serverpod.dart' as _i1;
import '../database/bulk_query_column_description.dart' as _i2;

abstract class BulkQueryResult
    implements _i1.SerializableModel, _i1.ProtocolSerialization {
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

  factory BulkQueryResult.fromJson(Map<String, dynamic> jsonSerialization) {
    return BulkQueryResult(
      headers: (jsonSerialization['headers'] as List)
          .map((e) => _i2.BulkQueryColumnDescription.fromJson(
              (e as Map<String, dynamic>)))
          .toList(),
      data: jsonSerialization['data'] as String,
      numAffectedRows: jsonSerialization['numAffectedRows'] as int,
      duration:
          _i1.DurationJsonExtension.fromJson(jsonSerialization['duration']),
    );
  }

  List<_i2.BulkQueryColumnDescription> headers;

  String data;

  int numAffectedRows;

  Duration duration;

  /// Returns a shallow copy of this [BulkQueryResult]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  BulkQueryResult copyWith({
    List<_i2.BulkQueryColumnDescription>? headers,
    String? data,
    int? numAffectedRows,
    Duration? duration,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      'headers': headers.toJson(valueToJson: (v) => v.toJson()),
      'data': data,
      'numAffectedRows': numAffectedRows,
      'duration': duration.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      'headers': headers.toJson(valueToJson: (v) => v.toJsonForProtocol()),
      'data': data,
      'numAffectedRows': numAffectedRows,
      'duration': duration.toJson(),
    };
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
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

  /// Returns a shallow copy of this [BulkQueryResult]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  BulkQueryResult copyWith({
    List<_i2.BulkQueryColumnDescription>? headers,
    String? data,
    int? numAffectedRows,
    Duration? duration,
  }) {
    return BulkQueryResult(
      headers: headers ?? this.headers.map((e0) => e0.copyWith()).toList(),
      data: data ?? this.data,
      numAffectedRows: numAffectedRows ?? this.numAffectedRows,
      duration: duration ?? this.duration,
    );
  }
}
