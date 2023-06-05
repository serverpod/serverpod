/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: public_member_api_docs
// ignore_for_file: implementation_imports

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:serverpod/serverpod.dart' as _i1;
import 'protocol.dart' as _i2;
import 'package:collection/collection.dart' as _i3;

class _Undefined {}

/// A list of SessionLogInfo.
class SessionLogResult extends _i1.SerializableEntity {
  SessionLogResult({required this.sessionLog});

  factory SessionLogResult.fromJson(
    Map<String, dynamic> jsonSerialization,
    _i1.SerializationManager serializationManager,
  ) {
    return SessionLogResult(
        sessionLog: serializationManager.deserialize<List<_i2.SessionLogInfo>>(
            jsonSerialization['sessionLog']));
  }

  /// The list of SessionLogInfo.
  final List<_i2.SessionLogInfo> sessionLog;

  late Function({List<_i2.SessionLogInfo>? sessionLog}) copyWith = _copyWith;

  @override
  Map<String, dynamic> toJson() {
    return {'sessionLog': sessionLog};
  }

  @override
  bool operator ==(dynamic other) {
    return identical(
          this,
          other,
        ) ||
        (other is SessionLogResult &&
            const _i3.DeepCollectionEquality().equals(
              sessionLog,
              other.sessionLog,
            ));
  }

  @override
  int get hashCode => const _i3.DeepCollectionEquality().hash(sessionLog);

  SessionLogResult _copyWith({List<_i2.SessionLogInfo>? sessionLog}) {
    return SessionLogResult(sessionLog: sessionLog ?? this.sessionLog);
  }
}
