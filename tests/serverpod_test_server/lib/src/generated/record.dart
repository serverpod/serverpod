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
import 'package:serverpod_test_server/src/generated/protocol.dart' as _igqrxdcj;

abstract class Record
    implements _is.SerializableModel, _is.ProtocolSerialization {
  Record._({this.aBoolRecord});

  factory Record({(bool,)? aBoolRecord}) = _RecordImpl;

  factory Record.fromJson(Map<String, dynamic> jsonSerialization) {
    return Record(
      aBoolRecord: jsonSerialization['aBoolRecord'] == null
          ? null
          : _igqrxdcj.Protocol().deserialize<(bool,)?>(
              (jsonSerialization['aBoolRecord'] as Map<String, dynamic>),
            ),
    );
  }

  (bool,)? aBoolRecord;

  /// Returns a shallow copy of this [Record]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  Record copyWith({(bool,)? aBoolRecord});
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'Record',
      if (aBoolRecord != null)
        'aBoolRecord': _igqrxdcj.Protocol().mapRecordToJson(aBoolRecord),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'Record',
      if (aBoolRecord != null)
        'aBoolRecord': _igqrxdcj.Protocol().mapRecordToJson(aBoolRecord),
    };
  }

  @override
  String toString() {
    return _is.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _RecordImpl extends Record {
  _RecordImpl({(bool,)? aBoolRecord}) : super._(aBoolRecord: aBoolRecord);

  /// Returns a shallow copy of this [Record]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  @override
  Record copyWith({Object? aBoolRecord = _Undefined}) {
    return Record(
      aBoolRecord: aBoolRecord is (bool,)?
          ? aBoolRecord
          : this.aBoolRecord == null
          ? null
          : (this.aBoolRecord!.$1,),
    );
  }
}
