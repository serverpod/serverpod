import 'dart:io';

import 'package:bootstrap_project/src/util.dart';
import 'package:path/path.dart' as p;
import 'package:serverpod_cli/src/config/experimental_feature.dart';
import 'package:serverpod_cli/src/create/create.dart';
import 'package:serverpod_cli/src/create/template_context.dart';
import 'package:serverpod_cli/src/shared/environment.dart' as env;
import 'package:test/test.dart';
import 'package:uuid/uuid.dart';

void setupForPerformCreateTest() {
  env.loadEnvironmentVars();
  CommandLineExperimentalFeatures.initialize(ExperimentalFeature.values);
}

class TempProject {
  /// The randomly generated project name.
  final String name;

  /// The temp directory the project was created in.
  late final Directory workingDir;

  TempProject(this.name);

  /// Absolute path to the generated project root (`<workingDir>/<name>`).
  String get projectRoot => p.join(workingDir.path, name);

  /// Absolute path to the generated server package.
  String get serverDir => p.join(workingDir.path, createServerFolderPath(name));
}

/// Generate a Serverpod project for [context] via [performCreate].
///
/// Returns the [TempProject] whose paths the tests assert against.
TempProject setUpPerformCreateInTempDir({required TemplateContext context}) {
  final project = TempProject(
    'temp_test_${const Uuid().v4().replaceAll('-', '_').toLowerCase()}',
  );
  setUpAll(() async {
    setupForPerformCreateTest();
    project.workingDir = Directory.systemTemp.createTempSync(
      'sp_perform_create_',
    );
    await performCreate(
      project.name,
      false,
      interactive: false,
      context: context,
      workingDirectory: project.workingDir,
    );
  });
  tearDownAll(() {
    try {
      project.workingDir.deleteSync(recursive: true);
    } on FileSystemException {
      // Gone.
    }
  });
  return project;
}
