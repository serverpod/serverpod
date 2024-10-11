import 'dart:convert';

import 'package:serverpod/serverpod.dart';

/// A test helper that serializes objects to JSON before passing it to [EndpointDispatch].
/// Used by the generated code.
dynamic testObjectToJson(dynamic object) {
  return jsonDecode(SerializationManager.encodeForProtocol(object));
}
