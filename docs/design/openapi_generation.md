# OpenAPI Specification Generation

`serverpod generate` can produce an [OpenAPI 3.1](https://spec.openapis.org/oas/v3.1.0) document describing the endpoints of a project. It is off by default. The document is meant for documentation, API explorers (Swagger UI, Postman), and client generators for languages that Serverpod has no client for.

## Enabling it

Add an `openapi` section to `config/generator.yaml` of the server package:

```yaml
openapi:
  enabled: true
  title: My API          # Optional. Defaults to the project name.
  version: 1.0.0         # Optional. Defaults to 1.0.0.
  securitySchemes:       # Optional. Declares the schemes @OpenApiAuth can refer to.
    serverpodAuth:
      type: http
      scheme: bearer
```

The next `serverpod generate` writes `lib/src/generated/openapi.json`, next to `protocol.yaml`. Setting `enabled: false` (or removing the section) only stops the file from being generated. An existing `openapi.json` is not deleted and becomes stale, so remove it yourself if you no longer want it.

The base URLs of the environments need no configuration, see [Servers](#servers-and-test-credentials). Each entry under `securitySchemes` is copied unchanged into `components.securitySchemes`, so anything the OpenAPI specification allows works: `http`, `apiKey`, `oauth2`, `openIdConnect`. Every scheme needs a `type`.

> [!NOTE]
> `config/generator.yaml` is read when `serverpod generate` starts. In `--watch` mode, restart the command after changing the `openapi` section.

## Servers and test credentials

The `servers` of the document list where the API can be reached. Each entry under `openapi.environments` in `generator.yaml` is an environment (a run mode of your choosing) and becomes a server, in the order written. Nothing is read from `config/<run mode>.yaml`.

```yaml
openapi:
  securitySchemes:
    bearerAuth: { type: http, scheme: bearer }
  environments:
    development:
      description: Local development server
      apiServer:
        publicScheme: http
        publicHost: localhost
        publicPort: 8080
      insightsServer:
        publicScheme: http
        publicHost: localhost
        publicPort: 8081
      testCredentials:
        bearerAuth:
          - userName: guest
            password: guest-pass
    sandbox:
      apiServer:
        publicScheme: https
        publicHost: sandbox.example.com
```

gives

```json
"servers": [
  {"url": "http://localhost:8080", "description": "Local development server",
   "x-insights-url": "http://localhost:8081", "x-test-credentials": {"bearerAuth": [{"userName": "guest", "password": "guest-pass"}]}},
  {"url": "https://sandbox.example.com", "description": "Sandbox"}
]
```

| Key | Meaning |
| --- | --- |
| `apiServer` | Required. `publicScheme` (`http` or `https`), `publicHost` and an optional `publicPort`, as in `config/<run mode>.yaml`. The port is left out of the URL when it is the default of the scheme. |
| `insightsServer` | Optional. Same shape. Written to the server as the `x-insights-url` extension. |
| `description` | Defaults to the capitalized name, such as `Staging`. |
| `testCredentials` | Credentials for trying the API in this environment. See below. |

If `environments` is absent the document has no `servers` and tools assume the document's own location. Unknown keys are rejected, which catches typos.

### Test credentials

OpenAPI has no field for credentials, so `testCredentials` are written to the server as the `x-test-credentials` extension. They are keyed by the name of a security scheme declared under `securitySchemes`, and the value is copied as it is written, so use whatever shape suits the scheme: a map for one account, or a list for several.

```json
{
  "url": "http://localhost:8080",
  "description": "Local development server",
  "x-test-credentials": {
    "bearerAuth": [{"userName": "guest", "password": "guest-pass"}]
  }
}
```

Tools that do not know the extension ignore it. It is meant for people reading the document and for tooling that wants to offer ready-made logins.

> [!WARNING]
> The generated file is written to the source tree and normally committed. Only configure credentials of a test account that is safe to share. Configuring credentials for the `production` environment prints a warning when the code is generated.

Naming a scheme in `testCredentials` that is not declared under `securitySchemes` is a configuration error.

## What is described

Serverpod exposes every endpoint method as `POST /{endpoint}/{method}` with a JSON object holding the named parameters as the body. The generated document follows that:

| Dart | OpenAPI |
| --- | --- |
| Endpoint method | `POST /{endpoint}/{method}` with `operationId` `{endpoint}_{method}` |
| Endpoint name | Operation tag |
| Doc comment | `summary` (first paragraph) and `description` |
| Parameters (after `Session`) | Properties of the JSON request body. Non-nullable required parameters are listed as `required` |
| `Future<T>` | `200` response with the schema of `T`. `Future<void>` has no body |
| `@Deprecated` | `deprecated: true` |
| Models and enums | `components.schemas`, referenced with `$ref` |

Always documented responses are `400` (invalid parameters) and `500`. When the operation has security requirements, `401` is added, and `403` when any scope is required.

Only endpoint classes of the project itself are described, not the endpoints that modules bring along. An endpoint class of the project that extends a module's base class (such as the identity provider endpoints of `serverpod_auth_idp`) is a project endpoint, and its inherited methods are described like any other.

### Not described

- Methods that return or accept a `Stream`. They use WebSockets, which OpenAPI cannot express.
- Endpoints and methods annotated with `@doNotGenerate` or `@openApiExclude`, and abstract endpoints.

### Type mapping

| Dart | Schema |
| --- | --- |
| `String` | `string` |
| `int` | `integer`, format `int64` |
| `double` | `number`, format `double` |
| `bool` | `boolean` |
| `DateTime` | `string`, format `date-time` |
| `Duration` | `integer` (milliseconds) |
| `UuidValue` | `string`, format `uuid` |
| `Uri` | `string`, format `uri` |
| `BigInt` | `string` |
| `ByteData` | `string`, format `byte` |
| `List<T>` | `array` |
| `Set<T>` | `array` with `uniqueItems` |
| `Map<String, T>` | `object` with `additionalProperties` |
| `Map<K, V>`, `K` not `String` | `array` of `{k, v}` objects, which is how Serverpod serializes them |
| Records, geography types | `object` |
| Vector types | `array` of `number` |
| Nullable `T?` | The schema of `T` combined with `null` |
| Enums | `string` with the value names, or `integer` for enums serialized by index |
| Model classes | `object` with the fields that are sent to clients, named by their JSON key |

Fields with a `scope` of `serverOnly` or `none` are left out of model schemas, and fields with a `jsonKey` use that key.

## Annotations

The annotations are exported from `package:serverpod_shared/annotations.dart` (and re-exported by `package:serverpod`). They apply to endpoint classes and methods; an annotation on a method wins over one on its class. They only affect the generated document. They are never copied into generated client or server code, and they do not change how requests are handled.

### `@OpenApiAuth`

Declares how an endpoint or method is authenticated.

```dart
@OpenApiAuth('serverpodAuth', scopes: ['admin'])
class AdminEndpoint extends Endpoint {
  Future<void> reset(Session session) async { /* ... */ }

  @unauthenticatedClientCall
  Future<String> status(Session session) async => 'ok';
}
```

The first argument must name a scheme declared under `openapi.securitySchemes`. Using an undeclared name is a code generation error, reported at the endpoint class or method, and the endpoint is left out of the generated code until it is fixed:

```
The security scheme "nope" used by @OpenApiAuth is not declared under
"openapi.securitySchemes" in config/generator.yaml. Declared schemes: serverpodAuth.
```

The check only runs while `openapi.enabled` is `true`.

How the security of an operation is resolved:

1. `@OpenApiAuth` on the method.
2. `@unauthenticatedClientCall` on the method: public (`security: []`).
3. `@OpenApiAuth` on the class.
4. `@unauthenticatedClientCall` on the class: public.
5. Otherwise no `security` is written, meaning the document makes no statement.

`@OpenApiAuth` can be repeated on one element to describe alternatives; any one of them is then enough.

Serverpod does not infer security from `requireLogin` or `requiredScopes`, since those are runtime getters the analyzer cannot evaluate. Keep `@OpenApiAuth` and those getters in agreement.

**Which scheme to declare.** The server reads the key from the `Authorization` header and accepts `Bearer <key>`, `Basic <base64 key>` or the bare key. The scheme in the example above (`http` / `bearer`) therefore matches what the generated Dart clients send, where the key is whatever the authentication handler of the project issues, such as a JWT.

### `@OpenApiDoc`

Adds or overrides documentation of the operation. Values set here take precedence over the doc comment.

```dart
@OpenApiDoc(
  summary: 'Create a booking',
  description: 'Reserves the room for the given period.',
  tags: ['bookings'],
  operationId: 'createBooking',
)
Future<Booking> create(Session session, BookingRequest request) async { /* ... */ }
```

All arguments are optional. Without `tags`, the endpoint name is used. An `@OpenApiDoc` on the endpoint class supplies the `summary`, `description` and `tags` of methods that do not set their own; `operationId` is only read from the method.

### `@OpenApiResponse`

Documents an additional response, typically an error. Can be repeated.

```dart
@OpenApiResponse(404, 'No booking with that id exists.')
@OpenApiResponse(409, 'The room is already booked.')
Future<Booking> get(Session session, int id) async { /* ... */ }
```

### `@openApiExclude`

Hides an endpoint or method from the document while still generating its server and client code. Use `@doNotGenerate` to skip code generation altogether.

## Output stability

The document is deterministic: paths, schemas, security schemes and response codes are sorted. Like the other generated files, it is only rewritten when its content changes, and it takes part in the regular staleness check, so changing `generator.yaml` or an endpoint regenerates it.

## Limitations

- **Types without a model definition.** Classes from modules that only ship generated code, and classes declared under `extraClasses`, have no model definition the generator can read. They are described from their Dart declaration instead: every public instance field is included (including fields their model marks `serverOnly`), and enums are assumed to be serialized by name. Project models are exact.
- **Inheritance.** Sealed and inherited model hierarchies are not described as `oneOf` or `allOf`; a model schema holds the fields of the class including inherited ones.
- **Exceptions.** Serializable exceptions that an endpoint throws are not turned into error responses. Document them with `@OpenApiResponse`.
- **Records** are described only as `object`.
- **Types that cannot be resolved** at all become an empty schema (`{}`), which accepts anything.
- **Validation.** The output has been checked for syntax with `postman spec lint --issueType=syntax`. It has not been checked against rule sets such as Spectral's recommended ruleset.

## Implementation

| Part | Location |
| --- | --- |
| Annotations | `packages/serverpod_shared/lib/src/annotations.dart` |
| Annotation parsing | `tools/serverpod_cli/lib/src/analyzer/dart/endpoint_analyzers/annotation.dart` |
| Scheme validation | `tools/serverpod_cli/lib/src/analyzer/dart/endpoint_analyzers/openapi_annotation_validator.dart` |
| Configuration | `OpenApiConfig` in `tools/serverpod_cli/lib/src/config/openapi_config.dart` |
| Generator | `tools/serverpod_cli/lib/src/generator/yaml/openapi_generator.dart` |
