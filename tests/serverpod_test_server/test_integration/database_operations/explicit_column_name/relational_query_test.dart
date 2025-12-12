import 'package:serverpod/serverpod.dart' as pod;

import 'package:serverpod_test_server/src/generated/protocol.dart';

import 'package:test/test.dart';

import '../../test_tools/serverpod_test_tools.dart';

void main() async {
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
   * 
   * Contractor: {
   *   name: String,
   *   serviceIdField: int,
   * }
   * 
   * Service: {
   *   name: String,
   * }
   */

  withServerpod(
    'Given a model wih an explicit column name on the foreign key field',
    (
      final sessionBuilder,
      final endpoints,
    ) {
      late pod.Session session;

      setUp(() async {
        session = sessionBuilder.build();
      });
      tearDown(() async {
        await Employee.db.deleteWhere(
          session,
          where: (t) => pod.Constant.bool(true),
        );
        await Department.db.deleteWhere(
          session,
          where: (t) => pod.Constant.bool(true),
        );
        await Contractor.db.deleteWhere(
          session,
          where: (t) => pod.Constant.bool(true),
        );
        await Service.db.deleteWhere(
          session,
          where: (t) => pod.Constant.bool(true),
        );
      });
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

      test(
        'when fetching model including object relation then returned model '
        'has the attached data in the object relation.',
        () async {
          final service = await Service.db.insertRow(
            session,
            Service(name: 'serviceName'),
          );
          expect(service.id, isNotNull);

          final contractor = await Contractor.db.insertRow(
            session,
            Contractor(
              name: 'contractorName',
              serviceIdField: service.id,
            ),
          );

          final contractorWithService = await Contractor.db.findById(
            session,
            contractor.id!,
            include: Contractor.include(service: Service.include()),
          );

          expect(contractorWithService?.service?.name, 'serviceName');
          expect(contractorWithService?.service?.id, service.id);
        },
      );
    },
  );
}
