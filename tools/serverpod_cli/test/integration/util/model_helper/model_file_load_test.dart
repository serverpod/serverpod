import 'dart:io';

import 'package:path/path.dart';
import 'package:serverpod_cli/analyzer.dart';
import 'package:serverpod_cli/src/util/model_helper.dart';
import 'package:test/test.dart';
import 'package:uuid/uuid.dart';

GeneratorConfig createGeneratorConfig([
  List<String> serverPackageDirectoryPathParts = const [],
]) {
  return GeneratorConfig(
    name: 'test',
    type: PackageType.server,
    serverPackage: 'test_server',
    dartClientPackage: 'test_client',
    dartClientDependsOnServiceClient: true,
    serverPackageDirectoryPathParts: serverPackageDirectoryPathParts,
    relativeDartClientPackagePathParts: [],
    modules: [],
    extraClasses: [],
    enabledFeatures: [],
  );
}

void main() {
  late Directory testDirectory;
  setUpAll(() {
    testDirectory = Directory(join(Directory.current.path, const Uuid().v4()));
    testDirectory.createSync(recursive: true);
  });

  tearDownAll(() {
    testDirectory.deleteSync(recursive: true);
  });

  group('Given a valid model class with *.yaml file ending', () {
    var modelFileName = 'example.yaml';

    late Directory testProject;
    late GeneratorConfig config;
    setUp(() {
      testProject = Directory(join(testDirectory.path, const Uuid().v4()));
      testProject.createSync(recursive: true);
      config = createGeneratorConfig(split(testProject.path));
    });

    tearDown(() {
      testProject.deleteSync(recursive: true);
    });

    group('placed in the "lib/src/models" directory when loaded', () {
      late List<ModelSource> models;

      setUp(() async {
        var modelFile = File(join(
          testProject.path,
          'lib',
          'src',
          'models',
          modelFileName,
        ));
        modelFile.createSync(recursive: true);
        modelFile.writeAsStringSync('''
  class: Example
  fields:
    name: String
''');
        models = await ModelHelper.loadProjectYamlModelsFromDisk(config);
      });

      test('then the class is serialized.', () async {
        expect(models, hasLength(1));
      });

      test('then modelSource has no subDirPathParts.', () async {
        expect(models.firstOrNull?.subDirPathParts, isEmpty);
      });
    });

    group('placed in the "lib/src/protocol" directory when loaded', () {
      late List<ModelSource> models;

      setUp(() async {
        var modelFile = File(join(
          testProject.path,
          'lib',
          'src',
          'protocol',
          modelFileName,
        ));
        modelFile.createSync(recursive: true);
        modelFile.writeAsStringSync('''
  class: Example
  fields:
    name: String
''');
        models = await ModelHelper.loadProjectYamlModelsFromDisk(config);
      });

      test('then the class is serialized.', () async {
        expect(models, hasLength(1));
      });

      test('then modelSource has no subDirPathParts.', () async {
        expect(models.firstOrNull?.subDirPathParts, isEmpty);
      });
    });

    group(
        'placed in a subdirectory of the "lib/src/models" directory when loaded',
        () {
      late List<ModelSource> models;

      setUp(() async {
        var modelFile = File(join(
          testProject.path,
          'lib',
          'src',
          'models',
          'sub',
          modelFileName,
        ));
        modelFile.createSync(recursive: true);
        modelFile.writeAsStringSync('''
  class: Example
  fields:
    name: String

''');
        models = await ModelHelper.loadProjectYamlModelsFromDisk(config);
      });

      test('then the class is serialized.', () async {
        expect(models, hasLength(1));
      });

      test('then modelSource has the correct subDirPathParts.', () async {
        expect(models.firstOrNull?.subDirPathParts, ['sub']);
      });
    });

    group('placed in the "lib/src" directory when loaded', () {
      late List<ModelSource> models;

      setUp(() async {
        var modelFile = File(join(
          testProject.path,
          'lib',
          'src',
          modelFileName,
        ));
        modelFile.createSync(recursive: true);
        modelFile.writeAsStringSync('''
  class: Example
  fields:
    name: String
''');
        models = await ModelHelper.loadProjectYamlModelsFromDisk(config);
      });

      test('then the class is not serialized.', () async {
        expect(models, hasLength(0));
      });
    });
  });

  group('Given a valid model class with *.yml file ending', () {
    var modelFileName = 'example.yml';

    late Directory testProject;
    late GeneratorConfig config;
    setUp(() {
      testProject = Directory(join(testDirectory.path, const Uuid().v4()));
      testProject.createSync(recursive: true);
      config = createGeneratorConfig(split(testProject.path));
    });

    tearDown(() {
      testProject.deleteSync(recursive: true);
    });

    group('placed in the "lib/src/models" directory when loaded', () {
      late List<ModelSource> models;

      setUp(() async {
        var modelFile = File(join(
          testProject.path,
          'lib',
          'src',
          'models',
          modelFileName,
        ));
        modelFile.createSync(recursive: true);
        modelFile.writeAsStringSync('''
  class: Example
  fields:
    name: String
''');
        models = await ModelHelper.loadProjectYamlModelsFromDisk(config);
      });

      test('then the class is serialized.', () async {
        expect(models, hasLength(1));
      });

      test('then modelSource has no subDirPathParts.', () async {
        expect(models.firstOrNull?.subDirPathParts, isEmpty);
      });
    });

    group('placed in the "lib/src/protocol" directory when loaded', () {
      late List<ModelSource> models;

      setUp(() async {
        var modelFile = File(join(
          testProject.path,
          'lib',
          'src',
          'protocol',
          modelFileName,
        ));
        modelFile.createSync(recursive: true);
        modelFile.writeAsStringSync('''
  class: Example
  fields:
    name: String
''');
        models = await ModelHelper.loadProjectYamlModelsFromDisk(config);
      });

      test('then the class is serialized.', () async {
        expect(models, hasLength(1));
      });

      test('then modelSource has no subDirPathParts.', () async {
        expect(models.firstOrNull?.subDirPathParts, isEmpty);
      });
    });

    group(
        'placed in a subdirectory of the "lib/src/models" directory when loaded',
        () {
      late List<ModelSource> models;

      setUp(() async {
        var modelFile = File(join(
          testProject.path,
          'lib',
          'src',
          'models',
          'sub',
          modelFileName,
        ));
        modelFile.createSync(recursive: true);
        modelFile.writeAsStringSync('''
  class: Example
  fields:
    name: String

''');
        models = await ModelHelper.loadProjectYamlModelsFromDisk(config);
      });

      test('then the class is serialized.', () async {
        expect(models, hasLength(1));
      });

      test('then modelSource has the correct subDirPathParts.', () async {
        expect(models.firstOrNull?.subDirPathParts, ['sub']);
      });
    });

    group(
        'placed in a subdirectory of the "lib/src/protocol" directory when loaded',
        () {
      late List<ModelSource> models;

      setUp(() async {
        var modelFile = File(join(
          testProject.path,
          'lib',
          'src',
          'protocol',
          'sub',
          modelFileName,
        ));
        modelFile.createSync(recursive: true);
        modelFile.writeAsStringSync('''
  class: Example
  fields:
    name: String

''');
        models = await ModelHelper.loadProjectYamlModelsFromDisk(config);
      });

      test('then the class is serialized.', () async {
        expect(models, hasLength(1));
      });

      test('then modelSource has the correct subDirPathParts.', () async {
        expect(models.firstOrNull?.subDirPathParts, ['sub']);
      });
    });

    group('placed in the "lib/src" directory when loaded', () {
      late List<ModelSource> models;

      setUp(() async {
        var modelFile = File(join(
          testProject.path,
          'lib',
          'src',
          modelFileName,
        ));
        modelFile.createSync(recursive: true);
        modelFile.writeAsStringSync('''
  class: Example
  fields:
    name: String
''');
        models = await ModelHelper.loadProjectYamlModelsFromDisk(config);
      });

      test('then the class is not serialized.', () async {
        expect(models, hasLength(0));
      });
    });
  });

  group('Given a valid model class with *.spy file ending', () {
    var modelFileName = 'example.spy';

    late Directory testProject;
    late GeneratorConfig config;
    setUp(() {
      testProject = Directory(join(testDirectory.path, const Uuid().v4()));
      testProject.createSync(recursive: true);
      config = createGeneratorConfig(split(testProject.path));
    });

    tearDown(() {
      testProject.deleteSync(recursive: true);
    });

    group('placed in the "lib/src/models" directory when loaded', () {
      late List<ModelSource> models;

      setUp(() async {
        var modelFile = File(join(
          testProject.path,
          'lib',
          'src',
          'models',
          modelFileName,
        ));
        modelFile.createSync(recursive: true);
        modelFile.writeAsStringSync('''
  class: Example
  fields:
    name: String
''');
        models = await ModelHelper.loadProjectYamlModelsFromDisk(config);
      });

      test('then the class is serialized.', () async {
        expect(models, hasLength(1));
      });

      test('then modelSource has no subDirPathParts.', () async {
        expect(models.firstOrNull?.subDirPathParts, isEmpty);
      });
    });

    group('placed in the "lib/src/protocol" directory when loaded', () {
      late List<ModelSource> models;

      setUp(() async {
        var modelFile = File(join(
          testProject.path,
          'lib',
          'src',
          'protocol',
          modelFileName,
        ));
        modelFile.createSync(recursive: true);
        modelFile.writeAsStringSync('''
  class: Example
  fields:
    name: String
''');
        models = await ModelHelper.loadProjectYamlModelsFromDisk(config);
      });

      test('then the class is serialized.', () async {
        expect(models, hasLength(1));
      });

      test('then modelSource has no subDirPathParts.', () async {
        expect(models.firstOrNull?.subDirPathParts, isEmpty);
      });
    });

    group(
        'placed in a subdirectory of the "lib/src/models" directory when loaded',
        () {
      late List<ModelSource> models;

      setUp(() async {
        var modelFile = File(join(
          testProject.path,
          'lib',
          'src',
          'models',
          'sub',
          modelFileName,
        ));
        modelFile.createSync(recursive: true);
        modelFile.writeAsStringSync('''
  class: Example
  fields:
    name: String

''');
        models = await ModelHelper.loadProjectYamlModelsFromDisk(config);
      });

      test('then the class is serialized.', () async {
        expect(models, hasLength(1));
      });

      test('then modelSource has the correct subDirPathParts.', () async {
        expect(models.firstOrNull?.subDirPathParts, ['sub']);
      });
    });

    group(
        'placed in a subdirectory of the "lib/src/protocol" directory when loaded',
        () {
      late List<ModelSource> models;

      setUp(() async {
        var modelFile = File(join(
          testProject.path,
          'lib',
          'src',
          'protocol',
          'sub',
          modelFileName,
        ));
        modelFile.createSync(recursive: true);
        modelFile.writeAsStringSync('''
  class: Example
  fields:
    name: String

''');
        models = await ModelHelper.loadProjectYamlModelsFromDisk(config);
      });

      test('then the class is serialized.', () async {
        expect(models, hasLength(1));
      });

      test('then modelSource has the correct subDirPathParts.', () async {
        expect(models.firstOrNull?.subDirPathParts, ['sub']);
      });
    });

    group('placed in the "lib/src" directory when loaded', () {
      late List<ModelSource> models;

      setUp(() async {
        var modelFile = File(join(
          testProject.path,
          'lib',
          'src',
          modelFileName,
        ));
        modelFile.createSync(recursive: true);
        modelFile.writeAsStringSync('''
  class: Example
  fields:
    name: String
''');
        models = await ModelHelper.loadProjectYamlModelsFromDisk(config);
      });

      test('then the class is not serialized.', () async {
        expect(models, hasLength(0));
      });
    });
  });

  group('Given a valid model class with *.spy.yaml file ending', () {
    var modelFileName = 'example.spy.yaml';

    late Directory testProject;
    late GeneratorConfig config;
    setUp(() {
      testProject = Directory(join(testDirectory.path, const Uuid().v4()));
      testProject.createSync(recursive: true);
      config = createGeneratorConfig(split(testProject.path));
    });

    tearDown(() {
      testProject.deleteSync(recursive: true);
    });

    group('placed in the "lib/src/models" directory when loaded', () {
      late List<ModelSource> models;

      setUp(() async {
        var modelFile = File(join(
          testProject.path,
          'lib',
          'src',
          'models',
          modelFileName,
        ));
        modelFile.createSync(recursive: true);
        modelFile.writeAsStringSync('''
  class: Example
  fields:
    name: String
''');
        models = await ModelHelper.loadProjectYamlModelsFromDisk(config);
      });

      test('then the class is serialized.', () async {
        expect(models, hasLength(1));
      });

      test('then modelSource has no subDirPathParts.', () async {
        expect(models.firstOrNull?.subDirPathParts, isEmpty);
      });
    });

    group('placed in the "lib/src/protocol" directory when loaded', () {
      late List<ModelSource> models;

      setUp(() async {
        var modelFile = File(join(
          testProject.path,
          'lib',
          'src',
          'protocol',
          modelFileName,
        ));
        modelFile.createSync(recursive: true);
        modelFile.writeAsStringSync('''
  class: Example
  fields:
    name: String
''');
        models = await ModelHelper.loadProjectYamlModelsFromDisk(config);
      });

      test('then the class is serialized.', () async {
        expect(models, hasLength(1));
      });

      test('then modelSource has no subDirPathParts.', () async {
        expect(models.firstOrNull?.subDirPathParts, isEmpty);
      });
    });

    group(
        'placed in a subdirectory of the "lib/src/models" directory when loaded',
        () {
      late List<ModelSource> models;

      setUp(() async {
        var modelFile = File(join(
          testProject.path,
          'lib',
          'src',
          'models',
          'sub',
          modelFileName,
        ));
        modelFile.createSync(recursive: true);
        modelFile.writeAsStringSync('''
  class: Example
  fields:
    name: String

''');
        models = await ModelHelper.loadProjectYamlModelsFromDisk(config);
      });

      test('then the class is serialized.', () async {
        expect(models, hasLength(1));
      });

      test('then modelSource has the correct subDirPathParts.', () async {
        expect(models.firstOrNull?.subDirPathParts, ['sub']);
      });
    });

    group(
        'placed in a subdirectory of the "lib/src/protocol" directory when loaded',
        () {
      late List<ModelSource> models;

      setUp(() async {
        var modelFile = File(join(
          testProject.path,
          'lib',
          'src',
          'protocol',
          'sub',
          modelFileName,
        ));
        modelFile.createSync(recursive: true);
        modelFile.writeAsStringSync('''
  class: Example
  fields:
    name: String

''');
        models = await ModelHelper.loadProjectYamlModelsFromDisk(config);
      });

      test('then the class is serialized.', () async {
        expect(models, hasLength(1));
      });

      test('then modelSource has the correct subDirPathParts.', () async {
        expect(models.firstOrNull?.subDirPathParts, ['sub']);
      });
    });

    group('placed in the "lib/src" directory when loaded', () {
      late List<ModelSource> models;

      setUp(() async {
        var modelFile = File(join(
          testProject.path,
          'lib',
          'src',
          modelFileName,
        ));
        modelFile.createSync(recursive: true);
        modelFile.writeAsStringSync('''
  class: Example
  fields:
    name: String
''');
        models = await ModelHelper.loadProjectYamlModelsFromDisk(config);
      });

      test('then the class is not serialized.', () async {
        expect(models, hasLength(0));
      });
    });
  });

  group('Given a valid model class with *.spy.yml file ending', () {
    var modelFileName = 'example.spy.yml';

    late Directory testProject;
    late GeneratorConfig config;
    setUp(() {
      testProject = Directory(join(testDirectory.path, const Uuid().v4()));
      testProject.createSync(recursive: true);
      config = createGeneratorConfig(split(testProject.path));
    });

    tearDown(() {
      testProject.deleteSync(recursive: true);
    });

    group('placed in the "lib/src/models" directory when loaded', () {
      late List<ModelSource> models;

      setUp(() async {
        var modelFile = File(join(
          testProject.path,
          'lib',
          'src',
          'models',
          modelFileName,
        ));
        modelFile.createSync(recursive: true);
        modelFile.writeAsStringSync('''
  class: Example
  fields:
    name: String
''');
        models = await ModelHelper.loadProjectYamlModelsFromDisk(config);
      });

      test('then the class is serialized.', () async {
        expect(models, hasLength(1));
      });

      test('then modelSource has no subDirPathParts.', () async {
        expect(models.firstOrNull?.subDirPathParts, isEmpty);
      });
    });

    group('placed in the "lib/src/protocol" directory when loaded', () {
      late List<ModelSource> models;

      setUp(() async {
        var modelFile = File(join(
          testProject.path,
          'lib',
          'src',
          'protocol',
          modelFileName,
        ));
        modelFile.createSync(recursive: true);
        modelFile.writeAsStringSync('''
  class: Example
  fields:
    name: String
''');
        models = await ModelHelper.loadProjectYamlModelsFromDisk(config);
      });

      test('then the class is serialized.', () async {
        expect(models, hasLength(1));
      });

      test('then modelSource has no subDirPathParts.', () async {
        expect(models.firstOrNull?.subDirPathParts, isEmpty);
      });
    });

    group(
        'placed in a subdirectory of the "lib/src/models" directory when loaded',
        () {
      late List<ModelSource> models;

      setUp(() async {
        var modelFile = File(join(
          testProject.path,
          'lib',
          'src',
          'models',
          'sub',
          modelFileName,
        ));
        modelFile.createSync(recursive: true);
        modelFile.writeAsStringSync('''
  class: Example
  fields:
    name: String

''');
        models = await ModelHelper.loadProjectYamlModelsFromDisk(config);
      });

      test('then the class is serialized.', () async {
        expect(models, hasLength(1));
      });

      test('then modelSource has the correct subDirPathParts.', () async {
        expect(models.firstOrNull?.subDirPathParts, ['sub']);
      });
    });

    group(
        'placed in a subdirectory of the "lib/src/protocol" directory when loaded',
        () {
      late List<ModelSource> models;

      setUp(() async {
        var modelFile = File(join(
          testProject.path,
          'lib',
          'src',
          'protocol',
          'sub',
          modelFileName,
        ));
        modelFile.createSync(recursive: true);
        modelFile.writeAsStringSync('''
  class: Example
  fields:
    name: String

''');
        models = await ModelHelper.loadProjectYamlModelsFromDisk(config);
      });

      test('then the class is serialized.', () async {
        expect(models, hasLength(1));
      });

      test('then modelSource has the correct subDirPathParts.', () async {
        expect(models.firstOrNull?.subDirPathParts, ['sub']);
      });
    });

    group('placed in the "lib/src" directory when loaded', () {
      late List<ModelSource> models;

      setUp(() async {
        var modelFile = File(join(
          testProject.path,
          'lib',
          'src',
          modelFileName,
        ));
        modelFile.createSync(recursive: true);
        modelFile.writeAsStringSync('''
  class: Example
  fields:
    name: String
''');
        models = await ModelHelper.loadProjectYamlModelsFromDisk(config);
      });

      test('then the class is not serialized.', () async {
        expect(models, hasLength(0));
      });
    });
  });
}
