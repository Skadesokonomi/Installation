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

INSERT INTO parametre (name, parent, value, type, minval, maxval, lookupvalues, "default", explanation, sort, checkable) VALUES ('Turisme, Kort - ny model', 'Turisme', '', 'T', '', '', '', 'q_tourism_spatial_new', 'Sæt hak såfremt der skal beregnes økonomiske tab for overnatningssteder som anvendes til turistformål. De berørte bygninger vises geografisk på et kort.  ', 10, 'T');
INSERT INTO parametre (name, parent, value, type, minval, maxval, lookupvalues, "default", explanation, sort, checkable) VALUES ('f_pkey_q_tourism_spatial_new'          , 'q_tourism_spatial_new', 'fid'                   , 'T', '', '', '', '', 'Name of primary keyfield for query', 10, ' ');
INSERT INTO parametre (name, parent, value, type, minval, maxval, lookupvalues, "default", explanation, sort, checkable) VALUES ('f_geom_q_tourism_spatial_new'          , 'q_tourism_spatial_new', 'geom'                  , 'T', '', '', '', '', 'Field name for geometry column', 10, ' ');
INSERT INTO parametre (name, parent, value, type, minval, maxval, lookupvalues, "default", explanation, sort, checkable) VALUES ('f_damage_present_q_tourism_spatial_new', 'q_tourism_spatial_new', 'skadebeloeb_nutid_kr'  , 'T', '', '', '', '', '', 1, 'T');
INSERT INTO parametre (name, parent, value, type, minval, maxval, lookupvalues, "default", explanation, sort, checkable) VALUES ('f_damage_future_q_tourism_spatial_new' , 'q_tourism_spatial_new', 'skadebeloeb_fremtid_kr', 'T', '', '', '', '', '', 1, 'T');
INSERT INTO parametre (name, parent, value, type, minval, maxval, lookupvalues, "default", explanation, sort, checkable) VALUES ('f_risk_q_tourism_spatial_new'          , 'q_tourism_spatial_new', 'risiko_kr'             , 'T', '', '', '', '', '', 1, 'T');

INSERT INTO parametre (name, parent, value, type, minval, maxval, lookupvalues, "default", explanation, sort, checkable) VALUES ('q_tourism_spatial_new', 'Queries',
'
SELECT
    b.{f_pkey_t_building} as {f_pkey_q_tourism_spatial_new},
    b.{f_muncode_t_building} AS kom_kode,
    b.{f_usage_code_t_building} AS bbr_anv_kode,
    t.bbr_anv_tekst AS bbr_anv_tekst,
    t.kapacitet AS kapacitet,
    t.omkostning AS omkostninger,
    {Antal tabte døgn} AS tabte_dage,
    {Antal tabte døgn} * t.kapacitet AS tabte_overnatninger,
    st_force2d(b.{f_geom_t_building}) AS {f_geom_q_tourism_spatial_new},
    n.*,
    f.*,
    r.*
    FROM {t_building} b
    INNER JOIN {t_tourism} t  ON t.{f_pkey_t_tourism} = b.{f_usage_code_t_building},  
    LATERAL (
        SELECT
            COUNT (*) AS cnt_oversvoem_nutid,
            COALESCE((SUM(st_area(st_intersection(b.{f_geom_t_building},{f_geom_Oversvømmelsesmodel, nutid})))),0)::NUMERIC(12,2) AS areal_oversvoem_nutid_m2,
            COALESCE((MIN({f_depth_Oversvømmelsesmodel, nutid}) * 100.00),0)::NUMERIC(12,2) AS min_vanddybde_nutid_cm,
            COALESCE((MAX({f_depth_Oversvømmelsesmodel, nutid}) * 100.00),0)::NUMERIC(12,2) AS max_vanddybde_nutid_cm,
            COALESCE((AVG({f_depth_Oversvømmelsesmodel, nutid}) * 100.00),0)::NUMERIC(12,2) AS avg_vanddybde_nutid_cm,
            CASE WHEN COUNT (*) > 0 THEN {Antal tabte døgn} * t.omkostning * t.kapacitet ELSE 0 END::NUMERIC(12,2) AS {f_damage_present_q_tourism_spatial_new}
        FROM {Oversvømmelsesmodel, nutid} WHERE st_intersects(b.{f_geom_t_building},{f_geom_Oversvømmelsesmodel, nutid}) AND {f_depth_Oversvømmelsesmodel, nutid} >= {Minimum vanddybde (meter)}
    ) n,
    LATERAL (
        SELECT
            COUNT (*) AS cnt_oversvoem_fremtid,
            COALESCE((SUM(st_area(st_intersection(b.{f_geom_t_building},{f_geom_Oversvømmelsesmodel, fremtid})))),0)::NUMERIC(12,2) AS areal_oversvoem_fremtid_m2,
            COALESCE((MIN({f_depth_Oversvømmelsesmodel, fremtid}) * 100.00),0)::NUMERIC(12,2) AS min_vanddybde_fremtid_cm,
            COALESCE((MAX({f_depth_Oversvømmelsesmodel, fremtid}) * 100.00),0)::NUMERIC(12,2) AS max_vanddybde_fremtid_cm,
            COALESCE((AVG({f_depth_Oversvømmelsesmodel, fremtid}) * 100.00),0)::NUMERIC(12,2) AS avg_vanddybde_fremtid_cm,
            CASE WHEN COUNT (*) > 0 THEN {Antal tabte døgn} * t.omkostning * t.kapacitet ELSE 0 END::NUMERIC(12,2) AS {f_damage_future_q_tourism_spatial_new}
        FROM {Oversvømmelsesmodel, fremtid} WHERE st_intersects(b.{f_geom_t_building},{f_geom_Oversvømmelsesmodel, fremtid}) AND {f_depth_Oversvømmelsesmodel, fremtid} >= {Minimum vanddybde (meter)}
    ) f,
    LATERAL (
        SELECT
          ''{Medtag i risikoberegninger}'' AS risiko_beregning,
		  {Returperiode, antal år} AS retur_periode,
          ((0.219058829 * CASE WHEN ''{Medtag i risikoberegninger}'' IN (''Skadebeløb'',''Skadebeløb og værditab'') THEN n.{f_damage_present_q_tourism_spatial_new} ELSE 0.0 END + 
          0.089925625   * CASE WHEN ''{Medtag i risikoberegninger}'' IN (''Skadebeløb'',''Skadebeløb og værditab'') THEN f.{f_damage_future_q_tourism_spatial_new} ELSE 0.0 END)/{Returperiode, antal år})::NUMERIC(12,2) AS {f_risk_q_tourism_spatial_new},
          '''' AS omraade
    ) r
	WHERE f.cnt_oversvoem_fremtid > 0 OR n.cnt_oversvoem_nutid > 0
', 'P', '', '', '', '', 'SQL template for buildings new model ', 8, ' ');

-- Patch  2022-02-27: Model q_tourism_spatial_new slut --
