/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

library protocol; // ignore_for_file: no_leading_underscores_for_library_prefixes

import 'package:serverpod_client/serverpod_client.dart' as _i1;
import 'example_class.dart' as _i2;
export 'example_class.dart';
export 'client.dart'; // ignore_for_file: equal_keys_in_map

class Protocol extends _i1.SerializationManager {
  static final Protocol instance = Protocol();

  @override
  final Map<Type, _i1.constructor> constructors = {
    _i2.Example:
        (jsonSerialization, _i1.SerializationManager serializationManager) =>
            _i2.Example.fromJson(jsonSerialization, serializationManager),
    _i1.getType<_i2.Example?>():
        (jsonSerialization, _i1.SerializationManager serializationManager) =>
            jsonSerialization != null
                ? _i2.Example.fromJson(jsonSerialization, serializationManager)
                : null,
  };

  @override
  final Map<String, Type> classNameTypeMapping = {};
}
