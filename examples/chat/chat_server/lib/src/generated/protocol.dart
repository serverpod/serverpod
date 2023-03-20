/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: public_member_api_docs
// ignore_for_file: implementation_imports

library protocol; // ignore_for_file: no_leading_underscores_for_library_prefixes

import 'package:serverpod/serverpod.dart' as _i1;
import 'channel.dart' as _i2;
import 'package:chat_server/src/generated/channel.dart' as _i3;
import 'package:serverpod_auth_server/module.dart' as _i4;
import 'package:serverpod_chat_server/module.dart' as _i5;
import 'package:serverpod/protocol.dart' as _i6;
export 'channel.dart'; // ignore_for_file: equal_keys_in_map

class Protocol extends _i1.SerializationManagerServer {
  Protocol._();

  factory Protocol() => _instance;

  static final Map<Type, _i1.constructor> customConstructors = {};

  static final Protocol _instance = Protocol._();

  @override
  T deserialize<T>(
    dynamic data, [
    Type? t,
  ]) {
    t ??= T;
    if (customConstructors.containsKey(t)) {
      return customConstructors[t]!(data, this) as T;
    }
    if (t == _i2.Channel) {
      return _i2.Channel.fromJson(data, this) as T;
    }
    if (t == _i1.getType<_i2.Channel?>()) {
      return (data != null ? _i2.Channel.fromJson(data, this) : null) as T;
    }
    if (t == List<_i3.Channel>) {
      return (data as List).map((e) => deserialize<_i3.Channel>(e)).toList()
          as dynamic;
    }
    try {
      return _i4.Protocol().deserialize<T>(data, t);
    } catch (_) {}
    try {
      return _i5.Protocol().deserialize<T>(data, t);
    } catch (_) {}
    try {
      return _i6.Protocol().deserialize<T>(data, t);
    } catch (_) {}
    return super.deserialize<T>(data, t);
  }

  @override
  String? getClassNameForObject(Object data) {
    String? className;
    className = _i4.Protocol().getClassNameForObject(data);
    if (className != null) {
      return 'serverpod_auth.$className';
    }
    className = _i5.Protocol().getClassNameForObject(data);
    if (className != null) {
      return 'serverpod_chat.$className';
    }
    if (data is _i2.Channel) {
      return 'Channel';
    }
    return super.getClassNameForObject(data);
  }

  @override
  dynamic deserializeByClassName(Map<String, dynamic> data) {
    if (data['className'].startsWith('serverpod_auth.')) {
      data['className'] = data['className'].substring(15);
      return _i4.Protocol().deserializeByClassName(data);
    }
    if (data['className'].startsWith('serverpod_chat.')) {
      data['className'] = data['className'].substring(15);
      return _i5.Protocol().deserializeByClassName(data);
    }
    if (data['className'] == 'Channel') {
      return deserialize<_i2.Channel>(data['data']);
    }
    return super.deserializeByClassName(data);
  }

  @override
  _i1.Table? getTableForType(Type t) {
    {
      var table = _i4.Protocol().getTableForType(t);
      if (table != null) {
        return table;
      }
    }
    {
      var table = _i5.Protocol().getTableForType(t);
      if (table != null) {
        return table;
      }
    }
    {
      var table = _i6.Protocol().getTableForType(t);
      if (table != null) {
        return table;
      }
    }
    switch (t) {
      case _i2.Channel:
        return _i2.Channel.t;
    }
    return null;
  }

  static List<_i6.TableDefinition> getDesiredDatabaseStructure() => [
        _i6.TableDefinition(
          name: 'channel',
          columns: [
            _i6.ColumnDefinition(
              name: 'id',
              columnType: _i6.ColumnType.integer,
              isNullable: true,
            ),
            _i6.ColumnDefinition(
              name: 'name',
              columnType: _i6.ColumnType.text,
              isNullable: false,
            ),
            _i6.ColumnDefinition(
              name: 'channel',
              columnType: _i6.ColumnType.text,
              isNullable: false,
            ),
          ],
          primaryKey: ['id'],
          foreignKeys: [],
          indexes: [],
        ),
        ..._i4.Protocol.getDesiredDatabaseStructure(),
        ..._i5.Protocol.getDesiredDatabaseStructure(),
        ..._i6.Protocol.getDesiredDatabaseStructure(),
      ];
}
