/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

library protocol;

import 'package:serverpod_client/serverpod_client.dart';

import 'simple_data.dart';
import 'types.dart';

export 'simple_data.dart';
export 'types.dart';
export 'client.dart';

class Protocol extends SerializationManager {
  static final Protocol instance = Protocol();

  Map<String, constructor> _constructors = {};
  Map<String, constructor> get constructors => _constructors;
  Map<String,String> _tableClassMapping = {};
  Map<String,String> get tableClassMapping => _tableClassMapping;

  Protocol() {
    constructors['SimpleData'] = (Map<String, dynamic> serialization) => SimpleData.fromSerialization(serialization);
    constructors['Types'] = (Map<String, dynamic> serialization) => Types.fromSerialization(serialization);
  }
}
