import 'package:serverpod_database/serverpod_database.dart';
import 'package:serverpod_test_sqlite_client/serverpod_test_sqlite_client.dart';
import 'package:test/test.dart';

import '../../../test_util.dart';

void main() {
  initTestClientSession();

  group('Given models with many to many relation', () {
    test(
      'when fetching models ordered on count of many relation then result is as expected',
      () async {
        var students = await Student.db.insert(session, [
          Student(name: 'Alex'),
          Student(name: 'Viktor'),
          Student(name: 'Isak'),
          Student(name: 'Lisa'),
        ]);
        var courses = await Course.db.insert(session, [
          Course(name: 'Math'),
          Course(name: 'English'),
          Course(name: 'History'),
        ]);
        await Enrollment.db.insert(session, [
          // Alex is enrolled in Math and History
          Enrollment(studentId: students[0].id!, courseId: courses[0].id!),
          Enrollment(studentId: students[0].id!, courseId: courses[2].id!),
          // Viktor is enrolled in Math, English and History
          Enrollment(studentId: students[1].id!, courseId: courses[0].id!),
          Enrollment(studentId: students[1].id!, courseId: courses[1].id!),
          Enrollment(studentId: students[1].id!, courseId: courses[2].id!),
          // Isak is enrolled in English
          Enrollment(studentId: students[2].id!, courseId: courses[1].id!),
        ]);

        var studentsFetched = await Student.db.find(
          session,
          // Fetch all students ordered by number of courses they are enrolled to.
          orderBy: (t) => t.enrollments.count().desc(),
        );

        var studentNames = studentsFetched.map((e) => e.name);
        expect(studentNames, ['Viktor', 'Alex', 'Isak', 'Lisa']);
      },
    );

    test(
      'when fetching models ordered on filtered count of many relation then result is as expected',
      () async {
        var students = await Student.db.insert(session, [
          Student(name: 'Alex'),
          Student(name: 'Viktor'),
          Student(name: 'Isak'),
          Student(name: 'Lisa'),
        ]);
        var courses = await Course.db.insert(session, [
          Course(name: 'Level 1: Math'),
          Course(name: 'Level 1: English'),
          Course(name: 'Level 1: History'),
          Course(name: 'Level 2: Math'),
          Course(name: 'Level 2: English'),
          Course(name: 'Level 2: History'),
        ]);
        await Enrollment.db.insert(session, [
          // Alex is enrolled in Level 1 Math and Level 2 English
          Enrollment(studentId: students[0].id!, courseId: courses[0].id!),
          Enrollment(studentId: students[0].id!, courseId: courses[4].id!),
          // Viktor is enrolled in Level 1 Math, Level 2 English and Level 2 History
          Enrollment(studentId: students[1].id!, courseId: courses[0].id!),
          Enrollment(studentId: students[1].id!, courseId: courses[4].id!),
          Enrollment(studentId: students[1].id!, courseId: courses[5].id!),
          // Isak is enrolled in Level 1 English
          Enrollment(studentId: students[2].id!, courseId: courses[1].id!),
          // Lisa is enrolled in Level 2 Math, Level 2 English and Level 2 History
          Enrollment(studentId: students[3].id!, courseId: courses[3].id!),
          Enrollment(studentId: students[3].id!, courseId: courses[4].id!),
          Enrollment(studentId: students[3].id!, courseId: courses[5].id!),
        ]);

        var studentsFetched = await Student.db.find(
          session,
          // Fetch all students ordered by the number of level 2 courses they are enrolled to.
          orderBy: (t) => t.enrollments
              .count((e) => e.course.name.ilike('level 2:%'))
              .desc(),
        );

        var studentNames = studentsFetched.map((e) => e.name);
        expect(studentNames, ['Lisa', 'Viktor', 'Alex', 'Isak']);
      },
    );
  });
}
