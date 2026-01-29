# Persistent Log Environment Variable Analysis

## Overview

This document explains how the `SERVERPOD_SESSION_PERSISTENT_LOG_ENABLED` environment variable is handled in Serverpod, and what the default values are for mini and standard projects.

## ⚠️ Important Default Behavior

**If you have a database configured and do NOT specify `persistentEnabled` in your production.yaml (or any other config file) and do NOT set the `SERVERPOD_SESSION_PERSISTENT_LOG_ENABLED` environment variable, then persistent logging IS ENABLED BY DEFAULT.**

This is intentional behavior - when a database is available, Serverpod automatically enables persistent logging unless you explicitly disable it.

## Environment Variable Definition

**Variable Name:** `SERVERPOD_SESSION_PERSISTENT_LOG_ENABLED`

**Location:** `/packages/serverpod_shared/lib/src/environment_variables.dart` (lines 259-260)

**Type:** Boolean (parsed via `bool.parse()`)

**Config Key:** `persistentEnabled` (under `sessionLogs` section in YAML config files)

## How It's Handled

### 1. Environment Variable Processing

The environment variable is processed through several functions in `/packages/serverpod_shared/lib/src/config.dart`:

- **`_buildSessionLogsConfigMap()`** (lines 846-857): Extracts the environment variable and converts it to a boolean
- **`_buildConfigMap()`** (lines 868-882): Merges configuration file values with environment variable overrides
- **`_extractMapEntry()`** (lines 884-900): Retrieves and converts the environment variable value

### 2. Priority Order

Environment variables **always override** configuration file settings:
1. Environment variable value (if set)
2. Configuration file value (YAML)
3. Default value (based on database availability and run mode)

## Default Values

### Default Behavior (when no config is specified)

From `SessionLogConfig.buildDefault()` (lines 721-732):

| Scenario | Persistent Logging | Console Logging |
|----------|-------------------|-----------------|
| **No Database** | `false` (disabled) | `true` (enabled) |
| **Database Enabled + Development** | `true` (enabled) | `true` (enabled) |
| **Database Enabled + Production** | `true` (enabled) | `false` (disabled) |

**Key Logic:**
```dart
persistentEnabled: databaseEnabled,
consoleEnabled: !databaseEnabled || runMode == _developmentRunMode,
```

## Mini vs Standard Project Templates

### Mini Project (`serverpod create --mini`)

**Template Used:** Base `projectname_server` template only (no upgrade files)

**Configuration:** No config files included in base template - falls back to code defaults

**Default Behavior:**
- **Persistent Logging:** `false` (no database configured by default)
- **Console Logging:** `true` (always enabled when no database)
- **Database:** Not configured

### Standard Project (`serverpod create`)

**Templates Used:** 
1. Base `projectname_server` template
2. Additional `projectname_server_upgrade` files (includes config directory)

**Configuration Files:** Multiple environment-specific configs in `/config/`:

#### development.yaml (lines 50-52)
```yaml
sessionLogs:
  persistentEnabled: true
  consoleEnabled: true
  consoleLogFormat: text
```

#### test.yaml (lines 47-49)
```yaml
sessionLogs:
  persistentEnabled: true
  consoleEnabled: true
```

#### production.yaml (lines 54-56)
```yaml
sessionLogs:
  consoleEnabled: false
# persistentEnabled: true  # commented out (uses default: true)
```

#### staging.yaml
Similar to production, with customizable settings

**Default Behavior:**
- **Development:** Both persistent and console logging enabled
- **Test:** Both persistent and console logging enabled
- **Production:** Only persistent logging enabled (console disabled)
- **Database:** Configured and enabled in all environments

## Environment Variable Override

The `SERVERPOD_SESSION_PERSISTENT_LOG_ENABLED` environment variable can override any of these defaults:

```bash
# Enable persistent logging (overrides config file)
export SERVERPOD_SESSION_PERSISTENT_LOG_ENABLED=true

# Disable persistent logging (overrides config file)
export SERVERPOD_SESSION_PERSISTENT_LOG_ENABLED=false
```

### Validation

From `_validate()` (lines 762-770):

**Error Condition:** If persistent logging is enabled but database is not available, a `StateError` is thrown:

```
Persistent session logs cannot be enabled when the database is disabled.
```

This ensures that persistent logging can only be enabled when there's a database to store the logs.

## Summary Table

| Project Type | Default Persistent Log | Console Log | Database | Config Files |
|-------------|----------------------|-------------|----------|--------------|
| **Mini** | `false` | `true` | ❌ Not configured | ❌ None |
| **Standard - Dev** | `true` | `true` | ✅ Configured | ✅ Multiple |
| **Standard - Test** | `true` | `true` | ✅ Configured | ✅ Multiple |
| **Standard - Prod** | `true` | `false` | ✅ Configured | ✅ Multiple |

## Key Takeaways

1. **Environment variables override config files** - `SERVERPOD_SESSION_PERSISTENT_LOG_ENABLED` always takes precedence
2. **Mini projects default to console-only logging** - No persistent logging since no database is configured
3. **Standard projects default to persistent logging** - Database is configured, so persistent logging is enabled
4. **Persistent logging requires a database** - Validation prevents enabling persistent logs without database
5. **Production disables console logging** - Only persistent logging enabled in production for standard projects

## Production Configuration - Confirmed Behavior

**Q: If I have nothing in my production.yaml and no environment variable configured, is persistent logging enabled by default (assuming I have a database)?**

**A: YES** ✅ - Persistent logging is **enabled by default** when:
- A database is configured in your production.yaml
- The `persistentEnabled` setting is **not** specified in the `sessionLogs` section
- The `SERVERPOD_SESSION_PERSISTENT_LOG_ENABLED` environment variable is **not** set

This behavior is verified by the test case in `/packages/serverpod_shared/test/session_logs_config_test.dart` (lines 102-132):

```dart
test(
  'Given a Serverpod config with "production" run mode missing sessionLogs configuration and a database when loading from Map then sessionLogs defaults to persistent logging enabled and json console logging disabled',
  () {
    // ... test confirms persistentEnabled is true by default in production with database
    expect(config.sessionLogs.persistentEnabled, isTrue);
  },
);
```

### How to Disable Persistent Logging in Production

If you want to disable persistent logging in production, you must **explicitly** set it to `false`:

**Option 1: In production.yaml**
```yaml
sessionLogs:
  persistentEnabled: false
  consoleEnabled: false
```

**Option 2: Using Environment Variable**
```bash
export SERVERPOD_SESSION_PERSISTENT_LOG_ENABLED=false
```

The production.yaml template includes this as a commented line with clear documentation:
```yaml
# persistentEnabled: true # Defaults to true (enabled) when database is configured
```

## Related Files

- Environment variable definition: `/packages/serverpod_shared/lib/src/environment_variables.dart`
- Configuration handling: `/packages/serverpod_shared/lib/src/config.dart`
- Mini template: `/templates/serverpod_templates/projectname_server/`
- Standard template configs: `/templates/serverpod_templates/projectname_server_upgrade/config/`
- Tests: `/packages/serverpod_shared/test_integration/load_session_logs_config_test.dart`
