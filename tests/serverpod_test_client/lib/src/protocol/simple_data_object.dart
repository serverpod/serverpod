/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: implementation_imports
// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: non_constant_identifier_names
// ignore_for_file: public_member_api_docs
// ignore_for_file: type_literal_in_constant_pattern
// ignore_for_file: use_super_parameters

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:serverpod_client/serverpod_client.dart' as _i1;
import 'simple_data.dart' as _i2;

abstract class SimpleDataObject implements _i1.SerializableModel {
  SimpleDataObject._({required this.object});

  factory SimpleDataObject({required _i2.SimpleData object}) =
      _SimpleDataObjectImpl;

  factory SimpleDataObject.fromJson(Map<String, dynamic> jsonSerialization) {
    return SimpleDataObject(
        object: _i2.SimpleData.fromJson(
            (jsonSerialization['object'] as Map<String, dynamic>)));
  }

  _i2.SimpleData object;

  /// Returns a shallow copy of this [SimpleDataObject]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  SimpleDataObject copyWith({_i2.SimpleData? object});
  @override
  Map<String, dynamic> toJson() {
    return {'object': object.toJson()};
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _SimpleDataObjectImpl extends SimpleDataObject {
  _SimpleDataObjectImpl({required _i2.SimpleData object})
      : super._(object: object);

  /// Returns a shallow copy of this [SimpleDataObject]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  SimpleDataObject copyWith({_i2.SimpleData? object}) {
    return SimpleDataObject(object: object ?? this.object.copyWith());
  }
}
