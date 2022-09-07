import 'dart:convert';
import 'dart:typed_data';

import 'package:serverpod_serialization/serverpod_serialization.dart';

/// Encodes arguments for serialization.
String formatArgs(
    Map<String, dynamic> args, String? authorizationKey, String method) {
  var formattedArgs = <String, String?>{};

  for (var argName in args.keys) {
    var value = args[argName];
    if (value != null) {
      if (value is List) {
        // Handle List.
        if (value is List<ByteData> || value is List<ByteData?>) {
          formattedArgs[argName] = jsonEncode(
            value.map((e) => (e as ByteData?)?.base64encodedString()).toList(),
          );
        } else if (value is List<DateTime> || value is List<DateTime?>) {
          formattedArgs[argName] = jsonEncode(
            value.map((e) => (e as DateTime?)?.toIso8601String()).toList(),
          );
        } else if (value is List<String> ||
            value is List<String?> ||
            value is List<int> ||
            value is List<int?> ||
            value is List<double> ||
            value is List<double?> ||
            value is List<bool> ||
            value is List<bool?>) {
          formattedArgs[argName] = jsonEncode(value);
        } else {
          formattedArgs[argName] = jsonEncode(
            value.map((e) => e?.toString()).toList(),
          );
        }
      } else if (value is Map) {
        // Handle Map.
        if (value is Map<String, ByteData> || value is Map<String, ByteData?>) {
          formattedArgs[argName] = jsonEncode(value.map(
            (k, v) => MapEntry(k, (v as ByteData?)?.base64encodedString()),
          ));
        } else if (value is List<DateTime> || value is List<DateTime?>) {
          formattedArgs[argName] = jsonEncode(value.map(
            (k, v) => MapEntry(k, (v as DateTime?)?.toIso8601String()),
          ));
        } else if (value is Map<String, String> ||
            value is Map<String, String?> ||
            value is Map<String, int> ||
            value is Map<String, int?> ||
            value is Map<String, double> ||
            value is Map<String, double?> ||
            value is Map<String, bool> ||
            value is Map<String, bool?>) {
          formattedArgs[argName] = jsonEncode(value);
        } else {
          formattedArgs[argName] = jsonEncode(value.map(
            (k, v) => MapEntry(k, v?.toString()),
          ));
        }
      } else {
        // Handle basic types and serialized objects.
        if (value is ByteData) {
          formattedArgs[argName] = value.base64encodedString();
        } else if (value is DateTime) {
          formattedArgs[argName] = value.toIso8601String();
        } else {
          formattedArgs[argName] = value.toString();
        }
      }
    }
  }

  if (authorizationKey != null) formattedArgs['auth'] = authorizationKey;

  formattedArgs['method'] = method;

  return jsonEncode(formattedArgs);
}

/// Deserializes data sent from the server based on the return type.
dynamic parseData(
  String data,
  String returnTypeName,
  SerializationManager serializationManager,
) {
  // Make sure there are no whitespace in the return type so we can safely
  // match it.
  returnTypeName = returnTypeName.replaceAll(' ', '');

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
  } else if (returnTypeName == 'List<int>') {
    return (jsonDecode(data) as List?)?.cast<int>();
  } else if (returnTypeName == 'List<int?>') {
    return (jsonDecode(data) as List?)?.cast<int?>();
  } else if (returnTypeName == 'List<double>') {
    return (jsonDecode(data) as List?)?.cast<double>();
  } else if (returnTypeName == 'List<double?>') {
    return (jsonDecode(data) as List?)?.cast<double?>();
  } else if (returnTypeName == 'List<bool>') {
    return (jsonDecode(data) as List?)?.cast<bool>();
  } else if (returnTypeName == 'List<bool?>') {
    return (jsonDecode(data) as List?)?.cast<bool?>();
  } else if (returnTypeName == 'List<String>') {
    return (jsonDecode(data) as List?)?.cast<String>();
  } else if (returnTypeName == 'List<String?>') {
    return (jsonDecode(data) as List?)?.cast<String?>();
  } else if (returnTypeName == 'List<DateTime>') {
    var stringList = (jsonDecode(data) as List?)?.cast<String>();
    return stringList?.map<DateTime>((e) => DateTime.tryParse(e)!).toList();
  } else if (returnTypeName == 'List<DateTime?>') {
    var stringList = (jsonDecode(data) as List?)?.cast<String?>();
    return stringList
        ?.map<DateTime?>((e) => e == null ? null : DateTime.tryParse(e)!)
        .toList();
  } else if (returnTypeName == 'List<ByteData>') {
    var stringList = (jsonDecode(data) as List?)?.cast<String>();
    return stringList
        ?.map<ByteData>((e) => e.base64DecodedByteData()!)
        .toList();
  } else if (returnTypeName == 'List<ByteData?>') {
    var stringList = (jsonDecode(data) as List?)?.cast<String?>();
    return stringList
        ?.map<ByteData?>((e) => e?.base64DecodedByteData())
        .toList();
  } else if (returnTypeName.startsWith('List<') &&
      returnTypeName.endsWith('?>')) {
    var stringList = (jsonDecode(data) as List?)?.cast<String?>();
    return stringList
        ?.map((e) => e == null
            ? null
            : serializationManager.createEntityFromSerialization(jsonDecode(e)))
        .toList();
  } else if (returnTypeName.startsWith('List<') &&
      returnTypeName.endsWith('>')) {
    var stringList = (jsonDecode(data) as List?)?.cast<String>();
    return stringList
        ?.map((e) =>
            serializationManager.createEntityFromSerialization(jsonDecode(e))!)
        .toList();
  } else if (returnTypeName == 'Map<String,int>') {
    return (jsonDecode(data) as Map?)?.cast<String, int>();
  } else if (returnTypeName == 'Map<String,int?>') {
    return (jsonDecode(data) as Map?)?.cast<String, int?>();
  } else if (returnTypeName == 'Map<String,double>') {
    return (jsonDecode(data) as Map?)?.cast<String, double>();
  } else if (returnTypeName == 'Map<String,double?>') {
    return (jsonDecode(data) as Map?)?.cast<String, double?>();
  } else if (returnTypeName == 'Map<String,bool>') {
    return (jsonDecode(data) as Map?)?.cast<String, bool>();
  } else if (returnTypeName == 'Map<String,bool?>') {
    return (jsonDecode(data) as Map?)?.cast<String, bool?>();
  } else if (returnTypeName == 'Map<String,String>') {
    return (jsonDecode(data) as Map?)?.cast<String, String>();
  } else if (returnTypeName == 'Map<String,String?>') {
    return (jsonDecode(data) as Map?)?.cast<String, String?>();
  } else if (returnTypeName == 'Map<String,DateTime>') {
    var stringMap = (jsonDecode(data) as Map?)?.cast<String, String>();
    return stringMap?.map<String, DateTime>(
      (k, v) => MapEntry(k, DateTime.tryParse(v)!),
    );
  } else if (returnTypeName == 'Map<String,DateTime?>') {
    var stringMap = (jsonDecode(data) as Map?)?.cast<String, String?>();
    return stringMap?.map<String, DateTime?>(
      (k, v) => MapEntry(k, v == null ? null : DateTime.tryParse(v)!),
    );
  } else if (returnTypeName == 'Map<String,ByteData>') {
    var stringMap = (jsonDecode(data) as Map?)?.cast<String, String>();
    return stringMap?.map<String, ByteData>(
      (k, v) => MapEntry(k, v.base64DecodedByteData()!),
    );
  } else if (returnTypeName == 'Map<String,ByteData?>') {
    var stringMap = (jsonDecode(data) as Map?)?.cast<String, String?>();
    return stringMap?.map<String, ByteData?>(
      (k, v) => MapEntry(k, v?.base64DecodedByteData()),
    );
  } else if (returnTypeName.startsWith('Map<String,') &&
      returnTypeName.endsWith('?>')) {
    var stringMap = (jsonDecode(data) as Map?)?.cast<String, String?>();
    return stringMap?.map(
      (k, v) => MapEntry(
        k,
        v == null
            ? null
            : serializationManager.createEntityFromSerialization(
                jsonDecode(v),
              ),
      ),
    );
  } else if (returnTypeName.startsWith('Map<String,') &&
      returnTypeName.endsWith('>')) {
    var stringList = (jsonDecode(data) as Map?)?.cast<String, String>();
    return stringList?.map(
      (k, v) => MapEntry(k,
          serializationManager.createEntityFromSerialization(jsonDecode(v))!),
    );
  }
  return serializationManager.createEntityFromSerialization(jsonDecode(data));
}
