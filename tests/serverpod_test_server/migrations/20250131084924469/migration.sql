BEGIN;

--
-- ACTION ALTER TABLE
--
ALTER TABLE "types" ADD COLUMN "aUri" text;
--
-- ACTION CREATE TABLE
--
CREATE TABLE "uri_default" (
    "id" bigserial PRIMARY KEY,
    "uriDefault" text NOT NULL DEFAULT 'https://serverpod.dev/default'::text,
    "uriDefaultNull" text DEFAULT 'https://serverpod.dev/default'::text
);

--
-- ACTION CREATE TABLE
--
CREATE TABLE "uri_default_mix" (
    "id" bigserial PRIMARY KEY,
    "uriDefaultAndDefaultModel" text NOT NULL DEFAULT 'https://serverpod.dev/default'::text,
    "uriDefaultAndDefaultPersist" text NOT NULL DEFAULT 'https://serverpod.dev/defaultPersist'::text,
    "uriDefaultModelAndDefaultPersist" text NOT NULL DEFAULT 'https://serverpod.dev/defaultPersist'::text
);

--
-- ACTION CREATE TABLE
--
CREATE TABLE "uri_default_model" (
    "id" bigserial PRIMARY KEY,
    "uriDefaultModel" text NOT NULL,
    "uriDefaultModelNull" text
);

--
-- ACTION CREATE TABLE
--
CREATE TABLE "uri_default_persist" (
    "id" bigserial PRIMARY KEY,
    "uriDefaultPersist" text DEFAULT 'https://serverpod.dev/'::text
);


--
-- MIGRATION VERSION FOR serverpod_test
--
INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
    VALUES ('serverpod_test', '20250131084924469', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20250131084924469', "timestamp" = now();

--
-- MIGRATION VERSION FOR serverpod_auth
--
INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
    VALUES ('serverpod_auth', '20240520102713718', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20240520102713718', "timestamp" = now();

--
-- MIGRATION VERSION FOR serverpod
--
INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
    VALUES ('serverpod', '20240516151843329', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20240516151843329', "timestamp" = now();

--
-- MIGRATION VERSION FOR serverpod_test_module
--
INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
    VALUES ('serverpod_test_module', '20241219152628926', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20241219152628926', "timestamp" = now();


COMMIT;
