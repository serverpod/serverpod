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
abstract class ImmutableChildObjectWithNoAdditionalFields
    extends _i2.ImmutableObject implements _i1.SerializableModel {
  const ImmutableChildObjectWithNoAdditionalFields._({required super.variable});

  const factory ImmutableChildObjectWithNoAdditionalFields(
          {required String variable}) =
      _ImmutableChildObjectWithNoAdditionalFieldsImpl;

  factory ImmutableChildObjectWithNoAdditionalFields.fromJson(
      Map<String, dynamic> jsonSerialization) {
    return ImmutableChildObjectWithNoAdditionalFields(
        variable: jsonSerialization['variable'] as String);
  }

  /// Returns a shallow copy of this [ImmutableChildObjectWithNoAdditionalFields]
  /// with some or all fields replaced by the given arguments.
  @override
  @_i1.useResult
  ImmutableChildObjectWithNoAdditionalFields copyWith({String? variable});
  @override
  bool operator ==(Object other) {
    return identical(
          other,
          this,
        ) ||
        other.runtimeType == runtimeType &&
            other is ImmutableChildObjectWithNoAdditionalFields &&
            (identical(
                  other.variable,
                  variable,
                ) ||
                other.variable == variable);
  }

  @override
  int get hashCode {
    return Object.hash(
      runtimeType,
      variable,
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {'variable': variable};
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _ImmutableChildObjectWithNoAdditionalFieldsImpl
    extends ImmutableChildObjectWithNoAdditionalFields {
  const _ImmutableChildObjectWithNoAdditionalFieldsImpl(
      {required String variable})
      : super._(variable: variable);

  /// Returns a shallow copy of this [ImmutableChildObjectWithNoAdditionalFields]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  ImmutableChildObjectWithNoAdditionalFields copyWith({String? variable}) {
    return ImmutableChildObjectWithNoAdditionalFields(
        variable: variable ?? this.variable);
  }
}
