/* 
-----------------------------------------------------------------------
--   Patch 2022-02-03: Indføresle af tabel og felt selektor
-----------------------------------------------------------------------

     search_path skal værdisættes, således at navnet på administrations schema er første parameter. 
     Hvis der ikke er ændret på standard navn for administrationsskema "fdc_admin"
     skal der ikke rettes i linjen

*/
SET search_path = fdc_admin, public;
--                *********

-- NIX PILLE VED RESTEN....................................................................................................

-- Opdatér rækker i faneblad "Data" hvor navn starter med 't_", dvs tabel entries
update parametre set "type" = 'S' 
  where "name" like 't_%' and parent in ('Data', 'Admin data', 'Flood data', 'Sector data') and "type" = 'T';

-- Opdatér rækker i faneblad "Data" hvor navn starter med 'f_", dvs f entries, og hvor parent er med i 1. opdatering
update parametre set "type" = 'F' 
  where "name" like 'f_%' and parent in (select name from fdc_admin.parametre where "name" like 't_%' and parent in ('Data', 'Admin data', 'Flood data', 'Sector data') and "type" = 'S');

-- Patch 2022-02-03: Indføresle af tabel og felt selektor --


DELETE FROM parametre WHERE name='Returperiode for hændelse i fremtiden (år)';
DELETE FROM parametre WHERE name='Returperiode for hændelse i dag (år)';

DELETE FROM parametre WHERE parent = 'q_tourism_alphanumeric' OR name = 'q_tourism_alphanumeric' OR "default" = 'q_tourism_alphanumeric';
DELETE FROM parametre WHERE parent = 'q_bioscore_alphanumeric' OR name = 'q_bioscore_alphanumeric' OR "default" = 'q_bioscore_alphanumeric';



/* 
-----------------------------------------------------------------------
--   Patch 2022-02-26: Model q_building_new (2. time)
-----------------------------------------------------------------------

     search_path skal værdisættes, således at navnet på administrations schema er første parameter. 
     Hvis der ikke er ændret på standard navn for administrationsskema "fdc_admin"
     skal der ikke rettes i linjen

*/



SET search_path = fdc_admin, public;
--                *********
DELETE FROM parametre WHERE name='Oversvømmelsesmodel, fremtid';
DELETE FROM parametre WHERE name='Oversvømmelsesmodel, nutid';
DELETE FROM parametre WHERE name='Returperiode, antal år';

INSERT INTO parametre (name, parent, value, type, minval, maxval, lookupvalues, "default", explanation, sort, checkable) VALUES ('Oversvømmelsesmodel, nutid', 'Generelle modelværdier', 'fdc_data.oversvoem', 'Q', '', '', 't_flood', 't_flood', 'Vælg oversvømmelsestabel for nutidshændelse', 12, ' ');
INSERT INTO parametre (name, parent, value, type, minval, maxval, lookupvalues, "default", explanation, sort, checkable) VALUES ('Oversvømmelsesmodel, fremtid', 'Generelle modelværdier', 'fdc_data.oversvoem', 'Q', '', '', 't_flood', 't_flood', 'Vælg oversvømmelsestabel for fremtidshændelse', 13, ' ');
INSERT INTO fdc_admin.parametre (name, parent, value, type, minval, maxval, lookupvalues, "default", explanation, sort, checkable) VALUES ('Returperiode, antal år', 'Generelle modelværdier', '100', 'I', '0', '1000', '10', '', 'Indtast returperioden i hele år, dvs. gennemsnitligt antal år mellem hændelser (Nutidshændelse og fremtidshændelse skal have samme returperiode)', 14, ' ');

UPDATE parametre SET parent = 'Bygninger' WHERE name = 'Skadeberegning for kælder';
UPDATE parametre SET parent = 'Bygninger' WHERE name = 'Skadetype';

/* 
-----------------------------------------------------------------------
--   Patch 2022-02-26: Model q_building_new (2. time)
-----------------------------------------------------------------------

     search_path skal værdisættes, således at navnet på administrations schema er første parameter. 
     Hvis der ikke er ændret på standard navn for administrationsskema "fdc_admin"
     skal der ikke rettes i linjen

*/

SET search_path = fdc_admin, public;
--                *********

-- NIX PILLE VED RESTEN....................................................................................................

DELETE FROM parametre WHERE parent = 'q_building_new' OR name = 'q_building_new' OR "default" = 'q_building_new';
DELETE FROM parametre WHERE parent = 'q_building' OR name = 'q_building' OR "default" = 'q_building';

INSERT INTO parametre (name, parent, value, type, minval, maxval, lookupvalues, "default", explanation, sort, checkable) VALUES ('Skadeberegninger, Bygninger', 'Bygninger', '', 'T', '', '', '', 'q_building', 'Skadeberegning for bygninger, forskellige skademodeller, med eller uden kælderberegning, ny metode', 11, 'T');
INSERT INTO parametre (name, parent, value, type, minval, maxval, lookupvalues, "default", explanation, sort, checkable) VALUES ('f_pkey_q_building'                  , 'q_building', 'objectid'                      , 'T', '', '', '', '', 'Name of primary keyfield for query', 10, ' ');
INSERT INTO parametre (name, parent, value, type, minval, maxval, lookupvalues, "default", explanation, sort, checkable) VALUES ('f_geom_q_building'                  , 'q_building', 'geom'                          , 'T', '', '', '', '', 'Field name for geometry column', 10, ' ');
INSERT INTO parametre (name, parent, value, type, minval, maxval, lookupvalues, "default", explanation, sort, checkable) VALUES ('f_damage_present_q_building'        , 'q_building', 'skadebeloeb_nutid_kr'          , 'T', '', '', '', '', '', 1, 'T');
INSERT INTO parametre (name, parent, value, type, minval, maxval, lookupvalues, "default", explanation, sort, checkable) VALUES ('f_damage_future_q_building'         , 'q_building', 'skadebeloeb_fremtid_kr'        , 'T', '', '', '', '', '', 1, 'T');
INSERT INTO parametre (name, parent, value, type, minval, maxval, lookupvalues, "default", explanation, sort, checkable) VALUES ('f_damage_cellar_present_q_building' , 'q_building', 'skadebeloeb_kaelder_nutid_kr'  , 'T', '', '', '', '', '', 1, 'T');
INSERT INTO parametre (name, parent, value, type, minval, maxval, lookupvalues, "default", explanation, sort, checkable) VALUES ('f_damage_cellar_future_q_building'  , 'q_building', 'skadebeloeb_kaelder_fremtid_kr', 'T', '', '', '', '', '', 1, 'T');
INSERT INTO parametre (name, parent, value, type, minval, maxval, lookupvalues, "default", explanation, sort, checkable) VALUES ('f_loss_present_q_building'          , 'q_building', 'vaerditab_nutid_kr'            , 'T', '', '', '', '', '', 1, 'T');
INSERT INTO parametre (name, parent, value, type, minval, maxval, lookupvalues, "default", explanation, sort, checkable) VALUES ('f_loss_future_q_building'           , 'q_building', 'vaerditab_fremtid_kr'          , 'T', '', '', '', '', '', 1, 'T');
INSERT INTO parametre (name, parent, value, type, minval, maxval, lookupvalues, "default", explanation, sort, checkable) VALUES ('f_risk_q_building'                  , 'q_building', 'risiko_kr'                     , 'T', '', '', '', '', '', 1, 'T');
INSERT INTO parametre (name, parent, value, type, minval, maxval, lookupvalues, "default", explanation, sort, checkable) VALUES ('q_building', 'Queries', 
'
SELECT
    b.*,
    d.{f_category_t_damage} AS skade_kategori,
    d.{f_type_t_damage} AS skade_type,
	''{Skadeberegning for kælder}'' AS kaelder_beregning,
    {Værditab, skaderamte bygninger (%)}::NUMERIC(12,2) as tab_procent,
    k.{f_sqmprice_t_sqmprice}::NUMERIC(12,2) as kvm_pris_kr,
    st_area(b.{f_geom_t_building})::NUMERIC(12,2) AS areal_byg_m2,
    n.*,
    f.*,
    r.*
    FROM {t_building} b
    LEFT JOIN {t_build_usage} u on b.{f_usage_code_t_building} = u.{f_pkey_t_build_usage}
    LEFT JOIN {t_damage} d on u.{f_category_t_build_usage} = d.{f_category_t_damage} AND d.{f_type_t_damage} = ''{Skadetype}''   
    LEFT JOIN {t_sqmprice} k on (b.{f_muncode_t_building} = k.{f_muncode_t_sqmprice}),
    LATERAL (
        SELECT
            COUNT (*) AS cnt_oversvoem_nutid,
            COALESCE(SUM(st_area(st_intersection(b.{f_geom_t_building},{f_geom_Oversvømmelsesmodel, nutid}))),0)::NUMERIC(12,2) AS areal_oversvoem_nutid_m2,
            COALESCE(MIN({f_depth_Oversvømmelsesmodel, nutid}) * 100.00,0)::NUMERIC(12,2) AS min_vanddybde_nutid_cm,
            COALESCE(MAX({f_depth_Oversvømmelsesmodel, nutid}) * 100.00,0)::NUMERIC(12,2) AS max_vanddybde_nutid_cm,
            COALESCE(AVG({f_depth_Oversvømmelsesmodel, nutid}) * 100.00,0)::NUMERIC(12,2) AS avg_vanddybde_nutid_cm,
            CASE WHEN COUNT (*) > 0 THEN d.b0 + st_area(b.{f_geom_t_building}) * (d.b1 * ln(GREATEST(MAX({f_depth_Oversvømmelsesmodel, nutid})*100.00, 1.0)) + d.b2) ELSE 0 END::NUMERIC(12,2) AS {f_damage_present_q_building},
            CASE WHEN COUNT (*) > 0 AND ''{Skadeberegning for kælder}'' = ''Medtages'' THEN COALESCE(b.{f_cellar_area_t_building},0.0) * d.c0 ELSE 0 END::NUMERIC(12,2) as {f_damage_cellar_present_q_building},
            CASE WHEN COUNT (*) > 0 THEN k.kvm_pris * st_area(b.{f_geom_t_building}) * {Værditab, skaderamte bygninger (%)}/100.0 ELSE 0 END::NUMERIC(12,2) as {f_loss_present_q_building}             
        FROM {Oversvømmelsesmodel, nutid} WHERE st_intersects(b.{f_geom_t_building},{f_geom_Oversvømmelsesmodel, nutid}) AND {f_depth_Oversvømmelsesmodel, nutid} >= {Minimum vanddybde (meter)}
    ) n,
    LATERAL (
        SELECT
            COUNT (*) AS cnt_oversvoem_fremtid,
            COALESCE(SUM(st_area(st_intersection(b.{f_geom_t_building},{f_geom_Oversvømmelsesmodel, fremtid}))),0)::NUMERIC(12,2) AS areal_oversvoem_fremtid_m2,
            COALESCE(MIN({f_depth_Oversvømmelsesmodel, fremtid}) * 100.00,0)::NUMERIC(12,2) AS min_vanddybde_fremtid_cm,
            COALESCE(MAX({f_depth_Oversvømmelsesmodel, fremtid}) * 100.00,0)::NUMERIC(12,2) AS max_vanddybde_fremtid_cm,
            COALESCE(AVG({f_depth_Oversvømmelsesmodel, fremtid}) * 100.00,0)::NUMERIC(12,2) AS avg_vanddybde_fremtid_cm,
            CASE WHEN COUNT (*) > 0 THEN d.b0 + st_area(b.{f_geom_t_building}) * (d.b1 * ln(GREATEST(MAX({f_depth_Oversvømmelsesmodel, fremtid})*100.00, 1.0)) + d.b2) ELSE 0 END::NUMERIC(12,2) AS {f_damage_future_q_building},
            CASE WHEN COUNT (*) > 0 AND ''{Skadeberegning for kælder}'' = ''Medtages'' THEN COALESCE(b.{f_cellar_area_t_building},0.0) * d.c0 ELSE 0 END::NUMERIC(12,2) as {f_damage_cellar_future_q_building},
            CASE WHEN COUNT (*) > 0 THEN k.kvm_pris * st_area(b.{f_geom_t_building}) * {Værditab, skaderamte bygninger (%)}/100.0 ELSE 0 END::NUMERIC(12,2) as {f_loss_future_q_building}                
        FROM {Oversvømmelsesmodel, fremtid} WHERE st_intersects(b.{f_geom_t_building},{f_geom_Oversvømmelsesmodel, fremtid}) AND {f_depth_Oversvømmelsesmodel, fremtid} >= {Minimum vanddybde (meter)}
    ) f,
    LATERAL (
        SELECT
          ''{Medtag i risikoberegninger}'' AS risiko_beregning,
		  {Returperiode, antal år} AS retur_periode,
          ((0.219058829 * CASE
          WHEN ''{Medtag i risikoberegninger}'' = ''Intet (0 kr.)'' THEN 0.0
          WHEN ''{Medtag i risikoberegninger}'' = ''Skadebeløb'' THEN n.{f_damage_present_q_building} + n.{f_damage_cellar_present_q_building}
          WHEN ''{Medtag i risikoberegninger}'' = ''Værditab'' THEN n.{f_loss_present_q_building}
          WHEN ''{Medtag i risikoberegninger}'' = ''Skadebeløb og værditab'' THEN n.{f_damage_present_q_building} + n.{f_damage_cellar_present_q_building} + n.{f_loss_present_q_building} 
          END + 
          0.089925625 * CASE
          WHEN ''{Medtag i risikoberegninger}'' = ''Intet (0 kr.)'' THEN 0.0
          WHEN ''{Medtag i risikoberegninger}'' = ''Skadebeløb'' THEN f.{f_damage_future_q_building} + f.{f_damage_cellar_future_q_building}
          WHEN ''{Medtag i risikoberegninger}'' = ''Værditab'' THEN f.{f_loss_future_q_building}
          WHEN ''{Medtag i risikoberegninger}'' = ''Skadebeløb og værditab'' THEN f.{f_damage_future_q_building} + f.{f_damage_cellar_future_q_building} + f.{f_loss_future_q_building} 
          END)/{Returperiode, antal år})::NUMERIC(12,2) AS {f_risk_q_building},
          '''' AS omraade
    ) r
    WHERE f.cnt_oversvoem_fremtid > 0 OR n.cnt_oversvoem_nutid > 0', 'P', '', '', '', '', 'SQL template for buildings new model ', 8, ' ');

-- Patch  2022-02-26: Model q_building_new slut --


/* 
-----------------------------------------------------------------------
--   Patch 2022-02-27: Model q_tourism_spatial_new (2. time)
-----------------------------------------------------------------------

     search_path skal værdisættes, således at navnet på administrations schema er første parameter. 
     Hvis der ikke er ændret på standard navn for administrationsskema "fdc_admin"
     skal der ikke rettes i linjen

*/
SET search_path = fdc_admin, public;
--                *********

-- NIX PILLE VED RESTEN....................................................................................................

DELETE FROM parametre WHERE parent = 'q_tourism_spatial_new' OR name = 'q_tourism_spatial_new' OR "default" = 'q_tourism_spatial_new';
DELETE FROM parametre WHERE parent = 'q_tourism_spatial' OR name = 'q_tourism_spatial' OR "default" = 'q_tourism_spatial';

INSERT INTO parametre (name, parent, value, type, minval, maxval, lookupvalues, "default", explanation, sort, checkable) VALUES ('Turisme, Kort'              , 'Turisme'              , ''                      , 'T', '', '', '', 'q_tourism_spatial', 'Sæt hak såfremt der skal beregnes økonomiske tab for overnatningssteder som anvendes til turistformål. De berørte bygninger vises geografisk på et kort.  ', 10, 'T');
INSERT INTO parametre (name, parent, value, type, minval, maxval, lookupvalues, "default", explanation, sort, checkable) VALUES ('f_pkey_q_tourism_spatial'          , 'q_tourism_spatial', 'fid'                   , 'T', '', '', '', '', 'Name of primary keyfield for query', 10, ' ');
INSERT INTO parametre (name, parent, value, type, minval, maxval, lookupvalues, "default", explanation, sort, checkable) VALUES ('f_geom_q_tourism_spatial'          , 'q_tourism_spatial', 'geom'                  , 'T', '', '', '', '', 'Field name for geometry column', 10, ' ');
INSERT INTO parametre (name, parent, value, type, minval, maxval, lookupvalues, "default", explanation, sort, checkable) VALUES ('f_damage_present_q_tourism_spatial', 'q_tourism_spatial', 'skadebeloeb_nutid_kr'  , 'T', '', '', '', '', '', 1, 'T');
INSERT INTO parametre (name, parent, value, type, minval, maxval, lookupvalues, "default", explanation, sort, checkable) VALUES ('f_damage_future_q_tourism_spatial' , 'q_tourism_spatial', 'skadebeloeb_fremtid_kr', 'T', '', '', '', '', '', 1, 'T');
INSERT INTO parametre (name, parent, value, type, minval, maxval, lookupvalues, "default", explanation, sort, checkable) VALUES ('f_risk_q_tourism_spatial'          , 'q_tourism_spatial', 'risiko_kr'             , 'T', '', '', '', '', '', 1, 'T');
INSERT INTO parametre (name, parent, value, type, minval, maxval, lookupvalues, "default", explanation, sort, checkable) VALUES ('q_tourism_spatial'                 , 'Queries',
'
SELECT
    b.{f_pkey_t_building} as {f_pkey_q_tourism_spatial},
    b.{f_muncode_t_building} AS kom_kode,
    b.{f_usage_code_t_building} AS bbr_anv_kode,
    t.bbr_anv_tekst AS bbr_anv_tekst,
    t.kapacitet AS kapacitet,
    t.omkostning AS omkostninger,
    {Antal tabte døgn} AS tabte_dage,
    {Antal tabte døgn} * t.kapacitet AS tabte_overnatninger,
    st_force2d(b.{f_geom_t_building}) AS {f_geom_q_tourism_spatial},
    n.*,
    f.*,
    r.*
    FROM {t_building} b
    INNER JOIN {t_tourism} t  ON t.{f_pkey_t_tourism} = b.{f_usage_code_t_building},  
    LATERAL (
        SELECT
            COUNT (*) AS cnt_oversvoem_nutid,
            COALESCE(SUM(st_area(st_intersection(b.{f_geom_t_building},{f_geom_Oversvømmelsesmodel, nutid}))),0)::NUMERIC(12,2) AS areal_oversvoem_nutid_m2,
            COALESCE(MIN({f_depth_Oversvømmelsesmodel, nutid}) * 100.00,0)::NUMERIC(12,2) AS min_vanddybde_nutid_cm,
            COALESCE(MAX({f_depth_Oversvømmelsesmodel, nutid}) * 100.00,0)::NUMERIC(12,2) AS max_vanddybde_nutid_cm,
            COALESCE(AVG({f_depth_Oversvømmelsesmodel, nutid}) * 100.00,0)::NUMERIC(12,2) AS avg_vanddybde_nutid_cm,
            CASE WHEN COUNT (*) > 0 THEN {Antal tabte døgn} * t.omkostning * t.kapacitet ELSE 0 END::NUMERIC(12,2) AS {f_damage_present_q_tourism_spatial}
        FROM {Oversvømmelsesmodel, nutid} WHERE st_intersects(b.{f_geom_t_building},{f_geom_Oversvømmelsesmodel, nutid}) AND {f_depth_Oversvømmelsesmodel, nutid} >= {Minimum vanddybde (meter)}
    ) n,
    LATERAL (
        SELECT
            COUNT (*) AS cnt_oversvoem_fremtid,
            COALESCE(SUM(st_area(st_intersection(b.{f_geom_t_building},{f_geom_Oversvømmelsesmodel, fremtid}))),0)::NUMERIC(12,2) AS areal_oversvoem_fremtid_m2,
            COALESCE(MIN({f_depth_Oversvømmelsesmodel, fremtid}) * 100.00,0)::NUMERIC(12,2) AS min_vanddybde_fremtid_cm,
            COALESCE(MAX({f_depth_Oversvømmelsesmodel, fremtid}) * 100.00,0)::NUMERIC(12,2) AS max_vanddybde_fremtid_cm,
            COALESCE(AVG({f_depth_Oversvømmelsesmodel, fremtid}) * 100.00,0)::NUMERIC(12,2) AS avg_vanddybde_fremtid_cm,
            CASE WHEN COUNT (*) > 0 THEN {Antal tabte døgn} * t.omkostning * t.kapacitet ELSE 0 END::NUMERIC(12,2) AS {f_damage_future_q_tourism_spatial}
        FROM {Oversvømmelsesmodel, fremtid} WHERE st_intersects(b.{f_geom_t_building},{f_geom_Oversvømmelsesmodel, fremtid}) AND {f_depth_Oversvømmelsesmodel, fremtid} >= {Minimum vanddybde (meter)}
    ) f,
    LATERAL (
        SELECT
          ''{Medtag i risikoberegninger}'' AS risiko_beregning,
		  {Returperiode, antal år} AS retur_periode,
          ((
		      0.219058829 * CASE WHEN ''{Medtag i risikoberegninger}'' IN (''Skadebeløb'',''Skadebeløb og værditab'') THEN n.{f_damage_present_q_tourism_spatial} ELSE 0.0 END + 
              0.089925625   * CASE WHEN ''{Medtag i risikoberegninger}'' IN (''Skadebeløb'',''Skadebeløb og værditab'') THEN f.{f_damage_future_q_tourism_spatial} ELSE 0.0 END
          )/{Returperiode, antal år})::NUMERIC(12,2) AS {f_risk_q_tourism_spatial},
          '''' AS omraade
    ) r
	WHERE f.cnt_oversvoem_fremtid > 0 OR n.cnt_oversvoem_nutid > 0
', 'P', '', '', '', '', 'SQL template for buildings new model ', 8, ' ');

-- Patch  2022-02-27: Model q_tourism_spatial_new slut --

/*
-----------------------------------------------------------------------
--   Patch 2022-04-011 Model q_human_health_new
-----------------------------------------------------------------------

     search_path skal værdisættes, således at navnet på administrations schema er første parameter. 
     Hvis der ikke er ændret på standard navn for administrationsskema "fdc_admin"
     skal der ikke rettes i linjen

*/
SET search_path = fdc_admin, public;
--                *********

DELETE FROM parametre WHERE parent = 'q_human_health_new' OR name = 'q_human_health_new' OR "default" = 'q_human_health_new';
DELETE FROM parametre WHERE parent = 'q_human_health' OR name = 'q_human_health' OR "default" = 'q_human_health';

INSERT INTO parametre (name, parent, value, type, minval, maxval, lookupvalues, "default", explanation, sort, checkable) VALUES ('Humane omkostninger', 'Mennesker og helbred', '', 'T', '', '', '', 'q_human_health', 'Sæt hak såfremt der skal beregnes humane omkostninger', 10, 'T');
INSERT INTO parametre (name, parent, value, type, minval, maxval, lookupvalues, "default", explanation, sort, checkable) VALUES ('f_pkey_q_human_health'              , 'q_human_health', 'fid'                       , 'T', '', '', '', '', 'Name of primary keyfield for query', 10, ' ');
INSERT INTO parametre (name, parent, value, type, minval, maxval, lookupvalues, "default", explanation, sort, checkable) VALUES ('f_geom_q_human_health'              , 'q_human_health', 'geom'                      , 'T', '', '', '', '', 'Field name for geometry column', 10, ' ');
INSERT INTO parametre (name, parent, value, type, minval, maxval, lookupvalues, "default", explanation, sort, checkable) VALUES ('f_damage_present_q_human_health'    , 'q_human_health', 'skadebeloeb_nutid_kr'      , 'T', '', '', '', '', '', 1, 'T');
INSERT INTO parametre (name, parent, value, type, minval, maxval, lookupvalues, "default", explanation, sort, checkable) VALUES ('f_damage_future_q_human_health'     , 'q_human_health', 'skadebeloeb_fremtid_kr'    , 'T', '', '', '', '', '', 1, 'T');
INSERT INTO parametre (name, parent, value, type, minval, maxval, lookupvalues, "default", explanation, sort, checkable) VALUES ('f_risk_q_human_health'              , 'q_human_health', 'risiko_kr'                 , 'T', '', '', '', '', '', 1, 'T');
INSERT INTO parametre (name, parent, value, type, minval, maxval, lookupvalues, "default", explanation, sort, checkable) VALUES ('q_human_health', 'Queries', 
'
SELECT 
    b.{f_pkey_t_building} as {f_pkey_q_human_health},
    b.{f_muncode_t_building} AS kom_kode,
    b.{f_usage_code_t_building} AS bbr_anv_kode,
    b.{f_usage_text_t_building} AS bbr_anv_tekst,
    st_area(b.{f_geom_t_building})::NUMERIC(12,2) AS areal_byg_m2,
    st_multi(st_force2d(b.{f_geom_t_building}))::Geometry(Multipolygon,25832) AS {f_geom_q_human_health},
    n.*,
    f.*,
    h.*,
    r.*
    FROM {t_building} b,
    LATERAL (
        SELECT
            COUNT (*) AS cnt_oversvoem_nutid,
            COALESCE((SUM(st_area(st_intersection(b.{f_geom_t_building},{f_geom_Oversvømmelsesmodel, nutid})))),0)::NUMERIC(12,2) AS areal_oversvoem_nutid_m2,
            COALESCE((MIN({f_depth_Oversvømmelsesmodel, nutid}) * 100.00),0)::NUMERIC(12,2) AS min_vanddybde_nutid_cm,
            COALESCE((MAX({f_depth_Oversvømmelsesmodel, nutid}) * 100.00),0)::NUMERIC(12,2) AS max_vanddybde_nutid_cm,
            COALESCE((AVG({f_depth_Oversvømmelsesmodel, nutid}) * 100.00),0)::NUMERIC(12,2) AS avg_vanddybde_nutid_cm
        FROM {Oversvømmelsesmodel, nutid} WHERE st_intersects(b.{f_geom_t_building},{f_geom_Oversvømmelsesmodel, nutid}) AND {f_depth_Oversvømmelsesmodel, nutid} >= {Minimum vanddybde (meter)}
    ) n,
    LATERAL (
        SELECT
            COUNT (*) AS cnt_oversvoem_fremtid,
            COALESCE((SUM(st_area(st_intersection(b.{f_geom_t_building},{f_geom_Oversvømmelsesmodel, fremtid})))),0)::NUMERIC(12,2) AS areal_oversvoem_fremtid_m2,
            COALESCE((MIN({f_depth_Oversvømmelsesmodel, fremtid}) * 100.00),0)::NUMERIC(12,2) AS min_vanddybde_fremtid_cm,
            COALESCE((MAX({f_depth_Oversvømmelsesmodel, fremtid}) * 100.00),0)::NUMERIC(12,2) AS max_vanddybde_fremtid_cm,
            COALESCE((AVG({f_depth_Oversvømmelsesmodel, fremtid}) * 100.00),0)::NUMERIC(12,2) AS avg_vanddybde_fremtid_cm
        FROM {Oversvømmelsesmodel, fremtid} WHERE st_intersects(b.{f_geom_t_building},{f_geom_Oversvømmelsesmodel, fremtid}) AND {f_depth_Oversvømmelsesmodel, fremtid} >= {Minimum vanddybde (meter)}
    ) f,
    LATERAL (
        SELECT
            COUNT(*) AS mennesker_total,
            COUNT(*) FILTER (WHERE {f_age_t_human_health} BETWEEN 0 AND 6) AS mennesker_0_6,
            COUNT(*) FILTER (WHERE {f_age_t_human_health} BETWEEN 7 AND 17) AS mennesker_7_17,
            COUNT(*) FILTER (WHERE {f_age_t_human_health} BETWEEN 18 AND 70) AS mennesker_18_70,
            COUNT(*) FILTER (WHERE {f_age_t_human_health} > 70) AS mennesker_71plus,
            CASE WHEN n.cnt_oversvoem_nutid > 0 THEN COUNT(*) FILTER (WHERE {f_age_t_human_health} BETWEEN 18 AND 70) * (138 * 301) ELSE 0 END::integer AS arbejdstid_nutid_kr,
            CASE WHEN n.cnt_oversvoem_nutid > 0 THEN COUNT(*) FILTER (WHERE {f_age_t_human_health} BETWEEN 18 AND 70) * (23  * 301) ELSE 0 END::integer AS rejsetid_nutid_kr,
            CASE WHEN n.cnt_oversvoem_nutid > 0 THEN COUNT(*) FILTER (WHERE {f_age_t_human_health} BETWEEN 18 AND 70) * (64  * 301) ELSE 0 END::integer AS sygetimer_nutid_kr, 
            CASE WHEN n.cnt_oversvoem_nutid > 0 THEN COUNT(*) FILTER (WHERE {f_age_t_human_health} BETWEEN 18 AND 70) * (26  * 301) ELSE 0 END::integer AS ferietimer_nutid_kr, 
            CASE WHEN f.cnt_oversvoem_fremtid > 0 THEN COUNT(*) FILTER (WHERE {f_age_t_human_health} BETWEEN 18 AND 70) * (138 * 301) ELSE 0 END::integer AS arbejdstid_fremtid_kr,
            CASE WHEN f.cnt_oversvoem_fremtid > 0 THEN COUNT(*) FILTER (WHERE {f_age_t_human_health} BETWEEN 18 AND 70) * (23  * 301) ELSE 0 END::integer AS rejsetid_fremtid_kr,
            CASE WHEN f.cnt_oversvoem_fremtid > 0 THEN COUNT(*) FILTER (WHERE {f_age_t_human_health} BETWEEN 18 AND 70) * (64  * 301) ELSE 0 END::integer AS sygetimer_fremtid_kr, 
            CASE WHEN f.cnt_oversvoem_fremtid > 0 THEN COUNT(*) FILTER (WHERE {f_age_t_human_health} BETWEEN 18 AND 70) * (26  * 301) ELSE 0 END::integer AS ferietimer_fremtid_kr 
        FROM {t_human_health} WHERE ST_CoveredBy({f_geom_t_human_health},b.{f_geom_t_building})
    ) h,
    LATERAL (
        SELECT
		    h.arbejdstid_nutid_kr + 
			h.rejsetid_nutid_kr + 
			h.sygetimer_nutid_kr + 
			h.ferietimer_nutid_kr AS {f_damage_present_q_human_health},
            h.arbejdstid_fremtid_kr + 
			h.rejsetid_fremtid_kr + 
			h.sygetimer_fremtid_kr + 
			h.ferietimer_fremtid_kr AS {f_damage_future_q_human_health},
            ''{Medtag i risikoberegninger}'' AS risiko_beregning,
		    {Returperiode, antal år} AS retur_periode,
            ((
			    0.219058829 * CASE WHEN ''{Medtag i risikoberegninger}'' IN (''Skadebeløb'',''Skadebeløb og værditab'') THEN 
			        h.arbejdstid_nutid_kr + 
					h.rejsetid_nutid_kr + 
					h.sygetimer_nutid_kr + 
					h.ferietimer_nutid_kr ELSE 0 END
				 +
                0.089925625 * CASE WHEN ''{Medtag i risikoberegninger}'' IN (''Skadebeløb'',''Skadebeløb og værditab'') THEN
                    h.arbejdstid_fremtid_kr + 
					h.rejsetid_fremtid_kr + 
					h.sygetimer_fremtid_kr + 
					h.ferietimer_fremtid_kr ELSE 0 END
				)/{Returperiode, antal år})::NUMERIC(12,2) AS {f_risk_q_human_health},
            '''' AS omraade
    ) r
    WHERE (f.cnt_oversvoem_fremtid > 0 OR n.cnt_oversvoem_nutid > 0) AND h.mennesker_total > 0
', 'P', '', '', '', '', 'SQL template for human health new model ', 8, ' ');

-- Patch  2022-04-11: Model q_human_health_new slut --

/*
-----------------------------------------------------------------------
--   Patch 2022-04-12 Model q_recreative_new
-----------------------------------------------------------------------

     search_path skal værdisættes, således at navnet på administrations schema er første parameter. 
     Hvis der ikke er ændret på standard navn for administrationsskema "fdc_admin"
     skal der ikke rettes i linjen

*/
SET search_path = fdc_admin, public;
--                *********

DELETE FROM parametre WHERE parent = 'q_recreative_new' OR name = 'q_recreative_new' OR "default" = 'q_recreative_new';
DELETE FROM parametre WHERE parent = 'q_recreative' OR name = 'q_recreative' OR "default" = 'q_recreative';

INSERT INTO parametre (name, parent, value, type, minval, maxval, lookupvalues, "default", explanation, sort, checkable) VALUES ('Skadesberegning, Rekreative områder', 'Rekreative områder', '', 'T', '', '', '', 'q_recreative', 'Sæt hak såfremt der skal beregnes økonomiske tab for overnatningssteder som anvendes til turistformål. De berørte bygninger vises geografisk på et kort.  ', 10, 'T');
INSERT INTO parametre (name, parent, value, type, minval, maxval, lookupvalues, "default", explanation, sort, checkable) VALUES ('f_pkey_q_recreative'              , 'q_recreative', 'id'                       , 'T', '', '', '', '', 'Name of primary keyfield for query', 10, ' ');
INSERT INTO parametre (name, parent, value, type, minval, maxval, lookupvalues, "default", explanation, sort, checkable) VALUES ('f_geom_q_recreative'              , 'q_recreative', 'geom'                      , 'T', '', '', '', '', 'Field name for geometry column', 10, ' ');
INSERT INTO parametre (name, parent, value, type, minval, maxval, lookupvalues, "default", explanation, sort, checkable) VALUES ('f_damage_present_q_recreative'    , 'q_recreative', 'skadebeloeb_nutid_kr'      , 'T', '', '', '', '', '', 1, 'T');
INSERT INTO parametre (name, parent, value, type, minval, maxval, lookupvalues, "default", explanation, sort, checkable) VALUES ('f_damage_future_q_recreative'     , 'q_recreative', 'skadebeloeb_fremtid_kr'    , 'T', '', '', '', '', '', 1, 'T');
INSERT INTO parametre (name, parent, value, type, minval, maxval, lookupvalues, "default", explanation, sort, checkable) VALUES ('f_risk_q_recreative'              , 'q_recreative', 'risiko_kr'                 , 'T', '', '', '', '', '', 1, 'T');
INSERT INTO parametre (name, parent, value, type, minval, maxval, lookupvalues, "default", explanation, sort, checkable) VALUES ('q_recreative', 'Queries', 
'
SELECT 
    b.*,
    {Antal dage med oversvømmelse} AS periode_dage, 
    st_area(b.{f_geom_t_recreative})::NUMERIC(12,2) AS areal_m2,
    n.*,
    f.*,
    h.*,
    r.*
    FROM {t_recreative} b,
    LATERAL (
        SELECT
            COUNT (*) AS cnt_oversvoem_nutid,
            COALESCE((SUM(st_area(st_intersection(b.{f_geom_t_recreative},{f_geom_Oversvømmelsesmodel, nutid})))),0)::NUMERIC(12,2) AS areal_oversvoem_nutid_m2,
            COALESCE((MIN({f_depth_Oversvømmelsesmodel, nutid}) * 100.00),0)::NUMERIC(12,2) AS min_vanddybde_nutid_cm,
            COALESCE((MAX({f_depth_Oversvømmelsesmodel, nutid}) * 100.00),0)::NUMERIC(12,2) AS max_vanddybde_nutid_cm,
            COALESCE((AVG({f_depth_Oversvømmelsesmodel, nutid}) * 100.00),0)::NUMERIC(12,2) AS avg_vanddybde_nutid_cm
        FROM {Oversvømmelsesmodel, nutid} WHERE st_intersects(b.{f_geom_t_recreative},{f_geom_Oversvømmelsesmodel, nutid}) AND {f_depth_Oversvømmelsesmodel, nutid} >= {Minimum vanddybde (meter)}
    ) n,
    LATERAL (
        SELECT
            COUNT (*) AS cnt_oversvoem_fremtid,
            COALESCE((SUM(st_area(st_intersection(b.{f_geom_t_recreative},{f_geom_Oversvømmelsesmodel, fremtid})))),0)::NUMERIC(12,2) AS areal_oversvoem_fremtid_m2,
            COALESCE((MIN({f_depth_Oversvømmelsesmodel, fremtid}) * 100.00),0)::NUMERIC(12,2) AS min_vanddybde_fremtid_cm,
            COALESCE((MAX({f_depth_Oversvømmelsesmodel, fremtid}) * 100.00),0)::NUMERIC(12,2) AS max_vanddybde_fremtid_cm,
            COALESCE((AVG({f_depth_Oversvømmelsesmodel, fremtid}) * 100.00),0)::NUMERIC(12,2) AS avg_vanddybde_fremtid_cm
        FROM {Oversvømmelsesmodel, fremtid} WHERE st_intersects(b.{f_geom_t_recreative},{f_geom_Oversvømmelsesmodel, fremtid}) AND {f_depth_Oversvømmelsesmodel, fremtid} >= {Minimum vanddybde (meter)}
    ) f,
    LATERAL (
        SELECT
            (100.0 * n.areal_oversvoem_nutid_m2/st_area(b.{f_geom_t_recreative}))::NUMERIC(12,2) AS oversvoem_nutid_pct,
            (100.0 * f.areal_oversvoem_fremtid_m2/st_area(b.{f_geom_t_recreative}))::NUMERIC(12,2) AS oversvoem_fremtid_pct,
            (({Antal dage med oversvømmelse}/365.0) * (n.areal_oversvoem_nutid_m2/st_area(b.{f_geom_t_recreative})) * b.valuationk)::NUMERIC(12,2)  AS {f_damage_present_q_recreative},		    
            (({Antal dage med oversvømmelse}/365.0) * (f.areal_oversvoem_fremtid_m2/st_area(b.{f_geom_t_recreative})) * b.valuationk)::NUMERIC(12,2)  AS {f_damage_future_q_recreative}		    
    ) h,
    LATERAL (
        SELECT
            ''{Medtag i risikoberegninger}'' AS risiko_beregning,
		    {Returperiode, antal år} AS retur_periode,
            ((0.219058829 * CASE WHEN ''{Medtag i risikoberegninger}'' IN (''Skadebeløb'',''Skadebeløb og værditab'') THEN 
			    h.{f_damage_present_q_recreative} ELSE 0 END +
			0.089925625 * CASE WHEN ''{Medtag i risikoberegninger}'' IN (''Skadebeløb'',''Skadebeløb og værditab'') THEN
			    h.{f_damage_future_q_recreative} ELSE 0 END)/{Returperiode, antal år})::NUMERIC(12,2) AS {f_risk_q_recreative},
            '''' AS omraade
    ) r
    WHERE f.cnt_oversvoem_fremtid > 0 OR n.cnt_oversvoem_nutid > 0
', 'P', '', '', '', '', 'SQL template for recreative new model ', 8, ' ');

UPDATE parametre SET parent = 'Rekreative områder', sort = 3 WHERE name = 'Antal dage med oversvømmelse';

-- Patch  2022-04-12: Model q_recreative_new slut --

/*
-----------------------------------------------------------------------
--   Patch 2022-04-13 Model q_comp_build_new
-----------------------------------------------------------------------

     search_path skal værdisættes, således at navnet på administrations schema er første parameter. 
     Hvis der ikke er ændret på standard navn for administrationsskema "fdc_admin"
     skal der ikke rettes i linjen

*/
SET search_path = fdc_admin, public;
--                *********

DELETE FROM parametre WHERE parent = 'q_comp_build_new' OR name = 'q_comp_build_new' OR "default" = 'q_comp_build_new';
DELETE FROM parametre WHERE parent = 'q_comp_build' OR name = 'q_comp_build' OR "default" = 'q_comp_build';

INSERT INTO parametre (name, parent, value, type, minval, maxval, lookupvalues, "default", explanation, sort, checkable) VALUES ('Industri, personale i bygninger', 'Industri', ' ', 'T', '', '', '', 'q_comp_build', 'Sæt hak såfremt modellen skal identificere de virksomheder som bliver berørt af den pågældende oversvømmelse, og angive antallet af medarbejdere per virksomhed.', 10, 'T');
INSERT INTO parametre (name, parent, value, type, minval, maxval, lookupvalues, "default", explanation, sort, checkable) VALUES ('f_pkey_q_comp_build'              , 'q_comp_build', 'id'                       , 'T', '', '', '', '', 'Name of primary keyfield for query', 10, ' ');
INSERT INTO parametre (name, parent, value, type, minval, maxval, lookupvalues, "default", explanation, sort, checkable) VALUES ('f_geom_q_comp_build'              , 'q_comp_build', 'geom'                      , 'T', '', '', '', '', 'Field name for geometry column', 10, ' ');
INSERT INTO parametre (name, parent, value, type, minval, maxval, lookupvalues, "default", explanation, sort, checkable) VALUES ('q_comp_build', 'Queries', 
'
SELECT
    c.*,
    b.{f_pkey_t_building} AS byg_id,
    b.{f_muncode_t_building} AS kom_kode,
    b.{f_usage_code_t_building} AS bbr_anv_kode,
    b.{f_usage_text_t_building} AS bbr_anv_tekst,
    n.*,
    f.*,
    '''' AS omraade
FROM {t_company} c LEFT JOIN {t_building} b ON st_within(c.{f_geom_t_company},b.{f_geom_t_building}),     
    LATERAL (
        SELECT
            COUNT (*) AS cnt_oversvoem_nutid,
            COALESCE((MIN({f_depth_Oversvømmelsesmodel, nutid}) * 100.00),0)::NUMERIC(12,2) AS min_vanddybde_nutid_cm,
            COALESCE((MAX({f_depth_Oversvømmelsesmodel, nutid}) * 100.00),0)::NUMERIC(12,2) AS max_vanddybde_nutid_cm,
            COALESCE((AVG({f_depth_Oversvømmelsesmodel, nutid}) * 100.00),0)::NUMERIC(12,2) AS avg_vanddybde_nutid_cm
        FROM {Oversvømmelsesmodel, nutid} WHERE {f_depth_Oversvømmelsesmodel, nutid} >= {Minimum vanddybde (meter)} AND 
		    (b.{f_pkey_t_building} IS NOT NULL AND st_intersects(b.{f_geom_t_building},{f_geom_Oversvømmelsesmodel, nutid}) OR
			 b.{f_pkey_t_building} IS NULL     AND st_within(c.{f_geom_t_company},{f_geom_Oversvømmelsesmodel, nutid}))
    ) n,
    LATERAL (
        SELECT
            COUNT (*) AS cnt_oversvoem_fremtid,
            COALESCE((MIN({f_depth_Oversvømmelsesmodel, fremtid}) * 100.00),0)::NUMERIC(12,2) AS min_vanddybde_fremtid_cm,
            COALESCE((MAX({f_depth_Oversvømmelsesmodel, fremtid}) * 100.00),0)::NUMERIC(12,2) AS max_vanddybde_fremtid_cm,
            COALESCE((AVG({f_depth_Oversvømmelsesmodel, fremtid}) * 100.00),0)::NUMERIC(12,2) AS avg_vanddybde_fremtid_cm
        FROM {Oversvømmelsesmodel, fremtid} WHERE {f_depth_Oversvømmelsesmodel, fremtid} >= {Minimum vanddybde (meter)} AND 
		    (b.{f_pkey_t_building} IS NOT NULL AND st_intersects(b.{f_geom_t_building},{f_geom_Oversvømmelsesmodel, fremtid}) OR
			 b.{f_pkey_t_building} IS NULL     AND st_within(c.{f_geom_t_company},{f_geom_Oversvømmelsesmodel, fremtid}))
    ) f
WHERE n.cnt_oversvoem_nutid > 0 OR f.cnt_oversvoem_fremtid > 0 
', 'P', '', '', '', '', 'SQL template for human health new model ', 8, ' ');

-- Patch  2022-04-13: Model q_comp_build_new slut --


/*
-----------------------------------------------------------------------
--   Patch 2022-04-15 Model q_bioscore_spatial_new
-----------------------------------------------------------------------

     search_path skal værdisættes, således at navnet på administrations schema er første parameter. 
     Hvis der ikke er ændret på standard navn for administrationsskema "fdc_admin"
     skal der ikke rettes i linjen

*/
SET search_path = fdc_admin, public;
--                *********

DELETE FROM parametre WHERE parent = 'q_bioscore_spatial_new' OR name = 'q_bioscore_spatial_new' OR "default" = 'q_bioscore_spatial_new';
DELETE FROM parametre WHERE parent = 'q_bioscore_spatial' OR name = 'q_bioscore_spatial' OR "default" = 'q_bioscore_spatial';

INSERT INTO parametre (name, parent, value, type, minval, maxval, lookupvalues, "default", explanation, sort, checkable) VALUES ('Biodiversitet, kort', 'Biodiversitet', '', 'T', '', '', '', 'q_bioscore_spatial', 'Sæt hak såfremt modellen skal identificere særlige levesteder for rødlistede arter som bliver berørt i forbindelse med den pågældende oversvømmelseshændelse. Her vises levestederne geografisk på et kort.', 10, 'T');
INSERT INTO parametre (name, parent, value, type, minval, maxval, lookupvalues, "default", explanation, sort, checkable) VALUES ('f_pkey_q_bioscore_spatial'              , 'q_bioscore_spatial', 'id'                       , 'T', '', '', '', '', 'Name of primary keyfield for query', 10, ' ');
INSERT INTO parametre (name, parent, value, type, minval, maxval, lookupvalues, "default", explanation, sort, checkable) VALUES ('f_geom_q_bioscore_spatial'              , 'q_bioscore_spatial', 'geom'                      , 'T', '', '', '', '', 'Field name for geometry column', 10, ' ');
INSERT INTO parametre (name, parent, value, type, minval, maxval, lookupvalues, "default", explanation, sort, checkable) VALUES ('q_bioscore_spatial', 'Queries', 
'
SELECT
    c.*,
	st_area(c.{f_geom_t_bioscore})::NUMERIC(12,2) AS areal_m2,
    n.*,
    f.*,
    '''' AS omraade
FROM {t_bioscore} c,     
    LATERAL (
        SELECT
            COUNT (*) AS cnt_oversvoem_nutid,
            COALESCE((SUM(st_area(st_intersection(c.{f_geom_t_bioscore},{f_geom_Oversvømmelsesmodel, nutid})))),0)::NUMERIC(12,2) AS areal_oversvoem_nutid_m2,
            COALESCE((MIN({f_depth_Oversvømmelsesmodel, nutid}) * 100.00),0)::NUMERIC(12,2) AS min_vanddybde_nutid_cm,
            COALESCE((MAX({f_depth_Oversvømmelsesmodel, nutid}) * 100.00),0)::NUMERIC(12,2) AS max_vanddybde_nutid_cm,
            COALESCE((AVG({f_depth_Oversvømmelsesmodel, nutid}) * 100.00),0)::NUMERIC(12,2) AS avg_vanddybde_nutid_cm
        FROM {Oversvømmelsesmodel, nutid} WHERE {f_depth_Oversvømmelsesmodel, nutid} >= {Minimum vanddybde (meter)} AND st_intersects(c.{f_geom_t_bioscore},{f_geom_Oversvømmelsesmodel, nutid})
    ) n,
    LATERAL (
        SELECT
            COUNT (*) AS cnt_oversvoem_fremtid,
            COALESCE((SUM(st_area(st_intersection(c.{f_geom_t_bioscore},{f_geom_Oversvømmelsesmodel, fremtid})))),0)::NUMERIC(12,2) AS areal_oversvoem_fremtid_m2,
            COALESCE((MIN({f_depth_Oversvømmelsesmodel, fremtid}) * 100.00),0)::NUMERIC(12,2) AS min_vanddybde_fremtid_cm,
            COALESCE((MAX({f_depth_Oversvømmelsesmodel, fremtid}) * 100.00),0)::NUMERIC(12,2) AS max_vanddybde_fremtid_cm,
            COALESCE((AVG({f_depth_Oversvømmelsesmodel, fremtid}) * 100.00),0)::NUMERIC(12,2) AS avg_vanddybde_fremtid_cm
        FROM {Oversvømmelsesmodel, fremtid} WHERE {f_depth_Oversvømmelsesmodel, fremtid} >= {Minimum vanddybde (meter)} AND st_intersects(c.{f_geom_t_bioscore},{f_geom_Oversvømmelsesmodel, fremtid})
    ) f
WHERE n.cnt_oversvoem_nutid > 0 OR f.cnt_oversvoem_fremtid > 0 
', 'P', '', '', '', '', 'SQL template for bioscore spatial - new model ', 8, ' ');

-- Patch  2022-04-15: Model q_comp_bioscore_new slut --


/*
-----------------------------------------------------------------------
--   Patch 2022-04-17 Model q_road_traffic_new
-----------------------------------------------------------------------

     search_path skal værdisættes, således at navnet på administrations schema er første parameter. 
     Hvis der ikke er ændret på standard navn for administrationsskema "fdc_admin"
     skal der ikke rettes i linjen

*/
SET search_path = fdc_admin, public;
--                *********

DELETE FROM parametre WHERE parent = 'q_road_traffic_new' OR name = 'q_road_traffic_new' OR "default" = 'q_road_traffic_new';
DELETE FROM parametre WHERE parent = 'q_road_traffic' OR name = 'q_road_traffic' OR "default" = 'q_road_traffic';

INSERT INTO parametre (name, parent, value, type, minval, maxval, lookupvalues, "default", explanation, sort, checkable) VALUES ('f_risk_q_road_traffic', 'q_road_traffic', 'risiko_kr', 'T', '', '', '', '', '', 1, 'T');
INSERT INTO parametre (name, parent, value, type, minval, maxval, lookupvalues, "default", explanation, sort, checkable) VALUES ('f_damage_present_q_road_traffic', 'q_road_traffic', 'pris_total_nutid_kr', 'T', '', '', '', '', '', 1, 'T');
INSERT INTO parametre (name, parent, value, type, minval, maxval, lookupvalues, "default", explanation, sort, checkable) VALUES ('f_damage_future_q_road_traffic', 'q_road_traffic', 'pris_total_fremtid_kr', 'T', '', '', '', '', '', 1, 'T');
INSERT INTO parametre (name, parent, value, type, minval, maxval, lookupvalues, "default", explanation, sort, checkable) VALUES ('f_pkey_q_road_traffic', 'q_road_traffic', 'id', 'T', '', '', '', '', '', 10, ' ');
INSERT INTO parametre (name, parent, value, type, minval, maxval, lookupvalues, "default", explanation, sort, checkable) VALUES ('f_geom_q_road_traffic', 'q_road_traffic', 'geom', 'T', '', '', '', '', '', 10, ' ');
INSERT INTO parametre (name, parent, value, type, minval, maxval, lookupvalues, "default", explanation, sort, checkable) VALUES ('Skadeberegning, vej og trafik', 'Vej og trafik', '', 'T', '', '', '', 'q_road_traffic', 'Sæt hak såfremt der skal beregnes økonomiske tab for vej og trafik i forbindelse med den pågældende oversvømmelseshændelse.', 10, 'T');

UPDATE parametre SET parent = 'Vej og trafik' WHERE name = 'Oversvømmelsesperiode (timer)';
UPDATE parametre SET parent = 'Vej og trafik' WHERE name = 'Renovationspris pr meter vej (DKK)';

INSERT INTO parametre (name, parent, value, type, minval, maxval, lookupvalues, "default", explanation, sort, checkable) VALUES ('q_road_traffic', 'Queries', 
'
SELECT 
    b.*,
    n.*,
    f.*,
    {Oversvømmelsesperiode (timer)} AS blokering_timer,
    0.3 AS vanddybde_bloker_m,
    0.075 AS vanddybde_min_m,
	{Renovationspris pr meter vej (DKK)} AS pris_renovation_kr_m,
    h.*,
	i.*,
    r.*
    FROM {t_road_traffic} b,
    LATERAL (
        SELECT
            st_length(b.{f_geom_t_road_traffic})::NUMERIC(12,2) AS laengde_org_m,
            COUNT (*) AS cnt_oversvoem_nutid,
            COALESCE((SUM(st_length(st_intersection(b.{f_geom_t_road_traffic},{f_geom_Oversvømmelsesmodel, nutid})))),0)::NUMERIC(12,2) AS laengde_oversvoem_nutid_m,
            COALESCE((MIN({f_depth_Oversvømmelsesmodel, nutid}) * 100.00),0)::NUMERIC(12,2) AS min_vanddybde_nutid_cm,
            COALESCE((MAX({f_depth_Oversvømmelsesmodel, nutid}) * 100.00),0)::NUMERIC(12,2) AS max_vanddybde_nutid_cm,
            COALESCE((AVG({f_depth_Oversvømmelsesmodel, nutid}) * 100.00),0)::NUMERIC(12,2) AS avg_vanddybde_nutid_cm
        FROM {Oversvømmelsesmodel, nutid} WHERE st_intersects(b.{f_geom_t_road_traffic},{f_geom_Oversvømmelsesmodel, nutid}) AND {f_depth_Oversvømmelsesmodel, nutid} >= 0.075
    ) n,
    LATERAL (
        SELECT
            COUNT (*) AS cnt_oversvoem_fremtid,
            COALESCE((SUM(st_length(st_intersection(b.{f_geom_t_road_traffic},{f_geom_Oversvømmelsesmodel, fremtid})))),0)::NUMERIC(12,2) AS laengde_oversvoem_fremtid_m,
            COALESCE((MIN({f_depth_Oversvømmelsesmodel, fremtid}) * 100.00),0)::NUMERIC(12,2) AS min_vanddybde_fremtid_cm,
            COALESCE((MAX({f_depth_Oversvømmelsesmodel, fremtid}) * 100.00),0)::NUMERIC(12,2) AS max_vanddybde_fremtid_cm,
            COALESCE((AVG({f_depth_Oversvømmelsesmodel, fremtid}) * 100.00),0)::NUMERIC(12,2) AS avg_vanddybde_fremtid_cm
        FROM {Oversvømmelsesmodel, fremtid} WHERE st_intersects(b.{f_geom_t_road_traffic},{f_geom_Oversvømmelsesmodel, fremtid}) AND {f_depth_Oversvømmelsesmodel, fremtid} >= 0.075
    ) f,
    LATERAL (
        SELECT
            CASE WHEN n.avg_vanddybde_nutid_cm >= 30.0 THEN 0.0 ELSE 0.0009 * (n.avg_vanddybde_nutid_cm*10.0)^2.0 - 0.5529 * n.avg_vanddybde_nutid_cm*10.0 + 86.9448 END::NUMERIC(12,2) AS hastighed_red_nutid_km_time,
            CASE WHEN f.avg_vanddybde_fremtid_cm >= 30.0 THEN 0.0 ELSE 0.0009 * (f.avg_vanddybde_fremtid_cm*10.0)^2.0 - 0.5529 * f.avg_vanddybde_fremtid_cm*10.0 + 86.9448 END::NUMERIC(12,2) AS hastighed_red_fremtid_km_time,
            n.laengde_oversvoem_nutid_m * {Renovationspris pr meter vej (DKK)} AS skade_renovation_nutid_kr,
            f.laengde_oversvoem_fremtid_m * {Renovationspris pr meter vej (DKK)} AS skade_renovation_fremtid_kr
    ) h,
    LATERAL (
        SELECT
            CASE WHEN h.hastighed_red_nutid_km_time > 50.0 THEN 0.0 ELSE (68.8 - 1.376 * h.hastighed_red_nutid_km_time) * ({Oversvømmelsesperiode (timer)} / 24.0) * n.laengde_org_m * (b.{f_number_cars_t_road_traffic}/6200.00)*2.0 END::NUMERIC(12,2) AS skade_transport_nutid_kr,
            CASE WHEN h.hastighed_red_fremtid_km_time > 50.0 THEN 0.0 ELSE (68.8 - 1.376 * h.hastighed_red_fremtid_km_time) * ({Oversvømmelsesperiode (timer)} / 24.0) * n.laengde_org_m * (b.{f_number_cars_t_road_traffic}/6200.00)*2.0 END::NUMERIC(12,2) AS skade_transport_fremtid_kr
    ) i,
    LATERAL (
        SELECT
		    h.skade_renovation_nutid_kr + i.skade_transport_nutid_kr AS {f_damage_present_q_road_traffic},
		    h.skade_renovation_fremtid_kr + i.skade_transport_fremtid_kr AS {f_damage_future_q_road_traffic},
            ''{Medtag i risikoberegninger}'' AS risiko_beregning,
		    {Returperiode, antal år} AS retur_periode,
            ((0.219058829 * CASE WHEN ''{Medtag i risikoberegninger}'' IN (''Skadebeløb'',''Skadebeløb og værditab'') THEN 
			    h.skade_renovation_nutid_kr + i.skade_transport_nutid_kr ELSE 0 END +
			0.089925625 * CASE WHEN ''{Medtag i risikoberegninger}'' IN (''Skadebeløb'',''Skadebeløb og værditab'') THEN
			    h.skade_renovation_fremtid_kr + i.skade_transport_fremtid_kr ELSE 0 END)/{Returperiode, antal år})::NUMERIC(12,2) AS {f_risk_q_road_traffic},
            '''' AS omraade
    ) r
    WHERE f.cnt_oversvoem_fremtid > 0 OR n.cnt_oversvoem_nutid > 0
', 'P', '', '', '', '', 'SQL template for road traffic new model ', 8, ' ');

-- Patch  2022-04-17: Model q_road_traffic_new slut --

/*
-----------------------------------------------------------------------
--   Patch 2022-04-18 Model q_surrounding_loss_new
-----------------------------------------------------------------------

     search_path skal værdisættes, således at navnet på administrations schema er første parameter. 
     Hvis der ikke er ændret på standard navn for administrationsskema "fdc_admin"
     skal der ikke rettes i linjen

*/
SET search_path = fdc_admin, public;
--                *********

DELETE FROM parametre WHERE parent = 'q_surrounding_loss_new' OR name = 'q_surrounding_loss_new' OR "default" = 'q_surrounding_loss_new';
DELETE FROM parametre WHERE parent = 'q_surrounding_loss' OR name = 'q_surrounding_loss' OR "default" = 'q_surrounding_loss';

INSERT INTO parametre (name, parent, value, type, minval, maxval, lookupvalues, "default", explanation, sort, checkable) VALUES ('f_pkey_q_surrounding_loss', 'q_surrounding_loss', 'objectid', 'T', '', '', '', '', '', 10, ' ');
INSERT INTO parametre (name, parent, value, type, minval, maxval, lookupvalues, "default", explanation, sort, checkable) VALUES ('f_geom_q_surrounding_loss', 'q_surrounding_loss', 'geom', 'T', '', '', '', '', '', 10, ' ');
INSERT INTO parametre (name, parent, value, type, minval, maxval, lookupvalues, "default", explanation, sort, checkable) VALUES ('f_risk_q_surrounding_loss', 'q_surrounding_loss', 'risiko_kr', 'T', '', '', '', '', '', 10, ' ');
INSERT INTO parametre (name, parent, value, type, minval, maxval, lookupvalues, "default", explanation, sort, checkable) VALUES ('f_loss_future_q_surrounding_loss', 'q_surrounding_loss', 'vaerditab_fremtid_kr', 'T', '', '', '', '', '', 10, ' ');
INSERT INTO parametre (name, parent, value, type, minval, maxval, lookupvalues, "default", explanation, sort, checkable) VALUES ('f_loss_present_q_surrounding_loss', 'q_surrounding_loss', 'vaerditab_nutid_kr', 'T', '', '', '', '', '', 10, ' ');
INSERT INTO parametre (name, parent, value, type, minval, maxval, lookupvalues, "default", explanation, sort, checkable) VALUES ('q_surrounding_loss', 'Queries',
'
WITH 
    of AS (SELECT b.{f_pkey_t_building}, b.{f_geom_t_building} FROM {t_building} b WHERE EXISTS ( SELECT 1 FROM {Oversvømmelsesmodel, fremtid} f WHERE st_intersects (f.{f_geom_Oversvømmelsesmodel, fremtid}, b.{f_geom_t_building}) AND  f.{f_depth_Oversvømmelsesmodel, fremtid} >= {Minimum vanddybde (meter)})),
    op AS (SELECT b.{f_pkey_t_building}, b.{f_geom_t_building} FROM {t_building} b WHERE EXISTS ( SELECT 1 FROM {Oversvømmelsesmodel, nutid} f WHERE st_intersects (f.{f_geom_Oversvømmelsesmodel, nutid}, b.{f_geom_t_building}) AND  f.{f_depth_Oversvømmelsesmodel, nutid} >= {Minimum vanddybde (meter)}))

SELECT 
    x.*,
    st_area(x.{f_geom_t_building})::NUMERIC(12,2) AS areal_byg_m2,
    k.{f_sqmprice_t_sqmprice}::NUMERIC(12,2) AS kvm_pris_kr,
    ({Værditab, skaderamte bygninger (%)}*{Faktor for værditab})::NUMERIC(12,2) AS tab_procent,
    CASE WHEN y.{f_pkey_t_building} IS NULL THEN 0.0 ELSE k.{f_sqmprice_t_sqmprice} * st_area(x.{f_geom_t_building}) * {Værditab, skaderamte bygninger (%)}*{Faktor for værditab} / 100.0 END::NUMERIC(12,2) AS {f_loss_future_q_surrounding_loss},
    CASE WHEN z.{f_pkey_t_building} IS NULL THEN 0.0 ELSE k.{f_sqmprice_t_sqmprice} * st_area(x.{f_geom_t_building}) * {Værditab, skaderamte bygninger (%)}*{Faktor for værditab} / 100.0 END::NUMERIC(12,2) AS {f_loss_present_q_surrounding_loss},
    ''{Medtag i risikoberegninger}'' AS risiko_beregning,
    {Returperiode, antal år} AS retur_periode,
    ((
	    0.219058829 * 
	    CASE 
		    WHEN ''{Medtag i risikoberegninger}'' IN (''Værditab'',''Skadebeløb og værditab'') THEN 
                CASE 
			        WHEN z.{f_pkey_t_building} IS NULL THEN 0.0 
			        ELSE k.{f_sqmprice_t_sqmprice} * st_area(x.{f_geom_t_building}) * {Værditab, skaderamte bygninger (%)}*{Faktor for værditab} / 100.0 
                END
            ELSE 0 
		END +
	    0.089925625 * 
	    CASE 
		    WHEN ''{Medtag i risikoberegninger}'' IN (''Værditab'',''Skadebeløb og værditab'') THEN
	            CASE 
				    WHEN y.{f_pkey_t_building} IS NULL THEN 0.0 
					ELSE k.{f_sqmprice_t_sqmprice} * st_area(x.{f_geom_t_building}) * {Værditab, skaderamte bygninger (%)}*{Faktor for værditab} / 100.0 
				END
	        ELSE 0 
        END)/{Returperiode, antal år})::NUMERIC(12,2) AS {f_risk_q_surrounding_loss},
    '''' AS omraade
FROM {t_building} x 
LEFT JOIN (SELECT DISTINCT c.{f_pkey_t_building} FROM {t_building} c, of WHERE c.{f_pkey_t_building} NOT IN (SELECT {f_pkey_t_building} from of) and st_dwithin(of.{f_geom_t_building},c.{f_geom_t_building},300.)) y ON x.{f_pkey_t_building} = y.{f_pkey_t_building} 
LEFT JOIN (SELECT DISTINCT c.{f_pkey_t_building} FROM {t_building} c, op WHERE c.{f_pkey_t_building} NOT IN (SELECT {f_pkey_t_building} from op) and st_dwithin(op.{f_geom_t_building},c.{f_geom_t_building},300.)) z ON x.{f_pkey_t_building} = z.{f_pkey_t_building} 
LEFT JOIN {t_sqmprice} k ON k.kom_kode = x.komkode 
WHERE y.{f_pkey_t_building} IS NOT NULL OR z.{f_pkey_t_building} IS NOT NULL
', 'P', '', '', '', '', 'SQL template for surrounding loss - new model ', 8, ' ');
INSERT INTO parametre (name, parent, value, type, minval, maxval, lookupvalues, "default", explanation, sort, checkable) VALUES ('Værditab nabobygninger', 'Bygninger', '', 'T', '', '', '', 'q_surrounding_loss', '', 12, 'T');

UPDATE parametre SET parent = 'Bygninger', sort = 3 WHERE name = 'Bredde af nabozone (meter)';
UPDATE parametre SET parent = 'Bygninger', sort = 4 WHERE name = 'Faktor for værditab';

-- Patch  2022-04-18: Model q_surrounding_loss_new slut --

/*
-----------------------------------------------------------------------
--   Patch 2022-04-14 Ny struktur i faneblad data
-----------------------------------------------------------------------

     search_path skal værdisættes, således at navnet på administrations schema er første parameter. 
     Hvis der ikke er ændret på standard navn for administrationsskema "fdc_admin"
     skal der ikke rettes i linjen

*/
SET search_path = fdc_admin, public;
--                *********

INSERT INTO parametre (name, parent, value, type, minval, maxval, lookupvalues, "default", explanation, sort, checkable) VALUES ('Admin data', 'Data', '', 'G', '', '', '', '', 'Gruppe for administration af Lookup tabeller', 2, ' ') ON CONFLICT (name) DO NOTHING;
INSERT INTO parametre (name, parent, value, type, minval, maxval, lookupvalues, "default", explanation, sort, checkable) VALUES ('Flood data',  'Data', '', 'G', '', '', '', '', 'Gruppe for administration af Oversvømmelses tabeller', 2, ' ') ON CONFLICT (name) DO NOTHING;
INSERT INTO parametre (name, parent, value, type, minval, maxval, lookupvalues, "default", explanation, sort, checkable) VALUES ('Sector data', 'Data', '', 'G', '', '', '', '', 'Gruppe for administration af Sektor tabeller', 2, ' ') ON CONFLICT (name) DO NOTHING;

DELETE FROM parametre WHERE name like 't_flood%' OR parent like 't_flood%';

INSERT INTO parametre (name, parent, value, type, minval, maxval, lookupvalues, "default", explanation, sort, checkable) VALUES ('t_flood'   , 'Flood data', 'fdc_data.oversvoem', 'S', '', '', '', '', 'Parametergruppe til tabel "oversvømmelser"', 1, ' ');
INSERT INTO parametre (name, parent, value, type, minval, maxval, lookupvalues, "default", explanation, sort, checkable) VALUES ('t_flood_2' , 'Flood data', 'fdc_data.oversvoem', 'S', '', '', '', '', 'Parametergruppe til tabel "oversvømmelser"', 2, ' ');
INSERT INTO parametre (name, parent, value, type, minval, maxval, lookupvalues, "default", explanation, sort, checkable) VALUES ('t_flood_3' , 'Flood data', 'fdc_data.oversvoem', 'S', '', '', '', '', 'Parametergruppe til tabel "oversvømmelser"', 3, ' ');
INSERT INTO parametre (name, parent, value, type, minval, maxval, lookupvalues, "default", explanation, sort, checkable) VALUES ('t_flood_4' , 'Flood data', 'fdc_data.oversvoem', 'S', '', '', '', '', 'Parametergruppe til tabel "oversvømmelser"', 4, ' ');
INSERT INTO parametre (name, parent, value, type, minval, maxval, lookupvalues, "default", explanation, sort, checkable) VALUES ('t_flood_5' , 'Flood data', 'fdc_data.oversvoem', 'S', '', '', '', '', 'Parametergruppe til tabel "oversvømmelser"', 5, ' ');
INSERT INTO parametre (name, parent, value, type, minval, maxval, lookupvalues, "default", explanation, sort, checkable) VALUES ('t_flood_6' , 'Flood data', 'fdc_data.oversvoem', 'S', '', '', '', '', 'Parametergruppe til tabel "oversvømmelser"', 6, ' ');
INSERT INTO parametre (name, parent, value, type, minval, maxval, lookupvalues, "default", explanation, sort, checkable) VALUES ('t_flood_7' , 'Flood data', 'fdc_data.oversvoem', 'S', '', '', '', '', 'Parametergruppe til tabel "oversvømmelser"', 7, ' ');
INSERT INTO parametre (name, parent, value, type, minval, maxval, lookupvalues, "default", explanation, sort, checkable) VALUES ('t_flood_8' , 'Flood data', 'fdc_data.oversvoem', 'S', '', '', '', '', 'Parametergruppe til tabel "oversvømmelser"', 8, ' ');
INSERT INTO parametre (name, parent, value, type, minval, maxval, lookupvalues, "default", explanation, sort, checkable) VALUES ('t_flood_9' , 'Flood data', 'fdc_data.oversvoem', 'S', '', '', '', '', 'Parametergruppe til tabel "oversvømmelser"', 9, ' ');
INSERT INTO parametre (name, parent, value, type, minval, maxval, lookupvalues, "default", explanation, sort, checkable) VALUES ('t_flood_10', 'Flood data', 'fdc_data.oversvoem', 'S', '', '', '', '', 'Parametergruppe til tabel "oversvømmelser"', 10, ' ');
INSERT INTO parametre (name, parent, value, type, minval, maxval, lookupvalues, "default", explanation, sort, checkable) VALUES ('t_flood_11', 'Flood data', 'fdc_data.oversvoem', 'S', '', '', '', '', 'Parametergruppe til tabel "oversvømmelser"', 11, ' ');
INSERT INTO parametre (name, parent, value, type, minval, maxval, lookupvalues, "default", explanation, sort, checkable) VALUES ('t_flood_12', 'Flood data', 'fdc_data.oversvoem', 'S', '', '', '', '', 'Parametergruppe til tabel "oversvømmelser"', 12, ' ');
INSERT INTO parametre (name, parent, value, type, minval, maxval, lookupvalues, "default", explanation, sort, checkable) VALUES ('t_flood_13', 'Flood data', 'fdc_data.oversvoem', 'S', '', '', '', '', 'Parametergruppe til tabel "oversvømmelser"', 13, ' ');
INSERT INTO parametre (name, parent, value, type, minval, maxval, lookupvalues, "default", explanation, sort, checkable) VALUES ('t_flood_14', 'Flood data', 'fdc_data.oversvoem', 'S', '', '', '', '', 'Parametergruppe til tabel "oversvømmelser"', 14, ' ');
INSERT INTO parametre (name, parent, value, type, minval, maxval, lookupvalues, "default", explanation, sort, checkable) VALUES ('t_flood_15', 'Flood data', 'fdc_data.oversvoem', 'S', '', '', '', '', 'Parametergruppe til tabel "oversvømmelser"', 15, ' ');
INSERT INTO parametre (name, parent, value, type, minval, maxval, lookupvalues, "default", explanation, sort, checkable) VALUES ('t_flood_16', 'Flood data', 'fdc_data.oversvoem', 'S', '', '', '', '', 'Parametergruppe til tabel "oversvømmelser"', 16, ' ');
INSERT INTO parametre (name, parent, value, type, minval, maxval, lookupvalues, "default", explanation, sort, checkable) VALUES ('t_flood_17', 'Flood data', 'fdc_data.oversvoem', 'S', '', '', '', '', 'Parametergruppe til tabel "oversvømmelser"', 17, ' ');
INSERT INTO parametre (name, parent, value, type, minval, maxval, lookupvalues, "default", explanation, sort, checkable) VALUES ('t_flood_18', 'Flood data', 'fdc_data.oversvoem', 'S', '', '', '', '', 'Parametergruppe til tabel "oversvømmelser"', 18, ' ');
INSERT INTO parametre (name, parent, value, type, minval, maxval, lookupvalues, "default", explanation, sort, checkable) VALUES ('t_flood_19', 'Flood data', 'fdc_data.oversvoem', 'S', '', '', '', '', 'Parametergruppe til tabel "oversvømmelser"', 19, ' ');
INSERT INTO parametre (name, parent, value, type, minval, maxval, lookupvalues, "default", explanation, sort, checkable) VALUES ('t_flood_20', 'Flood data', 'fdc_data.oversvoem', 'S', '', '', '', '', 'Parametergruppe til tabel "oversvømmelser"', 20, ' ');
INSERT INTO parametre (name, parent, value, type, minval, maxval, lookupvalues, "default", explanation, sort, checkable) VALUES ('t_flood_21', 'Flood data', 'fdc_data.oversvoem', 'S', '', '', '', '', 'Parametergruppe til tabel "oversvømmelser"', 21, ' ');
INSERT INTO parametre (name, parent, value, type, minval, maxval, lookupvalues, "default", explanation, sort, checkable) VALUES ('t_flood_22', 'Flood data', 'fdc_data.oversvoem', 'S', '', '', '', '', 'Parametergruppe til tabel "oversvømmelser"', 22, ' ');
INSERT INTO parametre (name, parent, value, type, minval, maxval, lookupvalues, "default", explanation, sort, checkable) VALUES ('t_flood_23', 'Flood data', 'fdc_data.oversvoem', 'S', '', '', '', '', 'Parametergruppe til tabel "oversvømmelser"', 23, ' ');
INSERT INTO parametre (name, parent, value, type, minval, maxval, lookupvalues, "default", explanation, sort, checkable) VALUES ('t_flood_24', 'Flood data', 'fdc_data.oversvoem', 'S', '', '', '', '', 'Parametergruppe til tabel "oversvømmelser"', 24, ' ');
INSERT INTO parametre (name, parent, value, type, minval, maxval, lookupvalues, "default", explanation, sort, checkable) VALUES ('t_flood_25', 'Flood data', 'fdc_data.oversvoem', 'S', '', '', '', '', 'Parametergruppe til tabel "oversvømmelser"', 25, ' ');
INSERT INTO parametre (name, parent, value, type, minval, maxval, lookupvalues, "default", explanation, sort, checkable) VALUES ('t_flood_26', 'Flood data', 'fdc_data.oversvoem', 'S', '', '', '', '', 'Parametergruppe til tabel "oversvømmelser"', 26, ' ');
INSERT INTO parametre (name, parent, value, type, minval, maxval, lookupvalues, "default", explanation, sort, checkable) VALUES ('t_flood_27', 'Flood data', 'fdc_data.oversvoem', 'S', '', '', '', '', 'Parametergruppe til tabel "oversvømmelser"', 27, ' ');
INSERT INTO parametre (name, parent, value, type, minval, maxval, lookupvalues, "default", explanation, sort, checkable) VALUES ('t_flood_28', 'Flood data', 'fdc_data.oversvoem', 'S', '', '', '', '', 'Parametergruppe til tabel "oversvømmelser"', 28, ' ');
INSERT INTO parametre (name, parent, value, type, minval, maxval, lookupvalues, "default", explanation, sort, checkable) VALUES ('t_flood_29', 'Flood data', 'fdc_data.oversvoem', 'S', '', '', '', '', 'Parametergruppe til tabel "oversvømmelser"', 29, ' ');
INSERT INTO parametre (name, parent, value, type, minval, maxval, lookupvalues, "default", explanation, sort, checkable) VALUES ('t_flood_30', 'Flood data', 'fdc_data.oversvoem', 'S', '', '', '', '', 'Parametergruppe til tabel "oversvømmelser"', 30, ' ');
INSERT INTO parametre (name, parent, value, type, minval, maxval, lookupvalues, "default", explanation, sort, checkable) VALUES ('t_flood_31', 'Flood data', 'fdc_data.oversvoem', 'S', '', '', '', '', 'Parametergruppe til tabel "oversvømmelser"', 31, ' ');
INSERT INTO parametre (name, parent, value, type, minval, maxval, lookupvalues, "default", explanation, sort, checkable) VALUES ('t_flood_32', 'Flood data', 'fdc_data.oversvoem', 'S', '', '', '', '', 'Parametergruppe til tabel "oversvømmelser"', 32, ' ');
INSERT INTO parametre (name, parent, value, type, minval, maxval, lookupvalues, "default", explanation, sort, checkable) VALUES ('t_flood_33', 'Flood data', 'fdc_data.oversvoem', 'S', '', '', '', '', 'Parametergruppe til tabel "oversvømmelser"', 33, ' ');
INSERT INTO parametre (name, parent, value, type, minval, maxval, lookupvalues, "default", explanation, sort, checkable) VALUES ('t_flood_34', 'Flood data', 'fdc_data.oversvoem', 'S', '', '', '', '', 'Parametergruppe til tabel "oversvømmelser"', 34, ' ');
INSERT INTO parametre (name, parent, value, type, minval, maxval, lookupvalues, "default", explanation, sort, checkable) VALUES ('t_flood_35', 'Flood data', 'fdc_data.oversvoem', 'S', '', '', '', '', 'Parametergruppe til tabel "oversvømmelser"', 35, ' ');
INSERT INTO parametre (name, parent, value, type, minval, maxval, lookupvalues, "default", explanation, sort, checkable) VALUES ('t_flood_36', 'Flood data', 'fdc_data.oversvoem', 'S', '', '', '', '', 'Parametergruppe til tabel "oversvømmelser"', 36, ' ');
INSERT INTO parametre (name, parent, value, type, minval, maxval, lookupvalues, "default", explanation, sort, checkable) VALUES ('t_flood_37', 'Flood data', 'fdc_data.oversvoem', 'S', '', '', '', '', 'Parametergruppe til tabel "oversvømmelser"', 37, ' ');
INSERT INTO parametre (name, parent, value, type, minval, maxval, lookupvalues, "default", explanation, sort, checkable) VALUES ('t_flood_38', 'Flood data', 'fdc_data.oversvoem', 'S', '', '', '', '', 'Parametergruppe til tabel "oversvømmelser"', 38, ' ');
INSERT INTO parametre (name, parent, value, type, minval, maxval, lookupvalues, "default", explanation, sort, checkable) VALUES ('t_flood_39', 'Flood data', 'fdc_data.oversvoem', 'S', '', '', '', '', 'Parametergruppe til tabel "oversvømmelser"', 39, ' ');
INSERT INTO parametre (name, parent, value, type, minval, maxval, lookupvalues, "default", explanation, sort, checkable) VALUES ('t_flood_40', 'Flood data', 'fdc_data.oversvoem', 'S', '', '', '', '', 'Parametergruppe til tabel "oversvømmelser"', 40, ' ');
INSERT INTO parametre (name, parent, value, type, minval, maxval, lookupvalues, "default", explanation, sort, checkable) VALUES ('t_flood_41', 'Flood data', 'fdc_data.oversvoem', 'S', '', '', '', '', 'Parametergruppe til tabel "oversvømmelser"', 41, ' ');
INSERT INTO parametre (name, parent, value, type, minval, maxval, lookupvalues, "default", explanation, sort, checkable) VALUES ('t_flood_42', 'Flood data', 'fdc_data.oversvoem', 'S', '', '', '', '', 'Parametergruppe til tabel "oversvømmelser"', 42, ' ');
INSERT INTO parametre (name, parent, value, type, minval, maxval, lookupvalues, "default", explanation, sort, checkable) VALUES ('t_flood_43', 'Flood data', 'fdc_data.oversvoem', 'S', '', '', '', '', 'Parametergruppe til tabel "oversvømmelser"', 43, ' ');
INSERT INTO parametre (name, parent, value, type, minval, maxval, lookupvalues, "default", explanation, sort, checkable) VALUES ('t_flood_44', 'Flood data', 'fdc_data.oversvoem', 'S', '', '', '', '', 'Parametergruppe til tabel "oversvømmelser"', 44, ' ');
INSERT INTO parametre (name, parent, value, type, minval, maxval, lookupvalues, "default", explanation, sort, checkable) VALUES ('t_flood_45', 'Flood data', 'fdc_data.oversvoem', 'S', '', '', '', '', 'Parametergruppe til tabel "oversvømmelser"', 45, ' ');
INSERT INTO parametre (name, parent, value, type, minval, maxval, lookupvalues, "default", explanation, sort, checkable) VALUES ('t_flood_46', 'Flood data', 'fdc_data.oversvoem', 'S', '', '', '', '', 'Parametergruppe til tabel "oversvømmelser"', 46, ' ');
INSERT INTO parametre (name, parent, value, type, minval, maxval, lookupvalues, "default", explanation, sort, checkable) VALUES ('t_flood_47', 'Flood data', 'fdc_data.oversvoem', 'S', '', '', '', '', 'Parametergruppe til tabel "oversvømmelser"', 47, ' ');
INSERT INTO parametre (name, parent, value, type, minval, maxval, lookupvalues, "default", explanation, sort, checkable) VALUES ('t_flood_48', 'Flood data', 'fdc_data.oversvoem', 'S', '', '', '', '', 'Parametergruppe til tabel "oversvømmelser"', 48, ' ');
INSERT INTO parametre (name, parent, value, type, minval, maxval, lookupvalues, "default", explanation, sort, checkable) VALUES ('t_flood_49', 'Flood data', 'fdc_data.oversvoem', 'S', '', '', '', '', 'Parametergruppe til tabel "oversvømmelser"', 49, ' ');
INSERT INTO parametre (name, parent, value, type, minval, maxval, lookupvalues, "default", explanation, sort, checkable) VALUES ('t_flood_50', 'Flood data', 'fdc_data.oversvoem', 'S', '', '', '', '', 'Parametergruppe til tabel "oversvømmelser"', 50, ' ');
INSERT INTO parametre (name, parent, value, type, minval, maxval, lookupvalues, "default", explanation, sort, checkable) VALUES ('f_geom_t_flood'   , 't_flood'   , 'geom', 'F', '', '', '', '', 'Field name for geometry field in flood table', 10, ' ');
INSERT INTO parametre (name, parent, value, type, minval, maxval, lookupvalues, "default", explanation, sort, checkable) VALUES ('f_geom_t_flood_2' , 't_flood_2' , 'geom', 'F', '', '', '', '', 'Field name for geometry field in flood table', 10, ' ');
INSERT INTO parametre (name, parent, value, type, minval, maxval, lookupvalues, "default", explanation, sort, checkable) VALUES ('f_geom_t_flood_3' , 't_flood_3' , 'geom', 'F', '', '', '', '', 'Field name for geometry field in flood table', 10, ' ');
INSERT INTO parametre (name, parent, value, type, minval, maxval, lookupvalues, "default", explanation, sort, checkable) VALUES ('f_geom_t_flood_4' , 't_flood_4' , 'geom', 'F', '', '', '', '', 'Field name for geometry field in flood table', 10, ' ');
INSERT INTO parametre (name, parent, value, type, minval, maxval, lookupvalues, "default", explanation, sort, checkable) VALUES ('f_geom_t_flood_5' , 't_flood_5' , 'geom', 'F', '', '', '', '', 'Field name for geometry field in flood table', 10, ' ');
INSERT INTO parametre (name, parent, value, type, minval, maxval, lookupvalues, "default", explanation, sort, checkable) VALUES ('f_geom_t_flood_6' , 't_flood_6' , 'geom', 'F', '', '', '', '', 'Field name for geometry field in flood table', 10, ' ');
INSERT INTO parametre (name, parent, value, type, minval, maxval, lookupvalues, "default", explanation, sort, checkable) VALUES ('f_geom_t_flood_7' , 't_flood_7' , 'geom', 'F', '', '', '', '', 'Field name for geometry field in flood table', 10, ' ');
INSERT INTO parametre (name, parent, value, type, minval, maxval, lookupvalues, "default", explanation, sort, checkable) VALUES ('f_geom_t_flood_8' , 't_flood_8' , 'geom', 'F', '', '', '', '', 'Field name for geometry field in flood table', 10, ' ');
INSERT INTO parametre (name, parent, value, type, minval, maxval, lookupvalues, "default", explanation, sort, checkable) VALUES ('f_geom_t_flood_9' , 't_flood_9' , 'geom', 'F', '', '', '', '', 'Field name for geometry field in flood table', 10, ' ');
INSERT INTO parametre (name, parent, value, type, minval, maxval, lookupvalues, "default", explanation, sort, checkable) VALUES ('f_geom_t_flood_10', 't_flood_10', 'geom', 'F', '', '', '', '', 'Field name for geometry field in flood table', 10, ' ');
INSERT INTO parametre (name, parent, value, type, minval, maxval, lookupvalues, "default", explanation, sort, checkable) VALUES ('f_geom_t_flood_11', 't_flood_11', 'geom', 'F', '', '', '', '', 'Field name for geometry field in flood table', 10, ' ');
INSERT INTO parametre (name, parent, value, type, minval, maxval, lookupvalues, "default", explanation, sort, checkable) VALUES ('f_geom_t_flood_12', 't_flood_12', 'geom', 'F', '', '', '', '', 'Field name for geometry field in flood table', 10, ' ');
INSERT INTO parametre (name, parent, value, type, minval, maxval, lookupvalues, "default", explanation, sort, checkable) VALUES ('f_geom_t_flood_13', 't_flood_13', 'geom', 'F', '', '', '', '', 'Field name for geometry field in flood table', 10, ' ');
INSERT INTO parametre (name, parent, value, type, minval, maxval, lookupvalues, "default", explanation, sort, checkable) VALUES ('f_geom_t_flood_14', 't_flood_14', 'geom', 'F', '', '', '', '', 'Field name for geometry field in flood table', 10, ' ');
INSERT INTO parametre (name, parent, value, type, minval, maxval, lookupvalues, "default", explanation, sort, checkable) VALUES ('f_geom_t_flood_15', 't_flood_15', 'geom', 'F', '', '', '', '', 'Field name for geometry field in flood table', 10, ' ');
INSERT INTO parametre (name, parent, value, type, minval, maxval, lookupvalues, "default", explanation, sort, checkable) VALUES ('f_geom_t_flood_16', 't_flood_16', 'geom', 'F', '', '', '', '', 'Field name for geometry field in flood table', 10, ' ');
INSERT INTO parametre (name, parent, value, type, minval, maxval, lookupvalues, "default", explanation, sort, checkable) VALUES ('f_geom_t_flood_17', 't_flood_17', 'geom', 'F', '', '', '', '', 'Field name for geometry field in flood table', 10, ' ');
INSERT INTO parametre (name, parent, value, type, minval, maxval, lookupvalues, "default", explanation, sort, checkable) VALUES ('f_geom_t_flood_18', 't_flood_18', 'geom', 'F', '', '', '', '', 'Field name for geometry field in flood table', 10, ' ');
INSERT INTO parametre (name, parent, value, type, minval, maxval, lookupvalues, "default", explanation, sort, checkable) VALUES ('f_geom_t_flood_19', 't_flood_19', 'geom', 'F', '', '', '', '', 'Field name for geometry field in flood table', 10, ' ');
INSERT INTO parametre (name, parent, value, type, minval, maxval, lookupvalues, "default", explanation, sort, checkable) VALUES ('f_geom_t_flood_20', 't_flood_20', 'geom', 'F', '', '', '', '', 'Field name for geometry field in flood table', 10, ' ');
INSERT INTO parametre (name, parent, value, type, minval, maxval, lookupvalues, "default", explanation, sort, checkable) VALUES ('f_geom_t_flood_21', 't_flood_21', 'geom', 'F', '', '', '', '', 'Field name for geometry field in flood table', 10, ' ');
INSERT INTO parametre (name, parent, value, type, minval, maxval, lookupvalues, "default", explanation, sort, checkable) VALUES ('f_geom_t_flood_22', 't_flood_22', 'geom', 'F', '', '', '', '', 'Field name for geometry field in flood table', 10, ' ');
INSERT INTO parametre (name, parent, value, type, minval, maxval, lookupvalues, "default", explanation, sort, checkable) VALUES ('f_geom_t_flood_23', 't_flood_23', 'geom', 'F', '', '', '', '', 'Field name for geometry field in flood table', 10, ' ');
INSERT INTO parametre (name, parent, value, type, minval, maxval, lookupvalues, "default", explanation, sort, checkable) VALUES ('f_geom_t_flood_24', 't_flood_24', 'geom', 'F', '', '', '', '', 'Field name for geometry field in flood table', 10, ' ');
INSERT INTO parametre (name, parent, value, type, minval, maxval, lookupvalues, "default", explanation, sort, checkable) VALUES ('f_geom_t_flood_25', 't_flood_25', 'geom', 'F', '', '', '', '', 'Field name for geometry field in flood table', 10, ' ');
INSERT INTO parametre (name, parent, value, type, minval, maxval, lookupvalues, "default", explanation, sort, checkable) VALUES ('f_geom_t_flood_26', 't_flood_26', 'geom', 'F', '', '', '', '', 'Field name for geometry field in flood table', 10, ' ');
INSERT INTO parametre (name, parent, value, type, minval, maxval, lookupvalues, "default", explanation, sort, checkable) VALUES ('f_geom_t_flood_27', 't_flood_27', 'geom', 'F', '', '', '', '', 'Field name for geometry field in flood table', 10, ' ');
INSERT INTO parametre (name, parent, value, type, minval, maxval, lookupvalues, "default", explanation, sort, checkable) VALUES ('f_geom_t_flood_28', 't_flood_28', 'geom', 'F', '', '', '', '', 'Field name for geometry field in flood table', 10, ' ');
INSERT INTO parametre (name, parent, value, type, minval, maxval, lookupvalues, "default", explanation, sort, checkable) VALUES ('f_geom_t_flood_29', 't_flood_29', 'geom', 'F', '', '', '', '', 'Field name for geometry field in flood table', 10, ' ');
INSERT INTO parametre (name, parent, value, type, minval, maxval, lookupvalues, "default", explanation, sort, checkable) VALUES ('f_geom_t_flood_30', 't_flood_30', 'geom', 'F', '', '', '', '', 'Field name for geometry field in flood table', 10, ' ');
INSERT INTO parametre (name, parent, value, type, minval, maxval, lookupvalues, "default", explanation, sort, checkable) VALUES ('f_geom_t_flood_31', 't_flood_31', 'geom', 'F', '', '', '', '', 'Field name for geometry field in flood table', 10, ' ');
INSERT INTO parametre (name, parent, value, type, minval, maxval, lookupvalues, "default", explanation, sort, checkable) VALUES ('f_geom_t_flood_32', 't_flood_32', 'geom', 'F', '', '', '', '', 'Field name for geometry field in flood table', 10, ' ');
INSERT INTO parametre (name, parent, value, type, minval, maxval, lookupvalues, "default", explanation, sort, checkable) VALUES ('f_geom_t_flood_33', 't_flood_33', 'geom', 'F', '', '', '', '', 'Field name for geometry field in flood table', 10, ' ');
INSERT INTO parametre (name, parent, value, type, minval, maxval, lookupvalues, "default", explanation, sort, checkable) VALUES ('f_geom_t_flood_34', 't_flood_34', 'geom', 'F', '', '', '', '', 'Field name for geometry field in flood table', 10, ' ');
INSERT INTO parametre (name, parent, value, type, minval, maxval, lookupvalues, "default", explanation, sort, checkable) VALUES ('f_geom_t_flood_35', 't_flood_35', 'geom', 'F', '', '', '', '', 'Field name for geometry field in flood table', 10, ' ');
INSERT INTO parametre (name, parent, value, type, minval, maxval, lookupvalues, "default", explanation, sort, checkable) VALUES ('f_geom_t_flood_36', 't_flood_36', 'geom', 'F', '', '', '', '', 'Field name for geometry field in flood table', 10, ' ');
INSERT INTO parametre (name, parent, value, type, minval, maxval, lookupvalues, "default", explanation, sort, checkable) VALUES ('f_geom_t_flood_37', 't_flood_37', 'geom', 'F', '', '', '', '', 'Field name for geometry field in flood table', 10, ' ');
INSERT INTO parametre (name, parent, value, type, minval, maxval, lookupvalues, "default", explanation, sort, checkable) VALUES ('f_geom_t_flood_38', 't_flood_38', 'geom', 'F', '', '', '', '', 'Field name for geometry field in flood table', 10, ' ');
INSERT INTO parametre (name, parent, value, type, minval, maxval, lookupvalues, "default", explanation, sort, checkable) VALUES ('f_geom_t_flood_39', 't_flood_39', 'geom', 'F', '', '', '', '', 'Field name for geometry field in flood table', 10, ' ');
INSERT INTO parametre (name, parent, value, type, minval, maxval, lookupvalues, "default", explanation, sort, checkable) VALUES ('f_geom_t_flood_40', 't_flood_40', 'geom', 'F', '', '', '', '', 'Field name for geometry field in flood table', 10, ' ');
INSERT INTO parametre (name, parent, value, type, minval, maxval, lookupvalues, "default", explanation, sort, checkable) VALUES ('f_geom_t_flood_41', 't_flood_41', 'geom', 'F', '', '', '', '', 'Field name for geometry field in flood table', 10, ' ');
INSERT INTO parametre (name, parent, value, type, minval, maxval, lookupvalues, "default", explanation, sort, checkable) VALUES ('f_geom_t_flood_42', 't_flood_42', 'geom', 'F', '', '', '', '', 'Field name for geometry field in flood table', 10, ' ');
INSERT INTO parametre (name, parent, value, type, minval, maxval, lookupvalues, "default", explanation, sort, checkable) VALUES ('f_geom_t_flood_43', 't_flood_43', 'geom', 'F', '', '', '', '', 'Field name for geometry field in flood table', 10, ' ');
INSERT INTO parametre (name, parent, value, type, minval, maxval, lookupvalues, "default", explanation, sort, checkable) VALUES ('f_geom_t_flood_44', 't_flood_44', 'geom', 'F', '', '', '', '', 'Field name for geometry field in flood table', 10, ' ');
INSERT INTO parametre (name, parent, value, type, minval, maxval, lookupvalues, "default", explanation, sort, checkable) VALUES ('f_geom_t_flood_45', 't_flood_45', 'geom', 'F', '', '', '', '', 'Field name for geometry field in flood table', 10, ' ');
INSERT INTO parametre (name, parent, value, type, minval, maxval, lookupvalues, "default", explanation, sort, checkable) VALUES ('f_geom_t_flood_46', 't_flood_46', 'geom', 'F', '', '', '', '', 'Field name for geometry field in flood table', 10, ' ');
INSERT INTO parametre (name, parent, value, type, minval, maxval, lookupvalues, "default", explanation, sort, checkable) VALUES ('f_geom_t_flood_47', 't_flood_47', 'geom', 'F', '', '', '', '', 'Field name for geometry field in flood table', 10, ' ');
INSERT INTO parametre (name, parent, value, type, minval, maxval, lookupvalues, "default", explanation, sort, checkable) VALUES ('f_geom_t_flood_48', 't_flood_48', 'geom', 'F', '', '', '', '', 'Field name for geometry field in flood table', 10, ' ');
INSERT INTO parametre (name, parent, value, type, minval, maxval, lookupvalues, "default", explanation, sort, checkable) VALUES ('f_geom_t_flood_49', 't_flood_49', 'geom', 'F', '', '', '', '', 'Field name for geometry field in flood table', 10, ' ');
INSERT INTO parametre (name, parent, value, type, minval, maxval, lookupvalues, "default", explanation, sort, checkable) VALUES ('f_geom_t_flood_50', 't_flood_50', 'geom', 'F', '', '', '', '', 'Field name for geometry field in flood table', 10, ' ');
INSERT INTO parametre (name, parent, value, type, minval, maxval, lookupvalues, "default", explanation, sort, checkable) VALUES ('f_depth_t_flood'   , 't_flood'   , 'vanddybde_m', 'F', '', '', '', '', 'Field name for detph field in flood table ', 10, ' ');
INSERT INTO parametre (name, parent, value, type, minval, maxval, lookupvalues, "default", explanation, sort, checkable) VALUES ('f_depth_t_flood_2' , 't_flood_2' , 'vanddybde_m', 'F', '', '', '', '', 'Field name for detph field in flood table ', 10, ' ');
INSERT INTO parametre (name, parent, value, type, minval, maxval, lookupvalues, "default", explanation, sort, checkable) VALUES ('f_depth_t_flood_3' , 't_flood_3' , 'vanddybde_m', 'F', '', '', '', '', 'Field name for detph field in flood table ', 10, ' ');
INSERT INTO parametre (name, parent, value, type, minval, maxval, lookupvalues, "default", explanation, sort, checkable) VALUES ('f_depth_t_flood_4' , 't_flood_4' , 'vanddybde_m', 'F', '', '', '', '', 'Field name for detph field in flood table ', 10, ' ');
INSERT INTO parametre (name, parent, value, type, minval, maxval, lookupvalues, "default", explanation, sort, checkable) VALUES ('f_depth_t_flood_5' , 't_flood_5' , 'vanddybde_m', 'F', '', '', '', '', 'Field name for detph field in flood table ', 10, ' ');
INSERT INTO parametre (name, parent, value, type, minval, maxval, lookupvalues, "default", explanation, sort, checkable) VALUES ('f_depth_t_flood_6' , 't_flood_6' , 'vanddybde_m', 'F', '', '', '', '', 'Field name for detph field in flood table ', 10, ' ');
INSERT INTO parametre (name, parent, value, type, minval, maxval, lookupvalues, "default", explanation, sort, checkable) VALUES ('f_depth_t_flood_7' , 't_flood_7' , 'vanddybde_m', 'F', '', '', '', '', 'Field name for detph field in flood table ', 10, ' ');
INSERT INTO parametre (name, parent, value, type, minval, maxval, lookupvalues, "default", explanation, sort, checkable) VALUES ('f_depth_t_flood_8' , 't_flood_8' , 'vanddybde_m', 'F', '', '', '', '', 'Field name for detph field in flood table ', 10, ' ');
INSERT INTO parametre (name, parent, value, type, minval, maxval, lookupvalues, "default", explanation, sort, checkable) VALUES ('f_depth_t_flood_9' , 't_flood_9' , 'vanddybde_m', 'F', '', '', '', '', 'Field name for detph field in flood table ', 10, ' ');
INSERT INTO parametre (name, parent, value, type, minval, maxval, lookupvalues, "default", explanation, sort, checkable) VALUES ('f_depth_t_flood_10', 't_flood_10', 'vanddybde_m', 'F', '', '', '', '', 'Field name for detph field in flood table ', 10, ' ');
INSERT INTO parametre (name, parent, value, type, minval, maxval, lookupvalues, "default", explanation, sort, checkable) VALUES ('f_depth_t_flood_11', 't_flood_11', 'vanddybde_m', 'F', '', '', '', '', 'Field name for detph field in flood table ', 10, ' ');
INSERT INTO parametre (name, parent, value, type, minval, maxval, lookupvalues, "default", explanation, sort, checkable) VALUES ('f_depth_t_flood_12', 't_flood_12', 'vanddybde_m', 'F', '', '', '', '', 'Field name for detph field in flood table ', 10, ' ');
INSERT INTO parametre (name, parent, value, type, minval, maxval, lookupvalues, "default", explanation, sort, checkable) VALUES ('f_depth_t_flood_13', 't_flood_13', 'vanddybde_m', 'F', '', '', '', '', 'Field name for detph field in flood table ', 10, ' ');
INSERT INTO parametre (name, parent, value, type, minval, maxval, lookupvalues, "default", explanation, sort, checkable) VALUES ('f_depth_t_flood_14', 't_flood_14', 'vanddybde_m', 'F', '', '', '', '', 'Field name for detph field in flood table ', 10, ' ');
INSERT INTO parametre (name, parent, value, type, minval, maxval, lookupvalues, "default", explanation, sort, checkable) VALUES ('f_depth_t_flood_15', 't_flood_15', 'vanddybde_m', 'F', '', '', '', '', 'Field name for detph field in flood table ', 10, ' ');
INSERT INTO parametre (name, parent, value, type, minval, maxval, lookupvalues, "default", explanation, sort, checkable) VALUES ('f_depth_t_flood_16', 't_flood_16', 'vanddybde_m', 'F', '', '', '', '', 'Field name for detph field in flood table ', 10, ' ');
INSERT INTO parametre (name, parent, value, type, minval, maxval, lookupvalues, "default", explanation, sort, checkable) VALUES ('f_depth_t_flood_17', 't_flood_17', 'vanddybde_m', 'F', '', '', '', '', 'Field name for detph field in flood table ', 10, ' ');
INSERT INTO parametre (name, parent, value, type, minval, maxval, lookupvalues, "default", explanation, sort, checkable) VALUES ('f_depth_t_flood_18', 't_flood_18', 'vanddybde_m', 'F', '', '', '', '', 'Field name for detph field in flood table ', 10, ' ');
INSERT INTO parametre (name, parent, value, type, minval, maxval, lookupvalues, "default", explanation, sort, checkable) VALUES ('f_depth_t_flood_19', 't_flood_19', 'vanddybde_m', 'F', '', '', '', '', 'Field name for detph field in flood table ', 10, ' ');
INSERT INTO parametre (name, parent, value, type, minval, maxval, lookupvalues, "default", explanation, sort, checkable) VALUES ('f_depth_t_flood_20', 't_flood_20', 'vanddybde_m', 'F', '', '', '', '', 'Field name for detph field in flood table ', 10, ' ');
INSERT INTO parametre (name, parent, value, type, minval, maxval, lookupvalues, "default", explanation, sort, checkable) VALUES ('f_depth_t_flood_21', 't_flood_21', 'vanddybde_m', 'F', '', '', '', '', 'Field name for detph field in flood table ', 10, ' ');
INSERT INTO parametre (name, parent, value, type, minval, maxval, lookupvalues, "default", explanation, sort, checkable) VALUES ('f_depth_t_flood_22', 't_flood_22', 'vanddybde_m', 'F', '', '', '', '', 'Field name for detph field in flood table ', 10, ' ');
INSERT INTO parametre (name, parent, value, type, minval, maxval, lookupvalues, "default", explanation, sort, checkable) VALUES ('f_depth_t_flood_23', 't_flood_23', 'vanddybde_m', 'F', '', '', '', '', 'Field name for detph field in flood table ', 10, ' ');
INSERT INTO parametre (name, parent, value, type, minval, maxval, lookupvalues, "default", explanation, sort, checkable) VALUES ('f_depth_t_flood_24', 't_flood_24', 'vanddybde_m', 'F', '', '', '', '', 'Field name for detph field in flood table ', 10, ' ');
INSERT INTO parametre (name, parent, value, type, minval, maxval, lookupvalues, "default", explanation, sort, checkable) VALUES ('f_depth_t_flood_25', 't_flood_25', 'vanddybde_m', 'F', '', '', '', '', 'Field name for detph field in flood table ', 10, ' ');
INSERT INTO parametre (name, parent, value, type, minval, maxval, lookupvalues, "default", explanation, sort, checkable) VALUES ('f_depth_t_flood_26', 't_flood_26', 'vanddybde_m', 'F', '', '', '', '', 'Field name for detph field in flood table ', 10, ' ');
INSERT INTO parametre (name, parent, value, type, minval, maxval, lookupvalues, "default", explanation, sort, checkable) VALUES ('f_depth_t_flood_27', 't_flood_27', 'vanddybde_m', 'F', '', '', '', '', 'Field name for detph field in flood table ', 10, ' ');
INSERT INTO parametre (name, parent, value, type, minval, maxval, lookupvalues, "default", explanation, sort, checkable) VALUES ('f_depth_t_flood_28', 't_flood_28', 'vanddybde_m', 'F', '', '', '', '', 'Field name for detph field in flood table ', 10, ' ');
INSERT INTO parametre (name, parent, value, type, minval, maxval, lookupvalues, "default", explanation, sort, checkable) VALUES ('f_depth_t_flood_29', 't_flood_29', 'vanddybde_m', 'F', '', '', '', '', 'Field name for detph field in flood table ', 10, ' ');
INSERT INTO parametre (name, parent, value, type, minval, maxval, lookupvalues, "default", explanation, sort, checkable) VALUES ('f_depth_t_flood_30', 't_flood_30', 'vanddybde_m', 'F', '', '', '', '', 'Field name for detph field in flood table ', 10, ' ');
INSERT INTO parametre (name, parent, value, type, minval, maxval, lookupvalues, "default", explanation, sort, checkable) VALUES ('f_depth_t_flood_31', 't_flood_31', 'vanddybde_m', 'F', '', '', '', '', 'Field name for detph field in flood table ', 10, ' ');
INSERT INTO parametre (name, parent, value, type, minval, maxval, lookupvalues, "default", explanation, sort, checkable) VALUES ('f_depth_t_flood_32', 't_flood_32', 'vanddybde_m', 'F', '', '', '', '', 'Field name for detph field in flood table ', 10, ' ');
INSERT INTO parametre (name, parent, value, type, minval, maxval, lookupvalues, "default", explanation, sort, checkable) VALUES ('f_depth_t_flood_33', 't_flood_33', 'vanddybde_m', 'F', '', '', '', '', 'Field name for detph field in flood table ', 10, ' ');
INSERT INTO parametre (name, parent, value, type, minval, maxval, lookupvalues, "default", explanation, sort, checkable) VALUES ('f_depth_t_flood_34', 't_flood_34', 'vanddybde_m', 'F', '', '', '', '', 'Field name for detph field in flood table ', 10, ' ');
INSERT INTO parametre (name, parent, value, type, minval, maxval, lookupvalues, "default", explanation, sort, checkable) VALUES ('f_depth_t_flood_35', 't_flood_35', 'vanddybde_m', 'F', '', '', '', '', 'Field name for detph field in flood table ', 10, ' ');
INSERT INTO parametre (name, parent, value, type, minval, maxval, lookupvalues, "default", explanation, sort, checkable) VALUES ('f_depth_t_flood_36', 't_flood_36', 'vanddybde_m', 'F', '', '', '', '', 'Field name for detph field in flood table ', 10, ' ');
INSERT INTO parametre (name, parent, value, type, minval, maxval, lookupvalues, "default", explanation, sort, checkable) VALUES ('f_depth_t_flood_37', 't_flood_37', 'vanddybde_m', 'F', '', '', '', '', 'Field name for detph field in flood table ', 10, ' ');
INSERT INTO parametre (name, parent, value, type, minval, maxval, lookupvalues, "default", explanation, sort, checkable) VALUES ('f_depth_t_flood_38', 't_flood_38', 'vanddybde_m', 'F', '', '', '', '', 'Field name for detph field in flood table ', 10, ' ');
INSERT INTO parametre (name, parent, value, type, minval, maxval, lookupvalues, "default", explanation, sort, checkable) VALUES ('f_depth_t_flood_39', 't_flood_39', 'vanddybde_m', 'F', '', '', '', '', 'Field name for detph field in flood table ', 10, ' ');
INSERT INTO parametre (name, parent, value, type, minval, maxval, lookupvalues, "default", explanation, sort, checkable) VALUES ('f_depth_t_flood_40', 't_flood_40', 'vanddybde_m', 'F', '', '', '', '', 'Field name for detph field in flood table ', 10, ' ');
INSERT INTO parametre (name, parent, value, type, minval, maxval, lookupvalues, "default", explanation, sort, checkable) VALUES ('f_depth_t_flood_41', 't_flood_41', 'vanddybde_m', 'F', '', '', '', '', 'Field name for detph field in flood table ', 10, ' ');
INSERT INTO parametre (name, parent, value, type, minval, maxval, lookupvalues, "default", explanation, sort, checkable) VALUES ('f_depth_t_flood_42', 't_flood_42', 'vanddybde_m', 'F', '', '', '', '', 'Field name for detph field in flood table ', 10, ' ');
INSERT INTO parametre (name, parent, value, type, minval, maxval, lookupvalues, "default", explanation, sort, checkable) VALUES ('f_depth_t_flood_43', 't_flood_43', 'vanddybde_m', 'F', '', '', '', '', 'Field name for detph field in flood table ', 10, ' ');
INSERT INTO parametre (name, parent, value, type, minval, maxval, lookupvalues, "default", explanation, sort, checkable) VALUES ('f_depth_t_flood_44', 't_flood_44', 'vanddybde_m', 'F', '', '', '', '', 'Field name for detph field in flood table ', 10, ' ');
INSERT INTO parametre (name, parent, value, type, minval, maxval, lookupvalues, "default", explanation, sort, checkable) VALUES ('f_depth_t_flood_45', 't_flood_45', 'vanddybde_m', 'F', '', '', '', '', 'Field name for detph field in flood table ', 10, ' ');
INSERT INTO parametre (name, parent, value, type, minval, maxval, lookupvalues, "default", explanation, sort, checkable) VALUES ('f_depth_t_flood_46', 't_flood_46', 'vanddybde_m', 'F', '', '', '', '', 'Field name for detph field in flood table ', 10, ' ');
INSERT INTO parametre (name, parent, value, type, minval, maxval, lookupvalues, "default", explanation, sort, checkable) VALUES ('f_depth_t_flood_47', 't_flood_47', 'vanddybde_m', 'F', '', '', '', '', 'Field name for detph field in flood table ', 10, ' ');
INSERT INTO parametre (name, parent, value, type, minval, maxval, lookupvalues, "default", explanation, sort, checkable) VALUES ('f_depth_t_flood_48', 't_flood_48', 'vanddybde_m', 'F', '', '', '', '', 'Field name for detph field in flood table ', 10, ' ');
INSERT INTO parametre (name, parent, value, type, minval, maxval, lookupvalues, "default", explanation, sort, checkable) VALUES ('f_depth_t_flood_49', 't_flood_49', 'vanddybde_m', 'F', '', '', '', '', 'Field name for detph field in flood table ', 10, ' ');
INSERT INTO parametre (name, parent, value, type, minval, maxval, lookupvalues, "default", explanation, sort, checkable) VALUES ('f_depth_t_flood_50', 't_flood_50', 'vanddybde_m', 'F', '', '', '', '', 'Field name for detph field in flood table ', 10, ' ');


UPDATE parametre SET parent = 'Admin data' WHERE name= 't_tourism';
UPDATE parametre SET parent = 'Admin data' WHERE name= 't_build_usage';
UPDATE parametre SET parent = 'Admin data' WHERE name= 't_sqmprice';
UPDATE parametre SET parent = 'Admin data' WHERE name= 't_damage';
UPDATE parametre SET parent = 'Sector data' WHERE name= 't_company';
UPDATE parametre SET parent = 'Sector data' WHERE name= 't_publicservice';
UPDATE parametre SET parent = 'Sector data' WHERE name= 't_road_traffic';
UPDATE parametre SET parent = 'Sector data' WHERE name= 't_bioscore';
UPDATE parametre SET parent = 'Sector data' WHERE name= 't_human_health';
UPDATE parametre SET parent = 'Sector data' WHERE name= 't_recreative';
UPDATE parametre SET parent = 'Sector data' WHERE name= 't_infrastructure';
UPDATE parametre SET parent = 'Sector data' WHERE name= 't_building';
UPDATE parametre SET parent = 'Flood data' WHERE name= 't_flood';
UPDATE parametre SET parent = 'Flood data' WHERE name= 't_flood_2';
UPDATE parametre SET parent = 'Flood data' WHERE name= 't_flood_3';
UPDATE parametre SET parent = 'Flood data' WHERE name= 't_flood_4';
UPDATE parametre SET parent = 'Flood data' WHERE name= 't_flood_5';
UPDATE parametre SET parent = 'Flood data' WHERE name= 't_flood_6';
UPDATE parametre SET parent = 'Flood data' WHERE name= 't_flood_7';
UPDATE parametre SET parent = 'Flood data' WHERE name= 't_flood_8';
UPDATE parametre SET parent = 'Flood data' WHERE name= 't_flood_9';
UPDATE parametre SET parent = 'Flood data' WHERE name= 't_flood_10';
UPDATE parametre SET parent = 'Flood data' WHERE name= 't_flood_11';
UPDATE parametre SET parent = 'Flood data' WHERE name= 't_flood_12';
UPDATE parametre SET parent = 'Flood data' WHERE name= 't_flood_13';
UPDATE parametre SET parent = 'Flood data' WHERE name= 't_flood_14';
UPDATE parametre SET parent = 'Flood data' WHERE name= 't_flood_15';
UPDATE parametre SET parent = 'Flood data' WHERE name= 't_flood_16';
UPDATE parametre SET parent = 'Flood data' WHERE name= 't_flood_17';
UPDATE parametre SET parent = 'Flood data' WHERE name= 't_flood_18';
UPDATE parametre SET parent = 'Flood data' WHERE name= 't_flood_19';
UPDATE parametre SET parent = 'Flood data' WHERE name= 't_flood_20';
UPDATE parametre SET parent = 'Flood data' WHERE name= 't_flood_21';
UPDATE parametre SET parent = 'Flood data' WHERE name= 't_flood_22';
UPDATE parametre SET parent = 'Flood data' WHERE name= 't_flood_23';
UPDATE parametre SET parent = 'Flood data' WHERE name= 't_flood_24';
UPDATE parametre SET parent = 'Flood data' WHERE name= 't_flood_25';
UPDATE parametre SET parent = 'Flood data' WHERE name= 't_flood_26';
UPDATE parametre SET parent = 'Flood data' WHERE name= 't_flood_27';
UPDATE parametre SET parent = 'Flood data' WHERE name= 't_flood_28';
UPDATE parametre SET parent = 'Flood data' WHERE name= 't_flood_29';
UPDATE parametre SET parent = 'Flood data' WHERE name= 't_flood_30';
UPDATE parametre SET parent = 'Flood data' WHERE name= 't_flood_31';
UPDATE parametre SET parent = 'Flood data' WHERE name= 't_flood_32';
UPDATE parametre SET parent = 'Flood data' WHERE name= 't_flood_33';
UPDATE parametre SET parent = 'Flood data' WHERE name= 't_flood_34';
UPDATE parametre SET parent = 'Flood data' WHERE name= 't_flood_35';
UPDATE parametre SET parent = 'Flood data' WHERE name= 't_flood_36';
UPDATE parametre SET parent = 'Flood data' WHERE name= 't_flood_37';
UPDATE parametre SET parent = 'Flood data' WHERE name= 't_flood_38';
UPDATE parametre SET parent = 'Flood data' WHERE name= 't_flood_39';
UPDATE parametre SET parent = 'Flood data' WHERE name= 't_flood_40';
UPDATE parametre SET parent = 'Flood data' WHERE name= 't_flood_41';
UPDATE parametre SET parent = 'Flood data' WHERE name= 't_flood_42';
UPDATE parametre SET parent = 'Flood data' WHERE name= 't_flood_43';
UPDATE parametre SET parent = 'Flood data' WHERE name= 't_flood_44';
UPDATE parametre SET parent = 'Flood data' WHERE name= 't_flood_45';
UPDATE parametre SET parent = 'Flood data' WHERE name= 't_flood_46';
UPDATE parametre SET parent = 'Flood data' WHERE name= 't_flood_47';
UPDATE parametre SET parent = 'Flood data' WHERE name= 't_flood_48';
UPDATE parametre SET parent = 'Flood data' WHERE name= 't_flood_49';
UPDATE parametre SET parent = 'Flood data' WHERE name= 't_flood_50';

CREATE SCHEMA IF NOT EXISTS fdc_flood;

-- Patch  2022-04-14: Ny struktiur i faneblad Data slut --

UPDATE parametre SET "value" = '4' WHERE name= 'Værditab, skaderamte bygninger (%)';

/* 
-----------------------------------------------------------------------
--   Patch 2022-03-04: Template "Create cell layer template" modification 
-----------------------------------------------------------------------

     search_path skal værdisættes, således at navnet på administrations schema er første parameter. 
     Hvis der ikke er ændret på standard navn for administrationsskema "fdc_admin"
     skal der ikke rettes i linjen

*/
SET search_path = fdc_admin, public;
--                *********

-- NIX PILLE VED RESTEN....................................................................................................

UPDATE parametre SET value = 
'CREATE TABLE IF NOT EXISTS {celltable} AS
  WITH g AS (
    SELECT (
      st_squaregrid({cellsize}, st_geomfromewkt(''SRID={epsg}; POLYGON(({xmin} {ymin},{xmax} {ymin},{xmax} {ymax},{xmin} {ymax},{xmin} {ymin}))''))
	).*
  )
  SELECT
    row_number() OVER () AS fid,
    i,
    j,
    {cellsize} AS  cellsize, 
    CASE WHEN {cellsize} < 1000 THEN {cellsize}::INTEGER::TEXT || ''m_'' ELSE ({cellsize}/1000)::INTEGER::TEXT || ''km_'' END || 
	    j::TEXT || ''_'' || i::TEXT AS cellname,
    0.0::NUMERIC(12,2) AS val_intersect, 
    0 AS num_intersect,
    st_force2d(geom)::Geometry(Polygon,25832) AS geom	
  FROM g;
ALTER TABLE {celltable} ADD PRIMARY KEY(fid);
CREATE INDEX ON {celltable} USING GIST(geom);'

WHERE name = 'Create cell layer template';

-- Patch 2022-03-04 slut --

/* 
-----------------------------------------------------------------------
--   Patch 2022-05-17: Indførsel af ny skadekategori "Erhverv_lav"
-----------------------------------------------------------------------

     search_path skal værdisættes, således at navnet på administrations schema er første parameter. 
     Hvis der ikke er ændret på standard navn for administrationsskema "fdc_admin"
     skal der ikke rettes i linjen

*/
SET search_path = fdc_admin, public;
--                *********

-- NIX PILLE VED RESTEN....................................................................................................

INSERT INTO skadefunktioner (skade_type, skade_kategori, b0, b1, b2, c0) VALUES ('Stormflod', 'Erhverv_lav', 0, 346.98, -220.45, 578);
INSERT INTO skadefunktioner (skade_type, skade_kategori, b0, b1, b2, c0) VALUES ('Skybrud',   'Erhverv_lav', 0,      0,  351.63, 578);
INSERT INTO skadefunktioner (skade_type, skade_kategori, b0, b1, b2, c0) VALUES ('Vandløb',   'Erhverv_lav', 0, 115.66,  -73.48, 578);

UPDATE bbr_anvendelse SET skade_kategori = 'Erhverv_lav' WHERE bbr_anv_kode IN (211, 212, 213, 214, 215, 216, 218, 310, 313, 314, 319, 323, 534, 535);

--   Patch 2022-05-17: Indførsel af ny skadekategori "Erhverv_lav" slut

/* 
-----------------------------------------------------------------------
--   Patch 2022-06-10: Indførsel af kolonnerne returperiode og omraade på visse queries
-----------------------------------------------------------------------

     search_path skal værdisættes, således at navnet på administrations schema er første parameter. 
     Hvis der ikke er ændret på standard navn for administrationsskema "fdc_admin"
     skal der ikke rettes i linjen

*/
SET search_path = fdc_admin, public;
--                *********

-- NIX PILLE VED RESTEN....................................................................................................

UPDATE parametre set value = 
'
SELECT DISTINCT ON (o.{f_pkey_t_infrastructure}) 
    o.*,
    b.{f_pkey_t_building} AS object_id_b, 
    b.{f_muncode_t_building} AS komkode_b,
    b.{f_usage_code_t_building} AS bbr_anv_kode_b, 
    b.{f_usage_text_t_building} AS bbr_anv_tekst_b, 
    st_area(b.{f_geom_t_building})::NUMERIC(12,2) AS areal_byg_m2,
    n.*,
    f.*,
    {Returperiode, antal år} AS retur_periode,
    '''' AS omraade
    FROM {t_infrastructure} o
    LEFT JOIN {t_building} b ON st_intersects(o.{f_geom_t_infrastructure},b.{f_geom_t_building}), 
    LATERAL (
        SELECT
            COUNT (*) AS cnt_oversvoem_nutid,
            COALESCE(SUM(st_area(st_intersection(COALESCE (b.{f_geom_t_building},o.{f_geom_t_infrastructure}),{f_geom_Oversvømmelsesmodel, nutid}))),0)::NUMERIC(12,2) AS areal_oversvoem_nutid_m2,
            COALESCE(MIN({f_depth_Oversvømmelsesmodel, nutid}) * 100.00,0)::NUMERIC(12,2) AS min_vanddybde_nutid_cm,
            COALESCE(MAX({f_depth_Oversvømmelsesmodel, nutid}) * 100.00,0)::NUMERIC(12,2) AS max_vanddybde_nutid_cm,
            COALESCE(AVG({f_depth_Oversvømmelsesmodel, nutid}) * 100.00,0)::NUMERIC(12,2) AS avg_vanddybde_nutid_cm
        FROM {Oversvømmelsesmodel, nutid} WHERE {f_depth_Oversvømmelsesmodel, nutid} >= {Minimum vanddybde (meter)} AND st_intersects(COALESCE (b.{f_geom_t_building},o.{f_geom_t_infrastructure}),{f_geom_Oversvømmelsesmodel, nutid}) 
    ) n,
    LATERAL (
        SELECT
            COUNT (*) AS cnt_oversvoem_fremtid,
            COALESCE(SUM(st_area(st_intersection(COALESCE (b.{f_geom_t_building},o.{f_geom_t_infrastructure}),{f_geom_Oversvømmelsesmodel, fremtid}))),0)::NUMERIC(12,2) AS areal_oversvoem_fremtid_m2,
            COALESCE(MIN({f_depth_Oversvømmelsesmodel, fremtid}) * 100.00,0)::NUMERIC(12,2) AS min_vanddybde_fremtid_cm,
            COALESCE(MAX({f_depth_Oversvømmelsesmodel, fremtid}) * 100.00,0)::NUMERIC(12,2) AS max_vanddybde_fremtid_cm,
            COALESCE(AVG({f_depth_Oversvømmelsesmodel, fremtid}) * 100.00,0)::NUMERIC(12,2) AS avg_vanddybde_fremtid_cm
        FROM {Oversvømmelsesmodel, fremtid} WHERE {f_depth_Oversvømmelsesmodel, fremtid} >= {Minimum vanddybde (meter)} AND st_intersects(COALESCE (b.{f_geom_t_building},o.{f_geom_t_infrastructure}),{f_geom_Oversvømmelsesmodel, fremtid}) 
    ) f
    WHERE f.cnt_oversvoem_fremtid > 0 OR n.cnt_oversvoem_nutid > 0
'
WHERE name = 'q_infrastructure' AND parent = 'Queries';

UPDATE parametre set value = 
'
SELECT DISTINCT ON (o.{f_pkey_t_publicservice}) 
    o.*,
    b.{f_pkey_t_building} AS object_id_b, 
    b.{f_muncode_t_building} AS komkode_b,
    b.{f_usage_code_t_building} AS bbr_anv_kode_b, 
    b.{f_usage_text_t_building} AS bbr_anv_tekst_b, 
    st_area(b.{f_geom_t_building})::NUMERIC(12,2) AS areal_byg_m2,
    n.*,
    f.*,
    {Returperiode, antal år} AS retur_periode,
    '''' AS omraade
    FROM {t_publicservice} o
    LEFT JOIN {t_building} b ON st_intersects(o.{f_geom_t_publicservice},b.{f_geom_t_building}), 
    LATERAL (
        SELECT
            COUNT (*) AS cnt_oversvoem_nutid,
            COALESCE(SUM(st_area(st_intersection(o.{f_geom_t_publicservice},{f_geom_Oversvømmelsesmodel, nutid}))),0)::NUMERIC(12,2) AS areal_oversvoem_nutid_m2,
            COALESCE(MIN({f_depth_Oversvømmelsesmodel, nutid}) * 100.00,0)::NUMERIC(12,2) AS min_vanddybde_nutid_cm,
            COALESCE(MAX({f_depth_Oversvømmelsesmodel, nutid}) * 100.00,0)::NUMERIC(12,2) AS max_vanddybde_nutid_cm,
            COALESCE(AVG({f_depth_Oversvømmelsesmodel, nutid}) * 100.00,0)::NUMERIC(12,2) AS avg_vanddybde_nutid_cm
        FROM {Oversvømmelsesmodel, nutid} WHERE {f_depth_Oversvømmelsesmodel, nutid} >= {Minimum vanddybde (meter)} AND st_intersects(COALESCE (b.{f_geom_t_building},o.{f_geom_t_publicservice}),{f_geom_Oversvømmelsesmodel, nutid}) 
    ) n,
    LATERAL (
        SELECT
            COUNT (*) AS cnt_oversvoem_fremtid,
            COALESCE(SUM(st_area(st_intersection(o.{f_geom_t_publicservice},{f_geom_Oversvømmelsesmodel, fremtid}))),0)::NUMERIC(12,2) AS areal_oversvoem_fremtid_m2,
            COALESCE(MIN({f_depth_Oversvømmelsesmodel, fremtid}) * 100.00,0)::NUMERIC(12,2) AS min_vanddybde_fremtid_cm,
            COALESCE(MAX({f_depth_Oversvømmelsesmodel, fremtid}) * 100.00,0)::NUMERIC(12,2) AS max_vanddybde_fremtid_cm,
            COALESCE(AVG({f_depth_Oversvømmelsesmodel, fremtid}) * 100.00,0)::NUMERIC(12,2) AS avg_vanddybde_fremtid_cm
        FROM {Oversvømmelsesmodel, fremtid} WHERE st_intersects(o.{f_geom_t_publicservice},{f_geom_Oversvømmelsesmodel, fremtid}) AND {f_depth_Oversvømmelsesmodel, fremtid} >= {Minimum vanddybde (meter)}
    ) f
    WHERE f.cnt_oversvoem_fremtid > 0 OR n.cnt_oversvoem_nutid > 0
'
WHERE name = 'q_publicservice' AND parent = 'Queries';

UPDATE parametre set value = 
'
SELECT
    c.*,
	st_area(c.{f_geom_t_bioscore})::NUMERIC(12,2) AS areal_m2,
    n.*,
    f.*,
    {Returperiode, antal år} AS retur_periode,
    '''' AS omraade
FROM {t_bioscore} c,     
    LATERAL (
        SELECT
            COUNT (*) AS cnt_oversvoem_nutid,
            COALESCE((SUM(st_area(st_intersection(c.{f_geom_t_bioscore},{f_geom_Oversvømmelsesmodel, nutid})))),0)::NUMERIC(12,2) AS areal_oversvoem_nutid_m2,
            COALESCE((MIN({f_depth_Oversvømmelsesmodel, nutid}) * 100.00),0)::NUMERIC(12,2) AS min_vanddybde_nutid_cm,
            COALESCE((MAX({f_depth_Oversvømmelsesmodel, nutid}) * 100.00),0)::NUMERIC(12,2) AS max_vanddybde_nutid_cm,
            COALESCE((AVG({f_depth_Oversvømmelsesmodel, nutid}) * 100.00),0)::NUMERIC(12,2) AS avg_vanddybde_nutid_cm
        FROM {Oversvømmelsesmodel, nutid} WHERE {f_depth_Oversvømmelsesmodel, nutid} >= {Minimum vanddybde (meter)} AND st_intersects(c.{f_geom_t_bioscore},{f_geom_Oversvømmelsesmodel, nutid})
    ) n,
    LATERAL (
        SELECT
            COUNT (*) AS cnt_oversvoem_fremtid,
            COALESCE((SUM(st_area(st_intersection(c.{f_geom_t_bioscore},{f_geom_Oversvømmelsesmodel, fremtid})))),0)::NUMERIC(12,2) AS areal_oversvoem_fremtid_m2,
            COALESCE((MIN({f_depth_Oversvømmelsesmodel, fremtid}) * 100.00),0)::NUMERIC(12,2) AS min_vanddybde_fremtid_cm,
            COALESCE((MAX({f_depth_Oversvømmelsesmodel, fremtid}) * 100.00),0)::NUMERIC(12,2) AS max_vanddybde_fremtid_cm,
            COALESCE((AVG({f_depth_Oversvømmelsesmodel, fremtid}) * 100.00),0)::NUMERIC(12,2) AS avg_vanddybde_fremtid_cm
        FROM {Oversvømmelsesmodel, fremtid} WHERE {f_depth_Oversvømmelsesmodel, fremtid} >= {Minimum vanddybde (meter)} AND st_intersects(c.{f_geom_t_bioscore},{f_geom_Oversvømmelsesmodel, fremtid})
    ) f
WHERE n.cnt_oversvoem_nutid > 0 OR f.cnt_oversvoem_fremtid > 0 
'
WHERE name = 'q_bioscore_spatial' AND parent = 'Queries';


UPDATE parametre set value = 
'
SELECT
    c.*,
    b.{f_pkey_t_building} AS byg_id,
    b.{f_muncode_t_building} AS kom_kode,
    b.{f_usage_code_t_building} AS bbr_anv_kode,
    b.{f_usage_text_t_building} AS bbr_anv_tekst,
    n.*,
    f.*,
    {Returperiode, antal år} AS retur_periode,
    '''' AS omraade
FROM {t_company} c LEFT JOIN {t_building} b ON st_within(c.{f_geom_t_company},b.{f_geom_t_building}),     
    LATERAL (
        SELECT
            COUNT (*) AS cnt_oversvoem_nutid,
            COALESCE((MIN({f_depth_Oversvømmelsesmodel, nutid}) * 100.00),0)::NUMERIC(12,2) AS min_vanddybde_nutid_cm,
            COALESCE((MAX({f_depth_Oversvømmelsesmodel, nutid}) * 100.00),0)::NUMERIC(12,2) AS max_vanddybde_nutid_cm,
            COALESCE((AVG({f_depth_Oversvømmelsesmodel, nutid}) * 100.00),0)::NUMERIC(12,2) AS avg_vanddybde_nutid_cm
        FROM {Oversvømmelsesmodel, nutid} WHERE {f_depth_Oversvømmelsesmodel, nutid} >= {Minimum vanddybde (meter)} AND 
		    (b.{f_pkey_t_building} IS NOT NULL AND st_intersects(b.{f_geom_t_building},{f_geom_Oversvømmelsesmodel, nutid}) OR
			 b.{f_pkey_t_building} IS NULL     AND st_within(c.{f_geom_t_company},{f_geom_Oversvømmelsesmodel, nutid}))
    ) n,
    LATERAL (
        SELECT
            COUNT (*) AS cnt_oversvoem_fremtid,
            COALESCE((MIN({f_depth_Oversvømmelsesmodel, fremtid}) * 100.00),0)::NUMERIC(12,2) AS min_vanddybde_fremtid_cm,
            COALESCE((MAX({f_depth_Oversvømmelsesmodel, fremtid}) * 100.00),0)::NUMERIC(12,2) AS max_vanddybde_fremtid_cm,
            COALESCE((AVG({f_depth_Oversvømmelsesmodel, fremtid}) * 100.00),0)::NUMERIC(12,2) AS avg_vanddybde_fremtid_cm
        FROM {Oversvømmelsesmodel, fremtid} WHERE {f_depth_Oversvømmelsesmodel, fremtid} >= {Minimum vanddybde (meter)} AND 
		    (b.{f_pkey_t_building} IS NOT NULL AND st_intersects(b.{f_geom_t_building},{f_geom_Oversvømmelsesmodel, fremtid}) OR
			 b.{f_pkey_t_building} IS NULL     AND st_within(c.{f_geom_t_company},{f_geom_Oversvømmelsesmodel, fremtid}))
    ) f
WHERE n.cnt_oversvoem_nutid > 0 OR f.cnt_oversvoem_fremtid > 0 
'
WHERE name = 'q_comp_build' AND parent = 'Queries';

--   Patch 2022-06-10: Indførsel af kolonnerne returperiode og omraade på visse queries Slut

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
    f.*,
    {Returperiode, antal år} AS retur_periode,
    '''' AS omraade
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
    f.*,
	{Returperiode, antal år} AS retur_periode,
    '''' AS omraade
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
 


 
