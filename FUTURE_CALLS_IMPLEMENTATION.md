# Future Calls Typed Interface Implementation

## Overview
This implementation adds code generation for a typed interface to future calls in Serverpod, similar to how endpoints work.

## What Was Implemented

### 1. Analyzer Components (`tools/serverpod_cli/lib/src/analyzer/dart/`)

#### `future_call_analyzers/future_call_class_analyzer.dart`
- Detects classes that extend `FutureCall`
- Validates class names are unique
- Converts class names to camelCase (e.g., `ExampleFutureCall` → `example`)
- Parses methods within future call classes

#### `future_call_analyzers/future_call_method_analyzer.dart`
- Identifies valid future call methods:
  - Must have `Session` as first parameter
  - Must return a `Future`
  - Cannot be `invoke` method (reserved)
  - No stream parameters allowed
- Validates parameters are serializable
- Parses method signatures

#### `future_calls_analyzer.dart`
- Main analyzer that scans Dart files for `FutureCall` classes
- Similar structure to `EndpointsAnalyzer`
- Handles file watching for continuous generation
- Collects and reports validation errors

### 2. Data Definitions (`tools/serverpod_cli/lib/src/analyzer/dart/definitions.dart`)

Added two new classes:
- `FutureCallDefinition`: Represents a future call class
- `FutureCallMethodDefinition`: Represents a method within a future call

### 3. Protocol Definition (`tools/serverpod_cli/lib/src/analyzer/protocol_definition.dart`)

Added `futureCalls` field to `ProtocolDefinition` to include future call definitions alongside endpoints and models.

### 4. Code Generator (`tools/serverpod_cli/lib/src/generator/dart/library_generators/library_generator.dart`)

Added methods to generate:
- `_FutureCallArgs`: Helper class for serializing method arguments
- `_FutureCall{Name}`: Individual classes for each future call with typed methods
- `_FutureCallsAtTime`: Intermediate class that provides access to all future calls
- `FutureCalls`: Main class with `callAtTime()` and `callWithDelay()` methods

### 5. Generator Integration

Updated:
- `generator.dart`: Added `FutureCallsAnalyzer` parameter
- `generator_continuous.dart`: Added support for watching future call files
- `commands/generate.dart`: Creates `FutureCallsAnalyzer` instance

## How It Works

### Developer Experience

1. **Define a Future Call Class:**
```dart
class ExampleFutureCall extends FutureCall {
  Future<void> myMethod(Session session, String name) async {
    // Do something in the future
  }
  
  Future<void> anotherMethod(Session session, int count, {bool flag = false}) async {
    // Another scheduled task
  }
}
```

2. **Generated Code Creates:**
   - `_FutureCallExample` class with typed `myMethod()` and `anotherMethod()`
   - `_FutureCallsAtTime` class with `example` getter
   - `FutureCalls` class with `callAtTime()` and `callWithDelay()` methods

3. **Usage:**
```dart
// Call at a specific time
futureCalls.callAtTime(myDateTime).example.myMethod('Hello');

// Call after a delay
futureCalls.callWithDelay(Duration(hours: 1)).example.myMethod('Hello');
```

## What Still Needs to Be Done

### 1. Runtime Integration

The generated code creates the typed interface, but the runtime needs to:

a. **Expose `futureCalls` globally or via `Serverpod`:**
   - Add a getter in `Serverpod` class that returns `FutureCalls` instance
   - Example: `pod.futureCalls.callAtTime(...).example.myMethod(...)`

b. **Update `FutureCallManager` to handle method-based calls:**
   - Currently expects call name like "testCall"
   - Needs to handle names like "example.myMethod"
   - Parse the serialized arguments and route to correct method

c. **Create dispatcher in generated code:**
   - Generate an `initializeFutureCalls()` method that registers all future calls
   - Each future call should have a dispatcher that:
     - Deserializes the `_FutureCallArgs`
     - Extracts individual parameters
     - Calls the appropriate method

### 2. Example Implementation for Runtime

In the generated `protocol.dart`, add:

```dart
void initializeFutureCalls(Serverpod pod) {
  // Register ExampleFutureCall
  pod.registerFutureCall(
    _ExampleFutureCallDispatcher(),
    'example',
  );
}

class _ExampleFutureCallDispatcher extends FutureCall<_FutureCallArgs> {
  final _instance = ExampleFutureCall();
  
  @override
  Future<void> invoke(Session session, _FutureCallArgs? args) async {
    if (args == null) return;
    
    var argsData = SerializationManager.decode(args.serializedArgs);
    var methodName = argsData['__method__'] as String;
    
    switch (methodName) {
      case 'myMethod':
        await _instance.myMethod(
          session,
          argsData['name'] as String,
        );
        break;
      case 'anotherMethod':
        await _instance.anotherMethod(
          session,
          argsData['count'] as int,
          flag: argsData['flag'] as bool? ?? false,
        );
        break;
    }
  }
}
```

### 3. Update Method Body Generation

The `_buildFutureCallMethodBody` needs to include the method name in serialized args:

```dart
var argsData = {
  '__method__': '${method.name}',
  ...actualParameters
};
```

### 4. Testing

Add tests for:
- Analyzer correctly identifies future call classes
- Analyzer validates method signatures
- Generator produces correct typed interface
- Runtime correctly dispatches to methods
- Parameters are correctly serialized/deserialized

### 5. Documentation

- Update Serverpod documentation with new future calls pattern
- Add migration guide from old string-based registration
- Add examples to templates

## Files Modified

### Analyzer
- `tools/serverpod_cli/lib/src/analyzer/dart/future_call_analyzers/future_call_class_analyzer.dart` (new)
- `tools/serverpod_cli/lib/src/analyzer/dart/future_call_analyzers/future_call_method_analyzer.dart` (new)
- `tools/serverpod_cli/lib/src/analyzer/dart/future_calls_analyzer.dart` (new)
- `tools/serverpod_cli/lib/src/analyzer/dart/definitions.dart` (modified)
- `tools/serverpod_cli/lib/src/analyzer/protocol_definition.dart` (modified)

### Generator
- `tools/serverpod_cli/lib/src/generator/dart/library_generators/library_generator.dart` (modified)
- `tools/serverpod_cli/lib/src/generator/generator.dart` (modified)
- `tools/serverpod_cli/lib/src/generator/generator_continuous.dart` (modified)
- `tools/serverpod_cli/lib/src/commands/generate.dart` (modified)

## Next Steps

1. Complete runtime integration (dispatcher generation)
2. Add method name to serialized arguments
3. Create `initializeFutureCalls()` generator
4. Add `futureCalls` getter to `Serverpod`
5. Write comprehensive tests
6. Update templates and documentation

