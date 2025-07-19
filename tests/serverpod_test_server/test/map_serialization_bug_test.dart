/// Tests for the Map serialization bug in Serverpod
///
/// BUG DESCRIPTION:
/// When Maps with non-String keys contain empty data, they are serialized as empty Lists [].
/// However, during deserialization, if the data is somehow an empty Map {} instead of a List,
/// the code tries to cast it with `(data as List)` which throws:
/// "type '_Map<String, dynamic>' is not a subtype of type 'List<dynamic>' in type cast"
///
/// ROOT CAUSE:
/// 1. Maps with non-String keys are serialized as Lists of objects with 'k' and 'v' keys
/// 2. Empty Maps become empty Lists []
/// 3. Deserialization code expects Lists and tries to cast with `(data as List)`
/// 4. If data is an empty Map {} instead, the cast fails
///
/// LOCATIONS:
/// - Serialization: packages/serverpod_serialization/lib/src/extensions/serialization_extensions.dart:94-120
/// - Code Generation: tools/serverpod_cli/lib/src/generator/types.dart:560-580
/// - Generated Code: tests/serverpod_test_client/lib/src/protocol/protocol.dart:1694-1696
///
/// FIX REQUIRED:
/// The generated deserialization code should check if data is a Map before casting as List,
/// and return an empty Map in that case.
///
/// TEST STRUCTURE:
/// - Empty Maps with Non-String Keys: Tests all Map types that should work but currently fail
/// - Empty Maps with String Keys: Control tests that work correctly
/// - Direct Protocol Deserialization: Tests the exact failure scenarios
/// - JSON Round-trip Tests: Tests the full serialization cycle
/// - Mixed Content Tests: Tests Maps with both empty and populated data
/// - Server Protocol Tests: Tests server-side protocol
/// - Edge Case Tests: Tests the exact bug scenarios

import 'dart:convert';
import 'dart:typed_data';

import 'package:serverpod/protocol.dart' as serverpod;
import 'package:serverpod_test_client/serverpod_test_client.dart';
import 'package:serverpod_test_server/src/generated/protocol.dart' as server;
import 'package:test/test.dart';

void main() {
  var protocol = Protocol();
  var serverProtocol = server.Protocol();

  group('Map Serialization Bug Tests', () {
    group('Empty Maps with Non-String Keys', () {
      test(
          'Given an empty Map<int, String> when serializing and deserializing then it should not throw a type cast error',
          () {
        var object = TypesMap(anIntKey: {});

        var encodedString = SerializationManager.encode(object);
        var typesMap = Protocol().decode<TypesMap>(encodedString);

        expect(typesMap.anIntKey, {});
      });

      test(
          'Given an empty Map<bool, String> when serializing and deserializing then it should not throw a type cast error',
          () {
        var object = TypesMap(aBoolKey: {});

        var encodedString = SerializationManager.encode(object);
        var typesMap = Protocol().decode<TypesMap>(encodedString);

        expect(typesMap.aBoolKey, {});
      });

      test(
          'Given an empty Map<double, String> when serializing and deserializing then it should not throw a type cast error',
          () {
        var object = TypesMap(aDoubleKey: {});

        var encodedString = SerializationManager.encode(object);
        var typesMap = Protocol().decode<TypesMap>(encodedString);

        expect(typesMap.aDoubleKey, {});
      });

      test(
          'Given an empty Map<DateTime, String> when serializing and deserializing then it should not throw a type cast error',
          () {
        var object = TypesMap(aDateTimeKey: {});

        var encodedString = SerializationManager.encode(object);
        var typesMap = Protocol().decode<TypesMap>(encodedString);

        expect(typesMap.aDateTimeKey, {});
      });

      test(
          'Given an empty Map<ByteData, String> when serializing and deserializing then it should not throw a type cast error',
          () {
        var object = TypesMap(aByteDataKey: {});

        var encodedString = SerializationManager.encode(object);
        var typesMap = Protocol().decode<TypesMap>(encodedString);

        expect(typesMap.aByteDataKey, {});
      });

      test(
          'Given an empty Map<Duration, String> when serializing and deserializing then it should not throw a type cast error',
          () {
        var object = TypesMap(aDurationKey: {});

        var encodedString = SerializationManager.encode(object);
        var typesMap = Protocol().decode<TypesMap>(encodedString);

        expect(typesMap.aDurationKey, {});
      });

      test(
          'Given an empty Map<UuidValue, String> when serializing and deserializing then it should not throw a type cast error',
          () {
        var object = TypesMap(aUuidKey: {});

        var encodedString = SerializationManager.encode(object);
        var typesMap = Protocol().decode<TypesMap>(encodedString);

        expect(typesMap.aUuidKey, {});
      });

      test(
          'Given an empty Map<Uri, String> when serializing and deserializing then it should not throw a type cast error',
          () {
        var object = TypesMap(aUriKey: {});

        var encodedString = SerializationManager.encode(object);
        var typesMap = Protocol().decode<TypesMap>(encodedString);

        expect(typesMap.aUriKey, {});
      });

      test(
          'Given an empty Map<BigInt, String> when serializing and deserializing then it should not throw a type cast error',
          () {
        var object = TypesMap(aBigIntKey: {});

        var encodedString = SerializationManager.encode(object);
        var typesMap = Protocol().decode<TypesMap>(encodedString);

        expect(typesMap.aBigIntKey, {});
      });

      test(
          'Given an empty Map<TestEnum, String> when serializing and deserializing then it should not throw a type cast error',
          () {
        var object = TypesMap(anEnumKey: {});

        var encodedString = SerializationManager.encode(object);
        var typesMap = Protocol().decode<TypesMap>(encodedString);

        expect(typesMap.anEnumKey, {});
      });

      test(
          'Given an empty Map<TestEnumStringified, String> when serializing and deserializing then it should not throw a type cast error',
          () {
        var object = TypesMap(aStringifiedEnumKey: {});

        var encodedString = SerializationManager.encode(object);
        var typesMap = Protocol().decode<TypesMap>(encodedString);

        expect(typesMap.aStringifiedEnumKey, {});
      });

      test(
          'Given an empty Map<Types, String> when serializing and deserializing then it should not throw a type cast error',
          () {
        var object = TypesMap(anObjectKey: {});

        var encodedString = SerializationManager.encode(object);
        var typesMap = Protocol().decode<TypesMap>(encodedString);

        expect(typesMap.anObjectKey, {});
      });

      test(
          'Given an empty Map<Map<Types, String>, String> when serializing and deserializing then it should not throw a type cast error',
          () {
        var object = TypesMap(aMapKey: {});

        var encodedString = SerializationManager.encode(object);
        var typesMap = Protocol().decode<TypesMap>(encodedString);

        expect(typesMap.aMapKey, {});
      });

      test(
          'Given an empty Map<List<Types>, String> when serializing and deserializing then it should not throw a type cast error',
          () {
        var object = TypesMap(aListKey: {});

        var encodedString = SerializationManager.encode(object);
        var typesMap = Protocol().decode<TypesMap>(encodedString);

        expect(typesMap.aListKey, {});
      });

      test(
          'Given an empty Map<(String,), String> when serializing and deserializing then it should not throw a type cast error',
          () {
        var object = TypesMap(aRecordKey: {});

        var encodedString = SerializationManager.encode(object);
        var typesMap = Protocol().decode<TypesMap>(encodedString);

        expect(typesMap.aRecordKey, {});
      });

      test(
          'Given an empty Map<(String,)?, String> when serializing and deserializing then it should not throw a type cast error',
          () {
        var object = TypesMap(aNullableRecordKey: {});

        var encodedString = SerializationManager.encode(object);
        var typesMap = Protocol().decode<TypesMap>(encodedString);

        expect(typesMap.aNullableRecordKey, {});
      });
    });

    group('Empty Maps with String Keys (Control Tests)', () {
      test(
          'Given an empty Map<String, String> when serializing and deserializing then it should work correctly',
          () {
        var object = TypesMap(aStringKey: {});

        var encodedString = SerializationManager.encode(object);
        var typesMap = Protocol().decode<TypesMap>(encodedString);

        expect(typesMap.aStringKey, {});
      });

      test(
          'Given an empty Map<String, int> when serializing and deserializing then it should work correctly',
          () {
        var object = TypesMap(anIntValue: {});

        var encodedString = SerializationManager.encode(object);
        var typesMap = Protocol().decode<TypesMap>(encodedString);

        expect(typesMap.anIntValue, {});
      });
    });

    group('Direct Protocol Deserialization Tests', () {
      test(
          'Given an empty List representing a Map<int, int> when deserializing directly then it should not throw a type cast error',
          () {
        // This simulates the case where an empty Map<int, int> was serialized as an empty List
        var emptyList = <dynamic>[];

        // This should not throw a type cast error
        var result = protocol.deserialize<Map<int, int>>(emptyList);

        expect(result, {});
      });

      //FAILS
      test(
          'Given an empty Map representing a Map<int, int> when deserializing directly then it should not throw a type cast error',
          () {
        // This simulates the edge case where the data is an empty Map instead of a List
        var emptyMap = <String, dynamic>{};

        // This should not throw a type cast error
        var result = protocol.deserialize<Map<int, int>>(emptyMap);

        expect(result, {});
      });

      test(
          'Given null representing a Map<int, int>? when deserializing directly then it should not throw a type cast error',
          () {
        // This should not throw a type cast error
        var result = protocol.deserialize<Map<int, int>?>(null);

        expect(result, isNull);
      });

      test(
          'Given an empty List representing a Map<Types, String> when deserializing directly then it should not throw a type cast error',
          () {
        // This simulates the case where an empty Map<Types, String> was serialized as an empty List
        var emptyList = <dynamic>[];

        // This should not throw a type cast error
        var result = protocol.deserialize<Map<Types, String>>(emptyList);

        expect(result, {});
      });

      //FAILS
      test(
          'Given an empty Map representing a Map<Types, String> when deserializing directly then it should not throw a type cast error',
          () {
        // This simulates the edge case where the data is an empty Map instead of a List
        var emptyMap = <String, dynamic>{};

        // This should not throw a type cast error
        var result = protocol.deserialize<Map<Types, String>>(emptyMap);

        expect(result, {});
      });
    });

    group('JSON Round-trip Tests', () {
      test(
          'Given a TypesMap with empty non-String key maps when encoding to JSON and back then it should not throw a type cast error',
          () {
        var object = TypesMap(
          anIntKey: {},
          aBoolKey: {},
          aDoubleKey: {},
          aDateTimeKey: {},
          aByteDataKey: {},
          aDurationKey: {},
          aUuidKey: {},
          aUriKey: {},
          aBigIntKey: {},
          anEnumKey: {},
          aStringifiedEnumKey: {},
          anObjectKey: {},
          aMapKey: {},
          aListKey: {},
          aRecordKey: {},
          aNullableRecordKey: {},
        );

        var jsonString = jsonEncode(object.toJson());
        var decodedJson = jsonDecode(jsonString);
        var typesMap = TypesMap.fromJson(decodedJson);

        expect(typesMap.anIntKey, {});
        expect(typesMap.aBoolKey, {});
        expect(typesMap.aDoubleKey, {});
        expect(typesMap.aDateTimeKey, {});
        expect(typesMap.aByteDataKey, {});
        expect(typesMap.aDurationKey, {});
        expect(typesMap.aUuidKey, {});
        expect(typesMap.aUriKey, {});
        expect(typesMap.aBigIntKey, {});
        expect(typesMap.anEnumKey, {});
        expect(typesMap.aStringifiedEnumKey, {});
        expect(typesMap.anObjectKey, {});
        expect(typesMap.aMapKey, {});
        expect(typesMap.aListKey, {});
        expect(typesMap.aRecordKey, {});
        expect(typesMap.aNullableRecordKey, {});
      });
    });

    group('Mixed Content Tests', () {
      test(
          'Given a TypesMap with both empty and populated non-String key maps when serializing and deserializing then it should work correctly',
          () {
        var object = TypesMap(
          anIntKey: {1: 'one', 2: 'two'},
          aBoolKey: {},
          aDoubleKey: {3.14: 'pi'},
          aDateTimeKey: {},
          anObjectKey: {Types(anInt: 42): 'answer'},
        );

        var encodedString = SerializationManager.encode(object);
        var typesMap = Protocol().decode<TypesMap>(encodedString);

        expect(typesMap.anIntKey, {1: 'one', 2: 'two'});
        expect(typesMap.aBoolKey, {});
        expect(typesMap.aDoubleKey, {3.14: 'pi'});
        expect(typesMap.aDateTimeKey, {});
        expect(typesMap.anObjectKey?.entries.first.key.anInt, 42);
        expect(typesMap.anObjectKey?.entries.first.value, 'answer');
      });
    });

    group('Server Protocol Tests', () {
      test(
          'Given an empty Map<int, String> when using server protocol then it should not throw a type cast error',
          () {
        var object = server.TypesMap(anIntKey: {});

        var encodedString = SerializationManager.encode(object);
        var typesMap = serverProtocol.decode<server.TypesMap>(encodedString);

        expect(typesMap.anIntKey, {});
      });

      test(
          'Given an empty Map<Types, String> when using server protocol then it should not throw a type cast error',
          () {
        var object = server.TypesMap(anObjectKey: {});

        var encodedString = SerializationManager.encode(object);
        var typesMap = serverProtocol.decode<server.TypesMap>(encodedString);

        expect(typesMap.anObjectKey, {});
      });
    });

    group('Edge Case Tests - The Actual Bug', () {
      //FALIS
      test(
          'Given a Map<int, int> with empty data when deserializing from JSON that contains an empty Map instead of List then it should not throw a type cast error',
          () {
        // This test simulates the exact scenario where the bug occurs:
        // 1. A Map<int, int> is serialized as an empty List []
        // 2. But somehow the JSON contains an empty Map {} instead
        // 3. The deserialization code tries to cast it as List and fails

        // Create a JSON that would cause the bug
        var problematicJson = {
          'anIntKey': {}, // This should be [] but is {} instead
        };

        // This should not throw: type '_Map<String, dynamic>' is not a subtype of type 'List<dynamic>' in type cast
        var typesMap = TypesMap.fromJson(problematicJson);

        expect(typesMap.anIntKey, {});
      });

      //FAILS
      test(
          'Given a Map<Types, String> with empty data when deserializing from JSON that contains an empty Map instead of List then it should not throw a type cast error',
          () {
        // Create a JSON that would cause the bug
        var problematicJson = {
          'anObjectKey': {}, // This should be [] but is {} instead
        };

        // This should not throw: type '_Map<String, dynamic>' is not a subtype of type 'List<dynamic>' in type cast
        var typesMap = TypesMap.fromJson(problematicJson);

        expect(typesMap.anObjectKey, {});
      });

      //FAILS
      test(
          'Given a Map<int, int> when deserializing from a malformed JSON that has empty Map instead of List then it should handle gracefully',
          () {
        // Simulate the exact error scenario
        var malformedData = <String, dynamic>{}; // Empty Map instead of List

        // This should not throw the type cast error
        var result = protocol.deserialize<Map<int, int>>(malformedData);

        expect(result, {});
      });

      //FAILS
      test(
          'Given a Map<Types, String> when deserializing from a malformed JSON that has empty Map instead of List then it should handle gracefully',
          () {
        // Simulate the exact error scenario
        var malformedData = <String, dynamic>{}; // Empty Map instead of List

        // This should not throw the type cast error
        var result = protocol.deserialize<Map<Types, String>>(malformedData);

        expect(result, {});
      });
    });
  });
}
