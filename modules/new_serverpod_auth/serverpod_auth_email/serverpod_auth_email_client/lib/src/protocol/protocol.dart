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
import 'module_class.dart' as _i2;
import 'package:serverpod_auth_email_account_client/serverpod_auth_email_account_client.dart'
    as _i3;
import 'package:serverpod_auth_profile_client/serverpod_auth_profile_client.dart'
    as _i4;
import 'package:serverpod_auth_session_client/serverpod_auth_session_client.dart'
    as _i5;
import 'package:serverpod_auth_user_client/serverpod_auth_user_client.dart'
    as _i6;
export 'module_class.dart';
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
    if (t == _i2.ModuleClass) {
      return _i2.ModuleClass.fromJson(data) as T;
    }
    if (t == _i1.getType<_i2.ModuleClass?>()) {
      return (data != null ? _i2.ModuleClass.fromJson(data) : null) as T;
    }
    try {
      return _i3.Protocol().deserialize<T>(data, t);
    } on _i1.DeserializationTypeNotFoundException catch (_) {}
    try {
      return _i4.Protocol().deserialize<T>(data, t);
    } on _i1.DeserializationTypeNotFoundException catch (_) {}
    try {
      return _i5.Protocol().deserialize<T>(data, t);
    } on _i1.DeserializationTypeNotFoundException catch (_) {}
    try {
      return _i6.Protocol().deserialize<T>(data, t);
    } on _i1.DeserializationTypeNotFoundException catch (_) {}
    return super.deserialize<T>(data, t);
  }

  @override
  String? getClassNameForObject(Object? data) {
    String? className = super.getClassNameForObject(data);
    if (className != null) return className;
    if (data is _i2.ModuleClass) {
      return 'ModuleClass';
    }
    className = _i3.Protocol().getClassNameForObject(data);
    if (className != null) {
      return 'serverpod_auth_email_account.$className';
    }
    className = _i4.Protocol().getClassNameForObject(data);
    if (className != null) {
      return 'serverpod_auth_profile.$className';
    }
    className = _i5.Protocol().getClassNameForObject(data);
    if (className != null) {
      return 'serverpod_auth_session.$className';
    }
    className = _i6.Protocol().getClassNameForObject(data);
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
    if (dataClassName == 'ModuleClass') {
      return deserialize<_i2.ModuleClass>(data['data']);
    }
    if (dataClassName.startsWith('serverpod_auth_email_account.')) {
      data['className'] = dataClassName.substring(29);
      return _i3.Protocol().deserializeByClassName(data);
    }
    if (dataClassName.startsWith('serverpod_auth_profile.')) {
      data['className'] = dataClassName.substring(23);
      return _i4.Protocol().deserializeByClassName(data);
    }
    if (dataClassName.startsWith('serverpod_auth_session.')) {
      data['className'] = dataClassName.substring(23);
      return _i5.Protocol().deserializeByClassName(data);
    }
    if (dataClassName.startsWith('serverpod_auth_user.')) {
      data['className'] = dataClassName.substring(20);
      return _i6.Protocol().deserializeByClassName(data);
    }
    return super.deserializeByClassName(data);
  }
}
