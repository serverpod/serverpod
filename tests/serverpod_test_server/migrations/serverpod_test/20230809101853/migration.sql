BEGIN;

--
-- ACTION CREATE TABLE
--
CREATE TABLE "town" (
    "id" serial PRIMARY KEY,
    "name" text NOT NULL
);

--
-- ACTION CREATE TABLE
--
CREATE TABLE "company" (
    "id" serial PRIMARY KEY,
    "name" text NOT NULL,
    "townId" integer NOT NULL
);

-- Foreign keys
ALTER TABLE ONLY "company"
    ADD CONSTRAINT "company_fk_0"
    FOREIGN KEY("townId")
    REFERENCES "town"("id")
    ON DELETE CASCADE;

--
-- ACTION CREATE TABLE
--
CREATE TABLE "citizen" (
    "id" serial PRIMARY KEY,
    "name" text NOT NULL,
    "companyId" integer NOT NULL,
    "oldCompanyId" integer
);

-- Foreign keys
ALTER TABLE ONLY "citizen"
    ADD CONSTRAINT "citizen_fk_0"
    FOREIGN KEY("companyId")
    REFERENCES "company"("id")
    ON DELETE CASCADE;
ALTER TABLE ONLY "citizen"
    ADD CONSTRAINT "citizen_fk_1"
    FOREIGN KEY("oldCompanyId")
    REFERENCES "company"("id")
    ON DELETE CASCADE;

--
-- MIGRATION VERSION
--
INSERT INTO "serverpod_migrations" ("module", "version", "priority", "timestamp")
    VALUES ('serverpod_test', '20230809101853', 2, now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20230809101853', "priority" = 2;


COMMIT;
