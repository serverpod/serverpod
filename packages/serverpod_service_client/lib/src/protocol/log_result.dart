/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: implementation_imports
// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: non_constant_identifier_names
// ignore_for_file: public_member_api_docs
// ignore_for_file: type_literal_in_constant_pattern
// ignore_for_file: use_super_parameters

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:serverpod_client/serverpod_client.dart' as _i1;
import 'log_entry.dart' as _i2;

/// A list of log entries, used to return logging data.
abstract class LogResult implements _i1.SerializableModel {
  LogResult._({required this.entries});

  factory LogResult({required List<_i2.LogEntry> entries}) = _LogResultImpl;

  factory LogResult.fromJson(Map<String, dynamic> jsonSerialization) {
    return LogResult(
        entries: (jsonSerialization['entries'] as List)
            .map((e) => _i2.LogEntry.fromJson((e as Map<String, dynamic>)))
            .toList());
  }

  /// The log entries in this result.
  List<_i2.LogEntry> entries;

  /// Returns a shallow copy of this [LogResult]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  LogResult copyWith({List<_i2.LogEntry>? entries});
  @override
  Map<String, dynamic> toJson() {
    return {'entries': entries.toJson(valueToJson: (v) => v.toJson())};
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _LogResultImpl extends LogResult {
  _LogResultImpl({required List<_i2.LogEntry> entries})
      : super._(entries: entries);

  /// Returns a shallow copy of this [LogResult]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  LogResult copyWith({List<_i2.LogEntry>? entries}) {
    return LogResult(
        entries: entries ?? this.entries.map((e0) => e0.copyWith()).toList());
  }
}
