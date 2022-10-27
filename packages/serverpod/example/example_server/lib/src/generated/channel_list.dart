/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: public_member_api_docs

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:serverpod/serverpod.dart' as _i1;
import 'protocol.dart' as _i2;

class ChannelList extends _i1.SerializableEntity {
  ChannelList({required this.channels});

  factory ChannelList.fromJson(
    Map<String, dynamic> jsonSerialization,
    _i1.SerializationManager serializationManager,
  ) {
    return ChannelList(
        channels: serializationManager
            .deserializeJson<List<_i2.Channel>>(jsonSerialization['channels']));
  }

  List<_i2.Channel> channels;

  @override
  Map<String, dynamic> toJson() {
    return {'channels': channels};
  }

  @override
  Map<String, dynamic> allToJson() {
    return {'channels': channels};
  }
}
