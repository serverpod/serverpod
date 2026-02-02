import 'dart:convert';

import 'package:serverpod_serialization/serverpod_serialization.dart';
import 'package:test/test.dart';

void main() {
  group('JsonValue', () {
    group('constructor', () {
      test('creates from dynamic value', () {
        var json = JsonValue({'key': 'value'});
        expect(json.value, {'key': 'value'});
      });

      test('creates from null', () {
        var json = JsonValue(null);
        expect(json.value, null);
        expect(json.isNull, true);
      });

      test('creates from number', () {
        var json = JsonValue(42);
        expect(json.value, 42);
        expect(json.isNumber, true);
      });

      test('creates from string', () {
        var json = JsonValue('hello');
        expect(json.value, 'hello');
        expect(json.isString, true);
      });

      test('creates from boolean', () {
        var json = JsonValue(true);
        expect(json.value, true);
        expect(json.isBool, true);
      });
    });

    group('factory constructors', () {
      test('fromJsonString parses JSON string', () {
        var json = JsonValue.fromJsonString('{"name":"John","age":30}');
        expect(json.value, {'name': 'John', 'age': 30});
      });

      test('object creates empty object when no argument', () {
        var json = JsonValue.object();
        expect(json.value, <String, dynamic>{});
        expect(json.isObject, true);
      });

      test('object creates object from map', () {
        var json = JsonValue.object({'key': 'value'});
        expect(json.value, {'key': 'value'});
      });

      test('array creates empty array when no argument', () {
        var json = JsonValue.array();
        expect(json.value, []);
        expect(json.isArray, true);
      });

      test('array creates array from list', () {
        var json = JsonValue.array([1, 2, 3]);
        expect(json.value, [1, 2, 3]);
      });
    });

    group('type checking', () {
      test('isObject returns true for maps', () {
        var json = JsonValue({'key': 'value'});
        expect(json.isObject, true);
        expect(json.isArray, false);
      });

      test('isArray returns true for lists', () {
        var json = JsonValue([1, 2, 3]);
        expect(json.isArray, true);
        expect(json.isObject, false);
      });

      test('isNull returns true for null', () {
        var json = JsonValue(null);
        expect(json.isNull, true);
      });

      test('isBool returns true for booleans', () {
        expect(JsonValue(true).isBool, true);
        expect(JsonValue(false).isBool, true);
        expect(JsonValue('true').isBool, false);
      });

      test('isNumber returns true for numbers', () {
        expect(JsonValue(42).isNumber, true);
        expect(JsonValue(3.14).isNumber, true);
        expect(JsonValue('42').isNumber, false);
      });

      test('isString returns true for strings', () {
        expect(JsonValue('hello').isString, true);
        expect(JsonValue(42).isString, false);
      });
    });

    group('serialization', () {
      test('toJson returns underlying value', () {
        var json = JsonValue({'name': 'John'});
        expect(json.toJson(), {'name': 'John'});
      });

      test('fromJson creates from value', () {
        var json = JsonValue.fromJson({'name': 'John'});
        expect(json.value, {'name': 'John'});
      });

      test('toJsonString returns JSON encoded string', () {
        var json = JsonValue({'name': 'John', 'age': 30});
        var str = json.toJsonString();
        expect(jsonDecode(str), {'name': 'John', 'age': 30});
      });
    });

    group('equality', () {
      test('equal objects are equal', () {
        var json1 = JsonValue({'key': 'value'});
        var json2 = JsonValue({'key': 'value'});
        expect(json1 == json2, true);
      });

      test('different objects are not equal', () {
        var json1 = JsonValue({'key': 'value1'});
        var json2 = JsonValue({'key': 'value2'});
        expect(json1 == json2, false);
      });

      test('nested objects are compared deeply', () {
        var json1 = JsonValue({
          'outer': {'inner': 'value'}
        });
        var json2 = JsonValue({
          'outer': {'inner': 'value'}
        });
        expect(json1 == json2, true);
      });

      test('arrays are compared deeply', () {
        var json1 = JsonValue([1, 2, [3, 4]]);
        var json2 = JsonValue([1, 2, [3, 4]]);
        expect(json1 == json2, true);
      });

      test('different types are not equal', () {
        var json1 = JsonValue({'key': 'value'});
        var json2 = JsonValue(['key', 'value']);
        expect(json1 == json2, false);
      });
    });

    group('hashCode', () {
      test('equal objects have same hash code', () {
        var json1 = JsonValue({'key': 'value'});
        var json2 = JsonValue({'key': 'value'});
        expect(json1.hashCode, json2.hashCode);
      });
    });

    group('toString', () {
      test('returns string representation', () {
        var json = JsonValue({'key': 'value'});
        expect(json.toString(), contains('JsonValue'));
        expect(json.toString(), contains('key'));
      });
    });
  });

  group('JsonValueJsonExtension', () {
    test('fromJson handles JsonValue', () {
      var original = JsonValue({'key': 'value'});
      var result = JsonValueJsonExtension.fromJson(original);
      expect(result.value, {'key': 'value'});
    });

    test('fromJson handles Map', () {
      var result = JsonValueJsonExtension.fromJson({'key': 'value'});
      expect(result.value, {'key': 'value'});
    });

    test('fromJson handles List', () {
      var result = JsonValueJsonExtension.fromJson([1, 2, 3]);
      expect(result.value, [1, 2, 3]);
    });

    test('fromJson handles JSON string', () {
      var result = JsonValueJsonExtension.fromJson('{"key":"value"}');
      expect(result.value, {'key': 'value'});
    });

    test('fromJson handles plain string (not JSON)', () {
      var result = JsonValueJsonExtension.fromJson('hello');
      expect(result.value, 'hello');
    });

    test('fromJson handles number', () {
      var result = JsonValueJsonExtension.fromJson(42);
      expect(result.value, 42);
    });

    test('fromJson handles bool', () {
      var result = JsonValueJsonExtension.fromJson(true);
      expect(result.value, true);
    });

    test('fromJson handles null', () {
      var result = JsonValueJsonExtension.fromJson(null);
      expect(result.value, null);
    });
  });

  group('SerializationManager integration', () {
    test('can encode JsonValue', () {
      var json = JsonValue({'name': 'John', 'age': 30});
      var encoded = SerializationManager.encode(json);
      expect(encoded, contains('John'));
      expect(encoded, contains('30'));
    });
  });
}
