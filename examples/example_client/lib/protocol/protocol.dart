/*** AUTOMATICALLY GENERATED CODE DO NOT MODIFY ***/
/* To generate run: "serverpod generate"  */

library protocol;

import 'package:serverpod_client/serverpod_client.dart';

import 'user_info.dart';

export 'user_info.dart';

class Protocol extends SerializationManager {
  Map<String, constructor> _constructors = <String, constructor>{};
  Map<String, constructor> get constructors => _constructors;
  Protocol() {
    constructors['UserInfo'] = (Map<String, dynamic> serialization) => UserInfo.fromSerialization(serialization);
  }
}
