-----------------------------------------------------------------------
--   Patch 2022-04-18 Model q_surrounding_loss_new
-----------------------------------------------------------------------
/*
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
LEFT JOIN (SELECT DISTINCT c.{f_pkey_t_building} FROM {t_building} c, of WHERE c.{f_pkey_t_building} NOT IN (SELECT {f_pkey_t_building} from of) and st_dwithin(of.{f_geom_t_building},c.{f_geom_t_building},{Bredde af nabozone (meter)})) y ON x.{f_pkey_t_building} = y.{f_pkey_t_building} 
LEFT JOIN (SELECT DISTINCT c.{f_pkey_t_building} FROM {t_building} c, op WHERE c.{f_pkey_t_building} NOT IN (SELECT {f_pkey_t_building} from op) and st_dwithin(op.{f_geom_t_building},c.{f_geom_t_building},{Bredde af nabozone (meter)})) z ON x.{f_pkey_t_building} = z.{f_pkey_t_building} 
LEFT JOIN {t_sqmprice} k ON k.kom_kode = x.komkode 
WHERE y.{f_pkey_t_building} IS NOT NULL OR z.{f_pkey_t_building} IS NOT NULL
', 'P', '', '', '', '', 'SQL template for surrounding loss - new model ', 8, ' ');
INSERT INTO parametre (name, parent, value, type, minval, maxval, lookupvalues, "default", explanation, sort, checkable) VALUES ('Værditab nabobygninger', 'Bygninger', '', 'T', '', '', '', 'q_surrounding_loss', '', 12, 'T');

UPDATE parametre SET parent = 'Bygninger', sort = 3 WHERE name = 'Bredde af nabozone (meter)';
UPDATE parametre SET parent = 'Bygninger', sort = 4 WHERE name = 'Faktor for værditab';

-- Patch  2022-04-18: Model q_surrounding_loss_new slut --

