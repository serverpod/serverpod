# Serverpod development environment installer

Provide one command that diagnoses, proposes changes, provisions approved missing
dependencies, and verifies a usable Serverpod/Flutter environment:

```bash
curl -fsSL https://serverpod.dev/install.sh | bash
```

**Use a native Serverpod CLI bundle for initial diagnosis, mise for provisioning,
and vendor tools for platform checks.** Serverpod owns compatibility policy,
profiles, normalized results, and reconciliation; it should not become another
package manager. The decisions below reflect research on 2026-10-06, including
isolated Linux probes of released **mise v2026.10.3**. The doctor API, installer,
native release matrix, and clean-machine qualification remain implementation work.

## Scope and profiles

“Zeroed machine” means no developer tools. The entry command still needs Bash,
curl, working HTTPS trust/network, writable storage, and bootstrap archive/checksum
utilities. Images missing this transport floor need another launch mechanism.
The installer must supply development prerequisites without asking users to
configure mise or install Git manually.

Target macOS arm64/Intel and named glibc Linux x64 distribution recipes, subject to
release qualification. Mise's broader platform support does not imply Flutter,
Android, or Ruby support: its pinned Flutter registry supplies Linux x64 archives;
Intel CocoaPods requires separate qualification. Linux arm64, musl/NixOS, and other
unqualified combinations must be reported explicitly.
([Flutter registry](https://github.com/jdx/mise/blob/v2026.10.3/registry/flutter.toml))

| Profile | Requested capabilities |
| --- | --- |
| `minimal` | Flutter/Dart and Serverpod CLI; SDK-only setup |
| `android` | Minimal plus Android builds; device/emulator setup when requested |
| `ios` | Minimal plus Xcode, CocoaPods, and iOS simulator support on macOS |
| `mobile` | Android and iOS where supported |
| `all` | Mobile plus desktop and web prerequisites |

The interactive default recommends `all`; automation specifies a profile.
An explicitly requested unsupported target fails clearly. Unrequested targets do
not fail readiness. Build readiness and device/simulator readiness are separate.

Proposed automation invocation:

```bash
curl -fsSL https://serverpod.dev/install.sh | bash -s -- --profile mobile --yes
```

## Run doctor before provisioning

The small shell bootstrap detects OS/architecture, verifies and extracts a pinned
native CLI bundle, then runs `serverpod doctor`. It can also download pinned mise
as a private diagnostic helper for package planning, without activation or global
configuration changes. Basic doctor detection must work when mise is absent.

Use **`dart build cli`**, preserving its executable and native-library layout;
the receiving host needs no Dart SDK.
This repository already bundles the CLI in CI; sqlite3 build hooks make plain
`dart compile exe` insufficient. Extend that mechanism to qualified release hosts,
with macOS signing/notarization and explicit minimum OS/libc requirements.
([Dart bundles](https://dart.dev/tools/dart-build),
[existing build helper](../../packages/serverpod_shared/lib/src/utils/serverpod_cli_build.dart))

Doctor needs a bootstrap-safe entry path: bypass existing Dart/Flutter prechecks,
welcome browser, counters, update checks, and SDK-dependent initialization.
Downloading the executable is bootstrap; diagnosis must not install missing
development tools. Reuse existing SDK resolution where possible, converting its
missing-SDK exceptions into diagnostic results.
([CLI startup](../../tools/serverpod_cli/bin/serverpod_cli.dart),
[SDK resolution](../../packages/serverpod_shared/lib/src/utils/sdk_path.dart))

Do not bootstrap through Puro: its commands select Flutter environments and its
configuration requires Git, adding dependencies before diagnosis. An official
pinned Dart SDK archive is a fallback if native distribution is unavailable,
with additional download and package-resolution costs.
([Puro forwarding](https://github.com/pingbird/puro/blob/ce706523fd06fab6995b7cfc10fdc577ffbe7e0e/puro/lib/src/env/command.dart),
[Git prerequisite](https://github.com/pingbird/puro/blob/ce706523fd06fab6995b7cfc10fdc577ffbe7e0e/puro/lib/src/config.dart))

## Compose diagnostics around selected tools

Propose `serverpod doctor [--profile <profile>] [--json]` with a versioned result
schema: selected executable/SDK root, provider, version, evidence, remedy, and
status (`ready`, `missing`, `incompatible`, `misconfigured`, `unknown/error`,
`not-requested`, or `unsupported`). Failed or timed-out probes mean uncertainty,
not absence. Exit success requires every requested supported capability to pass.

Discover candidates from inherited PATH, explicit configuration/environment, known
SDK locations, and provider inventories. Retain shim and resolved SDK paths;
executable presence alone proves little. Preserve compatible user-managed tools
and flag conflicting selections. Do not source arbitrary shell startup files or
treat aliases as portable executables. Run bounded probes using selected absolute
paths and a consistent child environment; disable verified manager auto-install
behavior or defer unsafe shim execution until approval.

Reuse these existing interfaces:

| Tool | Useful evidence and limits |
| --- | --- |
| `mise doctor --json`, `mise ls --json` | Mise configuration and known versions; neither inventories every PATH tool. `mise which` only resolves mise tools. |
| `mise doctor project --json` | Declared exit-based checks with timeouts/platform filters; an empty or skipped set is not readiness. |
| `mise bootstrap packages status --json`, `mise bootstrap plan --json` | Host package state and plan; inspect manager availability and retain separate SDK/tool actions. |
| `flutter --version --machine`, `flutter devices --machine` | Structured Flutter and connected-device evidence. |
| Vendor probes | SDK package inventory, `adb devices -l`, emulator list/acceleration checks, Xcode selection/version, and `xcrun simctl list --json`. |

These mise commands exist in v2026.10.3. Use installer-owned configuration with
inherited configurations/hooks disabled; never auto-trust a project. Avoid
`mise env` during inspection because it can install missing versions.
([Released doctor](https://github.com/jdx/mise/blob/v2026.10.3/src/cli/doctor/mod.rs),
[project checks](https://github.com/jdx/mise/blob/v2026.10.3/src/cli/doctor/project.rs),
[environment behavior](https://github.com/jdx/mise/blob/v2026.10.3/src/cli/env.rs))

Keep `flutter doctor -v` as a human-readable supplement. Flutter 3.44.4 has no
doctor JSON option; its normal exit code does not encode readiness. Do not parse
its prose or import private Flutter validators. Flutter commands can initialize
their cache; disclose that before running them. Probe the JDK and Android SDK
Flutter actually selects, including configured overrides and Android Studio's
bundled JDK, rather than assuming PATH Java is authoritative.
([Doctor](https://github.com/flutter/flutter/blob/3.44.4/packages/flutter_tools/lib/src/commands/doctor.dart),
[Java resolution](https://github.com/flutter/flutter/blob/3.44.4/packages/flutter_tools/lib/src/android/java.dart))

## Provision approved changes through mise

Mise's standalone executable requires neither Git nor shell activation; Flutter
still requires working Git. Use absolute-path mise operations and controlled
configuration instead of `mise use -g`. Preserve the pinned registry's Flutter
HTTP/checksum metadata: bare `http:flutter` omits required options.
([Mise installation](https://github.com/jdx/mise/blob/v2026.10.3/docs/installing-mise.md),
[Flutter Git requirement](https://github.com/flutter/flutter/blob/3.44.4/bin/internal/shared.sh))

Declare host prerequisites through mise's released package bootstrap support,
preview with `mise bootstrap packages apply --manager <manager> --dry-run`, and apply after
approval. Qualify recipes for each supported distribution. Include Git/archive
utilities, desktop compiler/CMake/Ninja/GTK dependencies, and a supported web
browser according to profile; SDK installation alone does not provide them.
([Package bootstrap](https://github.com/jdx/mise/blob/v2026.10.3/docs/bootstrap/packages/index.md),
[Linux desktop](https://docs.flutter.dev/platform-integration/linux/setup))

A release manifest pins compatible Flutter, Java (`core:java`), Ruby (`core:ruby`),
CocoaPods (`gem:cocoapods`), and xcodes (`aqua:XcodesOrg/xcodes`) versions and backend
metadata. Keep Ruby and gems together. Prebuilt Ruby does not cover macOS Intel:
qualify its compiler/native-library recipe explicitly, rather than silently
falling back to source builds or assuming Homebrew solves it.
([Ruby](https://mise.jdx.dev/lang/ruby.html),
[gem backend](https://mise.jdx.dev/dev-tools/backends/gem.html))

## Apple tooling remains Apple's distribution

Mise installs the third-party **xcodes manager**; xcodes downloads Apple-signed
Xcode and verifies its signing identity. The same selected Xcode build provides
Apple's tools. Installation path, App Store receipts/update ownership, active
selection, and installed runtimes can differ. Reuse compatible existing Xcode.
([xcodes](https://github.com/XcodesOrg/xcodes),
[signature verification](https://github.com/XcodesOrg/XcodesKit/blob/main/Sources/XcodesKit/Services/XcodeSignatureVerifier.swift))

Full Xcode includes command-line tools; otherwise use Apple's CLT installation
flow. Check developer selection before invoking macOS Git stubs, which can open
an installation dialog. Select Xcode explicitly and provision a compatible iOS
runtime with `xcodebuild -downloadPlatform iOS` or pinned xcodes runtime selection.
Expose Apple authentication/2FA, administrator authorization, first launch, and
license acceptance: xcodes performs privileged preparation and accepts the Xcode
license during installation, so specific consent must precede that operation.
After that approval, run `xcodes install <version> --select`.
([Apple CLT](https://developer.apple.com/documentation/xcode/installing-the-command-line-tools/),
[xcodes preparation](https://github.com/XcodesOrg/XcodesKit/blob/main/Sources/XcodesKit/Services/XcodePostInstallPreparationService.swift))

## Android needs a small persistent-SDK adapter

Reuse the selected SDK root; otherwise create a persistent user-owned root. Mise
already ships `android-sdk`, but v2026.10.3 skips archive checksums and ties the SDK
root to its tool-version directory. Initially use a verified official archive
download/unpack/layout adapter; Google tools own packages and AVDs. Android Studio
is optional. Keep `ANDROID_HOME` and Flutter configuration consistent; resolve
conflicting deprecated `ANDROID_SDK_ROOT` values before changes.
([Mise backend](https://github.com/jdx/mise/tree/v2026.10.3/crates/vfox/embedded-plugins/vfox-android-sdk/hooks),
[Google layout](https://developer.android.com/tools/sdkmanager))

Pin and qualify cmdline-tools with Flutter/JDK and template-required packages,
including NDK/CMake where needed. Google's new Android CLI replaces deprecated
sdkmanager/avdmanager; cmdline-tools 23.0's `sdkmanager --licenses` wrapper returns
success without checking acceptance. Initially qualify a legacy version (19.0 is
a candidate, **not a validated pairing**). Migrate after license, Flutter, and
explicit AVD-selection compatibility tests; never infer license readiness from
exit zero or manufacture license files.
([Android CLI changes](https://developer.android.com/tools/agents/android-cli/release-notes),
[23.0 distribution](https://dl.google.com/android/repository/commandlinetools-linux-16111833_latest.zip))

For that legacy route, bind these variables from the tested release manifest and
selected SDK, with `SYSTEM_IMAGE="system-images;android-<api>;google_apis;<host-abi>"`.
Obtain license consent through Google's interactive flow:

```bash
sdkmanager="$ANDROID_HOME/cmdline-tools/$CMDLINE_TOOLS_VERSION/bin/sdkmanager"
avdmanager="$ANDROID_HOME/cmdline-tools/$CMDLINE_TOOLS_VERSION/bin/avdmanager"

"$sdkmanager" --sdk_root="$ANDROID_HOME" --licenses
"$sdkmanager" --sdk_root="$ANDROID_HOME" --install \
  "platform-tools" "platforms;android-$ANDROID_API" \
  "build-tools;$ANDROID_BUILD_TOOLS"

# Optional emulator target; preserve any existing named AVD.
"$sdkmanager" --sdk_root="$ANDROID_HOME" --install "emulator" "$SYSTEM_IMAGE"
"$avdmanager" create avd -n "$AVD_NAME" -k "$SYSTEM_IMAGE"
```

Choose a host-compatible image. Check `emulator -accel-check`: Linux needs usable
KVM/permissions, macOS uses Hypervisor.Framework. A physical device can replace
an emulator on supported build hosts, with USB trust/developer setup; it does not
solve missing Linux ARM host binaries.
([Acceleration](https://developer.android.com/studio/run/emulator-acceleration),
[AVD creation](https://developer.android.com/tools/avdmanager))

## Approval, persistence, and completion

Read approvals and interactive child input through `/dev/tty` under `curl | bash`.
`--yes` approves the Serverpod plan, not third-party licenses or credentials.
Headless runs must exit promptly with actionable, resumable blocked status when
required UI, consent, or privileges are unavailable.

Pin and verify HTTPS downloads against reviewed release metadata; show privileged
actions and approved shell integration before execution. Install launchers using
the selected environment without requiring manual mise setup. A child cannot
change its parent's PATH: clearly report any new-shell/relogin boundary.

Reruns reuse compatible tools, preserve unrelated configuration and AVDs, and
resume partial work. Doctor remains independently useful; future project pins
and an explicitly approved `doctor --fix` can share the same component policy.

Completion requires doctor plus an actual selected Serverpod starter launch and
requested Flutter target build/run, with device boot/connectivity checked
separately. This checkout's starter uses embedded PostgreSQL and disables Redis;
do not add mandatory Docker. Follow the selected release's template dependencies.
([Starter configuration](../../templates/serverpod_templates/projectname_server_upgrade/config/development.yaml))

Before publishing, qualify each OS/architecture/profile on clean machines and
existing installations, including missing Dart, conflicting shims, interrupted
setup, consent/headless paths, and reruns. Research and isolated mise probes
validate the strategy; they do not establish complete workstation readiness.
