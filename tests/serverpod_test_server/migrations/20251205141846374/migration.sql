BEGIN;

--
-- ACTION CREATE TABLE
--
CREATE TABLE "child_table_explicit_column" (
    "id" bigserial PRIMARY KEY,
    "non_table_parent_field" text NOT NULL,
    "child_field" text NOT NULL
);

--
-- ACTION CREATE TABLE
--
CREATE TABLE "contractor" (
    "id" bigserial PRIMARY KEY,
    "name" text NOT NULL,
    "fk_contractor_service_id" bigint
);

-- Indexes
CREATE UNIQUE INDEX "contractor_service_unique_idx" ON "contractor" USING btree ("fk_contractor_service_id");

--
-- ACTION CREATE TABLE
--
CREATE TABLE "department" (
    "id" bigserial PRIMARY KEY,
    "name" text NOT NULL
);

--
-- ACTION CREATE TABLE
--
CREATE TABLE "employee" (
    "id" bigserial PRIMARY KEY,
    "name" text NOT NULL,
    "fk_employee_department_id" bigint NOT NULL
);

--
-- ACTION CREATE TABLE
--
CREATE TABLE "modified_column_name" (
    "id" bigserial PRIMARY KEY,
    "originalColumn" text NOT NULL,
    "modified_column" text NOT NULL
);

--
-- ACTION CREATE TABLE
--
CREATE TABLE "service" (
    "id" bigserial PRIMARY KEY,
    "name" text NOT NULL,
    "description" text
);

--
-- ACTION CREATE TABLE
--
CREATE TABLE "table_with_explicit_column_names" (
    "id" bigserial PRIMARY KEY,
    "user_name" text NOT NULL,
    "user_description" text DEFAULT 'Just some information'::text
);

--
-- ACTION CREATE FOREIGN KEY
--
ALTER TABLE ONLY "contractor"
    ADD CONSTRAINT "contractor_fk_0"
    FOREIGN KEY("fk_contractor_service_id")
    REFERENCES "service"("id")
    ON DELETE NO ACTION
    ON UPDATE NO ACTION;

--
-- ACTION CREATE FOREIGN KEY
--
ALTER TABLE ONLY "employee"
    ADD CONSTRAINT "employee_fk_0"
    FOREIGN KEY("fk_employee_department_id")
    REFERENCES "department"("id")
    ON DELETE NO ACTION
    ON UPDATE NO ACTION;


--
-- MIGRATION VERSION FOR serverpod_test
--
INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
    VALUES ('serverpod_test', '20251205141846374', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20251205141846374', "timestamp" = now();

--
-- MIGRATION VERSION FOR serverpod
--
INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
    VALUES ('serverpod', '20250825102336032-v3-0-0', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20250825102336032-v3-0-0', "timestamp" = now();

--
-- MIGRATION VERSION FOR serverpod_auth
--
INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
    VALUES ('serverpod_auth', '20250825102351908-v3-0-0', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20250825102351908-v3-0-0', "timestamp" = now();

--
-- MIGRATION VERSION FOR serverpod_test_module
--
INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
    VALUES ('serverpod_test_module', '20250825102429343-v3-0-0', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20250825102429343-v3-0-0', "timestamp" = now();


COMMIT;
