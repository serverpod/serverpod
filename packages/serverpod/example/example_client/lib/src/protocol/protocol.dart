/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: public_member_api_docs

library protocol;

import 'package:serverpod_client/serverpod_client.dart';

import 'example_class.dart';

export 'example_class.dart';
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
    constructors['Example'] = (Map<String, dynamic> serialization) => Example.fromSerialization(serialization);
  }
}
