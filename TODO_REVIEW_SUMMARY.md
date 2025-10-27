# TODO Review Summary for Serverpod 3.0.0

This document summarizes the comprehensive review of all TODO markers in the Serverpod codebase as part of the 3.0.0 release preparation.

## Summary Statistics

- **Total TODOs found**: 47
- **TODOs already tracked by existing issues**: 7 (via 5 GitHub issues)
- **TODOs fixed in this PR**: 1 (removed unused debug parameter)
- **TODOs requiring new issues**: 39

## Completed Actions

✅ **Fixed Deprecation-Related TODOs**
- Removed unused `debug` parameter from `signInWithGoogle` function and `SignInWithGoogleButton` widget (breaking change for 3.0.0)

## TODOs Already Tracked by Existing Issues

The following TODOs reference existing GitHub issues and don't require new issues:

1. **Issue #2603**: Improve pubspec analysis
   - File: `tools/serverpod_cli/lib/src/internal_tools/analyze_pubspecs.dart:86`

2. **Issue #2711**: Enable inheritance by default
   - File: `tools/serverpod_cli/lib/src/config/experimental_feature.dart:16`

3. **Issue #3298**: Serverpod packages version check (2 occurrences)
   - Files: `tools/serverpod_cli/test/integration/serverpod_packages_version_check/load_config_test.dart:39, 56`

4. **Issue #3391**: Database relation operations (2 occurrences)
   - Files: `tests/serverpod_test_server/test_integration/database_operations/changed_id_type_relations/one_to_one/update/attach_detach_test.dart:296, 311`

5. **Issue #3462**: Unnecessary null comparison workaround
   - File: `tools/serverpod_cli/lib/src/generator/dart/library_generators/model_library_generator.dart:214`

---

## TODOs Requiring New GitHub Issues

### HIGH PRIORITY

#### Issue: Implement localKeys and localSize in RedisCache

**Files**: 
- `packages/serverpod/lib/src/cache/redis_cache.dart:87`
- `packages/serverpod/lib/src/cache/redis_cache.dart:92`

**Description**:
The `RedisCache` class currently throws `UnimplementedError` for the `localKeys` getter and `localSize` getter, which are part of the `GlobalCache` interface. These methods need to be properly implemented to complete the cache interface.

**Context**:
```dart
@override
// TODO: implement localKeys
List<String> get localKeys =>
    throw UnimplementedError('No local keys are used in RedisCache');

@override
// TODO: implement localSize
int get localSize =>
    throw UnimplementedError('No local keys are used in RedisCache');
```

**Suggested Implementation**:
- Research whether Redis-based caches should track local keys or if these methods should return empty/zero values
- Implement the methods according to the intended cache semantics
- Add tests to verify the implementation

**Impact**: API completeness, prevents runtime errors when these methods are called

---

### MEDIUM PRIORITY - Architecture Improvements

#### Issue: Add server cluster support to MessageCentral

**File**: `packages/serverpod/lib/src/server/message_central.dart:16`

**Description**:
The `MessageCentral` class currently only handles communication within a single server instance. It needs to be extended to support communication between servers in a cluster deployment.

**Context**:
```dart
// TODO: Support for server clusters.

/// The [MessageCentral] handles communication within the server, and between
/// servers in a cluster. It is especially useful when working with streaming
/// endpoints.
```

**Suggested Implementation**:
- Design a messaging protocol for cross-server communication
- Implement pub/sub mechanism (possibly Redis-based) for cluster-wide message distribution
- Add configuration options for cluster mode
- Ensure backward compatibility with single-server deployments
- Add comprehensive tests for cluster scenarios

**Impact**: Essential for production deployments with multiple server instances

---

#### Issue: Refactor request handling to use Router from relic package

**File**: `packages/serverpod/lib/src/server/server.dart:190`

**Description**:
The current server implementation uses manual path and HTTP verb dispatch. This should be refactored to use the `Router` class from the `relic` package for better maintainability and extensibility.

**Context**:
```dart
// TODO: Use Router instead of manual dispatch on path and verb
if (uri.path == '/') {
  // Perform health checks
  ...
}
```

**Suggested Implementation**:
- Use the `Router` class from the `relic` package (already a dependency)
- Implement route matching and dispatching logic using relic's Router API
- Migrate existing manual dispatch code to use Router
- Add support for route parameters and pattern matching as provided by relic
- Maintain backward compatibility during transition
- Add tests for route matching edge cases

**Impact**: Code maintainability, extensibility for adding new routes, better error handling

---

#### Issue: Refactor httpResponseHeaders to use Headers class from relic package

**File**: `packages/serverpod/lib/src/server/server.dart:180`

**Description**:
The `httpResponseHeaders` should use the `Headers` class from the `relic` package instead of the current Map implementation for better type safety and API consistency.

**Context**:
```dart
// TODO: Make httpResponseHeaders a Headers object from the get-go.
// or better yet, use middleware
final headers = Headers.build((mh) {
  for (var rh in httpResponseHeaders.entries) {
    mh[rh.key] = ['${rh.value}'];
  }
});
```

**Suggested Implementation**:
- Change `httpResponseHeaders` from `Map<String, String>` to use the `Headers` class from the `relic` package directly
- Refactor code to use the Headers type throughout the codebase
- Update related APIs to work with the new type
- Consider using middleware as suggested in the comment
- Ensure backward compatibility or provide migration guide
- Add tests for header manipulation

**Impact**: Type safety, API consistency, better developer experience

---

### MEDIUM PRIORITY - Feature Enhancements

#### Issue: Add -d/--directory option to serverpod generate command

**File**: `tools/serverpod_cli/lib/src/commands/generate.dart:50`

**Description**:
The `serverpod generate` command should support a `-d` or `--directory` option to allow users to specify which directory to generate code for, rather than always operating on the current directory.

**Context**:
```dart
// TODO: add a -d option to select the directory
GeneratorConfig config;
try {
  config = await GeneratorConfig.load();
```

**Suggested Implementation**:
- Add a `--directory` or `-d` command-line option to the generate command
- Update `GeneratorConfig.load()` to accept an optional directory parameter
- Update command help text and documentation
- Add tests for directory specification
- Handle edge cases (non-existent directories, permission issues, etc.)

**Impact**: Improved CLI usability, especially for monorepo setups or CI/CD pipelines

---

#### Issue: Expand content type mappings in public storage endpoint

**File**: `packages/serverpod/lib/src/cloud_storage/public_endpoint.dart:9`

**Description**:
The public storage endpoint currently has limited content type mappings. More common file types should be added to improve file serving capabilities.

**Context**:
```dart
// TODO: Add more content type mappings.
```

**Current Implementation Analysis Needed**: Review existing mappings and identify gaps

**Suggested Implementation**:
- Audit current content type mappings
- Add mappings for common file types (images, videos, documents, archives, etc.)
- Consider using a standard MIME type library
- Add configuration option for custom mappings
- Add tests for various file types

**Impact**: Better file serving support, fewer content type issues in production

---

#### Issue: Add comparison and additional operations to database column API

**File**: `packages/serverpod/lib/src/database/concepts/columns.dart:62`

**Description**:
The database column API needs additional comparison operators and operations to support more complex queries.

**Context**:
```dart
// TODO: Add comparisons and possibly other operations
```

**Suggested Implementation**:
- Design additional column operations (LIKE, IN, BETWEEN, etc.)
- Implement comparison operators for different data types
- Ensure type-safe query building
- Add comprehensive tests for new operations
- Update documentation with examples

**Impact**: Enhanced query capabilities, better ORM functionality

---

### LOW PRIORITY - Code Quality & Documentation

#### Issue: Review and improve error logging throughout the framework

**Description**:
Multiple locations in the codebase have questions about whether errors should be logged, indicating a need for a comprehensive error logging strategy review.

**Affected Files**:
- `packages/serverpod_client/lib/src/file_uploader.dart:77` - "Shouldn't we log something here?"
- `packages/serverpod/lib/src/server/server.dart:253` - "Log to database?"
- `packages/serverpod/lib/src/server/server.dart:290` - "Log to database?"
- `packages/serverpod/lib/src/server/future_call_manager/future_call_manager.dart:168` - "this should be logged or caught otherwise"
- `packages/serverpod/lib/src/server/health_check_manager.dart:97` - "Sometimes serverpod attempts to write duplicate health checks"
- `tests/serverpod_test_server/test_e2e/connection_test.dart:813` - "Check that it is recorded in error logs"

**Suggested Implementation**:
- Define a comprehensive logging strategy for the framework
- Determine which errors should be logged vs thrown
- Decide on error log destinations (console, database, external service)
- Implement consistent logging patterns across the codebase
- Add configuration options for log levels and destinations
- Address each TODO location based on the strategy

**Impact**: Better error tracking, easier debugging in production

---

#### Issue: Review and resolve code clarification TODOs

**Description**:
Several TODOs ask questions about code behavior that need to be answered by the original developers or through testing.

**Affected Files**:
- `packages/serverpod/lib/src/server/server.dart:241` - "Why set this explicitly?"
- `packages/serverpod/lib/src/server/server.dart:286` - "historically not included"
- `packages/serverpod/lib/src/server/server.dart:386` - "Should we keep doing this?"
- `modules/serverpod_auth/serverpod_auth_server/lib/src/endpoints/google_endpoint.dart:56` - "Double check"
- `modules/serverpod_auth/serverpod_auth_server/lib/src/endpoints/google_endpoint.dart:139` - "This should probably be done on this server"

**Suggested Implementation**:
- Review each location and understand the original intent
- Test behavior to confirm if current implementation is correct
- Either remove the TODO with clarifying comment or implement the suggested change
- Add tests to prevent regression

**Impact**: Code clarity, reduced technical debt

---

#### Issue: Complete type coverage in serialization and code generation

**Description**:
The serialization system and code generator need comprehensive type coverage to handle all Dart native types properly.

**Affected Files**:
- `packages/serverpod_serialization/lib/src/serialization.dart:101` - "all the 'dart native' types should be listed here"
- `tools/serverpod_cli/lib/src/generator/types.dart:386` - "add all supported types here"

**Suggested Implementation**:
- Create a comprehensive list of Dart native types
- Implement serialization/deserialization for each type
- Add code generation support for each type
- Add tests for all type variations
- Document supported types

**Impact**: Better type support, fewer runtime serialization errors

---

#### Issue: Improve SQL expression parsing and quoting in database analyzer

**Description**:
The database analyzer needs improvements in handling quoted identifiers and expressions containing quotes.

**Affected Files**:
- `packages/serverpod/lib/src/database/analyze.dart:222` - "Maybe unquote in the future. Should be considered when Serverpod introduces partial indexes"
- `packages/serverpod/lib/src/database/analyze.dart:363` - "Handle \" that are inside an expression"

**Suggested Implementation**:
- Review SQL quoting rules and edge cases
- Implement proper quote handling in expression parser
- Consider partial index support requirements
- Add tests for various quoting scenarios
- Ensure compatibility with PostgreSQL rules

**Impact**: Better SQL parsing, support for complex database features

---

#### Issue: Refactor CLI code organization and improve cross-platform support

**Description**:
Several CLI-related TODOs indicate areas where code organization could be improved and cross-platform support strengthened.

**Affected Files**:
- `tools/serverpod_cli/lib/src/util/model_helper.dart:61` - "Move this logic to the code generator instead"
- `tools/serverpod_cli/lib/src/database/migration.dart:87` - "Check if table can be modified"
- `tools/serverpod_cli/lib/src/util/process_killer_extension.dart:6` - "Fix for Windows, if necessary"
- `tools/serverpod_cli/test/test_util/endpoint_validation_helpers.dart:10` - "the serverpod import is brittle here"

**Suggested Implementation**:
- Refactor model helper logic into code generator
- Implement table modification checks in migration system
- Test and fix process killing on Windows
- Improve test utility imports to be more robust
- Add cross-platform tests

**Impact**: Better code organization, improved Windows support, more maintainable tests

---

### AUTH SYSTEM RELATED (Depends on New Auth System Deployment)

#### Issue: Complete new authentication system implementation and cleanup

**Description**:
Multiple TODOs are related to completing the new authentication system and cleaning up old auth code. These should be addressed together once the new auth system is fully deployed.

**Affected Files**:
- `modules/new_serverpod_auth/serverpod_auth_idp/serverpod_auth_idp_server/lib/src/providers/apple/business/apple_idp_utils.dart:66` - "Handle the edge-case where we already know the user"
- `modules/new_serverpod_auth/serverpod_auth_idp/serverpod_auth_idp_server/lib/src/providers/apple/business/apple_idp_utils.dart:201` - "Implement session revocation based on the notification"
- `modules/new_serverpod_auth/serverpod_auth_core/serverpod_auth_core_server/lib/src/common/endpoints/status_endpoint.dart:13` - "Replace signout methods implementation by using the TokenManager"
- `modules/serverpod_chat/serverpod_chat_flutter/lib/src/chat_input.dart:90` - "Remove from server"
- `packages/serverpod/lib/src/server/serverpod.dart:488` - "Remove this when we have a better way to handle this"
- `packages/serverpod_client/lib/src/serverpod_client_shared.dart:141` - "Deprecate after the new authentication system is in place"

**Suggested Implementation**:
- Complete new auth system implementation
- Handle Apple IDP edge cases
- Implement session revocation
- Migrate to TokenManager for signout
- Deprecate old auth parameters
- Remove temporary workarounds
- Update documentation and migration guide
- Add comprehensive tests for new auth system

**Impact**: Modern authentication system, better security, cleaner API

---

#### Issue: Remove backwards compatibility code after new auth deployment

**Description**:
Several pieces of backwards compatibility code can be removed once the new authentication system is fully deployed and all users have migrated.

**Affected Files**:
- `packages/serverpod_client/lib/src/serverpod_client_shared.dart:243` - "Remove this backwards compatibility assignment"
- `packages/serverpod_serialization/lib/src/serialization.dart:250` - "Remove this in 2.0.0 as the extensions should be used instead"

**Context**:
The first TODO is about `authenticationKeyManager` backwards compatibility, which should be removed after new auth is deployed.
The second TODO is about serialization fallback, but this should remain as it's an intentional safety feature (not truly a "backwards compatibility" issue).

**Suggested Implementation**:
- Mark `authenticationKeyManager` as deprecated
- Plan removal for next major version after migration period
- Update documentation with migration instructions
- Add warnings for deprecated usage
- Monitor usage before removal

**Impact**: Cleaner API, reduced maintenance burden

---

#### Issue: Template TODOs in library files (Low Priority)

**Description**:
Some library files contain template TODOs that are placeholders and may not need actual implementation.

**Affected Files**:
- `packages/serverpod_service_client/lib/serverpod_service_client.dart:9` - "Export any libraries intended for clients of this package"
- `tests/serverpod_test_shared/lib/src/external_custom_class.dart:1` - "Put public facing types in this file"
- `packages/serverpod/lib/src/database/adapters/postgres/value_encoder.dart:38` - Empty TODO with comment about ByteData detection hack

**Suggested Implementation**:
- Review each file to determine if exports/types are actually needed
- Either implement the suggested additions or remove the TODO if not applicable
- For value_encoder.dart, either improve the ByteData detection or document why current approach is necessary

**Impact**: Code cleanliness, reduced confusion

---

## Recommended Action Plan

1. **Phase 1**: Create GitHub issues for HIGH priority items (RedisCache methods)
2. **Phase 2**: Create GitHub issues for MEDIUM priority Architecture items (cluster support, router, headers)
3. **Phase 3**: Create GitHub issues for MEDIUM priority Features (CLI options, content types, DB operations)
4. **Phase 4**: Create consolidated GitHub issues for LOW priority items (logging, clarifications, type coverage, SQL parsing, CLI refactoring)
5. **Phase 5**: Track AUTH-related TODOs in a single epic issue, to be addressed after new auth system deployment

---

*This review was conducted as part of the 3.0.0 release preparation to clean up technical debt and ensure proper tracking of future work.*
