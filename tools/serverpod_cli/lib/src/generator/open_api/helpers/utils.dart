/// Convert a list of directory parts to a path string.
///
/// Example: ['api', 'v1'] => '/api/v1'
String getExtraPath(List<String> subDirParts) =>
    subDirParts.isEmpty ? '' : "/${subDirParts.join('/')}";

/// The location of the parameter. Possible values are "query", "header",
/// "path" or "cookie".
enum ParameterLocation {
  query,
  header,
  path,
  cookie,
  body,
}

/// Describes how the parameter value will be serialized depending on the type
/// of the parameter value.
/// Default values (based on value of in): for query - form; for path - simple;
/// for header - simple; for cookie - form.
enum ParameterStyle {
  queryForm,
  pathSimple,
  headerSimple,
  cookieSimple,
}

/// An enum representing different openAPI schema types.
/// example
/// ```
///  schema:
///       type: object
/// ```
enum SchemaObjectType {
  /// When type converting a [Map], it becomes an [object].
  ///
  /// When generating schemas, both [Map] and [serializableObjects] can be represented
  /// as [object].
  object,
  string,
  integer,
  number,
  array,
  boolean,

  /// When converting [TypeDefinition] non dart core types, they are
  /// represented as [serializableObjects]
  serializableObjects,
}

/// An openAPI string format
enum SchemaObjectFormat {
  /// Full-date notation as defined by RFC 3339, section 5.6, for example,
  /// 2017-07-21
  date,

  /// The date-time notation as defined by RFC 3339, section 5.6,
  /// for example, 2017-07-21T17:32:28Z
  dateTime,

  /// A hint to UIs to mask the input
  password,

  /// base64-encoded characters, for example, U3dhZ2dlciByb2Nrcw==
  byte,

  /// binary data, used to describe files
  binary,

  boolean,

  /// unsupported
  email,
  int32,
  int64,
  uri,
  uuid,
  hostname,
  ipv4,
  ipv6,
  float,
  double,
  time,
  any,
}

enum SecuritySchemeType {
  http,
  apiKey,
  mutualTLS,
  oauth2,
  openIdConnect,
}

enum OpenAPIJsonKey {
  items,
  properties,
  $ref,
  schemas,
  schema,
  securitySchemes,
  description,
  url,
  operationId,
  tags,
  summary,
  externalDocs,
  requestBody,
  parameters,
  security,
  responses,
  name,
  deprecated,
  style,
  explode,
  allowReserved,
  allowEmptyValue,
  post,
  content,
  type,
  nullable,
  additionalProperties,
  scheme,
  flows,
}
