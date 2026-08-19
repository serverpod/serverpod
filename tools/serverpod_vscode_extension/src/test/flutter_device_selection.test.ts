import * as assert from 'assert';
import * as vscode from 'vscode';
import * as sinon from 'sinon';
import * as fs from 'fs';
import * as os from 'os';
import * as path from 'path';
import {
    clearDeviceInfo,
    deviceInfoFilePath,
    isEligibleForDeviceSelection,
    resolveServerpodFlutterAttach,
    serverpodAttachTarget,
    substituteWorkspaceFolder,
} from '../flutter_device_selection';

/** Creates a temp server package dir with the given pubspec content. */
function createServerDir(pubspec: string): string {
    const root = fs.mkdtempSync(path.join(os.tmpdir(), 'serverpod_ext_test_'));
    const serverDir = path.join(root, 'project_server');
    fs.mkdirSync(serverDir, { recursive: true });
    fs.writeFileSync(path.join(serverDir, 'pubspec.yaml'), pubspec);
    return serverDir;
}

function attachConfig(serverDir: string): vscode.DebugConfiguration {
    return {
        name: 'project_flutter',
        type: 'dart',
        request: 'attach',
        vmServiceInfoFile: path.join(
            serverDir,
            '.dart_tool',
            'serverpod',
            'flutter-vm-service-info-project.json',
        ),
    };
}

/** The generated `<project>_server` attach config, which shares the
 * `serverpod_start` preLaunchTask with the Flutter one. */
function serverAttachConfig(serverDir: string): vscode.DebugConfiguration {
    return {
        name: 'project_server',
        type: 'dart',
        request: 'attach',
        vmServiceInfoFile: path.join(
            serverDir,
            '.dart_tool',
            'serverpod',
            'vm-service-info.json',
        ),
    };
}

/** Seeds a device-info file, as a crashed previous session would leave behind. */
function writeDeviceInfo(serverDir: string, deviceId: string): string {
    const infoFile = deviceInfoFilePath(serverDir);
    fs.mkdirSync(path.dirname(infoFile), { recursive: true });
    fs.writeFileSync(infoFile, JSON.stringify({ deviceId }));
    return infoFile;
}

/** The device id currently handed to `serverpod start`, if any. */
function readDeviceInfo(serverDir: string): string | undefined {
    try {
        return JSON.parse(
            fs.readFileSync(deviceInfoFilePath(serverDir), 'utf8'),
        ).deviceId;
    } catch {
        return undefined;
    }
}

const singleAppNoDevice = `
name: project_server
serverpod:
  flutter_apps:
    project:
      path: ../project_flutter
`;

suite('Flutter device selection', () => {
    teardown(() => {
        sinon.restore();
    });

    suite('serverpodAttachTarget', () => {
        test('Given a per-app info file then it is the Flutter app target.', () => {
            const p = ['', 'w', 'proj_server', '.dart_tool', 'serverpod', 'flutter-vm-service-info-app.json'].join(path.sep);
            assert.deepStrictEqual(serverpodAttachTarget(p), {
                serverDir: ['', 'w', 'proj_server'].join(path.sep),
                isFlutterApp: true,
            });
        });

        test('Given the server info file then it is the server target.', () => {
            const p = ['', 'w', 'proj_server', '.dart_tool', 'serverpod', 'vm-service-info.json'].join(path.sep);
            assert.deepStrictEqual(serverpodAttachTarget(p), {
                serverDir: ['', 'w', 'proj_server'].join(path.sep),
                isFlutterApp: false,
            });
        });

        test('Given an unrelated path then there is no target.', () => {
            assert.strictEqual(serverpodAttachTarget('/tmp/other/file.json'), undefined);
        });

        test('Given a non-string then there is no target.', () => {
            assert.strictEqual(serverpodAttachTarget(undefined), undefined);
        });
    });

    suite('isEligibleForDeviceSelection', () => {
        test('Given one app without a device line then it is eligible.', () => {
            assert.strictEqual(
                isEligibleForDeviceSelection(singleAppNoDevice, '/tmp/none'),
                true,
            );
        });

        test('Given one app with a device line then it is not eligible.', () => {
            const pubspec = `
name: project_server
serverpod:
  flutter_apps:
    project:
      path: ../project_flutter
      device: chrome
`;
            assert.strictEqual(isEligibleForDeviceSelection(pubspec, '/tmp/none'), false);
        });

        test('Given two apps then it is not eligible.', () => {
            const pubspec = `
name: project_server
serverpod:
  flutter_apps:
    web:
      path: ../web_flutter
    admin:
      path: ../admin_flutter
`;
            assert.strictEqual(isEligibleForDeviceSelection(pubspec, '/tmp/none'), false);
        });

        test('Given no flutter_apps section and an existing sibling flutter package then the synthesized app is eligible.', () => {
            const serverDir = createServerDir('name: project_server\n');
            const flutterDir = path.join(serverDir, '..', 'project_flutter');
            fs.mkdirSync(flutterDir, { recursive: true });
            fs.writeFileSync(path.join(flutterDir, 'pubspec.yaml'), 'name: project_flutter\n');

            assert.strictEqual(
                isEligibleForDeviceSelection('name: project_server\n', serverDir),
                true,
            );
        });

        test('Given no flutter_apps section and no sibling flutter package then it is not eligible.', () => {
            const serverDir = createServerDir('name: project_server\n');
            assert.strictEqual(
                isEligibleForDeviceSelection('name: project_server\n', serverDir),
                false,
            );
        });
    });

    suite('substituteWorkspaceFolder', () => {
        test('Given a workspaceFolder variable then it is expanded.', () => {
            assert.strictEqual(
                substituteWorkspaceFolder('${workspaceFolder}/a/b.json', '/work/proj'),
                '/work/proj/a/b.json',
            );
        });

        test('Given a workspaceFolder variable without a folder then it fails.', () => {
            assert.strictEqual(
                substituteWorkspaceFolder('${workspaceFolder}/a.json', undefined),
                undefined,
            );
        });

        test('Given other variables then it fails rather than mis-resolve.', () => {
            assert.strictEqual(
                substituteWorkspaceFolder('${userHome}/a.json', '/work/proj'),
                undefined,
            );
        });

        test('Given a plain path then it is returned as-is.', () => {
            assert.strictEqual(substituteWorkspaceFolder('/a/b.json', undefined), '/a/b.json');
        });
    });

    suite('clearDeviceInfo', () => {
        test('Given an existing info file then it is removed.', () => {
            const serverDir = createServerDir(singleAppNoDevice);
            const infoFile = writeDeviceInfo(serverDir, 'macos');

            clearDeviceInfo(infoFile);

            assert.strictEqual(fs.existsSync(infoFile), false);
        });

        test('Given a missing info file then it does not throw.', () => {
            clearDeviceInfo(path.join(os.tmpdir(), 'no-such-serverpod-device-info.json'));
        });
    });

    suite('resolveServerpodFlutterAttach', () => {
        test('Given a non-serverpod attach config then it is passed through untouched.', async () => {
            const config: vscode.DebugConfiguration = {
                name: 'other',
                type: 'dart',
                request: 'attach',
                vmServiceInfoFile: '/tmp/some/other/file.json',
            };
            const resolved = await resolveServerpodFlutterAttach(config);
            assert.strictEqual(resolved, config);
        });

        test('Given a config with a user-pinned deviceId then no device is written.', async () => {
            const serverDir = createServerDir(singleAppNoDevice);
            const executeCommand = sinon.stub(vscode.commands, 'executeCommand');

            const config = { ...attachConfig(serverDir), deviceId: 'chrome' };
            const resolved = await resolveServerpodFlutterAttach(config);

            assert.strictEqual(resolved, config);
            assert.strictEqual(executeCommand.called, false);
            assert.strictEqual(readDeviceInfo(serverDir), undefined);
        });

        test('Given a project with pinned device then no device is written.', async () => {
            const serverDir = createServerDir(`
name: project_server
serverpod:
  flutter_apps:
    project:
      path: ../project_flutter
      device: chrome
`);
            const executeCommand = sinon.stub(vscode.commands, 'executeCommand');

            const config = attachConfig(serverDir);
            const resolved = await resolveServerpodFlutterAttach(config);

            assert.strictEqual(resolved, config);
            assert.strictEqual(executeCommand.called, false);
            assert.strictEqual(readDeviceInfo(serverDir), undefined);
        });

        test('Given a device is already selected in VS Code then it is used without a menu.', async () => {
            const serverDir = createServerDir(singleAppNoDevice);
            const executeCommand = sinon.stub(vscode.commands, 'executeCommand');
            executeCommand.withArgs('flutter.getSelectedDeviceId').resolves('macos');

            const resolved = await resolveServerpodFlutterAttach(attachConfig(serverDir));

            assert.strictEqual(resolved?.deviceId, 'macos');
            assert.strictEqual(readDeviceInfo(serverDir), 'macos');
            assert.strictEqual(executeCommand.calledWith('flutter.selectDevice'), false);
        });

        test('Given device info left by a crashed session then the current selection replaces it.', async () => {
            const serverDir = createServerDir(singleAppNoDevice);
            writeDeviceInfo(serverDir, 'ghost-device');
            const executeCommand = sinon.stub(vscode.commands, 'executeCommand');
            executeCommand.withArgs('flutter.getSelectedDeviceId').resolves('macos');

            const resolved = await resolveServerpodFlutterAttach(attachConfig(serverDir));

            assert.strictEqual(resolved?.deviceId, 'macos');
            assert.strictEqual(readDeviceInfo(serverDir), 'macos');
        });

        test('Given no device is selected then the menu is shown and its result is written.', async () => {
            const serverDir = createServerDir(singleAppNoDevice);
            const executeCommand = sinon.stub(vscode.commands, 'executeCommand');
            executeCommand.withArgs('flutter.getSelectedDeviceId').resolves(undefined);
            executeCommand.withArgs('flutter.selectDevice').resolves({ id: 'macos' });

            const resolved = await resolveServerpodFlutterAttach(attachConfig(serverDir));

            assert.strictEqual(executeCommand.calledWith('flutter.selectDevice'), true);
            assert.strictEqual(resolved?.deviceId, 'macos');
            assert.strictEqual(readDeviceInfo(serverDir), 'macos');
        });

        test('Given the menu is dismissed then the attach is aborted and no device is left behind.', async () => {
            const serverDir = createServerDir(singleAppNoDevice);
            writeDeviceInfo(serverDir, 'ghost-device');
            const executeCommand = sinon.stub(vscode.commands, 'executeCommand');
            executeCommand.withArgs('flutter.getSelectedDeviceId').resolves(undefined);
            executeCommand.withArgs('flutter.selectDevice').resolves(undefined);

            const resolved = await resolveServerpodFlutterAttach(attachConfig(serverDir));

            assert.strictEqual(resolved, undefined);
            assert.strictEqual(readDeviceInfo(serverDir), undefined);
        });

        test('Given Dart-Code is unavailable then the attach proceeds and any stale device info is dropped.', async () => {
            const serverDir = createServerDir(singleAppNoDevice);
            writeDeviceInfo(serverDir, 'ghost-device');
            const executeCommand = sinon.stub(vscode.commands, 'executeCommand');
            executeCommand
                .withArgs('flutter.getSelectedDeviceId')
                .rejects(new Error('command not found'));

            const config = attachConfig(serverDir);
            const resolved = await resolveServerpodFlutterAttach(config);

            assert.strictEqual(resolved, config);
            assert.strictEqual(readDeviceInfo(serverDir), undefined);
        });

        test('Given a workspaceFolder-relative info file then it is resolved against the folder.', async () => {
            const serverDir = createServerDir(singleAppNoDevice);
            const workspaceFolder = path.dirname(serverDir);
            const executeCommand = sinon.stub(vscode.commands, 'executeCommand');
            executeCommand.withArgs('flutter.getSelectedDeviceId').resolves('macos');

            const config: vscode.DebugConfiguration = {
                name: 'project_flutter',
                type: 'dart',
                request: 'attach',
                vmServiceInfoFile:
                    '${workspaceFolder}/project_server/.dart_tool/serverpod/flutter-vm-service-info-project.json',
            };
            const resolved = await resolveServerpodFlutterAttach(config, workspaceFolder);

            assert.strictEqual(resolved?.deviceId, 'macos');
        });

        test('Given the server attach config then it also writes the device and waits.', async () => {
            const serverDir = createServerDir(singleAppNoDevice);
            const executeCommand = sinon.stub(vscode.commands, 'executeCommand');
            executeCommand.withArgs('flutter.getSelectedDeviceId').resolves('macos');

            const resolved = await resolveServerpodFlutterAttach(serverAttachConfig(serverDir));

            assert.strictEqual(readDeviceInfo(serverDir), 'macos');
            // The server session is not a Flutter one; it only had to wait.
            assert.strictEqual(resolved?.deviceId, undefined);
        });

        test('Given a dismissed menu on the server attach config then the launch is aborted.', async () => {
            const serverDir = createServerDir(singleAppNoDevice);
            const executeCommand = sinon.stub(vscode.commands, 'executeCommand');
            executeCommand.withArgs('flutter.getSelectedDeviceId').resolves(undefined);
            executeCommand.withArgs('flutter.selectDevice').resolves(undefined);

            const resolved = await resolveServerpodFlutterAttach(serverAttachConfig(serverDir));

            assert.strictEqual(resolved, undefined);
        });

        test('Given both compound configs resolving together then only one device menu is shown.', async () => {
            const serverDir = createServerDir(singleAppNoDevice);
            const executeCommand = sinon.stub(vscode.commands, 'executeCommand');
            executeCommand.withArgs('flutter.getSelectedDeviceId').resolves(undefined);
            let menuCalls = 0;
            executeCommand.withArgs('flutter.selectDevice').callsFake(async () => {
                menuCalls++;
                // Hold the menu open so the sibling config resolves meanwhile.
                await new Promise((r) => setTimeout(r, 20));
                return { id: 'macos' };
            });

            const [server, flutter] = await Promise.all([
                resolveServerpodFlutterAttach(serverAttachConfig(serverDir)),
                resolveServerpodFlutterAttach(attachConfig(serverDir)),
            ]);

            assert.strictEqual(menuCalls, 1, 'the compound must share one menu');
            assert.strictEqual(flutter?.deviceId, 'macos');
            assert.strictEqual(server?.deviceId, undefined);
            assert.strictEqual(readDeviceInfo(serverDir), 'macos');
        });
    });
});
