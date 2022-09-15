/*
-----------------------------------------------------------------------
--   Patch 2022-09-15: Model Model q_infrastructure & q_publicservice simple
-----------------------------------------------------------------------

     search_path skal værdisættes, således at navnet på administrations schema er første parameter. 
     Hvis der ikke er ændret på standard navn for administrationsskema "fdc_admin"
     skal der ikke rettes i linjen

*/
SET search_path = fdc_admin, public;
--                *********

-- NIX PILLE VED RESTEN....................................................................................................

DELETE FROM parametre WHERE parent = 'q_infrastructure_new' OR name = 'q_infrastructure_new' OR "default" = 'q_infrastructure_new';
DELETE FROM parametre WHERE parent = 'q_infrastructure' OR name = 'q_infrastructure' OR "default" = 'q_infrastructure';

INSERT INTO parametre (name, parent, value, type, minval, maxval, lookupvalues, "default", explanation, sort, checkable) VALUES ('Oversvømmet infrastruktur'  , 'Kritisk infrastruktur', ''        , 'T', '', '', '', 'q_infrastructure', 'Udpegning af oversvømmet kritisk infrastruktur. Den berørte infrastruktur vises geografisk på et kort.  ', 10, 'T');
INSERT INTO parametre (name, parent, value, type, minval, maxval, lookupvalues, "default", explanation, sort, checkable) VALUES ('f_pkey_q_infrastructure'          , 'q_infrastructure' , 'objectid', 'T', '', '', '', '', 'Name of primary keyfield for query', 10, ' ');
INSERT INTO parametre (name, parent, value, type, minval, maxval, lookupvalues, "default", explanation, sort, checkable) VALUES ('f_geom_q_infrastructure'          , 'q_infrastructure' , 'geom'    , 'T', '', '', '', '', 'Field name for geometry column', 10, ' ');
INSERT INTO parametre (name, parent, value, type, minval, maxval, lookupvalues, "default", explanation, sort, checkable) VALUES ('q_infrastructure', 'Queries',
'
SELECT DISTINCT ON (o.{f_pkey_t_infrastructure}) 
    o.*,
    n.*,
    f.*
    FROM {t_infrastructure} o
    LATERAL (
        SELECT
            COUNT (*) AS cnt_oversvoem_nutid,
            COALESCE(SUM(st_area(st_intersection(o.{f_geom_t_infrastructure},{f_geom_Oversvømmelsesmodel, nutid}))),0)::NUMERIC(12,2) AS areal_oversvoem_nutid_m2,
            COALESCE(SUM(st_length(st_intersection(o.{f_geom_t_infrastructure},{f_geom_Oversvømmelsesmodel, nutid}))),0)::NUMERIC(12,2) AS laengde_oversvoem_nutid_m2,
            COALESCE(MIN({f_depth_Oversvømmelsesmodel, nutid}) * 100.00,0)::NUMERIC(12,2) AS min_vanddybde_nutid_cm,
            COALESCE(MAX({f_depth_Oversvømmelsesmodel, nutid}) * 100.00,0)::NUMERIC(12,2) AS max_vanddybde_nutid_cm,
            COALESCE(AVG({f_depth_Oversvømmelsesmodel, nutid}) * 100.00,0)::NUMERIC(12,2) AS avg_vanddybde_nutid_cm
        FROM {Oversvømmelsesmodel, nutid} WHERE {f_depth_Oversvømmelsesmodel, nutid} >= {Minimum vanddybde (meter)} AND st_intersects(o.{f_geom_t_infrastructure},{f_geom_Oversvømmelsesmodel, nutid}) 
    ) n,
    LATERAL (
        SELECT
            COUNT (*) AS cnt_oversvoem_fremtid,
            COALESCE(SUM(st_area(st_intersection(o.{f_geom_t_infrastructure},{f_geom_Oversvømmelsesmodel, fremtid}))),0)::NUMERIC(12,2) AS areal_oversvoem_fremtid_m2,
            COALESCE(SUM(st_length(st_intersection(o.{f_geom_t_infrastructure},{f_geom_Oversvømmelsesmodel, fremtid}))),0)::NUMERIC(12,2) AS laengde_oversvoem_fremtid_m2,
            COALESCE(MIN({f_depth_Oversvømmelsesmodel, fremtid}) * 100.00,0)::NUMERIC(12,2) AS min_vanddybde_fremtid_cm,
            COALESCE(MAX({f_depth_Oversvømmelsesmodel, fremtid}) * 100.00,0)::NUMERIC(12,2) AS max_vanddybde_fremtid_cm,
            COALESCE(AVG({f_depth_Oversvømmelsesmodel, fremtid}) * 100.00,0)::NUMERIC(12,2) AS avg_vanddybde_fremtid_cm
        FROM {Oversvømmelsesmodel, fremtid} WHERE {f_depth_Oversvømmelsesmodel, fremtid} >= {Minimum vanddybde (meter)} AND st_intersects(o.{f_geom_t_infrastructure},{f_geom_Oversvømmelsesmodel, fremtid}) 
    ) f
    WHERE f.cnt_oversvoem_fremtid > 0 OR n.cnt_oversvoem_nutid > 0
', 'P', '', '', '', '', 'SQL template for infrastructure new model ', 8, ' ');
	

DELETE FROM parametre WHERE parent = 'q_publicservice_new' OR name = 'q_publicservice_new' OR "default" = 'q_publicservice_new';
DELETE FROM parametre WHERE parent = 'q_publicservice' OR name = 'q_publicservice' OR "default" = 'q_publicservice';

INSERT INTO parametre (name, parent, value, type, minval, maxval, lookupvalues, "default", explanation, sort, checkable) VALUES ('Oversvømmet offentlig service'  , 'Offentlig service', ''      , 'T', '', '', '', 'q_publicservice', 'Udpegning af oversvømmet kritisk infrastruktur. Den berørte infrastruktur vises geografisk på et kort.  ', 10, 'T');
INSERT INTO parametre (name, parent, value, type, minval, maxval, lookupvalues, "default", explanation, sort, checkable) VALUES ('f_pkey_q_publicservice'          , 'q_publicservice' , 'objectid', 'T', '', '', '', '', 'Name of primary keyfield for query', 10, ' ');
INSERT INTO parametre (name, parent, value, type, minval, maxval, lookupvalues, "default", explanation, sort, checkable) VALUES ('f_geom_q_publicservice'          , 'q_publicservice' , 'geom'    , 'T', '', '', '', '', 'Field name for geometry column', 10, ' ');
INSERT INTO parametre (name, parent, value, type, minval, maxval, lookupvalues, "default", explanation, sort, checkable) VALUES ('q_publicservice', 'Queries',
'
SELECT DISTINCT ON (o.{f_pkey_t_publicservice}) 
    o.*,
    n.*,
    f.*
    FROM {t_publicservice} o
    LATERAL (
        SELECT
            COUNT (*) AS cnt_oversvoem_nutid,
            COALESCE(SUM(st_area(st_intersection(o.{f_geom_t_publicservice},{f_geom_Oversvømmelsesmodel, nutid}))),0)::NUMERIC(12,2) AS areal_oversvoem_nutid_m2,
            COALESCE(SUM(st_length(st_intersection(o.{f_geom_t_publicservice},{f_geom_Oversvømmelsesmodel, nutid}))),0)::NUMERIC(12,2) AS laengde_oversvoem_nutid_m2,
            COALESCE(MIN({f_depth_Oversvømmelsesmodel, nutid}) * 100.00,0)::NUMERIC(12,2) AS min_vanddybde_nutid_cm,
            COALESCE(MAX({f_depth_Oversvømmelsesmodel, nutid}) * 100.00,0)::NUMERIC(12,2) AS max_vanddybde_nutid_cm,
            COALESCE(AVG({f_depth_Oversvømmelsesmodel, nutid}) * 100.00,0)::NUMERIC(12,2) AS avg_vanddybde_nutid_cm
        FROM {Oversvømmelsesmodel, nutid} WHERE {f_depth_Oversvømmelsesmodel, nutid} >= {Minimum vanddybde (meter)} AND st_intersects(o.{f_geom_t_publicservice},{f_geom_Oversvømmelsesmodel, nutid}) 
    ) n,
    LATERAL (
        SELECT
            COUNT (*) AS cnt_oversvoem_fremtid,
            COALESCE(SUM(st_area(st_intersection(o.{f_geom_t_publicservice},{f_geom_Oversvømmelsesmodel, fremtid}))),0)::NUMERIC(12,2) AS areal_oversvoem_fremtid_m2,
            COALESCE(SUM(st_length(st_intersection(o.{f_geom_t_publicservice},{f_geom_Oversvømmelsesmodel, fremtid}))),0)::NUMERIC(12,2) AS laengde_oversvoem_fremtid_m2,
            COALESCE(MIN({f_depth_Oversvømmelsesmodel, fremtid}) * 100.00,0)::NUMERIC(12,2) AS min_vanddybde_fremtid_cm,
            COALESCE(MAX({f_depth_Oversvømmelsesmodel, fremtid}) * 100.00,0)::NUMERIC(12,2) AS max_vanddybde_fremtid_cm,
            COALESCE(AVG({f_depth_Oversvømmelsesmodel, fremtid}) * 100.00,0)::NUMERIC(12,2) AS avg_vanddybde_fremtid_cm
        FROM {Oversvømmelsesmodel, fremtid} WHERE {f_depth_Oversvømmelsesmodel, fremtid} >= {Minimum vanddybde (meter)} AND st_intersects(o.{f_geom_t_publicservice},{f_geom_Oversvømmelsesmodel, fremtid}) 
    ) f
    WHERE f.cnt_oversvoem_fremtid > 0 OR n.cnt_oversvoem_nutid > 0
', 'P', '', '', '', '', 'SQL template for public service new model ', 8, ' ');
	
-- Patch  2022-09-15: Model q_infrastructure & q_publicservice simple slut --