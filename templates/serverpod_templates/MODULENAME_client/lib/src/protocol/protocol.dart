/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

library protocol;

import 'package:serverpod_client/serverpod_client.dart';

import 'module_class.dart';

export 'module_class.dart';
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
    constructors['MODULENAME_server.ModuleClass'] = (Map<String, dynamic> serialization) => ModuleClass.fromSerialization(serialization);
  }
}
