import { spawn, ChildProcess } from 'child_process';
import {
	DebugAdapterDescriptor,
	DebugAdapterDescriptorFactory,
	DebugAdapterExecutable,
	DebugAdapterNamedPipeServer,
	DebugSession,
	Disposable,
	ExtensionContext,
	OutputChannel,
	debug,
	window,
} from 'vscode';

/** Marker lines `serverpod dap` writes to stderr to announce its chosen
 *  transport. The literals are the contract between the two sides; if you
 *  change them here, update `DapCommand.socketAnnouncement` /
 *  `DapCommand.stdioAnnouncement` in
 *  `tools/serverpod_cli/lib/src/commands/dap.dart` to match. */
const SOCKET_LINE = /^SERVERPOD_DAP_SOCKET=(.+?)\s*$/;
const STDIO_LINE = /^SERVERPOD_DAP_STDIO\s*$/;

/** Single shared output channel; created lazily on first attach so the user
 *  doesn't see an empty channel until they actually try to debug. */
let sharedChannel: OutputChannel | undefined;

function getOutput(): OutputChannel {
	return (sharedChannel ??= window.createOutputChannel('Serverpod DAP'));
}

/**
 * Registers the `serverpod` debug type. For each session, spawns
 * `serverpod dap` (with cwd = the active workspace folder so the CLI's
 * `ServerDirectoryFinder` has a starting point), waits for the CLI to
 * announce its chosen transport on stderr, and dispatches:
 *
 * - `SERVERPOD_DAP_SOCKET=<path>` -> `DebugAdapterNamedPipeServer(path)`.
 *   VS Code connects to the Unix domain socket the CLI bound at the
 *   announced path.
 * - `SERVERPOD_DAP_STDIO` -> kill the spawned process and return
 *   `DebugAdapterExecutable` so VS Code respawns the CLI and manages stdio
 *   framing itself. Used when the CLI's platform doesn't support AF_UNIX
 *   (Windows on Dart < 3.11).
 */
export function registerServerpodDebug(context: ExtensionContext): void {
	context.subscriptions.push(
		debug.registerDebugAdapterDescriptorFactory(
			'serverpod',
			new ServerpodDebugAdapterFactory(context),
		),
	);
}

class ServerpodDebugAdapterFactory implements DebugAdapterDescriptorFactory {
	constructor(private readonly context: ExtensionContext) {}

	async createDebugAdapterDescriptor(
		session: DebugSession,
	): Promise<DebugAdapterDescriptor> {
		const out = getOutput();
		out.show(true);
		out.appendLine(`--- ${new Date().toISOString()} attach request ---`);
		out.appendLine(`PATH=${process.env.PATH ?? '(unset)'}`);
		out.appendLine(
			`resolved config: ${JSON.stringify(session.configuration, null, 2)}`,
		);

		const env: { [key: string]: string } = {};
		for (const [k, v] of Object.entries(process.env)) {
			if (v !== undefined) env[k] = v;
		}

		// Anchor the CLI's working directory at the workspace folder so its
		// `ServerDirectoryFinder` has a meaningful starting point for
		// discovering the server package. Falls back to no override (CLI
		// will start from process.cwd()) if there's no folder context.
		const folder = session.workspaceFolder;
		const cwd = folder?.uri.fsPath;

		out.appendLine(`spawning: serverpod dap (cwd=${cwd ?? '(none)'})`);
		const proc = spawn('serverpod', ['dap'], {
			env,
			cwd,
			shell: true,
			// Pipe both streams so we can surface every byte the CLI writes,
			// regardless of whether log lines / banners go to stdout or
			// stderr.
			stdio: ['ignore', 'pipe', 'pipe'],
		});
		out.appendLine(
			`spawned: pid=${proc.pid ?? '(none)'}, ` +
			`stdout=${proc.stdout ? 'piped' : 'null'}, ` +
			`stderr=${proc.stderr ? 'piped' : 'null'}`,
		);

		// Tie process lifetime to this debug session: kill it when the
		// session ends instead of waiting for extension shutdown, so
		// repeated attaches don't accumulate adapter processes.
		const sessionEnd = debug.onDidTerminateDebugSession((ended) => {
			if (ended.id !== session.id) return;
			sessionEnd.dispose();
			if (proc.exitCode === null) proc.kill();
		});
		// Belt-and-braces: also kill on extension dispose so a stuck
		// process doesn't survive the editor.
		const disposeKill = killOnDispose(proc);
		this.context.subscriptions.push(disposeKill);

		const announcement = await waitForAnnouncement(proc, out);

		if (announcement.kind === 'socket') {
			out.appendLine(
				`got socket path ${announcement.path}; ` +
				'returning DebugAdapterNamedPipeServer',
			);
			return new DebugAdapterNamedPipeServer(announcement.path);
		}

		// stdio path: this spawn was just for the announcement. VS Code
		// will respawn via DebugAdapterExecutable and manage stdio framing
		// itself.
		out.appendLine(
			'got stdio announcement; killing probe spawn and ' +
			'returning DebugAdapterExecutable',
		);
		sessionEnd.dispose();
		disposeKill.dispose();
		return new DebugAdapterExecutable('serverpod', ['dap'], { env, cwd });
	}
}

type Announcement =
	| { kind: 'socket'; path: string }
	| { kind: 'stdio' };

/** Resolves with the transport announcement from `serverpod dap`. Watches
 *  both stdout and stderr because we don't know upfront which stream a
 *  given Dart/puro/log layer chose, and we don't want a missed
 *  announcement to be invisible to the user. Every non-marker line is
 *  echoed to [out]. */
function waitForAnnouncement(
	proc: ChildProcess,
	out: OutputChannel,
): Promise<Announcement> {
	return new Promise<Announcement>((resolve, reject) => {
		let resolved = false;
		const buffers: { [key: string]: string } = { stdout: '', stderr: '' };

		const onLine = (source: 'stdout' | 'stderr', line: string) => {
			const m = SOCKET_LINE.exec(line);
			if (m) {
				resolved = true;
				out.appendLine(`[${source}] (socket announcement) ${line}`);
				resolve({ kind: 'socket', path: m[1] });
				return;
			}
			if (STDIO_LINE.test(line)) {
				resolved = true;
				out.appendLine(`[${source}] (stdio announcement) ${line}`);
				resolve({ kind: 'stdio' });
				return;
			}
			out.appendLine(`[${source}] ${line}`);
		};

		const attach = (
			stream: NodeJS.ReadableStream | null,
			source: 'stdout' | 'stderr',
		) => {
			if (!stream) {
				out.appendLine(`(${source} is not piped)`);
				return;
			}
			stream.on('data', (chunk: Buffer | string) => {
				const text = typeof chunk === 'string' ? chunk : chunk.toString('utf8');
				// Once the announcement is known we no longer need to scan
				// line-by-line; just forward bytes verbatim.
				if (resolved) {
					out.append(text);
					return;
				}
				buffers[source] += text;
				let nl: number;
				while ((nl = buffers[source].indexOf('\n')) !== -1) {
					const line = buffers[source].slice(0, nl).replace(/\r$/, '');
					buffers[source] = buffers[source].slice(nl + 1);
					onLine(source, line);
				}
			});
		};

		attach(proc.stdout, 'stdout');
		attach(proc.stderr, 'stderr');

		proc.on('exit', (code, signal) => {
			out.appendLine(`process exited: code=${code}, signal=${signal}`);
			if (resolved) return;
			reject(new Error(
				`serverpod dap exited (code=${code}, signal=${signal}) ` +
				'before announcing a transport. See the "Serverpod DAP" output channel.',
			));
		});
		proc.on('error', (err) => {
			out.appendLine(`process error: ${err.message}`);
			if (resolved) return;
			reject(err);
		});

		// Cap the wait so a stuck CLI fails fast instead of hanging the IDE.
		setTimeout(() => {
			if (resolved) return;
			out.appendLine('timed out waiting for transport announcement; killing.');
			proc.kill();
			reject(new Error(
				'Timed out waiting for `serverpod dap` to announce a transport. ' +
				'See the "Serverpod DAP" output channel.',
			));
		}, 30_000);
	});
}

function killOnDispose(proc: ChildProcess): Disposable {
	return {
		dispose: () => {
			if (proc.exitCode === null) proc.kill();
		},
	};
}
