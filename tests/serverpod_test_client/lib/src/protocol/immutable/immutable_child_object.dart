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
import '../protocol.dart' as _i2;

@_i1.immutable
abstract class ImmutableChildObject extends _i2.ImmutableObject
    implements _i1.SerializableModel {
  const ImmutableChildObject._({
    required super.variable,
    required this.childVariable,
  });

  const factory ImmutableChildObject({
    required String variable,
    required String childVariable,
  }) = _ImmutableChildObjectImpl;

  factory ImmutableChildObject.fromJson(
      Map<String, dynamic> jsonSerialization) {
    return ImmutableChildObject(
      variable: jsonSerialization['variable'] as String,
      childVariable: jsonSerialization['childVariable'] as String,
    );
  }

  final String childVariable;

  /// Returns a shallow copy of this [ImmutableChildObject]
  /// with some or all fields replaced by the given arguments.
  @override
  @_i1.useResult
  ImmutableChildObject copyWith({
    String? variable,
    String? childVariable,
  });
  @override
  bool operator ==(Object other) {
    return identical(
          other,
          this,
        ) ||
        other.runtimeType == runtimeType &&
            other is ImmutableChildObject &&
            (identical(
                  other.variable,
                  variable,
                ) ||
                other.variable == variable) &&
            (identical(
                  other.childVariable,
                  childVariable,
                ) ||
                other.childVariable == childVariable);
  }

  @override
  int get hashCode {
    return Object.hash(
      runtimeType,
      variable,
      childVariable,
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'variable': variable,
      'childVariable': childVariable,
    };
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _ImmutableChildObjectImpl extends ImmutableChildObject {
  const _ImmutableChildObjectImpl({
    required String variable,
    required String childVariable,
  }) : super._(
          variable: variable,
          childVariable: childVariable,
        );

  /// Returns a shallow copy of this [ImmutableChildObject]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  ImmutableChildObject copyWith({
    String? variable,
    String? childVariable,
  }) {
    return ImmutableChildObject(
      variable: variable ?? this.variable,
      childVariable: childVariable ?? this.childVariable,
    );
  }
}
