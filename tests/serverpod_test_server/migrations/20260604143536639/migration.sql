BEGIN;

--
-- ACTION CREATE TABLE
--
CREATE TABLE "bleed_child" (
    "id" bigserial PRIMARY KEY,
    "bleedingText" text
);

--
-- ACTION CREATE TABLE
--
CREATE TABLE "bleed_root" (
    "id" bigserial PRIMARY KEY,
    "name" text NOT NULL,
    "firstChildId" bigint,
    "secondChildId" bigint
);

--
-- ACTION CREATE FOREIGN KEY
--
ALTER TABLE ONLY "bleed_root"
    ADD CONSTRAINT "bleed_root_fk_0"
    FOREIGN KEY("firstChildId")
    REFERENCES "bleed_child"("id")
    ON DELETE NO ACTION
    ON UPDATE NO ACTION;
ALTER TABLE ONLY "bleed_root"
    ADD CONSTRAINT "bleed_root_fk_1"
    FOREIGN KEY("secondChildId")
    REFERENCES "bleed_child"("id")
    ON DELETE NO ACTION
    ON UPDATE NO ACTION;


--
-- MIGRATION VERSION FOR serverpod_test
--
INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
    VALUES ('serverpod_test', '20260604143536639', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20260604143536639', "timestamp" = now();

--
-- MIGRATION VERSION FOR serverpod
--
INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
    VALUES ('serverpod', '20260129180959368', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20260129180959368', "timestamp" = now();

--
-- MIGRATION VERSION FOR serverpod_auth
--
INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
    VALUES ('serverpod_auth', '20260129181059877', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20260129181059877', "timestamp" = now();

--
-- MIGRATION VERSION FOR serverpod_test_module
--
INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
    VALUES ('serverpod_test_module', '20260129181225792', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20260129181225792', "timestamp" = now();


COMMIT;
