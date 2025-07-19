# Map Serialization Bug Tests

This directory contains comprehensive unit tests that demonstrate a bug in Serverpod's Map serialization system when dealing with Maps that have non-String keys and contain empty data.

## The Bug

**Error Message:**
```
type '_Map<String, dynamic>' is not a subtype of type 'List<dynamic>' in type cast
```

**Root Cause:**
When Maps with non-String keys (like `Map<int, String>`) contain empty data, they are serialized as empty Lists `[]`. However, during deserialization, if the data is somehow an empty Map `{}` instead of a List, the code tries to cast it with `(data as List)` which throws the type cast error.

## Test Files

### 1. `map_serialization_bug_test.dart`
Comprehensive test suite that covers:
- **Empty Maps with Non-String Keys**: Tests all Map types that should work but currently fail
- **Empty Maps with String Keys**: Control tests that work correctly
- **Direct Protocol Deserialization**: Tests the exact failure scenarios
- **JSON Round-trip Tests**: Tests the full serialization cycle
- **Mixed Content Tests**: Tests Maps with both empty and populated data
- **Server Protocol Tests**: Tests server-side protocol
- **Edge Case Tests**: Tests the exact bug scenarios

### 2. `demonstrate_bug.dart`
Simple demonstration script that shows the bug clearly:
```bash
dart run test/demonstrate_bug.dart
```

## Running the Tests

### Run All Tests
```bash
dart test test/map_serialization_bug_test.dart
```

### Run Specific Test Groups
```bash
# Run only the failing tests (demonstrates the bug)
dart test test/map_serialization_bug_test.dart --plain-name "Edge Case Tests"

# Run only the passing tests (control tests)
dart test test/map_serialization_bug_test.dart --plain-name "Empty Maps with String Keys"
```

### Expected Results

**Currently Failing Tests (6 tests):**
- Direct protocol deserialization with empty Map data
- Edge case tests with malformed JSON
- These demonstrate the exact bug scenario

**Currently Passing Tests (25 tests):**
- Empty Maps with String keys (control tests)
- Normal serialization/deserialization cycles
- Mixed content tests
- Server protocol tests

## Bug Locations

### 1. Serialization Logic
**File:** `packages/serverpod_serialization/lib/src/extensions/serialization_extensions.dart` (lines 94-120)

```dart
extension MapJsonExtension<K, V> on Map<K, V> {
  dynamic toJson({...}) {
    if (_keyType != String) {
      return entries.map((e) => {
        'k': serializedKey,
        'v': serializedValue,
      }).toList(); // Empty Maps become empty Lists []
    }
  }
}
```

### 2. Code Generation Logic
**File:** `tools/serverpod_cli/lib/src/generator/types.dart` (lines 560-580)

```dart
// Generated code expects List but gets Map
const Code('Map.fromEntries((data as List).map((e) =>...')
```

### 3. Generated Protocol Code
**File:** `tests/serverpod_test_client/lib/src/protocol/protocol.dart` (lines 1694-1696)

```dart
if (t == Map<int, int>) {
  return Map.fromEntries((data as List).map((e) => // Fails if data is Map
      MapEntry(deserialize<int>(e['k']), deserialize<int>(e['v'])))) as T;
}
```

## The Fix

The generated deserialization code should check if `data` is a Map before casting as List:

```dart
if (t == Map<int, int>) {
  if (data is Map) {
    return Map<int, int>() as T; // Return empty map
  }
  return Map.fromEntries((data as List).map((e) =>
      MapEntry(deserialize<int>(e['k']), deserialize<int>(e['v'])))) as T;
}
```

## Test Coverage

The tests cover all Map types with non-String keys:
- `Map<int, String>`
- `Map<bool, String>`
- `Map<double, String>`
- `Map<DateTime, String>`
- `Map<ByteData, String>`
- `Map<Duration, String>`
- `Map<UuidValue, String>`
- `Map<Uri, String>`
- `Map<BigInt, String>`
- `Map<TestEnum, String>`
- `Map<TestEnumStringified, String>`
- `Map<Types, String>`
- `Map<Map<Types, String>, String>`
- `Map<List<Types>, String>`
- `Map<(String,), String>`
- `Map<(String,)?, String>`

## Usage

These tests serve as:
1. **Bug demonstration**: Show the exact failure scenarios
2. **Regression prevention**: Ensure the bug doesn't return after fixes
3. **Fix validation**: Confirm that proposed fixes work correctly
4. **Documentation**: Provide clear examples of the issue

## Related Issues

This bug affects any Serverpod project that uses Maps with non-String keys and empty data, particularly in scenarios where:
- Data comes from external sources (APIs, databases)
- JSON parsing produces Maps instead of Lists
- Edge cases in serialization/deserialization pipelines
