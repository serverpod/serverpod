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
        Map neVal = {};
        value.forEach((key, value) {
          var newKey = getParsedValueForEncoding(key);
          var newValue = getParsedValueForEncoding(value);
          neVal[newKey] = newValue;
        });
        formattedArgs[argName] = jsonEncode(neVal);
      } else if (value is List) {
        if (value.firstOrNull is SerializableEntity) {
          formattedArgs[argName] = jsonEncode((value)
              // .map((e) => (e as SerializableEntity).serialize())
              .toList());
        } else if (value.firstOrNull is DateTime) {
          formattedArgs[argName] = jsonEncode(
              (value).map((e) => (e as DateTime).toIso8601String()).toList());
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

/// To Prase Value for Json Encoding
dynamic getParsedValueForEncoding(dynamic value) {
  if (value.runtimeType == DateTime) {
    return (value as DateTime).toIso8601String();
  } else if (value.runtimeType == ByteData) {
    return (value as ByteData).base64encodedString();
  } else if ([int, String, double, bool, Null].contains(value.runtimeType)) {
    return value;
  } else {
    try {
      // Todo: Find validation method to check the type is SerializableEntity or Not
      return (value as SerializableEntity).serialize();
    } catch (e) {
      return value;
    }
  }
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
        return getPrasedValue(e, type, serializationManager);
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
    List<String> mapTypes = returnTypeName
        .replaceAll('Map<', '')
        .substring(0, returnTypeName.length - 5)
        .split(',');
    var newMap = {};
    (receivedData as Map).forEach((key, value) {
      newMap[getPrasedValue(key, mapTypes.first, serializationManager)] =
          getPrasedValue(value, mapTypes.last, serializationManager);
    });
    return Map.from(newMap);
  }
}

/// Parsing Key and Vaues of Map
dynamic getPrasedValue(dynamic value, String expectedType,
    SerializationManager serializationManager) {
  // Todo: To Handle Dynamic Value
  if (value == null) return null;
  if (value is String) {
    return parseData(
        value, expectedType.replaceAll('?', ''), serializationManager);
  } else {
  // Todo: to Recheck This Loop 
    return value;
  }
}
