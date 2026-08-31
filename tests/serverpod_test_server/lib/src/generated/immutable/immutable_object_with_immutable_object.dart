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
import '../immutable/immutable_object.dart' as _ib7avg00;

@_is.immutable
abstract class ImmutableObjectWithImmutableObject
    implements _is.SerializableModel, _is.ProtocolSerialization {
  const ImmutableObjectWithImmutableObject._({required this.immutableVariable});

  const factory ImmutableObjectWithImmutableObject({
    required _ib7avg00.ImmutableObject immutableVariable,
  }) = _ImmutableObjectWithImmutableObjectImpl;

  factory ImmutableObjectWithImmutableObject.fromJson(
    Map<String, dynamic> jsonSerialization,
  ) {
    return ImmutableObjectWithImmutableObject(
      immutableVariable: _igqrxdcj.Protocol()
          .deserialize<_ib7avg00.ImmutableObject>(
            jsonSerialization['immutableVariable'],
          ),
    );
  }

  final _ib7avg00.ImmutableObject immutableVariable;

  /// Returns a shallow copy of this [ImmutableObjectWithImmutableObject]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  ImmutableObjectWithImmutableObject copyWith({
    _ib7avg00.ImmutableObject? immutableVariable,
  });
  @override
  bool operator ==(Object other) {
    return identical(
          other,
          this,
        ) ||
        other.runtimeType == runtimeType &&
            other is ImmutableObjectWithImmutableObject &&
            (identical(
                  other.immutableVariable,
                  immutableVariable,
                ) ||
                other.immutableVariable == immutableVariable);
  }

  @override
  int get hashCode {
    return Object.hash(
      runtimeType,
      immutableVariable,
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'ImmutableObjectWithImmutableObject',
      'immutableVariable': immutableVariable.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'ImmutableObjectWithImmutableObject',
      'immutableVariable': immutableVariable.toJsonForProtocol(),
    };
  }

  @override
  String toString() {
    return _is.SerializationManager.encode(this);
  }
}

class _ImmutableObjectWithImmutableObjectImpl
    extends ImmutableObjectWithImmutableObject {
  const _ImmutableObjectWithImmutableObjectImpl({
    required _ib7avg00.ImmutableObject immutableVariable,
  }) : super._(immutableVariable: immutableVariable);

  /// Returns a shallow copy of this [ImmutableObjectWithImmutableObject]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  @override
  ImmutableObjectWithImmutableObject copyWith({
    _ib7avg00.ImmutableObject? immutableVariable,
  }) {
    return ImmutableObjectWithImmutableObject(
      immutableVariable: immutableVariable ?? this.immutableVariable.copyWith(),
    );
  }
}
