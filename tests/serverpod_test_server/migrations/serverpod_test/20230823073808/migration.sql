BEGIN;

--
-- ACTION CREATE TABLE
--
CREATE TABLE "citizen" (
    "id" serial PRIMARY KEY,
    "name" text NOT NULL,
    "companyId" integer NOT NULL,
    "oldCompanyId" integer
);

--
-- ACTION CREATE TABLE
--
CREATE TABLE "company" (
    "id" serial PRIMARY KEY,
    "name" text NOT NULL,
    "townId" integer NOT NULL
);

--
-- ACTION CREATE TABLE
--
CREATE TABLE "town" (
    "id" serial PRIMARY KEY,
    "name" text NOT NULL,
    "mayorId" integer
);

--
-- ACTION CREATE FOREIGN KEY
--
ALTER TABLE ONLY "citizen"
    ADD CONSTRAINT "citizen_fk_0"
    FOREIGN KEY("companyId")
    REFERENCES "company"("id")
    ON DELETE CASCADE
    ON UPDATE NO ACTION;
ALTER TABLE ONLY "citizen"
    ADD CONSTRAINT "citizen_fk_1"
    FOREIGN KEY("oldCompanyId")
    REFERENCES "company"("id")
    ON DELETE CASCADE
    ON UPDATE NO ACTION;

--
-- ACTION CREATE FOREIGN KEY
--
ALTER TABLE ONLY "company"
    ADD CONSTRAINT "company_fk_0"
    FOREIGN KEY("townId")
    REFERENCES "town"("id")
    ON DELETE CASCADE
    ON UPDATE NO ACTION;

--
-- ACTION CREATE FOREIGN KEY
--
ALTER TABLE ONLY "town"
    ADD CONSTRAINT "town_fk_0"
    FOREIGN KEY("mayorId")
    REFERENCES "citizen"("id")
    ON DELETE CASCADE
    ON UPDATE NO ACTION;

--
-- MIGRATION VERSION
--
INSERT INTO "serverpod_migrations" ("module", "version", "priority", "timestamp")
    VALUES ('serverpod_test', '20230823073808', 2, now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20230823073808', "priority" = 2;


COMMIT;
