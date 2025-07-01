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
import 'auth_session_info.dart' as _i2;
import 'auth_success.dart' as _i3;
import 'package:serverpod_auth_user_client/serverpod_auth_user_client.dart'
    as _i4;
export 'auth_session_info.dart';
export 'auth_success.dart';
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
    if (t == _i2.AuthSessionInfo) {
      return _i2.AuthSessionInfo.fromJson(data) as T;
    }
    if (t == _i3.AuthSuccess) {
      return _i3.AuthSuccess.fromJson(data) as T;
    }
    if (t == _i1.getType<_i2.AuthSessionInfo?>()) {
      return (data != null ? _i2.AuthSessionInfo.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i3.AuthSuccess?>()) {
      return (data != null ? _i3.AuthSuccess.fromJson(data) : null) as T;
    }
    if (t == Set<String>) {
      return (data as List).map((e) => deserialize<String>(e)).toSet() as T;
    }
    try {
      return _i4.Protocol().deserialize<T>(data, t);
    } on _i1.DeserializationTypeNotFoundException catch (_) {}
    return super.deserialize<T>(data, t);
  }

  @override
  String? getClassNameForObject(Object? data) {
    String? className = super.getClassNameForObject(data);
    if (className != null) return className;
    switch (data) {
      case _i2.AuthSessionInfo():
        return 'AuthSessionInfo';
      case _i3.AuthSuccess():
        return 'AuthSuccess';
    }
    className = _i4.Protocol().getClassNameForObject(data);
    if (className != null) {
      return 'serverpod_auth_user.$className';
    }
    return null;
  }

  @override
  dynamic deserializeByClassName(Map<String, dynamic> data) {
    var dataClassName = data['className'];
    if (dataClassName is! String) {
      return super.deserializeByClassName(data);
    }
    if (dataClassName == 'AuthSessionInfo') {
      return deserialize<_i2.AuthSessionInfo>(data['data']);
    }
    if (dataClassName == 'AuthSuccess') {
      return deserialize<_i3.AuthSuccess>(data['data']);
    }
    if (dataClassName.startsWith('serverpod_auth_user.')) {
      data['className'] = dataClassName.substring(20);
      return _i4.Protocol().deserializeByClassName(data);
    }
    return super.deserializeByClassName(data);
  }
}
