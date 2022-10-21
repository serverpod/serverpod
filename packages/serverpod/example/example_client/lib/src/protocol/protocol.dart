/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: public_member_api_docs

library protocol; // ignore_for_file: no_leading_underscores_for_library_prefixes

import 'package:serverpod_client/serverpod_client.dart' as _i1;
import 'channel.dart' as _i2;
import 'channel_list.dart' as _i3;
import 'protocol.dart' as _i4;
export 'channel.dart';
export 'channel_list.dart';
export 'client.dart'; // ignore_for_file: equal_keys_in_map

class Protocol extends _i1.SerializationManager {
  static final Protocol instance = Protocol();

  @override
  final Map<Type, _i1.constructor> constructors = {
    _i2.Channel:
        (jsonSerialization, _i1.SerializationManager serializationManager) =>
            _i2.Channel.fromJson(jsonSerialization, serializationManager),
    _i3.ChannelList:
        (jsonSerialization, _i1.SerializationManager serializationManager) =>
            _i3.ChannelList.fromJson(jsonSerialization, serializationManager),
    _i1.getType<_i2.Channel?>():
        (jsonSerialization, _i1.SerializationManager serializationManager) =>
            jsonSerialization != null
                ? _i2.Channel.fromJson(jsonSerialization, serializationManager)
                : null,
    _i1.getType<_i3.ChannelList?>(): (jsonSerialization,
            _i1.SerializationManager serializationManager) =>
        jsonSerialization != null
            ? _i3.ChannelList.fromJson(jsonSerialization, serializationManager)
            : null,
    List<_i4.Channel>: (jsonSerialization,
            _i1.SerializationManager serializationManager) =>
        (jsonSerialization as List)
            .map((e) => serializationManager.deserializeJson<_i4.Channel>(e))
            .toList(),
  };

  @override
  final Map<String, Type> classNameTypeMapping = {};
}
