BEGIN;

--
-- ACTION CREATE TABLE
--
CREATE TABLE "generated_relation_company" (
    "id" bigserial PRIMARY KEY,
    "name" text NOT NULL
);

--
-- ACTION CREATE TABLE
--
CREATE TABLE "generated_relation_employee" (
    "id" bigserial PRIMARY KEY,
    "name" text NOT NULL,
    "customCompanyId" bigint NOT NULL,
    "customPreviousCompanyId" bigint
);

--
-- ACTION CREATE TABLE
--
CREATE TABLE "generated_relation_office" (
    "id" bigserial PRIMARY KEY,
    "address" text NOT NULL,
    "customCompanyId" bigint NOT NULL
);

-- Indexes
CREATE UNIQUE INDEX "generated_relation_office_company_unique_idx" ON "generated_relation_office" USING btree ("customCompanyId");

--
-- ACTION CREATE FOREIGN KEY
--
ALTER TABLE ONLY "generated_relation_employee"
    ADD CONSTRAINT "generated_relation_employee_fk_0"
    FOREIGN KEY("customCompanyId")
    REFERENCES "generated_relation_company"("id")
    ON DELETE NO ACTION
    ON UPDATE NO ACTION;
ALTER TABLE ONLY "generated_relation_employee"
    ADD CONSTRAINT "generated_relation_employee_fk_1"
    FOREIGN KEY("customPreviousCompanyId")
    REFERENCES "generated_relation_company"("id")
    ON DELETE NO ACTION
    ON UPDATE NO ACTION;

--
-- ACTION CREATE FOREIGN KEY
--
ALTER TABLE ONLY "generated_relation_office"
    ADD CONSTRAINT "generated_relation_office_fk_0"
    FOREIGN KEY("customCompanyId")
    REFERENCES "generated_relation_company"("id")
    ON DELETE NO ACTION
    ON UPDATE NO ACTION;


--
-- MIGRATION VERSION FOR serverpod_test
--
INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
    VALUES ('serverpod_test', '20260818135803417', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20260818135803417', "timestamp" = now();

--
-- MIGRATION VERSION FOR serverpod
--
INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
    VALUES ('serverpod', '20260416151914983-insights-perf', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20260416151914983-insights-perf', "timestamp" = now();

--
-- MIGRATION VERSION FOR serverpod_auth
--
INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
    VALUES ('serverpod_auth', '20260417182239578', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20260417182239578', "timestamp" = now();

--
-- MIGRATION VERSION FOR serverpod_test_module
--
INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
    VALUES ('serverpod_test_module', '20260417182416941', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20260417182416941', "timestamp" = now();

--
-- MIGRATION VERSION FOR serverpod_test_shared_module
--
INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
    VALUES ('serverpod_test_shared_module', '20260711022602028', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20260711022602028', "timestamp" = now();


COMMIT;
