/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: public_member_api_docs
// ignore_for_file: implementation_imports
// ignore_for_file: use_super_parameters
// ignore_for_file: type_literal_in_constant_pattern

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:serverpod_client/serverpod_client.dart' as _i1;

abstract class ServerOnlyClassField extends _i1.SerializableEntity {
  ServerOnlyClassField._();

  factory ServerOnlyClassField() = _ServerOnlyClassFieldImpl;

  factory ServerOnlyClassField.fromJson(
      Map<String, dynamic> jsonSerialization) {
    return ServerOnlyClassField();
  }

  ServerOnlyClassField copyWith();
  @override
  Map<String, dynamic> toJson() {
    return {};
  }
}

class _ServerOnlyClassFieldImpl extends ServerOnlyClassField {
  _ServerOnlyClassFieldImpl() : super._();

  @override
  ServerOnlyClassField copyWith() {
    return ServerOnlyClassField();
  }
}
