--
-- Class ObjectFieldScopes as table object_field_scopes
--

CREATE TABLE "object_field_scopes" (
  "id" serial,
  "normal" text NOT NULL,
  "database" text
);

ALTER TABLE ONLY "object_field_scopes"
  ADD CONSTRAINT object_field_scopes_pkey PRIMARY KEY (id);


--
-- Class ObjectWithByteData as table object_with_bytedata
--

CREATE TABLE "object_with_bytedata" (
  "id" serial,
  "byteData" bytea NOT NULL
);

ALTER TABLE ONLY "object_with_bytedata"
  ADD CONSTRAINT object_with_bytedata_pkey PRIMARY KEY (id);


--
-- Class ObjectWithDuration as table object_with_duration
--

CREATE TABLE "object_with_duration" (
  "id" serial,
  "duration" bigint NOT NULL
);

ALTER TABLE ONLY "object_with_duration"
  ADD CONSTRAINT object_with_duration_pkey PRIMARY KEY (id);


--
-- Class ObjectWithEnum as table object_with_enum
--

CREATE TABLE "object_with_enum" (
  "id" serial,
  "testEnum" integer NOT NULL,
  "nullableEnum" integer,
  "enumList" json NOT NULL,
  "nullableEnumList" json NOT NULL,
  "enumListList" json NOT NULL
);

ALTER TABLE ONLY "object_with_enum"
  ADD CONSTRAINT object_with_enum_pkey PRIMARY KEY (id);


--
-- Class ObjectWithObject as table object_with_object
--

CREATE TABLE "object_with_object" (
  "id" serial,
  "data" json NOT NULL,
  "nullableData" json,
  "dataList" json NOT NULL,
  "nullableDataList" json,
  "listWithNullableData" json NOT NULL,
  "nullableListWithNullableData" json
);

ALTER TABLE ONLY "object_with_object"
  ADD CONSTRAINT object_with_object_pkey PRIMARY KEY (id);


--
-- Class ParentData as table parent_data
--

CREATE TABLE "parent_data" (
  "id" serial,
  "name" text NOT NULL
);

ALTER TABLE ONLY "parent_data"
  ADD CONSTRAINT parent_data_pkey PRIMARY KEY (id);


--
-- Class ChildData as table child_data
--

CREATE TABLE "child_data" (
  "id" serial,
  "description" text NOT NULL,
  "createdBy" integer NOT NULL,
  "modifiedBy" integer
);

ALTER TABLE ONLY "child_data"
  ADD CONSTRAINT child_data_pkey PRIMARY KEY (id);

ALTER TABLE ONLY "child_data"
  ADD CONSTRAINT child_data_fk_0
    FOREIGN KEY("createdBy")
      REFERENCES parent_data(id)
        ON DELETE CASCADE;
ALTER TABLE ONLY "child_data"
  ADD CONSTRAINT child_data_fk_1
    FOREIGN KEY("modifiedBy")
      REFERENCES parent_data(id)
        ON DELETE CASCADE;

--
-- Class SimpleData as table simple_data
--

CREATE TABLE "simple_data" (
  "id" serial,
  "num" integer NOT NULL
);

ALTER TABLE ONLY "simple_data"
  ADD CONSTRAINT simple_data_pkey PRIMARY KEY (id);


--
-- Class Types as table types
--

CREATE TABLE "types" (
  "id" serial,
  "anInt" integer,
  "aBool" boolean,
  "aDouble" double precision,
  "aDateTime" timestamp without time zone,
  "aString" text,
  "aByteData" bytea,
  "aDuration" bigint
);

ALTER TABLE ONLY "types"
  ADD CONSTRAINT types_pkey PRIMARY KEY (id);


