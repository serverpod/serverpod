import 'dart:convert';

import 'package:serverpod_serialization/serverpod_serialization.dart';

String formatArgs(Map<String, dynamic> args, String? authorizationKey, String method) {
  var formattedArgs = <String, String?>{};

  for (var argName in args.keys) {
    var value = args[argName];
    if (value != null) {
      formattedArgs[argName] = value.toString();
    }
  }

  if (authorizationKey != null)
    formattedArgs['auth'] = authorizationKey;

  formattedArgs['method'] = method;

  return jsonEncode(formattedArgs);
}

dynamic parseData(String data, String returnTypeName, SerializationManager serializationManager) {
  // TODO: Support more types!
  if (returnTypeName == 'int')
    return int.tryParse(data);
  else if (returnTypeName == 'double')
    return double.tryParse(data);
  else if (returnTypeName == 'bool')
    return jsonDecode(data);
  else if (returnTypeName == 'DateTime')
    return DateTime.tryParse(data);
  else if (returnTypeName == 'String')
    return jsonDecode(data);
  return serializationManager.createEntityFromSerialization(jsonDecode(data));
}