-- Setup result tables and sequence

SET search_path = fdc_results, public;

DROP VIEW  IF EXISTS used_parameters_view;
DROP TABLE IF EXISTS used_parameters;
DROP TABLE IF EXISTS used_models;
DROP TABLE IF EXISTS batches;
DROP SEQUENCE IF EXISTS id_numbers;

CREATE SEQUENCE IF NOT EXISTS id_numbers;

CREATE TABLE IF NOT EXISTS batches
(
    bid bigint NOT NULL DEFAULT nextval('fdc_results.id_numbers'),
    name character varying NOT NULL,
    run_at timestamp,
    no_models INT default 0,
    CONSTRAINT batches_pkey PRIMARY KEY (bid)
);

CREATE TABLE fdc_results.used_models
(
    mid bigint NOT NULL DEFAULT nextval('fdc_results.id_numbers'::regclass),
    bid bigint NOT NULL,
    table_name character varying COLLATE pg_catalog."default" NOT NULL,
    name character varying COLLATE pg_catalog."default" NOT NULL,
    no_rows integer,
    no_secs double precision,
    CONSTRAINT used_models_pkey PRIMARY KEY (mid)
);


CREATE TABLE IF NOT EXISTS used_parameters
(
    uid bigint NOT NULL DEFAULT nextval('fdc_results.id_numbers'),
    mid bigint NOT NULL,
    name character varying COLLATE pg_catalog."default" NOT NULL,
    value character varying COLLATE pg_catalog."default" NOT NULL,
    CONSTRAINT used_parameters_pkey PRIMARY KEY (uid)
);


CREATE OR REPLACE VIEW fdc_results.used_parameters_view
 AS
 SELECT b.bid,
    b.name AS batch_name,
    b.run_at,
    b.no_models,
    m.mid,
    m.table_name,
    m.name AS model_name,
    m.no_rows,
    m.no_secs,
    p.uid,
    p.name AS parameter_name,
    p.value
   FROM fdc_results.batches b
     LEFT JOIN fdc_results.used_models m ON b.bid = m.bid
     LEFT JOIN fdc_results.used_parameters p ON m.mid = p.mid
  ORDER BY b.bid, m.mid, p.uid;