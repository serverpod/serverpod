import 'package:path/path.dart' as p;
import 'package:serverpod_cli/src/analytics/project_identity.dart';
import 'package:test/test.dart';
import 'package:test_descriptor/test_descriptor.dart' as d;

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

      final mainServerDir = p.join(d.sandbox, 'repo', '.git'); // common dir
      final worktreeServerDir = p.join(d.sandbox, 'wt', 'app_server');

      // The worktree resolves to the same common dir as the main repo, so
      // both share one metadata location (no per-leaf copies).
      expect(
        ProjectIdentity.gitCommonDir(worktreeServerDir),
        mainServerDir,
      );
      expect(
        ProjectIdentity.metadataDirectory(worktreeServerDir),
        p.join(mainServerDir, 'serverpod'),
      );
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
}
