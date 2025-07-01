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
CREATE TABLE "object_with_bit" (
    "id" bigserial PRIMARY KEY,
    "bit" bit(512) NOT NULL,
    "bitNullable" bit(512),
    "bitIndexedHnsw" bit(512) NOT NULL,
    "bitIndexedHnswWithParams" bit(512) NOT NULL,
    "bitIndexedIvfflat" bit(512) NOT NULL,
    "bitIndexedIvfflatWithParams" bit(512) NOT NULL
);

-- Indexes
CREATE INDEX "bit_index_default" ON "object_with_bit" USING hnsw ("bit" bit_hamming_ops);
CREATE INDEX "bit_index_hnsw" ON "object_with_bit" USING hnsw ("bitIndexedHnsw" bit_hamming_ops);
CREATE INDEX "bit_index_hnsw_with_params" ON "object_with_bit" USING hnsw ("bitIndexedHnswWithParams" bit_jaccard_ops) WITH (m=64, ef_construction=200);
CREATE INDEX "bit_index_ivfflat" ON "object_with_bit" USING ivfflat ("bitIndexedIvfflat" bit_hamming_ops);
CREATE INDEX "bit_index_ivfflat_with_params" ON "object_with_bit" USING ivfflat ("bitIndexedIvfflatWithParams" bit_hamming_ops) WITH (lists=300);

--
-- ACTION CREATE TABLE
--
CREATE TABLE "object_with_half_vector" (
    "id" bigserial PRIMARY KEY,
    "halfVector" halfvec(512) NOT NULL,
    "halfVectorNullable" halfvec(512),
    "halfVectorIndexedHnsw" halfvec(512) NOT NULL,
    "halfVectorIndexedHnswWithParams" halfvec(512) NOT NULL,
    "halfVectorIndexedIvfflat" halfvec(512) NOT NULL,
    "halfVectorIndexedIvfflatWithParams" halfvec(512) NOT NULL
);

-- Indexes
CREATE INDEX "half_vector_index_default" ON "object_with_half_vector" USING hnsw ("halfVector" halfvec_l2_ops);
CREATE INDEX "half_vector_index_hnsw" ON "object_with_half_vector" USING hnsw ("halfVectorIndexedHnsw" halfvec_l2_ops);
CREATE INDEX "half_vector_index_hnsw_with_params" ON "object_with_half_vector" USING hnsw ("halfVectorIndexedHnswWithParams" halfvec_l2_ops) WITH (m=64, ef_construction=200);
CREATE INDEX "half_vector_index_ivfflat" ON "object_with_half_vector" USING ivfflat ("halfVectorIndexedIvfflat" halfvec_l2_ops);
CREATE INDEX "half_vector_index_ivfflat_with_params" ON "object_with_half_vector" USING ivfflat ("halfVectorIndexedIvfflatWithParams" halfvec_cosine_ops) WITH (lists=300);

--
-- ACTION CREATE TABLE
--
CREATE TABLE "object_with_sparse_vector" (
    "id" bigserial PRIMARY KEY,
    "sparseVector" sparsevec(512) NOT NULL,
    "sparseVectorNullable" sparsevec(512),
    "sparseVectorIndexedHnsw" sparsevec(512) NOT NULL,
    "sparseVectorIndexedHnswWithParams" sparsevec(512) NOT NULL
);

-- Indexes
CREATE INDEX "sparse_vector_index_default" ON "object_with_sparse_vector" USING hnsw ("sparseVector" sparsevec_l2_ops);
CREATE INDEX "sparse_vector_index_hnsw" ON "object_with_sparse_vector" USING hnsw ("sparseVectorIndexedHnsw" sparsevec_l2_ops);
CREATE INDEX "sparse_vector_index_hnsw_with_params" ON "object_with_sparse_vector" USING hnsw ("sparseVectorIndexedHnswWithParams" sparsevec_l1_ops) WITH (m=64, ef_construction=200);

--
-- ACTION ALTER TABLE
--
DROP INDEX "vector_index_default";
DROP INDEX "vector_index_hnsw";
DROP INDEX "vector_index_hnsw_with_params";
DROP INDEX "vector_index_ivfflat";
DROP INDEX "vector_index_ivfflat_with_params";
CREATE INDEX "vector_index_default" ON "object_with_vector" USING hnsw ("vector" vector_l2_ops);
CREATE INDEX "vector_index_hnsw" ON "object_with_vector" USING hnsw ("vectorIndexedHnsw" vector_l2_ops);
CREATE INDEX "vector_index_hnsw_with_params" ON "object_with_vector" USING hnsw ("vectorIndexedHnswWithParams" vector_cosine_ops) WITH (m=64, ef_construction=200);
CREATE INDEX "vector_index_ivfflat" ON "object_with_vector" USING ivfflat ("vectorIndexedIvfflat" vector_l2_ops);
CREATE INDEX "vector_index_ivfflat_with_params" ON "object_with_vector" USING ivfflat ("vectorIndexedIvfflatWithParams" vector_ip_ops) WITH (lists=300);
--
-- ACTION ALTER TABLE
--
ALTER TABLE "types" ADD COLUMN "aHalfVector" halfvec(3);
ALTER TABLE "types" ADD COLUMN "aSparseVector" sparsevec(3);
ALTER TABLE "types" ADD COLUMN "aBit" bit(3);

--
-- MIGRATION VERSION FOR serverpod_test
--
INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
    VALUES ('serverpod_test', '20250608012916104', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20250608012916104', "timestamp" = now();

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
