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
import 'package:serverpod/serverpod.dart' as _i1;
import 'package:serverpod_test_server/src/generated/protocol.dart' as _i2;

abstract class Record
    implements _i1.SerializableModel, _i1.ProtocolSerialization {
  Record._({this.aBoolRecord});

  factory Record({(bool,)? aBoolRecord}) = _RecordImpl;

  factory Record.fromJson(Map<String, dynamic> jsonSerialization) {
    return Record(
        aBoolRecord: jsonSerialization['aBoolRecord'] == null
            ? null
            : _i2.Protocol().deserialize<(bool,)?>(
                (jsonSerialization['aBoolRecord'] as Map<String, dynamic>)));
  }

  (bool,)? aBoolRecord;

  /// Returns a shallow copy of this [Record]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  Record copyWith({(bool,)? aBoolRecord});
  @override
  Map<String, dynamic> toJson() {
    return {
      if (aBoolRecord != null) 'aBoolRecord': _i2.mapRecordToJson(aBoolRecord)
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      if (aBoolRecord != null) 'aBoolRecord': _i2.mapRecordToJson(aBoolRecord)
    };
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _RecordImpl extends Record {
  _RecordImpl({(bool,)? aBoolRecord}) : super._(aBoolRecord: aBoolRecord);

  /// Returns a shallow copy of this [Record]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  Record copyWith({Object? aBoolRecord = _Undefined}) {
    return Record(
        aBoolRecord: aBoolRecord is (bool,)?
            ? aBoolRecord
            : this.aBoolRecord == null
                ? null
                : (this.aBoolRecord!.$1,));
  }
}
