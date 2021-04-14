/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

library protocol;

import 'package:serverpod_client/serverpod_client.dart';

import 'nullability.dart';
import 'simple_data.dart';
import 'types.dart';
import 'simple_data_list.dart';
import 'object_with_object.dart';

export 'nullability.dart';
export 'simple_data.dart';
export 'types.dart';
export 'simple_data_list.dart';
export 'object_with_object.dart';
export 'client.dart';

class Protocol extends SerializationManager {
  static final Protocol instance = Protocol();

  final Map<String, constructor> _constructors = {};
  @override
  Map<String, constructor> get constructors => _constructors;
  final Map<String,String> _tableClassMapping = {};
  @override
  Map<String,String> get tableClassMapping => _tableClassMapping;

  Protocol() {
    constructors['Nullability'] = (Map<String, dynamic> serialization) => Nullability.fromSerialization(serialization);
    constructors['SimpleData'] = (Map<String, dynamic> serialization) => SimpleData.fromSerialization(serialization);
    constructors['Types'] = (Map<String, dynamic> serialization) => Types.fromSerialization(serialization);
    constructors['SimpleDataList'] = (Map<String, dynamic> serialization) => SimpleDataList.fromSerialization(serialization);
    constructors['ObjectWithObject'] = (Map<String, dynamic> serialization) => ObjectWithObject.fromSerialization(serialization);
  }
}
