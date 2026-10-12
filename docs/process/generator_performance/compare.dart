// Same-machine comparison of the code generator. Builds the baseline from an
// isolated copy of its revision; never switches branches or changes the
// workspace's dependency resolution.
import 'dart:convert';
import 'dart:io';

import 'workload.dart';

Future<ProcessResult> command(
  String executable,
  List<String> args, {
  String? cwd,
  Map<String, String>? environment,
}) async {
  final result = await Process.run(
    executable,
    args,
    workingDirectory: cwd,
    environment: environment,
  );
  if (result.exitCode != 0) {
    throw ProcessException(
      executable,
      args,
      '${result.stdout}\n${result.stderr}',
      result.exitCode,
    );
  }
  return result;
}

String option(List<String> args, String name, String fallback) =>
    args
        .where((arg) => arg.startsWith('--$name='))
        .map((arg) => arg.substring(name.length + 3))
        .singleOrNull ??
    fallback;

int intOption(List<String> args, String name, int fallback) {
  final value = int.tryParse(option(args, name, '$fallback'));
  if (value == null || value < 1) {
    throw ArgumentError('--$name takes a positive integer');
  }
  return value;
}

double median(List<double> values) {
  final sorted = [...values]..sort();
  final middle = sorted.length ~/ 2;
  return sorted.length.isOdd
      ? sorted[middle]
      : (sorted[middle - 1] + sorted[middle]) / 2;
}

Future<String> fileHash(File file) async => (await command(
  'git',
  ['hash-object', '--', file.path],
)).stdout.toString().trim();

Future<Map<String, String>> untrackedDartSources(Directory root) async {
  final files =
      (await command(
            'git',
            ['ls-files', '--others', '--exclude-standard', '-z'],
            cwd: root.path,
          )).stdout
          .toString()
          .split('\u0000')
          .where((path) => path.endsWith('.dart'))
          .toList()
        ..sort();
  return {
    for (final path in files)
      path: await fileHash(File.fromUri(root.uri.resolve(path))),
  };
}

Set<Uri> compilerInputs(String depfile) {
  final separator = depfile.indexOf(': ');
  if (separator < 0) throw FormatException('Invalid compiler depfile');
  final paths = <Uri>{};
  var token = StringBuffer();
  var escaped = false;

  void flush() {
    if (token.isNotEmpty) {
      paths.add(File(token.toString()).absolute.uri.normalizePath());
      token = StringBuffer();
    }
  }

  // Make-style paths escape spaces and backslashes, including on Windows.
  for (final unit in depfile.substring(separator + 2).codeUnits) {
    if (escaped) {
      token.writeCharCode(unit);
      escaped = false;
    } else if (unit == 92) {
      escaped = true;
    } else if (unit == 32 || unit == 9 || unit == 10 || unit == 13) {
      flush();
    } else {
      token.writeCharCode(unit);
    }
  }
  if (escaped) throw FormatException('Incomplete depfile escape');
  flush();
  return paths;
}

const _valueOptions = [
  'baseline',
  'package-config',
  'native-assets',
  'scale',
  'repeats',
  'edit-samples',
];

Future<void> main(List<String> args) async {
  if (args.contains('--help')) {
    stdout.writeln(
      'dart run docs/process/generator_performance/compare.dart [options]\n'
      '  --baseline=<git-ref>     Required: revision to compare with the working tree\n'
      '  --quick                  50 files per fixture (smoke check only)\n'
      '  --scale=<n>              Files added at once, and future calls, endpoints and\n'
      '                           models in the large project. At least 2.\n'
      '                           Default: 1000\n'
      '  --repeats=<n>            Times the workload runs per revision. Default: 1\n'
      '  --edit-samples=<n>       Times each edit is repeated per watch session. Default: 1\n'
      '  --package-config=<path>  The working tree\'s package configuration.\n'
      '                           Default: .dart_tool/package_config.json\n'
      '  --native-assets=<path>   The working tree\'s native assets.\n'
      '                           Default: .dart_tool/native_assets.yaml\n'
      '  --keep                   Keep the temporary sources, projects and kernels\n'
      'Requires git, tar, a resolved workspace and built native assets. The\n'
      'baseline revision is extracted and resolved on its own, which needs its\n'
      'dependencies in the pub cache or network access.\n'
      'Prints fresh Markdown results; no historical timing files are inputs.',
    );
    return;
  }
  for (final arg in args) {
    if (arg != '--quick' &&
        arg != '--keep' &&
        !_valueOptions.any((name) => arg.startsWith('--$name='))) {
      throw ArgumentError('Unknown argument: $arg');
    }
  }

  final scale = intOption(args, 'scale', args.contains('--quick') ? 50 : 1000);
  if (scale < 2) {
    // The edits need a future call with and one without parameters, and a
    // model that another one depends on.
    throw ArgumentError('--scale must be at least 2');
  }

  final baselineRef = option(args, 'baseline', '');
  if (baselineRef.isEmpty) {
    throw ArgumentError(
      'Provide --baseline=<git-ref> to select the revision to compare. '
      'Use --baseline=HEAD to measure uncommitted generator changes.',
    );
  }
  final quick = args.contains('--quick');
  final workloadOptions = WorkloadOptions(
    scale: scale,
    repeats: intOption(args, 'repeats', 1),
    editSamples: intOption(args, 'edit-samples', 1),
    settle: const Duration(milliseconds: 300),
    stepTimeout: const Duration(minutes: 10),
  );

  final root = Directory(
    (await command('git', [
      'rev-parse',
      '--show-toplevel',
    ])).stdout.toString().trim(),
  );
  final baseline = (await command('git', [
    'rev-parse',
    '--verify',
    '$baselineRef^{commit}',
  ])).stdout.toString().trim();
  final head = (await command('git', [
    'rev-parse',
    'HEAD',
  ])).stdout.toString().trim();
  final beforeDiff = (await command('git', [
    'diff',
    'HEAD',
    '--',
  ])).stdout.toString();
  final beforeUntracked = await untrackedDartSources(root);
  const cliPath = 'tools/serverpod_cli';
  final cliDiffers =
      (await command('git', [
        'diff',
        '--name-only',
        baseline,
        '--',
        cliPath,
      ], cwd: root.path)).stdout.toString().trim().isNotEmpty ||
      beforeUntracked.keys.any((path) => path.startsWith('$cliPath/'));

  final started = DateTime.now();
  final scratch = await Directory.systemTemp.createTemp(
    'serverpod_generator_compare_',
  );
  final keep = args.contains('--keep');
  try {
    final diffFile = File('${scratch.path}/working-tree.diff')
      ..writeAsStringSync(beforeDiff);
    final diffHash = await fileHash(diffFile);

    final sdkBin = File(Platform.resolvedExecutable).parent;
    final suffix = Platform.isWindows ? '.exe' : '';
    final dart = '${sdkBin.path}/dart$suffix';
    final compiler = '${sdkBin.path}/snapshots/gen_kernel_aot.dart.snapshot';
    final platform =
        '${sdkBin.parent.path}/lib/_internal/vm_platform_strong.dill';
    // The CLI resolves `dart` from PATH for the projects it creates. Put the
    // SDK running this script first so everything uses a single SDK.
    final environment = {
      'SERVERPOD_HOME': root.path,
      'PATH':
          '${sdkBin.path}${Platform.isWindows ? ';' : ':'}'
          '${Platform.environment['PATH'] ?? ''}',
    };

    // The baseline is a complete copy of its revision with its own dependency
    // resolution, so it does not have to compile against the working tree's
    // packages: either revision may add, remove or upgrade dependencies and
    // workspace packages.
    stderr.writeln('Extracting the baseline revision...');
    final baselineRoot = await Directory('${scratch.path}/baseline').create();
    final archive = '${scratch.path}/baseline.tar';
    await command('git', [
      'archive',
      '--format=tar',
      '--output=$archive',
      baseline,
    ], cwd: root.path);
    await command('tar', ['-xf', archive, '-C', baselineRoot.path]);
    await File(archive).delete();
    final baselineCli = Directory('${baselineRoot.path}/$cliPath');
    if (!File('${baselineCli.path}/bin/serverpod_cli.dart').existsSync()) {
      throw StateError('The baseline has no $cliPath/bin/serverpod_cli.dart');
    }
    // Start from the working tree's lock file, when the baseline does not
    // bring its own, so the dependencies both revisions share resolve to the
    // same versions wherever the baseline's constraints allow it.
    final workingTreeLock = File('${root.path}/pubspec.lock');
    final baselineLock = File('${baselineRoot.path}/pubspec.lock');
    if (workingTreeLock.existsSync() && !baselineLock.existsSync()) {
      await workingTreeLock.copy(baselineLock.path);
    }
    stderr.writeln('Resolving the baseline dependencies...');
    await command(
      dart,
      ['pub', 'get'],
      cwd: baselineCli.path,
      environment: environment,
    );
    // Running the CLI once builds the native assets its dependencies need.
    await command(
      dart,
      ['run', 'bin/serverpod_cli.dart', '--no-analytics', 'version'],
      cwd: baselineCli.path,
      environment: {...environment, 'SERVERPOD_HOME': baselineRoot.path},
    );

    /// The package configuration that applies to the CLI below [treeRoot].
    File packageConfigOf(Directory treeRoot) {
      var directory = Directory('${treeRoot.path}/$cliPath').absolute;
      while (true) {
        final config = File('${directory.path}/.dart_tool/package_config.json');
        if (config.existsSync()) return config;
        if (directory.path == treeRoot.absolute.path ||
            directory.parent.path == directory.path) {
          throw StateError(
            'No .dart_tool/package_config.json for $cliPath in '
            '${treeRoot.path}. Resolve its dependencies with dart pub get.',
          );
        }
        directory = directory.parent;
      }
    }

    final treeRoots = {'baseline': baselineRoot, 'candidate': root};
    final configFiles = {
      'baseline': packageConfigOf(baselineRoot),
      'candidate': args.any((arg) => arg.startsWith('--package-config='))
          ? File(option(args, 'package-config', '')).absolute
          : packageConfigOf(root),
    };
    File assetsBeside(File config) =>
        File('${config.parent.path}/native_assets.yaml');
    final assetsFiles = {
      'baseline': assetsBeside(configFiles['baseline']!),
      'candidate': args.any((arg) => arg.startsWith('--native-assets='))
          ? File(option(args, 'native-assets', '')).absolute
          : assetsBeside(configFiles['candidate']!),
    };
    if (!assetsFiles['candidate']!.existsSync()) {
      throw StateError(
        'Missing ${assetsFiles['candidate']!.path}. Build workspace native assets first with:\n'
        'dart run tools/serverpod_cli/bin/serverpod_cli.dart version',
      );
    }

    final revisions = <String, CliRevision>{};
    final kernelHashes = <String, String>{};
    final compiledSourceCounts = <String, int>{};

    for (final label in ['baseline', 'candidate']) {
      final treeRoot = treeRoots[label]!;
      final config = configFiles[label]!;
      final assets = assetsFiles[label]!;
      final kernel = '${scratch.path}/$label.dill';
      final depfile = File('${scratch.path}/$label.d');
      stderr.writeln(
        'Compiling the $label CLI from its own sources and dependencies...',
      );
      await command('${sdkBin.path}/dartaotruntime$suffix', [
        compiler,
        '--platform',
        platform,
        '--packages',
        config.path,
        // A revision whose dependencies have no native assets has no mapping.
        if (assets.existsSync()) ...['--native-assets', assets.path],
        '--output',
        kernel,
        '--depfile',
        depfile.path,
        '${treeRoot.path}/$cliPath/bin/serverpod_cli.dart',
      ]);
      final inputs = compilerInputs(await depfile.readAsString());
      // This checks compiler-produced dependency evidence, not a package map
      // supplied later at runtime. A wrong compile-time map must fail here.
      final ownCli = Directory(
        '${treeRoot.path}/$cliPath/lib/',
      ).absolute.uri.normalizePath().toString();
      if (!inputs.any((input) => input.toString().startsWith(ownCli))) {
        throw StateError('Compiler did not consume the $label CLI: $ownCli');
      }
      final otherTree =
          treeRoots[label == 'baseline' ? 'candidate' : 'baseline']!
              .absolute
              .uri
              .normalizePath()
              .toString();
      final mixed = inputs
          .map((input) => input.toString())
          .where((input) => input.startsWith(otherTree))
          // The scratch directory is not below the working tree, but guard
          // against a baseline input that is.
          .where((input) => !input.startsWith(treeRoot.absolute.uri.toString()))
          .firstOrNull;
      if (mixed != null) {
        throw StateError('Compiler mixed revisions for $label: $mixed');
      }
      compiledSourceCounts[label] = inputs.length;
      kernelHashes[label] = await fileHash(File(kernel));
      revisions[label] = CliRevision(
        label: label,
        dart: dart,
        packageConfig: config.path,
        kernel: kernel,
        environment: environment,
      );
    }

    /// Packages from outside the revision's tree, by name, with the location
    /// that identifies their version.
    Map<String, String> externalPackages(String label) {
      final config = configFiles[label]!;
      final tree = treeRoots[label]!.absolute.uri.normalizePath().toString();
      final packages =
          (jsonDecode(config.readAsStringSync())
                  as Map<String, dynamic>)['packages']
              as List;
      return {
        for (final package in packages.cast<Map<String, dynamic>>())
          if (!Directory.fromUri(
            config.uri.resolve(package['rootUri'] as String),
          ).absolute.uri.normalizePath().toString().startsWith(tree))
            package['name'] as String: Uri.parse(
              package['rootUri'] as String,
            ).pathSegments.lastWhere((segment) => segment.isNotEmpty),
      };
    }

    final baselinePackages = externalPackages('baseline');
    final candidatePackages = externalPackages('candidate');
    final dependencyDifferences = [
      for (final name in {
        ...baselinePackages.keys,
        ...candidatePackages.keys,
      }.toList()..sort())
        if (baselinePackages[name] != candidatePackages[name])
          '$name (${baselinePackages[name] ?? 'absent'} → '
              '${candidatePackages[name] ?? 'absent'})',
    ];

    // Both revisions measure copies of one project, created by the candidate.
    const projectName = 'benchproject';
    stderr.writeln(
      'Creating the project that every measurement starts from...',
    );
    final templateParent = await Directory('${scratch.path}/template').create();
    await command(
      dart,
      revisions['candidate']!.arguments([
        '--no-interactive',
        'create',
        projectName,
        '--template',
        'server',
      ]),
      cwd: templateParent.path,
      environment: environment,
    );
    final template = Directory('${templateParent.path}/$projectName');
    if (!Directory('${template.path}/${projectName}_server').existsSync()) {
      throw StateError('serverpod create did not create ${template.path}');
    }

    final results = await runWorkload(
      baseline: revisions['baseline']!,
      candidate: revisions['candidate']!,
      template: template,
      projectName: projectName,
      scratch: scratch,
      options: workloadOptions,
      log: stderr.writeln,
    );

    for (final label in ['baseline', 'candidate']) {
      if (await fileHash(File(revisions[label]!.kernel)) !=
          kernelHashes[label]) {
        throw StateError('$label kernel changed during measurement');
      }
    }
    if ((await command('git', [
              'rev-parse',
              'HEAD',
            ])).stdout.toString().trim() !=
            head ||
        (await command('git', ['diff', 'HEAD', '--'])).stdout.toString() !=
            beforeDiff ||
        jsonEncode(await untrackedDartSources(root)) !=
            jsonEncode(beforeUntracked)) {
      throw StateError(
        'Source changed during measurement; rerun on a stable tree.',
      );
    }
    final sampleCountProblems = results.sampleCountProblems([
      'baseline',
      'candidate',
    ]);
    if (sampleCountProblems.isNotEmpty) {
      throw StateError(
        'Incomplete measurement set:\n${sampleCountProblems.join('\n')}',
      );
    }

    stdout.writeln('# Code generator same-machine comparison\n');
    stdout.writeln(
      'Baseline: `$baseline`. Candidate: `$head`${beforeDiff.isEmpty ? '' : ' plus working-tree edits'}.',
    );
    stdout.writeln(
      'Generated: ${DateTime.now().toUtc().toIso8601String()}. Host: ${Platform.operatingSystem} ${Platform.operatingSystemVersion}, ${Platform.numberOfProcessors} processors.',
    );
    stdout.writeln(
      'Duration: ${DateTime.now().difference(started).inMinutes} minutes.',
    );
    stdout.writeln('Dart: ${Platform.version}.');
    stdout.writeln(
      'Each CLI is compiled from the complete source tree of its revision with its own resolved dependencies and native assets, using the same Dart SDK. The measured project is created by the candidate CLI and depends on the working tree\'s Serverpod packages for both.',
    );
    stdout.writeln(
      'External dependencies that differ (baseline → candidate): ${dependencyDifferences.isEmpty ? 'none' : dependencyDifferences.join(', ')}.',
    );
    if (!cliDiffers) {
      stdout.writeln(
        '**The revisions do not differ in `$cliPath`; differences below come from its dependencies or from noise.**',
      );
    }
    stdout.writeln('Execution: CLI compiled to kernel, run with JIT.');
    stdout.writeln('Git blob hash: tracked diff=$diffHash.');
    stdout.writeln(
      'Untracked Dart source hashes: ${beforeUntracked.entries.map((e) => '${e.key}=${e.value}').join(', ')}.',
    );
    for (final label in ['baseline', 'candidate']) {
      stdout.writeln(
        '$label compiler inputs: ${compiledSourceCounts[label]}; kernel blob=${kernelHashes[label]}.',
      );
    }
    stdout.writeln(
      'Fixture: ${workloadOptions.scale} files per kind; ${workloadOptions.repeats} workload run(s) per revision; ${workloadOptions.editSamples} sample(s) per edit and watch session.',
    );
    stdout.writeln(
      '\n${quick ? '**Smoke check only; do not use these reduced timings as performance evidence.**' : 'The revision that runs first alternates between scenarios. Host load is uncontrolled.'}\n',
    );

    for (final note in results.notes) {
      stdout.writeln('**$note**\n');
    }
    if (results.verificationFailures.isEmpty) {
      stdout.writeln(
        'Every measured run produced the generated code it was expected to, and generated nothing where nothing was expected.\n',
      );
    } else {
      stdout.writeln('**Runs that did not behave as expected:**\n');
      for (final failure in results.verificationFailures) {
        stdout.writeln('- $failure');
      }
      stdout.writeln();
    }

    const metrics = <(String, double? Function(Sample))>[
      ('Analysis', _analysis),
      ('Generation', _generation),
      ('Wall clock', _wall),
    ];
    List<double> values(
      String operation,
      Mode mode,
      String label,
      double? Function(Sample) metric,
    ) => [
      for (final sample in results.samples(operation, mode, label))
        ?metric(sample),
    ];
    String summary(List<double> samples) {
      if (samples.isEmpty) return 'none';
      return median(samples).toStringAsFixed(0);
    }

    for (final mode in Mode.values) {
      stdout.writeln(
        mode == Mode.watch
            ? '## Continuous generation (`serverpod generate --watch`)\n'
            : '## One-shot generation (`serverpod generate`)\n',
      );
      stdout.writeln(
        '| Operation | Metric | Baseline median ms | Candidate median ms | Baseline / candidate | Samples |',
      );
      stdout.writeln('| --- | --- | ---: | ---: | ---: | ---: |');
      for (final operation in results.operations) {
        if (results.samples(operation, mode, 'baseline').isEmpty) continue;
        for (final (name, metric) in metrics) {
          final before = values(operation, mode, 'baseline', metric);
          final after = values(operation, mode, 'candidate', metric);
          final ratio = before.isEmpty || after.isEmpty
              ? '-'
              : _formatRatio(_ratio(median(before), median(after)));
          stdout.writeln(
            '| $operation | $name | ${summary(before)} | ${summary(after)} | $ratio | ${before.length} / ${after.length} |',
          );
        }
      }
      stdout.writeln();
    }

    stdout.writeln(
      'Analysis and generation are the times the CLI prints for `Analyzing changes` and `Generating code`, summed over the cycles one change triggers. The CLI prints whole milliseconds below 100 ms and tenths of a second from there on. `none` for generation means the CLI decided that nothing needed generating; `none` for analysis means the CLI did not analyze the changes as a step of its own, so compare wall clock instead. Wall clock is measured by the runner: for watch, from applying the change until the last cycle it triggered finished, which for a cycle that generated code is when its generation stamp is written, and including file watcher latency; for one-shot, the whole process including CLI startup. A one-shot run on an up-to-date project has neither an analysis nor a generation time. Ratios describe these fixtures on this host, not universal gains; values above 1.00x mean the candidate is faster. A median of 0 ms, which means the CLI printed a time below one millisecond, counts as 1 ms in a ratio. These summaries are descriptive, not statistical confidence tests. All samples are retained below.\n',
    );
    stdout.writeln('| Operation | Mode | Revision | Metric | Samples ms |');
    stdout.writeln('| --- | --- | --- | --- | --- |');
    for (final operation in results.operations) {
      for (final mode in Mode.values) {
        for (final label in ['baseline', 'candidate']) {
          if (results.samples(operation, mode, label).isEmpty) continue;
          for (final (name, metric) in metrics) {
            final samples = values(operation, mode, label, metric);
            stdout.writeln(
              '| $operation | ${mode.title} | $label | $name | ${samples.isEmpty ? 'none' : samples.map((v) => v.toStringAsFixed(0)).join(', ')} |',
            );
          }
        }
      }
    }

    if (results.verificationFailures.any((f) => f.startsWith('candidate'))) {
      stderr.writeln('The candidate did not behave as expected.');
      exitCode = 1;
    }
  } finally {
    if (keep) {
      stderr.writeln('Temporary files kept in ${scratch.path}');
    } else {
      await scratch.delete(recursive: true);
    }
  }
}

/// How many times faster the candidate is than the baseline.
///
/// The CLI prints whole milliseconds, so a median of 0 ms is a time below one
/// millisecond. It counts as 1 ms, the smallest time the CLI can print, which
/// keeps the ratio finite: 900 ms against 0 ms is 900x.
double _ratio(double baselineMs, double candidateMs) =>
    (baselineMs < 1 ? 1 : baselineMs) / (candidateMs < 1 ? 1 : candidateMs);

/// [ratio] for the report: up to two decimals without trailing zeros, so
/// `2x` rather than `2.00x`, and none for ratios of 100 and more.
String _formatRatio(double ratio) {
  if (ratio >= 100) return '${ratio.toStringAsFixed(0)}x';
  final text = ratio
      .toStringAsFixed(2)
      .replaceFirst(RegExp(r'0+$'), '')
      .replaceFirst(RegExp(r'\.$'), '');
  return '${text}x';
}

double? _analysis(Sample sample) => sample.analysisMs;

double? _generation(Sample sample) => sample.generationMs;

double? _wall(Sample sample) => sample.wallMs;
