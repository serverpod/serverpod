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

  test(
    'Given a projected user with a json projected field when fetching using findFirstRow and using projection forwarding (.) then the nested json field is correctly flattened into the object.',
    () async {
      var address = await ProjectedAddress.db.insertRow(
        session,
        ProjectedAddress(street: 'Main Street', state: 'CA', country: 'USA'),
      );

      await ProjectedUser.db.insertRow(
        session,
        ProjectedUser(
          name: 'John',
          addressId: address.id!,
          jsonField: ProjectedJsonField(
            text: 'text',
            value: 1,
            valueA: true,
            valueB: 2.1,
            list: ['John Doe', 'Jane Doe'],
            listA: [1, 2, 5, 4, 9],
            listB: [true, false, true, false],
            listC: [1.2, 3.2, 5.34, 6.78],
            listD: ['Hello', 'World'],
            map: {'text': 'Discount Text', 'value': '50% off'},
            mapA: {'min': 1, 'max': 100},
            mapB: {'mute': true, 'video': false},
            mapC: {'amount': 1.4, 'discount': 0.2},
            dateValue: DateTime.now(),
          ),
        ),
      );

      var result = await ProjectedUserJsonField.db.findFirstRow(
        session,
      );

      expect(result, isNotNull);
      expect(result?.name, 'John');
      expect(result?.jsonFieldText, 'text');
    },
  );

  test(
    'Given a projected user with multiple json projected fields when fetching using findFirstRow then multiple nested json fields are flattened into the object.',
    () async {
      var address = await ProjectedAddress.db.insertRow(
        session,
        ProjectedAddress(street: 'Main Street', state: 'CA', country: 'USA'),
      );

      await ProjectedUser.db.insertRow(
        session,
        ProjectedUser(
          name: 'Alice',
          addressId: address.id!,
          jsonField: ProjectedJsonField(
            text: 'sample text',
            value: 42,
            valueA: true,
            valueB: 3.14,
            list: ['John Doe', 'Jane Doe', 'Bob Smith'],
            listA: [1, 42, 99, 3],
            listB: [true, false, false],
            listC: [0.1, 0.2, 0.3, 0.4, 0.5, 0.6, 0.7, 0.8, 0.9],
            listD: ['Hello', 'World', 'Test'],
            map: {'text': 'Discount Text', 'value': '50% off'},
            mapA: {'discount': 50, 'amount': 200},
            mapB: {'mute': true, 'video': false},
            mapC: {'amount': 1.4, 'discount': 0.2},
            dateValue: DateTime.now(),
          ),
        ),
      );

      var result = await ProjectedUserJsonMultiField.db.findFirstRow(
        session,
      );

      expect(result, isNotNull);
      expect(result?.name, 'Alice');
      expect(result?.jsonFieldText, 'sample text');
      expect(result?.jsonFieldValue, 42);
      expect(result?.jsonFieldMapA, {'discount': 50, 'amount': 200});
      expect(result?.jsonFieldListA, [1, 42, 99, 3]);
      expect(result?.jsonFieldDateValue, isA<DateTime>());
    },
  );

  test(
    'Given a projected user with a sub-projected json model (->) when fetching using findFirstRow then the sub-projected json model is correctly deserialized.',
    () async {
      var address = await ProjectedAddress.db.insertRow(
        session,
        ProjectedAddress(street: 'Main Street', state: 'CA', country: 'USA'),
      );

      await ProjectedUser.db.insertRow(
        session,
        ProjectedUser(
          name: 'Bob',
          addressId: address.id!,
          jsonField: ProjectedJsonField(
            text: 'sub-projected',
            value: 99,
            valueA: false,
            valueB: 1.0,
            list: [],
            listA: [],
            listB: [],
            listC: [],
            listD: [],
            map: {},
            mapA: {},
            mapB: {},
            mapC: {},
            dateValue: DateTime.now(),
          ),
        ),
      );

      var result = await ProjectedUserSimpleJson.db.findFirstRow(
        session,
      );

      expect(result, isNotNull);
      expect(result?.name, 'Bob');
      expect(result?.jsonField, isA<ProjectedJsonFieldSimple>());
      expect(result?.jsonField?.text, 'sub-projected');
      expect(result?.jsonField?.value, 99);
    },
  );

  test(
    'Given a projected user with a null json field when fetching using findFirstRow then the flattened json field is null.',
    () async {
      var address = await ProjectedAddress.db.insertRow(
        session,
        ProjectedAddress(street: 'Main Street', state: 'CA', country: 'USA'),
      );

      await ProjectedUser.db.insertRow(
        session,
        ProjectedUser(
          name: 'Charlie',
          addressId: address.id!,
          jsonField: null,
        ),
      );

      var result = await ProjectedUserJsonField.db.findFirstRow(
        session,
      );

      expect(result, isNotNull);
      expect(result?.name, 'Charlie');
      expect(result?.jsonFieldText, isNull);
    },
  );
}
