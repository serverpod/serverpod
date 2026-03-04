BEGIN;

--
-- ACTION CREATE TABLE
--
CREATE TABLE "shared_model_container" (
    "id" bigserial PRIMARY KEY,
    "sharedModel" json NOT NULL,
    "sharedModelWithModuleAlias" json NOT NULL,
    "sharedModelNullable" json,
    "serverOnlySharedModel" json,
    "sharedSubclass" json NOT NULL,
    "sharedSubclassNullable" json,
    "sharedEnum" text NOT NULL,
    "sharedEnumNullable" text,
    "sharedSealedParent" json NOT NULL,
    "sharedSealedParentNullable" json,
    "sharedSealedChild" json NOT NULL,
    "sharedSealedChildNullable" json,
    "sharedModelSubclass" json NOT NULL,
    "sharedModelSubclassNullable" json,
    "sharedModelList" json NOT NULL,
    "sharedModelNullableList" json NOT NULL,
    "sharedModelListNullable" json,
    "sharedModelMap" json NOT NULL,
    "sharedModelMapNullable" json,
    "sharedSubclassMap" json NOT NULL,
    "sharedModelSet" json NOT NULL,
    "sharedModelSetNullable" json
);


--
-- MIGRATION VERSION FOR serverpod_test
--
INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
    VALUES ('serverpod_test', '20260305002030445', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20260305002030445', "timestamp" = now();

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
