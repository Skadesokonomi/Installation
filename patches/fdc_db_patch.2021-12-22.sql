/* 
-----------------------------------------------------------------------
--   Patch 2021-12-22: Opdatering af Kritisk infrastruktur                          --
-----------------------------------------------------------------------

     search_path skal værdisættes, således at navnet på administrations schema er første parameter. 
     Hvis der ikke er ændret på standard navn for administrationsskema "fdc_admin"
     skal der ikke rettes i linjen

*/
SET search_path = fdc_admin, public;
--                *********


-- NIX PILLE VED RESTEN....................................................................................................

-- Opdatér query 'q_infrastructure'
UPDATE parametre SET value = 'WITH cte1 AS (
  SELECT DISTINCT ON (c.{f_pkey_t_infrastructure})
    c.*,
    o.{f_depth_t_flood}*100.00 AS vanddybde_cm,
    b.{f_pkey_t_building} AS byg_id,
    b.{f_muncode_t_building} AS kom_kode,
    b.{f_usage_code_t_building} AS bbr_kode,
    b.{f_usage_text_t_building} AS bbr_tekst
    FROM {t_infrastructure} c 
    LEFT JOIN {t_building} b ON st_intersects(c.{f_geom_t_infrastructure},b.{f_geom_t_building})
    LEFT JOIN {t_flood} o ON st_intersects(b.{f_geom_t_building},o.{f_geom_t_flood})
    WHERE o.{f_depth_t_flood} >= {Minimum vanddybde (meter)} AND b.{f_pkey_t_building} IS NOT NULL 
  ORDER BY c.{f_pkey_t_infrastructure} ASC, o.{f_depth_t_flood} DESC
),
cte2 AS (
  SELECT DISTINCT ON (c.{f_pkey_t_infrastructure})
    c.*,
    o.{f_depth_t_flood}*100.00 AS vanddybde_cm,
    b.{f_pkey_t_building} AS byg_id,
    b.{f_muncode_t_building} AS kom_kode,
    b.{f_usage_code_t_building} AS bbr_kode,
    b.{f_usage_text_t_building} AS bbr_tekst
    FROM {t_infrastructure} c 
    LEFT JOIN {t_flood} o ON st_intersects(c.{f_geom_t_infrastructure},o.{f_geom_t_flood})
    LEFT JOIN {t_building} b ON st_intersects(c.{f_geom_t_infrastructure},b.{f_geom_t_building})
    WHERE o.{f_depth_t_flood} >= {Minimum vanddybde (meter)} AND b.{f_pkey_t_building} IS NULL 
  ORDER BY c.{f_pkey_t_infrastructure} ASC, o.{f_depth_t_flood} DESC
) 
SELECT * FROM cte1 UNION ALL SELECT * FROM cte2
'
WHERE name = 'q_infrastructure' AND parent = 'Queries';

-- Patch 2021-12-22: Opdatering af Kritisk infrastruktur slut --
