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
import 'package:serverpod/serverpod.dart' as _is;
import 'package:serverpod/src/generated/protocol.dart' as _ic00rqxb;
import 'log_entry.dart' as _iv7ld46g;

/// A list of log entries, used to return logging data.
abstract class LogResult
    implements _is.SerializableModel, _is.ProtocolSerialization {
  LogResult._({required this.entries});

  factory LogResult({required List<_iv7ld46g.LogEntry> entries}) =
      _LogResultImpl;

  factory LogResult.fromJson(Map<String, dynamic> jsonSerialization) {
    return LogResult(
      entries: _ic00rqxb.Protocol().deserialize<List<_iv7ld46g.LogEntry>>(
        jsonSerialization['entries'],
      ),
    );
  }

  /// The log entries in this result.
  List<_iv7ld46g.LogEntry> entries;

  /// Returns a shallow copy of this [LogResult]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  LogResult copyWith({List<_iv7ld46g.LogEntry>? entries});
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'serverpod.LogResult',
      'entries': entries.toJson(valueToJson: (v) => v.toJson()),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'serverpod.LogResult',
      'entries': entries.toJson(valueToJson: (v) => v.toJsonForProtocol()),
    };
  }

  @override
  String toString() {
    return _is.SerializationManager.encode(this);
  }
}

class _LogResultImpl extends LogResult {
  _LogResultImpl({required List<_iv7ld46g.LogEntry> entries})
    : super._(entries: entries);

  /// Returns a shallow copy of this [LogResult]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  @override
  LogResult copyWith({List<_iv7ld46g.LogEntry>? entries}) {
    return LogResult(
      entries: entries ?? this.entries.map((e0) => e0.copyWith()).toList(),
    );
  }
}
