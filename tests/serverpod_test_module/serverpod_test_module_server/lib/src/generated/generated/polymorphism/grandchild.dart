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
import '../../protocol.dart' as _iototaiw;

/// A grandchild class.
abstract class ModulePolymorphicGrandChild
    extends _iototaiw.ModulePolymorphicChild
    implements _is.SerializableModel, _is.ProtocolSerialization {
  ModulePolymorphicGrandChild._({
    required super.parent,
    required super.child,
    required this.grandchild,
  });

  factory ModulePolymorphicGrandChild({
    required String parent,
    required String child,
    required String grandchild,
  }) = _ModulePolymorphicGrandChildImpl;

  factory ModulePolymorphicGrandChild.fromJson(
    Map<String, dynamic> jsonSerialization,
  ) {
    return ModulePolymorphicGrandChild(
      parent: jsonSerialization['parent'] as String,
      child: jsonSerialization['child'] as String,
      grandchild: jsonSerialization['grandchild'] as String,
    );
  }

  /// The grandchild field.
  String grandchild;

  /// Returns a shallow copy of this [ModulePolymorphicGrandChild]
  /// with some or all fields replaced by the given arguments.
  @override
  @_is.useResult
  ModulePolymorphicGrandChild copyWith({
    String? parent,
    String? child,
    String? grandchild,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'serverpod_test_module.ModulePolymorphicGrandChild',
      'parent': parent,
      'child': child,
      'grandchild': grandchild,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'serverpod_test_module.ModulePolymorphicGrandChild',
      'parent': parent,
      'child': child,
      'grandchild': grandchild,
    };
  }

  @override
  String toString() {
    return _is.SerializationManager.encode(this);
  }
}

class _ModulePolymorphicGrandChildImpl extends ModulePolymorphicGrandChild {
  _ModulePolymorphicGrandChildImpl({
    required String parent,
    required String child,
    required String grandchild,
  }) : super._(
         parent: parent,
         child: child,
         grandchild: grandchild,
       );

  /// Returns a shallow copy of this [ModulePolymorphicGrandChild]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  @override
  ModulePolymorphicGrandChild copyWith({
    String? parent,
    String? child,
    String? grandchild,
  }) {
    return ModulePolymorphicGrandChild(
      parent: parent ?? this.parent,
      child: child ?? this.child,
      grandchild: grandchild ?? this.grandchild,
    );
  }
}
