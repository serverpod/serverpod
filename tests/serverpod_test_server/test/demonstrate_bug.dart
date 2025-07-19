/// Simple demonstration of the Map serialization bug
///
/// This script shows the exact error that occurs when trying to deserialize
/// Maps with non-String keys that contain empty data.

import 'package:serverpod_test_client/serverpod_test_client.dart';

void main() {
  print('Demonstrating Serverpod Map Serialization Bug\n');

  // Test 1: Empty Map with String keys (should work)
  print('Test 1: Empty Map with String keys (should work)');
  try {
    final result = Protocol().deserialize<Map<String, String>>({});
    print('✓ Success: $result');
  } catch (e) {
    print('✗ Failed: $e');
  }

  // Test 2: Empty Map with int keys (should work but fails)
  print('\nTest 2: Empty Map with int keys (should work but fails)');
  try {
    final result = Protocol().deserialize<Map<int, int>>({});
    print('✓ Success: $result');
  } catch (e) {
    print('✗ Failed: $e');
  }

  // Test 3: Direct deserialization with empty Map (demonstrates the bug)
  print(
      '\nTest 3: Direct deserialization with empty Map (demonstrates the bug)');
  try {
    final result = Protocol().deserialize<Map<int, int>>({});
    print('✓ Success: $result');
  } catch (e) {
    print('✗ Failed: $e');
  }

  // Test 4: Direct deserialization with empty List (should work)
  print('\nTest 4: Direct deserialization with empty List (should work)');
  try {
    final result = Protocol().deserialize<Map<int, int>>([]);
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
