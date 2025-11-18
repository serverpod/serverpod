import 'package:serverpod/serverpod.dart' as pod;

import 'package:serverpod_test_server/src/generated/protocol.dart';
import 'package:serverpod_test_server/test_util/test_serverpod.dart';

import 'package:test/test.dart';

void main() async {
  final session = await IntegrationTestServer().session();

  /**
   * The structure of the data used in this test is as follows:
   * 
   * Department: {
   *   name: String,
   *   employees: Employee[],
   * }
   * 
   * Employee: {
   *   name: String,
   *   departmentId: int,
   * }
   */

  tearDown(() async {
    await Employee.db.deleteWhere(
      session,
      where: (t) => pod.Constant.bool(true),
    );
    await Department.db.deleteWhere(
      session,
      where: (t) => pod.Constant.bool(true),
    );
  });

  group(
    'Given a model wih an explicit column name on the foreign key field',
    () {
      test(
        'when fetching model including list relation then returned model '
        'has the attached data in the list relation.',
        () async {
          final department = await Department.db.insertRow(
            session,
            Department(name: 'departmentName'),
          );
          expect(department.id, isNotNull);

          final [employee1, employee2] = await Future.wait([
            Employee.db.insertRow(
              session,
              Employee(
                name: 'employee1',
                departmentId: department.id!,
              ),
            ),
            Employee.db.insertRow(
              session,
              Employee(
                name: 'employee2',
                departmentId: department.id!,
              ),
            ),
          ]);

          final departmentWithEmployees = await Department.db.findById(
            session,
            department.id!,
            include: Department.include(employees: Employee.includeList()),
          );

          expect(departmentWithEmployees?.employees, hasLength(2));
          final employeeIds = departmentWithEmployees?.employees?.map(
            (e) => e.id,
          );
          expect(employeeIds, containsAll([employee1.id, employee2.id]));
        },
      );
    },
  );
}
