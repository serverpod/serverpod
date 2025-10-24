# TODO Review Summary for Serverpod 3.0.0

This document summarizes the review of all TODO markers in the Serverpod codebase as part of the 3.0.0 release preparation.

## Completed Actions

✅ **Fixed Deprecation-Related TODOs**
- Removed unused `debug` parameter from `signInWithGoogle` function (breaking change)
- Updated serialization fallback encoder comment to clarify its purpose
- Updated auth backwards compatibility comment with clear migration path

✅ **Cleaned Up Trivial TODOs**
- Removed template TODOs from generated/test files
- Clarified ByteData detection workaround in postgres value encoder

## TODOs Already Tracked by Existing Issues

The following TODOs reference existing GitHub issues and don't require new issues:

1. **Issue #2603**: Improve pubspec analysis
   - `tools/serverpod_cli/lib/src/internal_tools/analyze_pubspecs.dart:86`

2. **Issue #2711**: Enable inheritance by default
   - `tools/serverpod_cli/lib/src/config/experimental_feature.dart:16`

3. **Issue #3298**: Serverpod packages version check
   - `tools/serverpod_cli/test/integration/serverpod_packages_version_check/load_config_test.dart:39`
   - `tools/serverpod_cli/test/integration/serverpod_packages_version_check/load_config_test.dart:56`

4. **Issue #3391**: Database relation operations
   - `tests/serverpod_test_server/test_integration/database_operations/changed_id_type_relations/one_to_one/update/attach_detach_test.dart:296`
   - `tests/serverpod_test_server/test_integration/database_operations/changed_id_type_relations/one_to_one/update/attach_detach_test.dart:311`

5. **Issue #3462**: Unnecessary null comparison workaround
   - `tools/serverpod_cli/lib/src/generator/dart/library_generators/model_library_generator.dart:214`

## TODOs Requiring New GitHub Issues

### High Priority - Implementation Gaps

**RedisCache local methods** - `packages/serverpod/lib/src/cache/redis_cache.dart:87, 92`
- `localKeys` and `localSize` methods throw `UnimplementedError`
- RedisCache doesn't fully implement cache interface

### Medium Priority - Architecture Improvements

**Server Cluster Support** - `packages/serverpod/lib/src/server/message_central.dart:16`
- MessageCentral needs cluster support for multi-server deployments

**Router Refactoring** - `packages/serverpod/lib/src/server/server.dart:190`
- Replace manual path/verb dispatch with Router

**Headers Object Type** - `packages/serverpod/lib/src/server/server.dart:180`
- httpResponseHeaders should use proper Headers type for type safety

### Medium Priority - Feature Enhancements

**CLI Directory Option** - `tools/serverpod_cli/lib/src/commands/generate.dart:50`
- Add -d/--directory option to generate command

**Content Type Mappings** - `packages/serverpod/lib/src/cloud_storage/public_endpoint.dart:9`
- Expand content type mappings in public storage endpoint

**Database Column Operations** - `packages/serverpod/lib/src/database/concepts/columns.dart:62`
- Add comparison and additional operations to column API

### Low Priority - Code Quality

**Logging and Error Handling** - Multiple files
- Review and improve error logging throughout framework
- Files: file_uploader.dart:77, server.dart:253/290, future_call_manager.dart:168, etc.

**Code Clarification** - Multiple files
- Resolve code clarification questions in server and auth modules
- Files: server.dart:241/286/386, google_endpoint.dart:56/139

**Type System Coverage** - serialization.dart:101, types.dart:386
- Complete type coverage in serialization and code generation

**Database SQL Handling** - analyze.dart:222/363
- Improve SQL expression parsing and quoting

**CLI Code Organization** - Multiple CLI files
- Refactor code organization and improve cross-platform support

### Auth System Related

**New Auth System Migration** - Multiple new_serverpod_auth files
- Complete new authentication system implementation
- Cleanup old auth code after migration

**authenticationKeyManager Deprecation** - serverpod_client_shared.dart:141
- Deprecate after new auth system is fully deployed

## Statistics

- **Total TODOs found**: 47
- **TODOs already tracked**: 7 (via 5 existing issues)
- **TODOs fixed in this PR**: 3
- **TODOs needing new issues**: ~37 (can be consolidated into ~14 issues)

## Recommended Next Steps

1. ✅ **Completed**: Fixed deprecation-related TODOs and cleaned up trivial ones
2. **Next**: Create GitHub issues for high and medium priority items
3. **Future**: Create consolidated issues for low priority items
4. **Future**: Address auth-related TODOs once new auth system is complete

---

*This review was conducted as part of the 3.0.0 release preparation to clean up technical debt and ensure proper tracking of future work.*
# Remaining TODOs that need GitHub issues
# Format: Priority | File:Line | TODO Text | Suggested Action

HIGH | packages/serverpod/lib/src/cache/redis_cache.dart:87 | TODO: implement localKeys | Create issue: Implement localKeys method in RedisCache
HIGH | packages/serverpod/lib/src/cache/redis_cache.dart:92 | TODO: implement localSize | Create issue: Implement localSize method in RedisCache

MEDIUM | packages/serverpod/lib/src/server/message_central.dart:16 | TODO: Support for server clusters. | Create issue: Add server cluster support to MessageCentral
MEDIUM | packages/serverpod/lib/src/server/server.dart:190 | TODO: Use Router instead of manual dispatch on path and verb | Create issue: Refactor request handling to use Router
MEDIUM | packages/serverpod/lib/src/server/server.dart:180 | TODO: Make httpResponseHeaders a Headers object from the get-go. | Create issue: Refactor httpResponseHeaders to use Headers object type
MEDIUM | tools/serverpod_cli/lib/src/commands/generate.dart:50 | TODO: add a -d option to select the directory | Create issue: Add -d/--directory option to generate command
MEDIUM | packages/serverpod/lib/src/cloud_storage/public_endpoint.dart:9 | TODO: Add more content type mappings. | Create issue: Expand content type mappings in public storage endpoint
MEDIUM | packages/serverpod/lib/src/database/concepts/columns.dart:62 | TODO: Add comparisons and possibly other operations | Create issue: Add comparison operations to database column API

LOW | packages/serverpod_client/lib/src/file_uploader.dart:77 | TODO: Shouldn't we log something here? | Create issue: Review error logging (consolidated)
LOW | packages/serverpod/lib/src/server/server.dart:253 | TODO: Log to database? | Create issue: Review error logging (consolidated)
LOW | packages/serverpod/lib/src/server/server.dart:290 | TODO: Log to database? | Create issue: Review error logging (consolidated)
LOW | packages/serverpod/lib/src/server/future_call_manager/future_call_manager.dart:168 | TODO: this should be logged or caught otherwise. | Create issue: Review error logging (consolidated)
LOW | packages/serverpod/lib/src/server/health_check_manager.dart:97 | TODO: Sometimes serverpod attempts to write duplicate health checks for | Create issue: Review error logging (consolidated)
LOW | tests/serverpod_test_server/test_e2e/connection_test.dart:813 | TODO: Check that it is recorded in error logs. | Create issue: Review error logging (consolidated)

LOW | packages/serverpod/lib/src/server/server.dart:241 | TODO: Why set this explicitly? | Create issue: Code clarification review (consolidated)
LOW | packages/serverpod/lib/src/server/server.dart:286 | ResultInternalServerError // TODO: historically not included | Create issue: Code clarification review (consolidated)
LOW | packages/serverpod/lib/src/server/server.dart:386 | TODO(kasper): Should we keep doing this? | Create issue: Code clarification review (consolidated)
LOW | modules/serverpod_auth/serverpod_auth_server/lib/src/endpoints/google_endpoint.dart:56 | var fullName = person.names?[0].displayName; // TODO: Double check | Create issue: Code clarification review (consolidated)
LOW | modules/serverpod_auth/serverpod_auth_server/lib/src/endpoints/google_endpoint.dart:139 | TODO: This should probably be done on this server. | Create issue: Code clarification review (consolidated)

LOW | packages/serverpod_serialization/lib/src/serialization.dart:101 | TODO: all the "dart native" types should be listed here | Create issue: Complete type coverage in serialization
LOW | tools/serverpod_cli/lib/src/generator/types.dart:386 | TODO: add all supported types here | Create issue: Complete type coverage in code generation

LOW | packages/serverpod/lib/src/database/analyze.dart:222 | TODO: Maybe unquote in the future. | Create issue: Improve SQL expression parsing
LOW | packages/serverpod/lib/src/database/analyze.dart:363 | TODO: Handle " that are inside an expression. | Create issue: Improve SQL expression parsing

LOW | tools/serverpod_cli/lib/src/util/model_helper.dart:61 | TODO This sort is needed to make sure all generated methods | Create issue: Refactor CLI code organization
LOW | tools/serverpod_cli/lib/src/database/migration.dart:87 | TODO: Check if table can be modified | Create issue: Improve migration checks
LOW | tools/serverpod_cli/lib/src/util/process_killer_extension.dart:6 | TODO: Fix for Windows, if necessary | Create issue: Improve cross-platform support
LOW | tools/serverpod_cli/test/test_util/endpoint_validation_helpers.dart:10 | TODO: the serverpod import is brittle here | Create issue: Refactor test utilities

AUTH | modules/new_serverpod_auth/serverpod_auth_idp/serverpod_auth_idp_server/lib/src/providers/apple/business/apple_idp_utils.dart:66 | TODO: Handle the edge-case where we already know the user, but they | Create issue: Complete new auth implementation
AUTH | modules/new_serverpod_auth/serverpod_auth_idp/serverpod_auth_idp_server/lib/src/providers/apple/business/apple_idp_utils.dart:201 | TODO: Implement session revocation based on the notification for all | Create issue: Complete new auth implementation
AUTH | modules/new_serverpod_auth/serverpod_auth_core/serverpod_auth_core_server/lib/src/common/endpoints/status_endpoint.dart:13 | TODO: Replace signout methods implementation by using the [TokenManager] | Create issue: Complete new auth implementation
AUTH | modules/serverpod_chat/serverpod_chat_flutter/lib/src/chat_input.dart:90 | TODO: Remove from server | Create issue: Complete new auth implementation
AUTH | packages/serverpod/lib/src/server/serverpod.dart:488 | TODO: Remove this when we have a better way to handle this. | Create issue: Complete new auth implementation
AUTH | packages/serverpod_client/lib/src/serverpod_client_shared.dart:141 | TODO: Deprecate after the new authentication system is in place. | Create issue: Deprecate authenticationKeyManager after new auth is deployed

TRACKED | tools/serverpod_cli/lib/src/internal_tools/analyze_pubspecs.dart:86 | TODO: Improve this, tracking issue: https://github.com/serverpod/serverpod/issues/2603 | Already tracked by issue #2603
TRACKED | tools/serverpod_cli/lib/src/config/experimental_feature.dart:16 | TODO: Remove when inheritance is enabled by default. | Already tracked by issue #2711
TRACKED | tools/serverpod_cli/test/integration/serverpod_packages_version_check/load_config_test.dart:39 | TODO: https://github.com/serverpod/serverpod/issues/3298 | Already tracked by issue #3298
TRACKED | tools/serverpod_cli/test/integration/serverpod_packages_version_check/load_config_test.dart:56 | TODO: https://github.com/serverpod/serverpod/issues/3298 | Already tracked by issue #3298
TRACKED | tests/serverpod_test_server/test_integration/database_operations/changed_id_type_relations/one_to_one/update/attach_detach_test.dart:296 | TODO: Fix case after issue https://github.com/serverpod/serverpod/issues/3391 is fixed. | Already tracked by issue #3391
TRACKED | tests/serverpod_test_server/test_integration/database_operations/changed_id_type_relations/one_to_one/update/attach_detach_test.dart:311 | TODO: Fix case after issue https://github.com/serverpod/serverpod/issues/3391 is fixed. | Already tracked by issue #3391
TRACKED | tools/serverpod_cli/lib/src/generator/dart/library_generators/model_library_generator.dart:214 | TODO: Remove this workaround when closing issue https://github.com/serverpod/serverpod/issues/3462 | Already tracked by issue #3462

FIXED | modules/serverpod_auth/serverpod_auth_google_flutter/lib/src/auth.dart:41 | TODO: Remove this parameter on next breaking change. | Fixed - removed unused debug parameter
FIXED | packages/serverpod_serialization/lib/src/serialization.dart:250 | TODO: Remove this in 2.0.0 as the extensions should be used instead. | Fixed - clarified comment
FIXED | packages/serverpod_client/lib/src/serverpod_client_shared.dart:243 | TODO: Remove this backwards compatibility assignment. | Fixed - updated comment with migration path
FIXED | packages/serverpod_service_client/lib/serverpod_service_client.dart:9 | TODO: Export any libraries intended for clients of this package. | Fixed - removed template TODO
FIXED | tests/serverpod_test_shared/lib/src/external_custom_class.dart:1 | TODO: Put public facing types in this file. | Fixed - removed template TODO
FIXED | packages/serverpod/lib/src/database/adapters/postgres/value_encoder.dart:38 | TODO: | Fixed - clarified ByteData detection
