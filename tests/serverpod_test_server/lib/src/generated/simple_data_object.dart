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
import 'simple_data.dart' as _i0zisc0t;

abstract class SimpleDataObject
    implements _is.SerializableModel, _is.ProtocolSerialization {
  SimpleDataObject._({required this.object});

  factory SimpleDataObject({required _i0zisc0t.SimpleData object}) =
      _SimpleDataObjectImpl;

  factory SimpleDataObject.fromJson(Map<String, dynamic> jsonSerialization) {
    return SimpleDataObject(
      object: _igqrxdcj.Protocol().deserialize<_i0zisc0t.SimpleData>(
        jsonSerialization['object'],
      ),
    );
  }

  _i0zisc0t.SimpleData object;

  /// Returns a shallow copy of this [SimpleDataObject]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  SimpleDataObject copyWith({_i0zisc0t.SimpleData? object});
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'SimpleDataObject',
      'object': object.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'SimpleDataObject',
      'object': object.toJsonForProtocol(),
    };
  }

  @override
  String toString() {
    return _is.SerializationManager.encode(this);
  }
}

class _SimpleDataObjectImpl extends SimpleDataObject {
  _SimpleDataObjectImpl({required _i0zisc0t.SimpleData object})
    : super._(object: object);

  /// Returns a shallow copy of this [SimpleDataObject]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  @override
  SimpleDataObject copyWith({_i0zisc0t.SimpleData? object}) {
    return SimpleDataObject(object: object ?? this.object.copyWith());
  }
}
