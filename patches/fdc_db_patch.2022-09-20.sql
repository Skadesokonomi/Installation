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
WITH v AS (
    SELECT 
        ST_perimeter({f_geom_Oversvømmelsesmodel, nutid}) / 4.0 AS side_length_w
    FROM {Oversvømmelsesmodel, nutid} OFFSET 1000 LIMIT 1
)    

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
        FROM {Oversvømmelsesmodel, nutid} WHERE st_overlaps(b.{f_geom_t_building},{f_geom_Oversvømmelsesmodel, nutid}) AND {f_depth_Oversvømmelsesmodel, nutid} >= {Minimum vanddybde (meter)}
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
        FROM {Oversvømmelsesmodel, fremtid} WHERE st_overlaps(b.{f_geom_t_building},{f_geom_Oversvømmelsesmodel, fremtid}) AND {f_depth_Oversvømmelsesmodel, fremtid} >= {Minimum vanddybde (meter)}
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

-- Patch  2022-02-26: Model q_build_peri_new slut --

