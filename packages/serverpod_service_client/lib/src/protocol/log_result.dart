/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: public_member_api_docs
// ignore_for_file: implementation_imports

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:serverpod_client/serverpod_client.dart' as _i1;
import 'protocol.dart' as _i2;
import 'package:collection/collection.dart' as _i3;

/// A list of log entries, used to return logging data.
abstract class LogResult extends _i1.SerializableEntity {
  const LogResult._();

  const factory LogResult({required List<_i2.LogEntry> entries}) = _LogResult;

  factory LogResult.fromJson(
    Map<String, dynamic> jsonSerialization,
    _i1.SerializationManager serializationManager,
  ) {
    return LogResult(
        entries: serializationManager
            .deserialize<List<_i2.LogEntry>>(jsonSerialization['entries']));
  }

  LogResult copyWith({List<_i2.LogEntry>? entries});

  /// The log entries in this result.
  List<_i2.LogEntry> get entries;
}

/// A list of log entries, used to return logging data.
class _LogResult extends LogResult {
  const _LogResult({required this.entries}) : super._();

  /// The log entries in this result.
  @override
  final List<_i2.LogEntry> entries;

  @override
  Map<String, dynamic> toJson() {
    return {'entries': entries};
  }

  @override
  bool operator ==(dynamic other) {
    return identical(
          this,
          other,
        ) ||
        (other is LogResult &&
            const _i3.DeepCollectionEquality().equals(
              entries,
              other.entries,
            ));
  }

  @override
  int get hashCode => const _i3.DeepCollectionEquality().hash(entries);

  @override
  LogResult copyWith({List<_i2.LogEntry>? entries}) {
    return LogResult(entries: entries ?? this.entries);
  }
}
