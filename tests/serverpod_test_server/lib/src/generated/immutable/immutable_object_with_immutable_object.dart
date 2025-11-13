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
import '../immutable/immutable_object.dart' as _i2;

@_i1.immutable
abstract class ImmutableObjectWithImmutableObject
    implements _i1.SerializableModel, _i1.ProtocolSerialization {
  const ImmutableObjectWithImmutableObject._({required this.immutableVariable});

  const factory ImmutableObjectWithImmutableObject({
    required _i2.ImmutableObject immutableVariable,
  }) = _ImmutableObjectWithImmutableObjectImpl;

  factory ImmutableObjectWithImmutableObject.fromJson(
    Map<String, dynamic> jsonSerialization,
  ) {
    return ImmutableObjectWithImmutableObject(
      immutableVariable: _i2.ImmutableObject.fromJson(
        (jsonSerialization['immutableVariable'] as Map<String, dynamic>),
      ),
    );
  }

  final _i2.ImmutableObject immutableVariable;

  /// Returns a shallow copy of this [ImmutableObjectWithImmutableObject]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  ImmutableObjectWithImmutableObject copyWith({
    _i2.ImmutableObject? immutableVariable,
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
    return {'immutableVariable': immutableVariable.toJson()};
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {'immutableVariable': immutableVariable.toJsonForProtocol()};
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _ImmutableObjectWithImmutableObjectImpl
    extends ImmutableObjectWithImmutableObject {
  const _ImmutableObjectWithImmutableObjectImpl({
    required _i2.ImmutableObject immutableVariable,
  }) : super._(immutableVariable: immutableVariable);

  /// Returns a shallow copy of this [ImmutableObjectWithImmutableObject]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  ImmutableObjectWithImmutableObject copyWith({
    _i2.ImmutableObject? immutableVariable,
  }) {
    return ImmutableObjectWithImmutableObject(
      immutableVariable: immutableVariable ?? this.immutableVariable.copyWith(),
    );
  }
}
