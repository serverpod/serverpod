
import { ExtensionContext } from 'vscode';
import {
	LanguageClient,
	LanguageClientOptions,
	RevealOutputChannelOn,
	ServerOptions,
	TransportKind,
} from 'vscode-languageclient/node';

let client: LanguageClient;

export function activate(context: ExtensionContext) {
	const serverOptions: ServerOptions = {
		command: 'serverpod',
		args: ['language-server', '--no-development-print'],
		options: {},
		transport: TransportKind.stdio
	};

	const clientOptions: LanguageClientOptions = {
		revealOutputChannelOn: RevealOutputChannelOn.Info,
		documentSelector: [
			{ scheme: 'file', language: 'yaml', pattern: '**/protocol/**/*.yaml' },
			{ scheme: 'file', pattern: '**/*.sp.yaml' },
		],
	};

	client = new LanguageClient(
		'serverpodLanguageServer',
		'Serverpod',
		serverOptions,
		clientOptions
	);

	client.start();
}

export function deactivate(): Thenable<void> | undefined {
	if (!client) {
		return undefined;
	}
	return client.stop();
}
