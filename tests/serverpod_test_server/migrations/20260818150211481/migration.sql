BEGIN;

--
-- ACTION CREATE TABLE
--
CREATE TABLE "fk_relation_company" (
    "id" bigserial PRIMARY KEY,
    "name" text NOT NULL
);

--
-- ACTION CREATE TABLE
--
CREATE TABLE "fk_relation_employee" (
    "id" bigserial PRIMARY KEY,
    "name" text NOT NULL,
    "companyId" bigint NOT NULL,
    "previousCompanyId" bigint
);

--
-- ACTION CREATE TABLE
--
CREATE TABLE "fk_relation_office" (
    "id" bigserial PRIMARY KEY,
    "address" text NOT NULL,
    "companyId" bigint NOT NULL
);

-- Indexes
CREATE UNIQUE INDEX "fk_relation_office_company_unique_idx" ON "fk_relation_office" USING btree ("companyId");

--
-- ACTION CREATE FOREIGN KEY
--
ALTER TABLE ONLY "fk_relation_employee"
    ADD CONSTRAINT "fk_relation_employee_fk_0"
    FOREIGN KEY("companyId")
    REFERENCES "fk_relation_company"("id")
    ON DELETE NO ACTION
    ON UPDATE NO ACTION;
ALTER TABLE ONLY "fk_relation_employee"
    ADD CONSTRAINT "fk_relation_employee_fk_1"
    FOREIGN KEY("previousCompanyId")
    REFERENCES "fk_relation_company"("id")
    ON DELETE NO ACTION
    ON UPDATE NO ACTION;

--
-- ACTION CREATE FOREIGN KEY
--
ALTER TABLE ONLY "fk_relation_office"
    ADD CONSTRAINT "fk_relation_office_fk_0"
    FOREIGN KEY("companyId")
    REFERENCES "fk_relation_company"("id")
    ON DELETE NO ACTION
    ON UPDATE NO ACTION;


--
-- MIGRATION VERSION FOR serverpod_test
--
INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
    VALUES ('serverpod_test', '20260818150211481', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20260818150211481', "timestamp" = now();

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
