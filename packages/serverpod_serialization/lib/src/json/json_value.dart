import 'dart:convert';

/// Represents an arbitrary JSON value stored as PostgreSQL jsonb.
///
/// This type provides type-safe handling of JSON data that will be stored
/// in a PostgreSQL `jsonb` column. Unlike [ColumnSerializable] which stores
/// objects as JSON but has no query operations, [JsonValue] supports
/// PostgreSQL's JSONB operators for querying nested data.
///
/// Example:
/// ```dart
/// // Create from various values
/// var obj = JsonValue.object({'name': 'John', 'age': 30});
/// var arr = JsonValue.array([1, 2, 3]);
/// var jsonValue = JsonValue({'nested': {'key': 'value'}});
///
/// // Access the underlying value
/// print(obj.value); // {name: John, age: 30}
///
/// // Serialize to JSON string
/// print(obj.toJsonString()); // {"name":"John","age":30}
/// ```
class JsonValue {
  final dynamic _value;

  /// Creates a new [JsonValue] from any JSON-compatible value.
  ///
  /// The value can be any valid JSON type: null, bool, num, String, List, or Map.
  const JsonValue(this._value);

  /// Creates a [JsonValue] from a JSON-encoded string.
  ///
  /// Example:
  /// ```dart
  /// var json = JsonValue.fromJsonString('{"name": "John"}');
  /// print(json.value); // {name: John}
  /// ```
  factory JsonValue.fromJsonString(String json) => JsonValue(jsonDecode(json));

  /// Creates a [JsonValue] containing a JSON object (Map).
  ///
  /// If no map is provided, an empty object `{}` is created.
  ///
  /// Example:
  /// ```dart
  /// var empty = JsonValue.object();
  /// var data = JsonValue.object({'key': 'value'});
  /// ```
  factory JsonValue.object([Map<String, dynamic>? map]) =>
      JsonValue(map ?? <String, dynamic>{});

  /// Creates a [JsonValue] containing a JSON array (List).
  ///
  /// If no list is provided, an empty array `[]` is created.
  ///
  /// Example:
  /// ```dart
  /// var empty = JsonValue.array();
  /// var data = JsonValue.array([1, 2, 3]);
  /// ```
  factory JsonValue.array([List<dynamic>? list]) => JsonValue(list ?? []);

  /// Returns the underlying JSON value.
  ///
  /// The returned value can be any valid JSON type: null, bool, num, String,
  /// List<dynamic>, or Map<String, dynamic>.
  dynamic get value => _value;

  /// Returns `true` if the underlying value is a JSON object (Map).
  bool get isObject => _value is Map<String, dynamic>;

  /// Returns `true` if the underlying value is a JSON array (List).
  bool get isArray => _value is List;

  /// Returns `true` if the underlying value is `null`.
  bool get isNull => _value == null;

  /// Returns `true` if the underlying value is a boolean.
  bool get isBool => _value is bool;

  /// Returns `true` if the underlying value is a number.
  bool get isNumber => _value is num;

  /// Returns `true` if the underlying value is a string.
  bool get isString => _value is String;

  /// Serializes this [JsonValue] to a JSON representation for storage.
  ///
  /// This returns the underlying value directly, which will be properly
  /// encoded when serialized.
  dynamic toJson() => _value;

  /// Creates a [JsonValue] from a JSON representation.
  ///
  /// This factory is used during deserialization.
  static JsonValue fromJson(dynamic data) => JsonValue(data);

  /// Returns a JSON-encoded string representation of the value.
  ///
  /// Example:
  /// ```dart
  /// var json = JsonValue({'name': 'John'});
  /// print(json.toJsonString()); // {"name":"John"}
  /// ```
  String toJsonString() => jsonEncode(_value);

  @override
  String toString() => 'JsonValue($_value)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! JsonValue) return false;
    return _deepEquals(_value, other._value);
  }

  @override
  int get hashCode => _deepHashCode(_value);

  /// Performs deep equality comparison for JSON values.
  static bool _deepEquals(dynamic a, dynamic b) {
    if (identical(a, b)) return true;
    if (a == null || b == null) return a == b;
    if (a.runtimeType != b.runtimeType) return false;

    if (a is Map && b is Map) {
      if (a.length != b.length) return false;
      for (var key in a.keys) {
        if (!b.containsKey(key) || !_deepEquals(a[key], b[key])) {
          return false;
        }
      }
      return true;
    }

    if (a is List && b is List) {
      if (a.length != b.length) return false;
      for (var i = 0; i < a.length; i++) {
        if (!_deepEquals(a[i], b[i])) return false;
      }
      return true;
    }

    return a == b;
  }

  /// Computes a deep hash code for JSON values.
  static int _deepHashCode(dynamic value) {
    if (value == null) return 0;

    if (value is Map) {
      var hash = 0;
      for (var entry in value.entries) {
        hash ^= entry.key.hashCode ^ _deepHashCode(entry.value);
      }
      return hash;
    }

    if (value is List) {
      var hash = 0;
      for (var i = 0; i < value.length; i++) {
        hash ^= i.hashCode ^ _deepHashCode(value[i]);
      }
      return hash;
    }

    return value.hashCode;
  }
}
