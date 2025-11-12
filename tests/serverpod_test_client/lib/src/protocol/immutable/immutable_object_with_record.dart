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
import 'package:serverpod_client/serverpod_client.dart' as _i1;
import 'package:serverpod_test_client/src/protocol/protocol.dart' as _i2;

@_i1.immutable
abstract class ImmutableObjectWithRecord implements _i1.SerializableModel {
  const ImmutableObjectWithRecord._({required this.recordVariable});

  const factory ImmutableObjectWithRecord(
      {required (int, String) recordVariable}) = _ImmutableObjectWithRecordImpl;

  factory ImmutableObjectWithRecord.fromJson(
      Map<String, dynamic> jsonSerialization) {
    return ImmutableObjectWithRecord(
        recordVariable: _i2.Protocol().deserialize<(int, String)>(
            (jsonSerialization['recordVariable'] as Map<String, dynamic>)));
  }

  final (int, String) recordVariable;

  /// Returns a shallow copy of this [ImmutableObjectWithRecord]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  ImmutableObjectWithRecord copyWith({(int, String)? recordVariable});
  @override
  bool operator ==(Object other) {
    return identical(
          other,
          this,
        ) ||
        other.runtimeType == runtimeType &&
            other is ImmutableObjectWithRecord &&
            (identical(
                  other.recordVariable,
                  recordVariable,
                ) ||
                other.recordVariable == recordVariable);
  }

  @override
  int get hashCode {
    return Object.hash(
      runtimeType,
      recordVariable,
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {'recordVariable': _i2.mapRecordToJson(recordVariable)};
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _ImmutableObjectWithRecordImpl extends ImmutableObjectWithRecord {
  const _ImmutableObjectWithRecordImpl({required (int, String) recordVariable})
      : super._(recordVariable: recordVariable);

  /// Returns a shallow copy of this [ImmutableObjectWithRecord]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  ImmutableObjectWithRecord copyWith({(int, String)? recordVariable}) {
    return ImmutableObjectWithRecord(
        recordVariable: recordVariable ??
            (
              this.recordVariable.$1,
              this.recordVariable.$2,
            ));
  }
}
