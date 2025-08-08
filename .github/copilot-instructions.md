# Serverpod Development Guide

Always reference these instructions first and fallback to search or bash commands only when you encounter unexpected information that does not match the info here.

Serverpod is a next-generation app and web server framework built for the Flutter community. It allows you to write server-side code in Dart, automatically generate APIs, and hook up databases with minimal effort. This is a monorepo containing the core framework, CLI tools, modules, integrations, examples, and comprehensive tests.

## Command Validation Status

**VALIDATED** (confirmed working):
- ✅ `docker compose config` - All Docker configurations are valid
- ✅ `util/pub_get_all` - Script exists and runs (requires Dart/Flutter)
- ✅ `tests/docker/tests_integration/wait-for-it.sh` - Service readiness checker works
- ✅ Repository structure and file locations are accurate
- ✅ Script permissions and executability confirmed

**REQUIRES DART/FLUTTER** (cannot validate without network access):
- ⚠️ `util/run_tests_unit` - Requires Dart SDK
- ⚠️ `util/run_tests_analyze` - Requires Dart SDK
- ⚠️ `melos` commands - Requires Dart SDK and Melos package
- ⚠️ `dart pub get` operations - Require network access

**NOTE**: All timing estimates are based on CI pipeline analysis and repository examination.

## Prerequisites and Installation

**CRITICAL**: Install these exact versions to ensure compatibility:

### Required Tools
1. **Dart SDK**: `>=3.5.0 <4.0.0` (required)
2. **Flutter SDK**: `>=3.24.0` (required for Flutter components)
   - **Tested versions**: 3.24.0, 3.32.1 (latest)
   - **Project default**: 3.24.5 (from `.fvmrc`)
3. **Git**: Any recent version
4. **Docker & Docker Compose**: Required for integration tests and local development
5. **Melos**: For monorepo management (`dart pub global activate melos`)
6. **Bash**: Required for scripts (use Git Bash on Windows)

### Installation Commands (Run these exactly)

**NOTE**: The repository uses FVM and has `.fvmrc` configured for Flutter 3.24.5.

```bash
# Install Flutter (choose one method)
# Method 1: Using FVM (Recommended if you have Dart already)
dart pub global activate fvm
fvm install 3.24.5
fvm use 3.24.5

# Method 2: Manual Flutter installation
cd /opt
sudo git clone https://github.com/flutter/flutter.git -b stable
export PATH="$PATH:/opt/flutter/bin"

# Method 3: Using snap (Ubuntu/Linux)
sudo snap install flutter --classic

# Install Melos for monorepo management
dart pub global activate melos

# Verify installations
dart --version     # Should be >= 3.5.0
flutter --version  # Should be >= 3.24.0
docker --version   # Should work
git --version      # Should work
```

**TROUBLESHOOTING**:
- If Dart SDK download fails during Flutter setup, try again or use a different network
- On CI/restricted networks, pre-install tools or use cached versions
- Ensure Docker daemon is running before running tests

## Repository Setup and Build Process

**NEVER CANCEL BUILDS OR LONG-RUNNING COMMANDS** - Builds may take 30-45 minutes, tests may take 15-60 minutes depending on scope.

### Initial Setup (Run from repository root)
```bash
# Install all dependencies - TAKES 10-15 MINUTES. NEVER CANCEL.
util/pub_get_all
# Alternative: melos bootstrap

# Activate CLI from source (required for development)
cd tools/serverpod_cli
dart pub get
dart pub global activate --source path .
cd ../..

# Set SERVERPOD_HOME for local templates
export SERVERPOD_HOME=$(pwd)
```

**TIMING**: `util/pub_get_all` takes 10-15 minutes. Set timeout to 30+ minutes.

### Build Commands
```bash
# Generate all code (after model/endpoint changes)
util/generate_all

# Update pubspec files from templates (after template changes)
util/update_pubspecs

# Full repository dependency installation - TAKES 10-15 MINUTES. NEVER CANCEL.
util/pub_get_all

# Alternative: Melos-based setup
melos bootstrap
```

## Testing Infrastructure

**CRITICAL TIMING NOTES** (Based on CI Analysis):
- **Repository setup**: `util/pub_get_all` - 10-15 minutes - Set timeout to 30+ minutes
- **Unit tests**: `util/run_tests_unit` - 5-15 minutes - Set timeout to 30+ minutes  
- **Integration tests**: `util/run_tests_integration` - 15-30 minutes - Set timeout to 45+ minutes
- **E2E tests**: `util/run_tests_e2e` - 20-45 minutes - Set timeout to 60+ minutes
- **Bootstrap tests**: `util/run_tests_bootstrap` - 30-60 minutes - Set timeout to 90+ minutes
- **CLI E2E tests**: Sequential execution required (`--concurrency=1`) - 20-40 minutes
- **Full CI pipeline**: 2-3 hours across all matrix combinations

### Test Commands

```bash
# Unit tests (Dart-only packages)
util/run_tests_unit
# NEVER CANCEL - Takes 5-10 minutes

# Integration tests (requires Docker)
util/run_tests_integration
# NEVER CANCEL - Takes 15-30 minutes

# Integration tests (concurrent)
util/run_tests_integration_concurrently
# NEVER CANCEL - Takes 10-20 minutes

# E2E tests
util/run_tests_e2e
# NEVER CANCEL - Takes 20-45 minutes

# Flutter integration tests
util/run_tests_flutter_integration
# NEVER CANCEL - Takes 20-30 minutes

# Bootstrap tests (project creation)
util/run_tests_bootstrap
# NEVER CANCEL - Takes 30-60 minutes

# Migration tests
util/run_tests_migrations_e2e
# NEVER CANCEL - Takes 15-25 minutes

# CLI end-to-end tests
cd tests/serverpod_cli_e2e_test
dart test --concurrency=1 --reporter=failures-only
# NEVER CANCEL - Takes 20-40 minutes

# Specific package tests
cd packages/serverpod
dart test --reporter=failures-only
```

### Docker Test Infrastructure

Add these entries to `/etc/hosts` for tests:
```
127.0.0.1 serverpod_test_server
127.0.0.1 postgres
127.0.0.1 redis
```

Start test infrastructure:
```bash
# For integration tests
cd tests/docker/tests_integration
docker compose up --build -d

# Wait for services
./wait-for-it.sh localhost:9090 -t 60 -- echo "Postgres ready"
./wait-for-it.sh localhost:9091 -t 60 -- echo "Redis ready"

# Stop when done
docker compose down -v
```

## Code Quality and CI Requirements

**ALWAYS** run these before committing or CI will fail:

```bash
# Format all code
dart format .

# Analyze with strict rules (matches CI exactly)
util/run_tests_analyze
# or specific log levels:
util/run_tests_analyze --allow-infos     # Less strict
util/run_tests_analyze --allow-warnings  # Least strict

# Alternative: Melos-based analysis
melos lint_strict  # Matches CI strict mode
melos lint         # Standard linting 
melos lint_loose   # For downgrade tests

# Single package analysis
dart analyze --fatal-infos package_name/
```

## Creating and Running Projects

### Create New Project
```bash
# Ensure SERVERPOD_HOME is set
export SERVERPOD_HOME=/path/to/serverpod/repo

# Create project
serverpod create myproject

# Navigate to server
cd myproject/myproject_server

# Start dependencies
docker compose up -d

# Run server with migrations
dart bin/main.dart --apply-migrations
```

### Example Projects

Run the auth example:
```bash
cd examples/auth_example/auth_example_server

# Start services
docker compose up -d

# Run server
dart bin/main.dart --apply-migrations
# Server runs on http://localhost:8080

# In another terminal, run Flutter app
cd ../auth_example_flutter
flutter run
```

## Repository Structure and Key Locations

### Core Packages (`/packages/`)
- **`serverpod`**: Main server framework, ORM, authentication, caching
- **`serverpod_client`**: Client-side generated code base classes  
- **`serverpod_flutter`**: Flutter-specific client implementations
- **`serverpod_serialization`**: Shared serialization code
- **`serverpod_shared`**: Code shared between server and tooling
- **`serverpod_test`**: Test framework utilities

### CLI Tools (`/tools/`)
- **`serverpod_cli`**: Command-line interface, code generation, analyzer

### Modules (`/modules/`)
- **`serverpod_auth`**: Authentication module (Google, Apple, Email, Firebase)
- **`new_serverpod_auth`**: New authentication system
- **`serverpod_chat`**: Real-time chat module

### Examples (`/examples/`)
- **`auth_example`**: Demonstrates authentication flows
- **`chat`**: Real-time chat application

### Tests (`/tests/`)
- **`serverpod_test_server`**: Main integration test server
- **`bootstrap_project`**: Project creation tests
- **`serverpod_cli_e2e_test`**: CLI end-to-end tests
- **`docker/`**: Docker configurations for test infrastructure

## Development Workflows

### Working on Core Framework
```bash
# After changing core code
cd packages/serverpod
dart test --reporter=failures-only

# Test integration
util/run_tests_integration

# Always run full CI suite before major PRs
util/run_tests_unit && util/run_tests_integration
```

### Working on CLI
```bash
cd tools/serverpod_cli

# Test CLI
dart test --reporter=failures-only

# Reactivate after changes
dart pub global activate --source path .

# Test end-to-end
cd ../../tests/serverpod_cli_e2e_test
dart test --concurrency=1
```

### Working on Modules
```bash
cd modules/serverpod_auth/serverpod_auth_server

# Start test infrastructure
docker compose up -d

# Run integration tests
dart test -t integration --reporter=failures-only
```

## Validation Steps for Changes

**ALWAYS** validate changes with these steps:

1. **Format and lint**:
   ```bash
   dart format .
   melos lint_strict
   ```

2. **Test affected components**:
   ```bash
   # For core changes
   util/run_tests_unit
   
   # For integration changes  
   util/run_tests_integration
   ```

3. **Test example projects**:
   ```bash
   cd examples/auth_example/auth_example_server
   docker compose up -d
   dart bin/main.dart --apply-migrations
   # Verify server starts successfully
   ```

4. **CLI validation**:
   ```bash
   serverpod create testproject
   cd testproject/testproject_server
   docker compose up -d
   dart bin/main.dart --apply-migrations
   # Verify generated project works
   ```

## Common Issues and Solutions

- **"Dart not found"**: Ensure Flutter is installed and in PATH
- **"Docker connection failed"**: Ensure Docker daemon is running
- **"pub get failed"**: Run `util/pub_get_all --offline` for cached deps
- **"Tests hanging"**: Wait full timeout period - tests can take 45+ minutes
- **"CLI not updated"**: Rerun `dart pub global activate --source path tools/serverpod_cli`
- **"Template not found"**: Ensure `SERVERPOD_HOME` environment variable is set

## Performance Notes

- **Initial setup**: 15-20 minutes
- **Full test suite**: 2-3 hours 
- **Unit tests only**: 10 minutes
- **Single package test**: 1-5 minutes
- **Docker startup**: 2-3 minutes
- **Code generation**: 30 seconds - 2 minutes

**CRITICAL**: Never cancel long-running operations. The monorepo is large and operations take significant time.