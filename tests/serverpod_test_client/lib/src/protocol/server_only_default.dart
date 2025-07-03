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

abstract class ServerOnlyDefault implements _i1.SerializableModel {
  ServerOnlyDefault._({required this.normalField});

  factory ServerOnlyDefault({required String normalField}) =
      _ServerOnlyDefaultImpl;

  factory ServerOnlyDefault.fromJson(Map<String, dynamic> jsonSerialization) {
    return ServerOnlyDefault(
        normalField: jsonSerialization['normalField'] as String);
  }

  String normalField;

  /// Returns a shallow copy of this [ServerOnlyDefault]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  ServerOnlyDefault copyWith({String? normalField});
  @override
  Map<String, dynamic> toJson() {
    return {'normalField': normalField};
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _ServerOnlyDefaultImpl extends ServerOnlyDefault {
  _ServerOnlyDefaultImpl({required String normalField})
      : super._(normalField: normalField);

  /// Returns a shallow copy of this [ServerOnlyDefault]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  ServerOnlyDefault copyWith({String? normalField}) {
    return ServerOnlyDefault(normalField: normalField ?? this.normalField);
  }
}
