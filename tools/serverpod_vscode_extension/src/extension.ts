
import { ExtensionContext } from 'vscode';
import {
	LanguageClient,
	LanguageClientOptions,
	RevealOutputChannelOn,
	TransportKind,
} from 'vscode-languageclient/node';


let client: LanguageClient;
export function activate(context: ExtensionContext) {
	console.log("starting serverpod language server client side");
	const serverOptions = {
		command: 'serverpod',
		args: ['language-server', '--stdio'],
		options: {},
		transport: TransportKind.stdio
	};

	
	const clientOptions: LanguageClientOptions = {
		revealOutputChannelOn: RevealOutputChannelOn.Info,
		documentSelector: [
			{ scheme: 'file', language: 'yaml', pattern: '**/protocol/**/*.yaml' },
			{ scheme: 'file', pattern: '**/protocol/**/*.sp.yaml' },
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
