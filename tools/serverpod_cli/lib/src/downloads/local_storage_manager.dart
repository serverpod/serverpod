import 'dart:convert';
import 'dart:io';

import 'package:path/path.dart' as p;

/// An abstract class that provides methods for storing, fetching and removing
/// json files from local storage.
abstract base class LocalStorageManager {
  /// Fetches the home directory of the current user.
  static Directory get homeDirectory {
    var envVars = Platform.environment;

    if (Platform.isWindows) {
      return Directory(envVars['UserProfile']!);
    } else if (Platform.isLinux || Platform.isMacOS) {
      return Directory(envVars['HOME']!);
    }
    throw (Exception('Unsupported platform.'));
  }

  /// Removes a file from the local storage.
  /// If the file does not exist, nothing will happen.
  ///
  /// [fileName] The name of the file to remove.
  /// [localStoragePath] The path to the local storage directory.
  /// [onError] A function that will be called if an error occurs. If not
  /// provided an exception will be thrown.
  static Future<void> removeFile({
    required String fileName,
    required String localStoragePath,
    Function(Object e)? onError,
  }) async {
    var file = File(p.join(localStoragePath, fileName));

    if (!file.existsSync()) return;

    try {
      await file.delete();
    } catch (e) {
      if (onError != null) {
        onError(e);
      } else {
        throw Exception('Failed to remove file. error: $e');
      }
    }
  }

  /// Stores a json file in the local storage.
  /// If the file already exists it will be overwritten.
  ///
  /// [fileName] The name of the file to store.
  /// [json] The json data to store.
  /// [localStoragePath] The path to the local storage directory.
  /// [onError] A function that will be called if an error occurs. If not
  /// provided an exception will be thrown.
  static Future<void> storeJsonFile({
    required String fileName,
    required Map<String, dynamic> json,
    required String localStoragePath,
    void Function(Object e)? onError,
  }) async {
    var file = File(p.join(localStoragePath, fileName));

    try {
      if (!file.existsSync()) {
        file.createSync(recursive: true);
      }

      var jsonString = const JsonEncoder.withIndent('  ').convert(json);

      file.writeAsStringSync(jsonString);
    } catch (e) {
      if (onError != null) {
        onError(e);
      } else {
        throw Exception('Failed to store json file. error: $e');
      }
    }
  }

  /// Tries to fetch and deserialize a json file from the local storage.
  /// If the file does not exist or if an error occurs during reading or
  /// deserialization, null will be returned.
  ///
  /// [fileName] The name of the file to fetch.
  /// [localStoragePath] The path to the local storage directory.
  /// [fromJson] A function that is used to deserialize the json data.
  /// [onReadError] A function that will be called if an error occurs when
  /// reading the file. If not provided, an exception will be thrown.
  /// [onDeserializationError] A function that will be called if an error occurs
  /// when deserializing the json data. If not provided, an exception will be
  /// thrown.
  static Future<T?> tryFetchAndDeserializeJsonFile<T>({
    required String fileName,
    required String localStoragePath,
    required T Function(Map<String, dynamic> json) fromJson,
    T? Function(Object e, File file)? onReadError,
    T? Function(Object e, File file)? onDeserializationError,
  }) async {
    var file = File(p.join(localStoragePath, fileName));

    if (!file.existsSync()) return null;

    dynamic json;
    try {
      json = jsonDecode(file.readAsStringSync());
    } catch (e) {
      if (onReadError != null) {
        return onReadError(e, file);
      } else {
        throw Exception('Failed to read json file. error: $e');
      }
    }

    try {
      return fromJson(json);
    } catch (e) {
      if (onDeserializationError != null) {
        return onDeserializationError(e, file);
      } else {
        throw Exception('Failed to deserialize json file. error: $e');
      }
    }
  }
}
