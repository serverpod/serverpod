# Design: Serverpod Templates

This document proposes an enhancement to Serverpod templates to support conditional rendering.

## Current State

Templates currently only support placeholder replacements with a very verbose setup. The templates also contain valid dart files which are statically analyzed.

This design introduces mustache-based template directives to enable conditional inclusion or removal of directories, files and sections within files for templates.

## Proposed Solution

Introduce mustache syntax for conditionals. In code files (dart and yaml), template directives will be embedded in single line comment blocks to preserve static analysis guarantees.

```dart
import 'dart:io';

import 'package:serverpod/serverpod.dart';
// {{#auth}}
import 'package:serverpod_auth_idp_server/core.dart';
import 'package:serverpod_auth_idp_server/providers/email.dart';
// {{/auth}}

import 'src/generated/endpoints.dart';
import 'src/generated/protocol.dart';
// {{#web}}
import 'src/web/routes/app_config_route.dart';
import 'src/web/routes/root.dart';
// {{/web}}

/// The starting point of the Serverpod server.
void run(List<String> args) async {
  // Initialize Serverpod and connect it with your generated code.
  final pod = Serverpod(args, Protocol(), Endpoints());

  // {{#auth}}
  // Initialize authentication services for the server.
  // Token managers will be used to validate and issue authentication keys,
  // and the identity providers will be the authentication options available for users.
  pod.initializeAuthServices(
    tokenManagerBuilders: [
      // Use JWT for authentication keys towards the server.
      JwtConfigFromPasswords(),
    ],
  );
  // {{/auth}}

  // Start the server.
  await pod.start();
}
```

```yaml
development:
  database: 'DB_PASSWORD'
  # {{#redis}}
  redis: 'REDIS_PASSWORD'
  # {{/redis}}
```

Directories may also have template directives in their names using a modified syntax where tags are closed with `{{!variable}}` to enable conditional rendering of entire directories based on enabled features.

For example:

- `project_name_server_upgrade/{{#web}}web{{!web}}` is processed as `project_name_server_upgrade/{{#web}}web{{/web}}`
- `project_name_server_upgrade/lib/src/{{#auth}}auth{{!auth}}` is processed as `project_name_server_upgrade/lib/src/{{#auth}}auth{{/auth}}`

Files may also have template directives in their names using the same modified syntax as above. A file with an extension may have only its name before the extension enclosed with template directives: `foo/{{#a}}bar{{!a}}.dart`.

For example:

- `project_name_server_upgrade/{{#docker}}Dockerfile{{!docker}}` is processed as `project_name_server_upgrade/{{#docker}}Dockerfile{{/docker}}`
- `project_name_server_upgrade/config/{{#docker}}passwords{{!docker}}.yaml` is processed as `project_name_server_upgrade/config/{{#docker}}passwords{{/docker}}.yaml`

After the current Serverpod create command runs, then all server files will be rendered to include or remove the conditional sections based on enabled parameters in the context. When rendering produces a directory with an empty name, then the directory is deleted along with all the files contained in it. Likewise, when rendering produces a file with an empty name or empty content, then the file is deleted.
