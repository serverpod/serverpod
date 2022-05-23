import 'dart:convert';
import 'dart:typed_data';
import 'package:collection/collection.dart';
import 'package:serverpod_serialization/serverpod_serialization.dart';

/// Encodes arguments for serialization.
String formatArgs(
    Map<String, dynamic> args, String? authorizationKey, String method) {
  var formattedArgs = <String, String?>{};
  for (var argName in args.keys) {
    var value = args[argName];
    if (value != null) {
      if (value is ByteData) {
        formattedArgs[argName] = value.base64encodedString();
      } else if (value is Map) {
        formattedArgs[argName] = jsonEncode(value);
      } else if (value is List) {
        if (value.firstOrNull is SerializableEntity) {
          formattedArgs[argName] = jsonEncode((value)
              .map((e) => (e as SerializableEntity).serialize())
              .toList());
        } else {
          formattedArgs[argName] = jsonEncode(value);
        }
      } else {
        formattedArgs[argName] = value.toString();
      }
    }
  }

  if (authorizationKey != null) formattedArgs['auth'] = authorizationKey;

  formattedArgs['method'] = method;

  return jsonEncode(formattedArgs);
}

/// Deserializes data sent from the server based on the return type.
dynamic parseData(String data, String returnTypeName,
    SerializationManager serializationManager) {
  // TODO: Support more types!
  if (returnTypeName == 'int') {
    return int.tryParse(data);
  } else if (returnTypeName == 'double') {
    return double.tryParse(data);
  } else if (returnTypeName == 'bool') {
    return jsonDecode(data);
  } else if (returnTypeName == 'DateTime') {
    return DateTime.tryParse(data);
  } else if (returnTypeName == 'ByteData') {
    return data.base64DecodedByteData();
  } else if (returnTypeName == 'String') {
    return jsonDecode(data);
  } else if (returnTypeName.startsWith('List')) {
    String type =
        returnTypeName.split('<').last.replaceAll('>', '').replaceAll('?', '');
    if (serializationManager.constructors.containsKey(type)) {
      List datalist = json.decode(data) as List;
      var value = datalist.map((e) {
        // Todo: optimize unnecessary json decoder
        return e == null
            ? null
            : serializationManager
                .createEntityFromSerialization(e is Map ? e : jsonDecode(e));
      }).toList();
      return value;
    } else {
      var listData = (jsonDecode(data) as List?)?.map((e) {
        return e == null
            ? null
            : parseData(e, e.runtimeType.toString(), serializationManager);
      }).toList();
      return listData;
    }
  }
  var receivedData = jsonDecode(data);
  if (receivedData == null) return null;
  var serializedData =
      serializationManager.createEntityFromSerialization(receivedData);
  if (serializedData != null) {
    return serializedData;
  } else if (returnTypeName.startsWith('Map<')) {
    return receivedData;
  }
}
