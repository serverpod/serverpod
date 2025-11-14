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
import '../../protocol.dart' as _i1;
import 'package:serverpod/serverpod.dart' as _i2;

/// A child class.
class ModulePolymorphicChild extends _i1.ModulePolymorphicParent
    implements _i2.SerializableModel, _i2.ProtocolSerialization {
  ModulePolymorphicChild({
    required super.parent,
    required this.child,
  });

  factory ModulePolymorphicChild.fromJson(
    Map<String, dynamic> jsonSerialization,
  ) {
    return ModulePolymorphicChild(
      parent: jsonSerialization['parent'] as String,
      child: jsonSerialization['child'] as String,
    );
  }

  /// The child field.
  String child;

  /// Returns a shallow copy of this [ModulePolymorphicChild]
  /// with some or all fields replaced by the given arguments.
  @_i2.useResult
  ModulePolymorphicChild copyWith({
    String? parent,
    String? child,
  }) {
    return ModulePolymorphicChild(
      parent: parent ?? this.parent,
      child: child ?? this.child,
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'parent': parent,
      'child': child,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      'parent': parent,
      'child': child,
    };
  }

  @override
  String toString() {
    return _i2.SerializationManager.encode(this);
  }
}
