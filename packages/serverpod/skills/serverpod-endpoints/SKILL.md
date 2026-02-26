---
name: serverpod-endpoints
description: Define Serverpod endpoints, use Session, pass parameters, and call from client. Use when creating RPC endpoints, working with Session, or client code generation.
---

# Serverpod Endpoints

Extend `Endpoint` with async methods; first parameter is `Session`, return `Future<T>` (or `Stream<T>` for real-time data streaming). Place anywhere under server `lib/`. Run `serverpod generate` to update the client.

## Defining an endpoint

```dart
import 'package:serverpod/serverpod.dart';

class ExampleEndpoint extends Endpoint {
  Future<String> hello(Session session, String name) async {
    return 'Hello $name';
  }
}
```

Client name is derived from the class name minus `Endpoint` suffix (`ExampleEndpoint` → `example`).

## Calling from the client

```dart
var result = await client.example.hello('World');
```

Client initialized once:

```dart
final serverUrl = await getServerUrl();
client = Client(serverUrl)
  // When using Flutter:
  ..connectivityMonitor = FlutterConnectivityMonitor()
  // When using authentication:
  ..authSessionManager = FlutterAuthSessionManager();
```

## Supported parameter and return types

- Primitives: `bool`, `int`, `double`, `String`
- `Duration`, `DateTime` (UTC), `ByteData`, `UuidValue`, `Uri`, `BigInt`
- Generated serializable models (from `.spy.yaml`)
- `List`, `Map`, `Set`, `Record` — strictly typed with the above

Default request size limit: 512 kB. Change with `maxRequestSize` in config. Use the file upload API for large files.

## Session

Provides: database access (`session.db`, `Model.db`), cache (`session.caches`), logging, request context. Do not capture for use after the request completes.

## Excluding from code generation

- **Entire endpoint:** `@doNotGenerate` on the class.
- **Single method:** `@doNotGenerate` on the method.

## Endpoint inheritance

- **Concrete extends concrete:** Client gets both; subclass exposes own + inherited methods.
- **Abstract endpoint:** Not registered; only concrete subclass is exposed.
- **Parent with `@doNotGenerate`:** Parent hidden; subclass gets a client implementing inherited methods.

Overriding is allowed: same signature, different behavior, client code unchanged.

## Backward compatibility

Older app versions may still call your server. Do not rename parameters (REST API passes by name). Do not delete methods or change signatures — add new methods or optional named parameters instead.

When you must break an endpoint's API, create a versioned endpoint:

```dart
@Deprecated('Use TeamV2Endpoint instead')
class TeamEndpoint extends Endpoint {
  Future<TeamInfo> join(Session session) async { /* ... */ }
}

class TeamV2Endpoint extends TeamEndpoint {
  @override
  @doNotGenerate
  Future<TeamInfo> join(Session session) async => throw UnimplementedError();

  Future<NewTeamInfo> joinWithCode(Session session, String invitationCode) async {
    // New implementation
  }
}
```

Old clients use `client.team.join()`; new clients use `client.teamV2.joinWithCode(...)`. Remove the old endpoint after all clients upgrade. Alternative: extract logic into a helper class callable from both endpoints.
