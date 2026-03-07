BEGIN;

--
-- ACTION CREATE TABLE
--
CREATE TABLE "unique_data_with_non_persist" (
    "id" bigserial PRIMARY KEY,
    "number" bigint NOT NULL,
    "email" text NOT NULL
);

-- Indexes
CREATE UNIQUE INDEX "unique_email_idx" ON "unique_data_with_non_persist" USING btree ("email");


--
-- MIGRATION VERSION FOR serverpod_test
--
INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
    VALUES ('serverpod_test', '20260219020242500', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20260219020242500', "timestamp" = now();

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
