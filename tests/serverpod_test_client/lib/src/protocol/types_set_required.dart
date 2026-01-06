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
import 'package:serverpod_client/serverpod_client.dart' as _i1;
import 'package:serverpod_test_client/src/protocol/protocol.dart' as _i2;

abstract class TypesSetRequired implements _i1.SerializableModel {
  TypesSetRequired._({required this.anInt});

  factory TypesSetRequired({required Set<int> anInt}) = _TypesSetRequiredImpl;

  factory TypesSetRequired.fromJson(Map<String, dynamic> jsonSerialization) {
    return TypesSetRequired(
      anInt: _i2.Protocol().deserialize<Set<int>>(jsonSerialization['anInt']),
    );
  }

  Set<int> anInt;

  /// Returns a shallow copy of this [TypesSetRequired]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  TypesSetRequired copyWith({Set<int>? anInt});
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'TypesSetRequired',
      'anInt': anInt.toJson(),
    };
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _TypesSetRequiredImpl extends TypesSetRequired {
  _TypesSetRequiredImpl({required Set<int> anInt}) : super._(anInt: anInt);

  /// Returns a shallow copy of this [TypesSetRequired]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  TypesSetRequired copyWith({Set<int>? anInt}) {
    return TypesSetRequired(anInt: anInt ?? this.anInt.map((e0) => e0).toSet());
  }
}
