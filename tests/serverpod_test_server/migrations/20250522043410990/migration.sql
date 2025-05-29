BEGIN;

--
-- CREATE VECTOR EXTENSION IF AVAILABLE
--
DO $$
BEGIN
  IF EXISTS (SELECT 1 FROM pg_available_extensions WHERE name = 'vector') THEN
    EXECUTE 'CREATE EXTENSION IF NOT EXISTS vector';
  ELSE
    RAISE EXCEPTION 'Required extension "vector" is not available on this instance. Please install pgvector. For instructions, see https://docs.serverpod.dev/upgrading/upgrade-to-pgvector.';
  END IF;
END
$$;

--
-- ACTION CREATE TABLE
--
CREATE TABLE "object_with_vector" (
    "id" bigserial PRIMARY KEY,
    "vector" vector(512) NOT NULL,
    "vectorNullable" vector(512),
    "vectorIndexedHnsw" vector(512) NOT NULL,
    "vectorIndexedHnswWithParams" vector(512) NOT NULL,
    "vectorIndexedIvfflat" vector(512) NOT NULL,
    "vectorIndexedIvfflatWithParams" vector(512) NOT NULL
);

-- Indexes
CREATE INDEX "vector_index_default" ON "object_with_vector" USING hnsw ("vector" vector_l2_ops);
CREATE INDEX "vector_index_hnsw" ON "object_with_vector" USING hnsw ("vectorIndexedHnsw" vector_l2_ops);
CREATE INDEX "vector_index_hnsw_with_params" ON "object_with_vector" USING hnsw ("vectorIndexedHnswWithParams" vector_cosine_ops) WITH (m=64, ef_construction=200);
CREATE INDEX "vector_index_ivfflat" ON "object_with_vector" USING ivfflat ("vectorIndexedIvfflat" vector_l2_ops);
CREATE INDEX "vector_index_ivfflat_with_params" ON "object_with_vector" USING ivfflat ("vectorIndexedIvfflatWithParams" vector_ip_ops) WITH (lists=300);

--
-- ACTION ALTER TABLE
--
ALTER TABLE "types" ADD COLUMN "aVector" vector(3);

--
-- MIGRATION VERSION FOR serverpod_test
--
INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
    VALUES ('serverpod_test', '20250522043410990', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20250522043410990', "timestamp" = now();

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
