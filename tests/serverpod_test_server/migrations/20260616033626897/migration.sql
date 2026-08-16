BEGIN;

--
-- ACTION ALTER TABLE
--
DROP INDEX "code_unique_idx";
DROP INDEX "category_value_unique_idx";
CREATE UNIQUE INDEX "upsert_test_model__code__unique_idx" ON "upsert_test_model" USING btree ("code");
CREATE UNIQUE INDEX "upsert_test_model__category__value__unique_idx" ON "upsert_test_model" USING btree ("category", "value");

--
-- MIGRATION VERSION FOR serverpod_test
--
INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
    VALUES ('serverpod_test', '20260616033626897', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20260616033626897', "timestamp" = now();

--
-- MIGRATION VERSION FOR serverpod
--
INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
    VALUES ('serverpod', '20260416151914983-insights-perf', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20260416151914983-insights-perf', "timestamp" = now();

--
-- MIGRATION VERSION FOR serverpod_auth
--
INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
    VALUES ('serverpod_auth', '20260417182239578', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20260417182239578', "timestamp" = now();

--
-- MIGRATION VERSION FOR serverpod_test_module
--
INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
    VALUES ('serverpod_test_module', '20260417182416941', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20260417182416941', "timestamp" = now();


COMMIT;
