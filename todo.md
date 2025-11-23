# Custom SQL Support Testing Plan

## 🧪 Manual Testing Checklist (Ordered by Priority)

### 1. **Basic Custom SQL Functionality** ⭐ Priority 1

#### 1.1 Fresh Database Setup with Custom SQL ✅ DONE (Mathis)

**Verification Results:**
- ✅ Custom index created successfully in post_database_setup.sql
- ✅ No critical warnings about the custom index (INFO level only)
- ✅ Server started successfully without integrity errors
- ✅ Fresh database setup executes: pre_database_setup.sql → definition.sql → post_database_setup.sql
#### 1.2 Rolling Forward Migration with Custom SQL ✅ DONE (Mathis)

**Verification Results:**
- ✅ `email` column added successfully
- ✅ `item_email_idx` custom index created (from post_migration.sql)
- ✅ `migration_log` table created (from pre_migration.sql)
- ✅ Migration execution order confirmed:
  - MIGRATION_START logged at 2025-11-22 23:20:01.283056
  - MIGRATION_COMPLETE logged at 2025-11-22 23:20:01.283056
- ✅ SQL execution order verified: pre_migration.sql → migration.sql → post_migration.sql

### 2. **SQL Execution Order Verification** ⭐ Priority 2

#### 2.1 Verify Pre-Database Setup Runs Before Definition
```bash
# Edit pre_database_setup.sql
cat > migrations/<VERSION>/pre_database_setup.sql << 'EOF'
-- This should run BEFORE definition.sql
CREATE TABLE setup_tracker (id SERIAL PRIMARY KEY, stage TEXT);
INSERT INTO setup_tracker (stage) VALUES ('pre_database_setup');
EOF

# Edit post_database_setup.sql
cat > migrations/<VERSION>/post_database_setup.sql << 'EOF'
-- This should run AFTER definition.sql
INSERT INTO setup_tracker (stage) VALUES ('post_database_setup');
EOF

# Drop database and recreate
docker compose down -v
docker compose up -d
dart bin/main.dart --apply-migrations

# Verify order in database
# Should see: pre_database_setup, then post_database_setup
```

#### 2.2 Verify Pre-Migration Runs Before Migration SQL
```bash
# Similar test but for migrations instead of fresh setup
```

### 3. **Module Support** ⭐ Priority 3

#### 3.1 Test with serverpod_auth Module
```bash
# Use auth example project
cd examples/auth_example/auth_example_server

# Check if auth module has migrations
ls -la ../../../modules/serverpod_auth/serverpod_auth_server/migrations/

# Manually add custom SQL to auth module migration
cat > ../../../modules/serverpod_auth/serverpod_auth_server/migrations/<LATEST_VERSION>/post_migration.sql << 'EOF'
-- Custom index on auth user table
CREATE INDEX idx_serverpod_user_info_email ON serverpod_user_info(email);
EOF

docker compose down -v
docker compose up -d
dart bin/main.dart --apply-migrations

# Verify: Module custom SQL should be applied
# Verify: No critical warnings about the custom auth index
```

#### 3.2 Test Multiple Modules with Custom SQL
```bash
# Test with both serverpod_auth and serverpod_chat
# Each with their own custom SQL
```

### 4. **Warning Categorization** ⭐ Priority 2

#### 4.1 Critical vs Informational Warnings
```bash
# Add custom index (should be INFO)
# Then manually ALTER a column type (should be CRITICAL)

# Run server without migrations
dart bin/main.dart

# Verify: 
# - Custom index shows as INFO
# - Column mismatch shows as CRITICAL (WARNING)
# - Server should fail to start on CRITICAL
```

#### 4.2 Empty Custom SQL Files
```bash
# Leave all 4 custom SQL files empty
dart bin/main.dart --apply-migrations

# Verify: Should work exactly as before (backward compatible)
# Verify: No INFO messages about custom SQL
```

### 5. **Edge Cases** ⭐ Priority 3

#### 5.1 Comments-Only Custom SQL
```bash
cat > migrations/<VERSION>/post_migration.sql << 'EOF'
-- This is just a comment
-- No actual SQL here
EOF

# Should be treated as empty (no custom SQL detected)
```

#### 5.2 Complex SQL Patterns
```bash
cat > migrations/<VERSION>/post_migration.sql << 'EOF'
-- Test various SQL patterns
CREATE UNIQUE INDEX idx_unique ON test_model(name);
ALTER TABLE test_model ADD CONSTRAINT check_name CHECK (length(name) > 0);
CREATE OR REPLACE FUNCTION notify_changes() RETURNS trigger AS $$
BEGIN
  PERFORM pg_notify('test_changes', NEW.id::text);
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;
EOF
```

#### 5.3 Multiple Tables Affected
```bash
# Add custom SQL that touches multiple tables
# Verify all are tracked in affectedTables
```

---

## ✅ Existing Tests That Should Pass

### 1. **CLI Tests** (Must pass)
```bash
cd tools/serverpod_cli

# Migration generation tests
dart test test/integration/migrations/migration_version_test.dart
dart test test/integration/migrations/migration_registry_test.dart
dart test test/integration/migrations/migration_generator_exceptions_test.dart

# SQL generation tests
dart test test/database/migration/migration_sql_test.dart
```

### 2. **Integration Tests** (Must pass)
```bash
cd tests/serverpod_test_server

# All database operation tests
dart test test/database_operations/

# Migration-related integration tests
dart test test/integration/ -t integration
```

### 3. **Full Test Suites** (Should all pass)
```bash
# From repository root
util/run_tests_unit          # 5-15 min
util/run_tests_integration   # 15-30 min
util/run_tests_e2e          # 20-45 min
```

---

## 📝 New Tests You Should Write

### 1. **Unit Tests for `migration_manager.dart`** ⭐ CRITICAL

**File**: `packages/serverpod/test/database/migrations/migration_manager_test.dart`

```dart
// Test _combineSQL()
test('Given empty SQL strings when combining then returns empty string.');
test('Given multiple SQL strings when combining then joins with double newline.');
test('Given SQL with whitespace when combining then trims properly.');

// Test _analyzeCustomSQL()
test('Given no custom SQL files when analyzing then returns hasCustomSQL false.');
test('Given empty custom SQL files when analyzing then returns hasCustomSQL false.');
test('Given custom SQL with CREATE INDEX when analyzing then extracts table name.');
test('Given custom SQL with ALTER TABLE when analyzing then extracts table name.');
test('Given custom SQL with CREATE TABLE when analyzing then extracts table name.');
test('Given custom SQL with comments only when analyzing then returns hasCustomSQL false.');

// Test _categorizeWarnings()
test('Given no custom SQL when categorizing warnings then all warnings are critical.');
test('Given custom SQL and missing index on affected table when categorizing then warning is informational.');
test('Given custom SQL and missing column when categorizing then warning is critical.');
test('Given custom SQL and foreign key mismatch when categorizing then warning is critical.');
```

### 2. **Integration Tests for Custom SQL Execution** ⭐ CRITICAL

**File**: `tests/serverpod_test_server/test/database_operations/custom_sql_test.dart`

```dart
group('Custom SQL execution', () {
  test('Given pre_database_setup.sql when creating fresh database then SQL executes before definition.sql.');
  test('Given post_database_setup.sql when creating fresh database then SQL executes after definition.sql.');
  test('Given pre_migration.sql when rolling forward then SQL executes before migration.sql.');
  test('Given post_migration.sql when rolling forward then SQL executes after migration.sql.');
  test('Given empty custom SQL files when migrating then migration succeeds without errors.');
});
```

### 3. **Integration Tests for Warning Categorization** ⭐ CRITICAL

**File**: `tests/serverpod_test_server/test/database_operations/integrity_verification_test.dart`

```dart
group('Database integrity verification with custom SQL', () {
  test('Given custom index on table when verifying integrity then shows informational warning.');
  test('Given no custom SQL and schema mismatch when verifying integrity then shows critical warning and fails.');
  test('Given custom SQL and missing expected column when verifying integrity then shows critical warning and fails.');
  test('Given empty custom SQL files when verifying integrity then behaves as before (all warnings critical).');
});
```

### 4. **CLI Tests for File Generation** ⭐ HIGH PRIORITY

**File**: `tools/serverpod_cli/test/integration/migrations/custom_sql_files_test.dart`

```dart
group('Custom SQL file generation', () {
  test('Given create-migration command when executed then creates 4 empty custom SQL files.');
  test('Given migration already exists when creating then does not overwrite existing custom SQL files.');
  test('Given custom SQL files with content when reading then content is preserved.');
});
```

### 5. **Module Integration Tests** ⭐ MEDIUM PRIORITY

**File**: `tests/serverpod_test_module/test/custom_sql_module_test.dart`

```dart
group('Module custom SQL support', () {
  test('Given module with custom SQL when migrating then module custom SQL executes.');
  test('Given main project and module with custom SQL when migrating then both execute in correct order.');
  test('Given module custom SQL affects module tables when verifying then warnings are informational.');
});
```

### 6. **E2E Tests** ⭐ MEDIUM PRIORITY

**File**: `tests/serverpod_cli_e2e_test/test/custom_sql_e2e_test.dart`

```dart
group('Custom SQL end-to-end', () {
  test('Given new project with custom SQL when creating and migrating then project works correctly.');
  test('Given custom SQL with indexes when starting server then no integrity failures.');
  test('Given custom SQL with complex patterns when migrating then all SQL executes successfully.');
});
```

---

## 🎯 Test Priority Summary

### Must Write (Before PR):
1. ✅ Unit tests for `_combineSQL()`, `_analyzeCustomSQL()`, `_categorizeWarnings()`
2. ✅ Integration test for SQL execution order
3. ✅ Integration test for warning categorization
4. ✅ CLI test for file generation

### Should Write (Before PR):
5. ⚠️ Module integration tests
6. ⚠️ E2E tests for complete workflow

### Test Coverage Goals:
- **Core functionality**: 100% (SQL combining, analysis, categorization)
- **Integration**: 80%+ (execution order, modules)
- **E2E**: Basic happy path + one failure scenario

---

## 🚨 Special Considerations for Modules

Based on your plan, modules need special attention:

1. **Module Custom SQL Inlining**: Each module should have its own custom SQL files that get inlined at the correct points
2. **Migration Order**: When modules have custom SQL, migrations must be applied sequentially (not in bulk)
3. **Test with Real Modules**: Use `serverpod_auth` and `serverpod_chat` for testing

**Key Test**:
```bash
# Verify module migration order with custom SQL
# Should apply: serverpod module migration + custom SQL, then project migration + custom SQL
```

This should be your **highest risk area** for bugs, so test thoroughly!

---

## 📋 Implementation Notes

### Files Changed:
1. `packages/serverpod/lib/src/database/migrations/migration_manager.dart` - Core migration logic
2. `packages/serverpod/lib/src/server/serverpod.dart` - Changed to instance method
3. `packages/serverpod_shared/lib/src/constants.dart` - Added 4 new file path constants
4. `tools/serverpod_cli/lib/src/migrations/generator.dart` - Creates empty custom SQL files
5. `tests/serverpod_test_server/migrations/migration_registry.txt` - Test migration entries

### Key Features:
- **4 Custom SQL Files**: pre_database_setup.sql, post_database_setup.sql, pre_migration.sql, post_migration.sql
- **Automatic File Generation**: CLI creates empty files for each migration
- **Smart SQL Combining**: Merges custom + generated SQL into single transaction
- **Intelligent Warning Categorization**: Distinguishes critical errors from expected custom SQL differences
- **Backward Compatible**: Empty files are ignored, works like before

### Execution Order:
- **Fresh DB**: pre_database_setup.sql → definition.sql → post_database_setup.sql
- **Migration**: pre_migration.sql → migration.sql → post_migration.sql
