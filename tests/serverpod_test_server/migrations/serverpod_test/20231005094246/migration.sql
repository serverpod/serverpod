BEGIN;

--
-- ACTION CREATE TABLE
--
CREATE TABLE "city" (
    "id" serial PRIMARY KEY,
    "name" text NOT NULL
);

--
-- ACTION CREATE TABLE
--
CREATE TABLE "organization" (
    "id" serial PRIMARY KEY,
    "name" text NOT NULL
);

--
-- ACTION CREATE TABLE
--
CREATE TABLE "person" (
    "id" serial PRIMARY KEY,
    "name" text NOT NULL,
    "organizationId" integer,
    "_cityCitizensCityId" integer
);

--
-- ACTION CREATE FOREIGN KEY
--
--
-- ACTION CREATE FOREIGN KEY
--
--
-- ACTION CREATE FOREIGN KEY
--
ALTER TABLE ONLY "person"
    ADD CONSTRAINT "person_fk_0"
    FOREIGN KEY("organizationId")
    REFERENCES "organization"("id")
    ON DELETE CASCADE
    ON UPDATE NO ACTION;
ALTER TABLE ONLY "person"
    ADD CONSTRAINT "person_fk_1"
    FOREIGN KEY("_cityCitizensCityId")
    REFERENCES "city"("id")
    ON DELETE CASCADE
    ON UPDATE NO ACTION;


--
-- MIGRATION VERSION FOR serverpod_test
--
INSERT INTO "serverpod_migrations" ("module", "version", "priority", "timestamp")
    VALUES ('serverpod_test', '20231005094246', 2, now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20231005094246', "priority" = 2;


COMMIT;
