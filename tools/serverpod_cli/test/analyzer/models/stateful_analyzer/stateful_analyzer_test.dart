import 'package:serverpod_cli/src/generator/code_generation_collector.dart';
import 'package:serverpod_cli/src/util/model_helper.dart';
import 'package:test/test.dart';
import 'package:serverpod_cli/src/analyzer/models/stateful_analyzer.dart';

void main() {
  test(
      'Given that no initial validation was done, then an empty list is returned when validating all files.',
      () {
    var statefulAnalyzer = StatefulAnalyzer([]);

    var models = statefulAnalyzer.validateAll();

    expect(models, []);
  });

  test(
      'When we add and remove a model, then an empty list is returned when validating all files.',
      () {
    var statefulAnalyzer = StatefulAnalyzer([]);

    var modelUri = Uri(path: 'lib/src/model/example.yaml');
    var yamlSource = ModelSource(
      '''
class: Example
fields:
  name: String
''',
      modelUri,
      [],
    );
    statefulAnalyzer.addYamlModel(yamlSource);
    statefulAnalyzer.removeYamlModel(modelUri);

    var models = statefulAnalyzer.validateAll();

    expect(models, []);
  });

  test(
      'Given an empty state, when removing a model that does not exist and validating all, then an empty list is returned',
      () {
    var statefulAnalyzer = StatefulAnalyzer([]);

    var modelUri = Uri(path: 'lib/src/model/example.yaml');
    statefulAnalyzer.removeYamlModel(modelUri);

    var models = statefulAnalyzer.validateAll();

    expect(models, []);
  });

  test(
      'Given an empty state, when validating a single model, then an empty list is returned',
      () {
    var statefulAnalyzer = StatefulAnalyzer([]);

    var modelUri = Uri(path: 'lib/src/model/example.yaml');
    var yaml = '''
class: Example
fields:
  name: String
''';

    var models = statefulAnalyzer.validateModel(yaml, modelUri);

    expect(models, []);
  });
  test(
      'Given a valid model class as the initial state, when validating all, then the class is serialized.',
      () {
    var modelUri = Uri(path: 'lib/src/model/example.yaml');
    var yamlSource = ModelSource(
      '''
class: Example
fields:
  name: String
''',
      modelUri,
      [],
    );

    var statefulAnalyzer = StatefulAnalyzer([yamlSource]);

    var models = statefulAnalyzer.validateAll();

    expect(models.length, 1);
    expect(models.first.className, 'Example');
  });

  test(
      'Given a valid model class and an error callback is registered, when validating all, then the callback is triggered.',
      () {
    var modelUri = Uri(path: 'lib/src/model/example.yaml');
    var yamlSource = ModelSource(
      '''
class: Example
fields:
  name: String
''',
      modelUri,
      [],
    );

    var wasCalled = false;
    var statefulAnalyzer = StatefulAnalyzer([yamlSource], (uri, errors) {
      wasCalled = true;
    });

    statefulAnalyzer.validateAll();
    expect(wasCalled, true, reason: 'The error callback was not triggered.');
  });

  test(
      'Given a model with invalid syntax and an error callback is registered, when validating all, then the callback is triggered.',
      () {
    var modelUri = Uri(path: 'lib/src/model/example.yaml');
    var yamlSource = ModelSource(
      '''''',
      modelUri,
      [],
    );

    var wasCalled = false;
    var statefulAnalyzer = StatefulAnalyzer([yamlSource], (uri, errors) {
      wasCalled = true;
    });

    statefulAnalyzer.validateAll();
    expect(wasCalled, true, reason: 'The error callback was not triggered.');
  });

  test(
      'Given a model with multi line invalid yaml syntax when validating all then error is reported.',
      () {
    var modelUri = Uri(path: 'lib/src/model/example.yaml');
    var invalidSource = ModelSource(
      '''
this is not valid yaml
and neither is this line
''',
      modelUri,
      [],
    );

    var collector = CodeGenerationCollector();
    StatefulAnalyzer([invalidSource], onErrorsCollector(collector))
        .validateAll();

    expect(
      collector.errors,
      isNotEmpty,
      reason: 'Expected an error but none was generated.',
    );

    var error = collector.errors.first;
    expect(error.span, isNotNull);
    expect(error.span!.start.line, 0);
    expect(error.span!.start.column, 0);
    expect(error.span!.end.line, 0);
    expect(error.span!.end.column, 22);
  });

  test(
      'Given a model that was invalid on first validation, when validating the same model with an updated valid syntax, then the previous errors are cleared.',
      () {
    var modelUri = Uri(path: 'lib/src/model/example.yaml');
    var invalidSource = ModelSource(
      '''
class: 
fields:
  name: String
''',
      modelUri,
      [],
    );

    var validSource = ModelSource(
      '''
class: Example
fields:
  name: String
''',
      modelUri,
      [],
    );

    CodeGenerationCollector? reportedErrors;
    var statefulAnalyzer = StatefulAnalyzer([invalidSource], (uri, errors) {
      reportedErrors = errors;
    });

    statefulAnalyzer.validateAll();

    expect(reportedErrors?.errors, hasLength(1),
        reason: 'Expected an error to be reported.');

    statefulAnalyzer.validateModel(validSource.yaml, modelUri);

    expect(reportedErrors?.errors, hasLength(0),
        reason: 'Expected the error to be cleared.');
  });

  test(
      'Given two yaml models with the same class name, when validating all, then an error is reported.',
      () {
    var yamlSource1 = ModelSource(
      '''
class: Example
fields:
  name: String
''',
      Uri(path: 'lib/src/model/example1.yaml'),
      [],
    );

    var yamlSource2 = ModelSource(
      '''
class: Example
fields:
  name: String
''',
      Uri(path: 'lib/src/model/example2.yaml'),
      [],
    );

    CodeGenerationCollector? reportedErrors;

    var statefulAnalyzer =
        StatefulAnalyzer([yamlSource1, yamlSource2], (uri, errors) {
      reportedErrors = errors;
    });

    statefulAnalyzer.validateAll();

    expect(reportedErrors?.errors, hasLength(1),
        reason: 'Expected an error to be reported.');
  });

  test(
      'Given two yaml models with the same class name, when removing and revalidating, then the previous error is cleared.',
      () {
    var yamlSource1 = ModelSource(
      '''
class: Example
fields:
  name: String
''',
      Uri(path: 'lib/src/model/example1.yaml'),
      [],
    );

    var yamlSource2 = ModelSource(
      '''
class: Example
fields:
  name: String
''',
      Uri(path: 'lib/src/model/example2.yaml'),
      [],
    );

    CodeGenerationCollector? reportedErrors;
    var statefulAnalyzer =
        StatefulAnalyzer([yamlSource1, yamlSource2], (uri, errors) {
      reportedErrors = errors;
    });

    statefulAnalyzer.validateAll();

    expect(reportedErrors?.errors, hasLength(1),
        reason: 'Expected an error to be reported.');

    statefulAnalyzer.removeYamlModel(yamlSource2.yamlSourceUri);

    statefulAnalyzer.validateAll();

    expect(reportedErrors?.errors, hasLength(0),
        reason: 'Expected the error to be cleared.');
  });

  test(
      'Given an initial validation with one valid model, when adding a second model with the same class and revalidating, then an error is reported.',
      () {
    var yamlSource1 = ModelSource(
      '''
class: Example
fields:
  name: String
''',
      Uri(path: 'lib/src/model/example1.yaml'),
      [],
    );

    var yamlSource2 = ModelSource(
      '''
class: Example
fields:
  name: String
''',
      Uri(path: 'lib/src/model/example2.yaml'),
      [],
    );

    CodeGenerationCollector? reportedErrors;
    var statefulAnalyzer = StatefulAnalyzer([yamlSource1], (uri, errors) {
      reportedErrors = errors;
    });

    statefulAnalyzer.validateAll();

    expect(reportedErrors?.errors, hasLength(0),
        reason: 'Expected no errors to be reported.');

    statefulAnalyzer.addYamlModel(yamlSource2);

    statefulAnalyzer.validateModel(
        yamlSource2.yaml, yamlSource2.yamlSourceUri);

    expect(reportedErrors?.errors, hasLength(1),
        reason: 'Expected an error to be reported.');
  });
}
