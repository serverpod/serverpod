
import { debug, ExtensionContext, window } from 'vscode';
import {
	LanguageClient,
	LanguageClientOptions,
	RevealOutputChannelOn,
	ServerOptions,
	TransportKind,
} from 'vscode-languageclient/node';
import { execSync } from 'child_process';
import { satisfies, coerce } from 'semver';
import { resolveServerpodFlutterAttach } from './flutter_device_selection';
import { registerModelNavigation } from './model_navigation';

let client: LanguageClient;

export function activate(context: ExtensionContext) {
	// Device selection for `serverpod start` companion-app attach sessions.
	// Registered before the CLI version gate so debugging still works when
	// the language server cannot start. Uses the pre-substitution hook so the
	// selected device lands on the config before Dart-Code injects its own in
	// resolveDebugConfigurationWithSubstitutedVariables.
	context.subscriptions.push(
		debug.registerDebugConfigurationProvider('dart', {
			resolveDebugConfiguration: (folder, config) =>
				resolveServerpodFlutterAttach(config, folder?.uri.fsPath),
		})
	);

	let output;
	try {
		output = execSync('serverpod version');
	} catch (e) {
		window.showErrorMessage('Failed to resolve the Serverpod CLI executable. Please ensure the Serverpod CLI is installed and available on the PATH used by VS Code.');
		return;
	}

	if (!validVersion(output.toString().trim())) {
		window.showErrorMessage('The Serverpod CLI version is outdated. Please upgrade to the latest version (minimum required version is 1.2).');
		return;
	}

	const serverOptions: ServerOptions = {
		command: 'serverpod',
		args: ['-q', 'language-server'],
		options: {
			env: process.env,
			shell: true,
		},
		transport: TransportKind.stdio
	};

	const clientOptions: LanguageClientOptions = {
		revealOutputChannelOn: RevealOutputChannelOn.Info,
		documentSelector: [
			{ scheme: 'file', pattern: '**/*.spy.yaml' },
			{ scheme: 'file', pattern: '**/*.spy.yml' },
			{ scheme: 'file', pattern: '**/*.spy' },
		],
	};

	client = new LanguageClient(
		'serverpodLanguageServer',
		'Serverpod',
		serverOptions,
		clientOptions
	);

	registerModelNavigation(context, client);

	client.start();
}

export function deactivate(): Thenable<void> | undefined {
	if (!client) {
		return undefined;
	}
	const stopPromise = client.stop();
	client = undefined as any;
	return stopPromise;
}


export function validVersion(versionString: string): boolean {
	console.log(versionString);
	const versionTag = versionString.split(':')[1];
	const versionNumber = coerce(versionTag);
	if (versionNumber === null) {
		// If we can't parse the version number, assume it's valid
		// since the version format is valid for all pre 1.2 versions.
		return true;
	}

	return satisfies(versionNumber, '>=1.2.0');
}