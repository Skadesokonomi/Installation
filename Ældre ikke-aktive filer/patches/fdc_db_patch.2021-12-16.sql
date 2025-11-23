/* 
-----------------------------------------------------------------------
--   Patch 2021-12-16: Opdatering af tabel skadefunktioner                          --
-----------------------------------------------------------------------

     search_path skal værdisættes, således at navnet på administrations schema er første parameter. 
     Hvis der ikke er ændret på standard navn for administrationsskema "fdc_admin"
     skal der ikke rettes i linjen

*/
SET search_path = fdc_admin, public;
--                *********

TRUNCATE TABLE skadefunktioner;
INSERT INTO skadefunktioner (skade_type, skade_kategori, b0, b1, b2, c0) VALUES ('Stormflod', 'Helårsbeboelse',     0.00, 1167.86,  -571.21, 578.00);
INSERT INTO skadefunktioner (skade_type, skade_kategori, b0, b1, b2, c0) VALUES ('Stormflod', 'Sommerhus'     ,     0.00, 1681.71, -2128.87, 578.00);
INSERT INTO skadefunktioner (skade_type, skade_kategori, b0, b1, b2, c0) VALUES ('Stormflod', 'Garage mm.'    , 30000.00,    0.00,     0.00, 578.00);
INSERT INTO skadefunktioner (skade_type, skade_kategori, b0, b1, b2, c0) VALUES ('Stormflod', 'Anneks'        , 30000.00,    0.00,     0.00, 578.00);
INSERT INTO skadefunktioner (skade_type, skade_kategori, b0, b1, b2, c0) VALUES ('Stormflod', 'Erhverv'       ,     0.00, 1387.94,  -881.80, 578.00);
INSERT INTO skadefunktioner (skade_type, skade_kategori, b0, b1, b2, c0) VALUES ('Stormflod', 'Kultur'        ,     0.00, 1387.94,  -881.80, 578.00);
INSERT INTO skadefunktioner (skade_type, skade_kategori, b0, b1, b2, c0) VALUES ('Stormflod', 'Forsyning'     ,     0.00, 1387.94,  -881.80, 578.00);
INSERT INTO skadefunktioner (skade_type, skade_kategori, b0, b1, b2, c0) VALUES ('Stormflod', 'Offentlig'     ,     0.00, 1387.94,  -881.80, 578.00);
INSERT INTO skadefunktioner (skade_type, skade_kategori, b0, b1, b2, c0) VALUES ('Stormflod', 'Ingen data'    ,     0.00,    0.00,  2000.00, 578.00);
INSERT INTO skadefunktioner (skade_type, skade_kategori, b0, b1, b2, c0) VALUES ('Stormflod', 'Andet'         ,     0.00,    0.00,  2000.00, 578.00);

INSERT INTO skadefunktioner (skade_type, skade_kategori, b0, b1, b2, c0) VALUES ('Skybrud',   'Helårsbeboelse',     0.00,    0.00,  1257.00, 578.00);
INSERT INTO skadefunktioner (skade_type, skade_kategori, b0, b1, b2, c0) VALUES ('Skybrud',   'Sommerhus'     ,     0.00,    0.00,  1249.00, 578.00);
INSERT INTO skadefunktioner (skade_type, skade_kategori, b0, b1, b2, c0) VALUES ('Skybrud',   'Garage mm.'    , 30000.00,    0.00,     0.00, 578.00);
INSERT INTO skadefunktioner (skade_type, skade_kategori, b0, b1, b2, c0) VALUES ('Skybrud',   'Anneks'        , 30000.00,    0.00,     0.00, 578.00);
INSERT INTO skadefunktioner (skade_type, skade_kategori, b0, b1, b2, c0) VALUES ('Skybrud',   'Erhverv'       ,     0.00,    0.00,  1407.00, 578.00);
INSERT INTO skadefunktioner (skade_type, skade_kategori, b0, b1, b2, c0) VALUES ('Skybrud',   'Kultur'        ,     0.00,    0.00,  1407.00, 578.00);
INSERT INTO skadefunktioner (skade_type, skade_kategori, b0, b1, b2, c0) VALUES ('Skybrud',   'Forsyning'     ,     0.00,    0.00,  1407.00, 578.00);
INSERT INTO skadefunktioner (skade_type, skade_kategori, b0, b1, b2, c0) VALUES ('Skybrud',   'Offentlig'     ,     0.00,    0.00,  1407.00, 578.00);
INSERT INTO skadefunktioner (skade_type, skade_kategori, b0, b1, b2, c0) VALUES ('Skybrud',   'Ingen data'    ,     0.00,    0.00,  1000.00, 578.00);
INSERT INTO skadefunktioner (skade_type, skade_kategori, b0, b1, b2, c0) VALUES ('Skybrud',   'Andet'         ,     0.00,    0.00,  1000.00, 578.00);

INSERT INTO skadefunktioner (skade_type, skade_kategori, b0, b1, b2, c0) VALUES ('Vandløb',   'Helårsbeboelse',     0.00,  389.29,  -190.40, 578.00);
INSERT INTO skadefunktioner (skade_type, skade_kategori, b0, b1, b2, c0) VALUES ('Vandløb',   'Sommerhus'     ,     0.00,  560.57,  -709.62, 578.00);
INSERT INTO skadefunktioner (skade_type, skade_kategori, b0, b1, b2, c0) VALUES ('Vandløb',   'Garage mm.'    , 30000.00,    0.00,     0.00, 578.00);
INSERT INTO skadefunktioner (skade_type, skade_kategori, b0, b1, b2, c0) VALUES ('Vandløb',   'Anneks'        , 30000.00,    0.00,     0.00, 578.00);
INSERT INTO skadefunktioner (skade_type, skade_kategori, b0, b1, b2, c0) VALUES ('Vandløb',   'Erhverv'       ,     0.00,  462.65,  -293.93, 578.00);
INSERT INTO skadefunktioner (skade_type, skade_kategori, b0, b1, b2, c0) VALUES ('Vandløb',   'Kultur'        ,     0.00,  462.65,  -293.93, 578.00);
INSERT INTO skadefunktioner (skade_type, skade_kategori, b0, b1, b2, c0) VALUES ('Vandløb',   'Forsyning'     ,     0.00,  462.65,  -293.93, 578.00);
INSERT INTO skadefunktioner (skade_type, skade_kategori, b0, b1, b2, c0) VALUES ('Vandløb',   'Offentlig'     ,     0.00,  462.65,  -293.93, 578.00);
INSERT INTO skadefunktioner (skade_type, skade_kategori, b0, b1, b2, c0) VALUES ('Vandløb',   'Ingen data'    ,     0.00,    0.00,  1000.00, 578.00);
INSERT INTO skadefunktioner (skade_type, skade_kategori, b0, b1, b2, c0) VALUES ('Vandløb',   'Andet'         ,     0.00,    0.00,  1000.00, 578.00);

-- Patch 2021-12-16: Opdatering af Industri slut --
