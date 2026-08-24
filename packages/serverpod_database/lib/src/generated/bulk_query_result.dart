/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: implementation_imports
// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: non_constant_identifier_names
// ignore_for_file: public_member_api_docs
// ignore_for_file: type_literal_in_constant_pattern
// ignore_for_file: use_super_parameters
// ignore_for_file: invalid_use_of_internal_member

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:serverpod_database/serverpod_database.dart' as _isd;
import 'package:serverpod_serialization/serverpod_serialization.dart' as _iss;

abstract class BulkQueryResult
    implements _iss.SerializableModel, _iss.ProtocolSerialization {
  BulkQueryResult._({
    required this.headers,
    required this.data,
    required this.numAffectedRows,
    required this.duration,
  });

  factory BulkQueryResult({
    required List<_isd.BulkQueryColumnDescription> headers,
    required String data,
    required int numAffectedRows,
    required Duration duration,
  }) = _BulkQueryResultImpl;

  factory BulkQueryResult.fromJson(Map<String, dynamic> jsonSerialization) {
    return BulkQueryResult(
      headers: _isd.Protocol()
          .deserialize<List<_isd.BulkQueryColumnDescription>>(
            jsonSerialization['headers'],
          ),
      data: jsonSerialization['data'] as String,
      numAffectedRows: jsonSerialization['numAffectedRows'] as int,
      duration: _iss.DurationJsonExtension.fromJson(
        jsonSerialization['duration'],
      ),
    );
  }

  List<_isd.BulkQueryColumnDescription> headers;

  String data;

  int numAffectedRows;

  Duration duration;

  /// Returns a shallow copy of this [BulkQueryResult]
  /// with some or all fields replaced by the given arguments.
  @_iss.useResult
  BulkQueryResult copyWith({
    List<_isd.BulkQueryColumnDescription>? headers,
    String? data,
    int? numAffectedRows,
    Duration? duration,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'serverpod.BulkQueryResult',
      'headers': headers.toJson(valueToJson: (v) => v.toJson()),
      'data': data,
      'numAffectedRows': numAffectedRows,
      'duration': duration.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'serverpod.BulkQueryResult',
      'headers': headers.toJson(valueToJson: (v) => v.toJsonForProtocol()),
      'data': data,
      'numAffectedRows': numAffectedRows,
      'duration': duration.toJson(),
    };
  }

  @override
  String toString() {
    return _iss.SerializationManager.encode(this);
  }
}

class _BulkQueryResultImpl extends BulkQueryResult {
  _BulkQueryResultImpl({
    required List<_isd.BulkQueryColumnDescription> headers,
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
  @_iss.useResult
  @override
  BulkQueryResult copyWith({
    List<_isd.BulkQueryColumnDescription>? headers,
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
