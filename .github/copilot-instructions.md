# Copilot Instructions for Serverpod

## Test Writing Guidelines

### Test Description Pattern
Use the "Given, When, Then" pattern for test descriptions to maintain consistency:

```dart
test(
  'Given a class with an index name that matches the table name when analyzing models then collect an error that the index name cannot be the same as the table name.',
  () {
    // Test implementation
  }
);
```

### Test Organization
- Place passing/success test cases at the top of test files
- Group related test cases using `group()` where appropriate
- Follow error test cases with success test cases for the same functionality

## Code Style
- Follow Dart formatting conventions
- Remove unnecessary comments from production code
- Use descriptive variable and function names