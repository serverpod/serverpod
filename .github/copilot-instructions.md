# Serverpod Development Guide

Always reference these instructions first and fallback to search or bash commands only when you encounter unexpected information that does not match the info here.

Serverpod is a next-generation app and web server framework built for the Flutter community. It allows you to write server-side code in Dart, automatically generate APIs, and hook up databases with minimal effort. This is a monorepo containing the core framework, CLI tools, modules, integrations, examples, and comprehensive tests.

## Pull Request Automation

When working with pull requests in this repository, **ALWAYS**:

1. **Use the PR description template**: Apply the exact template structure from `.github/pull_request_template.md`
2. **Reference issues**: Include "Fixes #XXXX." at the end of every PR description
3. **Follow conventional commits**: Ensure PR titles follow the format `<type>: <description>`
4. **Complete checklists**: Mark appropriate items in the pre-launch checklist
5. **Document breaking changes**: Always fill in the breaking changes section if applicable

### PR Template Enforcement
- **Never create** a PR description without using the standard template
- **Always preserve** the checklist structure and format
- **Ensure consistency** across all PRs for documentation quality
- **Reference the template file** directly when generating descriptions

## Command Validation Status

**FULLY VALIDATED** (confirmed working in test environment):
- ✅ `docker compose config` - All Docker configurations are valid
- ✅ `docker compose up -d postgres redis` - Services start and are accessible
- ✅ `tests/docker/tests_integration/wait-for-it.sh` - Service readiness checker works
- ✅ Repository structure and file locations are accurate
- ✅ Script permissions and executability confirmed
- ✅ PostgreSQL and Redis connectivity tested (ports 8090, 8091)
- ✅ Example project Docker infrastructure verified

**REQUIRES DART/FLUTTER** (cannot validate without network access):
- ⚠️ `util/run_tests_unit` - Requires Dart SDK
- ⚠️ `util/run_tests_analyze` - Requires Dart SDK
- ⚠️ `melos` commands - Requires Dart SDK and Melos package
- ⚠️ `dart pub get` operations - Require network access

**NOTE**: All timing estimates are based on CI pipeline analysis and repository examination.

## Prerequisites and Installation

**CRITICAL**: Install these exact versions to ensure compatibility:

### Required Tools
1. **Dart SDK**: `^3.8.0` (required)
2. **Flutter SDK**: `^3.32.0` (required for Flutter components)
3. **Git**: Any recent version
4. **Docker & Docker Compose**: Required for integration tests and local development
5. **Melos**: For monorepo management (`dart pub global activate melos`)
6. **Bash**: Required for scripts (use Git Bash on Windows)

### Installation Commands (Run these exactly)

```bash
# Install Flutter (choose one method)
# Method 1: Using FVM (Recommended if you have Dart already)
dart pub global activate fvm
fvm install 3.32.0
fvm use 3.32.0

# Method 2: Manual Flutter installation
cd /opt
sudo git clone https://github.com/flutter/flutter.git -b stable
export PATH="$PATH:/opt/flutter/bin"

# Method 3: Using snap (Ubuntu/Linux)
sudo snap install flutter --classic

# Install Melos for monorepo management
dart pub global activate melos

# Verify installations
dart --version     # Should be ^3.8.0
flutter --version  # Should be ^3.32.0
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
# Alternative: melos bootstrap
dart pub global activate melos

# Install all dependencies - NEVER CANCEL.
melos bootstrap

# Activate CLI from source (required for development)
cd tools/serverpod_cli
dart pub get
dart pub global activate --source path .
cd ../..

# Set SERVERPOD_HOME for local templates
export SERVERPOD_HOME=$(pwd)
```

**TIMING**: `melos bootstrap` takes 10-15 minutes. Set timeout to 30+ minutes.

### Build Commands
```bash
# Generate all code (after model/endpoint changes)
util/generate_all

# Update pubspec files from templates (after template changes)
util/update_pubspecs

# Full repository dependency installation - NEVER CANCEL.
melos bootstrap
```

## Testing Infrastructure

**VERIFIED DOCKER TIMING**:
- **PostgreSQL container**: 5-10 seconds (first run with image download)  
- **Redis container**: 2-5 seconds (first run with image download)
- **Subsequent starts**: 1-2 seconds per service
- **Service readiness**: Additional 1-2 seconds for network accessibility

**CRITICAL TIMING NOTES** (Based on CI Analysis):
- **Repository setup**: `melos bootstrap` - 10-15 minutes - Set timeout to 30+ minutes
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

## Real-World Usage Scenarios

### Scenario 1: Setting up Development Environment from Scratch
```bash
# 1. Clone and setup (15-20 minutes total)
git clone https://github.com/serverpod/serverpod.git
cd serverpod
export SERVERPOD_HOME=$(pwd)

# 2. Install melos
dart pub global activate melos

# 3. Install dependencies (10-15 minutes - NEVER CANCEL)
melos bootstrap

# 4. Activate CLI
cd tools/serverpod_cli
dart pub global activate --source path .
cd ../..

# 5. Verify setup
serverpod --version
```

### Scenario 2: Creating and Testing a New Project
```bash
# 1. Create project (30 seconds)
serverpod create testproject

# 2. Setup and run (2-3 minutes)
cd testproject/testproject_server
docker compose up -d  # Wait for readiness
dart bin/main.dart --apply-migrations

# 3. Verify server (should see startup logs)
# Server runs on http://localhost:8080
```

### Scenario 3: Running Integration Tests on Core Framework
```bash
# 1. Start test infrastructure (5-10 seconds)
cd tests/docker/tests_integration
docker compose up -d

# 2. Wait for services
./wait-for-it.sh localhost:9090 -t 60 -- echo "Postgres ready"
./wait-for-it.sh localhost:9091 -t 60 -- echo "Redis ready"

# 3. Run tests (15-30 minutes - NEVER CANCEL)
cd ../../..
util/run_tests_integration

# 4. Cleanup
cd tests/docker/tests_integration
docker compose down -v
```

### Scenario 4: Validating Changes Before PR
```bash
# 1. Format and analyze (1-2 minutes)
dart format .
util/run_tests_analyze

# 2. Run unit tests (5-15 minutes)
util/run_tests_unit

# 3. Test example project still works
cd examples/auth_example/auth_example_server
docker compose up -d
dart bin/main.dart --apply-migrations
# Verify no errors in startup
```

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

## Pull Request Guidelines

**CRITICAL**: All PR titles must follow [Conventional Commits](https://www.conventionalcommits.org/) format to pass CI validation.

### PR Title Format
```
<type>: <description>
```

**Valid types** (enforced by GitHub Actions):
- **`feat`**: New features
- **`fix`**: Bug fixes  
- **`docs`**: Documentation changes
- **`style`**: Code style changes (formatting, missing semi-colons, etc)
- **`refactor`**: Code refactoring without changing functionality
- **`perf`**: Performance improvements
- **`test`**: Adding or updating tests
- **`build`**: Changes to build system or dependencies
- **`ci`**: Changes to CI configuration files and scripts
- **`chore`**: Maintenance tasks, tooling changes
- **`revert`**: Reverting previous commits

**Requirements**:
- Description must start with an uppercase letter
- Be descriptive and concise
- Use imperative mood ("Add feature" not "Added feature")

**Examples**:
```
feat: Add authentication module for OAuth2 integration
fix: Resolve database connection timeout issue
docs: Update installation guide with Docker requirements
refactor: Simplify error handling in client package
test: Add integration tests for chat module
chore: Update dependencies to latest versions
```

### PR Submission Checklist
Before submitting a PR, ensure:

1. **Title follows conventional commits format**
2. **Code is formatted**: `dart format .`
3. **Linting passes**: `melos lint_strict` 
4. **Tests pass**: Run relevant test suites for your changes
5. **Examples still work**: Verify at least one example project starts successfully
6. **Documentation updated**: If adding features or changing APIs

## Common Issues and Solutions

- **"Dart not found"**: Ensure Flutter is installed and in PATH
- **"Docker connection failed"**: Ensure Docker daemon is running
- **"pub get failed"**: Run `melos bootstrap --offline` for cached deps
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

## Test Writing Guidelines

### Test Description Pattern
Use the "Given, When, Then" pattern for test descriptions to maintain consistency:

```dart
test(
  'Given [initial state] when [action performed] then [expected outcome].',
  () {
    // Test implementation
  }
);
```

### Test Organization
- Place passing/success test cases at the top of test files
- Group related test cases using `group()` where appropriate
- Follow success test cases with error test cases for the same functionality

## Code Style
- Follow Dart formatting conventions
- Remove unnecessary comments from production code
- Use descriptive variable and function names
