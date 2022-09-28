/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: public_member_api_docs
// ignore_for_file: unnecessary_import
// ignore_for_file: no_leading_underscores_for_local_identifiers
// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: depend_on_referenced_packages

library protocol;

// ignore: unused_import
import 'dart:typed_data';
import 'package:serverpod_client/serverpod_client.dart';

import 'example_class.dart';

export 'example_class.dart';
export 'client.dart';

class Protocol extends SerializationManager {
  static final Protocol instance = Protocol();

  final Map<String, constructor> _constructors = {};
  @override
  Map<String, constructor> get constructors => _constructors;

  Protocol() {
    constructors['Example'] = (Map<String, dynamic> serialization) =>
        Example.fromSerialization(serialization);
  }
}
