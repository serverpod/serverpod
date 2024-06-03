BEGIN;

--
-- ACTION CREATE TABLE
--
CREATE TABLE "empty_model" (
    "id" bigserial PRIMARY KEY
);

--
-- ACTION CREATE TABLE
--
CREATE TABLE "empty_model_relation_item" (
    "id" bigserial PRIMARY KEY,
    "name" text NOT NULL,
    "_emptyModelItemsEmptyModelId" bigint
);

--
-- ACTION ALTER TABLE
--
ALTER TABLE "serverpod_user_info" ALTER COLUMN "userName" DROP NOT NULL;
--
-- ACTION CREATE FOREIGN KEY
--
ALTER TABLE ONLY "empty_model_relation_item"
    ADD CONSTRAINT "empty_model_relation_item_fk_0"
    FOREIGN KEY("_emptyModelItemsEmptyModelId")
    REFERENCES "empty_model"("id")
    ON DELETE NO ACTION
    ON UPDATE NO ACTION;


--
-- MIGRATION VERSION FOR serverpod_test
--
INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
    VALUES ('serverpod_test', '20240603145858809', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20240603145858809', "timestamp" = now();

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
    VALUES ('serverpod_test_module', '20240115074247714', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20240115074247714', "timestamp" = now();


COMMIT;
