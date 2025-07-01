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
import 'auth_user_blocked_exception.dart' as _i2;
import 'auth_user_model.dart' as _i3;
import 'auth_user_not_found_exception.dart' as _i4;
export 'auth_user_blocked_exception.dart';
export 'auth_user_model.dart';
export 'auth_user_not_found_exception.dart';
export 'client.dart';

class Protocol extends _i1.SerializationManager {
  Protocol._();

  factory Protocol() => _instance;

  static final Protocol _instance = Protocol._();

  @override
  T deserialize<T>(
    dynamic data, [
    Type? t,
  ]) {
    t ??= T;
    if (t == _i2.AuthUserBlockedException) {
      return _i2.AuthUserBlockedException.fromJson(data) as T;
    }
    if (t == _i3.AuthUserModel) {
      return _i3.AuthUserModel.fromJson(data) as T;
    }
    if (t == _i4.AuthUserNotFoundException) {
      return _i4.AuthUserNotFoundException.fromJson(data) as T;
    }
    if (t == _i1.getType<_i2.AuthUserBlockedException?>()) {
      return (data != null ? _i2.AuthUserBlockedException.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i3.AuthUserModel?>()) {
      return (data != null ? _i3.AuthUserModel.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i4.AuthUserNotFoundException?>()) {
      return (data != null
          ? _i4.AuthUserNotFoundException.fromJson(data)
          : null) as T;
    }
    if (t == Set<String>) {
      return (data as List).map((e) => deserialize<String>(e)).toSet() as T;
    }
    return super.deserialize<T>(data, t);
  }

  @override
  String? getClassNameForObject(Object? data) {
    String? className = super.getClassNameForObject(data);
    if (className != null) return className;
    switch (data) {
      case _i2.AuthUserBlockedException():
        return 'AuthUserBlockedException';
      case _i3.AuthUserModel():
        return 'AuthUserModel';
      case _i4.AuthUserNotFoundException():
        return 'AuthUserNotFoundException';
    }
    return null;
  }

  @override
  dynamic deserializeByClassName(Map<String, dynamic> data) {
    var dataClassName = data['className'];
    if (dataClassName is! String) {
      return super.deserializeByClassName(data);
    }
    if (dataClassName == 'AuthUserBlockedException') {
      return deserialize<_i2.AuthUserBlockedException>(data['data']);
    }
    if (dataClassName == 'AuthUserModel') {
      return deserialize<_i3.AuthUserModel>(data['data']);
    }
    if (dataClassName == 'AuthUserNotFoundException') {
      return deserialize<_i4.AuthUserNotFoundException>(data['data']);
    }
    return super.deserializeByClassName(data);
  }
}
