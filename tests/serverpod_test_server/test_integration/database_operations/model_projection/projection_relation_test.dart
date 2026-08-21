import 'package:serverpod_test_server/test_util/test_serverpod.dart';
import 'package:serverpod_test_server/src/generated/protocol.dart';
import 'package:serverpod/serverpod.dart';
import 'package:test/test.dart';

void main() async {
  var session = await IntegrationTestServer().session();
  setUp(() async {
    await ProjectedEnrollment.db.deleteWhere(
      session,
      where: (_) => Constant.bool(true),
    );
    await ProjectedStudent.db.deleteWhere(
      session,
      where: (_) => Constant.bool(true),
    );
    await ProjectedCourse.db.deleteWhere(
      session,
      where: (_) => Constant.bool(true),
    );

    await ProjectedOrder.db.deleteWhere(
      session,
      where: (_) => Constant.bool(true),
    );
    await ProjectedUser.db.deleteWhere(
      session,
      where: (_) => Constant.bool(true),
    );
    await ProjectedAddress.db.deleteWhere(
      session,
      where: (_) => Constant.bool(true),
    );
    await ProjectedArticle.db.deleteWhere(
      session,
      where: (_) => Constant.bool(true),
    );
    await ProjectedAuthor.db.deleteWhere(
      session,
      where: (_) => Constant.bool(true),
    );
  });

  tearDown(() async {
    await ProjectedEnrollment.db.deleteWhere(
      session,
      where: (_) => Constant.bool(true),
    );
    await ProjectedStudent.db.deleteWhere(
      session,
      where: (_) => Constant.bool(true),
    );
    await ProjectedCourse.db.deleteWhere(
      session,
      where: (_) => Constant.bool(true),
    );

    await ProjectedOrder.db.deleteWhere(
      session,
      where: (_) => Constant.bool(true),
    );
    await ProjectedUser.db.deleteWhere(
      session,
      where: (_) => Constant.bool(true),
    );
    await ProjectedAddress.db.deleteWhere(
      session,
      where: (_) => Constant.bool(true),
    );
    await ProjectedArticle.db.deleteWhere(
      session,
      where: (_) => Constant.bool(true),
    );
    await ProjectedAuthor.db.deleteWhere(
      session,
      where: (_) => Constant.bool(true),
    );
  });

  test(
    'Given a projected user with a relation to a projected address when fetching using findFirstRow and including address with select then the resulting object is correctly populated (1:1 Object Relation).',
    () async {
      var address = await ProjectedAddress.db.insertRow(
        session,
        ProjectedAddress(street: 'Main Street', state: 'CA', country: 'USA'),
      );

      await ProjectedUser.db.insertRow(
        session,
        ProjectedUser(name: 'John', addressId: address.id!),
      );

      var result = await ProjectedUserStreetAddress.db.findFirstRow(
        session,
      );

      expect(result, isNotNull);
      expect(result?.name, 'John');
      expect(result?.address, isA<ProjectedAddressStreet>());
      expect(result?.address?.street, 'Main Street');
    },
  );

  test(
    'Given a projected user with a relation to projected orders when fetching using findFirstRow and including orders with select then the resulting list is correctly populated (1:n List Relation).',
    () async {
      var address = await ProjectedAddress.db.insertRow(
        session,
        ProjectedAddress(street: 'Main Street', state: 'CA', country: 'USA'),
      );

      var user = await ProjectedUser.db.insertRow(
        session,
        ProjectedUser(name: 'John', addressId: address.id!),
      );

      var orders = await ProjectedOrder.db.insert(session, [
        ProjectedOrder(description: 'Order 1', price: 10),
        ProjectedOrder(description: 'Order 2', price: 25),
      ]);

      await ProjectedUser.db.attach.orders(session, user, orders);

      var result = await ProjectedUserOrders.db.findFirstRow(
        session,
      );

      expect(result, isNotNull);
      expect(result?.name, 'John');
      expect(result?.orders, isA<List<ProjectedOrderDescription>?>());
      expect(result?.orders?.length, 2);
      expect(result?.orders?.first.description, 'Order 1');
    },
  );

  test(
    'Given a projected student with a many to many relation to projected courses when fetching using findFirstRow and including enrollments with select then the nested relations are correctly populated (n:n List Relation).',
    () async {
      var student = await ProjectedStudent.db.insertRow(
        session,
        ProjectedStudent(name: 'Alice'),
      );

      var course1 = await ProjectedCourse.db.insertRow(
        session,
        ProjectedCourse(name: 'Math 101'),
      );
      var course2 = await ProjectedCourse.db.insertRow(
        session,
        ProjectedCourse(name: 'History 201'),
      );

      await ProjectedEnrollment.db.insert(session, [
        ProjectedEnrollment(studentId: student.id!, courseId: course1.id!),
        ProjectedEnrollment(studentId: student.id!, courseId: course2.id!),
      ]);

      var result = await ProjectedStudentCourses.db.findFirstRow(
        session,
      );

      expect(result, isNotNull);
      expect(result?.name, 'Alice');
      expect(result?.enrollments, isA<List<ProjectedEnrollmentCourse>?>());
      expect(result?.enrollments?.length, 2);
      expect(result?.enrollments?.first.course?.name, 'Math 101');
      expect(result?.enrollments?.last.course?.name, 'History 201');
    },
  );

  test(
    'Given a projected user with a relation to a projected address when fetching using findFirstRow and using projection forwarding (.) then the nested field is correctly flattened into the object.',
    () async {
      var address = await ProjectedAddress.db.insertRow(
        session,
        ProjectedAddress(street: 'Main Street', state: 'CA', country: 'USA'),
      );

      await ProjectedUser.db.insertRow(
        session,
        ProjectedUser(name: 'John', addressId: address.id!),
      );

      var result = await ProjectedUserAddressStreetOnly.db.findFirstRow(
        session,
      );

      expect(result, isNotNull);
      expect(result?.name, 'John');
      expect(result?.addressStreet, 'Main Street');
    },
  );

  test(
    'Given an article with an author when fetching the article using a projection with author.name then the resulting object contains authorName.',
    () async {
      var author = await ProjectedAuthor.db.insertRow(
        session,
        ProjectedAuthor(
          name: 'Jane Doe',
          bio: 'Jane Doe\'s bio',
          email: 'janedoe@mail.com',
          phone: '8181094389',
        ),
      );

      await ProjectedArticle.db.insertRow(
        session,
        ProjectedArticle(
          title: 'My First Post',
          authorId: author.id!,
          summary: 'Summary of the post',
          content: 'The actual post content',
        ),
      );

      var result = await ProjectedArticleAuthorNameOnly.db.findFirstRow(
        session,
      );

      expect(result, isNotNull);
      expect(result?.title, 'My First Post');
      expect(result?.authorName, 'Jane Doe');
    },
  );
}
