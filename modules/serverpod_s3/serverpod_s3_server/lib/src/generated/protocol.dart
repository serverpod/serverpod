/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: public_member_api_docs

library protocol;

// ignore: unused_import
import 'dart:typed_data';
import 'package:serverpod/serverpod.dart';

import 'module_class.dart';

export 'module_class.dart';

class Protocol extends SerializationManager {
  static final Protocol instance = Protocol();

  final Map<String, constructor> _constructors = {};
  @override
  Map<String, constructor> get constructors => _constructors;
  final Map<String,String> _tableClassMapping = {};
  @override
  Map<String,String> get tableClassMapping => _tableClassMapping;

  Protocol() {
    constructors['serverpod_s3_server.ModuleClass'] = (Map<String, dynamic> serialization) => ModuleClass.fromSerialization(serialization);

  }
}
