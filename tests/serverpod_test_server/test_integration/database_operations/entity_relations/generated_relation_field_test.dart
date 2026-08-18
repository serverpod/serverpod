import 'package:serverpod/serverpod.dart';
import 'package:serverpod_test_server/src/generated/protocol.dart';
import 'package:test/test.dart';

import '../../test_tools/serverpod_test_tools.dart';

void main() {
  withServerpod(
    'Given a one-to-many relation with an auto-generated foreign key field,',
    (sessionBuilder, endpoints) {
      late Session session;
      late GeneratedRelationCompany company;
      late GeneratedRelationEmployee firstEmployee;
      late GeneratedRelationEmployee secondEmployee;

      setUp(() async {
        session = sessionBuilder.build();
        company = await GeneratedRelationCompany.db.insertRow(
          session,
          GeneratedRelationCompany(name: 'Serverpod'),
        );
        firstEmployee = await GeneratedRelationEmployee.db.insertRow(
          session,
          GeneratedRelationEmployee(
            name: 'Alex',
            customCompanyId: company.id!,
          ),
        );
        secondEmployee = await GeneratedRelationEmployee.db.insertRow(
          session,
          GeneratedRelationEmployee(
            name: 'Isak',
            customCompanyId: company.id!,
          ),
        );
      });

      group('when an employee is fetched including the company,', () {
        late GeneratedRelationEmployee? fetchedEmployee;

        setUp(() async {
          fetchedEmployee = await GeneratedRelationEmployee.db.findById(
            session,
            firstEmployee.id!,
            include: GeneratedRelationEmployee.include(
              company: GeneratedRelationCompany.include(),
            ),
          );
        });

        test('then the returned employee includes the related company.', () {
          expect(fetchedEmployee?.customCompanyId, company.id);
          expect(fetchedEmployee?.company?.id, company.id);
          expect(fetchedEmployee?.company?.name, 'Serverpod');
        });
      });

      group('when the company is fetched including the employees,', () {
        late GeneratedRelationCompany? fetchedCompany;

        setUp(() async {
          fetchedCompany = await GeneratedRelationCompany.db.findById(
            session,
            company.id!,
            include: GeneratedRelationCompany.include(
              employees: GeneratedRelationEmployee.includeList(),
            ),
          );
        });

        test('then the returned company includes the related employees.', () {
          expect(fetchedCompany?.employees, hasLength(2));
          expect(
            fetchedCompany?.employees?.map((employee) => employee.id),
            containsAll([firstEmployee.id, secondEmployee.id]),
          );
        });
      });
    },
  );

  withServerpod(
    'Given an optional relation with an auto-generated foreign key field that is unset,',
    (sessionBuilder, endpoints) {
      late Session session;
      late GeneratedRelationEmployee employee;

      setUp(() async {
        session = sessionBuilder.build();
        var company = await GeneratedRelationCompany.db.insertRow(
          session,
          GeneratedRelationCompany(name: 'Serverpod'),
        );
        employee = await GeneratedRelationEmployee.db.insertRow(
          session,
          GeneratedRelationEmployee(
            name: 'Alex',
            customCompanyId: company.id!,
          ),
        );
      });

      group(
        'when the employee is fetched including the previous company,',
        () {
          late GeneratedRelationEmployee? fetchedEmployee;

          setUp(() async {
            fetchedEmployee = await GeneratedRelationEmployee.db.findById(
              session,
              employee.id!,
              include: GeneratedRelationEmployee.include(
                previousCompany: GeneratedRelationCompany.include(),
              ),
            );
          });

          test('then the previous company is null.', () {
            expect(fetchedEmployee?.customPreviousCompanyId, isNull);
            expect(fetchedEmployee?.previousCompany, isNull);
          });
        },
      );
    },
  );

  withServerpod(
    'Given a one-to-one relation with an auto-generated foreign key field,',
    (sessionBuilder, endpoints) {
      late Session session;
      late GeneratedRelationCompany company;
      late GeneratedRelationOffice office;

      setUp(() async {
        session = sessionBuilder.build();
        company = await GeneratedRelationCompany.db.insertRow(
          session,
          GeneratedRelationCompany(name: 'Serverpod'),
        );
        office = await GeneratedRelationOffice.db.insertRow(
          session,
          GeneratedRelationOffice(
            address: 'Götgatan 3',
            customCompanyId: company.id!,
          ),
        );
      });

      group('when the office is fetched including the company,', () {
        late GeneratedRelationOffice? fetchedOffice;

        setUp(() async {
          fetchedOffice = await GeneratedRelationOffice.db.findById(
            session,
            office.id!,
            include: GeneratedRelationOffice.include(
              company: GeneratedRelationCompany.include(),
            ),
          );
        });

        test('then the returned office includes the related company.', () {
          expect(fetchedOffice?.customCompanyId, company.id);
          expect(fetchedOffice?.company?.id, company.id);
          expect(fetchedOffice?.company?.name, 'Serverpod');
        });
      });

      group('when the company is fetched including the office,', () {
        late GeneratedRelationCompany? fetchedCompany;

        setUp(() async {
          fetchedCompany = await GeneratedRelationCompany.db.findById(
            session,
            company.id!,
            include: GeneratedRelationCompany.include(
              office: GeneratedRelationOffice.include(),
            ),
          );
        });

        test('then the returned company includes the related office.', () {
          expect(fetchedCompany?.office?.id, office.id);
          expect(fetchedCompany?.office?.address, 'Götgatan 3');
        });
      });

      test(
        'when a second office is stored with the same foreign key, '
        'then the insert violates the unique index.',
        () async {
          var duplicateInsert = GeneratedRelationOffice.db.insertRow(
            session,
            GeneratedRelationOffice(
              address: 'Kungsgatan 4',
              customCompanyId: company.id!,
            ),
          );

          await expectLater(
            duplicateInsert,
            throwsA(
              isA<DatabaseUniqueViolationException>().having(
                (error) => error.code,
                'code',
                PgErrorCode.uniqueViolation,
              ),
            ),
          );
        },
      );
    },
  );

  withServerpod(
    'Given a one-to-many relation with the fk shorthand,',
    (sessionBuilder, endpoints) {
      late Session session;
      late FkRelationCompany company;
      late FkRelationEmployee firstEmployee;
      late FkRelationEmployee secondEmployee;

      setUp(() async {
        session = sessionBuilder.build();
        company = await FkRelationCompany.db.insertRow(
          session,
          FkRelationCompany(name: 'Serverpod'),
        );
        firstEmployee = await FkRelationEmployee.db.insertRow(
          session,
          FkRelationEmployee(
            name: 'Alex',
            companyId: company.id!,
          ),
        );
        secondEmployee = await FkRelationEmployee.db.insertRow(
          session,
          FkRelationEmployee(
            name: 'Isak',
            companyId: company.id!,
          ),
        );
      });

      group('when an employee is fetched including the company,', () {
        late FkRelationEmployee? fetchedEmployee;

        setUp(() async {
          fetchedEmployee = await FkRelationEmployee.db.findById(
            session,
            firstEmployee.id!,
            include: FkRelationEmployee.include(
              company: FkRelationCompany.include(),
            ),
          );
        });

        test('then the returned employee includes the related company.', () {
          expect(fetchedEmployee?.companyId, company.id);
          expect(fetchedEmployee?.company?.id, company.id);
          expect(fetchedEmployee?.company?.name, 'Serverpod');
        });
      });

      group('when the company is fetched including the employees,', () {
        late FkRelationCompany? fetchedCompany;

        setUp(() async {
          fetchedCompany = await FkRelationCompany.db.findById(
            session,
            company.id!,
            include: FkRelationCompany.include(
              employees: FkRelationEmployee.includeList(),
            ),
          );
        });

        test('then the returned company includes the related employees.', () {
          expect(fetchedCompany?.employees, hasLength(2));
          expect(
            fetchedCompany?.employees?.map((employee) => employee.id),
            containsAll([firstEmployee.id, secondEmployee.id]),
          );
        });
      });
    },
  );

  withServerpod(
    'Given an optional relation with the fk shorthand that is unset,',
    (sessionBuilder, endpoints) {
      late Session session;
      late FkRelationEmployee employee;

      setUp(() async {
        session = sessionBuilder.build();
        var company = await FkRelationCompany.db.insertRow(
          session,
          FkRelationCompany(name: 'Serverpod'),
        );
        employee = await FkRelationEmployee.db.insertRow(
          session,
          FkRelationEmployee(
            name: 'Alex',
            companyId: company.id!,
          ),
        );
      });

      group(
        'when the employee is fetched including the previous company,',
        () {
          late FkRelationEmployee? fetchedEmployee;

          setUp(() async {
            fetchedEmployee = await FkRelationEmployee.db.findById(
              session,
              employee.id!,
              include: FkRelationEmployee.include(
                previousCompany: FkRelationCompany.include(),
              ),
            );
          });

          test('then the previous company is null.', () {
            expect(fetchedEmployee?.previousCompanyId, isNull);
            expect(fetchedEmployee?.previousCompany, isNull);
          });
        },
      );
    },
  );

  withServerpod(
    'Given a one-to-one relation with the fk shorthand,',
    (sessionBuilder, endpoints) {
      late Session session;
      late FkRelationCompany company;
      late FkRelationOffice office;

      setUp(() async {
        session = sessionBuilder.build();
        company = await FkRelationCompany.db.insertRow(
          session,
          FkRelationCompany(name: 'Serverpod'),
        );
        office = await FkRelationOffice.db.insertRow(
          session,
          FkRelationOffice(
            address: 'Götgatan 3',
            companyId: company.id!,
          ),
        );
      });

      group('when the office is fetched including the company,', () {
        late FkRelationOffice? fetchedOffice;

        setUp(() async {
          fetchedOffice = await FkRelationOffice.db.findById(
            session,
            office.id!,
            include: FkRelationOffice.include(
              company: FkRelationCompany.include(),
            ),
          );
        });

        test('then the returned office includes the related company.', () {
          expect(fetchedOffice?.companyId, company.id);
          expect(fetchedOffice?.company?.id, company.id);
          expect(fetchedOffice?.company?.name, 'Serverpod');
        });
      });

      group('when the company is fetched including the office,', () {
        late FkRelationCompany? fetchedCompany;

        setUp(() async {
          fetchedCompany = await FkRelationCompany.db.findById(
            session,
            company.id!,
            include: FkRelationCompany.include(
              office: FkRelationOffice.include(),
            ),
          );
        });

        test('then the returned company includes the related office.', () {
          expect(fetchedCompany?.office?.id, office.id);
          expect(fetchedCompany?.office?.address, 'Götgatan 3');
        });
      });

      test(
        'when a second office is stored with the same foreign key, '
        'then the insert violates the unique index.',
        () async {
          var duplicateInsert = FkRelationOffice.db.insertRow(
            session,
            FkRelationOffice(
              address: 'Kungsgatan 4',
              companyId: company.id!,
            ),
          );

          await expectLater(
            duplicateInsert,
            throwsA(
              isA<DatabaseQueryException>().having(
                (error) => error.code,
                'code',
                PgErrorCode.uniqueViolation,
              ),
            ),
          );
        },
      );
    },
  );
}
