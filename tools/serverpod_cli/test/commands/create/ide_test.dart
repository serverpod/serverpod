import 'dart:convert';
import 'dart:io';

import 'package:path/path.dart' as p;
import 'package:serverpod_cli/src/create/ide.dart';
import 'package:test/test.dart';
import 'package:test_descriptor/test_descriptor.dart' as d;

void main() {
  test(
    'Given the Antigravity IDE, '
    'when reading its file path, '
    'then the MCP config lives directly in the .agents folder',
    () {
      expect(TemplateIde.antigravity.filePath, '.agents/mcp_config.json');
    },
  );

  test(
    'Given the Antigravity IDE on Windows, '
    'when rendering its config, '
    'then the MCP servers run as plain commands from the project dir',
    () {
      final config = TemplateIde.antigravity.effectiveConfig(
        serverDirRelative: 'my_app_server',
        isWindows: true,
      );

      expect(config, '''{
  "mcpServers": {
    "serverpod": {
      "command": "serverpod",
      "args": ["mcp-server", "--server-dir", "my_app_server"],
      "cwd": "."
    },
    "dart-mcp-server": {
      "command": "dart",
      "args": ["mcp-server"],
      "cwd": "."
    }
  }
}
''');
    },
  );

  test(
    'Given the Antigravity IDE on Windows, '
    'when rendering the config for a module, '
    'then only the Dart MCP server runs as a plain command',
    () {
      final config = TemplateIde.antigravity.effectiveConfig(
        serverDirRelative: 'my_module_server',
        isModule: true,
        isWindows: true,
      );

      expect(config, '''{
  "mcpServers": {
    "dart-mcp-server": {
      "command": "dart",
      "args": ["mcp-server"],
      "cwd": "."
    }
  }
}
''');
    },
  );

  group(
    'Given the Antigravity IDE on macOS or Linux,',
    testOn: '!windows',
    () {
      test(
        'with serverpod on PATH only through the login profile of SHELL, '
        'when starting the Serverpod MCP server, '
        'then serverpod runs with the project server dir',
        () async {
          final home = await _createHomeWithTools();
          _writeFile(p.join(home, '.profile'), _prependToolsToPath(home));

          final result = await _startMcpServer(
            TemplateIde.antigravity.effectiveConfig(
              serverDirRelative: 'my_app_server',
              isWindows: false,
            ),
            'serverpod',
            home: home,
            shell: '/bin/sh',
          );

          expect(
            result.stdout,
            'serverpod mcp-server --server-dir my_app_server\n',
          );
        },
      );

      test(
        'with a SHELL that puts serverpod on PATH, '
        'when starting the Serverpod MCP server, '
        'then serverpod is found through that shell',
        () async {
          final home = await _createHomeWithTools();
          final shell = p.join(home, 'custom_shell');
          _writeExecutable(
            shell,
            '${_prependToolsToPath(home)}exec /bin/sh "\$@"',
          );

          final result = await _startMcpServer(
            TemplateIde.antigravity.effectiveConfig(
              serverDirRelative: 'my_app_server',
              isWindows: false,
            ),
            'serverpod',
            home: home,
            shell: shell,
          );

          expect(
            result.stdout,
            'serverpod mcp-server --server-dir my_app_server\n',
          );
        },
      );

      test(
        'with SHELL pointing to a missing file and serverpod on PATH through ~/.profile, '
        'when starting the Serverpod MCP server, '
        'then serverpod is found through /bin/sh',
        () async {
          final home = await _createHomeWithTools();
          _writeFile(p.join(home, '.profile'), _prependToolsToPath(home));

          final result = await _startMcpServer(
            TemplateIde.antigravity.effectiveConfig(
              serverDirRelative: 'my_app_server',
              isWindows: false,
            ),
            'serverpod',
            home: home,
            shell: '/nonexistent/shell',
          );

          expect(
            result.stdout,
            'serverpod mcp-server --server-dir my_app_server\n',
          );
        },
      );

      test(
        'with SHELL pointing to a csh-family shell, '
        'when starting the Serverpod MCP server, '
        'then serverpod is found through /bin/sh instead',
        () async {
          final home = await _createHomeWithTools();
          _writeFile(p.join(home, '.profile'), _prependToolsToPath(home));
          final shell = p.join(home, 'tcsh');
          _writeExecutable(shell, 'echo "Unknown option" >&2; exit 1');

          final result = await _startMcpServer(
            TemplateIde.antigravity.effectiveConfig(
              serverDirRelative: 'my_app_server',
              isWindows: false,
            ),
            'serverpod',
            home: home,
            shell: shell,
          );

          expect(
            result.stdout,
            'serverpod mcp-server --server-dir my_app_server\n',
          );
        },
      );

      test(
        'with a module project and dart on PATH through ~/.profile, '
        'when starting the Dart MCP server, '
        'then dart runs as an MCP server',
        () async {
          final home = await _createHomeWithTools();
          _writeFile(p.join(home, '.profile'), _prependToolsToPath(home));

          final result = await _startMcpServer(
            TemplateIde.antigravity.effectiveConfig(
              serverDirRelative: 'my_module_server',
              isModule: true,
              isWindows: false,
            ),
            'dart-mcp-server',
            home: home,
            shell: '/bin/sh',
          );

          expect(result.stdout, 'dart mcp-server\n');
        },
      );
    },
  );

  group('Given the VS Code IDE', () {
    test(
      'when rendering its config '
      'then the mcpServers key is replaced with servers',
      () {
        final config = TemplateIde.vscode.effectiveConfig(
          serverDirRelative: 'my_app_server',
        );

        expect(config, contains('"servers":'));
        expect(config, isNot(contains('"mcpServers":')));
      },
    );
  });

  group('Given every IDE,', () {
    test(
      'when rendering all of its files, '
      'then no unrendered server dir slot remains',
      () {
        for (final ide in TemplateIde.values) {
          expect(
            ide.effectiveConfig(serverDirRelative: 'my_app_server'),
            isNot(contains('{serverDirRelative}')),
            reason: ide.name,
          );
        }
      },
    );

    test(
      'when rendering the config for a module '
      'then the Serverpod MCP server is left out',
      () {
        for (final ide in TemplateIde.values) {
          final config = ide.effectiveConfig(
            serverDirRelative: 'my_module_server',
            isModule: true,
          );

          expect(config, isNot(contains('serverpod')), reason: ide.name);
          expect(config, isNot(contains('my_module_server')), reason: ide.name);
        }
      },
    );

    test(
      'when rendering the config for a module '
      'then the Dart MCP server is still configured',
      () {
        for (final ide in TemplateIde.values) {
          final config = ide.effectiveConfig(
            serverDirRelative: 'my_module_server',
            isModule: true,
          );

          expect(config, contains('dart'), reason: ide.name);
          expect(config, contains('mcp-server'), reason: ide.name);
        }
      },
    );
  });
}

/// Creates a home dir with fake `serverpod` and `dart` executables in a `bin`
/// folder that is not on PATH. Each prints its name and arguments.
Future<String> _createHomeWithTools() async {
  final home = p.join(d.sandbox, 'home');
  for (final tool in ['serverpod', 'dart']) {
    _writeExecutable(p.join(home, 'bin', tool), 'echo "$tool \$*"');
  }
  return home;
}

String _prependToolsToPath(String home) =>
    'PATH="${p.join(home, 'bin')}:\$PATH"; export PATH\n';

void _writeFile(String path, String content) {
  File(path)
    ..createSync(recursive: true)
    ..writeAsStringSync(content);
}

void _writeExecutable(String path, String script) {
  _writeFile(path, '#!/bin/sh\n$script\n');
  Process.runSync('chmod', ['+x', path]);
}

/// Starts [serverName] from [config] the way an MCP client would, in an
/// environment that only has the system PATH, as a desktop-launched IDE does.
Future<ProcessResult> _startMcpServer(
  String config,
  String serverName, {
  required String home,
  required String shell,
}) {
  final servers =
      (jsonDecode(config) as Map<String, dynamic>)['mcpServers']
          as Map<String, dynamic>;
  final server = servers[serverName] as Map<String, dynamic>;
  return Process.run(
    server['command'] as String,
    (server['args'] as List).cast<String>(),
    workingDirectory: d.sandbox,
    environment: {
      'HOME': home,
      'PATH': '/usr/bin:/bin',
      'SHELL': shell,
    },
    includeParentEnvironment: false,
  );
}
