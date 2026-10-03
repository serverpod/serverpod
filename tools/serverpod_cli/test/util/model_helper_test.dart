import 'package:serverpod_cli/src/util/model_helper.dart';
import 'package:test/test.dart';

void main() {
  group('Given a file path with a model file extension', () {
    for (var path in [
      'lib/src/models/example.spy.yaml',
      'lib/src/models/example.spy.yml',
      'lib/src/models/example.spy',
      'lib/example.spy.yaml',
    ]) {
      test('when checking "$path" then it is recognized as a model file.', () {
        expect(ModelHelper.isModelFile(path), isTrue);
      });
    }
  });

  group('Given a file path without a model file extension', () {
    for (var path in [
      'lib/src/models/example.yaml',
      'lib/src/models/example.yml',
      'lib/src/protocol/example.yaml',
      'lib/src/models/example.dart',
      'pubspec.yaml',
    ]) {
      test(
        'when checking "$path" then it is not recognized as a model file.',
        () {
          expect(ModelHelper.isModelFile(path), isFalse);
        },
      );
    }
  });

  group('Given a model file uri', () {
    for (var (fileName, expected) in [
      ('example.spy.yaml', 'example'),
      ('example.spy.yml', 'example'),
      ('example.spy', 'example'),
      ('my.model.spy.yaml', 'my.model'),
      ('spy.spy.yaml', 'spy'),
    ]) {
      test(
        'when extracting the file name of "$fileName" '
        'then the model file extension is removed.',
        () {
          var uri = Uri.file('/project/lib/src/models/$fileName');
          expect(ModelHelper.modelFileNameWithoutExtension(uri), expected);
        },
      );
    }
  });
}
