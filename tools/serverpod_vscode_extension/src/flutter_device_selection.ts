import { commands, DebugConfiguration } from 'vscode';
import * as fs from 'fs';
import * as path from 'path';
import { parse as parseYaml } from 'yaml';

/// File the IDE-selected Flutter device is handed to `serverpod start` in,
/// inside the server's `.dart_tool/serverpod/` directory.
///
/// Scoped to one session: written as VS Code launches, and removed by the CLI
/// when the session ends, so a later `serverpod start` from a plain terminal
/// is never silently retargeted by a device picked in an IDE.
export const ideDeviceInfoFile = 'ide-flutter-device.json';

const flutterAppInfoFilePattern =
	/[\\/]\.dart_tool[\\/]serverpod[\\/]flutter-vm-service-info-.+\.json$/;
const serverInfoFilePattern =
	/[\\/]\.dart_tool[\\/]serverpod[\\/]vm-service-info\.json$/;

/// A launch configuration that causes `serverpod start` to run.
export interface ServerpodAttachTarget {
	/// The server package directory owning `.dart_tool/serverpod/`.
	serverDir: string;
	/// True for the companion Flutter app attach, false for the server attach.
	isFlutterApp: boolean;
}

/// Substitutes `${workspaceFolder}` in [value] with [workspaceFolderPath].
///
/// This runs in `resolveDebugConfiguration` - before VS Code's own variable
/// substitution - so the launch.json template's
/// `${workspaceFolder}/..._server/...` path must be expanded by hand. Returns
/// undefined for non-strings or when other, unsupported variables remain.
export function substituteWorkspaceFolder(
	value: unknown,
	workspaceFolderPath: string | undefined,
): string | undefined {
	if (typeof value !== 'string') { return undefined; }
	let result = value;
	if (result.includes('${workspaceFolder}')) {
		if (workspaceFolderPath === undefined) { return undefined; }
		result = result.split('${workspaceFolder}').join(workspaceFolderPath);
	}
	return result.includes('${') ? undefined : result;
}

/// Classifies [vmServiceInfoFile] as one of the two serverpod attach
/// configurations, or undefined when it is neither.
///
/// Both matter here because both carry the `serverpod_start` preLaunchTask:
/// the generated `<project> (full stack)` compound launches the server config
/// first, so leaving it unhooked would let `serverpod start` spawn the app
/// while the device menu is still open.
export function serverpodAttachTarget(
	vmServiceInfoFile: unknown,
): ServerpodAttachTarget | undefined {
	if (typeof vmServiceInfoFile !== 'string') { return undefined; }
	// <serverDir>/.dart_tool/serverpod/<info file>
	const serverDir = path.dirname(
		path.dirname(path.dirname(vmServiceInfoFile)),
	);
	if (flutterAppInfoFilePattern.test(vmServiceInfoFile)) {
		return { serverDir, isFlutterApp: true };
	}
	if (serverInfoFilePattern.test(vmServiceInfoFile)) {
		return { serverDir, isFlutterApp: false };
	}
	return undefined;
}

/// Whether the server at [serverDir] is eligible for IDE device selection:
/// exactly one companion Flutter app is configured and it has no explicit
/// `device:` line. When the pubspec has no `serverpod: flutter_apps:` section
/// the CLI synthesizes the default sibling `../<project>_flutter` app, which
/// counts as the one (device-less) app when its package exists.
export function isEligibleForDeviceSelection(
	pubspecContent: string,
	serverDir: string,
): boolean {
	let pubspec: unknown;
	try {
		pubspec = parseYaml(pubspecContent);
	} catch {
		return false;
	}
	if (typeof pubspec !== 'object' || pubspec === null) { return false; }

	const serverpodSection = (pubspec as Record<string, unknown>).serverpod;
	const flutterApps =
		typeof serverpodSection === 'object' && serverpodSection !== null
			? (serverpodSection as Record<string, unknown>).flutter_apps
			: undefined;

	if (flutterApps === undefined || flutterApps === null) {
		// Synthesized default app: `../<project>_flutter` next to the server
		// package, where the server package is named `<project>_server`.
		const serverName = (pubspec as Record<string, unknown>).name;
		if (typeof serverName !== 'string' || !serverName.endsWith('_server')) {
			return false;
		}
		const projectName = serverName.slice(0, -'_server'.length);
		const flutterPubspec = path.join(
			serverDir,
			'..',
			`${projectName}_flutter`,
			'pubspec.yaml',
		);
		return fs.existsSync(flutterPubspec);
	}

	if (typeof flutterApps !== 'object') { return false; }
	const entries = Object.values(flutterApps as Record<string, unknown>);
	if (entries.length !== 1) { return false; }

	const app = entries[0];
	if (typeof app !== 'object' || app === null) { return false; }
	return (app as Record<string, unknown>).device === undefined;
}

/// Path of the session device-info file for the server package at [serverDir].
export function deviceInfoFilePath(serverDir: string): string {
	return path.join(serverDir, '.dart_tool', 'serverpod', ideDeviceInfoFile);
}

/// Removes [infoFile] so `serverpod start` uses its own default device.
export function clearDeviceInfo(infoFile: string): void {
	try {
		fs.rmSync(infoFile, { force: true });
	} catch {
		// Best-effort; the CLI also removes the file when the session ends.
	}
}

function writeDeviceInfo(infoFile: string, deviceId: string): void {
	try {
		fs.mkdirSync(path.dirname(infoFile), { recursive: true });
		fs.writeFileSync(infoFile, JSON.stringify({ deviceId }));
	} catch {
		// Best-effort: without the info serverpod falls back to its default
		// device and the user is prompted again next time.
	}
}

/// Outcome of resolving which device the companion app should run on.
type DeviceSelection =
	| { kind: 'selected'; deviceId: string }
	/// The device menu was dismissed; the launch should be aborted.
	| { kind: 'cancelled' }
	/// No device could be determined (Dart-Code absent); launch without info.
	| { kind: 'unavailable' };

/// In-flight selections keyed by server directory, so the two configurations
/// of the `<project> (full stack)` compound share one device menu instead of
/// each opening their own.
const inFlightSelections = new Map<string, Promise<DeviceSelection>>();

async function selectDeviceForServer(
	serverDir: string,
): Promise<DeviceSelection> {
	const infoFile = deviceInfoFilePath(serverDir);

	// Dart-Code's status-bar selection is the source of truth: it always names
	// a device that currently exists (Dart-Code re-picks when one disappears),
	// so there is nothing to validate and no prompt to show.
	let current: unknown;
	try {
		current = await commands.executeCommand('flutter.getSelectedDeviceId');
	} catch {
		// Dart-Code is not installed or not active; don't block the attach, and
		// drop any info a previous session left behind.
		clearDeviceInfo(infoFile);
		return { kind: 'unavailable' };
	}

	if (typeof current === 'string' && current.length > 0) {
		writeDeviceInfo(infoFile, current);
		return { kind: 'selected', deviceId: current };
	}

	// No device is selected (none connected, or none supported yet) - ask.
	let picked: unknown;
	try {
		picked = await commands.executeCommand('flutter.selectDevice');
	} catch {
		clearDeviceInfo(infoFile);
		return { kind: 'unavailable' };
	}
	const deviceId =
		typeof picked === 'object' && picked !== null
			? (picked as Record<string, unknown>).id
			: undefined;
	if (typeof deviceId !== 'string' || deviceId.length === 0) {
		clearDeviceInfo(infoFile);
		return { kind: 'cancelled' };
	}

	writeDeviceInfo(infoFile, deviceId);
	return { kind: 'selected', deviceId };
}

function selectDeviceOnce(serverDir: string): Promise<DeviceSelection> {
	const existing = inFlightSelections.get(serverDir);
	if (existing !== undefined) { return existing; }

	const pending = selectDeviceForServer(serverDir).finally(() => {
		inFlightSelections.delete(serverDir);
	});
	inFlightSelections.set(serverDir, pending);
	return pending;
}

/// Hooks the launch of a serverpod attach configuration: when the project is
/// eligible (one companion app, no pinned device), hands the device currently
/// selected in VS Code to `serverpod start`, prompting with Dart-Code's device
/// menu only when nothing is selected.
///
/// Meant for `resolveDebugConfiguration`, which VS Code awaits before running
/// the `serverpod_start` preLaunchTask - that ordering is what lets the device
/// reach the info file before the app is spawned. It also runs before every
/// provider's substituted-variables hook, where Dart-Code injects its own
/// current device as `deviceId`, so setting ours first keeps VS Code's
/// `flutter attach` on the same device serverpod spawns, and a `deviceId`
/// already present here is genuinely user-authored.
///
/// Returns the configuration, or undefined to abort the session when the
/// device menu is dismissed.
export async function resolveServerpodFlutterAttach(
	config: DebugConfiguration,
	workspaceFolderPath?: string,
): Promise<DebugConfiguration | undefined> {
	if (config.type !== 'dart' || config.request !== 'attach') { return config; }
	const infoFile = substituteWorkspaceFolder(
		config.vmServiceInfoFile,
		workspaceFolderPath,
	);
	const target = serverpodAttachTarget(infoFile);
	if (target === undefined) { return config; }
	// An explicit deviceId in launch.json is a pin, like `device:` in the
	// pubspec - don't second-guess it.
	if (target.isFlutterApp && config.deviceId !== undefined) { return config; }

	let pubspecContent: string;
	try {
		pubspecContent = fs.readFileSync(
			path.join(target.serverDir, 'pubspec.yaml'),
			'utf8',
		);
	} catch {
		return config;
	}
	if (!isEligibleForDeviceSelection(pubspecContent, target.serverDir)) {
		return config;
	}

	const selection = await selectDeviceOnce(target.serverDir);
	switch (selection.kind) {
		case 'cancelled':
			return undefined;
		case 'unavailable':
			return config;
		case 'selected':
			// Only the Flutter attach takes a deviceId; the server session just
			// needed to wait so its preLaunchTask starts after the choice.
			return target.isFlutterApp
				? { ...config, deviceId: selection.deviceId }
				: config;
	}
}
