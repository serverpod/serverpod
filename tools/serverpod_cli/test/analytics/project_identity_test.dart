import 'dart:io';

import 'package:path/path.dart' as p;
import 'package:serverpod_cli/src/analytics/cli_analytics.dart';
import 'package:serverpod_cli/src/analytics/project_identity.dart';
import 'package:test/test.dart';
import 'package:test_descriptor/test_descriptor.dart' as d;

import '../test_util/analytics_helpers.dart';

void main() {
  test('Given SSH and HTTPS remote URLs for the same repository, '
      'when they are normalized, '
      'then they collapse to one canonical string.', () {
    const canonical = 'github.com/serverpod/serverpod';
    expect(
      ProjectIdentity.normalizeRemoteUrl(
        'git@github.com:serverpod/serverpod.git',
      ),
      canonical,
    );
    expect(
      ProjectIdentity.normalizeRemoteUrl(
        'https://github.com/serverpod/serverpod.git',
      ),
      canonical,
    );
    expect(
      ProjectIdentity.normalizeRemoteUrl(
        'ssh://git@github.com/serverpod/serverpod',
      ),
      canonical,
    );
    expect(
      ProjectIdentity.normalizeRemoteUrl(
        'https://GitHub.com/Serverpod/Serverpod/',
      ),
      canonical,
    );
  });

  test(
    'Given a remote URL that embeds credentials, '
    'when it is normalized, '
    'then they are stripped.',
    () {
      expect(
        ProjectIdentity.normalizeRemoteUrl(
          'https://user:token@gitlab.com/group/app.git',
        ),
        'gitlab.com/group/app',
      );
    },
  );

  test(
    'Given an empty remote URL, '
    'when it is normalized, '
    'then it returns null.',
    () {
      expect(ProjectIdentity.normalizeRemoteUrl('   '), isNull);
    },
  );

  test(
    'Given a project in the main worktree of a git checkout, '
    'when its git common directory is resolved, '
    'then the git common dir is the .git directory.',
    () async {
      await d.dir('repo_main', [
        d.dir('.git', [
          d.file(
            'config',
            '[remote "origin"]\n  url = git@github.com:org/app.git\n',
          ),
        ]),
        d.dir('app_server', [d.file('pubspec.yaml', 'name: app_server\n')]),
      ]).create();

      final serverDir = p.join(d.sandbox, 'repo_main', 'app_server');
      expect(
        ProjectIdentity.gitCommonDir(serverDir),
        p.join(d.sandbox, 'repo_main', '.git'),
      );
    },
  );

  test(
    'Given a project reached through an alternate filesystem path, '
    'when its git common directory is resolved, '
    'then the canonical git directory is returned.',
    () async {
      await d.dir('canonical_repo', [
        d.dir('.git', [d.file('config', '')]),
        d.dir('app_server', [d.file('pubspec.yaml', '')]),
      ]).create();
      await Link(d.path('canonical_repo_alias')).create(
        d.path('canonical_repo'),
      );

      expect(
        ProjectIdentity.gitCommonDir(
          p.join(d.sandbox, 'canonical_repo_alias', 'app_server'),
        ),
        p.join(d.sandbox, 'canonical_repo', '.git'),
      );
    },
    testOn: '!windows',
  );

  test(
    'Given a project in a linked worktree, '
    'when its git common directory is resolved, '
    'then it centralizes on the shared common dir.',
    () async {
      // Main repo with a registered worktree "wt".
      await d.dir('repo', [
        d.dir('.git', [
          d.file(
            'config',
            '[remote "origin"]\n  url = git@github.com:org/app.git\n',
          ),
          d.dir('worktrees', [
            d.dir('wt', [d.file('commondir', '../..\n')]),
          ]),
        ]),
        d.dir('app_server', [d.file('pubspec.yaml', 'name: app_server\n')]),
      ]).create();
      // The linked worktree: its `.git` is a file pointing at the gitdir.
      final worktreeGitDir = p.join(
        d.sandbox,
        'repo',
        '.git',
        'worktrees',
        'wt',
      );
      await d.dir('wt', [
        d.file('.git', 'gitdir: $worktreeGitDir\n'),
        d.dir('app_server', [d.file('pubspec.yaml', 'name: app_server\n')]),
      ]).create();

      final commonDir = p.join(d.sandbox, 'repo', '.git');
      final mainServerDir = p.join(d.sandbox, 'repo', 'app_server');
      final worktreeServerDir = p.join(d.sandbox, 'wt', 'app_server');

      // The worktree resolves to the same common dir as the main repo, so
      // both share one metadata location (no per-leaf copies).
      expect(
        ProjectIdentity.gitCommonDir(worktreeServerDir),
        commonDir,
      );
      expect(
        ProjectIdentity.metadataDirectory(worktreeServerDir),
        ProjectIdentity.metadataDirectory(mainServerDir),
      );
      expect(
        ProjectIdentity.durableProjectId(worktreeServerDir),
        ProjectIdentity.durableProjectId(mainServerDir),
      );
    },
  );

  test(
    'Given a project in a Dart workspace nested inside an outer git checkout, '
    'when its git common directory is resolved, '
    'then lookup stops at the workspace boundary.',
    () async {
      await d.dir('outer_repo', [
        d.dir('.git', [d.file('config', '')]),
        d.dir('workspace', [
          d.file('pubspec.yaml', '''
name: workspace
workspace:
  - app_server
'''),
          d.dir('app_server', [
            d.file('pubspec.yaml', 'name: app_server\n'),
          ]),
        ]),
      ]).create();

      final serverDir = p.join(
        d.sandbox,
        'outer_repo',
        'workspace',
        'app_server',
      );

      expect(ProjectIdentity.gitCommonDir(serverDir), isNull);
      expect(
        ProjectIdentity.metadataDirectory(serverDir),
        p.join(serverDir, '.dart_tool', 'serverpod'),
      );
    },
  );

  test(
    'Given a project whose Dart workspace and git checkout share a root, '
    'when its git common directory is resolved, '
    'then the colocated git directory is used.',
    () async {
      await d.dir('workspace_repo', [
        d.dir('.git', [d.file('config', '')]),
        d.file('pubspec.yaml', '''
name: workspace
workspace:
  - app_server
'''),
        d.dir('app_server', [
          d.file('pubspec.yaml', 'name: app_server\n'),
        ]),
      ]).create();

      final serverDir = p.join(
        d.sandbox,
        'workspace_repo',
        'app_server',
      );

      expect(
        ProjectIdentity.gitCommonDir(serverDir),
        p.join(d.sandbox, 'workspace_repo', '.git'),
      );
    },
  );

  test(
    'Given a project below an ordinary parent package in a git checkout, '
    'when its git common directory is resolved, '
    'then lookup continues through the non-workspace pubspec.',
    () async {
      await d.dir('package_repo', [
        d.dir('.git', [d.file('config', '')]),
        d.dir('package', [
          d.file('pubspec.yaml', 'name: package\n'),
          d.dir('app_server', [
            d.file('pubspec.yaml', 'name: app_server\n'),
          ]),
        ]),
      ]).create();

      final serverDir = p.join(
        d.sandbox,
        'package_repo',
        'package',
        'app_server',
      );

      expect(
        ProjectIdentity.gitCommonDir(serverDir),
        p.join(d.sandbox, 'package_repo', '.git'),
      );
    },
  );

  test(
    'Given two servers in the same git checkout, '
    'when their analytics identities are resolved, '
    'then each server is tracked independently.',
    () async {
      final recording = RecordingAnalytics();
      initializeCliAnalytics(
        CliAnalytics(analytics: recording)..enabled = true,
      );
      addTearDown(() => initializeCliAnalytics(CliAnalytics.disabled()));

      await d.dir('monorepo', [
        d.dir('.git', [
          d.file(
            'config',
            '[remote "origin"]\n  url = git@github.com:org/monorepo.git\n',
          ),
        ]),
        d.dir('apps', [
          d.dir('first_server', [d.file('pubspec.yaml', '')]),
        ]),
        d.dir('services', [
          d.dir('second_server', [d.file('pubspec.yaml', '')]),
        ]),
      ]).create();

      final firstServer = p.join(
        d.sandbox,
        'monorepo',
        'apps',
        'first_server',
      );
      final secondServer = p.join(
        d.sandbox,
        'monorepo',
        'services',
        'second_server',
      );

      await cliAnalytics.captureFlutterLaunch(
        serverDir: firstServer,
        device: 'chrome',
        isRelaunch: false,
      );
      await cliAnalytics.captureFlutterLaunch(
        serverDir: secondServer,
        device: 'chrome',
        isRelaunch: false,
      );

      final first = recording.properties.first;
      final second = recording.properties.last;
      expect(first[r'$groups'], isNot(second[r'$groups']));
      expect(first['checkout_id'], isNot(second['checkout_id']));
    },
  );

  test(
    'Given two git checkouts sharing a remote, '
    'when their durable project ids are derived, '
    'then they derive the same durable project id.',
    () async {
      await d.dir('clone_ssh', [
        d.dir('.git', [
          d.file(
            'config',
            '[remote "origin"]\n  url = git@github.com:org/app.git\n',
          ),
        ]),
        d.dir('app_server', [d.file('pubspec.yaml', '')]),
      ]).create();
      await d.dir('clone_https', [
        d.dir('.git', [
          d.file(
            'config',
            '[remote "origin"]\n  url = https://github.com/org/app.git\n',
          ),
        ]),
        d.dir('app_server', [d.file('pubspec.yaml', '')]),
      ]).create();

      final sshId = ProjectIdentity.durableProjectId(
        p.join(d.sandbox, 'clone_ssh', 'app_server'),
      );
      final httpsId = ProjectIdentity.durableProjectId(
        p.join(d.sandbox, 'clone_https', 'app_server'),
      );

      expect(sshId, isNotNull);
      expect(sshId, httpsId);
    },
  );

  test(
    'Given a git checkout without a remote, '
    'when its durable project id is derived, '
    'then the durable project id is null.',
    () async {
      await d.dir('no_remote', [
        d.dir('.git', [d.file('config', '[core]\n  bare = false\n')]),
        d.dir('app_server', [d.file('pubspec.yaml', '')]),
      ]).create();

      expect(
        ProjectIdentity.durableProjectId(
          p.join(d.sandbox, 'no_remote', 'app_server'),
        ),
        isNull,
      );
    },
  );

  test(
    'Given a git checkout without a remote, '
    'when analytics are captured twice, '
    'then its anonymous checkout id is reused as the project id.',
    () async {
      final recording = RecordingAnalytics();
      initializeCliAnalytics(
        CliAnalytics(analytics: recording)..enabled = true,
      );
      addTearDown(() => initializeCliAnalytics(CliAnalytics.disabled()));

      await d.dir('fallback_no_remote', [
        d.dir('.git', [d.file('config', '[core]\n  bare = false\n')]),
        d.dir('app_server', [d.file('pubspec.yaml', '')]),
      ]).create();
      final serverDir = p.join(
        d.sandbox,
        'fallback_no_remote',
        'app_server',
      );

      await cliAnalytics.captureFlutterLaunch(
        serverDir: serverDir,
        device: 'chrome',
        isRelaunch: false,
      );
      await cliAnalytics.captureFlutterLaunch(
        serverDir: serverDir,
        device: 'chrome',
        isRelaunch: true,
      );

      final first = recording.properties.first;
      final second = recording.properties.last;
      expect(first[r'$groups'], {'project': first['checkout_id']});
      expect(second[r'$groups'], first[r'$groups']);
      expect(second['checkout_id'], first['checkout_id']);
    },
  );

  test(
    'Given a project outside a git checkout, '
    'when analytics are captured twice, '
    'then its local anonymous id is reused as the project id.',
    () async {
      final recording = RecordingAnalytics();
      initializeCliAnalytics(
        CliAnalytics(analytics: recording)..enabled = true,
      );
      addTearDown(() => initializeCliAnalytics(CliAnalytics.disabled()));

      await d.dir('fallback_no_git', [
        d.file('pubspec.yaml', '''
name: workspace
workspace:
  - app_server
'''),
        d.dir('app_server', [d.file('pubspec.yaml', '')]),
      ]).create();
      final serverDir = p.join(
        d.sandbox,
        'fallback_no_git',
        'app_server',
      );

      await cliAnalytics.captureFlutterLaunch(
        serverDir: serverDir,
        device: 'chrome',
        isRelaunch: false,
      );
      await cliAnalytics.captureFlutterLaunch(
        serverDir: serverDir,
        device: 'chrome',
        isRelaunch: true,
      );

      final first = recording.properties.first;
      final second = recording.properties.last;
      expect(first[r'$groups'], {'project': first['checkout_id']});
      expect(second[r'$groups'], first[r'$groups']);
      expect(second['checkout_id'], first['checkout_id']);
    },
  );
}
