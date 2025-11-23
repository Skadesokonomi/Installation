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
