import 'package:serverpod_cli/analyzer.dart';
import 'package:serverpod_cli/src/analyzer/models/stateful_analyzer.dart';
import 'package:serverpod_cli/src/database/create_definition.dart';
import 'package:serverpod_cli/src/generator/code_generation_collector.dart';
import 'package:serverpod_cli/src/test_util/builders/model_source_builder.dart';
import 'package:serverpod_service_client/serverpod_service_client.dart';
import 'package:test/test.dart';

import '../../generator/dart/client_code_generator/class_constructors_test.dart';

void main() {
  test(
      'Given a table that is not managed by serverpod that changes to be managed',
      () {
    DatabaseDefinition sourceDefinition;
    {
      var models = [
        ModelSourceBuilder().withFileName('course').withYaml(
          '''
class: Course
table: course
fields:
  name: String
  enrollments: List<Enrollment>?, relation(name=course_enrollments)
          ''',
        ).build(),
        ModelSourceBuilder().withFileName('student').withYaml(
          '''
class: Student
table: student
fields:
  name: String
  enrollments: List<Enrollment>?, relation(name=student_enrollments)
          ''',
        ).build(),
        ModelSourceBuilder().withFileName('enrollment').withYaml(
          '''
class: Enrollment
table: enrollment
fields:
  student: Student?, relation(name=student_enrollments)
  course: Course?, relation(name=course_enrollments)
indexes:
  enrollment_index_idx:
    fields: studentId, courseId
    unique: true
          ''',
        ).build(),
      ];

      var collector = CodeGenerationCollector();
      var analyzer =
          StatefulAnalyzer(config, models, onErrorsCollector(collector));
      var definitions = analyzer.validateAll();
      expect(collector.errors, isEmpty);

      sourceDefinition =
          createDatabaseDefinitionFromModels(definitions, 'example', []);
    }

    DatabaseDefinition
        targetDefinition; // renames table `student` to `custom_student`
    {
      var models = [
        ModelSourceBuilder().withFileName('course').withYaml(
          '''
class: Course
table: course
fields:
  name: String
  enrollments: List<Enrollment>?, relation(name=course_enrollments)
          ''',
        ).build(),
        ModelSourceBuilder().withFileName('student').withYaml(
          '''
class: Student
table: custom_student
fields:
  name: String
  enrollments: List<Enrollment>?, relation(name=student_enrollments)
          ''',
        ).build(),
        ModelSourceBuilder().withFileName('enrollment').withYaml(
          '''
class: Enrollment
table: enrollment
fields:
  student: Student?, relation(name=student_enrollments)
  course: Course?, relation(name=course_enrollments)
indexes:
  enrollment_index_idx:
    fields: studentId, courseId
    unique: true
          ''',
        ).build(),
      ];

      var collector = CodeGenerationCollector();
      var analyzer =
          StatefulAnalyzer(config, models, onErrorsCollector(collector));
      var definitions = analyzer.validateAll();
      expect(collector.errors, isEmpty);

      targetDefinition = createDatabaseDefinitionFromModels(
        definitions,
        'example',
        [],
      );
    }

    var migration = generateDatabaseMigration(
      databaseSource: sourceDefinition,
      databaseTarget: targetDefinition,
    );

    var psql = migration.toPgSql(installedModules: [], removedModules: []);

    expect(psql, isNot(contains('DROP CONSTRAINT "enrollment_fk_0"')));
    expect(psql, contains('ADD CONSTRAINT "enrollment_fk_0"'));
  });
}
