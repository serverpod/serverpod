BEGIN;

--
-- ACTION CREATE TABLE
--
CREATE TABLE "address" (
    "id" serial PRIMARY KEY,
    "street" text NOT NULL,
    "inhabitantId" integer NOT NULL
);

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
CREATE TABLE "post" (
    "id" serial PRIMARY KEY,
    "content" text NOT NULL,
    "nextId" integer
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
ALTER TABLE ONLY "address"
    ADD CONSTRAINT "address_fk_0"
    FOREIGN KEY("inhabitantId")
    REFERENCES "citizen"("id")
    ON DELETE CASCADE
    ON UPDATE NO ACTION;

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
ALTER TABLE ONLY "post"
    ADD CONSTRAINT "post_fk_0"
    FOREIGN KEY("nextId")
    REFERENCES "post"("id")
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
    VALUES ('serverpod_test', '20230831155651', 2, now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20230831155651', "priority" = 2;


COMMIT;
