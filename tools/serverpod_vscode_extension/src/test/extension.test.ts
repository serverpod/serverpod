import * as assert from 'assert';
import * as vscode from 'vscode';
import * as sinon from 'sinon';
import * as childProcess from 'child_process';
import { validVersion, activate, deactivate } from '../extension';
import { LanguageClient } from 'vscode-languageclient/node';

suite('VS Code Extension', () => {
    let execSyncStub: sinon.SinonStub;
    let showErrorMessageStub: sinon.SinonStub;

    setup(() => {
        execSyncStub = sinon.stub(childProcess, 'execSync');
        showErrorMessageStub = sinon.stub(vscode.window, 'showErrorMessage');
    });

    teardown(() => {
        sinon.restore();
    });

    suite('validVersion', () => {
        test('Given a valid version string "Version: 1.2.0" when validVersion is called then it should return true.', () => {
            const result = validVersion('Version: 1.2.0');
            assert.strictEqual(result, true);
        });

        test('Given an outdated version string "Version: 1.1.9" when validVersion is called then it should return false.', () => {
            const result = validVersion('Version: 1.1.9');
            assert.strictEqual(result, false);
        });

        test('Given a version string with pre-release tag "Version: 1.2.0-alpha.1" when validVersion is called then it should handle it correctly.', () => {
            const result = validVersion('Version: 1.2.0-alpha.1');
            assert.strictEqual(result, true);
        });

        test('Given an unparseable version string when validVersion is called then it should return true (fallback behavior).', () => {
            const result = validVersion('invalid-version-format');
            assert.strictEqual(result, true);
        });

        test('Given an empty string when validVersion is called then it should handle gracefully.', () => {
            const result = validVersion('');
            assert.strictEqual(result, true);
        });
    });

    suite('activate', () => {
        test('Given serverpod CLI is not installed when activate is called then it should show error message and not start language client.', () => {
            execSyncStub.throws(new Error('Command not found'));
            const mockContext = {} as vscode.ExtensionContext;

            activate(mockContext);

            assert.strictEqual(showErrorMessageStub.calledOnce, true);
            assert.strictEqual(
                showErrorMessageStub.firstCall.args[0],
                'Failed to resolve the Serverpod CLI executable. Please ensure the Serverpod CLI is installed and available on the PATH used by VS Code.'
            );
        });

        test('Given serverpod CLI version is outdated when activate is called then it should show error message and not start language client.', () => {
            execSyncStub.returns(Buffer.from('Version: 1.1.0'));
            const mockContext = {} as vscode.ExtensionContext;

            activate(mockContext);

            assert.strictEqual(showErrorMessageStub.calledOnce, true);
            assert.strictEqual(
                showErrorMessageStub.firstCall.args[0],
                'The Serverpod CLI version is outdated. Please upgrade to the latest version (minimum required version is 1.2).'
            );
        });

        test('Given serverpod version output contains extra whitespace when activate is called then it should trim and parse correctly.', () => {
            execSyncStub.returns(Buffer.from('  Version: 1.2.0  \n'));
            const mockContext = {} as vscode.ExtensionContext;
            const languageClientStartStub = sinon.stub(LanguageClient.prototype, 'start');

            activate(mockContext);

            assert.strictEqual(showErrorMessageStub.called, false);
            assert.strictEqual(languageClientStartStub.calledOnce, true);
        });

        test('Given all prerequisites are met when activate is called then it should create and start the LanguageClient with correct configuration.', () => {
            execSyncStub.returns(Buffer.from('Version: 1.2.0'));
            const mockContext = {} as vscode.ExtensionContext;
            const languageClientStartStub = sinon.stub(LanguageClient.prototype, 'start');

            activate(mockContext);

            assert.strictEqual(showErrorMessageStub.called, false);
            assert.strictEqual(languageClientStartStub.calledOnce, true);
        });

        test('Given all prerequisites are met when activate is called then the client should register all expected document selectors.', () => {
            execSyncStub.returns(Buffer.from('Version: 1.2.0'));
            const mockContext = {} as vscode.ExtensionContext;

            let capturedClientOptions: any = null;
            const mockClient = {
                start: sinon.stub()
            };

            const LanguageClientModule = require('vscode-languageclient/node');
            sinon.stub(LanguageClientModule, 'LanguageClient').callsFake((...args: unknown[]) => {
                const [_id, _name, _serverOptions, clientOptions] = args;
                capturedClientOptions = clientOptions;
                return mockClient;
            });

            activate(mockContext);
            
            assert.ok(capturedClientOptions, 'Client options should be captured');
            
            assert.ok(capturedClientOptions.documentSelector, 'Document selector should exist');
            assert.strictEqual(capturedClientOptions.documentSelector.length, 5, 'Should have 5 document selectors');

            const patterns = capturedClientOptions.documentSelector.map((s: any) => s.pattern);
            assert.ok(patterns.includes('**/protocol/**/*.yaml'), 'Should include protocol YAML pattern');
            assert.ok(patterns.includes('**/models/**/*.yaml'), 'Should include models YAML pattern');
            assert.ok(patterns.includes('**/*.spy.yaml'), 'Should include .spy.yaml pattern');
            assert.ok(patterns.includes('**/*.spy.yml'), 'Should include .spy.yml pattern');
            assert.ok(patterns.includes('**/*.spy'), 'Should include .spy pattern');
        });
    });

    suite('deactivate', () => {
        test('Given client is initialized when deactivate is called then it should call client.stop() and return the Thenable.', () => {
            execSyncStub.returns(Buffer.from('Version: 1.2.0'));
            const mockContext = {} as vscode.ExtensionContext;
            
            sinon.stub(LanguageClient.prototype, 'start');
            const stopStub = sinon.stub(LanguageClient.prototype, 'stop').returns(Promise.resolve());

            activate(mockContext);
            const result = deactivate();

            assert.notStrictEqual(result, undefined, 'Result should not be undefined');
            assert.strictEqual(stopStub.calledOnce, true, 'stop() should be called once');
        });

        test('Given client is not initialized when deactivate is called then it should return undefined.', () => {
            const result = deactivate();
            assert.strictEqual(result, undefined);
        });
    });
});
