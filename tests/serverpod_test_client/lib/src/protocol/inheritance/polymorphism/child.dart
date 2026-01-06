/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: implementation_imports
// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: non_constant_identifier_names
// ignore_for_file: public_member_api_docs
// ignore_for_file: type_literal_in_constant_pattern
// ignore_for_file: use_super_parameters
// ignore_for_file: invalid_use_of_internal_member
// ignore_for_file: deprecated_member_use_from_same_package

// ignore_for_file: no_leading_underscores_for_library_prefixes
import '../../protocol.dart' as _i1;
import 'package:serverpod_client/serverpod_client.dart' as _i2;

/// A child class.
class PolymorphicChild extends _i1.PolymorphicParent
    implements _i2.SerializableModel {
  PolymorphicChild({
    required super.parent,
    required this.child,
  });

  factory PolymorphicChild.fromJson(Map<String, dynamic> jsonSerialization) {
    return PolymorphicChild(
      parent: jsonSerialization['parent'] as String,
      child: jsonSerialization['child'] as String,
    );
  }

  /// The child field.
  String child;

  /// Returns a shallow copy of this [PolymorphicChild]
  /// with some or all fields replaced by the given arguments.
  @_i2.useResult
  PolymorphicChild copyWith({
    String? parent,
    String? child,
  }) {
    return PolymorphicChild(
      parent: parent ?? this.parent,
      child: child ?? this.child,
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'PolymorphicChild',
      'parent': parent,
      'child': child,
    };
  }

  @override
  String toString() {
    return _i2.SerializationManager.encode(this);
  }
}
