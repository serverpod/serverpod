import 'package:serverpod/database.dart';
import 'package:serverpod_test_sqlite_server/src/generated/protocol.dart';
import 'package:serverpod_test_sqlite_server/test_util/test_serverpod.dart';
import 'package:test/test.dart';

// Regression tests for https://github.com/serverpod/serverpod/issues/5294
// Negating (~) a many-relation filter (none/any/count/every) used to generate
// SQL that referenced the relation alias outside of its CTE, causing a
// "missing FROM-clause entry" error. These verify the negated filters now
// execute and return the exact set-complement of the un-negated filter.
void main() async {
  var session = await IntegrationTestServer().session();

  group('Given models with many to many relation', () {
    tearDown(() async {
      await Enrollment.db.deleteWhere(
        session,
        where: (_) => Constant.bool(true),
      );
      await Student.db.deleteWhere(session, where: (_) => Constant.bool(true));
      await Course.db.deleteWhere(session, where: (_) => Constant.bool(true));
    });

    Future<List<Student>> insertBaseData() async {
      var students = await Student.db.insert(session, [
        Student(name: 'Alex'),
        Student(name: 'Isak'),
        Student(name: 'Lisa'),
      ]);
      var courses = await Course.db.insert(session, [
        Course(name: 'Math'),
        Course(name: 'English'),
      ]);
      await Enrollment.db.insert(session, [
        // Alex is enrolled in Math and English
        Enrollment(studentId: students[0].id!, courseId: courses[0].id!),
        Enrollment(studentId: students[0].id!, courseId: courses[1].id!),
        // Isak is enrolled in English
        Enrollment(studentId: students[1].id!, courseId: courses[1].id!),
        // Lisa is enrolled in nothing
      ]);
      return students;
    }

    test(
      'when fetching models filtered by NOT none() then students with at least one relation are returned',
      () async {
        await insertBaseData();

        var studentsFetched = await Student.db.find(
          session,
          where: (s) => ~s.enrollments.none(),
        );

        var studentNames = studentsFetched.map((e) => e.name);
        expect(studentNames, hasLength(2));
        expect(studentNames, containsAll(['Alex', 'Isak']));
      },
    );

    test(
      'when fetching models filtered by NOT any() then students with no relation are returned',
      () async {
        await insertBaseData();

        var studentsFetched = await Student.db.find(
          session,
          where: (s) => ~s.enrollments.any(),
        );

        var studentNames = studentsFetched.map((e) => e.name);
        expect(studentNames, ['Lisa']);
      },
    );

    test(
      'when fetching models filtered by NOT count() > 0 then students with no relation are returned',
      () async {
        await insertBaseData();

        var studentsFetched = await Student.db.find(
          session,
          where: (s) => ~(s.enrollments.count() > 0),
        );

        var studentNames = studentsFetched.map((e) => e.name);
        expect(studentNames, ['Lisa']);
      },
    );

    test(
      'when fetching models filtered by NOT of a combined filter and none() then De Morgan complement is returned',
      () async {
        await insertBaseData();

        // NOT (name == 'Lisa' AND no enrollments) excludes only Lisa, who is
        // the one student that both is named Lisa and has no enrollments.
        var studentsFetched = await Student.db.find(
          session,
          where: (s) => ~(s.name.equals('Lisa') & s.enrollments.none()),
        );

        var studentNames = studentsFetched.map((e) => e.name);
        expect(studentNames, hasLength(2));
        expect(studentNames, containsAll(['Alex', 'Isak']));
      },
    );

    test(
      'when fetching models filtered by NOT every() then complement is returned and includes the empty-relation row',
      () async {
        var students = await Student.db.insert(session, [
          Student(name: 'Alex'),
          Student(name: 'Isak'),
          Student(name: 'Lisa'),
          Student(name: 'Viktor'),
        ]);
        var courses = await Course.db.insert(session, [
          Course(name: 'Level 1: Math'),
          Course(name: 'Level 1: English'),
          Course(name: 'Level 2: Math'),
          Course(name: 'Level 2: English'),
        ]);
        await Enrollment.db.insert(session, [
          // Alex has a Level 1 course (so NOT all level 2)
          Enrollment(studentId: students[0].id!, courseId: courses[0].id!),
          Enrollment(studentId: students[0].id!, courseId: courses[2].id!),
          // Isak has a Level 1 course (so NOT all level 2)
          Enrollment(studentId: students[1].id!, courseId: courses[1].id!),
          // Lisa is enrolled only in Level 2 courses
          Enrollment(studentId: students[2].id!, courseId: courses[2].id!),
          Enrollment(studentId: students[2].id!, courseId: courses[3].id!),
          // Viktor is enrolled in nothing
        ]);

        // every(level 2) == [Lisa] (Viktor excluded: every() is non-vacuous).
        // NOT every(level 2) is the complement and therefore INCLUDES the
        // zero-enrollment student Viktor.
        var studentsFetched = await Student.db.find(
          session,
          where: (s) =>
              ~s.enrollments.every((e) => e.course.name.ilike('level 2:%')),
        );

        var studentNames = studentsFetched.map((e) => e.name);
        expect(studentNames, hasLength(3));
        expect(studentNames, containsAll(['Alex', 'Isak', 'Viktor']));
      },
    );
  });
}
