/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: implementation_imports
// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: non_constant_identifier_names
// ignore_for_file: public_member_api_docs
// ignore_for_file: type_literal_in_constant_pattern
// ignore_for_file: use_super_parameters
// ignore_for_file: invalid_use_of_internal_member

part of 'parent.dart';

abstract class SharedSealedChild extends _i1.SharedSealedParent
    implements _i2.SerializableModel {
  SharedSealedChild._({
    required super.sharedSealedField,
    required this.sharedSealedChildField,
  });

  factory SharedSealedChild({
    required String sharedSealedField,
    required String sharedSealedChildField,
  }) = _SharedSealedChildImpl;

  factory SharedSealedChild.fromJson(Map<String, dynamic> jsonSerialization) {
    return SharedSealedChild(
      sharedSealedField: jsonSerialization['sharedSealedField'] as String,
      sharedSealedChildField:
          jsonSerialization['sharedSealedChildField'] as String,
    );
  }

  String sharedSealedChildField;

  /// Returns a shallow copy of this [SharedSealedChild]
  /// with some or all fields replaced by the given arguments.
  @override
  @_i2.useResult
  SharedSealedChild copyWith({
    String? sharedSealedField,
    String? sharedSealedChildField,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'SharedSealedChild',
      'sharedSealedField': sharedSealedField,
      'sharedSealedChildField': sharedSealedChildField,
    };
  }

  @override
  String toString() {
    return _i2.SerializationManager.encode(this);
  }
}

class _SharedSealedChildImpl extends SharedSealedChild {
  _SharedSealedChildImpl({
    required String sharedSealedField,
    required String sharedSealedChildField,
  }) : super._(
         sharedSealedField: sharedSealedField,
         sharedSealedChildField: sharedSealedChildField,
       );

  /// Returns a shallow copy of this [SharedSealedChild]
  /// with some or all fields replaced by the given arguments.
  @_i2.useResult
  @override
  SharedSealedChild copyWith({
    String? sharedSealedField,
    String? sharedSealedChildField,
  }) {
    return SharedSealedChild(
      sharedSealedField: sharedSealedField ?? this.sharedSealedField,
      sharedSealedChildField:
          sharedSealedChildField ?? this.sharedSealedChildField,
    );
  }
}
