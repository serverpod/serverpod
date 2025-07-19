/// Simple demonstration of the Map serialization bug
///
/// This script shows the exact error that occurs when trying to deserialize
/// Maps with non-String keys that contain empty data.

import 'package:serverpod_test_client/serverpod_test_client.dart';

void main() {
  print('Demonstrating Serverpod Map Serialization Bug\n');

  var protocol = Protocol();

  // Test 1: This should work (and does)
  print('Test 1: Empty Map with String keys (should work)');
  try {
    var object = TypesMap(aStringKey: {});
    var encodedString = SerializationManager.encode(object);
    var typesMap = Protocol().decode<TypesMap>(encodedString);
    print('✓ Success: ${typesMap.aStringKey}');
  } catch (e) {
    print('✗ Failed: $e');
  }

  // Test 2: This should work but currently fails
  print('\nTest 2: Empty Map with int keys (should work but fails)');
  try {
    var object = TypesMap(anIntKey: {});
    var encodedString = SerializationManager.encode(object);
    var typesMap = Protocol().decode<TypesMap>(encodedString);
    print('✓ Success: ${typesMap.anIntKey}');
  } catch (e) {
    print('✗ Failed: $e');
  }

  // Test 3: Direct deserialization with empty Map (demonstrates the bug)
  print(
      '\nTest 3: Direct deserialization with empty Map (demonstrates the bug)');
  try {
    var emptyMap = <String, dynamic>{}; // This should be a List but is a Map
    var result = protocol.deserialize<Map<int, int>>(emptyMap);
    print('✓ Success: $result');
  } catch (e) {
    print('✗ Failed: $e');
    print(
        '  This is the exact error: "type \'_Map<String, dynamic>\' is not a subtype of type \'List<dynamic>\' in type cast"');
  }

  // Test 4: Direct deserialization with empty List (should work)
  print('\nTest 4: Direct deserialization with empty List (should work)');
  try {
    var emptyList = <dynamic>[]; // This is the correct format
    var result = protocol.deserialize<Map<int, int>>(emptyList);
    print('✓ Success: $result');
  } catch (e) {
    print('✗ Failed: $e');
  }

  print('\nSummary:');
  print('- Maps with String keys work correctly');
  print(
      '- Maps with non-String keys fail when data is an empty Map instead of List');
  print('- The fix should handle both empty Lists and empty Maps gracefully');
}
