BEGIN;

--
-- ACTION ALTER TABLE
--
ALTER TABLE "citizen" DROP CONSTRAINT "citizen_fk_2";
ALTER TABLE "citizen" DROP COLUMN "_companyEmployeesCompanyId";

--
-- MIGRATION VERSION FOR serverpod_test
--
INSERT INTO "serverpod_migrations" ("module", "version", "priority", "timestamp")
    VALUES ('serverpod_test', '20231006064104', 2, now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20231006064104', "priority" = 2;


COMMIT;
