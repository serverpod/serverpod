import {
	DebugAdapterDescriptor,
	DebugAdapterDescriptorFactory,
	DebugAdapterExecutable,
	DebugConfigurationProvider,
	DebugSession,
	ExtensionContext,
	ProviderResult,
	WorkspaceFolder,
	debug,
} from 'vscode';

/**
 * Registers the `serverpod` debug type. Spawns `serverpod dap` (a hidden
 * subcommand of the serverpod CLI) as the debug adapter and fills in
 * launch.json defaults so the user only has to specify the bare minimum.
 */
export function registerServerpodDebug(context: ExtensionContext): void {
	context.subscriptions.push(
		debug.registerDebugAdapterDescriptorFactory(
			'serverpod',
			new ServerpodDebugAdapterFactory(),
		),
		debug.registerDebugConfigurationProvider(
			'serverpod',
			new ServerpodDebugConfigurationProvider(),
		),
	);
}

class ServerpodDebugAdapterFactory implements DebugAdapterDescriptorFactory {
	createDebugAdapterDescriptor(
		_session: DebugSession,
	): ProviderResult<DebugAdapterDescriptor> {
		// DebugAdapterExecutable wants `{ [key: string]: string }`; strip
		// undefined values from process.env so the cast is safe.
		const env: { [key: string]: string } = {};
		for (const [k, v] of Object.entries(process.env)) {
			if (v !== undefined) env[k] = v;
		}
		return new DebugAdapterExecutable('serverpod', ['dap'], { env });
	}
}

class ServerpodDebugConfigurationProvider
	implements DebugConfigurationProvider {
	resolveDebugConfiguration(
		folder: WorkspaceFolder | undefined,
		config: any,
	): ProviderResult<any> {
		// Only attach is supported today; launch.json snippet should reflect that.
		if (config.request !== 'attach') {
			return config;
		}

		// If neither vmServiceUri nor vmServiceInfoFile is given, default to
		// the standard location written by `serverpod start --watch`.
		if (!config.vmServiceUri && !config.vmServiceInfoFile && folder) {
			config.vmServiceInfoFile =
				'${workspaceFolder}/.dart_tool/serverpod/vm-service-info.json';
		}

		return config;
	}
}
