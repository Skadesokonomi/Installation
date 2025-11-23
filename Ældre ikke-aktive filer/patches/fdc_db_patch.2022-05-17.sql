/* 
-----------------------------------------------------------------------
--   Patch 2022-05-17: Indførsel af ny skadekategori "Erhverv_lav"
-----------------------------------------------------------------------

     search_path skal værdisættes, således at navnet på administrations schema er første parameter. 
     Hvis der ikke er ændret på standard navn for administrationsskema "fdc_admin"
     skal der ikke rettes i linjen

*/
SET search_path = fdc_admin, public;
--                *********

-- NIX PILLE VED RESTEN....................................................................................................

INSERT INTO skadefunktioner (skade_type, skade_kategori, b0, b1, b2, c0) VALUES ('Stormflod', 'Erhverv_lav', 0, 346.98, -220.45, 578);
INSERT INTO skadefunktioner (skade_type, skade_kategori, b0, b1, b2, c0) VALUES ('Skybrud',   'Erhverv_lav', 0,      0,  351.63, 578);
INSERT INTO skadefunktioner (skade_type, skade_kategori, b0, b1, b2, c0) VALUES ('Vandløb',   'Erhverv_lav', 0, 115.66,  -73.48, 578);

UPDATE bbr_anvendelse SET skade_kategori = 'Erhverv_lav' WHERE bbr_anv_kode IN (211, 212, 213, 214, 215, 216, 218, 310, 313, 314, 319, 323, 534, 535);

--   Patch 2022-05-17: Indførsel af ny skadekategori "Erhverv_lav" slut

 