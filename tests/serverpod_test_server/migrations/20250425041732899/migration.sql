BEGIN;

--
-- Function: gen_random_uuid_v7()
-- Source: https://gist.github.com/kjmph/5bd772b2c2df145aa645b837da7eca74
-- License: MIT (copyright notice included on the generator source code).
--
create or replace function gen_random_uuid_v7()
returns uuid
as $$
begin
  -- use random v4 uuid as starting point (which has the same variant we need)
  -- then overlay timestamp
  -- then set version 7 by flipping the 2 and 1 bit in the version 4 string
  return encode(
    set_bit(
      set_bit(
        overlay(uuid_send(gen_random_uuid())
                placing substring(int8send(floor(extract(epoch from clock_timestamp()) * 1000)::bigint) from 3)
                from 1 for 6
        ),
        52, 1
      ),
      53, 1
    ),
    'hex')::uuid;
end
$$
language plpgsql
volatile;

--
-- ACTION ALTER TABLE
--
ALTER TABLE "arena_uuid" ALTER COLUMN "id" SET DEFAULT gen_random_uuid_v7();
--
-- ACTION ALTER TABLE
--
ALTER TABLE "company_uuid" ALTER COLUMN "id" SET DEFAULT gen_random_uuid_v7();
--
-- ACTION ALTER TABLE
--
ALTER TABLE "course_uuid" ALTER COLUMN "id" SET DEFAULT gen_random_uuid_v7();
--
-- ACTION ALTER TABLE
--
ALTER TABLE "order_uuid" ALTER COLUMN "id" SET DEFAULT gen_random_uuid_v7();
--
-- ACTION ALTER TABLE
--
ALTER TABLE "uuid_default" ADD COLUMN "uuidDefaultRandomV7" uuid NOT NULL DEFAULT gen_random_uuid_v7();
--
-- ACTION DROP TABLE
--
DROP TABLE "uuid_default_model" CASCADE;

--
-- ACTION CREATE TABLE
--
CREATE TABLE "uuid_default_model" (
    "id" bigserial PRIMARY KEY,
    "uuidDefaultModelRandom" uuid NOT NULL,
    "uuidDefaultModelRandomV7" uuid NOT NULL,
    "uuidDefaultModelRandomNull" uuid,
    "uuidDefaultModelStr" uuid NOT NULL,
    "uuidDefaultModelStrNull" uuid
);

--
-- ACTION ALTER TABLE
--
ALTER TABLE "uuid_default_persist" ADD COLUMN "uuidDefaultPersistRandomV7" uuid DEFAULT gen_random_uuid_v7();

--
-- MIGRATION VERSION FOR serverpod_test
--
INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
    VALUES ('serverpod_test', '20250425041732899', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20250425041732899', "timestamp" = now();

--
-- MIGRATION VERSION FOR serverpod
--
INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
    VALUES ('serverpod', '20240516151843329', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20240516151843329', "timestamp" = now();

--
-- MIGRATION VERSION FOR serverpod_auth
--
INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
    VALUES ('serverpod_auth', '20240520102713718', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20240520102713718', "timestamp" = now();

--
-- MIGRATION VERSION FOR serverpod_test_module
--
INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
    VALUES ('serverpod_test_module', '20241219152628926', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20241219152628926', "timestamp" = now();


COMMIT;
