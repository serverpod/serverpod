/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: public_member_api_docs

library protocol; // ignore_for_file: no_leading_underscores_for_library_prefixes

import 'package:serverpod/serverpod.dart' as _i1;
import 'module_class.dart' as _i2;
import 'package:serverpod/protocol.dart' as _i3;
export 'module_class.dart'; // ignore_for_file: equal_keys_in_map

class Protocol extends _i1.SerializationManagerServer {
  Protocol._();

  factory Protocol() => _instance;

  static final Map<Type, _i1.constructor> customConstructors = {};

  static final Protocol _instance = Protocol._();

  @override
  T deserializeJson<T>(
    dynamic data, [
    Type? t,
  ]) {
    t ??= T;
    if (customConstructors.containsKey(t)) {
      return customConstructors[t]!(data, this) as T;
    }
    if (t == _i2.ModuleClass) {
      return _i2.ModuleClass.fromJson(data, this) as T;
    }
    if (t == _i1.getType<_i2.ModuleClass?>()) {
      return (data != null ? _i2.ModuleClass.fromJson(data, this) : null) as T;
    }
    try {
      return _i3.Protocol().deserializeJson<T>(data, t);
    } catch (_) {}
    return super.deserializeJson<T>(data, t);
  }

  @override
  String? getClassNameForObject(Object data) {
    if (data is _i2.ModuleClass) {
      return 'ModuleClass';
    }
    return super.getClassNameForObject(data);
  }

  @override
  dynamic deserializeJsonByClassName(Map<String, dynamic> data) {
    if (data['className'] == 'ModuleClass') {
      return deserializeJson<_i2.ModuleClass>(data['data']);
    }
    return super.deserializeJsonByClassName(data);
  }

  @override
  _i1.Table? getTableForType(Type t) {
    {
      var table = _i3.Protocol().getTableForType(t);
      if (table != null) {
        return table;
      }
    }
    switch (t) {
    }
    return null;
  }
}
