// The generator workload: project fixtures, the changes applied to them and
// the code that drives `serverpod generate` and reads its timings.
import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:math' as math;

/// One revision of the Serverpod CLI, compiled to a kernel file.
class CliRevision {
  CliRevision({
    required this.label,
    required this.dart,
    required this.packageConfig,
    required this.kernel,
    required this.environment,
  });

  /// `baseline` or `candidate`.
  final String label;
  final String dart;
  final String packageConfig;
  final String kernel;
  final Map<String, String> environment;

  List<String> arguments(List<String> cliArguments) => [
    '--packages=$packageConfig',
    kernel,
    '--no-analytics',
    ...cliArguments,
  ];
}

/// How the generator was run for a measurement.
enum Mode {
  watch('watch'),
  oneShot('one-shot');

  const Mode(this.title);

  final String title;
}

/// The timings of one generator run.
class Sample {
  Sample({
    required this.analysisMs,
    required this.generationMs,
    required this.wallMs,
    this.upToDate = false,
  });

  /// `Analyzing changes` time printed by the CLI, `null` when the CLI did not
  /// analyze the changes as a step of its own.
  final double? analysisMs;

  /// `Generating code` time printed by the CLI, `null` when the CLI decided
  /// that nothing needed generating.
  final double? generationMs;

  /// Watch: from applying the change until the last cycle it triggered
  /// finished, including writing the generation stamp. One-shot: the whole
  /// `serverpod generate` process.
  final double wallMs;

  /// Whether the CLI reported that the generated code was already up to date.
  final bool upToDate;
}

/// Samples of every operation, by mode and revision label.
class Results {
  /// Operation titles in the order they were first measured.
  final operations = <String>[];
  final _samples = <String, List<Sample>>{};
  final _expected = <String, int>{};
  final verificationFailures = <String>[];

  /// Things that limit how a measurement can be read, each reported once.
  final notes = <String>{};

  static String _key(String operation, Mode mode, [String? label]) =>
      '$operation\u0000${mode.name}${label == null ? '' : '\u0000$label'}';

  /// Declares that [operation] must end up with [count] samples per revision.
  void expect(String operation, Mode mode, int count) =>
      _expected[_key(operation, mode)] = count;

  void add(String operation, Mode mode, String label, Sample sample) {
    if (!operations.contains(operation)) operations.add(operation);
    _samples.putIfAbsent(_key(operation, mode, label), () => []).add(sample);
  }

  List<Sample> samples(String operation, Mode mode, String label) =>
      _samples[_key(operation, mode, label)] ?? const [];

  /// Operations whose sample count for one of [labels] is not the expected
  /// one, including operations that were measured without being expected.
  List<String> sampleCountProblems(List<String> labels) {
    final problems = <String>[];
    final measured = <String>{
      for (final key in _samples.keys)
        key.substring(0, key.lastIndexOf('\u0000')),
    };
    for (final key in {..._expected.keys, ...measured}) {
      final parts = key.split('\u0000');
      final mode = Mode.values.byName(parts[1]);
      final expected = _expected[key];
      for (final label in labels) {
        final actual = samples(parts[0], mode, label).length;
        if (actual != expected) {
          problems.add(
            '${parts[0]} (${mode.title}), $label: $actual samples, '
            'expected ${expected ?? 'none'}',
          );
        }
      }
    }
    return problems;
  }
}

/// Sizes of the workload.
class WorkloadOptions {
  WorkloadOptions({
    required this.scale,
    required this.repeats,
    required this.editSamples,
    required this.settle,
    required this.stepTimeout,
  });

  /// Files added at once, and future calls, endpoints and models (each) in
  /// the large project.
  final int scale;

  /// Times the whole workload is run for each revision.
  final int repeats;

  /// Times each edit is repeated in one watch session.
  final int editSamples;

  /// Quiet time after a cycle before a watch step counts as finished.
  final Duration settle;

  /// Longest time to wait for one generator run.
  final Duration stepTimeout;
}

/// Thrown when a measurement cannot be completed.
class WorkloadFailure implements Exception {
  WorkloadFailure(this.message);

  final String message;

  @override
  String toString() => message;
}

/// The kinds of source files the workload writes.
enum SourceKind {
  plainDart('plain Dart files', ['bench_plain']),
  futureCall('future calls', ['bench_future_calls']),
  endpoint('endpoints', ['bench_endpoints']),
  model('YAML models', ['models', 'bench_models']);

  const SourceKind(this.title, this.directory);

  final String title;

  /// Directory of the files, below `lib/src`.
  final List<String> directory;
}

/// A Serverpod project the workload changes.
class BenchProject {
  BenchProject({
    required this.serverDir,
    required this.clientDir,
    this.referencesModels = false,
  });

  final Directory serverDir;
  final Directory clientDir;

  /// Whether the endpoints and future calls of this project use the YAML
  /// models as parameter and return types. Requires the models to be there.
  final bool referencesModels;

  /// The members added to each edited file so far, by file path.
  final _extras = <String, List<int>>{};

  /// Number of edits made so far, so every edit adds a new name.
  int _edits = 0;

  String get _src => _join([serverDir.path, 'lib', 'src']);

  String get _generated => _join([_src, 'generated']);

  String get _clientGenerated =>
      _join([clientDir.path, 'lib', 'src', 'protocol']);

  /// The record the CLI writes at the very end of a successful generation.
  File get stampFile => File(
    _join([serverDir.path, '.dart_tool', 'serverpod', 'generation.stamp']),
  );

  Directory directoryOf(SourceKind kind) =>
      Directory(_join([_src, ...kind.directory]));

  File fileOf(SourceKind kind, int index) => File(
    _join([directoryOf(kind).path, _fileName(kind, index)]),
  );

  static String _fileName(SourceKind kind, int index) => switch (kind) {
    SourceKind.plainDart => 'bench_plain_$index.dart',
    SourceKind.futureCall => 'bench_${index}_future_call.dart',
    SourceKind.endpoint => 'bench_${index}_endpoint.dart',
    SourceKind.model => 'bench_model_$index.spy.yaml',
  };

  /// Future calls with an even index take parameters besides the session, the
  /// ones with an odd index do not.
  static bool futureCallHasParameters(int index) => index.isEven;

  /// The source of file [index] of [kind] with [extras] extra members.
  ///
  /// Every model has a field of the previous model's type, so the models form
  /// one chain of dependencies. With [referencesModels], endpoints and future
  /// calls take and return the model with their own index.
  static String source(
    SourceKind kind,
    int index, {
    List<int> extras = const [],
    bool referencesModels = false,
  }) {
    const protocolImport = "\nimport '../generated/protocol.dart';\n";
    switch (kind) {
      case SourceKind.plainDart:
        return '''
/// Helper $index.
class BenchPlain$index {
  int value = $index;

  int next() => value + 1;
${[for (final extra in extras) '\n  int extra$extra() => value + $extra;\n'].join()}}
''';
      case SourceKind.futureCall:
        final hasParameters = futureCallHasParameters(index);
        final usesModel = hasParameters && referencesModels;
        final parameters = !hasParameters
            ? 'Session session'
            : usesModel
            ? 'Session session, BenchModel$index model, int count'
            : 'Session session, String name, int count';
        return '''
import 'package:serverpod/serverpod.dart';
${usesModel ? protocolImport : ''}
class Bench${index}FutureCall extends FutureCall {
  Future<void> run($parameters) async {
    session.log('Run $index');
  }
${[for (final extra in extras) '\n  Future<void> extra$extra($parameters) async {}\n'].join()}}
''';
      case SourceKind.endpoint:
        final method = referencesModels
            ? '''
  Future<BenchModel$index> echo(Session session, BenchModel$index model) async {
    return model;
  }'''
            : '''
  Future<String> hello(Session session, String name) async {
    return 'Hello \$name';
  }''';
        return '''
import 'package:serverpod/serverpod.dart';
${referencesModels ? protocolImport : ''}
class Bench${index}Endpoint extends Endpoint {
$method
${[for (final extra in extras) '\n  Future<int> extra$extra(Session session) async => $extra;\n'].join()}}
''';
      case SourceKind.model:
        return '''
class: BenchModel$index
fields:
  name: String
  count: int
  createdAt: DateTime?
${index > 0 ? '  previous: BenchModel${index - 1}?\n' : ''}${[for (final extra in extras) '  extra$extra: int?\n'].join()}''';
    }
  }

  /// Writes [count] files of [kind] straight into the project.
  void write(SourceKind kind, int count) {
    final directory = directoryOf(kind)..createSync(recursive: true);
    _writeFiles(directory, kind, count);
  }

  /// Adds [count] files of [kind] to the project in one rename, so a file
  /// watcher sees them arrive together. [staging] must be outside of `lib` and
  /// on the same file system.
  void addAtOnce(SourceKind kind, int count, Directory staging) {
    if (staging.existsSync()) staging.deleteSync(recursive: true);
    staging.createSync(recursive: true);
    _writeFiles(staging, kind, count);

    final target = directoryOf(kind);
    target.parent.createSync(recursive: true);
    staging.renameSync(target.path);
  }

  void _writeFiles(Directory directory, SourceKind kind, int count) {
    for (var i = 0; i < count; i++) {
      File(_join([directory.path, _fileName(kind, i)])).writeAsStringSync(
        source(kind, i, referencesModels: referencesModels),
      );
    }
  }

  /// Rewrites file [index] of [kind] with one more member than it has, keeping
  /// the members earlier edits added, and returns the number that identifies
  /// the new member.
  int edit(SourceKind kind, int index) {
    final file = fileOf(kind, index);
    final extras = _extras.putIfAbsent(file.path, () => [])..add(++_edits);
    file.writeAsStringSync(
      source(kind, index, extras: extras, referencesModels: referencesModels),
    );
    return extras.last;
  }

  /// Writes file [index] of [kind] again with the content it already has, as
  /// a save without edits does.
  void saveUnchanged(SourceKind kind, int index) {
    final file = fileOf(kind, index);
    file.writeAsBytesSync(file.readAsBytesSync());
  }

  /// Removes everything a previous generation left behind, so the next one
  /// starts from sources alone.
  void removeGeneratedOutput() {
    for (final directory in [
      Directory(_generated),
      Directory(_clientGenerated),
    ]) {
      if (directory.existsSync()) directory.deleteSync(recursive: true);
    }
    if (stampFile.existsSync()) stampFile.deleteSync();
  }

  String get _serverPackage =>
      serverDir.uri.pathSegments.lastWhere((segment) => segment.isNotEmpty);

  String get _clientPackage =>
      clientDir.uri.pathSegments.lastWhere((segment) => segment.isNotEmpty);

  List<int> _extrasOf(SourceKind kind, int index) =>
      _extras[fileOf(kind, index).path] ?? const [];

  /// The method every endpoint of this project has besides added members.
  String get _endpointMethod => referencesModels ? 'echo' : 'hello';

  /// Returns what is wrong with the generated server and client code for a
  /// project with files 0 to count - 1 of each kind, or `null` when nothing
  /// is. Always covers the generation stamp and the code generated for the
  /// model and endpoint a newly created project comes with.
  ///
  /// This reads the generated files as text. [analyzeGenerated] checks that
  /// the generated code compiles and has the members the fixtures call for.
  String? verifyGenerated({
    int futureCalls = 0,
    int endpoints = 0,
    int models = 0,
  }) {
    final problems = <String>[];

    String? read(String directory, String name) {
      final file = File(_join([directory, name]));
      if (!file.existsSync()) {
        problems.add('${file.path} does not exist');
        return null;
      }
      return file.readAsStringSync();
    }

    final stampProblem = _stampProblem();
    if (stampProblem != null) problems.add(stampProblem);
    for (final directory in [_generated, _clientGenerated]) {
      final protocol = read(directory, 'protocol.dart');
      if (protocol != null && !protocol.contains('class Protocol')) {
        problems.add('${_join([directory, 'protocol.dart'])} has no Protocol');
      }
    }

    final serverEndpoints = read(_generated, 'endpoints.dart');
    final connectors = serverEndpoints == null
        ? const <String, String>{}
        : _connectorBlocks(serverEndpoints);
    final clientEndpoints = read(_clientGenerated, 'client.dart');
    final clientClasses = clientEndpoints == null
        ? const <String, String>{}
        : _classBlocks(clientEndpoints);

    /// Checks the server registration and connector and the client class of
    /// the endpoint [name], declared by [className], with [methods].
    void checkEndpoint(String name, String className, List<String> methods) {
      if (serverEndpoints != null) {
        final registered = RegExp(
          "'$name':\\s*[\\w.]*\\b$className\\(\\)",
        ).hasMatch(serverEndpoints);
        if (!registered) problems.add('endpoints.dart does not register $name');
        final connector = connectors[name];
        for (final method in methods) {
          if (connector == null || !connector.contains("'$method':")) {
            problems.add('endpoints.dart has no connector for $name.$method');
          }
        }
      }
      if (clientEndpoints != null) {
        final clientClass =
            clientClasses['Endpoint${name[0].toUpperCase()}${name.substring(1)}'];
        for (final method in methods) {
          if (clientClass == null || !clientClass.contains(' $method(')) {
            problems.add('client.dart has no method $name.$method');
          }
        }
      }
    }

    // What a newly created project declares.
    checkEndpoint('greeting', 'GreetingEndpoint', ['hello']);
    for (final (side, directory) in [
      ('server', _generated),
      ('client', _clientGenerated),
    ]) {
      final greeting = _filesByNormalizedName(
        Directory(directory),
      )['greeting.dart'];
      final source = greeting?.readAsStringSync() ?? '';
      for (final field in ['message', 'author', 'timestamp']) {
        if (!RegExp('\\b$field;').hasMatch(source)) {
          problems.add('the $side class Greeting has no field $field');
        }
      }
    }

    if (futureCalls > 0) {
      final generated = read(_generated, 'future_calls.dart');
      final parameterModels = _filesByNormalizedName(
        Directory(_join([_generated, 'future_calls_generated_models'])),
      );
      for (var i = 0; generated != null && i < futureCalls; i++) {
        final methods = [
          'Run',
          for (final extra in _extrasOf(SourceKind.futureCall, i))
            'Extra$extra',
        ];
        for (final method in methods) {
          // The registration of the call and the class that invokes it.
          final name = 'Bench$i${method}FutureCall';
          if (!generated.contains("'$name': $name()") ||
              !generated.contains('class $name')) {
            problems.add('future_calls.dart does not register $name');
          }
          if (!futureCallHasParameters(i)) continue;
          final problem = _parameterModelProblem(parameterModels, i, method);
          if (problem != null) problems.add(problem);
        }
      }
    }

    for (var i = 0; i < endpoints; i++) {
      checkEndpoint('bench$i', 'Bench${i}Endpoint', [
        _endpointMethod,
        for (final extra in _extrasOf(SourceKind.endpoint, i)) 'extra$extra',
      ]);
    }

    if (models > 0) {
      final server = _filesByNormalizedName(Directory(_generated));
      final client = _filesByNormalizedName(Directory(_clientGenerated));
      for (var i = 0; i < models; i++) {
        final declaration = RegExp('class BenchModel$i\\b');
        final fields = [
          'name',
          'count',
          'createdAt',
          if (i > 0) 'previous',
          for (final extra in _extrasOf(SourceKind.model, i)) 'extra$extra',
        ];
        for (final (side, files) in [('server', server), ('client', client)]) {
          final source = files['benchmodel$i.dart']?.readAsStringSync();
          if (source == null || !source.contains(declaration)) {
            problems.add('no generated $side class BenchModel$i');
            continue;
          }
          for (final field in fields) {
            if (!RegExp('\\b$field;').hasMatch(source)) {
              problems.add('the $side class BenchModel$i has no field $field');
            }
          }
        }
      }
    }

    return _summary(problems);
  }

  /// Returns what is missing from the generated code for member [extra] added
  /// to file [index] of [kind], or `null` when it is there.
  String? verifyEdit(SourceKind kind, int index, int extra) {
    String? expectIn(String directory, String name) {
      final file = File(_join([directory, name]));
      if (!file.existsSync()) return '${file.path} does not exist';
      return file.readAsStringSync().contains('extra$extra')
          ? null
          : '${file.path} does not contain extra$extra';
    }

    switch (kind) {
      case SourceKind.plainDart:
        return null;
      case SourceKind.endpoint:
        return expectIn(_generated, 'endpoints.dart') ??
            expectIn(_clientGenerated, 'client.dart');
      case SourceKind.model:
        for (final directory in [_generated, _clientGenerated]) {
          final model = _filesByNormalizedName(
            Directory(directory),
          )['benchmodel$index.dart'];
          if (model == null) {
            return 'no generated file for BenchModel$index in $directory';
          }
          if (!RegExp('\\bextra$extra;').hasMatch(model.readAsStringSync())) {
            return '${model.path} has no field extra$extra';
          }
        }
        return null;
      case SourceKind.futureCall:
        final missing = expectIn(_generated, 'future_calls.dart');
        if (missing != null || !futureCallHasParameters(index)) return missing;

        // The parameters of the new method need a generated model of their own.
        return _parameterModelProblem(
          _filesByNormalizedName(
            Directory(_join([_generated, 'future_calls_generated_models'])),
          ),
          index,
          'Extra$extra',
        );
    }
  }

  /// Checks that the generated code compiles and offers what the fixtures
  /// declare, by analyzing it together with code that uses all of it: every
  /// model with its fields, every endpoint method through the client, and
  /// every future call through its dispatcher. Runs [dart] and takes a few
  /// seconds, so it must stay outside of any measured interval.
  ///
  /// Returns what is wrong, or `null` when nothing is.
  Future<String?> analyzeGenerated(
    String dart, {
    int futureCalls = 0,
    int endpoints = 0,
    int models = 0,
  }) async {
    // Outside of `lib`, so neither the generator nor a file watcher sees them.
    final serverUser = File(
      _join([serverDir.path, 'bench_verify_server.dart']),
    );
    final clientUser = File(
      _join([clientDir.path, 'bench_verify_client.dart']),
    );
    serverUser.writeAsStringSync(
      _serverUser(futureCalls: futureCalls, models: models),
    );
    clientUser.writeAsStringSync(
      _clientUser(endpoints: endpoints, models: models),
    );
    try {
      final result = await Process.run(dart, [
        'analyze',
        '--no-fatal-warnings',
        _generated,
        _clientGenerated,
        serverUser.path,
        clientUser.path,
      ], workingDirectory: serverDir.parent.path);
      if (result.exitCode == 0) return null;

      final errors = const LineSplitter()
          .convert('${result.stdout}\n${result.stderr}')
          .map((line) => line.trim())
          .where((line) => line.startsWith('error'))
          .toList();
      return 'the generated code does not analyze: '
          '${_summary(errors) ?? 'dart analyze exited with ${result.exitCode}'}';
    } finally {
      for (final file in [serverUser, clientUser]) {
        if (file.existsSync()) file.deleteSync();
      }
    }
  }

  /// Statements that create every model with all of its fields.
  String _modelStatements(int models) {
    final out = StringBuffer();
    for (var i = 0; i < models; i++) {
      out.writeln(
        '  final model$i = BenchModel$i(name: \'\', count: 0, createdAt: null'
        '${i > 0 ? ', previous: model${i - 1}' : ''});',
      );
      for (final extra in _extrasOf(SourceKind.model, i)) {
        out.writeln('  final int? model${i}Extra$extra = model$i.extra$extra;');
      }
    }
    return out.toString();
  }

  /// Server code that uses the generated models and schedules every future
  /// call with the arguments its source declares.
  String _serverUser({required int futureCalls, required int models}) {
    // The CLI only generates the future call dispatch for a project that
    // declares future calls.
    final hasFutureCalls = futureCalls > 0;
    final out = StringBuffer('''
// ignore_for_file: unused_local_variable, unawaited_futures
import 'package:$_serverPackage/src/generated/endpoints.dart';
${hasFutureCalls ? "import 'package:$_serverPackage/src/generated/future_calls.dart';\n" : ''}import 'package:$_serverPackage/src/generated/protocol.dart';

void verify() {
  Endpoints();
  Protocol();
  final greeting = Greeting(message: '', author: '', timestamp: DateTime.now());
''');
    out.write(_modelStatements(models));
    if (hasFutureCalls) {
      out.writeln(
        '  final calls = FutureCalls().callWithDelay(Duration.zero);',
      );
    }
    for (var i = 0; i < futureCalls; i++) {
      final arguments = !futureCallHasParameters(i)
          ? ''
          : referencesModels
          ? 'model$i, 0'
          : "'', 0";
      out.writeln('  calls.bench$i.run($arguments);');
      for (final extra in _extrasOf(SourceKind.futureCall, i)) {
        out.writeln('  calls.bench$i.extra$extra($arguments);');
      }
    }
    out.writeln('}');
    return out.toString();
  }

  /// Client code that uses the generated models and calls every endpoint
  /// method with the types its source declares.
  String _clientUser({required int endpoints, required int models}) {
    final out = StringBuffer('''
// ignore_for_file: unused_local_variable
import 'package:$_clientPackage/$_clientPackage.dart';

Future<void> verify(Client client) async {
  final Greeting greeting = await client.greeting.hello('');
  final String message = greeting.message;
  final String author = greeting.author;
  final DateTime timestamp = greeting.timestamp;
''');
    out.write(_modelStatements(models));
    for (var i = 0; i < endpoints; i++) {
      out.writeln(
        referencesModels
            ? '  final BenchModel$i echoed$i = '
                  'await client.bench$i.echo(model$i);'
            : "  final String hello$i = await client.bench$i.hello('');",
      );
      for (final extra in _extrasOf(SourceKind.endpoint, i)) {
        out.writeln(
          '  final int endpoint${i}Extra$extra = '
          'await client.bench$i.extra$extra();',
        );
      }
    }
    out.writeln('}');
    return out.toString();
  }

  /// What is wrong with the generation stamp, or `null` when nothing is.
  String? _stampProblem() {
    if (!stampFile.existsSync()) return 'no generation stamp';
    final lines = const LineSplitter().convert(stampFile.readAsStringSync());
    if (lines.length < 3 ||
        lines[0].trim().isEmpty ||
        !RegExp(r'^[0-9a-f]+$').hasMatch(lines[1].trim())) {
      return 'the generation stamp is malformed';
    }
    final files = [
      for (final line in lines.skip(2))
        if (line.isNotEmpty)
          File(line).isAbsolute ? line : _join([serverDir.path, line]),
    ];
    final missing = files.where((file) => !File(file).existsSync()).length;
    if (missing > 0) {
      return 'the generation stamp lists $missing files that do not exist';
    }
    return files.any((file) => file.endsWith('protocol.dart'))
        ? null
        : 'the generation stamp does not list the protocol';
  }

  /// What is wrong with the model generated for the parameters of [method] of
  /// future call [index], or `null` when nothing is.
  String? _parameterModelProblem(
    Map<String, File> parameterModels,
    int index,
    String method,
  ) {
    final className = 'Bench${index}FutureCall${method}Model';
    final source = parameterModels['${className.toLowerCase()}.dart']
        ?.readAsStringSync();
    if (source == null || !source.contains('class $className')) {
      return 'no generated parameter model $className';
    }
    for (final field in [referencesModels ? 'model' : 'name', 'count']) {
      if (!RegExp('\\b$field;').hasMatch(source)) {
        return 'the parameter model $className has no field $field';
      }
    }
    return null;
  }

  /// The connector of every endpoint in the generated `endpoints.dart`, by
  /// endpoint name.
  static Map<String, String> _connectorBlocks(String source) => {
    for (final block in source.split("connectors['").skip(1))
      block.substring(0, block.indexOf("'")): block,
  };

  /// The source of every top-level class in [source], by class name.
  static Map<String, String> _classBlocks(String source) => {
    for (final block
        in source.split(RegExp(r'^class ', multiLine: true)).skip(1))
      block.substring(0, block.indexOf(RegExp(r'\W'))): block,
  };

  static String? _summary(List<String> problems) {
    if (problems.isEmpty) return null;
    return '${problems.take(3).join('; ')}'
        '${problems.length > 3 ? ' and ${problems.length - 3} more' : ''}';
  }

  /// The files below [directory] by their name without underscores, which is
  /// how generated file names are matched whatever casing rule produced them.
  static Map<String, File> _filesByNormalizedName(Directory directory) {
    if (!directory.existsSync()) return const {};
    return {
      for (final file in directory.listSync(recursive: true).whereType<File>())
        file.uri.pathSegments.last.replaceAll('_', ''): file,
    };
  }
}

/// Runs the whole workload for both revisions and returns the samples.
///
/// [template] is the root of a newly created project named [projectName]. It
/// is copied for every measurement and never changed. [scratch] holds the
/// copies.
Future<Results> runWorkload({
  required CliRevision baseline,
  required CliRevision candidate,
  required Directory template,
  required String projectName,
  required Directory scratch,
  required WorkloadOptions options,
  required void Function(String) log,
}) async {
  final results = Results();
  final revisions = [baseline, candidate];
  var projectCount = 0;

  /// A fresh copy of the newly created project without the generated code and
  /// generation record that creating it left behind.
  BenchProject cleanProject({bool referencesModels = false}) {
    final root = Directory(_join([scratch.path, 'project_${projectCount++}']));
    _copyDirectory(template, root);
    return BenchProject(
      serverDir: Directory(_join([root.path, '${projectName}_server'])),
      clientDir: Directory(_join([root.path, '${projectName}_client'])),
      referencesModels: referencesModels,
    )..removeGeneratedOutput();
  }

  void deleteProject(BenchProject project) =>
      project.serverDir.parent.deleteSync(recursive: true);

  final staging = Directory(_join([scratch.path, 'staging']));

  void verify(CliRevision cli, String operation, Mode mode, String? problem) {
    if (problem != null) {
      results.verificationFailures.add(
        '${cli.label}, $operation (${mode.title}): $problem',
      );
    }
  }

  /// The problem with [sample] when its change must not generate anything.
  String? expectNoGeneration(Sample sample) => sample.generationMs == null
      ? null
      : 'generated code although the change needs none';

  const firstRunClean = 'First run on a clean project';
  const generateLarge = 'Generate the large project from scratch';
  const upToDateLarge = 'Run on the up-to-date large project';
  const firstRunLarge = 'First run on the up-to-date large project';
  const saveAfterChange =
      'Save an unchanged plain Dart file after a real change in the large '
      'project';
  const saveAgain =
      'Save an unchanged plain Dart file again in the large project';
  const regenerate = 'Regenerate the large project after an edit';
  String addTitle(SourceKind kind) =>
      'Add ${options.scale} ${kind.title} to a clean project';
  String editTitle(String title) => 'Edit $title in the large project';

  const addedKinds = [
    SourceKind.plainDart,
    SourceKind.futureCall,
    SourceKind.endpoint,
    SourceKind.model,
  ];

  /// The edits made to the large project, in the order they are measured.
  final edits = <({String title, SourceKind kind, int index})>[
    (
      title: 'a future call without parameters',
      kind: SourceKind.futureCall,
      index: 1,
    ),
    (
      title: 'a future call with parameters',
      kind: SourceKind.futureCall,
      index: 0,
    ),
    (title: 'an endpoint', kind: SourceKind.endpoint, index: 0),
    (title: 'a YAML model', kind: SourceKind.model, index: 0),
    (title: 'a plain Dart file', kind: SourceKind.plainDart, index: 0),
  ];

  // Every operation and how many samples each revision must end up with.
  final editCount = options.repeats * options.editSamples;
  for (final mode in Mode.values) {
    results.expect(firstRunClean, mode, options.repeats * addedKinds.length);
    for (final kind in addedKinds) {
      results.expect(addTitle(kind), mode, options.repeats);
    }
  }
  results.expect(generateLarge, Mode.oneShot, options.repeats);
  results.expect(upToDateLarge, Mode.oneShot, options.repeats);
  results.expect(firstRunLarge, Mode.watch, options.repeats);
  for (final edit in edits) {
    results.expect(editTitle(edit.title), Mode.watch, editCount);
  }
  results.expect(saveAfterChange, Mode.watch, editCount);
  results.expect(saveAgain, Mode.watch, editCount);
  results.expect(regenerate, Mode.oneShot, options.repeats);

  /// Checks the generated code of [project] for the given fixture, as text
  /// and by analyzing it. Takes seconds, so only call it between measurements.
  Future<String?> verifyCompletely(
    CliRevision cli,
    BenchProject project, {
    int futureCalls = 0,
    int endpoints = 0,
    int models = 0,
  }) async =>
      project.verifyGenerated(
        futureCalls: futureCalls,
        endpoints: endpoints,
        models: models,
      ) ??
      await project.analyzeGenerated(
        cli.dart,
        futureCalls: futureCalls,
        endpoints: endpoints,
        models: models,
      );

  /// The generated code a project must have after [count] files of [kind]
  /// were added to a clean project.
  Future<String?> verifyAdded(
    CliRevision cli,
    BenchProject project,
    SourceKind kind,
    int count,
  ) => verifyCompletely(
    cli,
    project,
    futureCalls: kind == SourceKind.futureCall ? count : 0,
    endpoints: kind == SourceKind.endpoint ? count : 0,
    models: kind == SourceKind.model ? count : 0,
  );

  /// Adds [options.scale] files of [kind] to a clean project at once.
  Future<void> addScenario(CliRevision cli, SourceKind kind) async {
    final count = options.scale;
    final operation = addTitle(kind);
    log('${cli.label}: $operation');

    // Watch: the first run generates the clean project, then the files arrive.
    var project = cleanProject();
    var watch = await WatchSession.start(cli, project, options, results);
    try {
      results.add(
        firstRunClean,
        Mode.watch,
        cli.label,
        await watch.waitForFirstRun(),
      );
      verify(cli, firstRunClean, Mode.watch, project.verifyGenerated());
      await watch.waitUntilWatching();
      final sample = await watch.measure(
        () => project.addAtOnce(kind, count, staging),
      );
      results.add(operation, Mode.watch, cli.label, sample);
      verify(
        cli,
        operation,
        Mode.watch,
        kind == SourceKind.plainDart
            ? expectNoGeneration(sample)
            : await verifyAdded(cli, project, kind, count),
      );
    } finally {
      await watch.stop();
    }
    deleteProject(project);

    // One-shot: generate the clean project, add the files, generate again.
    project = cleanProject();
    results.add(
      firstRunClean,
      Mode.oneShot,
      cli.label,
      await runOneShot(cli, project, options),
    );
    verify(cli, firstRunClean, Mode.oneShot, project.verifyGenerated());
    project.write(kind, count);
    results.add(
      operation,
      Mode.oneShot,
      cli.label,
      await runOneShot(cli, project, options),
    );
    verify(
      cli,
      operation,
      Mode.oneShot,
      await verifyAdded(cli, project, kind, count),
    );
    deleteProject(project);
  }

  /// Builds the large project and edits single files of it.
  Future<void> largeProjectScenarios(CliRevision cli) async {
    final scale = options.scale;
    Future<String?> verifyLarge(BenchProject project) => verifyCompletely(
      cli,
      project,
      futureCalls: scale,
      endpoints: scale,
      models: scale,
    );

    // Built for every repeat, so generating it from scratch is sampled as
    // often as everything else.
    log('${cli.label}: building the large project');
    final project = cleanProject(referencesModels: true);
    project.write(SourceKind.futureCall, scale);
    project.write(SourceKind.endpoint, scale);
    project.write(SourceKind.model, scale);
    project.write(SourceKind.plainDart, 2);
    results.add(
      generateLarge,
      Mode.oneShot,
      cli.label,
      await runOneShot(cli, project, options),
    );
    verify(cli, generateLarge, Mode.oneShot, await verifyLarge(project));

    // One-shot with nothing to do.
    final upToDate = await runOneShot(cli, project, options);
    results.add(upToDateLarge, Mode.oneShot, cli.label, upToDate);
    verify(
      cli,
      upToDateLarge,
      Mode.oneShot,
      // Nothing was written, so the checks that read the code as text do.
      upToDate.upToDate
          ? project.verifyGenerated(
              futureCalls: scale,
              endpoints: scale,
              models: scale,
            )
          : 'ran the generator although nothing changed',
    );

    // Watch: one session, every edit repeated in it.
    log('${cli.label}: editing the large project with --watch');
    final watch = await WatchSession.start(cli, project, options, results);
    try {
      final firstRun = await watch.waitForFirstRun();
      results.add(firstRunLarge, Mode.watch, cli.label, firstRun);
      verify(cli, firstRunLarge, Mode.watch, expectNoGeneration(firstRun));
      await watch.waitUntilWatching();

      for (final edit in edits) {
        for (var i = 0; i < options.editSamples; i++) {
          late int extra;
          final sample = await watch.measure(
            () => extra = project.edit(edit.kind, edit.index),
          );
          results.add(editTitle(edit.title), Mode.watch, cli.label, sample);
          verify(
            cli,
            editTitle(edit.title),
            Mode.watch,
            edit.kind == SourceKind.plainDart
                ? expectNoGeneration(sample)
                : project.verifyEdit(edit.kind, edit.index, extra),
          );
        }
      }

      // Saves that change nothing. A real change to another file comes first,
      // because it makes the CLI forget what it knew about unchanged files. The
      // first save after it is examined again, the second one need not be.
      for (var i = 0; i < options.editSamples; i++) {
        await watch.measure(() => project.edit(SourceKind.plainDart, 0));
        for (final operation in [saveAfterChange, saveAgain]) {
          final sample = await watch.measure(
            () => project.saveUnchanged(SourceKind.plainDart, 1),
          );
          results.add(operation, Mode.watch, cli.label, sample);
          verify(cli, operation, Mode.watch, expectNoGeneration(sample));
        }
      }
    } finally {
      await watch.stop();
    }
    verify(
      cli,
      'Edits in the large project',
      Mode.watch,
      await verifyLarge(project),
    );

    // One-shot: a single edit. A one-shot run generates the whole project
    // whatever changed, so further edits would measure the same path again.
    // The future call with parameters has the most generated code to verify.
    log('${cli.label}: regenerating the large project after an edit');
    final extra = project.edit(SourceKind.futureCall, 0);
    results.add(
      regenerate,
      Mode.oneShot,
      cli.label,
      await runOneShot(cli, project, options),
    );
    verify(
      cli,
      regenerate,
      Mode.oneShot,
      project.verifyEdit(SourceKind.futureCall, 0, extra) ??
          await verifyLarge(project),
    );
    deleteProject(project);
  }

  final scenarios = <Future<void> Function(CliRevision)>[
    for (final kind in addedKinds) (cli) => addScenario(cli, kind),
    largeProjectScenarios,
  ];

  for (var repeat = 0; repeat < options.repeats; repeat++) {
    for (final (index, scenario) in scenarios.indexed) {
      // Alternate which revision goes first, so neither always runs on the
      // warmer or the busier machine.
      final order = (repeat + index).isEven ? revisions : revisions.reversed;
      for (final cli in order) {
        await scenario(cli);
      }
    }
  }

  return results;
}

final _ansi = RegExp(r'\x1B\[[0-9;]*[A-Za-z]');

/// A finished progress line, as printed to a pipe (`Analyzing changes done.
/// (12ms)`) or to a terminal (`✓ Analyzing changes (12ms)`).
final _finished = RegExp(
  r'^(?:(✓|✗) )?(Analyzing changes|Generating code)(?: (done|failed)\.)? '
  r'\((\d+(?:\.\d+)?)(ms|s)\)$',
);
final _started = RegExp(r'(Analyzing changes|Generating code)\.\.\.$');
const _upToDateMessage = 'Generated code is up to date';

/// The progress lines of one generator run, summed over its cycles.
class _Timings {
  int cycles = 0;
  double? analysisMs;
  double? generationMs;
  bool failed = false;

  /// Whether an analysis or a generation finished. A full one-shot run may
  /// generate without analyzing the changes as a step of its own.
  bool get ranAnything => cycles > 0 || generationMs != null;

  /// Reads [rawLine] and returns whether it was a finished progress line.
  bool read(String rawLine) {
    final match = _finished.firstMatch(rawLine.replaceAll(_ansi, '').trim());
    if (match == null) return false;

    final value = double.parse(match.group(4)!);
    final milliseconds = match.group(5) == 's' ? value * 1000 : value;
    if (match.group(2) == 'Analyzing changes') {
      cycles++;
      analysisMs = (analysisMs ?? 0) + milliseconds;
    } else {
      generationMs = (generationMs ?? 0) + milliseconds;
    }
    if (match.group(1) == '✗' || match.group(3) == 'failed') failed = true;
    return true;
  }
}

/// Runs `serverpod generate` once on [project] and returns its timings.
///
/// A run that reports the generated code as up to date is a completed run
/// without analysis or generation times.
Future<Sample> runOneShot(
  CliRevision cli,
  BenchProject project,
  WorkloadOptions options,
) async {
  final stopwatch = Stopwatch()..start();
  final process = await Process.start(
    cli.dart,
    cli.arguments(['generate', '--directory', project.serverDir.path]),
    workingDirectory: project.serverDir.path,
    environment: cli.environment,
  );
  final output = StringBuffer();
  final stdoutDone = process.stdout
      .transform(utf8.decoder)
      .forEach(output.write);
  final stderrDone = process.stderr
      .transform(utf8.decoder)
      .forEach(output.write);

  final exitCode = await process.exitCode.timeout(
    options.stepTimeout,
    onTimeout: () {
      process.kill(ProcessSignal.sigkill);
      return -1;
    },
  );
  stopwatch.stop();
  await Future.wait([stdoutDone, stderrDone]);

  final timings = _Timings();
  const LineSplitter().convert(output.toString()).forEach(timings.read);
  final upToDate =
      !timings.ranAnything && output.toString().contains(_upToDateMessage);
  if (exitCode != 0 || timings.failed || !(timings.ranAnything || upToDate)) {
    throw WorkloadFailure(
      '${cli.label}: serverpod generate did not complete in '
      '${project.serverDir.path} (exit code $exitCode).\n$output',
    );
  }
  return Sample(
    analysisMs: timings.analysisMs,
    generationMs: timings.generationMs,
    wallMs: stopwatch.elapsedMicroseconds / 1000,
    upToDate: upToDate,
  );
}

/// A running `serverpod generate --watch` whose stdout is read for timings.
///
/// The CLI prints nothing when a cycle is over. Its last act in a cycle that
/// generated code is writing the generation stamp, so such a cycle counts as
/// finished when the stamp file changes. A cycle that generated nothing is
/// finished with its analysis line.
class WatchSession {
  WatchSession._(
    this._cli,
    this._project,
    this._process,
    this._options,
    this._results,
  ) {
    _stamp = _stampState();
  }

  /// How long a cycle that generated code may take to write its stamp before
  /// the measurement goes on without it.
  static const _stampGrace = Duration(seconds: 15);

  final CliRevision _cli;
  final BenchProject _project;
  final Process _process;
  final WorkloadOptions _options;
  final Results _results;
  final _clock = Stopwatch()..start();
  final _output = StringBuffer();

  /// Progress lines that started but have not finished yet.
  int _inFlight = 0;

  /// The run that progress lines are currently attributed to.
  _Timings _current = _Timings();
  int _lastActivityMicros = 0;
  int _lastFinishedMicros = 0;
  int _lastGenerationMicros = -1;
  int _lastStampChangeMicros = -1;
  String? _stamp;
  bool _upToDate = false;
  int _probes = 0;
  int? _exitCode;

  static Future<WatchSession> start(
    CliRevision cli,
    BenchProject project,
    WorkloadOptions options,
    Results results,
  ) async {
    final process = await Process.start(
      cli.dart,
      cli.arguments([
        'generate',
        '--watch',
        '--directory',
        project.serverDir.path,
      ]),
      workingDirectory: project.serverDir.path,
      environment: cli.environment,
    );
    final session = WatchSession._(cli, project, process, options, results);
    process.stdout
        .transform(utf8.decoder)
        .transform(const LineSplitter())
        .listen(session._onLine);
    process.stderr
        .transform(utf8.decoder)
        .transform(const LineSplitter())
        .listen((line) => session._output.writeln('[stderr] $line'));
    unawaited(process.exitCode.then((code) => session._exitCode = code));
    return session;
  }

  /// What identifies the current content of the stamp file, `null` without
  /// one.
  String? _stampState() {
    final stat = _project.stampFile.statSync();
    if (stat.type == FileSystemEntityType.notFound) return null;
    return '${stat.modified.microsecondsSinceEpoch}:${stat.size}';
  }

  /// Notices a stamp file that changed since it was last looked at.
  void _pollStamp() {
    final stamp = _stampState();
    if (stamp == _stamp) return;
    _stamp = stamp;
    if (stamp != null) {
      _lastStampChangeMicros = _lastActivityMicros = _clock.elapsedMicroseconds;
    }
  }

  void _onLine(String line) {
    _output.writeln(line);
    final now = _clock.elapsedMicroseconds;

    if (line.contains(_upToDateMessage)) {
      // Printed after the check that found nothing to do, which ends the run.
      _upToDate = true;
      _lastActivityMicros = now;
      _lastFinishedMicros = now;
    } else if (_current.read(line)) {
      _inFlight = math.max(0, _inFlight - 1);
      _lastActivityMicros = now;
      _lastFinishedMicros = now;
      if (line.contains('Generating code')) _lastGenerationMicros = now;
    } else if (_started.hasMatch(line.replaceAll(_ansi, '').trim())) {
      _inFlight++;
      _lastActivityMicros = now;
    }
  }

  /// Waits for the generation the watch command runs before it starts
  /// listening, and returns its timings. The wall time includes starting the
  /// CLI.
  Future<Sample> waitForFirstRun() async {
    final timings = _current;
    await _waitUntilSettled(
      startMicros: 0,
      what: 'the first run',
      // A finished analysis is not the end of the first run: the CLI goes on
      // to check whether the generated code is up to date, and then either
      // says so or generates. Only one of those two ends it.
      isDone: () =>
          _upToDate ||
          timings.generationMs != null ||
          _firstRunLeftUnfinished(timings),
    );
    return _sample(timings, startMicros: 0);
  }

  /// Waits until the file watcher reports changes.
  ///
  /// The CLI only announces that it is listening at debug level, and changes
  /// made before the OS watcher is initialized are dropped. So a file without
  /// endpoints or future calls is rewritten until a change to it is analyzed.
  Future<void> waitUntilWatching() async {
    final probe = File(
      _join([_project.serverDir.path, 'lib', 'src', 'bench_probe.dart']),
    );
    final deadline = _clock.elapsed + _options.stepTimeout;
    while (_clock.elapsed < deadline) {
      _failIfExited();
      _current = _Timings();
      probe.writeAsStringSync('// Benchmark probe ${_probes++}.\n');

      final probeDeadline = _clock.elapsed + const Duration(seconds: 2);
      while (_clock.elapsed < probeDeadline) {
        if (_current.cycles > 0) {
          // Let anything the probe triggered finish before measuring.
          return _waitUntilSettled(
            startMicros: _clock.elapsedMicroseconds,
            what: 'the watcher probe',
            isDone: () => true,
          );
        }
        await Future<void>.delayed(const Duration(milliseconds: 20));
      }
    }
    throw _failure('The file watcher did not report a change in time.');
  }

  /// Applies [change] and returns the timings of every cycle it triggers.
  Future<Sample> measure(void Function() change) async {
    _failIfExited();
    _pollStamp();
    final timings = _current = _Timings();
    final startMicros = _clock.elapsedMicroseconds;

    change();

    await _waitUntilSettled(
      startMicros: startMicros,
      what: 'a change',
      isDone: () => timings.ranAnything,
    );
    return _sample(timings, startMicros: startMicros);
  }

  Sample _sample(_Timings timings, {required int startMicros}) {
    if (timings.failed) {
      throw _failure('The CLI reported a failed analysis or generation.');
    }
    final endMicros = math.max(_lastFinishedMicros, _lastStampChangeMicros);
    return Sample(
      analysisMs: timings.analysisMs,
      generationMs: timings.generationMs,
      wallMs: (endMicros - startMicros) / 1000,
      upToDate: _upToDate && timings.generationMs == null,
    );
  }

  /// Waits until [isDone] holds, no progress line is unfinished, a cycle that
  /// generated code since [startMicros] has written its stamp, and both the
  /// output and the stamp have been quiet for the settle time.
  ///
  /// The quiet time is what lets a change that the file watcher reports as
  /// several events be measured as one step. It cannot rule out an event that
  /// arrives later than that.
  Future<void> _waitUntilSettled({
    required int startMicros,
    required String what,
    required bool Function() isDone,
  }) async {
    final timeoutMicros = startMicros + _options.stepTimeout.inMicroseconds;
    while (true) {
      _failIfExited();
      _pollStamp();
      final now = _clock.elapsedMicroseconds;
      final quietMicros = now - math.max(_lastActivityMicros, startMicros);
      if (isDone() &&
          _inFlight == 0 &&
          quietMicros >= _options.settle.inMicroseconds &&
          _stampWritten(startMicros, now)) {
        return;
      }
      if (now > timeoutMicros) {
        throw _failure(
          'Generation for $what did not finish within '
          '${_options.stepTimeout.inSeconds}s.',
        );
      }
      await Future<void>.delayed(const Duration(milliseconds: 10));
    }
  }

  /// Whether a first run that analyzed the project has gone so long without
  /// reporting it as up to date or generating that it is taken as over.
  bool _firstRunLeftUnfinished(_Timings timings) {
    if (timings.cycles == 0 || _inFlight > 0) return false;
    final quietMicros = _clock.elapsedMicroseconds - _lastActivityMicros;
    if (quietMicros < _stampGrace.inMicroseconds) return false;

    _results.notes.add(
      '${_cli.label} neither reported an analyzed project as up to date nor '
      'generated code within ${_stampGrace.inSeconds}s, so the wall time of '
      'its first watch run ends at the analysis.',
    );
    return true;
  }

  /// Whether the cycles since [startMicros] left no stamp to wait for.
  bool _stampWritten(int startMicros, int now) {
    final generated = _lastGenerationMicros >= startMicros;
    if (!generated || _lastStampChangeMicros >= startMicros) return true;
    if (now - _lastGenerationMicros < _stampGrace.inMicroseconds) return false;

    _results.notes.add(
      '${_cli.label} wrote no generation stamp within '
      '${_stampGrace.inSeconds}s of generating code, so its watch wall times '
      'end at the last progress line instead.',
    );
    return true;
  }

  void _failIfExited() {
    final code = _exitCode;
    if (code != null) {
      throw _failure('The CLI exited unexpectedly with exit code $code.');
    }
  }

  WorkloadFailure _failure(String message) => WorkloadFailure(
    '${_cli.label}: serverpod generate --watch in '
    '${_project.serverDir.path}: $message\n$_output',
  );

  Future<void> stop() async {
    if (_exitCode != null) return;
    _process.kill(ProcessSignal.sigint);
    await _process.exitCode.timeout(
      const Duration(seconds: 10),
      onTimeout: () {
        _process.kill(ProcessSignal.sigkill);
        return _process.exitCode;
      },
    );
  }
}

void _copyDirectory(Directory source, Directory target) {
  target.createSync(recursive: true);
  for (final entity in source.listSync(followLinks: false)) {
    final name = entity.uri.pathSegments.lastWhere((s) => s.isNotEmpty);
    final path = _join([target.path, name]);
    if (entity is Directory) {
      _copyDirectory(entity, Directory(path));
    } else if (entity is File) {
      entity.copySync(path);
    } else if (entity is Link) {
      Link(path).createSync(entity.targetSync());
    }
  }
}

String _join(List<String> parts) => parts.join(Platform.pathSeparator);
