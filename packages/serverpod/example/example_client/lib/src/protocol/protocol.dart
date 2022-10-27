/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: public_member_api_docs

library protocol; // ignore_for_file: no_leading_underscores_for_library_prefixes

import 'package:serverpod_client/serverpod_client.dart' as _i1;
import 'channel.dart' as _i2;
import 'channel_list.dart' as _i3;
import 'protocol.dart' as _i4;
import 'package:serverpod_auth_client/module.dart' as _i5;
import 'package:serverpod_chat_client/module.dart' as _i6;
export 'channel.dart';
export 'channel_list.dart';
export 'client.dart'; // ignore_for_file: equal_keys_in_map

class Protocol extends _i1.SerializationManager {
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
      return customConstructors[t] as T;
    }
    if (t == _i2.Channel) {
      return _i2.Channel.fromJson(data, this) as T;
    }
    if (t == _i3.ChannelList) {
      return _i3.ChannelList.fromJson(data, this) as T;
    }
    if (t == _i1.getType<_i2.Channel?>()) {
      return (data != null ? _i2.Channel.fromJson(data, this) : null) as T;
    }
    if (t == _i1.getType<_i3.ChannelList?>()) {
      return (data != null ? _i3.ChannelList.fromJson(data, this) : null) as T;
    }
    if (t == List<_i4.Channel>) {
      return (data as List).map((e) => deserializeJson<_i4.Channel>(e)).toList()
          as dynamic;
    }
    try {
      return _i5.Protocol().deserializeJson<T>(data, t);
    } catch (_) {}
    try {
      return _i6.Protocol().deserializeJson<T>(data, t);
    } catch (_) {}
    return super.deserializeJson<T>(data, t);
  }

  @override
  String? getClassNameForObject(Object data) {
    String? className;
    className = _i5.Protocol().getClassNameForObject(data);
    if (className != null) {
      return 'serverpod_auth.$className';
    }
    className = _i6.Protocol().getClassNameForObject(data);
    if (className != null) {
      return 'serverpod_chat.$className';
    }
    if (data is _i2.Channel) {
      return 'Channel';
    }
    if (data is _i3.ChannelList) {
      return 'ChannelList';
    }
    return super.getClassNameForObject(data);
  }

  @override
  dynamic deserializeJsonByClassName(Map<String, dynamic> data) {
    if (data['className'].startsWith('serverpod_auth.')) {
      data['className'] = data['className'].substring(15);
      return _i5.Protocol().deserializeJsonByClassName(data);
    }
    if (data['className'].startsWith('serverpod_chat.')) {
      data['className'] = data['className'].substring(15);
      return _i6.Protocol().deserializeJsonByClassName(data);
    }
    if (data['className'] == 'Channel') {
      return deserializeJson<_i2.Channel>(data['data']);
    }
    if (data['className'] == 'ChannelList') {
      return deserializeJson<_i3.ChannelList>(data['data']);
    }
    return super.deserializeJsonByClassName(data);
  }
}
