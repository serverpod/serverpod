# Serverpod Development Environment Installer

## Goal

Provide a single command that can take a macOS or Linux development machine from an unknown state to a working Serverpod + Flutter development environment:

```bash
curl -fsSL https://serverpod.dev/install.sh | bash
```

The installer should behave primarily as a **diagnostic and reconciliation tool**, not as a collection of bespoke installers.

It should:

- Detect what is already installed.
- Determine what is missing or incompatible.
- Present the intended changes.
- Install only what is necessary.
- Be safe to run repeatedly.
- Verify the resulting environment.

## Design Principle

Serverpod should own the **desired development environment and user experience**, while delegating generic tool installation and version management to existing tooling.

Use **mise** as the primary provisioning substrate.

Serverpod should not maintain custom installers for Flutter, Java, Ruby, CocoaPods, or similar generic development tools.

Conceptually:

```text
Serverpod Installer
├── Environment diagnosis
├── Desired-state definition
├── Dependency resolution
├── Platform-specific decisions
├── User interaction
├── Android SDK/emulator provisioning
└── Final verification
        │
        ▼
       mise
        │
        ├── Flutter
        │   └── Dart
        ├── Java
        ├── Ruby
        ├── CocoaPods
        └── xcodes
```

## Supported Platforms

### macOS

Provision a complete Flutter development workstation capable of:

- Serverpod development
- Flutter desktop/web development
- Android development
- iOS development

### Linux

Provision:

- Serverpod development
- Flutter desktop/web development
- Android development

iOS tooling must be reported as unavailable rather than treated as an installation failure.

## Components

### Common

The installer should diagnose and provision:

- mise
- Flutter
- Dart
- Serverpod CLI
- Java/JDK
- Git and other minimal prerequisites where required

### Android

Provision and configure:

- Android command-line tools
- Android SDK
- Platform tools
- Required Android platform
- Build tools
- Emulator
- At least one usable AVD, optionally

The Android tooling is the main area where Serverpod may initially need custom provisioning logic.

Prefer Google's current Android CLI/tooling over implementing SDK and AVD management directly.

A future goal should be to move Android command-line-tool installation into a reusable mise backend or registry entry.

### macOS / iOS

Provision and configure:

- `xcodes`
- Xcode
- Xcode command-line tools
- iOS Simulator runtime
- CocoaPods
- Ruby only where required as a dependency

Where Apple authentication, license acceptance, or other unavoidable interaction is required, the installer should clearly hand control to the user rather than attempting to bypass it.

## Mise Usage

Mise should be treated as an implementation detail rather than part of the Serverpod user-facing mental model.

Example internal operations:

```bash
mise use -g flutter@<version>
mise use -g java@<version>
mise use -g ruby@<version>
mise use -g xcodes@<version>
mise use -g cocoapods@<version>
```

Flutter installed through mise provides Dart, so no independent Dart bootstrap is required.

The Serverpod CLI can then be installed using the Dart provided by Flutter.

## Diagnostic-First UX

Running the installer on an existing workstation should first produce a status report.

Example:

```text
Serverpod Development Environment

System
  ✓ macOS arm64
  ✓ Git

Serverpod
  ✓ Flutter 3.x
  ✓ Dart 3.x
  ✗ Serverpod CLI

Android
  ✓ Java 21
  ✗ Android SDK
  ✗ Platform tools
  ✗ Android emulator
  ✗ Development device

iOS
  ✓ Xcode
  ✗ iOS Simulator runtime
  ✗ CocoaPods

4 components need installation.

Install missing components? [Y/n]
```

The installer must not reinstall valid components unnecessarily.

## Desired-State Model

The implementation should model the environment as dependencies rather than as a linear shell script.

Example:

```text
Flutter
└── Dart
    └── Serverpod CLI

Java
└── Android SDK
    ├── Platform tools
    ├── Build tools
    └── Emulator
        └── AVD

macOS
└── Xcode
    └── iOS Simulator

Ruby
└── CocoaPods
```

Each component should support:

- detection
- version validation
- installation
- verification

This keeps diagnosis and installation driven by the same model.

## Installation Profiles

Support explicit profiles for automation and advanced users.

For example:

```bash
serverpod-install --minimal
serverpod-install --android
serverpod-install --ios
serverpod-install --mobile
serverpod-install --all
```

Suggested semantics:

- `minimal`: Flutter + Dart + Serverpod CLI
- `android`: minimal + Java + Android tooling
- `ios`: minimal + Xcode/iOS tooling
- `mobile`: Android + iOS where supported
- `all`: all supported development tooling

The default interactive invocation should recommend the appropriate complete development setup for the current platform.

## Non-Interactive Usage

Support:

```bash
curl -fsSL https://serverpod.dev/install.sh | bash -s -- --yes --mobile
```

Requirements:

- No prompts except unavoidable third-party authentication/licensing.
- Clear non-zero exit codes.
- Suitable for workstation automation and CI images.
- Deterministic requested versions where Serverpod requires specific compatibility.

## Idempotency

The installer must be safe to rerun.

It should:

- Detect existing compatible installations.
- Preserve user-managed installations whenever possible.
- Avoid overwriting unrelated configuration.
- Resume cleanly after partial installation.
- Never require a clean machine.

Example:

```text
✓ Flutter 3.44.4 already installed
✓ Java 21 already installed
→ Installing Android SDK
→ Installing platform-tools
✓ Xcode already configured
```

## Existing Tool Ownership

If the user already manages a tool independently, Serverpod should prefer compatibility over takeover.

For example:

- Existing compatible Flutter installation → use it.
- Existing compatible Java → use it.
- Existing Xcode → do not replace it.
- Existing Android SDK → configure or extend it rather than creating another copy.

Mise is the default provisioning engine, not a requirement that every existing installation become mise-managed.

## Verification

Installation should conclude with actual functional checks, not merely executable discovery.

Example checks:

```text
✓ flutter doctor
✓ dart --version
✓ serverpod version
✓ Android SDK available
✓ adb available
✓ Android emulator available
✓ Xcode build tools available
✓ iOS Simulator runtime available
✓ CocoaPods available
```

Finish with a concise report:

```text
Serverpod development environment ready.

Flutter      3.x
Dart         3.x
Serverpod    4.x
Android      Ready
iOS          Ready
```

Any remaining issues should be presented as actionable items.

## `serverpod doctor`

The diagnostic system should eventually exist independently of the bootstrap script:

```bash
serverpod doctor
```

This should reuse the same component model as the installer and report:

- Missing tooling
- Unsupported versions
- PATH/configuration problems
- Android SDK problems
- Simulator/emulator availability
- Serverpod/Flutter compatibility

Potential future command:

```bash
serverpod doctor --fix
```

This would reconcile an existing workstation using the same provisioning engine as `install.sh`.

## Project-Level Versions

A later iteration may allow Serverpod projects to declare expected development tool versions.

For example:

```yaml
environment:
  flutter: 3.44.4
  java: 21
```

Serverpod could integrate this with mise project configuration so that:

- New contributors receive the expected toolchain.
- `serverpod doctor` detects version drift.
- CI and local environments can share compatible versions.

This should not be required for the initial installer.

## Security

The top-level bootstrap script should remain small and auditable.

It should:

- Use HTTPS exclusively.
- Pin or verify downloaded artifacts where practical.
- Delegate downloads to mise or official vendor tooling.
- Avoid `sudo` unless required.
- Show operations requiring elevated privileges before executing them.
- Avoid modifying shell startup files unless necessary and clearly communicated.

The installer should not evolve into its own general-purpose package manager.

## Non-Goals

The initial implementation should not:

- Replace Homebrew or system package managers.
- Replace mise's version-management functionality.
- Maintain custom Flutter or Java download logic.
- Support iOS development on Linux.
- Automatically solve Apple account authentication.
- Manage every possible Android emulator configuration.
- Force existing development environments to migrate to mise.

## Initial Implementation Boundary

### Serverpod owns

- `install.sh` bootstrap
- Environment diagnostics
- Component/dependency model
- Interactive UX
- Installation profiles
- Version compatibility policy
- Android SDK configuration
- Emulator/AVD setup
- Final verification
- `serverpod doctor`

### Mise / external tools own

- Flutter SDK installation/versioning
- Java installation/versioning
- Ruby installation/versioning
- CocoaPods installation
- `xcodes` installation
- Generic binary/archive acquisition

### Apple/Google tooling owns

- Xcode installation internals
- Simulator runtimes
- Android SDK packages
- Emulator internals
- Platform licenses

## Recommended First Milestone

Implement:

```text
install.sh
    ↓
detect OS/arch
    ↓
diagnose environment
    ↓
install mise if necessary
    ↓
provision Flutter
    ↓
install Serverpod CLI
    ↓
provision Java
    ↓
provision Android SDK
    ↓
macOS:
    provision/check Xcode + CocoaPods
    ↓
run validation
    ↓
print environment report
```

The initial success criterion is:

> A developer on a mostly clean macOS or Linux machine can run one Serverpod command and reach a usable Flutter + Serverpod development environment, with Android configured automatically and iOS configured as far as Apple's tooling permits.