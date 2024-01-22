/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: public_member_api_docs
// ignore_for_file: implementation_imports
// ignore_for_file: use_super_parameters
// ignore_for_file: type_literal_in_constant_pattern

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:serverpod_client/serverpod_client.dart' as _i1;
import 'protocol.dart' as _i2;
import 'package:serverpod_serialization/serverpod_serialization.dart';

abstract class SimpleDataObject extends _i1.SerializableEntity {
  SimpleDataObject._({required this.object});

  factory SimpleDataObject({required _i2.SimpleData object}) =
      _SimpleDataObjectImpl;

  factory SimpleDataObject.fromJson(
    Map<String, dynamic> jsonSerialization,
    _i1.SerializationManager serializationManager,
  ) {
    return SimpleDataObject(
        object: serializationManager
            .deserialize<_i2.SimpleData>(jsonSerialization['object']));
  }

  _i2.SimpleData object;

  SimpleDataObject copyWith({_i2.SimpleData? object});
  @override
  Map<String, dynamic> toJson() {
    return {'object': object.toJson()};
  }
}

class _SimpleDataObjectImpl extends SimpleDataObject {
  _SimpleDataObjectImpl({required _i2.SimpleData object})
      : super._(object: object);

  @override
  SimpleDataObject copyWith({_i2.SimpleData? object}) {
    return SimpleDataObject(object: object ?? this.object.copyWith());
  }
}
