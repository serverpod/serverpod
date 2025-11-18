BEGIN;

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
CREATE TABLE "service" (
    "id" bigserial PRIMARY KEY,
    "name" text NOT NULL,
    "description" text
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
-- MIGRATION VERSION FOR serverpod_test
--
INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
    VALUES ('serverpod_test', '20251118080114318', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20251118080114318', "timestamp" = now();

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
