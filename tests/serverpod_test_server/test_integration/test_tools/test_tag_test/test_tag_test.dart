import 'dart:io';

import 'package:path/path.dart' as path;
import 'package:test/test.dart';

enum TestTag { include, exclude }

void main() async {
  test('Given custom tag '
      'when including test tag '
      'then test is run', () async {
    final result = await runTest(
      TestTag.include,
      'customTag',
      'dummy_custom_tag.dart',
    );

    expect(result.exitCode, 0);
    expect(result.stdout, contains('dummy test passes'));
  });

  test('Given custom tag '
      'when excluding test tag '
      'then test is not run', () async {
    final result = await runTest(
      TestTag.exclude,
      'customTag',
      'dummy_custom_tag.dart',
    );

    expect(result.exitCode, isNot(equals(0)));
    // The reporter differs by environment (the GitHub reporter is auto-selected
    // on CI, the default one locally), so accept either "no tests" phrasing.
    expect(
      result.stdout,
      anyOf(contains('No tests ran'), contains('0 tests passed')),
    );
  });

  test('Given default tag '
      'when including test tag '
      'then test is run', () async {
    final result = await runTest(
      TestTag.include,
      'integration',
      'dummy_default_tag.dart',
    );

    expect(result.exitCode, 0);
    expect(result.stdout, contains('dummy test passes'));
  });

  test('Given default tag '
      'when excluding test tag '
      'then test is not run', () async {
    final result = await runTest(
      TestTag.exclude,
      'integration',
      'dummy_default_tag.dart',
    );

    expect(result.exitCode, isNot(equals(0)));
    // The reporter differs by environment (the GitHub reporter is auto-selected
    // on CI, the default one locally), so accept either "no tests" phrasing.
    expect(
      result.stdout,
      anyOf(contains('No tests ran'), contains('0 tests passed')),
    );
  });
}

Future<ProcessResult> runTest(TestTag includeTag, String tag, String testFile) {
  return Process.run(
    'dart',
    [
      'test',
      '--concurrency=1',
      includeTag == TestTag.include ? '--tags=$tag' : '--exclude-tags=$tag',
      path.joinAll([
        'test_integration',
        'test_tools',
        'test_tag_test',
        testFile,
      ]),
    ],
    runInShell: true,
  );
}
