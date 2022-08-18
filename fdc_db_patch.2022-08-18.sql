/* 
-----------------------------------------------------------------------
--   Patch 2022-08-18: Rettelse af public service query
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
        FROM {Oversvømmelsesmodel, fremtid} WHERE {f_depth_Oversvømmelsesmodel, fremtid} >= {Minimum vanddybde (meter)} AND st_intersects(COALESCE (b.{f_geom_t_building},o.{f_geom_t_publicservice}),{f_geom_Oversvømmelsesmodel, fremtid}) 
    ) f
    WHERE f.cnt_oversvoem_fremtid > 0 OR n.cnt_oversvoem_nutid > 0
'
WHERE name = 'q_publicservice' AND parent = 'Queries';

--   Patch 2022-08-18: Rettelse af public service query

 