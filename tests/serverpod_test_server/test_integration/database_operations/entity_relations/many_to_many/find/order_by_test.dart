import 'package:serverpod/database.dart';
import 'package:serverpod_test_server/src/generated/protocol.dart';
import 'package:serverpod_test_server/test_util/test_serverpod.dart';
import 'package:test/test.dart';

void main() async {
  var session = await IntegrationTestServer().session();

  group('Given entities with many to many relation', () {
    tearDown(() async {
      await Enrollment.db
          .deleteWhere(session, where: (_) => Constant.bool(true));
      await Student.db.deleteWhere(session, where: (_) => Constant.bool(true));
      await Course.db.deleteWhere(session, where: (_) => Constant.bool(true));
    });

    test(
        'when fetching entities ordered on count of many relation then result is as expected',
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
        orderBy: Student.t.enrollments.count(),
        orderDescending: true,
      );

      var studentNames = studentsFetched.map((e) => e.name);
      expect(studentNames, ['Viktor', 'Alex', 'Isak', 'Lisa']);
    });

    test(
        'when fetching entities ordered on filtered count of many relation then result is as expected',
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
        orderBy: Student.t.enrollments
            .count((e) => e.course.name.ilike('level 2:%')),
        orderDescending: true,
      );

      var studentNames = studentsFetched.map((e) => e.name);
      expect(studentNames, ['Lisa', 'Viktor', 'Alex', 'Isak']);
    });
  });
}
