/// Converts a list of directory parts to a path string.
///
/// Example: \['api', 'v1'\] => '/api/v1'
String getExtraPath(List<String> subDirParts) =>
    subDirParts.isEmpty ? '' : "/${subDirParts.join('/')}";

/// The location of the parameter.
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
/// ```yaml
///  schema:
///     type: object
/// ```
enum OpenAPISchemaType {
  /// When converting a [Map], it becomes an [object].
  ///
  /// When generating schemas, both [Map] and [serializableObjects]
  /// can be represented as [object].
  object,
  string,
  integer,
  number,
  array,
  boolean,

  /// When converting [TypeDefinition] non core dart types, they are
  /// represented as [serializableObjects].
  serializableObjects,
}

/// An openAPI string format
class SchemaObjectFormat {
  /// Full-date notation as defined by RFC 3339, section 5.6, for example,
  /// 2017-07-21.
  static const data = 'date';

  /// The date-time notation as defined by RFC 3339, section 5.6,
  /// for example, 2017-07-21T17:32:28Z.
  static const dateTime = 'date-time';

  /// A hint to UIs to mask the input.
  static const password = 'password';

  /// base64-encoded characters, for example, U3dhZ2dlciByb2Nrcw== .
  static const byte = 'byte';

  /// binary data, used to describe files
  static const binary = 'binary';

  static const boolean = 'boolean';

  /// unsupported
  static const email = 'email';
  static const int32 = 'int32';
  static const int64 = 'int64';
  static const uri = 'uri';
  static const uuid = 'uuid';
  static const hostname = 'hostname';
  static const ipv4 = 'ipv4';
  static const ipv6 = 'ipv6';
  static const float = 'float';
  static const double = 'double';
  static const time = 'time';
  static const any = 'any';

  /// A duration as defined by duration - RFC3339.
  static const duration = 'duration';
}

enum SecuritySchemeType {
  http,
  apiKey,
  mutualTLS,
  oauth2,
  openIdConnect,
}

class OpenAPIJsonKey {
  static const format = 'format';
  static const inKey = 'in';
  static const requiredKey = 'required';
  static const enumKey = 'enum';
  static const items = 'items';
  static const properties = 'properties';
  static const $ref = '\$ref';
  static const schemas = 'schemas';
  static const schema = 'schema';
  static const securitySchemes = 'securitySchemes';
  static const description = 'description';
  static const url = 'url';
  static const operationId = 'operationId';
  static const tags = 'tags';
  static const summary = 'summary';
  static const externalDocs = 'externalDocs';
  static const requestBody = 'requestBody';
  static const parameters = 'parameters';
  static const security = 'security';
  static const responses = 'responses';
  static const name = 'name';
  static const deprecated = 'deprecated';
  static const style = 'style';
  static const explode = 'explode';
  static const allowReserved = 'allowReserved';
  static const allowEmptyValue = 'allowEmptyValue';
  static const post = 'post';
  static const content = 'content';
  static const type = 'type';
  static const nullable = 'nullable';
  static const additionalProperties = 'additionalProperties';
  static const scheme = 'scheme';
  static const flows = 'flows';
  static const bearerFormat = 'bearerFormat';
  static const openIdConnectUrl = 'openIdConnectUrl';
  static const openapi = 'openapi';
  static const info = 'info';
  static const jsonSchemaDialect = 'jsonSchemaDialect';
  static const servers = 'servers';
  static const paths = 'paths';
  static const title = 'title';
  static const version = 'version';
  static const contact = 'contact';
  static const license = 'license';
  static const termOfService = 'termOfService';
  static const email = 'email';
  static const components = 'components';
  static const oneOf = 'oneOf';
  static const defaultKey = 'default';
  static const anyValue = 'AnyValue';
}
