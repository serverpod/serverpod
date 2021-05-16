import 'dart:convert';
import 'package:serverpod/serverpod.dart';
import 'package:serverpod_test_bundle/bundle.dart' as bundle;
import '../generated/protocol.dart';

class BundleSerializationEndpoint extends Endpoint {
  Future<bool> serializeBundleObject(Session session) async {
    var bundleClass = bundle.BundleClass(
      data: 42,
      name: 'foo',
    );

    try {
      var s = pod.serializationManager.serializeEntity(bundleClass)!;
      var unpacked = pod.serializationManager.createEntityFromSerialization(jsonDecode(s)) as bundle.BundleClass;
      return (unpacked.data == 42 && unpacked.name == 'foo');
    }
    catch(e, stackTrace) {
      print('BundleSerializationEndpoint.serializeBundleObject failed: $e');
      print('$stackTrace');

      return false;
    }
  }

  Future<bundle.BundleClass> modifyBundleObject(Session session, bundle.BundleClass object) async {
    object.data = 42;
    return object;
  }
}
