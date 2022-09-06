/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: public_member_api_docs
// ignore_for_file: unnecessary_import

library protocol;

// ignore: unused_import
import 'dart:typed_data';
import 'package:serverpod_client/serverpod_client.dart';

import 'nullability.dart';
import 'object_field_scopes.dart';
import 'object_with_maps.dart';
import 'object_with_object.dart';
import 'simple_data.dart';
import 'simple_data_list.dart';
import 'types.dart';

export 'nullability.dart';
export 'object_field_scopes.dart';
export 'object_with_maps.dart';
export 'object_with_object.dart';
export 'simple_data.dart';
export 'simple_data_list.dart';
export 'types.dart';
export 'client.dart';

class Protocol extends SerializationManager {
  static final Protocol instance = Protocol();

  final Map<String, constructor> _constructors = {};
  @override
  Map<String, constructor> get constructors => _constructors;

  Protocol() {
    constructors['Nullability'] = (Map<String, dynamic> serialization) =>
        Nullability.fromSerialization(serialization);
    constructors['ObjectFieldScopes'] = (Map<String, dynamic> serialization) =>
        ObjectFieldScopes.fromSerialization(serialization);
    constructors['ObjectWithMaps'] = (Map<String, dynamic> serialization) =>
        ObjectWithMaps.fromSerialization(serialization);
    constructors['ObjectWithObject'] = (Map<String, dynamic> serialization) =>
        ObjectWithObject.fromSerialization(serialization);
    constructors['SimpleData'] = (Map<String, dynamic> serialization) =>
        SimpleData.fromSerialization(serialization);
    constructors['SimpleDataList'] = (Map<String, dynamic> serialization) =>
        SimpleDataList.fromSerialization(serialization);
    constructors['Types'] = (Map<String, dynamic> serialization) =>
        Types.fromSerialization(serialization);
  }
}
