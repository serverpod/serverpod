import {
	commands,
	Definition,
	DefinitionProvider,
	Disposable,
	ExtensionContext,
	languages,
	Location,
	Position,
	Range,
	TextDocument,
	Uri,
	window,
	workspace,
} from 'vscode';
import { ErrorCodes, LanguageClient, ResponseError, State } from 'vscode-languageclient/node';

const modelDefinitionRequest = 'serverpod/modelDefinition';
const modelFilePattern = '**/*.spy.yaml';
const unsupportedByCliMessage =
	'Go to Model Definition requires a newer Serverpod CLI. Please upgrade the Serverpod CLI to navigate from Dart code to model files.';

interface ModelDefinitionResult {
	uri: string;
	range: {
		start: { line: number; character: number };
		end: { line: number; character: number };
	};
}

let currentRegistration: Disposable | undefined;

/// Wires Dart-to-model navigation: CTRL+Click on a model class name in Dart
/// code surfaces the yaml model definition alongside the generated Dart
/// class, and the `serverpod.goToModelDefinition` command jumps straight to
/// the yaml model.
export function registerModelNavigation(context: ExtensionContext, client: LanguageClient): void {
	// Commands are registered with the editor globally, so activating again
	// without a deactivate in between would fail with "command already
	// exists". Replace the previous registration instead.
	currentRegistration?.dispose();

	const resolver = new ModelLocationResolver(client);
	const registration = Disposable.from(
		resolver,
		languages.registerDefinitionProvider(
			{ language: 'dart', scheme: 'file' },
			new ServerpodModelDefinitionProvider(resolver)
		),
		commands.registerCommand('serverpod.goToModelDefinition', () => goToModelDefinition(resolver))
	);

	currentRegistration = registration;
	context.subscriptions.push(registration);
}

/// Resolves model class names to their yaml declaration.
///
/// The editor asks for a definition on every CTRL+hover, so resolutions are
/// cached until a model file changes to keep those hovers off the wire.
class ModelLocationResolver implements Disposable {
	private readonly cache = new Map<string, Location | undefined>();
	private readonly watcher = workspace.createFileSystemWatcher(modelFilePattern);
	private readonly stateListener: Disposable;
	private unsupported = false;

	constructor(private client: LanguageClient) {
		const clearCache = () => this.cache.clear();
		this.watcher.onDidCreate(clearCache);
		this.watcher.onDidChange(clearCache);
		this.watcher.onDidDelete(clearCache);
		this.stateListener = client.onDidChangeState((event) => {
			// A restarted server may be running a different CLI version.
			if (event.newState === State.Running) {
				this.unsupported = false;
				this.cache.clear();
			}
		});
	}

	/// Whether the language server answered that it does not know the model
	/// definition request, which an older Serverpod CLI does.
	get isUnsupported(): boolean {
		return this.unsupported;
	}

	async resolve(className: string): Promise<Location | undefined> {
		if (this.unsupported) {
			return undefined;
		}
		if (this.cache.has(className)) {
			return this.cache.get(className);
		}

		let result: ModelDefinitionResult | null;
		try {
			result = await this.client.sendRequest(modelDefinitionRequest, { className });
		} catch (error) {
			// Older CLI versions do not implement the request. Treat failures as
			// "no model" so navigation falls back to the Dart analyzer results,
			// and stop asking a server that does not know the request at all.
			// Transient failures are retried, and the flag is cleared whenever
			// the server restarts, so upgrading the CLI takes effect.
			if ((error as ResponseError<void>)?.code === ErrorCodes.MethodNotFound) {
				this.unsupported = true;
			}
			return undefined;
		}

		const location = result
			? new Location(
				Uri.parse(result.uri),
				new Range(
					result.range.start.line,
					result.range.start.character,
					result.range.end.line,
					result.range.end.character
				)
			)
			: undefined;
		this.cache.set(className, location);
		return location;
	}

	dispose(): void {
		this.stateListener.dispose();
		this.watcher.dispose();
		this.cache.clear();
	}
}

class ServerpodModelDefinitionProvider implements DefinitionProvider {
	constructor(private resolver: ModelLocationResolver) { }

	async provideDefinition(document: TextDocument, position: Position): Promise<Definition | undefined> {
		const className = modelClassNameAt(document, position);
		if (!className) {
			return undefined;
		}
		return this.resolver.resolve(className);
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

async function goToModelDefinition(resolver: ModelLocationResolver): Promise<void> {
	const editor = window.activeTextEditor;
	if (!editor) {
		return;
	}
	const className = modelClassNameAt(editor.document, editor.selection.active);
	if (!className) {
		return;
	}
	const location = await resolver.resolve(className);
	if (!location) {
		// Only an outdated CLI is worth reporting. Invoking the command on a
		// class that is not a model stays silent, since it is also bound to a
		// keybinding.
		if (resolver.isUnsupported) {
			window.showWarningMessage(unsupportedByCliMessage);
		}
		return;
	}
	await window.showTextDocument(location.uri, { selection: location.range });
}
