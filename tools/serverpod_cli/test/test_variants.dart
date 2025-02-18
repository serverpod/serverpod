import 'package:meta/meta.dart';
import 'package:test/test.dart';

///
@isTestGroup
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
