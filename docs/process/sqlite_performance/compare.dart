// Same-machine comparison. Uses isolated package maps; never switches branches
// or changes the workspace's dependency resolution.
import 'dart:convert';
import 'dart:io';

Future<ProcessResult> command(
  String executable,
  List<String> args, {
  String? cwd,
}) async {
  final result = await Process.run(executable, args, workingDirectory: cwd);
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

double median(List<double> values) {
  final sorted = [...values]..sort();
  final middle = sorted.length ~/ 2;
  return sorted.length.isOdd
      ? sorted[middle]
      : (sorted[middle - 1] + sorted[middle]) / 2;
}

({double winShare, double shift}) compareSamples(
  List<double> baseline,
  List<double> candidate,
) {
  final differences = [
    for (final after in candidate)
      for (final before in baseline) after - before,
  ];
  final wins = differences.fold<double>(
    0,
    (count, difference) =>
        count + (difference < 0 ? 1 : (difference == 0 ? 0.5 : 0)),
  );

  return (winShare: wins / differences.length, shift: median(differences));
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

Future<void> main(List<String> args) async {
  if (args.contains('--help')) {
    stdout.writeln(
      'dart run docs/process/sqlite_performance/compare.dart [options]\n'
      '  --baseline=<git-ref>   Required: revision to compare with the working tree\n'
      '  --package-config=<path>  Default: .dart_tool/package_config.json\n'
      '  --native-assets=<path>   Default: .dart_tool/native_assets.yaml\n'
      '  --quick  Smaller fixtures and one baseline/candidate pair (smoke check only).\n'
      'Requires git, tar, a resolved workspace and built native assets.\n'
      'Prints fresh Markdown results; no historical timing files are inputs.',
    );
    return;
  }
  for (final arg in args) {
    if (arg != '--quick' &&
        ![
          'baseline',
          'package-config',
          'native-assets',
        ].any((name) => arg.startsWith('--$name='))) {
      throw ArgumentError('Unknown argument: $arg');
    }
  }

  final baselineRef = option(args, 'baseline', '');
  if (baselineRef.isEmpty) {
    throw ArgumentError(
      'Provide --baseline=<git-ref> to select the revision to compare. '
      'Use --baseline=HEAD to measure uncommitted database changes.',
    );
  }

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
  final configFile = File(
    option(
      args,
      'package-config',
      '${root.path}/.dart_tool/package_config.json',
    ),
  ).absolute;
  final assetsFile = File(
    option(args, 'native-assets', '${root.path}/.dart_tool/native_assets.yaml'),
  ).absolute;
  if (!assetsFile.existsSync()) {
    throw StateError(
      'Missing ${assetsFile.path}. Build workspace native assets first with:\n'
      'dart run docs/process/sqlite_performance/returning_writes/orm_benchmark.dart --quick',
    );
  }
  final sourceConfig =
      jsonDecode(await configFile.readAsString()) as Map<String, dynamic>;
  final changed = (await command('git', [
    'diff',
    '--name-only',
    baseline,
    '--',
  ])).stdout.toString().split('\n');
  changed.addAll(beforeUntracked.keys);
  final rootsToArchive = <String>{};
  final packageRoots = <String, Uri>{};
  final archivedPackages = <String, String>{};

  for (final raw in sourceConfig['packages'] as List) {
    final package = raw as Map<String, dynamic>;
    final uri = configFile.uri.resolve(package['rootUri'] as String);
    final directoryUri = Directory.fromUri(uri).absolute.uri;
    packageRoots[package['name'] as String] = directoryUri;
    if (!directoryUri.toString().startsWith(root.uri.toString()) ||
        directoryUri == root.uri)
      continue;
    final relative = directoryUri
        .toFilePath()
        .substring(root.path.length + 1)
        .replaceAll('\\', '/')
        .replaceFirst(RegExp(r'/$'), '');
    if (changed.any(
      (file) =>
          file.startsWith('$relative/lib/') || file == '$relative/pubspec.yaml',
    )) {
      rootsToArchive.add(relative);
      archivedPackages[package['name'] as String] = relative;
    }
  }
  if (!archivedPackages.containsKey('serverpod_database')) {
    throw StateError(
      'The baseline must differ in serverpod_database; refusing a misleading comparison.',
    );
  }

  final scratch = await Directory.systemTemp.createTemp(
    'serverpod_sqlite_compare_',
  );
  try {
    final diffFile = File('${scratch.path}/working-tree.diff')
      ..writeAsStringSync(beforeDiff);
    final diffHash = await fileHash(diffFile);
    final baselineRoot = await Directory('${scratch.path}/baseline').create();
    final archive = '${scratch.path}/baseline.tar';
    await command('git', [
      'archive',
      '--format=tar',
      '--output=$archive',
      baseline,
      '--',
      ...rootsToArchive,
    ], cwd: root.path);
    await command('tar', ['-xf', archive, '-C', baselineRoot.path]);

    Future<File> writeConfig(String label) async {
      final config = <String, Object?>{
        'configVersion': 2,
        'packages': [
          for (final raw in sourceConfig['packages'] as List)
            {
              ...raw as Map<String, dynamic>,
              'rootUri':
                  label == 'baseline' &&
                      archivedPackages.containsKey(raw['name'])
                  ? baselineRoot.uri
                        .resolve('${archivedPackages[raw['name']]}/')
                        .toString()
                  : packageRoots[raw['name']].toString(),
            },
        ],
      };
      return File('${scratch.path}/$label-packages.json')
        ..writeAsStringSync(jsonEncode(config));
    }

    final sdkBin = File(Platform.resolvedExecutable).parent;
    final suffix = Platform.isWindows ? '.exe' : '';
    final dart = '${sdkBin.path}/dart$suffix';
    final compiler = '${sdkBin.path}/snapshots/gen_kernel_aot.dart.snapshot';
    final platform =
        '${sdkBin.parent.path}/lib/_internal/vm_platform_strong.dill';
    final script =
        '${root.path}/docs/process/sqlite_performance/returning_writes/orm_benchmark.dart';
    // Compile one captured harness for both revisions, even if an editor saves
    // the untracked benchmark file while the baseline compiler is running.
    final capturedScript = await File(
      script,
    ).copy('${scratch.path}/workload.dart');
    final kernels = <String, String>{};
    final configs = <String, File>{};
    final kernelHashes = <String, String>{};
    final workloadHash = await fileHash(capturedScript);
    final compiledSourceCounts = <String, int>{};

    Uri sourceRoot(String label, String package) =>
        label == 'baseline' && archivedPackages.containsKey(package)
        ? baselineRoot.uri.resolve('${archivedPackages[package]}/')
        : packageRoots[package]!;

    for (final label in ['baseline', 'candidate']) {
      final config = await writeConfig(label);
      configs[label] = config;
      final kernel = '${scratch.path}/$label.dill';
      final depfile = File('${scratch.path}/$label.d');
      stderr.writeln(
        'Compiling $label with the same SDK, dependencies and native assets...',
      );
      await command('${sdkBin.path}/dartaotruntime$suffix', [
        compiler,
        '--platform',
        platform,
        '--packages',
        config.path,
        '--native-assets',
        assetsFile.path,
        '-Ddart.vm.product=true',
        '--output',
        kernel,
        '--depfile',
        depfile.path,
        capturedScript.path,
      ]);
      final inputs = compilerInputs(await depfile.readAsString());
      // This checks compiler-produced dependency evidence, not a package map
      // supplied later at runtime. A wrong compile-time map must fail here.
      const requiredSources = {
        'serverpod_database': [
          'lib/src/adapters/sqlite/database_connection.dart',
          'lib/src/adapters/sqlite/sqlite_pool_manager.dart',
          'lib/src/adapters/sqlite/sqlite_migration_runner.dart',
        ],
        'serverpod_cli': ['lib/src/database/dialects/sqlite.dart'],
      };
      for (final package in requiredSources.entries) {
        for (final source in package.value) {
          final expected = sourceRoot(label, package.key).resolve(source);
          if (!inputs.contains(expected)) {
            throw StateError(
              'Compiler did not consume expected $label source: $expected',
            );
          }
        }
      }
      for (final package in archivedPackages.keys) {
        final wrongRoot = sourceRoot(
          label == 'baseline' ? 'candidate' : 'baseline',
          package,
        ).resolve('lib/').toString();
        if (inputs.any((input) => input.toString().startsWith(wrongRoot))) {
          throw StateError(
            'Compiler mixed revisions for $label package $package',
          );
        }
      }
      compiledSourceCounts[label] = inputs.length;
      kernels[label] = kernel;
      kernelHashes[label] = await fileHash(File(kernel));
    }

    final timings = <String, Map<String, List<double>>>{};
    final environments = <String, Map<String, String>>{};
    final hostObservations = <String>[];
    final quick = args.contains('--quick');
    // Counterbalance ABBA with BAAB so both revisions occupy the outer and
    // inner positions. Process medians below expose residual warmup/load drift.
    for (final label
        in quick
            ? ['baseline', 'candidate']
            : [
                'baseline',
                'candidate',
                'candidate',
                'baseline',
                'candidate',
                'baseline',
                'baseline',
                'candidate',
              ]) {
      stderr.writeln('Running $label${quick ? ' smoke check' : ''}...');
      if (await fileHash(File(kernels[label]!)) != kernelHashes[label]) {
        throw StateError(
          '$label kernel changed after compiler-input verification',
        );
      }
      final result = await command(dart, [
        '--packages=${configs[label]!.path}',
        kernels[label]!,
        if (quick) '--quick',
      ]);
      stderr.write(result.stderr);
      for (final line in const LineSplitter().convert(
        result.stdout.toString(),
      )) {
        final fields = line.split('\t');
        if (fields.first == 'RESULT') {
          final values = fields.skip(2).map(double.parse).toList();
          if (values.isEmpty ||
              values.any((value) => !value.isFinite || value <= 0)) {
            throw StateError('Invalid sample: $line');
          }
          (timings
                  .putIfAbsent(fields[1], () => {})
                  .putIfAbsent(label, () => []))
              .addAll(values);
        } else if (fields.first == 'ENV') {
          (environments.putIfAbsent(label, () => {}))[fields[1]] = fields
              .skip(2)
              .join('\t');
        } else if (line.isNotEmpty) {
          stderr.writeln('$label: $line');
        }
      }
      final environment = environments[label]!;
      hostObservations.add(
        '$label: processors=${environment['processors']}; load before=${environment['load_start']}; load after=${environment['load_end']}',
      );
    }

    for (final field in [
      'dart',
      'sqlite',
      'sqlite_source_id',
      'journal_mode',
      'synchronous',
      'fixture',
      'processors',
    ]) {
      final value = environments['baseline']?[field];
      if (value == null || value != environments['candidate']?[field]) {
        throw StateError('Environment mismatch for $field: $environments');
      }
    }
    final expectedAdapters = {
      'baseline': baselineRoot.uri.resolve(
        '${archivedPackages['serverpod_database']}/lib/src/adapters/sqlite/database_connection.dart',
      ),
      'candidate': packageRoots['serverpod_database']!.resolve(
        'lib/src/adapters/sqlite/database_connection.dart',
      ),
    };
    for (final label in expectedAdapters.keys) {
      if (environments[label]?['adapter'] !=
          expectedAdapters[label].toString()) {
        throw StateError(
          'Unexpected $label adapter: ${environments[label]?['adapter']}',
        );
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
    if (timings.length != 16 ||
        timings.values.any(
          (byRevision) =>
              byRevision['baseline']?.length != (quick ? 3 : 28) ||
              byRevision['candidate']?.length != (quick ? 3 : 28),
        )) {
      throw StateError('Incomplete measurement set: ${timings.keys}');
    }

    stdout.writeln('# SQLite same-machine comparison\n');
    stdout.writeln(
      'Baseline: `$baseline`. Candidate: `$head`${beforeDiff.isEmpty ? '' : ' plus working-tree edits'}.',
    );
    stdout.writeln(
      'Generated: ${DateTime.now().toUtc().toIso8601String()}. Host: ${Platform.operatingSystem} ${Platform.operatingSystemVersion}.',
    );
    stdout.writeln(
      'Dependencies and native assets are identical for both revisions.',
    );
    stdout.writeln('Execution: warmed kernel JIT with dart.vm.product=true.');
    stdout.writeln('Archived packages: ${archivedPackages.keys.join(', ')}.');
    stdout.writeln(
      'Git blob hashes: workload=$workloadHash; tracked diff=$diffHash.',
    );
    stdout.writeln(
      'Untracked Dart source hashes: ${beforeUntracked.entries.map((e) => '${e.key}=${e.value}').join(', ')}.',
    );
    for (final label in ['baseline', 'candidate']) {
      stdout.writeln(
        '$label compiler inputs: ${compiledSourceCounts[label]}; kernel blob=${kernelHashes[label]}.',
      );
    }
    stdout.writeln(
      'Host load is uncontrolled; Linux loadavg is recorded per process below (unavailable on other platforms).',
    );
    for (final observation in hostObservations) {
      stdout.writeln(observation);
    }
    for (final field in [
      'dart',
      'sqlite',
      'sqlite_source_id',
      'journal_mode',
      'synchronous',
      'fixture',
    ]) {
      stdout.writeln('$field: ${environments['candidate']![field]}.');
    }
    stdout.writeln(
      '\n${quick ? '**Smoke check only; do not use these reduced timings as performance evidence.**' : 'Order: baseline, candidate, candidate, baseline, candidate, baseline, baseline, candidate (ABBA + BAAB). Each process warms every operation before sampling.'}\n',
    );
    stdout.writeln(
      '| Operation | Baseline median [min–max] ms | Candidate median [min–max] ms | Baseline / candidate | Candidate pairwise wins | Median pairwise change ms | Sample ranges |',
    );
    stdout.writeln('| --- | ---: | ---: | ---: | ---: | ---: | --- |');
    for (final entry in timings.entries) {
      final baseSamples = [...entry.value['baseline']!]..sort();
      final candidateSamples = [...entry.value['candidate']!]..sort();
      final base = median(baseSamples);
      final candidate = median(candidateSamples);
      final comparison = compareSamples(baseSamples, candidateSamples);
      final overlaps =
          baseSamples.first <= candidateSamples.last &&
          candidateSamples.first <= baseSamples.last;
      String range(List<double> samples) =>
          '${samples.first.toStringAsFixed(3)}–${samples.last.toStringAsFixed(3)}';
      stdout.writeln(
        '| ${entry.key} | ${base.toStringAsFixed(3)} [${range(baseSamples)}] | ${candidate.toStringAsFixed(3)} [${range(candidateSamples)}] | ${(base / candidate).toStringAsFixed(2)}x | ${(100 * comparison.winShare).toStringAsFixed(1)}% | ${comparison.shift.toStringAsFixed(3)} | ${overlaps ? 'overlap' : 'separated'} |',
      );
    }
    stdout.writeln(
      '\nRatios describe these fixtures on this host, not universal gains. Candidate pairwise wins compare every candidate sample against every baseline sample, counting ties as half a win. Median pairwise change is the median of candidate minus baseline differences (Hodges–Lehmann shift); positive values indicate slower execution. Range overlap alone does not establish neutrality or inconclusiveness. These summaries are descriptive, not statistical confidence tests: samples share processes and host conditions. All samples are retained, including outliers. Setup and value checks are outside timing; opening/closing is timed separately.\n',
    );
    stdout.writeln(
      'Process medians and sample groups follow execution order within each revision.\n',
    );
    stdout.writeln(
      '| Operation | Revision | Process medians ms | Samples ms |',
    );
    stdout.writeln('| --- | --- | --- | --- |');
    for (final entry in timings.entries) {
      for (final label in ['baseline', 'candidate']) {
        final samples = entry.value[label]!;
        final perProcess = quick ? 3 : 7;
        final processMedians = [
          for (var i = 0; i < samples.length; i += perProcess)
            median(samples.sublist(i, i + perProcess)).toStringAsFixed(3),
        ];

        stdout.writeln(
          '| ${entry.key} | $label | ${processMedians.join(', ')} | ${samples.map((v) => v.toStringAsFixed(3)).join(', ')} |',
        );
      }
    }
  } finally {
    await scratch.delete(recursive: true);
  }
}
