import 'package:test/test.dart';

/// Creates test group with the given description, containing a test for each
/// item in [variants].
///
/// The test description is determined by [describeVariant] and each test
/// invocation is passed a variant `T` to its [body] callback.
///
/// Example usage:
/// ```dart
/// testWithVariants(
///    'Given a user',
///    describeVariant: (v) => 'named ${v.name} of age ${v.age}, test that ..',
///    const [
///      (name: 'Bob', age: 42),
///      (name: 'Alice', age: 29),
///    ], (variant) {/* ... */});
/// ```
/// The remaining argument are simply forwarded to [test]
void testWithVariants<T>(
  Object? description,
  Iterable<T> variants,
  dynamic Function(T) body, {
  String Function(T variant)? describeVariant,
  String? testOn,
  Timeout? timeout,
  Object? skip,
  Object? tags,
  Map<String, dynamic>? onPlatform,
  int? retry,
}) {
  group(description, () {
    for (var v in variants) {
      test(
        describeVariant == null ? '$v' : describeVariant(v),
        () => body(v),
        testOn: testOn,
        timeout: timeout,
        skip: skip,
        tags: tags,
        onPlatform: onPlatform,
        retry: retry,
      );
    }
  });
}
