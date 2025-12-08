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
-- ACTION CREATE TABLE
--
CREATE TABLE "child_entity" (
    "id" bigserial PRIMARY KEY,
    "sharedField" text NOT NULL,
    "localField" text NOT NULL,
    "_parentEntityChildrenParentEntityId" bigint
);

--
-- ACTION CREATE TABLE
--
CREATE TABLE "child_table_with_inherited_id" (
    "id" uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    "grandParentField" text NOT NULL,
    "parentField" text NOT NULL,
    "childField" text NOT NULL
);

--
-- ACTION CREATE TABLE
--
CREATE TABLE "child_with_inherited_id" (
    "id" uuid PRIMARY KEY DEFAULT gen_random_uuid_v7(),
    "name" text NOT NULL,
    "parentId" uuid
);

--
-- ACTION CREATE TABLE
--
CREATE TABLE "immutable_object_with_table" (
    "id" bigserial PRIMARY KEY,
    "variable" text NOT NULL
);

--
-- ACTION CREATE TABLE
--
CREATE TABLE "model_with_required_field" (
    "id" bigserial PRIMARY KEY,
    "name" text NOT NULL,
    "email" text,
    "phone" text
);

--
-- ACTION CREATE TABLE
--
CREATE TABLE "parent_entity" (
    "id" bigserial PRIMARY KEY
);

--
-- ACTION CREATE TABLE
--
CREATE TABLE "server_only_changed_id_field_class" (
    "id" uuid PRIMARY KEY DEFAULT gen_random_uuid()
);

--
-- ACTION ALTER TABLE
--
ALTER TABLE "serverpod_session_log" ADD COLUMN "userId" text;
--
-- ACTION CREATE FOREIGN KEY
--
ALTER TABLE ONLY "child_entity"
    ADD CONSTRAINT "child_entity_fk_0"
    FOREIGN KEY("_parentEntityChildrenParentEntityId")
    REFERENCES "parent_entity"("id")
    ON DELETE NO ACTION
    ON UPDATE NO ACTION;

--
-- ACTION CREATE FOREIGN KEY
--
ALTER TABLE ONLY "child_with_inherited_id"
    ADD CONSTRAINT "child_with_inherited_id_fk_0"
    FOREIGN KEY("parentId")
    REFERENCES "child_with_inherited_id"("id")
    ON DELETE NO ACTION
    ON UPDATE NO ACTION;


--
-- MIGRATION VERSION FOR serverpod_test
--
INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
    VALUES ('serverpod_test', '20251208110444054-v3-0-0', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20251208110444054-v3-0-0', "timestamp" = now();

--
-- MIGRATION VERSION FOR serverpod
--
INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
    VALUES ('serverpod', '20251208110333922-v3-0-0', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20251208110333922-v3-0-0', "timestamp" = now();

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
    VALUES ('serverpod_test_module', '20241219152628926', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20241219152628926', "timestamp" = now();


COMMIT;
