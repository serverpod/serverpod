/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: public_member_api_docs
// ignore_for_file: implementation_imports

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:serverpod_client/serverpod_client.dart' as _i1;
import 'protocol.dart' as _i2;
import 'package:collection/collection.dart' as _i3;

class _Undefined {}

/// A list of log entries, used to return logging data.
class LogResult extends _i1.SerializableEntity {
  LogResult({required this.entries});

  factory LogResult.fromJson(
    Map<String, dynamic> jsonSerialization,
    _i1.SerializationManager serializationManager,
  ) {
    return LogResult(
        entries: serializationManager
            .deserialize<List<_i2.LogEntry>>(jsonSerialization['entries']));
  }

  /// The log entries in this result.
  final List<_i2.LogEntry> entries;

  late Function({List<_i2.LogEntry>? entries}) copyWith = _copyWith;

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

  LogResult _copyWith({List<_i2.LogEntry>? entries}) {
    return LogResult(entries: entries ?? this.entries);
  }
}
