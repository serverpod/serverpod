import 'package:path/path.dart' as p;
import 'package:serverpod_cli/src/util/unrendered_template_path.dart';
import 'package:test/test.dart';

void main() {
  test(
    'Given a path whose directory name contains a Mustache create-template marker, '
    'when isUnrenderedTemplatePath is called, '
    'then the path is reported as unrendered.',
    () {
      expect(
        isUnrenderedTemplatePath(
          p.join('lib', 'src', '{{#auth}}auth{{!auth}}', 'endpoint.dart'),
        ),
        isTrue,
      );
    },
  );

  test(
    'Given a path with no Mustache markers, '
    'when isUnrenderedTemplatePath is called, '
    'then the path is not reported as unrendered.',
    () {
      expect(
        isUnrenderedTemplatePath(p.join('lib', 'src', 'auth', 'endpoint.dart')),
        isFalse,
      );
    },
  );
}
