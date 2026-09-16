---
name: serverpod-modules
description: Create and use Serverpod modules — adding modules, generator.yaml nicknames, model references, creating custom modules. Use when working with modules or shared server/client code.
---

# Serverpod Modules

Modules are reusable Serverpod packages with server, client, and optionally Flutter code in their own endpoint/model namespaces.

## Adding a module

**Server:** Add module server package to `pubspec.yaml` (e.g. `serverpod_auth_idp_server: <serverpod-version>`). Optionally declare in `config/generator.yaml`:

```yaml
modules:
  serverpod_auth_idp:
    nickname: auth
```

Then `dart pub get`, `serverpod generate`. If the module adds tables and database generation is enabled, follow [`../serverpod-migrations/SKILL.md`](../serverpod-migrations/SKILL.md).

**Client:** Add module client package (e.g. `serverpod_auth_idp_client: <serverpod-version>`).

**Flutter:** Add module Flutter package if provided (e.g. `serverpod_auth_idp_flutter: <serverpod-version>`).

Keep Serverpod and module versions aligned.

## Referencing module types in models

```yaml
class: MyClass
fields:
  userInfo: module:serverpod_auth_core:AuthUser
  # Or with nickname:
  userInfo: module:auth:AuthUser
```

Run `serverpod generate` after changes.

## Creating a custom module

```bash
serverpod create --template module my_module
```

Creates server + client packages. Add Flutter package if needed: `flutter create --template package my_module_flutter`. Set `type: module` in `config/generator.yaml`. Prefix table names (e.g. `my_module_orders`) to avoid clashes.

## Module startup hooks

Override post-migration initialization with a single `Module` subclass per package:

```dart
import 'package:serverpod/serverpod.dart';

class MyModule extends Module {
  @override
  Future<void> onStartup(Session session) async {
    // Runs after DB migrations / Redis connect, before API servers start.
  }
}
```

Run `serverpod generate`. The host invokes the local module (if any), then each dependency module sorted by module name (not dependency order). The session has no auth context — do not close or retain it.

Auth handlers and routes still use configure APIs before `Serverpod.start`. This hook is for post-migration work only.
