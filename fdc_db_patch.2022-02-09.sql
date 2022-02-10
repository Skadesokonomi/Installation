/* 
-----------------------------------------------------------------------
--   Patch 2022-02-09: Model q_building_new
-----------------------------------------------------------------------

     search_path skal værdisættes, således at navnet på administrations schema er første parameter. 
     Hvis der ikke er ændret på standard navn for administrationsskema "fdc_admin"
     skal der ikke rettes i linjen

*/
SET search_path = fdc_admin, public;
--                *********




-- NIX PILLE VED RESTEN....................................................................................................

INSERT INTO parametre (name, parent, value, type, minval, maxval, lookupvalues, "default", explanation, sort, checkable) VALUES ('f_risk_q_building_new', 'q_building_new', 'risiko_kr', 'T', '', '', '', '', '', 1, 'T');
INSERT INTO parametre (name, parent, value, type, minval, maxval, lookupvalues, "default", explanation, sort, checkable) VALUES ('f_damage_future_q_building_new', 'q_building_new', 'skadebeloeb_fremtid_kr', 'T', '', '', '', '', '', 1, 'T');
INSERT INTO parametre (name, parent, value, type, minval, maxval, lookupvalues, "default", explanation, sort, checkable) VALUES ('f_loss_q_building_new', 'q_building_new', 'vaerditab_kr', 'T', '', '', '', '', '', 1, 'T');
INSERT INTO parametre (name, parent, value, type, minval, maxval, lookupvalues, "default", explanation, sort, checkable) VALUES ('f_cellar_damage_present_q_building_new', 'q_building_new', 'skadebeloeb_kaelder_kr', 'T', '', '', '', '', '', 1, 'T');
INSERT INTO parametre (name, parent, value, type, minval, maxval, lookupvalues, "default", explanation, sort, checkable) VALUES ('f_damage_present_q_building_new', 'q_building_new', 'skadebeloeb_kr', 'T', '', '', '', '', '', 1, 'T');
INSERT INTO parametre (name, parent, value, type, minval, maxval, lookupvalues, "default", explanation, sort, checkable) VALUES ('f_cellar_damage_future_q_building_new', 'q_building_new', 'skadebeloeb_kaelder_fremtid_kr', 'T', '', '', '', '', '', 1, 'T');
INSERT INTO parametre (name, parent, value, type, minval, maxval, lookupvalues, "default", explanation, sort, checkable) VALUES ('f_pkey_q_building_new', 'q_building_new', 'fid', 'T', '', '', '', '', 'Name of primary keyfield for query', 10, ' ');
INSERT INTO parametre (name, parent, value, type, minval, maxval, lookupvalues, "default", explanation, sort, checkable) VALUES ('f_geom_q_building_new', 'q_building_new', 'geom_byg', 'T', '', '', '', '', 'Field name for geometry column', 10, ' ');
INSERT INTO parametre (name, parent, value, type, minval, maxval, lookupvalues, "default", explanation, sort, checkable) VALUES ('Oversvømmelsesmodel, fremtid', 'Generelle modelværdier', 'fdc_data.oversvoem', 'Q', '', '', 't_flood', 't_flood', '(Bruges til ny modelberegning for bygninger) 
Valg oversvømmelsestabel for fremtidshændelse', 12, ' ');
INSERT INTO parametre (name, parent, value, type, minval, maxval, lookupvalues, "default", explanation, sort, checkable) VALUES ('Oversvømmelsesmodel, nutid', 'Generelle modelværdier', 'fdc_data.oversvoem', 'Q', '', '', 't_flood', 't_flood', '(Bruges til ny modelberegning for bygninger) 
Valg oversvømmelsestabel for nutidshændelse', 13, ' ');
INSERT INTO parametre (name, parent, value, type, minval, maxval, lookupvalues, "default", explanation, sort, checkable) VALUES ('q_building_new', 'Queries', 'WITH obn AS (
    SELECT
        b.{f_pkey_t_building},
        COUNT (*) AS cnt_oversvoem,
        (SUM(st_area(st_intersection(b.{f_geom_t_building},o.{f_geom_Oversvømmelsesmodel, nutid}))))::NUMERIC(12,2) AS areal_oversvoem_m2,
        (MIN(o.{f_depth_Oversvømmelsesmodel, nutid}) * 100.00)::NUMERIC(12,2) AS min_vanddybde_cm,
        (MAX(o.{f_depth_Oversvømmelsesmodel, nutid}) * 100.00)::NUMERIC(12,2) AS max_vanddybde_cm,
        (AVG(o.{f_depth_Oversvømmelsesmodel, nutid}) * 100.00)::NUMERIC(12,2) AS avg_vanddybde_cm
        --(SUM(o.{f_depth_Oversvømmelsesmodel, nutid}*st_area(st_intersection(b.{f_geom_t_building},o.{f_geom_Oversvømmelsesmodel, nutid}))) * 100.0 / SUM(st_area(st_intersection(b.{f_geom_t_building},o.{f_geom_Oversvømmelsesmodel, nutid}))))::NUMERIC(12,2) AS avg_vanddybde_cm
    FROM {t_building} b
    INNER JOIN {Oversvømmelsesmodel, nutid} o on st_intersects(b.{f_geom_t_building},o.{f_geom_Oversvømmelsesmodel, nutid})
    WHERE o.{f_depth_Oversvømmelsesmodel, nutid} >= {Minimum vanddybde (meter)}
    GROUP BY b.{f_pkey_t_building}
),
obf AS (
    SELECT
        b.{f_pkey_t_building},
        COUNT (*) AS cnt_oversvoem_fremtid,
        (SUM(st_area(st_intersection(b.{f_geom_t_building},o.{f_geom_Oversvømmelsesmodel, fremtid}))))::NUMERIC(12,2) AS areal_oversvoem_fremtid_m2,
        (MIN(o.{f_depth_Oversvømmelsesmodel, fremtid}) * 100.00)::NUMERIC(12,2) AS min_vanddybde_fremtid_cm,
        (MAX(o.{f_depth_Oversvømmelsesmodel, fremtid}) * 100.00)::NUMERIC(12,2) AS max_vanddybde_fremtid_cm,
        (AVG(o.{f_depth_Oversvømmelsesmodel, fremtid}) * 100.00)::NUMERIC(12,2) AS avg_vanddybde_fremtid_cm
        --(SUM(o.{f_depth_Oversvømmelsesmodel, fremtid}*st_area(st_intersection(b.{f_geom_t_building},o.{f_geom_Oversvømmelsesmodel, fremtid}))) * 100.0 / SUM(st_area(st_intersection(b.{f_geom_t_building},o.{f_geom_Oversvømmelsesmodel, fremtid}))))::NUMERIC(12,2) AS avg_vanddybde_cm
    FROM {t_building} b
    INNER JOIN {Oversvømmelsesmodel, fremtid} o on st_intersects(b.{f_geom_t_building},o.{f_geom_Oversvømmelsesmodel, fremtid})
    WHERE o.{f_depth_Oversvømmelsesmodel, nutid} >= {Minimum vanddybde (meter)}
    GROUP BY b.{f_pkey_t_building}
),
os AS (
    SELECT
        b.{f_pkey_t_building} as {f_pkey_q_building_new},
        b.{f_muncode_t_building} AS kom_kode,
		b.{f_usage_code_t_building} AS bbr_anv_kode,
        u.{f_usage_text_t_build_usage} AS bbr_anv_tekst,
        b.{f_cellar_area_t_building}::NUMERIC(12,2) AS areal_kaelder_m2,
        st_area(b.{f_geom_t_building})::NUMERIC(12,2) AS areal_byg_m2,
        d.{f_category_t_damage} AS skade_kategori,
        d.{f_type_t_damage} AS skade_type,
        st_multi(st_force2d(b.{f_geom_t_building}))::Geometry(Multipolygon,25832) AS {f_geom_q_building_new},
        {Værditab, skaderamte bygninger (%)}::NUMERIC(12,2) as tab_procent,
        k.{f_sqmprice_t_sqmprice}::NUMERIC(12,2) as kvm_pris_kr,
        (k.{f_sqmprice_t_sqmprice} * st_area(b.{f_geom_t_building}) * {Værditab, skaderamte bygninger (%)}/100.0)::NUMERIC(12,2) as {f_loss_q_building_new},
        CASE
		    WHEN obn.max_vanddybde_cm IS NULL THEN 0.0
			ELSE (d.b0 + st_area(b.{f_geom_t_building}) * (d.b1 * ln(GREATEST(obn.max_vanddybde_cm, 1.0)) + d.b2))
        END::NUMERIC(12,2) AS {f_damage_present_q_building_new},
		CASE
	        WHEN ''{Skadeberegning for kælder}'' = ''Medtages ikke'' THEN 0.0
	        WHEN ''{Skadeberegning for kælder}'' = ''Medtages'' THEN b.{f_cellar_area_t_building} * d.c0 
        END::NUMERIC(12,2) as {f_cellar_damage_present_q_building_new},
        obn.cnt_oversvoem,
        obn.areal_oversvoem_m2,
        obn.min_vanddybde_cm,
        obn.max_vanddybde_cm,
        obn.avg_vanddybde_cm,
        CASE
		    WHEN obf.max_vanddybde_fremtid_cm IS NULL THEN 0.0
			ELSE (d.b0 + st_area(b.{f_geom_t_building}) * (d.b1 * ln(GREATEST(obf.max_vanddybde_fremtid_cm, 1.0)) + d.b2))
        END::NUMERIC(12,2) AS {f_damage_future_q_building_new},
        CASE
	        WHEN ''{Skadeberegning for kælder}'' = ''Medtages ikke'' THEN 0.0
	        WHEN ''{Skadeberegning for kælder}'' = ''Medtages'' THEN b.{f_cellar_area_t_building} * d.c0 
        END::NUMERIC(12,2) as {f_cellar_damage_future_q_building_new},
        obf.cnt_oversvoem_fremtid,
        obf.areal_oversvoem_fremtid_m2,
        obf.min_vanddybde_fremtid_cm,
        obf.max_vanddybde_fremtid_cm,
        obf.avg_vanddybde_fremtid_cm
    FROM {t_building} b
    LEFT JOIN obn on  b.{f_pkey_t_building} = obn.{f_pkey_t_building}
    LEFT JOIN obf on  b.{f_pkey_t_building} = obf.{f_pkey_t_building}
    LEFT JOIN {t_build_usage} u on b.{f_usage_code_t_building} = u.{f_pkey_t_build_usage}
    LEFT JOIN {t_damage} d on u.{f_category_t_build_usage} = d.{f_category_t_damage} AND d.{f_type_t_damage} = ''{Skadetype}''   
    LEFT JOIN {t_sqmprice} k on (b.{f_muncode_t_building} = k.{f_muncode_t_sqmprice})
    WHERE obn.{f_pkey_t_building} IS NOT NULL OR obf.{f_pkey_t_building}  IS NOT NULL 
)
SELECT 
    os.*,
	((0.219058829 * CASE
                       WHEN ''{Medtag i risikoberegninger}'' = ''Intet (0 kr.)'' THEN 0.0
                       WHEN ''{Medtag i risikoberegninger}'' = ''Skadebeløb'' THEN os.{f_damage_present_q_building_new} + os.{f_cellar_damage_present_q_building_new}
                       WHEN ''{Medtag i risikoberegninger}'' = ''Værditab'' THEN os.{f_loss_q_building_new}
                       WHEN ''{Medtag i risikoberegninger}'' = ''Skadebeløb og værditab'' THEN os.{f_damage_present_q_building_new} + os.{f_cellar_damage_present_q_building_new} + os.{f_loss_q_building_new} 
                   END + 
    0.089925625 *  CASE
                       WHEN ''{Medtag i risikoberegninger}'' = ''Intet (0 kr.)'' THEN 0.0
                       WHEN ''{Medtag i risikoberegninger}'' = ''Skadebeløb'' THEN os.{f_damage_future_q_building_new} + os.{f_cellar_damage_future_q_building_new}
                       WHEN ''{Medtag i risikoberegninger}'' = ''Værditab'' THEN os.{f_loss_q_building_new}
                       WHEN ''{Medtag i risikoberegninger}'' = ''Skadebeløb og værditab'' THEN os.{f_damage_future_q_building_new} + os.{f_cellar_damage_future_q_building_new} + os.{f_loss_q_building_new} 
                   END)/{Returperiode, antal år})::NUMERIC(12,2) AS {f_risk_q_building_new}
FROM os
', 'P', '', '', '', '', 'SQL template for buildings new model ', 8, ' ');


INSERT INTO parametre (name, parent, value, type, minval, maxval, lookupvalues, "default", explanation, sort, checkable) VALUES ('Returperiode, antal år', 'Generelle modelværdier', '20', 'I', '0', '1000', '10', '', '(Bruges til ny modelberegning for bygninger) 
Indtast returperioden i hele år, dvs. forventet antal år mellem nutidshændelse og fremtidshændelse', 14, ' ');

UPDATE parametre set parent = 'Bygninger' WHERE name = 'Skadeberegning for kælder';
UPDATE parametre set parent = 'Bygninger' WHERE name = 'Skadetype';
INSERT INTO parametre (name, parent, value, type, minval, maxval, lookupvalues, "default", explanation, sort, checkable) VALUES ('Skadeberegninger, Bygninger, ny model', 'Bygninger', '', 'T', '', '', '', 'q_building_new', 'Skadeberegning for bygninger, forskellige skademodeller, med eller uden kælderberegning, ny metode', 10, 'T');
INSERT INTO parametre (name, parent, value, type, minval, maxval, lookupvalues, "default", explanation, sort, checkable) VALUES ('t_flood_2', 'Data', '"fdc_data"."hav_20_2100"', 'S', '', '', '', '', 'Parametergruppe til tabel "oversvømmelser"', 8, ' ');
INSERT INTO parametre (name, parent, value, type, minval, maxval, lookupvalues, "default", explanation, sort, checkable) VALUES ('t_flood_3', 'Data', '"fdc_data"."hav_100_2020"', 'S', '', '', '', '', 'Parametergruppe til tabel "oversvømmelser"', 9, ' ');
INSERT INTO parametre (name, parent, value, type, minval, maxval, lookupvalues, "default", explanation, sort, checkable) VALUES ('t_flood_4', 'Data', '"fdc_data"."hav_100_2020"', 'S', '', '', '', '', 'Parametergruppe til tabel "oversvømmelser"', 9, ' ');
INSERT INTO parametre (name, parent, value, type, minval, maxval, lookupvalues, "default", explanation, sort, checkable) VALUES ('f_depth_t_flood_2', 't_flood_2', '"vandstand_m"', 'F', '', '', '', '', 'Field name for detph field in flood table ', 10, ' ');
INSERT INTO parametre (name, parent, value, type, minval, maxval, lookupvalues, "default", explanation, sort, checkable) VALUES ('f_geom_t_flood_2', 't_flood_2', '"geom"', 'F', '', '', '', '', 'Field name for geometry field in flood table', 10, ' ');
INSERT INTO parametre (name, parent, value, type, minval, maxval, lookupvalues, "default", explanation, sort, checkable) VALUES ('f_depth_t_flood_3', 't_flood_3', 'vandstand_m', 'F', '', '', '', '', 'Field name for detph field in flood table ', 10, ' ');
INSERT INTO parametre (name, parent, value, type, minval, maxval, lookupvalues, "default", explanation, sort, checkable) VALUES ('f_geom_t_flood_3', 't_flood_3', 'geom', 'F', '', '', '', '', 'Field name for geometry field in flood table', 10, ' ');
INSERT INTO parametre (name, parent, value, type, minval, maxval, lookupvalues, "default", explanation, sort, checkable) VALUES ('f_depth_t_flood_4', 't_flood_4', 'vandstand_m', 'F', '', '', '', '', 'Field name for detph field in flood table ', 10, ' ');
INSERT INTO parametre (name, parent, value, type, minval, maxval, lookupvalues, "default", explanation, sort, checkable) VALUES ('f_geom_t_flood_4', 't_flood_4', 'geom', 'F', '', '', '', '', 'Field name for geometry field in flood table', 10, ' ');


-- Patch 2022-02-09: Model q_building_new slut --
