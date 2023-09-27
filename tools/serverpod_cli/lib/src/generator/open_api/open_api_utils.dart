part of openapi_definition;

extension on ParameterStyle {
  /// convert queryFrom -> query-form
  String get toKebabCase => name.replaceAllMapped(RegExp(r'([a-z])([A-Z])'),
      (match) => '${match.group(1)}-${match.group(2)?.toLowerCase()}');
}

String _getRef(String ref) {
  return '#/components/schemas/$ref';
}

///. The location of the parameter. Possible values are "query", "header", "path" or "cookie".
enum ParameterLocation {
  query,
  header,
  path,
  cookie,
}

///Describes how the parameter value will be serialized depending on the type of the parameter value.
///Default values (based on value of in): for query - form; for path - simple;
/// for header - simple; for cookie - form.
enum ParameterStyle {
  queryForm,
  pathSimple,
  headerSimple,
  cookieSimple,
}
