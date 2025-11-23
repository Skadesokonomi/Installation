/* 
-----------------------------------------------------------------------
--   Patch 2021-12-11: Opdatering af Industri                          --
-----------------------------------------------------------------------

     search_path skal værdisættes, således at navnet på administrations schema er første parameter. 
     Hvis der ikke er ændret på standard navn for administrationsskema "fdc_admin"
     skal der ikke rettes i linjen

*/
SET search_path = fdc_admin, public;
--                *********

/* 
   værdi for parameter 'f_pkey_q_comp_build' skal sættes til kolonnenavn for primærnøgle for industri/virksomheds - tabel
   Den er som udgangspunkt sat til 'objectid'
*/
UPDATE parametre SET value = 'objectid' WHERE name = 'f_pkey_q_comp_build' AND parent = 'q_comp_build';
--                            ********

/* 
   Værdi for parameter 'f_geom_q_comp_build' skal sættes til kolonnenavn for geometrifelt for industri/virksomheds - tabel
   Den er som udgangspunkt sat til 'geom'
*/
UPDATE parametre SET value = 'geom' WHERE name = 'f_geom_q_comp_build' AND parent = 'q_comp_build';
--                            ****


-- NIX PILLE VED RESTEN....................................................................................................

-- Slet model 'Industri, punkter fejlplaceret' og associerede parametre.
DELETE FROM parametre WHERE name = 'f_mod_type_t_company' AND parent = 't_company';
DELETE FROM parametre WHERE name = 'f_mod_date_t_company' AND parent = 't_company';
DELETE FROM parametre WHERE name = 'f_comp_start_date_t_company' AND parent = 't_company';
DELETE FROM parametre WHERE name = 'f_pkey_q_comp_nobuild' AND parent = 'q_comp_nobuild';
DELETE FROM parametre WHERE name = 'f_geom_q_comp_nobuild' AND parent = 'q_comp_nobuild';
DELETE FROM parametre WHERE name = 'q_comp_nobuild' AND parent = 'Queries';
DELETE FROM parametre WHERE name = 'Industri, punkter fejlplaceret' AND parent = 'Industri';

-- Opdatér query 'q_comp_build'
UPDATE parametre SET value = 'WITH cte1 AS (
  SELECT DISTINCT ON (c.{f_pkey_t_company})
    c.*,
    o.{f_depth_t_flood}*100.00 AS vanddybde_cm,
    b.{f_pkey_t_building} AS byg_id,
    b.{f_muncode_t_building} AS kom_kode,
    b.{f_usage_code_t_building} AS bbr_kode,
    b.{f_usage_text_t_building} AS bbr_tekst
    FROM {t_company} c 
    LEFT JOIN {t_building} b ON st_within(c.{f_geom_t_company},b.{f_geom_t_building})
    LEFT JOIN {t_flood} o ON st_intersects(b.{f_geom_t_building},o.{f_geom_t_flood})
    WHERE o.{f_depth_t_flood} >= {Minimum vanddybde (meter)} AND b.{f_pkey_t_building} IS NOT NULL 
  ORDER BY c.{f_pkey_t_company} ASC, o.{f_depth_t_flood} DESC
),
cte2 AS (
  SELECT DISTINCT
    c.*,
    o.{f_depth_t_flood}*100.00 AS vanddybde_cm,
    b.{f_pkey_t_building} AS byg_id,
    b.{f_muncode_t_building} AS kom_kode,
    b.{f_usage_code_t_building} AS bbr_kode,
    b.{f_usage_text_t_building} AS bbr_tekst
    FROM {t_company} c 
    LEFT JOIN {t_flood} o ON st_within(c.{f_geom_t_company},o.{f_geom_t_flood})
    LEFT JOIN {t_building} b ON st_within(c.{f_geom_t_company},b.{f_geom_t_building})
    WHERE o.{f_depth_t_flood} >= {Minimum vanddybde (meter)} AND b.{f_pkey_t_building} IS NULL 
) 
SELECT * FROM cte1 UNION ALL SELECT * FROM cte2
'
WHERE name = 'q_comp_build' AND parent = 'Queries';

-- Patch 2021-12-11: Opdatering af Industri slut --
