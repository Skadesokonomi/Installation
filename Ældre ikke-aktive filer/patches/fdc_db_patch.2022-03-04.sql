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
