import {
	commands,
	Definition,
	DefinitionProvider,
	ExtensionContext,
	languages,
	Location,
	Position,
	Range,
	TextDocument,
	Uri,
	window,
} from 'vscode';
import { LanguageClient } from 'vscode-languageclient/node';

const modelDefinitionRequest = 'serverpod/modelDefinition';

var navigationDisposables: { dispose(): void }[] = [];

interface ModelDefinitionResult {
	uri: string;
	range: {
		start: { line: number; character: number };
		end: { line: number; character: number };
	};
}

/// Wires Dart-to-model navigation: CTRL+Click on a model class name in Dart
/// code surfaces the yaml model definition alongside the generated Dart
/// class, and the `serverpod.goToModelDefinition` command jumps straight to
/// the yaml model.
export function registerModelNavigation(context: ExtensionContext, client: LanguageClient): void {
	// Re-activation replaces previous registrations instead of conflicting
	// with them.
	for (const disposable of navigationDisposables) {
		disposable.dispose();
	}
	navigationDisposables = [
		languages.registerDefinitionProvider(
			{ language: 'dart', scheme: 'file' },
			new ServerpodModelDefinitionProvider(client)
		),
		commands.registerCommand('serverpod.goToModelDefinition', () => goToModelDefinition(client)),
	];
	context.subscriptions.push(...navigationDisposables);
}

class ServerpodModelDefinitionProvider implements DefinitionProvider {
	constructor(private client: LanguageClient) { }

	async provideDefinition(document: TextDocument, position: Position): Promise<Definition | undefined> {
		const className = modelClassNameAt(document, position);
		if (!className) {
			return undefined;
		}
		return resolveModelLocation(this.client, className);
	}
}

/// Returns the identifier at [position] when it looks like a model class
/// name (PascalCase), otherwise undefined.
export function modelClassNameAt(document: TextDocument, position: Position): string | undefined {
	const range = document.getWordRangeAtPosition(position);
	if (!range) {
		return undefined;
	}
	const word = document.getText(range);
	if (!/^[A-Z][A-Za-z0-9_]*$/.test(word)) {
		return undefined;
	}
	return word;
}

async function resolveModelLocation(client: LanguageClient, className: string): Promise<Location | undefined> {
	let result: ModelDefinitionResult | null;
	try {
		// Older CLI versions do not implement the request; treat failures as
		// "no model" so navigation falls back to the Dart analyzer results.
		result = await client.sendRequest(modelDefinitionRequest, { className });
	} catch (_) {
		return undefined;
	}
	if (!result) {
		return undefined;
	}
	return new Location(
		Uri.parse(result.uri),
		new Range(
			result.range.start.line,
			result.range.start.character,
			result.range.end.line,
			result.range.end.character
		)
	);
}

async function goToModelDefinition(client: LanguageClient): Promise<void> {
	const editor = window.activeTextEditor;
	if (!editor) {
		return;
	}
	const className = modelClassNameAt(editor.document, editor.selection.active);
	if (!className) {
		return;
	}
	const location = await resolveModelLocation(client, className);
	if (!location) {
		return;
	}
	await window.showTextDocument(location.uri, { selection: location.range });
}
