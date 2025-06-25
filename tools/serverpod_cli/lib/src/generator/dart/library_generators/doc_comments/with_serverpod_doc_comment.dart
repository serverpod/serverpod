import 'package:serverpod_cli/src/generator/dart/library_generators/doc_comments/build_doc_comment.dart';

const _withServerpodDocCommentsByParameter = {
  'applyMigrations':
      'Whether pending migrations should be applied when starting Serverpod. Defaults to `true`',
  'enableSessionLogging':
      'Whether session logging should be enabled. Defaults to `false`',
  'rollbackDatabase': '''
Options for when to rollback the database during the test lifecycle.
By default `withServerpod` does all database operations inside a transaction that is rolled back after each `test` case.
Just like the following enum describes, the behavior of the automatic rollbacks can be configured:
```dart
/// Options for when to rollback the database during the test lifecycle.
enum RollbackDatabase {
  /// After each test. This is the default.
  afterEach,

  /// After all tests.
  afterAll,

  /// Disable rolling back the database.
  disabled,
}
```''',
  'runMode':
      'The run mode that Serverpod should be running in. Defaults to `test`.',
  'serverpodLoggingMode':
      'The logging mode used when creating Serverpod. Defaults to `ServerpodLoggingMode.normal`',
  'serverpodStartTimeout':
      'The timeout to use when starting Serverpod, which connects to the database among other things. Defaults to `Duration(seconds: 30)`.',
  'testGroupTagsOverride': '''
By default Serverpod test tools tags the `withServerpod` test group with `"integration"`. 
This is to provide a simple way to only run unit or integration tests. 
This property allows this tag to be overridden to something else. Defaults to `['integration']`.''',
  'experimentalFeatures':
      'Optionally specify experimental features. See [Serverpod] for more information.',
};

var _methodDescription = '''
Creates a new test group that takes a callback that can be used to write tests. 
The callback has two parameters: `sessionBuilder` and `endpoints`.
`sessionBuilder` is used to build a `Session` object that represents the server state during an endpoint call and is used to set up scenarios.
`endpoints` contains all your Serverpod endpoints and lets you call them:
```dart
withServerpod('Given Example endpoint', (sessionBuilder, endpoints) {
  test('when calling `hello` then should return greeting', () async {
    final greeting = await endpoints.example.hello(sessionBuilder, 'Michael');
    expect(greeting, 'Hello Michael');
  });
});
```

**Configuration options**''';

String buildWithServerpodDocComments(List<String> parameters) {
  return buildDocComment(
    generalDescription: _methodDescription,
    docByParameter: Map.from(_withServerpodDocCommentsByParameter)
      ..removeWhere(
        (key, _) => !parameters.contains(key),
      ),
  );
}
