import * as assert from 'assert';
import * as vscode from 'vscode';
import * as sinon from 'sinon';
import { LanguageClient } from 'vscode-languageclient/node';
import { registerModelNavigation, modelClassNameAt } from '../model_navigation';

suite('Model Navigation', () => {
	let registerDefinitionProviderStub: sinon.SinonStub;
	let registerCommandStub: sinon.SinonStub;
	let showTextDocumentStub: sinon.SinonStub;
	let capturedProvider: vscode.DefinitionProvider;
	let commandHandler: () => Promise<void>;

	const modelLocationResult = {
		uri: 'file:///project/my_project_server/lib/src/models/user.spy.yaml',
		range: {
			start: { line: 0, character: 7 },
			end: { line: 0, character: 11 },
		},
	};

	function mockDocument(word: string | undefined): vscode.TextDocument {
		return {
			getWordRangeAtPosition: sinon.stub().returns(
				word === undefined ? undefined : new vscode.Range(0, 0, 0, word.length)
			),
			getText: sinon.stub().returns(word),
		} as unknown as vscode.TextDocument;
	}

	function mockClient(sendRequest: sinon.SinonStub): LanguageClient {
		return { sendRequest } as unknown as LanguageClient;
	}

	setup(() => {
		registerDefinitionProviderStub = sinon
			.stub(vscode.languages, 'registerDefinitionProvider')
			.callsFake(((_selector: vscode.DocumentSelector, provider: vscode.DefinitionProvider) => {
				capturedProvider = provider;
				return { dispose: () => { } };
			}) as never);
		registerCommandStub = sinon
			.stub(vscode.commands, 'registerCommand')
			.callsFake(((_command: string, handler: () => Promise<void>) => {
				commandHandler = handler;
				return { dispose: () => { } };
			}) as never);
		showTextDocumentStub = sinon.stub(vscode.window, 'showTextDocument');
	});

	teardown(() => {
		sinon.restore();
	});

	suite('registerModelNavigation', () => {
		test('Given a running language client when navigation is registered then a definition provider for dart files and the go to command are registered.', () => {
			const context = { subscriptions: [] } as unknown as vscode.ExtensionContext;

			registerModelNavigation(context, mockClient(sinon.stub()));

			assert.strictEqual(registerDefinitionProviderStub.calledOnce, true);
			assert.deepStrictEqual(registerDefinitionProviderStub.firstCall.args[0], { language: 'dart', scheme: 'file' });
			assert.strictEqual(registerCommandStub.calledOnce, true);
			assert.strictEqual(registerCommandStub.firstCall.args[0], 'serverpod.goToModelDefinition');
		});

		test('Given a dart document with a model class name when definition is requested then the provider returns the yaml model location.', async () => {
			const context = { subscriptions: [] } as unknown as vscode.ExtensionContext;
			const sendRequest = sinon.stub().resolves(modelLocationResult);
			registerModelNavigation(context, mockClient(sendRequest));

			const result = await capturedProvider.provideDefinition(
				mockDocument('User'),
				new vscode.Position(0, 2),
				{} as vscode.CancellationToken
			);

			assert.deepStrictEqual(sendRequest.firstCall.args, ['serverpod/modelDefinition', { className: 'User' }]);
			const location = result as vscode.Location;
			assert.strictEqual(location.uri.toString(), modelLocationResult.uri);
			assert.strictEqual(location.range.start.line, 0);
			assert.strictEqual(location.range.start.character, 7);
		});

		test('Given a dart document with a lowercase identifier when definition is requested then the provider returns undefined without querying the server.', async () => {
			const context = { subscriptions: [] } as unknown as vscode.ExtensionContext;
			const sendRequest = sinon.stub().resolves(modelLocationResult);
			registerModelNavigation(context, mockClient(sendRequest));

			const result = await capturedProvider.provideDefinition(
				mockDocument('userId'),
				new vscode.Position(0, 2),
				{} as vscode.CancellationToken
			);

			assert.strictEqual(result, undefined);
			assert.strictEqual(sendRequest.called, false);
		});

		test('Given a dart document with no identifier at the position when definition is requested then the provider returns undefined.', async () => {
			const context = { subscriptions: [] } as unknown as vscode.ExtensionContext;
			const sendRequest = sinon.stub().resolves(modelLocationResult);
			registerModelNavigation(context, mockClient(sendRequest));

			const result = await capturedProvider.provideDefinition(
				mockDocument(undefined),
				new vscode.Position(0, 2),
				{} as vscode.CancellationToken
			);

			assert.strictEqual(result, undefined);
			assert.strictEqual(sendRequest.called, false);
		});

		test('Given a class name that is not a model when definition is requested then the provider returns undefined.', async () => {
			const context = { subscriptions: [] } as unknown as vscode.ExtensionContext;
			const sendRequest = sinon.stub().resolves(null);
			registerModelNavigation(context, mockClient(sendRequest));

			const result = await capturedProvider.provideDefinition(
				mockDocument('String'),
				new vscode.Position(0, 2),
				{} as vscode.CancellationToken
			);

			assert.strictEqual(result, undefined);
		});

		test('Given a CLI that does not implement the model definition request when definition is requested then the provider returns undefined.', async () => {
			const context = { subscriptions: [] } as unknown as vscode.ExtensionContext;
			const sendRequest = sinon.stub().rejects(new Error('Method not found: serverpod/modelDefinition'));
			registerModelNavigation(context, mockClient(sendRequest));

			const result = await capturedProvider.provideDefinition(
				mockDocument('User'),
				new vscode.Position(0, 2),
				{} as vscode.CancellationToken
			);

			assert.strictEqual(result, undefined);
		});

		test('Given a dart document with a model class name when the go to model definition command runs then the yaml model is opened at the declaration range.', async () => {
			const context = { subscriptions: [] } as unknown as vscode.ExtensionContext;
			const sendRequest = sinon.stub().resolves(modelLocationResult);
			registerModelNavigation(context, mockClient(sendRequest));

			sinon.stub(vscode.window, 'activeTextEditor').value({
				document: mockDocument('User'),
				selection: { active: new vscode.Position(0, 2) },
			});

			await commandHandler();

			assert.strictEqual(showTextDocumentStub.calledOnce, true);
			const [uri, options] = showTextDocumentStub.firstCall.args;
			assert.strictEqual(uri.toString(), modelLocationResult.uri);
			assert.strictEqual((options.selection as vscode.Range).start.line, 0);
		});

		test('Given a class name that is not a model when the go to model definition command runs then no document is opened.', async () => {
			const context = { subscriptions: [] } as unknown as vscode.ExtensionContext;
			const sendRequest = sinon.stub().resolves(null);
			registerModelNavigation(context, mockClient(sendRequest));

			sinon.stub(vscode.window, 'activeTextEditor').value({
				document: mockDocument('String'),
				selection: { active: new vscode.Position(0, 2) },
			});

			await commandHandler();

			assert.strictEqual(showTextDocumentStub.called, false);
		});
	});

	suite('modelClassNameAt', () => {
		test('Given a PascalCase identifier at the position when the class name is extracted then the identifier is returned.', () => {
			const result = modelClassNameAt(mockDocument('UserInfo'), new vscode.Position(0, 2));

			assert.strictEqual(result, 'UserInfo');
		});

		test('Given a camelCase identifier at the position when the class name is extracted then undefined is returned.', () => {
			const result = modelClassNameAt(mockDocument('userInfo'), new vscode.Position(0, 2));

			assert.strictEqual(result, undefined);
		});

		test('Given no identifier at the position when the class name is extracted then undefined is returned.', () => {
			const result = modelClassNameAt(mockDocument(undefined), new vscode.Position(0, 0));

			assert.strictEqual(result, undefined);
		});
	});
});
