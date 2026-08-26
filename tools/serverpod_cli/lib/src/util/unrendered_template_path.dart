import 'package:path/path.dart' as p;

/// Whether [path] still contains a Serverpod create-template Mustache
/// segment such as `{{#auth}}auth{{!auth}}`.
///
/// Those paths are source for `serverpod create`, not live project code.
/// `serverpod generate` must ignore them so unrendered upgrade templates
/// are not treated as endpoints.
bool isUnrenderedTemplatePath(String path) {
  return p.split(path).any((segment) => segment.contains('{{'));
}
