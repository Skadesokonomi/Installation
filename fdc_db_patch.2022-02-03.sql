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
  where "name" like 't_%' and parent = 'Data' and "type" = 'T';

-- Opdatér rækker i faneblad "Data" hvor navn starter med 'f_", dvs f entries, og hvor parent er med i 1. opdatering
update parametre set "type" = 'F' 
  where "name" like 'f_%' and parent in (select name from fdc_admin.parametre where "name" like 't_%' and parent = 'Data' and "type" = 'S');

-- Patch 2022-02-03: Opdatering af Kritisk infrastruktur slut --
