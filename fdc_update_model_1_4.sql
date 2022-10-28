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

-- Patch 2022-02-03: Opdatering af Kritisk infrastruktur slut --


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

INSERT INTO parametre (name, parent, value, type, minval, maxval, lookupvalues, "default", explanation, sort, checkable) VALUES ('Oversvømmelsesmodel, nutid', 'Generelle modelværdier', 'fdc_data.nedbor_t100_nutid', 'Q', '', '', 't_flood', 't_flood', 'Vælg oversvømmelsestabel for nutidshændelse', 12, ' ');
INSERT INTO parametre (name, parent, value, type, minval, maxval, lookupvalues, "default", explanation, sort, checkable) VALUES ('Oversvømmelsesmodel, fremtid', 'Generelle modelværdier', 'fdc_data.nedbor_t100_fremtid', 'Q', '', '', 't_flood', 't_flood', 'Vælg oversvømmelsestabel for fremtidshændelse', 13, ' ');
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
--   Patch 2022-03-09: Model q_infrastructure_new
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
    b.{f_pkey_t_building} AS object_id_b, 
    b.{f_muncode_t_building} AS komkode_b,
    b.{f_usage_code_t_building} AS bbr_anv_kode_b, 
    b.{f_usage_text_t_building} AS bbr_anv_tekst_b, 
    st_area(b.{f_geom_t_building})::NUMERIC(12,2) AS areal_byg_m2,
    n.*,
    f.*
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
    b.{f_pkey_t_building} AS object_id_b, 
    b.{f_muncode_t_building} AS komkode_b,
    b.{f_usage_code_t_building} AS bbr_anv_kode_b, 
    b.{f_usage_text_t_building} AS bbr_anv_tekst_b, 
    st_area(b.{f_geom_t_building})::NUMERIC(12,2) AS areal_byg_m2,
    n.*,
    f.*
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
', 'P', '', '', '', '', 'SQL template for public service new model ', 8, ' ');
	
-- Patch  2022-03-09: Model q_publicservice_new slut --

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

INSERT INTO parametre (name, parent, value, type, minval, maxval, lookupvalues, "default", explanation, sort, checkable) VALUES ('t_flood'   , 'Flood data', 'fdc_data.nedbor_t100_nutid', 'S', '', '', '', '', 'Parametergruppe til tabel "oversvømmelser"', 1, ' ');
INSERT INTO parametre (name, parent, value, type, minval, maxval, lookupvalues, "default", explanation, sort, checkable) VALUES ('t_flood_2' , 'Flood data', 'fdc_data.nedbor_t100_fremtid', 'S', '', '', '', '', 'Parametergruppe til tabel "oversvømmelser"', 2, ' ');
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
INSERT INTO parametre (name, parent, value, type, minval, maxval, lookupvalues, "default", explanation, sort, checkable) VALUES ('f_depth_t_flood'   , 't_flood'   , 'vanddyb_m', 'F', '', '', '', '', 'Field name for detph field in flood table ', 10, ' ');
INSERT INTO parametre (name, parent, value, type, minval, maxval, lookupvalues, "default", explanation, sort, checkable) VALUES ('f_depth_t_flood_2' , 't_flood_2' , 'vanddyb_m', 'F', '', '', '', '', 'Field name for detph field in flood table ', 10, ' ');
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

INSERT INTO skadefunktioner (skade_type, skade_kategori, b0, b1, b2, c0) VALUES ('Stormflod', 'Erhverv_lav', 0, 346.98, -220.45, 578)
  ON CONFLICT ON CONSTRAINT skadefunktioner_pkey DO NOTHING;
INSERT INTO skadefunktioner (skade_type, skade_kategori, b0, b1, b2, c0) VALUES ('Skybrud',   'Erhverv_lav', 0,      0,  351.63, 578)
  ON CONFLICT ON CONSTRAINT skadefunktioner_pkey DO NOTHING;
INSERT INTO skadefunktioner (skade_type, skade_kategori, b0, b1, b2, c0) VALUES ('Vandløb',   'Erhverv_lav', 0, 115.66,  -73.48, 578)
  ON CONFLICT ON CONSTRAINT skadefunktioner_pkey DO NOTHING;

UPDATE bbr_anvendelse SET skade_kategori = 'Erhverv_lav' WHERE bbr_anv_kode IN (211, 212, 213, 214, 215, 216, 218, 310, 313, 314, 319, 323, 534, 535)

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
    FROM {t_infrastructure} o,
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
    FROM {t_publicservice} o,
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

/*
-----------------------------------------------------------------------
--   Patch 2022-09-16: Model agriculture 
-----------------------------------------------------------------------

     search_path skal værdisættes, således at navnet på administrations schema er første parameter. 
     Hvis der ikke er ændret på standard navn for administrationsskema "fdc_admin"
     skal der ikke rettes i linjen

*/
SET search_path = fdc_admin, public;
--                *********

-- NIX PILLE VED RESTEN....................................................................................................

DELETE FROM parametre WHERE name LIKE '%_agriculture' OR name LIKE '%_agr_cat' OR name LIKE '%_agr_price';
DELETE FROM parametre WHERE parent = 'Landbrug' OR name = 'Landbrug';
DROP TABLE IF EXISTS "afgroede_kategori";
DROP TABLE IF EXISTS "afgroede_pris";

INSERT INTO parametre (name, parent, value, type, minval, maxval, lookupvalues, "default", explanation, sort, checkable) VALUES ('Landbrug', 'Models', '', 'G', '', '', '', '', 'Skademodeller for landbrug', 10, ' ');
INSERT INTO parametre (name, parent, value, type, minval, maxval, lookupvalues, "default", explanation, sort, checkable) VALUES ('Oversvømmede landbrugs arealer', 'Landbrug'   , ''                      , 'T', '', '', '', 'q_agriculture', 'Sæt hak såfremt der skal beregnes økonomiske tab for oversvømmede landbrugsarealer.', 10, 'T');
INSERT INTO parametre (name, parent, value, type, minval, maxval, lookupvalues, "default", explanation, sort, checkable) VALUES ('f_pkey_q_agriculture'          , 'q_agriculture', 'fid'                   , 'T', '', '', '', '', 'Name of primary keyfield for query', 10, ' ');
INSERT INTO parametre (name, parent, value, type, minval, maxval, lookupvalues, "default", explanation, sort, checkable) VALUES ('f_geom_q_agriculture'          , 'q_agriculture', 'geom'                  , 'T', '', '', '', '', 'Field name for geometry column', 10, ' ');
INSERT INTO parametre (name, parent, value, type, minval, maxval, lookupvalues, "default", explanation, sort, checkable) VALUES ('f_damage_present_q_agriculture', 'q_agriculture', 'skadebeloeb_nutid_kr'  , 'T', '', '', '', '', '', 1, 'T');
INSERT INTO parametre (name, parent, value, type, minval, maxval, lookupvalues, "default", explanation, sort, checkable) VALUES ('f_damage_future_q_agriculture' , 'q_agriculture', 'skadebeloeb_fremtid_kr', 'T', '', '', '', '', '', 1, 'T');
INSERT INTO parametre (name, parent, value, type, minval, maxval, lookupvalues, "default", explanation, sort, checkable) VALUES ('f_risk_q_agriculture'          , 'q_agriculture', 'risiko_kr'             , 'T', '', '', '', '', '', 1, 'T');

INSERT INTO parametre (name, parent, value, type, minval, maxval, lookupvalues, "default", explanation, sort, checkable) VALUES ('t_agriculture'                 , 'Sector data'  , 'fdc_data.marker2021'        , 'S', '', '', '', '', 'Parametergruppe til tabel "Landbrug"', 10, ' ');
INSERT INTO parametre (name, parent, value, type, minval, maxval, lookupvalues, "default", explanation, sort, checkable) VALUES ('t_agr_cat'                     , 'Admin data'   , 'fdc_admin.afgroede_kategori', 'S', '', '', '', '', 'Parametergruppe til opslagstabel "afgrøde-kategori"', 10, ' ');
INSERT INTO parametre (name, parent, value, type, minval, maxval, lookupvalues, "default", explanation, sort, checkable) VALUES ('t_agr_price'                   , 'Admin data'   , 'fdc_admin.afgroede_pris'    , 'S', '', '', '', '', 'Parametergruppe til opslagstabel "afgrøde-pris"', 10, ' ');

INSERT INTO parametre (name, parent, value, type, minval, maxval, lookupvalues, "default", explanation, sort, checkable) VALUES ('f_pkey_t_agriculture'          , 't_agriculture', 'fid'                   , 'F', '', '', '', '', 'Name of primary keyfield for query', 10, ' ');
INSERT INTO parametre (name, parent, value, type, minval, maxval, lookupvalues, "default", explanation, sort, checkable) VALUES ('f_geom_t_agriculture'          , 't_agriculture', 'geom'                  , 'F', '', '', '', '', 'Field name for geometry column', 10, ' ');
INSERT INTO parametre (name, parent, value, type, minval, maxval, lookupvalues, "default", explanation, sort, checkable) VALUES ('f_afgcode_t_agriculture'       , 't_agriculture', 'afgkode'               , 'F', '', '', '', '', 'Field name for agr code column', 10, ' ');
INSERT INTO parametre (name, parent, value, type, minval, maxval, lookupvalues, "default", explanation, sort, checkable) VALUES ('f_pkey_t_agr_cat'              , 't_agr_cat'    , 'afgroedekode'          , 'F', '', '', '', '', 'Name of primary keyfield for query', 10, ' ');
INSERT INTO parametre (name, parent, value, type, minval, maxval, lookupvalues, "default", explanation, sort, checkable) VALUES ('f_pcat_t_agr_cat'              , 't_agr_cat'    , 'priskategori'          , 'F', '', '', '', '', 'Name of field for price category'  , 10, ' ');
INSERT INTO parametre (name, parent, value, type, minval, maxval, lookupvalues, "default", explanation, sort, checkable) VALUES ('f_pkey_t_agr_price'            , 't_agr_price'  , 'priskategori'          , 'F', '', '', '', '', 'Name of primary keyfield for query', 10, ' ');
INSERT INTO parametre (name, parent, value, type, minval, maxval, lookupvalues, "default", explanation, sort, checkable) VALUES ('f_price_t_agr_price'           , 't_agr_price'  , 'pris'                  , 'F', '', '', '', '', 'Name of field for price in øre', 10, ' ');


INSERT INTO parametre (name, parent, value, type, minval, maxval, lookupvalues, "default", explanation, sort, checkable) VALUES ('q_agriculture'                 , 'Queries',
'
SELECT
    b.*,
    k.afgroedegruppe,
    k.afgroedekategori,
    p.*,
    n.*,
    areal_oversvoem_nutid_m2 * p.{f_price_t_agr_price} /100.00 AS {f_damage_present_q_agriculture},
    f.*,
    areal_oversvoem_fremtid_m2 * p.{f_price_t_agr_price} /100.00 AS {f_damage_future_q_agriculture},
    r.*
    FROM {t_agriculture} b
    LEFT JOIN {t_agr_cat} k ON k.{f_pkey_t_agr_cat} = b.{f_afgcode_t_agriculture} 
    LEFT JOIN {t_agr_price} p ON p.{f_pkey_t_agr_price} = k.{f_pcat_t_agr_cat}, 
    LATERAL (
        SELECT
            COUNT (*) AS cnt_oversvoem_nutid,
            COALESCE(SUM(st_area(st_intersection(b.{f_geom_t_agriculture},{f_geom_Oversvømmelsesmodel, nutid}))),0)::NUMERIC(12,2) AS areal_oversvoem_nutid_m2,
            COALESCE(MIN({f_depth_Oversvømmelsesmodel, nutid}) * 100.00,0)::NUMERIC(12,2) AS min_vanddybde_nutid_cm,
            COALESCE(MAX({f_depth_Oversvømmelsesmodel, nutid}) * 100.00,0)::NUMERIC(12,2) AS max_vanddybde_nutid_cm,
            COALESCE(AVG({f_depth_Oversvømmelsesmodel, nutid}) * 100.00,0)::NUMERIC(12,2) AS avg_vanddybde_nutid_cm
        FROM {Oversvømmelsesmodel, nutid} WHERE st_intersects(b.{f_geom_t_agriculture},{f_geom_Oversvømmelsesmodel, nutid}) AND {f_depth_Oversvømmelsesmodel, nutid} >= {Minimum vanddybde (meter)}
    ) n,
    LATERAL (
        SELECT
            COUNT (*) AS cnt_oversvoem_fremtid,
            COALESCE(SUM(st_area(st_intersection(b.{f_geom_t_agriculture},{f_geom_Oversvømmelsesmodel, fremtid}))),0)::NUMERIC(12,2) AS areal_oversvoem_fremtid_m2,
            COALESCE(MIN({f_depth_Oversvømmelsesmodel, fremtid}) * 100.00,0)::NUMERIC(12,2) AS min_vanddybde_fremtid_cm,
            COALESCE(MAX({f_depth_Oversvømmelsesmodel, fremtid}) * 100.00,0)::NUMERIC(12,2) AS max_vanddybde_fremtid_cm,
            COALESCE(AVG({f_depth_Oversvømmelsesmodel, fremtid}) * 100.00,0)::NUMERIC(12,2) AS avg_vanddybde_fremtid_cm
        FROM {Oversvømmelsesmodel, fremtid} WHERE st_intersects(b.{f_geom_t_agriculture},{f_geom_Oversvømmelsesmodel, fremtid}) AND {f_depth_Oversvømmelsesmodel, fremtid} >= {Minimum vanddybde (meter)}
    ) f,
    LATERAL (
        SELECT
          ''{Medtag i risikoberegninger}'' AS risiko_beregning,
		  {Returperiode, antal år} AS retur_periode,
          ((
		      0.219058829 * CASE WHEN ''{Medtag i risikoberegninger}'' IN (''Skadebeløb'',''Skadebeløb og værditab'') THEN n.areal_oversvoem_nutid_m2 * p.{f_price_t_agr_price} /100.00 ELSE 0.0 END + 
              0.089925625   * CASE WHEN ''{Medtag i risikoberegninger}'' IN (''Skadebeløb'',''Skadebeløb og værditab'') THEN f.areal_oversvoem_fremtid_m2 * p.{f_price_t_agr_price} /100.00 ELSE 0.0 END
          )/{Returperiode, antal år})::NUMERIC(12,2) AS {f_risk_q_agriculture},
          '''' AS omraade
    ) r
	WHERE f.cnt_oversvoem_fremtid > 0 OR n.cnt_oversvoem_nutid > 0
', 'P', '', '', '', '', 'SQL template for agriculture model ', 8, ' ');


CREATE TABLE "afgroede_pris" (
    "priskategori" "text" NOT NULL,
    "pris" double precision
);

INSERT INTO "afgroede_pris" ("priskategori", "pris") VALUES ('processkartofler', 311);
INSERT INTO "afgroede_pris" ("priskategori", "pris") VALUES ('skovdrift', 1100);
INSERT INTO "afgroede_pris" ("priskategori", "pris") VALUES ('havre', 77);
INSERT INTO "afgroede_pris" ("priskategori", "pris") VALUES ('krydderurter', 25250);
INSERT INTO "afgroede_pris" ("priskategori", "pris") VALUES ('vårbyg', 92);
INSERT INTO "afgroede_pris" ("priskategori", "pris") VALUES ('chipskartofler', 392);
INSERT INTO "afgroede_pris" ("priskategori", "pris") VALUES ('Bælgsæd', 80.66666667);
INSERT INTO "afgroede_pris" ("priskategori", "pris") VALUES ('vårkorn blanding', 80.25);
INSERT INTO "afgroede_pris" ("priskategori", "pris") VALUES ('Frøgræs', 171.8333333);
INSERT INTO "afgroede_pris" ("priskategori", "pris") VALUES ('foderrodfrugter', 148);
INSERT INTO "afgroede_pris" ("priskategori", "pris") VALUES ('vårtriticale', 80);
INSERT INTO "afgroede_pris" ("priskategori", "pris") VALUES ('sukkeroer', 142);
INSERT INTO "afgroede_pris" ("priskategori", "pris") VALUES ('vårsæd til modenhed', 74);
INSERT INTO "afgroede_pris" ("priskategori", "pris") VALUES ('græs, permanent', 65);
INSERT INTO "afgroede_pris" ("priskategori", "pris") VALUES ('frugt', 1450.105);
INSERT INTO "afgroede_pris" ("priskategori", "pris") VALUES ('oliefrø', 73);
INSERT INTO "afgroede_pris" ("priskategori", "pris") VALUES ('Havefrø', 480);
INSERT INTO "afgroede_pris" ("priskategori", "pris") VALUES ('bær', 4031.45);
INSERT INTO "afgroede_pris" ("priskategori", "pris") VALUES ('Brak', 0);
INSERT INTO "afgroede_pris" ("priskategori", "pris") VALUES ('vinterkorn blanding', 126);
INSERT INTO "afgroede_pris" ("priskategori", "pris") VALUES ('hvede', 139);
INSERT INTO "afgroede_pris" ("priskategori", "pris") VALUES ('vinterrug', 114);
INSERT INTO "afgroede_pris" ("priskategori", "pris") VALUES ('majs til helsæd', 90);
INSERT INTO "afgroede_pris" ("priskategori", "pris") VALUES ('kløver', 120);
INSERT INTO "afgroede_pris" ("priskategori", "pris") VALUES ('kål', 1221);
INSERT INTO "afgroede_pris" ("priskategori", "pris") VALUES ('helsæd, vinter', 111);
INSERT INTO "afgroede_pris" ("priskategori", "pris") VALUES ('læggekartofler', 556.7);
INSERT INTO "afgroede_pris" ("priskategori", "pris") VALUES ('Energiafgrøder', 1100);
INSERT INTO "afgroede_pris" ("priskategori", "pris") VALUES ('græs, sædskifte', 124);
INSERT INTO "afgroede_pris" ("priskategori", "pris") VALUES ('brak', 0);
INSERT INTO "afgroede_pris" ("priskategori", "pris") VALUES ('vinterhvede', 139);
INSERT INTO "afgroede_pris" ("priskategori", "pris") VALUES ('potteplanter og stauder', 27250);
INSERT INTO "afgroede_pris" ("priskategori", "pris") VALUES ('stivelseskartofler', 375);
INSERT INTO "afgroede_pris" ("priskategori", "pris") VALUES ('vinterbyg', 110);
INSERT INTO "afgroede_pris" ("priskategori", "pris") VALUES ('lucerne', 83);
INSERT INTO "afgroede_pris" ("priskategori", "pris") VALUES ('vintertriticale', 100);
INSERT INTO "afgroede_pris" ("priskategori", "pris") VALUES ('grøntsager', 480);
INSERT INTO "afgroede_pris" ("priskategori", "pris") VALUES ('spisekartofler', 455);
INSERT INTO "afgroede_pris" ("priskategori", "pris") VALUES ('helsæd, vår', 75);
INSERT INTO "afgroede_pris" ("priskategori", "pris") VALUES ('rug', 74);


ALTER TABLE ONLY "afgroede_pris"
    ADD CONSTRAINT "afgroede_pris_pkey" PRIMARY KEY ("priskategori");


CREATE TABLE "afgroede_kategori" (
    "afgroedekode" integer NOT NULL,
    "afgroedenavn" "text",
    "afgroedegruppe" "text",
    "afgroedekategori" "text",
    "priskategori" "text"
);


INSERT INTO "afgroede_kategori" ("afgroedekode", "afgroedenavn", "afgroedegruppe", "afgroedekategori", "priskategori") VALUES (116, 'Rajgræs, hybrid', 'Frøgræs', 'vårsået rajgræsfrø', 'Frøgræs');
INSERT INTO "afgroede_kategori" ("afgroedekode", "afgroedenavn", "afgroedegruppe", "afgroedekategori", "priskategori") VALUES (652, 'Kinesisk kålfrø', 'Havefrø', 'ager-kål', 'Havefrø');
INSERT INTO "afgroede_kategori" ("afgroedekode", "afgroedenavn", "afgroedegruppe", "afgroedekategori", "priskategori") VALUES (273, 'Lucerne til fabrik', 'Kløver og lucerne i renbestand', 'lucerne', 'lucerne');
INSERT INTO "afgroede_kategori" ("afgroedekode", "afgroedenavn", "afgroedegruppe", "afgroedekategori", "priskategori") VALUES (51, 'Blanding bredbladet afgrøde, frø/kerne', 'Hør og Hamp', 'vårsået blanding', 'oliefrø');
INSERT INTO "afgroede_kategori" ("afgroedekode", "afgroedenavn", "afgroedegruppe", "afgroedekategori", "priskategori") VALUES (272, 'Permanent græs til fabrik', 'Græs, permanent', '(afgrøden har ingen kategori)', 'græs, permanent');
INSERT INTO "afgroede_kategori" ("afgroedekode", "afgroedenavn", "afgroedegruppe", "afgroedekategori", "priskategori") VALUES (552, 'Mandelgræskar', 'Frugt og bær', 'mandelgræskar', 'grøntsager');
INSERT INTO "afgroede_kategori" ("afgroedekode", "afgroedenavn", "afgroedegruppe", "afgroedekategori", "priskategori") VALUES (539, 'Blandet frugt', 'Frugt og bær', '(afgrøden har ingen kategori)', 'frugt');
INSERT INTO "afgroede_kategori" ("afgroedekode", "afgroedenavn", "afgroedegruppe", "afgroedekategori", "priskategori") VALUES (278, 'Permanent lucerne og lucernegræs over 50% lucerne', 'Græs, permanent', '(afgrøden har ingen kategori)', 'lucerne');
INSERT INTO "afgroede_kategori" ("afgroedekode", "afgroedenavn", "afgroedegruppe", "afgroedekategori", "priskategori") VALUES (431, 'Purløg', 'Grøntsager, friland', 'løg', 'krydderurter');
INSERT INTO "afgroede_kategori" ("afgroedekode", "afgroedenavn", "afgroedegruppe", "afgroedekategori", "priskategori") VALUES (406, 'Grønkål', 'Grøntsager, friland', 'kål', 'kål');
INSERT INTO "afgroede_kategori" ("afgroedekode", "afgroedenavn", "afgroedegruppe", "afgroedekategori", "priskategori") VALUES (424, 'Ærter, konsum', 'Grøntsager, friland', 'ært', 'grøntsager');
INSERT INTO "afgroede_kategori" ("afgroedekode", "afgroedenavn", "afgroedegruppe", "afgroedekategori", "priskategori") VALUES (491, 'Storfrugtet tranebær', 'Småplanteproduktion og planteskoleplanter', '(afgrøden har ingen kategori)', 'potteplanter og stauder');
INSERT INTO "afgroede_kategori" ("afgroedekode", "afgroedenavn", "afgroedegruppe", "afgroedekategori", "priskategori") VALUES (576, 'skovrejsning (statslig) - forbedring af vandmiljø og grundvandsbeskyttelse', 'Trækulturer', '(afgrøden har ingen kategori)', 'skovdrift');
INSERT INTO "afgroede_kategori" ("afgroedekode", "afgroedenavn", "afgroedegruppe", "afgroedekategori", "priskategori") VALUES (605, 'MFO - Lavskov', 'Energiafgrøder og anden særlig produktion', '(afgrøden har ingen kategori)', 'Energiafgrøder');
INSERT INTO "afgroede_kategori" ("afgroedekode", "afgroedenavn", "afgroedegruppe", "afgroedekategori", "priskategori") VALUES (345, 'Brak langs vandløb og søer, sommerslåning (alternativ til efterafgrøder)', 'Udyrkede arealer, vildtagre o.l.', 'brak', 'brak');
INSERT INTO "afgroede_kategori" ("afgroedekode", "afgroedenavn", "afgroedegruppe", "afgroedekategori", "priskategori") VALUES (541, 'Agurker', 'Småplanteproduktion og planteskoleplanter', 'agurk', 'potteplanter og stauder');
INSERT INTO "afgroede_kategori" ("afgroedekode", "afgroedenavn", "afgroedegruppe", "afgroedekategori", "priskategori") VALUES (180, 'Gul sennep', 'Oliefrø og Bælgsæd', 'sennep', 'oliefrø');
INSERT INTO "afgroede_kategori" ("afgroedekode", "afgroedenavn", "afgroedegruppe", "afgroedekategori", "priskategori") VALUES (660, 'Persillefrø', 'Havefrø', 'persille', 'Havefrø');
INSERT INTO "afgroede_kategori" ("afgroedekode", "afgroedenavn", "afgroedegruppe", "afgroedekategori", "priskategori") VALUES (509, 'Trækvæde', 'Småplanteproduktion og planteskoleplanter', '(afgrøden har ingen kategori)', 'potteplanter og stauder');
INSERT INTO "afgroede_kategori" ("afgroedekode", "afgroedenavn", "afgroedegruppe", "afgroedekategori", "priskategori") VALUES (663, 'Pastinakfrø', 'Havefrø', 'pastinak', 'Havefrø');
INSERT INTO "afgroede_kategori" ("afgroedekode", "afgroedenavn", "afgroedegruppe", "afgroedekategori", "priskategori") VALUES (22, 'Vinterraps', 'Oliefrø og Bælgsæd', 'vinterraps', 'oliefrø');
INSERT INTO "afgroede_kategori" ("afgroedekode", "afgroedenavn", "afgroedegruppe", "afgroedekategori", "priskategori") VALUES (263, 'Græs uden kløvergræs (omdrift)', 'Græsmarksplanter, omdrift', 'græs eller andet grøntfoder', 'lucerne');
INSERT INTO "afgroede_kategori" ("afgroedekode", "afgroedenavn", "afgroedegruppe", "afgroedekategori", "priskategori") VALUES (271, 'Rekreative formål', 'Udyrkede arealer, vildtagre o.l.', '(afgrøden har ingen kategori)', 'brak');
INSERT INTO "afgroede_kategori" ("afgroedekode", "afgroedenavn", "afgroedegruppe", "afgroedekategori", "priskategori") VALUES (156, 'Kartofler, friteret/chips/pommes frites', 'Kartofler', 'kartoffel', 'chipskartofler');
INSERT INTO "afgroede_kategori" ("afgroedekode", "afgroedenavn", "afgroedegruppe", "afgroedekategori", "priskategori") VALUES (417, 'Rødbede', 'Grøntsager, friland', 'beder', 'grøntsager');
INSERT INTO "afgroede_kategori" ("afgroedekode", "afgroedenavn", "afgroedegruppe", "afgroedekategori", "priskategori") VALUES (493, 'Surbær ', 'Småplanteproduktion og planteskoleplanter', '(afgrøden har ingen kategori)', 'potteplanter og stauder');
INSERT INTO "afgroede_kategori" ("afgroedekode", "afgroedenavn", "afgroedegruppe", "afgroedekategori", "priskategori") VALUES (711, 'Grønkorn af vintertriticale', 'Korn, grønkorn', 'vintertriticale', 'vintertriticale');
INSERT INTO "afgroede_kategori" ("afgroedekode", "afgroedenavn", "afgroedegruppe", "afgroedekategori", "priskategori") VALUES (707, 'Grønkorn af vinterhvede', 'Korn, grønkorn', 'vinterhvede', 'vinterhvede');
INSERT INTO "afgroede_kategori" ("afgroedekode", "afgroedenavn", "afgroedegruppe", "afgroedekategori", "priskategori") VALUES (665, 'Havrerodfrø', 'Havefrø', 'havrerod', 'Havefrø');
INSERT INTO "afgroede_kategori" ("afgroedekode", "afgroedenavn", "afgroedegruppe", "afgroedekategori", "priskategori") VALUES (529, 'Pærer', 'Frugt og bær', '(afgrøden har ingen kategori)', 'frugt');
INSERT INTO "afgroede_kategori" ("afgroedekode", "afgroedenavn", "afgroedegruppe", "afgroedekategori", "priskategori") VALUES (282, 'Fodermarvkål', 'Andre foderafgrøder', 'kål', 'foderrodfrugter');
INSERT INTO "afgroede_kategori" ("afgroedekode", "afgroedenavn", "afgroedegruppe", "afgroedekategori", "priskategori") VALUES (149, 'Kartofler, lægge- (certificerede)', 'Kartofler', 'kartoffel', 'læggekartofler');
INSERT INTO "afgroede_kategori" ("afgroedekode", "afgroedenavn", "afgroedegruppe", "afgroedekategori", "priskategori") VALUES (173, 'Kløver til slæt', 'Kløver og lucerne i renbestand', 'kløver', 'kløver');
INSERT INTO "afgroede_kategori" ("afgroedekode", "afgroedenavn", "afgroedegruppe", "afgroedekategori", "priskategori") VALUES (577, 'Skov med biodiversitetsformål', 'Trækulturer', '(afgrøden har ingen kategori)', 'skovdrift');
INSERT INTO "afgroede_kategori" ("afgroedekode", "afgroedenavn", "afgroedegruppe", "afgroedekategori", "priskategori") VALUES (269, 'Græs, rullegræs', 'Græsmarksplanter, omdrift', 'græs eller andet grøntfoder', 'græs, sædskifte');
INSERT INTO "afgroede_kategori" ("afgroedekode", "afgroedenavn", "afgroedegruppe", "afgroedekategori", "priskategori") VALUES (311, 'Skovrejsning på tidl. landbrugsjord 1', 'Særlige afgrødekoder i forbindelse med tilsagn eller miljøtiltag', '(afgrøden har ingen kategori)', 'brak');
INSERT INTO "afgroede_kategori" ("afgroedekode", "afgroedenavn", "afgroedegruppe", "afgroedekategori", "priskategori") VALUES (505, 'Ribs, stiklingeopformering', 'Småplanteproduktion og planteskoleplanter', '(afgrøden har ingen kategori)', 'potteplanter og stauder');
INSERT INTO "afgroede_kategori" ("afgroedekode", "afgroedenavn", "afgroedegruppe", "afgroedekategori", "priskategori") VALUES (261, 'Kløvergræs, over 50% kløver (omdrift)', 'Græsmarksplanter, omdrift', 'græs eller andet grøntfoder', 'græs, sædskifte');
INSERT INTO "afgroede_kategori" ("afgroedekode", "afgroedenavn", "afgroedegruppe", "afgroedekategori", "priskategori") VALUES (103, 'Rajgræsfrø, ital.', 'Frøgræs', 'vårsået rajgræsfrø', 'Frøgræs');
INSERT INTO "afgroede_kategori" ("afgroedekode", "afgroedenavn", "afgroedegruppe", "afgroedekategori", "priskategori") VALUES (502, 'Blomsterløg', 'Småplanteproduktion og planteskoleplanter', 'planteskolekultur', 'potteplanter og stauder');
INSERT INTO "afgroede_kategori" ("afgroedekode", "afgroedenavn", "afgroedegruppe", "afgroedekategori", "priskategori") VALUES (280, 'Fodersukkerroer', 'Andre foderafgrøder', 'beder', 'foderrodfrugter');
INSERT INTO "afgroede_kategori" ("afgroedekode", "afgroedenavn", "afgroedegruppe", "afgroedekategori", "priskategori") VALUES (42, 'Hamp', 'Hør og Hamp', 'hamp', 'oliefrø');
INSERT INTO "afgroede_kategori" ("afgroedekode", "afgroedenavn", "afgroedegruppe", "afgroedekategori", "priskategori") VALUES (161, 'Cikorierødder', 'Rodfrugter til fabrik', 'cikorie', 'sukkeroer');
INSERT INTO "afgroede_kategori" ("afgroedekode", "afgroedenavn", "afgroedegruppe", "afgroedekategori", "priskategori") VALUES (121, 'Bælgplanter, frø', 'Frøgræs', 'vårsået blanding', 'Frøgræs');
INSERT INTO "afgroede_kategori" ("afgroedekode", "afgroedenavn", "afgroedegruppe", "afgroedekategori", "priskategori") VALUES (117, 'Rajgræs, efterårsudl. hybrid', 'Frøgræs', 'efterårssået rajgræsfrø', 'Frøgræs');
INSERT INTO "afgroede_kategori" ("afgroedekode", "afgroedenavn", "afgroedegruppe", "afgroedekategori", "priskategori") VALUES (420, 'Salat (friland)', 'Grøntsager, friland', 'salat', 'grøntsager');
INSERT INTO "afgroede_kategori" ("afgroedekode", "afgroedenavn", "afgroedegruppe", "afgroedekategori", "priskategori") VALUES (40, 'Oliehør', 'Hør og Hamp', 'hør', 'oliefrø');
INSERT INTO "afgroede_kategori" ("afgroedekode", "afgroedenavn", "afgroedegruppe", "afgroedekategori", "priskategori") VALUES (257, 'Permanent græs, uden kløver', 'Græs, permanent', '(afgrøden har ingen kategori)', 'græs, permanent');
INSERT INTO "afgroede_kategori" ("afgroedekode", "afgroedenavn", "afgroedegruppe", "afgroedekategori", "priskategori") VALUES (125, 'Bederoefrø', 'Frøgræs', 'beder', 'Frøgræs');
INSERT INTO "afgroede_kategori" ("afgroedekode", "afgroedenavn", "afgroedegruppe", "afgroedekategori", "priskategori") VALUES (113, 'Engrapsgræsfrø (plænetype)', 'Frøgræs', 'eng- og rapgræsfrø', 'Frøgræs');
INSERT INTO "afgroede_kategori" ("afgroedekode", "afgroedenavn", "afgroedegruppe", "afgroedekategori", "priskategori") VALUES (328, 'MFO-bræmme med blomsterblanding', 'Særlige afgrødekoder i forbindelse med tilsagn eller miljøtiltag', 'brak', 'brak');
INSERT INTO "afgroede_kategori" ("afgroedekode", "afgroedenavn", "afgroedegruppe", "afgroedekategori", "priskategori") VALUES (525, 'Sødkirsebær med undervækst af græs', 'Frugt og bær', '(afgrøden har ingen kategori)', 'bær');
INSERT INTO "afgroede_kategori" ("afgroedekode", "afgroedenavn", "afgroedegruppe", "afgroedekategori", "priskategori") VALUES (658, 'Gulerodsfrø', 'Havefrø', 'gulerod', 'Havefrø');
INSERT INTO "afgroede_kategori" ("afgroedekode", "afgroedenavn", "afgroedegruppe", "afgroedekategori", "priskategori") VALUES (587, 'Skovrejsning på tidl. landbrugsjord 3', 'Trækulturer', '(afgrøden har ingen kategori)', 'skovdrift');
INSERT INTO "afgroede_kategori" ("afgroedekode", "afgroedenavn", "afgroedegruppe", "afgroedekategori", "priskategori") VALUES (650, 'Chrysanthemum Garland, frø', 'Havefrø', 'chrysanthemum', 'Havefrø');
INSERT INTO "afgroede_kategori" ("afgroedekode", "afgroedenavn", "afgroedegruppe", "afgroedekategori", "priskategori") VALUES (120, 'Kløverfrø', 'Frøgræs', 'kløver', 'Frøgræs');
INSERT INTO "afgroede_kategori" ("afgroedekode", "afgroedenavn", "afgroedegruppe", "afgroedekategori", "priskategori") VALUES (15, 'Vinterhybridrug', 'Vintersæd til modenhed', 'vinterrug', 'vinterrug');
INSERT INTO "afgroede_kategori" ("afgroedekode", "afgroedenavn", "afgroedegruppe", "afgroedekategori", "priskategori") VALUES (578, 'Skovrejsning (privat) – forbedring af vandmiljø og grundvandsbeskyttelse', 'Trækulturer', '(afgrøden har ingen kategori)', 'skovdrift');
INSERT INTO "afgroede_kategori" ("afgroedekode", "afgroedenavn", "afgroedegruppe", "afgroedekategori", "priskategori") VALUES (703, 'Grønkorn af vårhavre', 'Korn, grønkorn', 'vårhavre', 'havre');
INSERT INTO "afgroede_kategori" ("afgroedekode", "afgroedenavn", "afgroedegruppe", "afgroedekategori", "priskategori") VALUES (210, 'Vårbyg, helsæd', 'Helsæd, vår', 'vårbyg', 'vårbyg');
INSERT INTO "afgroede_kategori" ("afgroedekode", "afgroedenavn", "afgroedegruppe", "afgroedekategori", "priskategori") VALUES (440, 'Solhat', 'Medicinplanter', 'solhat', 'potteplanter og stauder');
INSERT INTO "afgroede_kategori" ("afgroedekode", "afgroedenavn", "afgroedegruppe", "afgroedekategori", "priskategori") VALUES (710, 'Grønkorn af hybridrug', 'Korn, grønkorn', 'vinterrug', 'vinterrug');
INSERT INTO "afgroede_kategori" ("afgroedekode", "afgroedenavn", "afgroedegruppe", "afgroedekategori", "priskategori") VALUES (57, 'Vinterhavre', 'Vintersæd til modenhed', 'vinterhavre', 'havre');
INSERT INTO "afgroede_kategori" ("afgroedekode", "afgroedenavn", "afgroedegruppe", "afgroedekategori", "priskategori") VALUES (160, 'Sukkerroer til fabrik', 'Rodfrugter til fabrik', 'beder', 'sukkeroer');
INSERT INTO "afgroede_kategori" ("afgroedekode", "afgroedenavn", "afgroedegruppe", "afgroedekategori", "priskategori") VALUES (602, 'MFO - Pil', 'Energiafgrøder og anden særlig produktion', '(afgrøden har ingen kategori)', 'Energiafgrøder');
INSERT INTO "afgroede_kategori" ("afgroedekode", "afgroedenavn", "afgroedegruppe", "afgroedekategori", "priskategori") VALUES (506, 'Stikkelsbær, stiklingeopformering', 'Småplanteproduktion og planteskoleplanter', '(afgrøden har ingen kategori)', 'potteplanter og stauder');
INSERT INTO "afgroede_kategori" ("afgroedekode", "afgroedenavn", "afgroedegruppe", "afgroedekategori", "priskategori") VALUES (508, 'Andre af slægten Vaccinium', 'Småplanteproduktion og planteskoleplanter', '(afgrøden har ingen kategori)', 'potteplanter og stauder');
INSERT INTO "afgroede_kategori" ("afgroedekode", "afgroedenavn", "afgroedegruppe", "afgroedekategori", "priskategori") VALUES (251, 'Permanent græs, lavt udbytte', 'Græs, permanent', '(afgrøden har ingen kategori)', 'græs, permanent');
INSERT INTO "afgroede_kategori" ("afgroedekode", "afgroedenavn", "afgroedegruppe", "afgroedekategori", "priskategori") VALUES (705, 'Grønkorn af vårtriticale', 'Korn, grønkorn', 'vårtriticale', 'vårtriticale');
INSERT INTO "afgroede_kategori" ("afgroedekode", "afgroedenavn", "afgroedegruppe", "afgroedekategori", "priskategori") VALUES (599, 'Poppel (100-400 andre træer pr. ha)', 'Energiafgrøder og anden særlig produktion', '(afgrøden har ingen kategori)', 'Energiafgrøder');
INSERT INTO "afgroede_kategori" ("afgroedekode", "afgroedenavn", "afgroedegruppe", "afgroedekategori", "priskategori") VALUES (5, 'Majs til modenhed', 'Vårsæd til modenhed', 'majs', 'vårsæd til modenhed');
INSERT INTO "afgroede_kategori" ("afgroedekode", "afgroedenavn", "afgroedegruppe", "afgroedekategori", "priskategori") VALUES (266, 'Græs under 50% kløver/lucerne, ekstremt lavt udbytte (omdrift)', 'Græsmarksplanter, omdrift', 'græs eller andet grøntfoder', 'græs, sædskifte');
INSERT INTO "afgroede_kategori" ("afgroedekode", "afgroedenavn", "afgroedegruppe", "afgroedekategori", "priskategori") VALUES (104, 'Rajgræsfrø, ital. 1. år efterårsudlagt', 'Frøgræs', 'efterårssået rajgræsfrø', 'Frøgræs');
INSERT INTO "afgroede_kategori" ("afgroedekode", "afgroedenavn", "afgroedegruppe", "afgroedekategori", "priskategori") VALUES (171, 'Lucerne, slæt', 'Kløver og lucerne i renbestand', 'lucerne', 'lucerne');
INSERT INTO "afgroede_kategori" ("afgroedekode", "afgroedenavn", "afgroedegruppe", "afgroedekategori", "priskategori") VALUES (531, 'Anden træfrugt', 'Frugt og bær', '(afgrøden har ingen kategori)', 'frugt');
INSERT INTO "afgroede_kategori" ("afgroedekode", "afgroedenavn", "afgroedegruppe", "afgroedekategori", "priskategori") VALUES (604, 'MFO - El', 'Energiafgrøder og anden særlig produktion', '(afgrøden har ingen kategori)', 'Energiafgrøder');
INSERT INTO "afgroede_kategori" ("afgroedekode", "afgroedenavn", "afgroedegruppe", "afgroedekategori", "priskategori") VALUES (283, 'Fodergulerødder', 'Andre foderafgrøder', 'gulerod', 'foderrodfrugter');
INSERT INTO "afgroede_kategori" ("afgroedekode", "afgroedenavn", "afgroedegruppe", "afgroedekategori", "priskategori") VALUES (305, 'Permanent græs, uden udbetaling af økologi-tilskud', 'Udyrkede arealer, vildtagre o.l.', '(afgrøden har ingen kategori)', 'græs, permanent');
INSERT INTO "afgroede_kategori" ("afgroedekode", "afgroedenavn", "afgroedegruppe", "afgroedekategori", "priskategori") VALUES (54, 'Bælgsæd blanding', 'Oliefrø og Bælgsæd', 'vårsået blanding', 'Bælgsæd');
INSERT INTO "afgroede_kategori" ("afgroedekode", "afgroedenavn", "afgroedegruppe", "afgroedekategori", "priskategori") VALUES (4, 'Blanding af vårsåede arter', 'Vårsæd til modenhed', 'vårsået blanding', 'vårsæd til modenhed');
INSERT INTO "afgroede_kategori" ("afgroedekode", "afgroedenavn", "afgroedegruppe", "afgroedekategori", "priskategori") VALUES (361, 'Ikke støtteberettiget landbrugsareal', 'Særlige afgrødekoder i forbindelse med tilsagn eller miljøtiltag', '(afgrøden har ingen kategori)', 'brak');
INSERT INTO "afgroede_kategori" ("afgroedekode", "afgroedenavn", "afgroedegruppe", "afgroedekategori", "priskategori") VALUES (321, 'Miljøtiltag, ej landbrugsarealer', 'Særlige afgrødekoder i forbindelse med tilsagn eller miljøtiltag', '(afgrøden har ingen kategori)', 'brak');
INSERT INTO "afgroede_kategori" ("afgroedekode", "afgroedenavn", "afgroedegruppe", "afgroedekategori", "priskategori") VALUES (10, 'Vinterbyg', 'Vintersæd til modenhed', 'vinterbyg', 'vinterbyg');
INSERT INTO "afgroede_kategori" ("afgroedekode", "afgroedenavn", "afgroedegruppe", "afgroedekategori", "priskategori") VALUES (105, 'Timothefrø', 'Frøgræs', 'Timothefrø', 'Frøgræs');
INSERT INTO "afgroede_kategori" ("afgroedekode", "afgroedenavn", "afgroedegruppe", "afgroedekategori", "priskategori") VALUES (35, 'Bælgsæd, flerårig blanding', 'Oliefrø og Bælgsæd', 'vårsået blanding ', 'Bælgsæd');
INSERT INTO "afgroede_kategori" ("afgroedekode", "afgroedenavn", "afgroedegruppe", "afgroedekategori", "priskategori") VALUES (402, 'Bladselleri', 'Grøntsager, friland', 'selleri', 'grøntsager');
INSERT INTO "afgroede_kategori" ("afgroedekode", "afgroedenavn", "afgroedegruppe", "afgroedekategori", "priskategori") VALUES (6, 'Vårhvede, brødhvede', 'Vårsæd til modenhed', 'vårhvede', 'vårsæd til modenhed');
INSERT INTO "afgroede_kategori" ("afgroedekode", "afgroedenavn", "afgroedegruppe", "afgroedekategori", "priskategori") VALUES (107, 'Engsvingelfrø', 'Frøgræs', 'svingelfrø', 'Frøgræs');
INSERT INTO "afgroede_kategori" ("afgroedekode", "afgroedenavn", "afgroedegruppe", "afgroedekategori", "priskategori") VALUES (537, 'Valnød (almindelig)', 'Frugt og bær', '(afgrøden har ingen kategori)', 'bær');
INSERT INTO "afgroede_kategori" ("afgroedekode", "afgroedenavn", "afgroedegruppe", "afgroedekategori", "priskategori") VALUES (220, 'Vinterbyg, helsæd', 'Helsæd, vinter', 'vinterbyg', 'vinterbyg');
INSERT INTO "afgroede_kategori" ("afgroedekode", "afgroedenavn", "afgroedegruppe", "afgroedekategori", "priskategori") VALUES (400, 'Asieagurker', 'Grøntsager, friland', 'agurk', 'grøntsager');
INSERT INTO "afgroede_kategori" ("afgroedekode", "afgroedenavn", "afgroedegruppe", "afgroedekategori", "priskategori") VALUES (252, 'Permanent græs, normalt udbytte', 'Græs, permanent', '(afgrøden har ingen kategori)', 'græs, permanent');
INSERT INTO "afgroede_kategori" ("afgroedekode", "afgroedenavn", "afgroedegruppe", "afgroedekategori", "priskategori") VALUES (343, 'MFO-bestøverbrak', 'Særlige afgrødekoder i forbindelse med tilsagn eller miljøtiltag', 'brak', 'brak');
INSERT INTO "afgroede_kategori" ("afgroedekode", "afgroedenavn", "afgroedegruppe", "afgroedekategori", "priskategori") VALUES (31, 'Hestebønner', 'Oliefrø og Bælgsæd', 'hestebønne', 'Bælgsæd');
INSERT INTO "afgroede_kategori" ("afgroedekode", "afgroedenavn", "afgroedegruppe", "afgroedekategori", "priskategori") VALUES (596, 'Elefantgræs', 'Energiafgrøder og anden særlig produktion', '(afgrøden har ingen kategori)', 'Energiafgrøder');
INSERT INTO "afgroede_kategori" ("afgroedekode", "afgroedenavn", "afgroedegruppe", "afgroedekategori", "priskategori") VALUES (285, 'Græs og kløvergræs uden norm, over 50 % kløver (omdrift)', 'Græsmarksplanter, omdrift', 'græs eller andet grøntfoder', 'græs, sædskifte');
INSERT INTO "afgroede_kategori" ("afgroedekode", "afgroedenavn", "afgroedegruppe", "afgroedekategori", "priskategori") VALUES (327, 'MFO-bræmme, sommerslåning', 'Særlige afgrødekoder i forbindelse med tilsagn eller miljøtiltag', 'brak', 'brak');
INSERT INTO "afgroede_kategori" ("afgroedekode", "afgroedenavn", "afgroedegruppe", "afgroedekategori", "priskategori") VALUES (253, 'Miljøgræs MVJ-tilsagn (80 N), omdrift', 'Arealer med tilsagn under miljøordningerne', 'græs eller andet grøntfoder', 'græs, sædskifte');
INSERT INTO "afgroede_kategori" ("afgroedekode", "afgroedenavn", "afgroedegruppe", "afgroedekategori", "priskategori") VALUES (14, 'Vinterrug', 'Vintersæd til modenhed', 'vinterrug', 'vinterrug');
INSERT INTO "afgroede_kategori" ("afgroedekode", "afgroedenavn", "afgroedegruppe", "afgroedekategori", "priskategori") VALUES (581, 'Skovdrift med fjernelse af ved', 'Trækulturer', '(afgrøden har ingen kategori)', 'skovdrift');
INSERT INTO "afgroede_kategori" ("afgroedekode", "afgroedenavn", "afgroedegruppe", "afgroedekategori", "priskategori") VALUES (497, 'Planteskolekulturer, vedplanter, til videresalg', 'Småplanteproduktion og planteskoleplanter', '(afgrøden har ingen kategori)', 'potteplanter og stauder');
INSERT INTO "afgroede_kategori" ("afgroedekode", "afgroedenavn", "afgroedegruppe", "afgroedekategori", "priskategori") VALUES (661, 'Kørvelfrø', 'Havefrø', 'kørvel', 'Havefrø');
INSERT INTO "afgroede_kategori" ("afgroedekode", "afgroedenavn", "afgroedegruppe", "afgroedekategori", "priskategori") VALUES (512, 'Rabarber', 'Frugt og bær', '(afgrøden har ingen kategori)', 'frugt');
INSERT INTO "afgroede_kategori" ("afgroedekode", "afgroedenavn", "afgroedegruppe", "afgroedekategori", "priskategori") VALUES (109, 'Rajsvingelfrø', 'Frøgræs', 'vårssået rajsvingelfrø', 'Frøgræs');
INSERT INTO "afgroede_kategori" ("afgroedekode", "afgroedenavn", "afgroedegruppe", "afgroedekategori", "priskategori") VALUES (523, 'Blomme med undervækst af græs', 'Frugt og bær', '(afgrøden har ingen kategori)', 'bær');
INSERT INTO "afgroede_kategori" ("afgroedekode", "afgroedenavn", "afgroedegruppe", "afgroedekategori", "priskategori") VALUES (13, 'Vinterhvede, brødhvede', 'Vintersæd til modenhed', 'vinterhvede', 'vinterhvede');
INSERT INTO "afgroede_kategori" ("afgroedekode", "afgroedenavn", "afgroedegruppe", "afgroedekategori", "priskategori") VALUES (155, 'Kartofler, pulver/granules-', 'Kartofler', 'kartoffel', 'processkartofler');
INSERT INTO "afgroede_kategori" ("afgroedekode", "afgroedenavn", "afgroedegruppe", "afgroedekategori", "priskategori") VALUES (416, 'Rosenkål', 'Grøntsager, friland', 'kål', 'kål');
INSERT INTO "afgroede_kategori" ("afgroedekode", "afgroedenavn", "afgroedegruppe", "afgroedekategori", "priskategori") VALUES (487, 'Skovlandbrug', 'Trækulturer', '(afgrøden har ingen kategori)', 'skovdrift');
INSERT INTO "afgroede_kategori" ("afgroedekode", "afgroedenavn", "afgroedegruppe", "afgroedekategori", "priskategori") VALUES (2, 'Vårhvede', 'Vårsæd til modenhed', 'vårhvede', 'vårsæd til modenhed');
INSERT INTO "afgroede_kategori" ("afgroedekode", "afgroedenavn", "afgroedegruppe", "afgroedekategori", "priskategori") VALUES (339, 'MFO-brak, forårsslåning', 'Udyrkede arealer, vildtagre o.l.', 'brak', 'brak');
INSERT INTO "afgroede_kategori" ("afgroedekode", "afgroedenavn", "afgroedegruppe", "afgroedekategori", "priskategori") VALUES (538, 'Kastanje (ægte)', 'Frugt og bær', '(afgrøden har ingen kategori)', 'bær');
INSERT INTO "afgroede_kategori" ("afgroedekode", "afgroedenavn", "afgroedegruppe", "afgroedekategori", "priskategori") VALUES (344, 'Brak langs vandløb og søer, forårsslåning (alternativ til efterafgrøder)', 'Udyrkede arealer, vildtagre o.l.', 'brak', 'brak');
INSERT INTO "afgroede_kategori" ("afgroedekode", "afgroedenavn", "afgroedegruppe", "afgroedekategori", "priskategori") VALUES (335, 'MFO-bræmme, permanent græs, forårsslåning', 'Særlige afgrødekoder i forbindelse med tilsagn eller miljøtiltag', '(afgrøden har ingen kategori)', 'græs, permanent');
INSERT INTO "afgroede_kategori" ("afgroedekode", "afgroedenavn", "afgroedegruppe", "afgroedekategori", "priskategori") VALUES (152, 'Kartofler, spise- (pakkeri, vejsalg)', 'Kartofler', 'kartoffel', 'spisekartofler');
INSERT INTO "afgroede_kategori" ("afgroedekode", "afgroedenavn", "afgroedegruppe", "afgroedekategori", "priskategori") VALUES (410, 'Knoldselleri', 'Grøntsager, friland', 'selleri', 'grøntsager');
INSERT INTO "afgroede_kategori" ("afgroedekode", "afgroedenavn", "afgroedegruppe", "afgroedekategori", "priskategori") VALUES (534, 'Hyben', 'Frugt og bær', '(afgrøden har ingen kategori)', 'frugt');
INSERT INTO "afgroede_kategori" ("afgroedekode", "afgroedenavn", "afgroedegruppe", "afgroedekategori", "priskategori") VALUES (603, 'MFO - Poppel (0-100 andre træer pr. ha)', 'Energiafgrøder og anden særlig produktion', '(afgrøden har ingen kategori)', 'Energiafgrøder');
INSERT INTO "afgroede_kategori" ("afgroedekode", "afgroedenavn", "afgroedegruppe", "afgroedekategori", "priskategori") VALUES (591, 'Lavskov', 'Energiafgrøder og anden særlig produktion', '(afgrøden har ingen kategori)', 'Energiafgrøder');
INSERT INTO "afgroede_kategori" ("afgroedekode", "afgroedenavn", "afgroedegruppe", "afgroedekategori", "priskategori") VALUES (230, 'Blanding af vårkorn, grønkorn', 'Korn, grønkorn', 'vårsået blanding', 'vårkorn blanding');
INSERT INTO "afgroede_kategori" ("afgroedekode", "afgroedenavn", "afgroedegruppe", "afgroedekategori", "priskategori") VALUES (7, 'Korn og bælgsæd under 50% bælgsæd', 'Vårsæd til modenhed', 'vårsået blanding', 'vårsæd til modenhed');
INSERT INTO "afgroede_kategori" ("afgroedekode", "afgroedenavn", "afgroedegruppe", "afgroedekategori", "priskategori") VALUES (222, 'Vinterrug, helsæd', 'Helsæd, vinter', 'vinterrug', 'vinterrug');
INSERT INTO "afgroede_kategori" ("afgroedekode", "afgroedenavn", "afgroedegruppe", "afgroedekategori", "priskategori") VALUES (651, 'Dildfrø', 'Havefrø', 'dild', 'Havefrø');
INSERT INTO "afgroede_kategori" ("afgroedekode", "afgroedenavn", "afgroedegruppe", "afgroedekategori", "priskategori") VALUES (597, 'Rørgræs', 'Energiafgrøder og anden særlig produktion', '(afgrøden har ingen kategori)', 'Energiafgrøder');
INSERT INTO "afgroede_kategori" ("afgroedekode", "afgroedenavn", "afgroedegruppe", "afgroedekategori", "priskategori") VALUES (503, 'En- og to-årige planter', 'Småplanteproduktion og planteskoleplanter', 'planteskolekultur', 'potteplanter og stauder');
INSERT INTO "afgroede_kategori" ("afgroedekode", "afgroedenavn", "afgroedegruppe", "afgroedekategori", "priskategori") VALUES (254, 'Miljøgræs MVJ-tilsagn (0 N), permanent', 'Arealer med tilsagn under miljøordningerne', '(afgrøden har ingen kategori)', 'græs, permanent');
INSERT INTO "afgroede_kategori" ("afgroedekode", "afgroedenavn", "afgroedegruppe", "afgroedekategori", "priskategori") VALUES (548, 'Småplanter, en-årige', 'Småplanteproduktion og planteskoleplanter', 'planteskolekultur', 'potteplanter og stauder');
INSERT INTO "afgroede_kategori" ("afgroedekode", "afgroedenavn", "afgroedegruppe", "afgroedekategori", "priskategori") VALUES (217, 'Korn og bælgsæd, helsæd, over 50% bælgsæd', 'Helsæd, vår', 'vårsået blanding', 'helsæd, vår');
INSERT INTO "afgroede_kategori" ("afgroedekode", "afgroedenavn", "afgroedegruppe", "afgroedekategori", "priskategori") VALUES (432, 'Krydderurter (undtagen persille og purløg)', 'Grøntsager, friland', 'planteskolekultur', 'krydderurter');
INSERT INTO "afgroede_kategori" ("afgroedekode", "afgroedenavn", "afgroedegruppe", "afgroedekategori", "priskategori") VALUES (250, 'Permanent græs, meget lavt udbytte', 'Græs, permanent', '(afgrøden har ingen kategori)', 'græs, permanent');
INSERT INTO "afgroede_kategori" ("afgroedekode", "afgroedenavn", "afgroedegruppe", "afgroedekategori", "priskategori") VALUES (709, 'Grønkorn af vinterrug', 'Korn, grønkorn', 'vinterrug', 'vinterrug');
INSERT INTO "afgroede_kategori" ("afgroedekode", "afgroedenavn", "afgroedegruppe", "afgroedekategori", "priskategori") VALUES (501, 'Stauder', 'Småplanteproduktion og planteskoleplanter', 'planteskolekultur', 'potteplanter og stauder');
INSERT INTO "afgroede_kategori" ("afgroedekode", "afgroedenavn", "afgroedegruppe", "afgroedekategori", "priskategori") VALUES (545, 'Potteplanter', 'Småplanteproduktion og planteskoleplanter', '(afgrøden har ingen kategori)', 'potteplanter og stauder');
INSERT INTO "afgroede_kategori" ("afgroedekode", "afgroedenavn", "afgroedegruppe", "afgroedekategori", "priskategori") VALUES (182, 'Blanding af oliearter', 'Oliefrø og Bælgsæd', 'vårsået blanding', 'oliefrø');
INSERT INTO "afgroede_kategori" ("afgroedekode", "afgroedenavn", "afgroedegruppe", "afgroedekategori", "priskategori") VALUES (319, 'MFO-brak, Udtagning, ej landbrugsareal', 'Særlige afgrødekoder i forbindelse med tilsagn eller miljøtiltag', '(afgrøden har ingen kategori)', 'brak');
INSERT INTO "afgroede_kategori" ("afgroedekode", "afgroedenavn", "afgroedegruppe", "afgroedekategori", "priskategori") VALUES (1, 'Vårbyg', 'Vårsæd til modenhed', 'vårbyg', 'vårbyg');
INSERT INTO "afgroede_kategori" ("afgroedekode", "afgroedenavn", "afgroedegruppe", "afgroedekategori", "priskategori") VALUES (106, 'Hundegræsfrø', 'Frøgræs', 'hundegræsfrø', 'Frøgræs');
INSERT INTO "afgroede_kategori" ("afgroedekode", "afgroedenavn", "afgroedegruppe", "afgroedekategori", "priskategori") VALUES (517, 'Brombær', 'Frugt og bær', '(afgrøden har ingen kategori)', 'bær');
INSERT INTO "afgroede_kategori" ("afgroedekode", "afgroedenavn", "afgroedegruppe", "afgroedekategori", "priskategori") VALUES (18, 'Korn og bælgsæd over 50% bælgsæd', 'Vårsæd til modenhed', 'vårsået blanding', 'vårsæd til modenhed');
INSERT INTO "afgroede_kategori" ("afgroedekode", "afgroedenavn", "afgroedegruppe", "afgroedekategori", "priskategori") VALUES (528, 'Æbler', 'Frugt og bær', '(afgrøden har ingen kategori)', 'frugt');
INSERT INTO "afgroede_kategori" ("afgroedekode", "afgroedenavn", "afgroedegruppe", "afgroedekategori", "priskategori") VALUES (110, 'Svingelfrø, bakke- (tidl. Stivbladet)', 'Frøgræs', 'svingelfrø', 'Frøgræs');
INSERT INTO "afgroede_kategori" ("afgroedekode", "afgroedenavn", "afgroedegruppe", "afgroedekategori", "priskategori") VALUES (563, 'Svampe, champignon', 'Småplanteproduktion og planteskoleplanter', '(afgrøden har ingen kategori)', 'potteplanter og stauder');
INSERT INTO "afgroede_kategori" ("afgroedekode", "afgroedenavn", "afgroedegruppe", "afgroedekategori", "priskategori") VALUES (496, 'Medicinpl., vedplanter', 'Medicinplanter', '(afgrøden har ingen kategori)', 'potteplanter og stauder');
INSERT INTO "afgroede_kategori" ("afgroedekode", "afgroedenavn", "afgroedegruppe", "afgroedekategori", "priskategori") VALUES (58, 'Sorghum', 'Vårsæd til modenhed', 'sorghum', 'vårsæd til modenhed');
INSERT INTO "afgroede_kategori" ("afgroedekode", "afgroedenavn", "afgroedegruppe", "afgroedekategori", "priskategori") VALUES (8, 'Vårspelt', 'Vårsæd til modenhed', 'vårspelt', 'vårsæd til modenhed');
INSERT INTO "afgroede_kategori" ("afgroedekode", "afgroedenavn", "afgroedegruppe", "afgroedekategori", "priskategori") VALUES (585, 'Skovrejsning i projektområde, som ikke er omfattet af tilsagn', 'Trækulturer', '(afgrøden har ingen kategori)', 'skovdrift');
INSERT INTO "afgroede_kategori" ("afgroedekode", "afgroedenavn", "afgroedegruppe", "afgroedekategori", "priskategori") VALUES (667, 'Timianfrø', 'Havefrø', 'timian', 'Havefrø');
INSERT INTO "afgroede_kategori" ("afgroedekode", "afgroedenavn", "afgroedegruppe", "afgroedekategori", "priskategori") VALUES (668, 'Blomsterfrø', 'Havefrø', 'planteskolekultur', 'Havefrø');
INSERT INTO "afgroede_kategori" ("afgroedekode", "afgroedenavn", "afgroedegruppe", "afgroedekategori", "priskategori") VALUES (708, 'Grønkorn af vinterhavre', 'Korn, grønkorn', 'vinterhavre', 'havre');
INSERT INTO "afgroede_kategori" ("afgroedekode", "afgroedenavn", "afgroedegruppe", "afgroedekategori", "priskategori") VALUES (267, 'Græs  under 50% kløver/lucerne, meget lavt udbytte (omdrift)', 'Græsmarksplanter, omdrift', 'græs eller andet grøntfoder', 'græs, sædskifte');
INSERT INTO "afgroede_kategori" ("afgroedekode", "afgroedenavn", "afgroedegruppe", "afgroedekategori", "priskategori") VALUES (448, 'Medicinpl., en- og toårige', 'Medicinplanter', 'planteskolekultur', 'potteplanter og stauder');
INSERT INTO "afgroede_kategori" ("afgroedekode", "afgroedenavn", "afgroedegruppe", "afgroedekategori", "priskategori") VALUES (52, 'Quinoa', 'Hør og Hamp', 'quinoa', 'oliefrø');
INSERT INTO "afgroede_kategori" ("afgroedekode", "afgroedenavn", "afgroedegruppe", "afgroedekategori", "priskategori") VALUES (701, 'Grønkorn af vårbyg', 'Korn, grønkorn', 'vårbyg', 'vårbyg');
INSERT INTO "afgroede_kategori" ("afgroedekode", "afgroedenavn", "afgroedegruppe", "afgroedekategori", "priskategori") VALUES (162, 'Blanding, andre industriafgr.', 'Rodfrugter til fabrik', 'vintersået blanding', 'sukkeroer');
INSERT INTO "afgroede_kategori" ("afgroedekode", "afgroedenavn", "afgroedegruppe", "afgroedekategori", "priskategori") VALUES (514, 'Solbær', 'Frugt og bær', '(afgrøden har ingen kategori)', 'bær');
INSERT INTO "afgroede_kategori" ("afgroedekode", "afgroedenavn", "afgroedegruppe", "afgroedekategori", "priskategori") VALUES (450, 'Grøntsager, blandinger', 'Grøntsager, friland', 'vårsået blanding', 'grøntsager');
INSERT INTO "afgroede_kategori" ("afgroedekode", "afgroedenavn", "afgroedegruppe", "afgroedekategori", "priskategori") VALUES (322, 'Minivådområder, projekttilsagn', 'Særlige afgrødekoder i forbindelse med tilsagn eller miljøtiltag', '(afgrøden har ingen kategori)', 'brak');
INSERT INTO "afgroede_kategori" ("afgroedekode", "afgroedenavn", "afgroedegruppe", "afgroedekategori", "priskategori") VALUES (582, 'Pyntegrønt, økologisk jordbrug', 'Trækulturer', '(afgrøden har ingen kategori)', 'skovdrift');
INSERT INTO "afgroede_kategori" ("afgroedekode", "afgroedenavn", "afgroedegruppe", "afgroedekategori", "priskategori") VALUES (900, 'Øvrige afgrøder', 'Øvrige afgrøder', '(afgrøden har ingen kategori)', 'Brak');
INSERT INTO "afgroede_kategori" ("afgroedekode", "afgroedenavn", "afgroedegruppe", "afgroedekategori", "priskategori") VALUES (405, 'Courgette, squash', 'Grøntsager, friland', 'mandelgræskar', 'grøntsager');
INSERT INTO "afgroede_kategori" ("afgroedekode", "afgroedenavn", "afgroedegruppe", "afgroedekategori", "priskategori") VALUES (170, 'Græs til fabrik (omdrift)', 'Græsmarksplanter, omdrift', 'græs eller andet grøntfoder', 'græs, sædskifte');
INSERT INTO "afgroede_kategori" ("afgroedekode", "afgroedenavn", "afgroedegruppe", "afgroedekategori", "priskategori") VALUES (276, 'Permanent græs og kløvergræs uden norm, under 50 % kløver', 'Græs, permanent', '(afgrøden har ingen kategori)', 'græs, permanent');
INSERT INTO "afgroede_kategori" ("afgroedekode", "afgroedenavn", "afgroedegruppe", "afgroedekategori", "priskategori") VALUES (513, 'Jordbær', 'Frugt og bær', 'jordbær', 'bær');
INSERT INTO "afgroede_kategori" ("afgroedekode", "afgroedenavn", "afgroedegruppe", "afgroedekategori", "priskategori") VALUES (101, 'Rajgræsfrø, alm.', 'Frøgræs', 'vårsået rajgræsfrø', 'Frøgræs');
INSERT INTO "afgroede_kategori" ("afgroedekode", "afgroedenavn", "afgroedegruppe", "afgroedekategori", "priskategori") VALUES (262, 'Lucernegræs, over 50% lucerne (omdrift)', 'Græsmarksplanter, omdrift', 'græs eller andet grøntfoder', 'græs, sædskifte');
INSERT INTO "afgroede_kategori" ("afgroedekode", "afgroedenavn", "afgroedegruppe", "afgroedekategori", "priskategori") VALUES (337, 'MFO-bræmme, permanent græs, miljøtilsagn', 'Særlige afgrødekoder i forbindelse med tilsagn eller miljøtiltag', '(afgrøden har ingen kategori)', 'græs, permanent');
INSERT INTO "afgroede_kategori" ("afgroedekode", "afgroedenavn", "afgroedegruppe", "afgroedekategori", "priskategori") VALUES (115, 'Hvenefrø, alm. og krybende', 'Frøgræs', 'hvenefrø', 'Frøgræs');
INSERT INTO "afgroede_kategori" ("afgroedekode", "afgroedenavn", "afgroedegruppe", "afgroedekategori", "priskategori") VALUES (114, 'Rapgræsfrø, alm.', 'Frøgræs', 'eng- og rapgræsfrø', 'Frøgræs');
INSERT INTO "afgroede_kategori" ("afgroedekode", "afgroedenavn", "afgroedegruppe", "afgroedekategori", "priskategori") VALUES (504, 'Solbær, stiklingeopformering', 'Småplanteproduktion og planteskoleplanter', '(afgrøden har ingen kategori)', 'potteplanter og stauder');
INSERT INTO "afgroede_kategori" ("afgroedekode", "afgroedenavn", "afgroedegruppe", "afgroedekategori", "priskategori") VALUES (415, 'Porre', 'Grøntsager, friland', 'løg', 'grøntsager');
INSERT INTO "afgroede_kategori" ("afgroedekode", "afgroedenavn", "afgroedegruppe", "afgroedekategori", "priskategori") VALUES (112, 'Engrapgræsfrø (marktype)', 'Frøgræs', 'eng- og rapgræsfrø', 'Frøgræs');
INSERT INTO "afgroede_kategori" ("afgroedekode", "afgroedenavn", "afgroedegruppe", "afgroedekategori", "priskategori") VALUES (108, 'Rødsvingelfrø', 'Frøgræs', 'svingelfrø', 'Frøgræs');
INSERT INTO "afgroede_kategori" ("afgroedekode", "afgroedenavn", "afgroedegruppe", "afgroedekategori", "priskategori") VALUES (547, 'Planteskolekulturer, stauder', 'Småplanteproduktion og planteskoleplanter', 'planteskolekultur', 'potteplanter og stauder');
INSERT INTO "afgroede_kategori" ("afgroedekode", "afgroedenavn", "afgroedegruppe", "afgroedekategori", "priskategori") VALUES (408, 'Hvidkål', 'Grøntsager, friland', 'kål', 'kål');
INSERT INTO "afgroede_kategori" ("afgroedekode", "afgroedenavn", "afgroedegruppe", "afgroedekategori", "priskategori") VALUES (268, 'Græs under 50% kløver/lucerne, lavt udbytte (omdrift)', 'Græsmarksplanter, omdrift', 'græs eller andet grøntfoder', 'græs, sædskifte');
INSERT INTO "afgroede_kategori" ("afgroedekode", "afgroedenavn", "afgroedegruppe", "afgroedekategori", "priskategori") VALUES (518, 'Hindbær', 'Frugt og bær', '(afgrøden har ingen kategori)', 'bær');
INSERT INTO "afgroede_kategori" ("afgroedekode", "afgroedenavn", "afgroedegruppe", "afgroedekategori", "priskategori") VALUES (589, 'Bæredygtig skovdrift', 'Trækulturer', '(afgrøden har ingen kategori)', 'skovdrift');
INSERT INTO "afgroede_kategori" ("afgroedekode", "afgroedenavn", "afgroedegruppe", "afgroedekategori", "priskategori") VALUES (583, 'Juletræer og pyntegrønt', 'Trækulturer', '(afgrøden har ingen kategori)', 'skovdrift');
INSERT INTO "afgroede_kategori" ("afgroedekode", "afgroedenavn", "afgroedegruppe", "afgroedekategori", "priskategori") VALUES (124, 'Spinatfrø', 'Frøgræs', 'spinat', 'Frøgræs');
INSERT INTO "afgroede_kategori" ("afgroedekode", "afgroedenavn", "afgroedegruppe", "afgroedekategori", "priskategori") VALUES (522, 'Blomme uden undervækst af græs', 'Frugt og bær', '(afgrøden har ingen kategori)', 'bær');
INSERT INTO "afgroede_kategori" ("afgroedekode", "afgroedenavn", "afgroedegruppe", "afgroedekategori", "priskategori") VALUES (329, 'MFO-bræmme, miljøtilsagn', 'Særlige afgrødekoder i forbindelse med tilsagn eller miljøtiltag', 'brak', 'brak');
INSERT INTO "afgroede_kategori" ("afgroedekode", "afgroedenavn", "afgroedegruppe", "afgroedekategori", "priskategori") VALUES (11, 'Vinterhvede', 'Vintersæd til modenhed', 'vinterhvede', 'vinterhvede');
INSERT INTO "afgroede_kategori" ("afgroedekode", "afgroedenavn", "afgroedegruppe", "afgroedekategori", "priskategori") VALUES (575, 'Skovrejsning (privat) - kulstofbinding og grundvandsbeskyttelse', 'Trækulturer', '(afgrøden har ingen kategori)', 'skovdrift');
INSERT INTO "afgroede_kategori" ("afgroedekode", "afgroedenavn", "afgroedegruppe", "afgroedekategori", "priskategori") VALUES (401, 'Asparges', 'Grøntsager, friland', '(afgrøden har ingen kategori)', 'grøntsager');
INSERT INTO "afgroede_kategori" ("afgroedekode", "afgroedenavn", "afgroedegruppe", "afgroedekategori", "priskategori") VALUES (490, 'Hassel, træ (Corylus avellana)', 'Frugt og bær', '(afgrøden har ingen kategori)', 'bær');
INSERT INTO "afgroede_kategori" ("afgroedekode", "afgroedenavn", "afgroedegruppe", "afgroedekategori", "priskategori") VALUES (527, 'Hassel (Corylus maxima)', 'Frugt og bær', '(afgrøden har ingen kategori)', 'bær');
INSERT INTO "afgroede_kategori" ("afgroedekode", "afgroedenavn", "afgroedegruppe", "afgroedekategori", "priskategori") VALUES (235, 'Blanding af vinterkorn, grønkorn', 'Korn, grønkorn', 'vintersået blanding', 'vinterkorn blanding');
INSERT INTO "afgroede_kategori" ("afgroedekode", "afgroedenavn", "afgroedegruppe", "afgroedekategori", "priskategori") VALUES (590, 'Bæredygtig skovdrift i Natura 2000-område', 'Trækulturer', '(afgrøden har ingen kategori)', 'skovdrift');
INSERT INTO "afgroede_kategori" ("afgroedekode", "afgroedenavn", "afgroedegruppe", "afgroedekategori", "priskategori") VALUES (659, 'Kålfrø (hvid- og rødkål)', 'Havefrø', 'kål', 'Havefrø');
INSERT INTO "afgroede_kategori" ("afgroedekode", "afgroedenavn", "afgroedegruppe", "afgroedekategori", "priskategori") VALUES (306, 'Græs i omdrift, uden udbetaling af økologi-tilskud', 'Udyrkede arealer, vildtagre o.l.', 'græs eller andet grøntfoder', 'græs, sædskifte');
INSERT INTO "afgroede_kategori" ("afgroedekode", "afgroedenavn", "afgroedegruppe", "afgroedekategori", "priskategori") VALUES (286, 'Permanent græs og kløvergræs uden norm, over 50 % kløver', 'Græs, permanent', '(afgrøden har ingen kategori)', 'græs, permanent');
INSERT INTO "afgroede_kategori" ("afgroedekode", "afgroedenavn", "afgroedegruppe", "afgroedekategori", "priskategori") VALUES (507, 'Hindbær, stiklingeopformering', 'Småplanteproduktion og planteskoleplanter', '(afgrøden har ingen kategori)', 'potteplanter og stauder');
INSERT INTO "afgroede_kategori" ("afgroedekode", "afgroedenavn", "afgroedegruppe", "afgroedekategori", "priskategori") VALUES (279, 'Permanent kløvergræs til fabrik', 'Græs, permanent', '(afgrøden har ingen kategori)', 'græs, permanent');
INSERT INTO "afgroede_kategori" ("afgroedekode", "afgroedenavn", "afgroedegruppe", "afgroedekategori", "priskategori") VALUES (214, 'Korn og bælgsæd, helsæd, under 50% bælgsæd', 'Helsæd, vår', 'vårsået blanding', 'helsæd, vår');
INSERT INTO "afgroede_kategori" ("afgroedekode", "afgroedenavn", "afgroedegruppe", "afgroedekategori", "priskategori") VALUES (9, 'Vinterspelt', 'Vintersæd til modenhed', 'vinterspelt', 'vinterkorn blanding');
INSERT INTO "afgroede_kategori" ("afgroedekode", "afgroedenavn", "afgroedegruppe", "afgroedekategori", "priskategori") VALUES (338, 'Brak, forårsslåning', 'Udyrkede arealer, vildtagre o.l.', 'brak', 'brak');
INSERT INTO "afgroede_kategori" ("afgroedekode", "afgroedenavn", "afgroedegruppe", "afgroedekategori", "priskategori") VALUES (903, 'Lysåbne arealer i skov', 'Øvrige afgrøder', '(afgrøden har ingen kategori)', 'Brak');
INSERT INTO "afgroede_kategori" ("afgroedekode", "afgroedenavn", "afgroedegruppe", "afgroedekategori", "priskategori") VALUES (543, 'Grøntsager, andre (drivhus)', 'Småplanteproduktion og planteskoleplanter', 'planteskolekultur', 'potteplanter og stauder');
INSERT INTO "afgroede_kategori" ("afgroedekode", "afgroedenavn", "afgroedegruppe", "afgroedekategori", "priskategori") VALUES (664, 'Skorzonerrod/skorzonerrodfrø', 'Havefrø', 'skorzonerrod', 'Havefrø');
INSERT INTO "afgroede_kategori" ("afgroedekode", "afgroedenavn", "afgroedegruppe", "afgroedekategori", "priskategori") VALUES (412, 'Pastinak', 'Grøntsager, friland', 'pastinak', 'grøntsager');
INSERT INTO "afgroede_kategori" ("afgroedekode", "afgroedenavn", "afgroedegruppe", "afgroedekategori", "priskategori") VALUES (551, 'Moskusgræskar', 'Frugt og bær', 'moskusgræskar', 'grøntsager');
INSERT INTO "afgroede_kategori" ("afgroedekode", "afgroedenavn", "afgroedegruppe", "afgroedekategori", "priskategori") VALUES (532, 'Anden buskfrugt', 'Frugt og bær', '(afgrøden har ingen kategori)', 'frugt');
INSERT INTO "afgroede_kategori" ("afgroedekode", "afgroedenavn", "afgroedegruppe", "afgroedekategori", "priskategori") VALUES (564, 'Containerplads', 'Småplanteproduktion og planteskoleplanter', '(afgrøden har ingen kategori)', 'brak');
INSERT INTO "afgroede_kategori" ("afgroedekode", "afgroedenavn", "afgroedegruppe", "afgroedekategori", "priskategori") VALUES (535, 'Bærmispel', 'Frugt og bær', '(afgrøden har ingen kategori)', 'frugt');
INSERT INTO "afgroede_kategori" ("afgroedekode", "afgroedenavn", "afgroedegruppe", "afgroedekategori", "priskategori") VALUES (592, 'Pil', 'Energiafgrøder og anden særlig produktion', '(afgrøden har ingen kategori)', 'Energiafgrøder');
INSERT INTO "afgroede_kategori" ("afgroedekode", "afgroedenavn", "afgroedegruppe", "afgroedekategori", "priskategori") VALUES (281, 'Kålroer', 'Andre foderafgrøder', 'vårraps', 'foderrodfrugter');
INSERT INTO "afgroede_kategori" ("afgroedekode", "afgroedenavn", "afgroedegruppe", "afgroedekategori", "priskategori") VALUES (579, 'Tagetes, sygdomssanerende plante', 'Udyrkede arealer, vildtagre o.l.', 'tagetes', 'potteplanter og stauder');
INSERT INTO "afgroede_kategori" ("afgroedekode", "afgroedenavn", "afgroedegruppe", "afgroedekategori", "priskategori") VALUES (510, 'Melon', 'Frugt og bær', 'melon', 'frugt');
INSERT INTO "afgroede_kategori" ("afgroedekode", "afgroedenavn", "afgroedegruppe", "afgroedekategori", "priskategori") VALUES (553, 'Centnergræskar', 'Frugt og bær', 'centnergræskar', 'grøntsager');
INSERT INTO "afgroede_kategori" ("afgroedekode", "afgroedenavn", "afgroedegruppe", "afgroedekategori", "priskategori") VALUES (259, 'Permanent græs, fabrik, over 6 tons', 'Græs, permanent', '(afgrøden har ingen kategori)', 'græs, permanent');
INSERT INTO "afgroede_kategori" ("afgroedekode", "afgroedenavn", "afgroedegruppe", "afgroedekategori", "priskategori") VALUES (519, 'Blåbær', 'Frugt og bær', '(afgrøden har ingen kategori)', 'bær');
INSERT INTO "afgroede_kategori" ("afgroedekode", "afgroedenavn", "afgroedegruppe", "afgroedekategori", "priskategori") VALUES (172, 'Lucernegræs, over 25% græs til slæt inkl. eget foder', 'Græsmarksplanter, omdrift', 'græs eller andet grøntfoder', 'græs, sædskifte');
INSERT INTO "afgroede_kategori" ("afgroedekode", "afgroedenavn", "afgroedegruppe", "afgroedekategori", "priskategori") VALUES (409, 'Kinakål', 'Grøntsager, friland', 'ager-kål', 'kål');
INSERT INTO "afgroede_kategori" ("afgroedekode", "afgroedenavn", "afgroedegruppe", "afgroedekategori", "priskategori") VALUES (30, 'Ærter', 'Oliefrø og Bælgsæd', 'ært', 'Bælgsæd');
INSERT INTO "afgroede_kategori" ("afgroedekode", "afgroedenavn", "afgroedegruppe", "afgroedekategori", "priskategori") VALUES (21, 'Vårraps', 'Oliefrø og Bælgsæd', 'vårraps', 'oliefrø');
INSERT INTO "afgroede_kategori" ("afgroedekode", "afgroedenavn", "afgroedegruppe", "afgroedekategori", "priskategori") VALUES (521, 'Surkirsebær med undervækst af græs', 'Frugt og bær', '(afgrøden har ingen kategori)', 'bær');
INSERT INTO "afgroede_kategori" ("afgroedekode", "afgroedenavn", "afgroedegruppe", "afgroedekategori", "priskategori") VALUES (3, 'Vårhavre', 'Vårsæd til modenhed', 'vårhavre', 'vårsæd til modenhed');
INSERT INTO "afgroede_kategori" ("afgroedekode", "afgroedenavn", "afgroedegruppe", "afgroedekategori", "priskategori") VALUES (17, 'Blanding af efterårssåede arter', 'Vintersæd til modenhed', 'vintersået blanding', 'vinterkorn blanding');
INSERT INTO "afgroede_kategori" ("afgroedekode", "afgroedenavn", "afgroedegruppe", "afgroedekategori", "priskategori") VALUES (324, 'Blomsterbrak', 'Særlige afgrødekoder i forbindelse med tilsagn eller miljøtiltag', 'brak', 'brak');
INSERT INTO "afgroede_kategori" ("afgroedekode", "afgroedenavn", "afgroedegruppe", "afgroedekategori", "priskategori") VALUES (212, 'Vårhavre, helsæd', 'Helsæd, vår', 'vårhavre', 'helsæd, vår');
INSERT INTO "afgroede_kategori" ("afgroedekode", "afgroedenavn", "afgroedegruppe", "afgroedekategori", "priskategori") VALUES (310, 'Brak, sommerslåning', 'Udyrkede arealer, vildtagre o.l.', 'brak', 'brak');
INSERT INTO "afgroede_kategori" ("afgroedekode", "afgroedenavn", "afgroedegruppe", "afgroedekategori", "priskategori") VALUES (907, 'Naturarealer, økologisk jordbrug', 'Øvrige afgrøder', '(afgrøden har ingen kategori)', 'Brak');
INSERT INTO "afgroede_kategori" ("afgroedekode", "afgroedenavn", "afgroedegruppe", "afgroedekategori", "priskategori") VALUES (404, 'Broccoli', 'Grøntsager, friland', 'kål', 'grøntsager');
INSERT INTO "afgroede_kategori" ("afgroedekode", "afgroedenavn", "afgroedegruppe", "afgroedekategori", "priskategori") VALUES (489, 'Havtorn', 'Småplanteproduktion og planteskoleplanter', '(afgrøden har ingen kategori)', 'potteplanter og stauder');
INSERT INTO "afgroede_kategori" ("afgroedekode", "afgroedenavn", "afgroedegruppe", "afgroedekategori", "priskategori") VALUES (255, 'Permanent græs, under 50% kløver/lucerne', 'Græs, permanent', '(afgrøden har ingen kategori)', 'græs, permanent');
INSERT INTO "afgroede_kategori" ("afgroedekode", "afgroedenavn", "afgroedegruppe", "afgroedekategori", "priskategori") VALUES (56, 'Vårtriticale', 'Vårsæd til modenhed', 'vårtriticale', 'vårtriticale');
INSERT INTO "afgroede_kategori" ("afgroedekode", "afgroedenavn", "afgroedegruppe", "afgroedekategori", "priskategori") VALUES (515, 'Ribs', 'Frugt og bær', '(afgrøden har ingen kategori)', 'bær');
INSERT INTO "afgroede_kategori" ("afgroedekode", "afgroedenavn", "afgroedegruppe", "afgroedekategori", "priskategori") VALUES (151, 'Kartofler, stivelses-', 'Kartofler', 'kartoffel', 'stivelseskartofler');
INSERT INTO "afgroede_kategori" ("afgroedekode", "afgroedenavn", "afgroedegruppe", "afgroedekategori", "priskategori") VALUES (418, 'Rødkål', 'Grøntsager, friland', 'kål', 'kål');
INSERT INTO "afgroede_kategori" ("afgroedekode", "afgroedenavn", "afgroedegruppe", "afgroedekategori", "priskategori") VALUES (706, 'Grønkorn af vinterbyg', 'Korn, grønkorn', 'vinterbyg', 'vinterbyg');
INSERT INTO "afgroede_kategori" ("afgroedekode", "afgroedenavn", "afgroedegruppe", "afgroedekategori", "priskategori") VALUES (407, 'Gulerod', 'Grøntsager, friland', 'gulerod', 'grøntsager');
INSERT INTO "afgroede_kategori" ("afgroedekode", "afgroedenavn", "afgroedegruppe", "afgroedekategori", "priskategori") VALUES (325, 'MFO-Blomsterbrak', 'Særlige afgrødekoder i forbindelse med tilsagn eller miljøtiltag', 'brak', 'brak');
INSERT INTO "afgroede_kategori" ("afgroedekode", "afgroedenavn", "afgroedegruppe", "afgroedekategori", "priskategori") VALUES (516, 'Stikkelsbær', 'Frugt og bær', '(afgrøden har ingen kategori)', 'bær');
INSERT INTO "afgroede_kategori" ("afgroedekode", "afgroedenavn", "afgroedegruppe", "afgroedekategori", "priskategori") VALUES (542, 'Salat (drivhus)', 'Småplanteproduktion og planteskoleplanter', 'salat', 'potteplanter og stauder');
INSERT INTO "afgroede_kategori" ("afgroedekode", "afgroedenavn", "afgroedegruppe", "afgroedekategori", "priskategori") VALUES (216, 'Silomajs', 'Helsæd, vår', 'majs', 'majs til helsæd');
INSERT INTO "afgroede_kategori" ("afgroedekode", "afgroedenavn", "afgroedegruppe", "afgroedekategori", "priskategori") VALUES (666, 'Purløgsfrø', 'Havefrø', 'løg', 'Havefrø');
INSERT INTO "afgroede_kategori" ("afgroedekode", "afgroedenavn", "afgroedegruppe", "afgroedekategori", "priskategori") VALUES (174, 'Kløvergræs til fabrik', 'Græsmarksplanter, omdrift', 'græs eller andet grøntfoder', 'græs, sædskifte');
INSERT INTO "afgroede_kategori" ("afgroedekode", "afgroedenavn", "afgroedegruppe", "afgroedekategori", "priskategori") VALUES (213, 'Blandkorn, vårsået, helsæd', 'Helsæd, vår', 'vårsået blanding', 'helsæd, vår');
INSERT INTO "afgroede_kategori" ("afgroedekode", "afgroedenavn", "afgroedegruppe", "afgroedekategori", "priskategori") VALUES (274, 'Permanent lucernegræs over 25% græs, til fabrik', 'Græs, permanent', '(afgrøden har ingen kategori)', 'græs, permanent');
INSERT INTO "afgroede_kategori" ("afgroedekode", "afgroedenavn", "afgroedegruppe", "afgroedekategori", "priskategori") VALUES (334, 'MFO-bræmme, forårsslåning', 'Særlige afgrødekoder i forbindelse med tilsagn eller miljøtiltag', 'brak', 'brak');
INSERT INTO "afgroede_kategori" ("afgroedekode", "afgroedenavn", "afgroedegruppe", "afgroedekategori", "priskategori") VALUES (540, 'Tomater', 'Småplanteproduktion og planteskoleplanter', 'tomat', 'potteplanter og stauder');
INSERT INTO "afgroede_kategori" ("afgroedekode", "afgroedenavn", "afgroedegruppe", "afgroedekategori", "priskategori") VALUES (598, 'Sorrel', 'Energiafgrøder og anden særlig produktion', 'sorrel', 'Energiafgrøder');
INSERT INTO "afgroede_kategori" ("afgroedekode", "afgroedenavn", "afgroedegruppe", "afgroedekategori", "priskategori") VALUES (223, 'Vintertriticale, helsæd', 'Helsæd, vinter', 'vintertriticale', 'vintertriticale');
INSERT INTO "afgroede_kategori" ("afgroedekode", "afgroedenavn", "afgroedegruppe", "afgroedekategori", "priskategori") VALUES (526, 'Hyld', 'Frugt og bær', '(afgrøden har ingen kategori)', 'bær');
INSERT INTO "afgroede_kategori" ("afgroedekode", "afgroedenavn", "afgroedegruppe", "afgroedekategori", "priskategori") VALUES (36, 'Bælgsæd, andre typer til modenhed blanding', 'Oliefrø og Bælgsæd', 'vårsået blanding', 'Bælgsæd');
INSERT INTO "afgroede_kategori" ("afgroedekode", "afgroedenavn", "afgroedegruppe", "afgroedekategori", "priskategori") VALUES (287, 'Græs til udegrise, permanent', 'Græs, permanent', '(afgrøden har ingen kategori)', 'græs, permanent');
INSERT INTO "afgroede_kategori" ("afgroedekode", "afgroedenavn", "afgroedegruppe", "afgroedekategori", "priskategori") VALUES (221, 'Vinterhvede, helsæd', 'Helsæd, vinter', 'vinterhvede', 'vinterhvede');
INSERT INTO "afgroede_kategori" ("afgroedekode", "afgroedenavn", "afgroedegruppe", "afgroedekategori", "priskategori") VALUES (524, 'Sødkirsebær uden undervækst af græs', 'Frugt og bær', '(afgrøden har ingen kategori)', 'bær');
INSERT INTO "afgroede_kategori" ("afgroedekode", "afgroedenavn", "afgroedegruppe", "afgroedekategori", "priskategori") VALUES (430, 'Bladpersille', 'Grøntsager, friland', 'persille', 'krydderurter');
INSERT INTO "afgroede_kategori" ("afgroedekode", "afgroedenavn", "afgroedegruppe", "afgroedekategori", "priskategori") VALUES (102, 'Rajgræsfrø, alm. 1. år, efterårsudlagt', 'Frøgræs', 'efterårssået rajgræsfrø', 'Frøgræs');
INSERT INTO "afgroede_kategori" ("afgroedekode", "afgroedenavn", "afgroedegruppe", "afgroedekategori", "priskategori") VALUES (312, '20-årig udtagning', 'Særlige afgrødekoder i forbindelse med tilsagn eller miljøtiltag', 'brak', 'brak');
INSERT INTO "afgroede_kategori" ("afgroedekode", "afgroedenavn", "afgroedegruppe", "afgroedekategori", "priskategori") VALUES (277, 'Kløver til fabrik', 'Kløver og lucerne i renbestand', 'kløver', 'kløver');
INSERT INTO "afgroede_kategori" ("afgroedekode", "afgroedenavn", "afgroedegruppe", "afgroedekategori", "priskategori") VALUES (594, 'El', 'Energiafgrøder og anden særlig produktion', '(afgrøden har ingen kategori)', 'Energiafgrøder');
INSERT INTO "afgroede_kategori" ("afgroedekode", "afgroedenavn", "afgroedegruppe", "afgroedekategori", "priskategori") VALUES (494, 'Japan kvæde', 'Småplanteproduktion og planteskoleplanter', '(afgrøden har ingen kategori)', 'potteplanter og stauder');
INSERT INTO "afgroede_kategori" ("afgroedekode", "afgroedenavn", "afgroedegruppe", "afgroedekategori", "priskategori") VALUES (533, 'Rønnebær', 'Frugt og bær', '(afgrøden har ingen kategori)', 'frugt');
INSERT INTO "afgroede_kategori" ("afgroedekode", "afgroedenavn", "afgroedegruppe", "afgroedekategori", "priskategori") VALUES (118, 'Rajsvingelfrø, efterårsudlagt', 'Frøgræs', 'efterårssået rajsvingelfrø', 'Frøgræs');
INSERT INTO "afgroede_kategori" ("afgroedekode", "afgroedenavn", "afgroedegruppe", "afgroedekategori", "priskategori") VALUES (499, 'Lukket system', 'Småplanteproduktion og planteskoleplanter', '(afgrøden har ingen kategori)', 'potteplanter og stauder');
INSERT INTO "afgroede_kategori" ("afgroedekode", "afgroedenavn", "afgroedegruppe", "afgroedekategori", "priskategori") VALUES (662, 'Majroefrø', 'Havefrø', 'ager-kål', 'Havefrø');
INSERT INTO "afgroede_kategori" ("afgroedekode", "afgroedenavn", "afgroedegruppe", "afgroedekategori", "priskategori") VALUES (284, 'Græs med vikke og andre bælgplanter, under 50 % bælgpl.', 'Græsmarksplanter, omdrift', 'græs eller andet grøntfoder', 'græs, sædskifte');
INSERT INTO "afgroede_kategori" ("afgroedekode", "afgroedenavn", "afgroedegruppe", "afgroedekategori", "priskategori") VALUES (317, 'Vådområder med udtagning', 'Særlige afgrødekoder i forbindelse med tilsagn eller miljøtiltag', 'brak', 'brak');
INSERT INTO "afgroede_kategori" ("afgroedekode", "afgroedenavn", "afgroedegruppe", "afgroedekategori", "priskategori") VALUES (111, 'Svingelfrø, strand-', 'Frøgræs', 'svingelfrø', 'Frøgræs');
INSERT INTO "afgroede_kategori" ("afgroedekode", "afgroedenavn", "afgroedegruppe", "afgroedekategori", "priskategori") VALUES (342, 'Bestøverbrak', 'Særlige afgrødekoder i forbindelse med tilsagn eller miljøtiltag', 'brak', 'brak');
INSERT INTO "afgroede_kategori" ("afgroedekode", "afgroedenavn", "afgroedegruppe", "afgroedekategori", "priskategori") VALUES (16, 'Vintertriticale', 'Vintersæd til modenhed', 'vintertriticale', 'vintertriticale');
INSERT INTO "afgroede_kategori" ("afgroedekode", "afgroedenavn", "afgroedegruppe", "afgroedekategori", "priskategori") VALUES (702, 'Grønkron af vårhvede', 'Korn, grønkorn', 'vårhvede', 'hvede');
INSERT INTO "afgroede_kategori" ("afgroedekode", "afgroedenavn", "afgroedegruppe", "afgroedekategori", "priskategori") VALUES (488, 'Hønsegård, permanent græs', 'Græs, permanent', '(afgrøden har ingen kategori)', 'græs, permanent');
INSERT INTO "afgroede_kategori" ("afgroedekode", "afgroedenavn", "afgroedegruppe", "afgroedekategori", "priskategori") VALUES (123, 'Valmuefrø', 'Frøgræs', 'valmue', 'Frøgræs');
INSERT INTO "afgroede_kategori" ("afgroedekode", "afgroedenavn", "afgroedegruppe", "afgroedekategori", "priskategori") VALUES (126, 'Blanding af markfrø til udsæd', 'Frøgræs', 'vårsået blanding', 'Frøgræs');
INSERT INTO "afgroede_kategori" ("afgroedekode", "afgroedenavn", "afgroedegruppe", "afgroedekategori", "priskategori") VALUES (326, 'Ej landbrug, MSO, omlagt fra permanent græs', 'Særlige afgrødekoder i forbindelse med tilsagn eller miljøtiltag', '(afgrøden har ingen kategori)', 'brak');
INSERT INTO "afgroede_kategori" ("afgroedekode", "afgroedenavn", "afgroedegruppe", "afgroedekategori", "priskategori") VALUES (492, 'Tyttebær ', 'Småplanteproduktion og planteskoleplanter', '(afgrøden har ingen kategori)', 'potteplanter og stauder');
INSERT INTO "afgroede_kategori" ("afgroedekode", "afgroedenavn", "afgroedegruppe", "afgroedekategori", "priskategori") VALUES (655, 'Radisefrø (inklusiv olieræddikefrø)', 'Havefrø', 'radise', 'Havefrø');
INSERT INTO "afgroede_kategori" ("afgroedekode", "afgroedenavn", "afgroedegruppe", "afgroedekategori", "priskategori") VALUES (544, 'Snitblomster og snitgrønt', 'Småplanteproduktion og planteskoleplanter', 'planteskolekultur', 'potteplanter og stauder');
INSERT INTO "afgroede_kategori" ("afgroedekode", "afgroedenavn", "afgroedegruppe", "afgroedekategori", "priskategori") VALUES (41, 'Spindhør', 'Hør og Hamp', 'hør', 'oliefrø');
INSERT INTO "afgroede_kategori" ("afgroedekode", "afgroedenavn", "afgroedegruppe", "afgroedekategori", "priskategori") VALUES (224, 'Blandkorn, efterårssået helsæd', 'Helsæd, vinter', 'vintersået blanding', 'helsæd, vinter');
INSERT INTO "afgroede_kategori" ("afgroedekode", "afgroedenavn", "afgroedegruppe", "afgroedekategori", "priskategori") VALUES (704, 'Grønkorn af vårrug', 'Korn, grønkorn', 'vårrug', 'rug');
INSERT INTO "afgroede_kategori" ("afgroedekode", "afgroedenavn", "afgroedegruppe", "afgroedekategori", "priskategori") VALUES (586, 'Offentlig skovrejsning', 'Trækulturer', '(afgrøden har ingen kategori)', 'skovdrift');
INSERT INTO "afgroede_kategori" ("afgroedekode", "afgroedenavn", "afgroedegruppe", "afgroedekategori", "priskategori") VALUES (53, 'Boghvede', 'Hør og Hamp', 'boghvede', 'oliefrø');
INSERT INTO "afgroede_kategori" ("afgroedekode", "afgroedenavn", "afgroedegruppe", "afgroedekategori", "priskategori") VALUES (32, 'Sødlupin', 'Oliefrø og Bælgsæd', 'lupin', 'Bælgsæd');
INSERT INTO "afgroede_kategori" ("afgroedekode", "afgroedenavn", "afgroedegruppe", "afgroedekategori", "priskategori") VALUES (413, 'Rodpersille', 'Grøntsager, friland', 'persille', 'grøntsager');
INSERT INTO "afgroede_kategori" ("afgroedekode", "afgroedenavn", "afgroedegruppe", "afgroedekategori", "priskategori") VALUES (336, 'MFO-bræmme, permanent græs, sommerslåning ', 'Særlige afgrødekoder i forbindelse med tilsagn eller miljøtiltag', '(afgrøden har ingen kategori)', 'græs, permanent');
INSERT INTO "afgroede_kategori" ("afgroedekode", "afgroedenavn", "afgroedegruppe", "afgroedekategori", "priskategori") VALUES (318, 'MVJ ej udtagning, ej landbrugsareal', 'Særlige afgrødekoder i forbindelse med tilsagn eller miljøtiltag', '(afgrøden har ingen kategori)', 'brak');
INSERT INTO "afgroede_kategori" ("afgroedekode", "afgroedenavn", "afgroedegruppe", "afgroedekategori", "priskategori") VALUES (606, 'MFO - Poppel (100-400 andre træer pr. ha)', 'Energiafgrøder og anden særlig produktion', '(afgrøden har ingen kategori)', 'Energiafgrøder');
INSERT INTO "afgroede_kategori" ("afgroedekode", "afgroedenavn", "afgroedegruppe", "afgroedekategori", "priskategori") VALUES (247, 'Miljøgræs MVJ-tilsagn (0 N), omdrift', 'Arealer med tilsagn under miljøordningerne', 'græs eller andet grøntfoder', 'græs, sædskifte');
INSERT INTO "afgroede_kategori" ("afgroedekode", "afgroedenavn", "afgroedegruppe", "afgroedekategori", "priskategori") VALUES (260, 'Græs med kløver/lucerne, under 50 % bælgpl. (omdrift)', 'Græsmarksplanter, omdrift', 'græs eller andet grøntfoder', 'græs, sædskifte');
INSERT INTO "afgroede_kategori" ("afgroedekode", "afgroedenavn", "afgroedegruppe", "afgroedekategori", "priskategori") VALUES (308, 'MFO-brak, sommerslåning', 'Udyrkede arealer, vildtagre o.l.', 'brak', 'brak');
INSERT INTO "afgroede_kategori" ("afgroedekode", "afgroedenavn", "afgroedegruppe", "afgroedekategori", "priskategori") VALUES (423, 'Sukkermajs', 'Grøntsager, friland', 'majs', 'grøntsager');
INSERT INTO "afgroede_kategori" ("afgroedekode", "afgroedenavn", "afgroedegruppe", "afgroedekategori", "priskategori") VALUES (313, '20-årig udtagning af agerjord med frivillig skovrejsning', 'Særlige afgrødekoder i forbindelse med tilsagn eller miljøtiltag', '(afgrøden har ingen kategori)', 'brak');
INSERT INTO "afgroede_kategori" ("afgroedekode", "afgroedenavn", "afgroedegruppe", "afgroedekategori", "priskategori") VALUES (150, 'Kartofler, lægge- (egen opformering)', 'Kartofler', 'kartoffel', 'læggekartofler');
INSERT INTO "afgroede_kategori" ("afgroedekode", "afgroedenavn", "afgroedegruppe", "afgroedekategori", "priskategori") VALUES (656, 'Bladbedefrø, rødbedefrø', 'Havefrø', 'beder', 'Havefrø');
INSERT INTO "afgroede_kategori" ("afgroedekode", "afgroedenavn", "afgroedegruppe", "afgroedekategori", "priskategori") VALUES (593, 'Poppel (0-100 andre træer pr. ha)', 'Energiafgrøder og anden særlig produktion', '(afgrøden har ingen kategori)', 'Energiafgrøder');
INSERT INTO "afgroede_kategori" ("afgroedekode", "afgroedenavn", "afgroedegruppe", "afgroedekategori", "priskategori") VALUES (421, 'Savoykål, spidskål', 'Grøntsager, friland', 'kål', 'kål');
INSERT INTO "afgroede_kategori" ("afgroedekode", "afgroedenavn", "afgroedegruppe", "afgroedekategori", "priskategori") VALUES (411, 'Løg', 'Grøntsager, friland', 'løg', 'grøntsager');
INSERT INTO "afgroede_kategori" ("afgroedekode", "afgroedenavn", "afgroedegruppe", "afgroedekategori", "priskategori") VALUES (24, 'Solsikke', 'Oliefrø og Bælgsæd', 'solsikke', 'oliefrø');
INSERT INTO "afgroede_kategori" ("afgroedekode", "afgroedenavn", "afgroedegruppe", "afgroedekategori", "priskategori") VALUES (429, 'Jordskokker, konsum', 'Grøntsager, friland', 'solsikke', 'grøntsager');
INSERT INTO "afgroede_kategori" ("afgroedekode", "afgroedenavn", "afgroedegruppe", "afgroedekategori", "priskategori") VALUES (25, 'Sojabønner', 'Oliefrø og Bælgsæd', 'soja', 'oliefrø');
INSERT INTO "afgroede_kategori" ("afgroedekode", "afgroedenavn", "afgroedegruppe", "afgroedekategori", "priskategori") VALUES (495, 'Morbær ', 'Småplanteproduktion og planteskoleplanter', '(afgrøden har ingen kategori)', 'potteplanter og stauder');
INSERT INTO "afgroede_kategori" ("afgroedekode", "afgroedenavn", "afgroedegruppe", "afgroedekategori", "priskategori") VALUES (122, 'Kommenfrø', 'Frøgræs', 'kommen', 'Frøgræs');
INSERT INTO "afgroede_kategori" ("afgroedekode", "afgroedenavn", "afgroedegruppe", "afgroedekategori", "priskategori") VALUES (154, 'Kartofler, spise- (proces, skrællet kogte)', 'Kartofler', 'kartoffel', 'processkartofler');
INSERT INTO "afgroede_kategori" ("afgroedekode", "afgroedenavn", "afgroedegruppe", "afgroedekategori", "priskategori") VALUES (570, 'Humle', 'Frugt og bær', '(afgrøden har ingen kategori)', 'bær');
INSERT INTO "afgroede_kategori" ("afgroedekode", "afgroedenavn", "afgroedegruppe", "afgroedekategori", "priskategori") VALUES (234, 'Korn og bælgsæd, grønkorn, under 50% bælgsæd', 'Korn, grønkorn', 'vårsået blanding', 'vårkorn blanding');
INSERT INTO "afgroede_kategori" ("afgroedekode", "afgroedenavn", "afgroedegruppe", "afgroedekategori", "priskategori") VALUES (657, 'Grønkålfrø', 'Havefrø', 'kål', 'Havefrø');
INSERT INTO "afgroede_kategori" ("afgroedekode", "afgroedenavn", "afgroedegruppe", "afgroedekategori", "priskategori") VALUES (434, 'Grøntsager, andre (friland)', 'Grøntsager, friland', 'planteskolekultur', 'grøntsager');
INSERT INTO "afgroede_kategori" ("afgroedekode", "afgroedenavn", "afgroedegruppe", "afgroedekategori", "priskategori") VALUES (211, 'Vårhvede, helsæd', 'Helsæd, vår', 'vårhvede', 'helsæd, vår');
INSERT INTO "afgroede_kategori" ("afgroedekode", "afgroedenavn", "afgroedegruppe", "afgroedekategori", "priskategori") VALUES (316, '20-årig Udtagning med fastholdelse, ej landbrugsareal', 'Særlige afgrødekoder i forbindelse med tilsagn eller miljøtiltag', '(afgrøden har ingen kategori)', 'brak');
INSERT INTO "afgroede_kategori" ("afgroedekode", "afgroedenavn", "afgroedegruppe", "afgroedekategori", "priskategori") VALUES (403, 'Blomkål', 'Grøntsager, friland', 'kål', 'kål');
INSERT INTO "afgroede_kategori" ("afgroedekode", "afgroedenavn", "afgroedegruppe", "afgroedekategori", "priskategori") VALUES (256, 'Permanent kløvergræs, over 50% kløver/lucerne', 'Græs, permanent', '(afgrøden har ingen kategori)', 'græs, permanent');
INSERT INTO "afgroede_kategori" ("afgroedekode", "afgroedenavn", "afgroedegruppe", "afgroedekategori", "priskategori") VALUES (580, 'Anden skovdrift', 'Trækulturer', '(afgrøden har ingen kategori)', 'skovdrift');
INSERT INTO "afgroede_kategori" ("afgroedekode", "afgroedenavn", "afgroedegruppe", "afgroedekategori", "priskategori") VALUES (654, 'Rucolafrø', 'Havefrø', 'rucola', 'Havefrø');
INSERT INTO "afgroede_kategori" ("afgroedekode", "afgroedenavn", "afgroedegruppe", "afgroedekategori", "priskategori") VALUES (530, 'Vindrue', 'Frugt og bær', '(afgrøden har ingen kategori)', 'frugt');
INSERT INTO "afgroede_kategori" ("afgroedekode", "afgroedenavn", "afgroedegruppe", "afgroedekategori", "priskategori") VALUES (422, 'Spinat', 'Grøntsager, friland', 'spinat', 'grøntsager');
INSERT INTO "afgroede_kategori" ("afgroedekode", "afgroedenavn", "afgroedegruppe", "afgroedekategori", "priskategori") VALUES (536, 'Spisedruer', 'Frugt og bær', '(afgrøden har ingen kategori)', 'frugt');
INSERT INTO "afgroede_kategori" ("afgroedekode", "afgroedenavn", "afgroedegruppe", "afgroedekategori", "priskategori") VALUES (449, 'Medicinpl., stauder ', 'Medicinplanter', 'planteskolekultur', 'potteplanter og stauder');
INSERT INTO "afgroede_kategori" ("afgroedekode", "afgroedenavn", "afgroedegruppe", "afgroedekategori", "priskategori") VALUES (264, 'Græs og kløvergræs uden norm, under 50 % kløver (omdrift)', 'Græsmarksplanter, omdrift', 'græs eller andet grøntfoder', 'græs, sædskifte');
INSERT INTO "afgroede_kategori" ("afgroedekode", "afgroedenavn", "afgroedegruppe", "afgroedekategori", "priskategori") VALUES (520, 'Surkirsebær uden undervækst af græs', 'Frugt og bær', '(afgrøden har ingen kategori)', 'bær');
INSERT INTO "afgroede_kategori" ("afgroedekode", "afgroedenavn", "afgroedegruppe", "afgroedekategori", "priskategori") VALUES (215, 'Ærtehelsæd', 'Helsæd, vår', 'ært', 'helsæd, vår');
INSERT INTO "afgroede_kategori" ("afgroedekode", "afgroedenavn", "afgroedegruppe", "afgroedekategori", "priskategori") VALUES (653, 'Karsefrø', 'Havefrø', 'karse', 'Havefrø');
INSERT INTO "afgroede_kategori" ("afgroedekode", "afgroedenavn", "afgroedegruppe", "afgroedekategori", "priskategori") VALUES (55, 'Vårrug', 'Vårsæd til modenhed', 'vårrug', 'vårsæd til modenhed');
INSERT INTO "afgroede_kategori" ("afgroedekode", "afgroedenavn", "afgroedegruppe", "afgroedekategori", "priskategori") VALUES (23, 'Rybs', 'Oliefrø og Bælgsæd', 'ager-kål', 'oliefrø');
INSERT INTO "afgroede_kategori" ("afgroedekode", "afgroedenavn", "afgroedegruppe", "afgroedekategori", "priskategori") VALUES (270, 'Græs til udegrise, omdrift', 'Græsmarksplanter, omdrift', 'græs eller andet grøntfoder', 'græs, sædskifte');
INSERT INTO "afgroede_kategori" ("afgroedekode", "afgroedenavn", "afgroedegruppe", "afgroedekategori", "priskategori") VALUES (486, 'Hønsegård uden plantedække', 'Udyrkede arealer, vildtagre o.l.', 'brak', 'brak');

ALTER TABLE "afgroede_kategori"
    ADD CONSTRAINT "afgroede_kategori_pkey" PRIMARY KEY ("afgroedekode");

ALTER TABLE "afgroede_kategori"
    ADD CONSTRAINT fk_afgroede_kategori_afgroedekode FOREIGN KEY (priskategori) REFERENCES afgroede_pris(priskategori);

    
-- Patch  2022-09-16: Model q_agriculture slut --
 
/* 
-----------------------------------------------------------------------
--   Patch 2022-09-20: Model q_building_perimeter
-----------------------------------------------------------------------

     search_path skal værdisættes, således at navnet på administrations schema er første parameter. 
     Hvis der ikke er ændret på standard navn for administrationsskema "fdc_admin"
     skal der ikke rettes i linjen

*/

SET search_path = fdc_admin, public;
--                *********

-- NIX PILLE VED RESTEN....................................................................................................

DELETE FROM parametre WHERE name = 'Perimeter cut-off (%)';
INSERT INTO fdc_admin.parametre (name, parent, value, type, minval, maxval, lookupvalues, "default", explanation, sort, checkable) VALUES ('Perimeter cut-off (%)', 'Generelle modelværdier', '5.0', 'R', '0.0', '100.0', '1.0', '', 'Her angives minimum brøkdel af oversvømmet perimeter i procent, før bygning medtages i skadeberegning.', 17, ' ');

DELETE FROM parametre WHERE parent = 'q_build_peri' OR name = 'q_build_peri' OR "default" = 'q_build_peri';

INSERT INTO parametre (name, parent, value, type, minval, maxval, lookupvalues, "default", explanation, sort, checkable) VALUES ('Skadeberegninger perimeter, Bygninger', 'Bygninger', '', 'T', '', '', '', 'q_build_peri', 'Skadeberegning for bygninger baseret på perimeter', 11, 'T');
INSERT INTO parametre (name, parent, value, type, minval, maxval, lookupvalues, "default", explanation, sort, checkable) VALUES ('f_pkey_q_build_peri'                  , 'q_build_peri', 'objectid'                      , 'T', '', '', '', '', 'Name of primary keyfield for query', 10, ' ');
INSERT INTO parametre (name, parent, value, type, minval, maxval, lookupvalues, "default", explanation, sort, checkable) VALUES ('f_geom_q_build_peri'                  , 'q_build_peri', 'geom'                          , 'T', '', '', '', '', 'Field name for geometry column', 10, ' ');
INSERT INTO parametre (name, parent, value, type, minval, maxval, lookupvalues, "default", explanation, sort, checkable) VALUES ('f_damage_present_q_build_peri'        , 'q_build_peri', 'skadebeloeb_nutid_kr'          , 'T', '', '', '', '', '', 1, 'T');
INSERT INTO parametre (name, parent, value, type, minval, maxval, lookupvalues, "default", explanation, sort, checkable) VALUES ('f_damage_future_q_build_peri'         , 'q_build_peri', 'skadebeloeb_fremtid_kr'        , 'T', '', '', '', '', '', 1, 'T');
INSERT INTO parametre (name, parent, value, type, minval, maxval, lookupvalues, "default", explanation, sort, checkable) VALUES ('f_damage_cellar_present_q_build_peri' , 'q_build_peri', 'skadebeloeb_kaelder_nutid_kr'  , 'T', '', '', '', '', '', 1, 'T');
INSERT INTO parametre (name, parent, value, type, minval, maxval, lookupvalues, "default", explanation, sort, checkable) VALUES ('f_damage_cellar_future_q_build_peri'  , 'q_build_peri', 'skadebeloeb_kaelder_fremtid_kr', 'T', '', '', '', '', '', 1, 'T');
INSERT INTO parametre (name, parent, value, type, minval, maxval, lookupvalues, "default", explanation, sort, checkable) VALUES ('f_loss_present_q_build_peri'          , 'q_build_peri', 'vaerditab_nutid_kr'            , 'T', '', '', '', '', '', 1, 'T');
INSERT INTO parametre (name, parent, value, type, minval, maxval, lookupvalues, "default", explanation, sort, checkable) VALUES ('f_loss_future_q_build_peri'           , 'q_build_peri', 'vaerditab_fremtid_kr'          , 'T', '', '', '', '', '', 1, 'T');
INSERT INTO parametre (name, parent, value, type, minval, maxval, lookupvalues, "default", explanation, sort, checkable) VALUES ('f_risk_q_build_peri'                  , 'q_build_peri', 'risiko_kr'                     , 'T', '', '', '', '', '', 1, 'T');
INSERT INTO parametre (name, parent, value, type, minval, maxval, lookupvalues, "default", explanation, sort, checkable) VALUES ('q_build_peri', 'Queries', 
'
SELECT
    b.*,
    d.{f_category_t_damage} AS skade_kategori,
    d.{f_type_t_damage} AS skade_type,
	''{Skadeberegning for kælder}'' AS kaelder_beregning,
    {Værditab, skaderamte bygninger (%)}::NUMERIC(12,2) as tab_procent,
    k.{f_sqmprice_t_sqmprice}::NUMERIC(12,2) as kvm_pris_kr,
    st_area(b.{f_geom_t_building})::NUMERIC(12,2) AS areal_byg_m2,
    st_perimeter(b.{f_geom_t_building})::NUMERIC(12,2) AS perimeter_byg_m,
    v.*,
    n.*,
    f.*,
    r.*
    FROM {t_building} b
    LEFT JOIN {t_build_usage} u on b.{f_usage_code_t_building} = u.{f_pkey_t_build_usage}
    LEFT JOIN {t_damage} d on u.{f_category_t_build_usage} = d.{f_category_t_damage} AND d.{f_type_t_damage} = ''{Skadetype}''   
    LEFT JOIN {t_sqmprice} k on (b.{f_muncode_t_building} = k.{f_muncode_t_sqmprice}),
    LATERAL (
        SELECT 
            ST_perimeter({f_geom_Oversvømmelsesmodel, nutid}) / 4.0 AS vp_side_laengde_m
        FROM {Oversvømmelsesmodel, nutid} LIMIT 1
    ) v, 
    LATERAL (
        SELECT
            COUNT (*) AS cnt_oversvoem_nutid,            
            100.0 * COUNT(*) * v.vp_side_laengde_m / ST_Perimeter(b.{f_geom_t_building}) AS oversvoem_peri_nutid_pct,            
            COALESCE(SUM(st_area(st_intersection(b.{f_geom_t_building},{f_geom_Oversvømmelsesmodel, nutid}))),0)::NUMERIC(12,2) AS areal_oversvoem_nutid_m2,
            COALESCE(MIN({f_depth_Oversvømmelsesmodel, nutid}) * 100.00,0)::NUMERIC(12,2) AS min_vanddybde_nutid_cm,
            COALESCE(MAX({f_depth_Oversvømmelsesmodel, nutid}) * 100.00,0)::NUMERIC(12,2) AS max_vanddybde_nutid_cm,
            COALESCE(AVG({f_depth_Oversvømmelsesmodel, nutid}) * 100.00,0)::NUMERIC(12,2) AS avg_vanddybde_nutid_cm,
            CASE WHEN COUNT(*) > 0 AND COUNT(*) * v.vp_side_laengde_m / ST_Perimeter(b.{f_geom_t_building}) >= {Perimeter cut-off (%)}/100.0 THEN d.b0 + st_area(b.{f_geom_t_building}) * (d.b1 * ln(GREATEST(MAX({f_depth_Oversvømmelsesmodel, nutid})*100.00, 1.0)) + d.b2) ELSE 0 END::NUMERIC(12,2) AS {f_damage_present_q_build_peri},
            CASE WHEN COUNT(*) > 0 AND COUNT(*) * v.vp_side_laengde_m / ST_Perimeter(b.{f_geom_t_building}) >= {Perimeter cut-off (%)}/100.0 AND ''{Skadeberegning for kælder}'' = ''Medtages'' THEN COALESCE(b.{f_cellar_area_t_building},0.0) * d.c0 ELSE 0 END::NUMERIC(12,2) as {f_damage_cellar_present_q_build_peri},
            CASE WHEN COUNT(*) > 0 THEN k.kvm_pris * st_area(b.{f_geom_t_building}) * {Værditab, skaderamte bygninger (%)}/100.0 ELSE 0 END::NUMERIC(12,2) as {f_loss_present_q_build_peri}             
        FROM {Oversvømmelsesmodel, nutid} WHERE st_intersects(b.{f_geom_t_building},{f_geom_Oversvømmelsesmodel, nutid}) AND {f_depth_Oversvømmelsesmodel, nutid} >= {Minimum vanddybde (meter)}
    ) n,
    LATERAL (
        SELECT
            COUNT (*) AS cnt_oversvoem_fremtid,
            100.0 * COUNT(*) * v.vp_side_laengde_m / ST_Perimeter(b.{f_geom_t_building}) AS oversvoem_peri_fremtid_pct,            
            COALESCE(SUM(st_area(st_intersection(b.{f_geom_t_building},{f_geom_Oversvømmelsesmodel, fremtid}))),0)::NUMERIC(12,2) AS areal_oversvoem_fremtid_m2,
            COALESCE(MIN({f_depth_Oversvømmelsesmodel, fremtid}) * 100.00,0)::NUMERIC(12,2) AS min_vanddybde_fremtid_cm,
            COALESCE(MAX({f_depth_Oversvømmelsesmodel, fremtid}) * 100.00,0)::NUMERIC(12,2) AS max_vanddybde_fremtid_cm,
            COALESCE(AVG({f_depth_Oversvømmelsesmodel, fremtid}) * 100.00,0)::NUMERIC(12,2) AS avg_vanddybde_fremtid_cm,
            CASE WHEN COUNT (*) > 0 AND COUNT(*) * v.vp_side_laengde_m / ST_Perimeter(b.{f_geom_t_building}) >= {Perimeter cut-off (%)}/100.0 THEN d.b0 + st_area(b.{f_geom_t_building}) * (d.b1 * ln(GREATEST(MAX({f_depth_Oversvømmelsesmodel, fremtid})*100.00, 1.0)) + d.b2) ELSE 0 END::NUMERIC(12,2) AS {f_damage_future_q_build_peri},
            CASE WHEN COUNT (*) > 0 AND COUNT(*) * v.vp_side_laengde_m / ST_Perimeter(b.{f_geom_t_building}) >= {Perimeter cut-off (%)}/100.0 AND ''{Skadeberegning for kælder}'' = ''Medtages'' THEN COALESCE(b.{f_cellar_area_t_building},0.0) * d.c0 ELSE 0 END::NUMERIC(12,2) as {f_damage_cellar_future_q_build_peri},
            CASE WHEN COUNT (*) > 0 THEN k.kvm_pris * st_area(b.{f_geom_t_building}) * {Værditab, skaderamte bygninger (%)}/100.0 ELSE 0 END::NUMERIC(12,2) as {f_loss_future_q_build_peri}                
        FROM {Oversvømmelsesmodel, fremtid} WHERE st_intersects(b.{f_geom_t_building},{f_geom_Oversvømmelsesmodel, fremtid}) AND {f_depth_Oversvømmelsesmodel, fremtid} >= {Minimum vanddybde (meter)}
    ) f,
    LATERAL (
        SELECT
          ''{Medtag i risikoberegninger}'' AS risiko_beregning,
		  {Returperiode, antal år} AS retur_periode,
          ((0.219058829 * CASE
          WHEN ''{Medtag i risikoberegninger}'' = ''Intet (0 kr.)'' THEN 0.0
          WHEN ''{Medtag i risikoberegninger}'' = ''Skadebeløb'' THEN n.{f_damage_present_q_build_peri} + n.{f_damage_cellar_present_q_build_peri}
          WHEN ''{Medtag i risikoberegninger}'' = ''Værditab'' THEN n.{f_loss_present_q_build_peri}
          WHEN ''{Medtag i risikoberegninger}'' = ''Skadebeløb og værditab'' THEN n.{f_damage_present_q_build_peri} + n.{f_damage_cellar_present_q_build_peri} + n.{f_loss_present_q_build_peri} 
          END + 
          0.089925625 * CASE
          WHEN ''{Medtag i risikoberegninger}'' = ''Intet (0 kr.)'' THEN 0.0
          WHEN ''{Medtag i risikoberegninger}'' = ''Skadebeløb'' THEN f.{f_damage_future_q_build_peri} + f.{f_damage_cellar_future_q_build_peri}
          WHEN ''{Medtag i risikoberegninger}'' = ''Værditab'' THEN f.{f_loss_future_q_build_peri}
          WHEN ''{Medtag i risikoberegninger}'' = ''Skadebeløb og værditab'' THEN f.{f_damage_future_q_build_peri} + f.{f_damage_cellar_future_q_build_peri} + f.{f_loss_future_q_build_peri} 
          END)/{Returperiode, antal år})::NUMERIC(12,2) AS {f_risk_q_build_peri},
          '''' AS omraade
    ) r
    WHERE f.cnt_oversvoem_fremtid > 0 OR n.cnt_oversvoem_nutid > 0', 'P', '', '', '', '', 'SQL template for buildings new model ', 8, ' ');

--   Patch 2022-09-20: Model q_building_peri slut

/*
-----------------------------------------------------------------------
--   Patch 2022-10-14 Model q_human_health with perimeter
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
    v.*,
    n.*,
    f.*,
    h.*,
    r.*
    FROM {t_building} b,
    LATERAL (
        SELECT 
            ST_perimeter({f_geom_Oversvømmelsesmodel, nutid}) / 4.0 AS vp_side_laengde_m FROM {Oversvømmelsesmodel, nutid} LIMIT 1
    ) v, 
    LATERAL (
        SELECT
            COUNT (*) AS cnt_oversvoem_nutid,
            100.0 * COUNT(*) * v.vp_side_laengde_m / ST_Perimeter(b.{f_geom_t_building}) AS oversvoem_peri_nutid_pct,            
            COALESCE((SUM(st_area(st_intersection(b.{f_geom_t_building},{f_geom_Oversvømmelsesmodel, nutid})))),0)::NUMERIC(12,2) AS areal_oversvoem_nutid_m2,
            COALESCE((MIN({f_depth_Oversvømmelsesmodel, nutid}) * 100.00),0)::NUMERIC(12,2) AS min_vanddybde_nutid_cm,
            COALESCE((MAX({f_depth_Oversvømmelsesmodel, nutid}) * 100.00),0)::NUMERIC(12,2) AS max_vanddybde_nutid_cm,
            COALESCE((AVG({f_depth_Oversvømmelsesmodel, nutid}) * 100.00),0)::NUMERIC(12,2) AS avg_vanddybde_nutid_cm
        FROM {Oversvømmelsesmodel, nutid} WHERE st_intersects(b.{f_geom_t_building},{f_geom_Oversvømmelsesmodel, nutid}) AND {f_depth_Oversvømmelsesmodel, nutid} >= {Minimum vanddybde (meter)}
    ) n,
    LATERAL (
        SELECT
            COUNT (*) AS cnt_oversvoem_fremtid,
            100.0 * COUNT(*) * v.vp_side_laengde_m / ST_Perimeter(b.{f_geom_t_building}) AS oversvoem_peri_fremtid_pct,            
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
            CASE WHEN n.cnt_oversvoem_nutid > 0 AND n.oversvoem_peri_nutid_pct >= {Perimeter cut-off (%)} THEN COUNT(*) FILTER (WHERE {f_age_t_human_health} BETWEEN 18 AND 70) * (138 * 301) ELSE 0 END::integer AS arbejdstid_nutid_kr,
            CASE WHEN n.cnt_oversvoem_nutid > 0 AND n.oversvoem_peri_nutid_pct >= {Perimeter cut-off (%)} THEN COUNT(*) FILTER (WHERE {f_age_t_human_health} BETWEEN 18 AND 70) * (23  * 301) ELSE 0 END::integer AS rejsetid_nutid_kr,
            CASE WHEN n.cnt_oversvoem_nutid > 0 AND n.oversvoem_peri_nutid_pct >= {Perimeter cut-off (%)} THEN COUNT(*) FILTER (WHERE {f_age_t_human_health} BETWEEN 18 AND 70) * (64  * 301) ELSE 0 END::integer AS sygetimer_nutid_kr, 
            CASE WHEN n.cnt_oversvoem_nutid > 0 AND n.oversvoem_peri_nutid_pct >= {Perimeter cut-off (%)} THEN COUNT(*) FILTER (WHERE {f_age_t_human_health} BETWEEN 18 AND 70) * (26  * 301) ELSE 0 END::integer AS ferietimer_nutid_kr, 
            CASE WHEN f.cnt_oversvoem_fremtid > 0 AND f.oversvoem_peri_fremtid_pct >= {Perimeter cut-off (%)} THEN COUNT(*) FILTER (WHERE {f_age_t_human_health} BETWEEN 18 AND 70) * (138 * 301) ELSE 0 END::integer AS arbejdstid_fremtid_kr,
            CASE WHEN f.cnt_oversvoem_fremtid > 0 AND f.oversvoem_peri_fremtid_pct >= {Perimeter cut-off (%)} THEN COUNT(*) FILTER (WHERE {f_age_t_human_health} BETWEEN 18 AND 70) * (23  * 301) ELSE 0 END::integer AS rejsetid_fremtid_kr,
            CASE WHEN f.cnt_oversvoem_fremtid > 0 AND f.oversvoem_peri_fremtid_pct >= {Perimeter cut-off (%)} THEN COUNT(*) FILTER (WHERE {f_age_t_human_health} BETWEEN 18 AND 70) * (64  * 301) ELSE 0 END::integer AS sygetimer_fremtid_kr, 
            CASE WHEN f.cnt_oversvoem_fremtid > 0 AND f.oversvoem_peri_fremtid_pct >= {Perimeter cut-off (%)} THEN COUNT(*) FILTER (WHERE {f_age_t_human_health} BETWEEN 18 AND 70) * (26  * 301) ELSE 0 END::integer AS ferietimer_fremtid_kr 
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

--   Patch 2022-10-14 Model q_human_health with perimeter slut --


/* 
-----------------------------------------------------------------------
--   Patch 2022-10-15: Model q_tourism_spatial perimeter
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
	v.*,
    n.*,
    f.*,
    r.*
    FROM {t_building} b
    INNER JOIN {t_tourism} t  ON t.{f_pkey_t_tourism} = b.{f_usage_code_t_building},  
    LATERAL (
        SELECT ST_perimeter({f_geom_Oversvømmelsesmodel, nutid}) / 4.0 AS vp_side_laengde_m FROM {Oversvømmelsesmodel, nutid} LIMIT 1
    ) v, 
    LATERAL (
        SELECT
            COUNT (*) AS cnt_oversvoem_nutid,
            100.0 * COUNT(*) * v.vp_side_laengde_m / ST_Perimeter(b.{f_geom_t_building}) AS oversvoem_peri_nutid_pct,            
            COALESCE(SUM(st_area(st_intersection(b.{f_geom_t_building},{f_geom_Oversvømmelsesmodel, nutid}))),0)::NUMERIC(12,2) AS areal_oversvoem_nutid_m2,
            COALESCE(MIN({f_depth_Oversvømmelsesmodel, nutid}) * 100.00,0)::NUMERIC(12,2) AS min_vanddybde_nutid_cm,
            COALESCE(MAX({f_depth_Oversvømmelsesmodel, nutid}) * 100.00,0)::NUMERIC(12,2) AS max_vanddybde_nutid_cm,
            COALESCE(AVG({f_depth_Oversvømmelsesmodel, nutid}) * 100.00,0)::NUMERIC(12,2) AS avg_vanddybde_nutid_cm,
            CASE WHEN COUNT (*) > 0 AND 100.0 * COUNT(*) * v.vp_side_laengde_m / ST_Perimeter(b.{f_geom_t_building}) >= {Perimeter cut-off (%)} THEN {Antal tabte døgn} * t.omkostning * t.kapacitet ELSE 0 END::NUMERIC(12,2) AS {f_damage_present_q_tourism_spatial}
        FROM {Oversvømmelsesmodel, nutid} WHERE st_intersects(b.{f_geom_t_building},{f_geom_Oversvømmelsesmodel, nutid}) AND {f_depth_Oversvømmelsesmodel, nutid} >= {Minimum vanddybde (meter)}
    ) n,
    LATERAL (
        SELECT
            COUNT (*) AS cnt_oversvoem_fremtid,
            100.0 * COUNT(*) * v.vp_side_laengde_m / ST_Perimeter(b.{f_geom_t_building}) AS oversvoem_peri_fremtid_pct,            
            COALESCE(SUM(st_area(st_intersection(b.{f_geom_t_building},{f_geom_Oversvømmelsesmodel, fremtid}))),0)::NUMERIC(12,2) AS areal_oversvoem_fremtid_m2,
            COALESCE(MIN({f_depth_Oversvømmelsesmodel, fremtid}) * 100.00,0)::NUMERIC(12,2) AS min_vanddybde_fremtid_cm,
            COALESCE(MAX({f_depth_Oversvømmelsesmodel, fremtid}) * 100.00,0)::NUMERIC(12,2) AS max_vanddybde_fremtid_cm,
            COALESCE(AVG({f_depth_Oversvømmelsesmodel, fremtid}) * 100.00,0)::NUMERIC(12,2) AS avg_vanddybde_fremtid_cm,
            CASE WHEN COUNT (*) > 0 AND 100.0 * COUNT(*) * v.vp_side_laengde_m / ST_Perimeter(b.{f_geom_t_building}) >= {Perimeter cut-off (%)} THEN {Antal tabte døgn} * t.omkostning * t.kapacitet ELSE 0 END::NUMERIC(12,2) AS {f_damage_future_q_tourism_spatial}
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

--   Patch 2022-10-15: Model q_tourism_spatial perimeter slut --

