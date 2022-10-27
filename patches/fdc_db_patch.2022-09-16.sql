/*
-----------------------------------------------------------------------
--   Patch 2022-09-16: Model agriculture 
-----------------------------------------------------------------------

     search_path skal værdisættes, således at navnet på administrations schema er første parameter. 
     Hvis der ikke er ændret på standard navn for administrationsskema "fdc_admin"
     skal der ikke rettes i linjen

*/
SET search_path = fdc_admin, public;
--                *********

-- NIX PILLE VED RESTEN....................................................................................................

DELETE FROM parametre WHERE name LIKE '%_agriculture' OR name LIKE '%_agr_cat' OR name LIKE '%_agr_price';
DELETE FROM parametre WHERE parent = 'Landbrug' OR name = 'Landbrug';
DROP TABLE IF EXISTS "afgroede_kategori";
DROP TABLE IF EXISTS "afgroede_pris";

INSERT INTO parametre (name, parent, value, type, minval, maxval, lookupvalues, "default", explanation, sort, checkable) VALUES ('Landbrug', 'Models', '', 'G', '', '', '', '', 'Skademodeller for landbrug', 10, ' ');
INSERT INTO parametre (name, parent, value, type, minval, maxval, lookupvalues, "default", explanation, sort, checkable) VALUES ('Oversvømmede landbrugs arealer', 'Landbrug'   , ''                      , 'T', '', '', '', 'q_agriculture', 'Sæt hak såfremt der skal beregnes økonomiske tab for oversvømmede landbrugsarealer.', 10, 'T');
INSERT INTO parametre (name, parent, value, type, minval, maxval, lookupvalues, "default", explanation, sort, checkable) VALUES ('f_pkey_q_agriculture'          , 'q_agriculture', 'fid'                   , 'T', '', '', '', '', 'Name of primary keyfield for query', 10, ' ');
INSERT INTO parametre (name, parent, value, type, minval, maxval, lookupvalues, "default", explanation, sort, checkable) VALUES ('f_geom_q_agriculture'          , 'q_agriculture', 'geom'                  , 'T', '', '', '', '', 'Field name for geometry column', 10, ' ');
INSERT INTO parametre (name, parent, value, type, minval, maxval, lookupvalues, "default", explanation, sort, checkable) VALUES ('f_damage_present_q_agriculture', 'q_agriculture', 'skadebeloeb_nutid_kr'  , 'T', '', '', '', '', '', 1, 'T');
INSERT INTO parametre (name, parent, value, type, minval, maxval, lookupvalues, "default", explanation, sort, checkable) VALUES ('f_damage_future_q_agriculture' , 'q_agriculture', 'skadebeloeb_fremtid_kr', 'T', '', '', '', '', '', 1, 'T');
INSERT INTO parametre (name, parent, value, type, minval, maxval, lookupvalues, "default", explanation, sort, checkable) VALUES ('f_risk_q_agriculture'          , 'q_agriculture', 'risiko_kr'             , 'T', '', '', '', '', '', 1, 'T');

INSERT INTO parametre (name, parent, value, type, minval, maxval, lookupvalues, "default", explanation, sort, checkable) VALUES ('t_agriculture'                 , 'Sector data'  , 'fdc_data.marker2021'        , 'S', '', '', '', '', 'Parametergruppe til tabel "Landbrug"', 10, ' ');
INSERT INTO parametre (name, parent, value, type, minval, maxval, lookupvalues, "default", explanation, sort, checkable) VALUES ('t_agr_cat'                     , 'Admin data'   , 'fdc_admin.afgroede_kategori', 'S', '', '', '', '', 'Parametergruppe til opslagstabel "afgrøde-kategori"', 10, ' ');
INSERT INTO parametre (name, parent, value, type, minval, maxval, lookupvalues, "default", explanation, sort, checkable) VALUES ('t_agr_price'                   , 'Admin data'   , 'fdc_admin.afgroede_pris'    , 'S', '', '', '', '', 'Parametergruppe til opslagstabel "afgrøde-pris"', 10, ' ');

INSERT INTO parametre (name, parent, value, type, minval, maxval, lookupvalues, "default", explanation, sort, checkable) VALUES ('f_pkey_t_agriculture'          , 't_agriculture', 'fid'                   , 'F', '', '', '', '', 'Name of primary keyfield for query', 10, ' ');
INSERT INTO parametre (name, parent, value, type, minval, maxval, lookupvalues, "default", explanation, sort, checkable) VALUES ('f_geom_t_agriculture'          , 't_agriculture', 'geom'                  , 'F', '', '', '', '', 'Field name for geometry column', 10, ' ');
INSERT INTO parametre (name, parent, value, type, minval, maxval, lookupvalues, "default", explanation, sort, checkable) VALUES ('f_afgcode_t_agriculture'       , 't_agriculture', 'afgkode'               , 'F', '', '', '', '', 'Field name for agr code column', 10, ' ');
INSERT INTO parametre (name, parent, value, type, minval, maxval, lookupvalues, "default", explanation, sort, checkable) VALUES ('f_pkey_t_agr_cat'              , 't_agr_cat'    , 'afgroedekode'          , 'F', '', '', '', '', 'Name of primary keyfield for query', 10, ' ');
INSERT INTO parametre (name, parent, value, type, minval, maxval, lookupvalues, "default", explanation, sort, checkable) VALUES ('f_pcat_t_agr_cat'              , 't_agr_cat'    , 'priskategori'          , 'F', '', '', '', '', 'Name of field for price category'  , 10, ' ');
INSERT INTO parametre (name, parent, value, type, minval, maxval, lookupvalues, "default", explanation, sort, checkable) VALUES ('f_pkey_t_agr_price'            , 't_agr_price'  , 'priskategori'          , 'F', '', '', '', '', 'Name of primary keyfield for query', 10, ' ');
INSERT INTO parametre (name, parent, value, type, minval, maxval, lookupvalues, "default", explanation, sort, checkable) VALUES ('f_price_t_agr_price'           , 't_agr_price'  , 'pris'                  , 'F', '', '', '', '', 'Name of field for price in øre', 10, ' ');


INSERT INTO parametre (name, parent, value, type, minval, maxval, lookupvalues, "default", explanation, sort, checkable) VALUES ('q_agriculture'                 , 'Queries',
'
SELECT
    b.*,
    k.afgroedegruppe,
    k.afgroedekategori,
    p.*,
    n.*,
    areal_oversvoem_nutid_m2 * p.{f_price_t_agr_price} /100.00 AS {f_damage_present_q_agriculture},
    f.*,
    areal_oversvoem_fremtid_m2 * p.{f_price_t_agr_price} /100.00 AS {f_damage_future_q_agriculture},
    r.*
    FROM {t_agriculture} b
    LEFT JOIN {t_agr_cat} k ON k.{f_pkey_t_agr_cat} = b.{f_afgcode_t_agriculture} 
    LEFT JOIN {t_agr_price} p ON p.{f_pkey_t_agr_price} = k.{f_pcat_t_agr_cat}, 
    LATERAL (
        SELECT
            COUNT (*) AS cnt_oversvoem_nutid,
            COALESCE(SUM(st_area(st_intersection(b.{f_geom_t_agriculture},{f_geom_Oversvømmelsesmodel, nutid}))),0)::NUMERIC(12,2) AS areal_oversvoem_nutid_m2,
            COALESCE(MIN({f_depth_Oversvømmelsesmodel, nutid}) * 100.00,0)::NUMERIC(12,2) AS min_vanddybde_nutid_cm,
            COALESCE(MAX({f_depth_Oversvømmelsesmodel, nutid}) * 100.00,0)::NUMERIC(12,2) AS max_vanddybde_nutid_cm,
            COALESCE(AVG({f_depth_Oversvømmelsesmodel, nutid}) * 100.00,0)::NUMERIC(12,2) AS avg_vanddybde_nutid_cm
        FROM {Oversvømmelsesmodel, nutid} WHERE st_intersects(b.{f_geom_t_agriculture},{f_geom_Oversvømmelsesmodel, nutid}) AND {f_depth_Oversvømmelsesmodel, nutid} >= {Minimum vanddybde (meter)}
    ) n,
    LATERAL (
        SELECT
            COUNT (*) AS cnt_oversvoem_fremtid,
            COALESCE(SUM(st_area(st_intersection(b.{f_geom_t_agriculture},{f_geom_Oversvømmelsesmodel, fremtid}))),0)::NUMERIC(12,2) AS areal_oversvoem_fremtid_m2,
            COALESCE(MIN({f_depth_Oversvømmelsesmodel, fremtid}) * 100.00,0)::NUMERIC(12,2) AS min_vanddybde_fremtid_cm,
            COALESCE(MAX({f_depth_Oversvømmelsesmodel, fremtid}) * 100.00,0)::NUMERIC(12,2) AS max_vanddybde_fremtid_cm,
            COALESCE(AVG({f_depth_Oversvømmelsesmodel, fremtid}) * 100.00,0)::NUMERIC(12,2) AS avg_vanddybde_fremtid_cm
        FROM {Oversvømmelsesmodel, fremtid} WHERE st_intersects(b.{f_geom_t_agriculture},{f_geom_Oversvømmelsesmodel, fremtid}) AND {f_depth_Oversvømmelsesmodel, fremtid} >= {Minimum vanddybde (meter)}
    ) f,
    LATERAL (
        SELECT
          ''{Medtag i risikoberegninger}'' AS risiko_beregning,
		  {Returperiode, antal år} AS retur_periode,
          ((
		      0.219058829 * CASE WHEN ''{Medtag i risikoberegninger}'' IN (''Skadebeløb'',''Skadebeløb og værditab'') THEN n.areal_oversvoem_nutid_m2 * p.{f_price_t_agr_price} /100.00 ELSE 0.0 END + 
              0.089925625   * CASE WHEN ''{Medtag i risikoberegninger}'' IN (''Skadebeløb'',''Skadebeløb og værditab'') THEN f.areal_oversvoem_fremtid_m2 * p.{f_price_t_agr_price} /100.00 ELSE 0.0 END
          )/{Returperiode, antal år})::NUMERIC(12,2) AS {f_risk_q_agriculture},
          '''' AS omraade
    ) r
	WHERE f.cnt_oversvoem_fremtid > 0 OR n.cnt_oversvoem_nutid > 0
', 'P', '', '', '', '', 'SQL template for agriculture model ', 8, ' ');


CREATE TABLE "afgroede_pris" (
    "priskategori" "text" NOT NULL,
    "pris" double precision
);

INSERT INTO "afgroede_pris" ("priskategori", "pris") VALUES ('processkartofler', 311);
INSERT INTO "afgroede_pris" ("priskategori", "pris") VALUES ('skovdrift', 1100);
INSERT INTO "afgroede_pris" ("priskategori", "pris") VALUES ('havre', 77);
INSERT INTO "afgroede_pris" ("priskategori", "pris") VALUES ('krydderurter', 25250);
INSERT INTO "afgroede_pris" ("priskategori", "pris") VALUES ('vårbyg', 92);
INSERT INTO "afgroede_pris" ("priskategori", "pris") VALUES ('chipskartofler', 392);
INSERT INTO "afgroede_pris" ("priskategori", "pris") VALUES ('Bælgsæd', 80.66666667);
INSERT INTO "afgroede_pris" ("priskategori", "pris") VALUES ('vårkorn blanding', 80.25);
INSERT INTO "afgroede_pris" ("priskategori", "pris") VALUES ('Frøgræs', 171.8333333);
INSERT INTO "afgroede_pris" ("priskategori", "pris") VALUES ('foderrodfrugter', 148);
INSERT INTO "afgroede_pris" ("priskategori", "pris") VALUES ('vårtriticale', 80);
INSERT INTO "afgroede_pris" ("priskategori", "pris") VALUES ('sukkeroer', 142);
INSERT INTO "afgroede_pris" ("priskategori", "pris") VALUES ('vårsæd til modenhed', 74);
INSERT INTO "afgroede_pris" ("priskategori", "pris") VALUES ('græs, permanent', 65);
INSERT INTO "afgroede_pris" ("priskategori", "pris") VALUES ('frugt', 1450.105);
INSERT INTO "afgroede_pris" ("priskategori", "pris") VALUES ('oliefrø', 73);
INSERT INTO "afgroede_pris" ("priskategori", "pris") VALUES ('Havefrø', 480);
INSERT INTO "afgroede_pris" ("priskategori", "pris") VALUES ('bær', 4031.45);
INSERT INTO "afgroede_pris" ("priskategori", "pris") VALUES ('Brak', 0);
INSERT INTO "afgroede_pris" ("priskategori", "pris") VALUES ('vinterkorn blanding', 126);
INSERT INTO "afgroede_pris" ("priskategori", "pris") VALUES ('hvede', 139);
INSERT INTO "afgroede_pris" ("priskategori", "pris") VALUES ('vinterrug', 114);
INSERT INTO "afgroede_pris" ("priskategori", "pris") VALUES ('majs til helsæd', 90);
INSERT INTO "afgroede_pris" ("priskategori", "pris") VALUES ('kløver', 120);
INSERT INTO "afgroede_pris" ("priskategori", "pris") VALUES ('kål', 1221);
INSERT INTO "afgroede_pris" ("priskategori", "pris") VALUES ('helsæd, vinter', 111);
INSERT INTO "afgroede_pris" ("priskategori", "pris") VALUES ('læggekartofler', 556.7);
INSERT INTO "afgroede_pris" ("priskategori", "pris") VALUES ('Energiafgrøder', 1100);
INSERT INTO "afgroede_pris" ("priskategori", "pris") VALUES ('græs, sædskifte', 124);
INSERT INTO "afgroede_pris" ("priskategori", "pris") VALUES ('brak', 0);
INSERT INTO "afgroede_pris" ("priskategori", "pris") VALUES ('vinterhvede', 139);
INSERT INTO "afgroede_pris" ("priskategori", "pris") VALUES ('potteplanter og stauder', 27250);
INSERT INTO "afgroede_pris" ("priskategori", "pris") VALUES ('stivelseskartofler', 375);
INSERT INTO "afgroede_pris" ("priskategori", "pris") VALUES ('vinterbyg', 110);
INSERT INTO "afgroede_pris" ("priskategori", "pris") VALUES ('lucerne', 83);
INSERT INTO "afgroede_pris" ("priskategori", "pris") VALUES ('vintertriticale', 100);
INSERT INTO "afgroede_pris" ("priskategori", "pris") VALUES ('grøntsager', 480);
INSERT INTO "afgroede_pris" ("priskategori", "pris") VALUES ('spisekartofler', 455);
INSERT INTO "afgroede_pris" ("priskategori", "pris") VALUES ('helsæd, vår', 75);
INSERT INTO "afgroede_pris" ("priskategori", "pris") VALUES ('rug', 74);


ALTER TABLE ONLY "afgroede_pris"
    ADD CONSTRAINT "afgroede_pris_pkey" PRIMARY KEY ("priskategori");


CREATE TABLE "afgroede_kategori" (
    "afgroedekode" integer NOT NULL,
    "afgroedenavn" "text",
    "afgroedegruppe" "text",
    "afgroedekategori" "text",
    "priskategori" "text"
);


INSERT INTO "afgroede_kategori" ("afgroedekode", "afgroedenavn", "afgroedegruppe", "afgroedekategori", "priskategori") VALUES (116, 'Rajgræs, hybrid', 'Frøgræs', 'vårsået rajgræsfrø', 'Frøgræs');
INSERT INTO "afgroede_kategori" ("afgroedekode", "afgroedenavn", "afgroedegruppe", "afgroedekategori", "priskategori") VALUES (652, 'Kinesisk kålfrø', 'Havefrø', 'ager-kål', 'Havefrø');
INSERT INTO "afgroede_kategori" ("afgroedekode", "afgroedenavn", "afgroedegruppe", "afgroedekategori", "priskategori") VALUES (273, 'Lucerne til fabrik', 'Kløver og lucerne i renbestand', 'lucerne', 'lucerne');
INSERT INTO "afgroede_kategori" ("afgroedekode", "afgroedenavn", "afgroedegruppe", "afgroedekategori", "priskategori") VALUES (51, 'Blanding bredbladet afgrøde, frø/kerne', 'Hør og Hamp', 'vårsået blanding', 'oliefrø');
INSERT INTO "afgroede_kategori" ("afgroedekode", "afgroedenavn", "afgroedegruppe", "afgroedekategori", "priskategori") VALUES (272, 'Permanent græs til fabrik', 'Græs, permanent', '(afgrøden har ingen kategori)', 'græs, permanent');
INSERT INTO "afgroede_kategori" ("afgroedekode", "afgroedenavn", "afgroedegruppe", "afgroedekategori", "priskategori") VALUES (552, 'Mandelgræskar', 'Frugt og bær', 'mandelgræskar', 'grøntsager');
INSERT INTO "afgroede_kategori" ("afgroedekode", "afgroedenavn", "afgroedegruppe", "afgroedekategori", "priskategori") VALUES (539, 'Blandet frugt', 'Frugt og bær', '(afgrøden har ingen kategori)', 'frugt');
INSERT INTO "afgroede_kategori" ("afgroedekode", "afgroedenavn", "afgroedegruppe", "afgroedekategori", "priskategori") VALUES (278, 'Permanent lucerne og lucernegræs over 50% lucerne', 'Græs, permanent', '(afgrøden har ingen kategori)', 'lucerne');
INSERT INTO "afgroede_kategori" ("afgroedekode", "afgroedenavn", "afgroedegruppe", "afgroedekategori", "priskategori") VALUES (431, 'Purløg', 'Grøntsager, friland', 'løg', 'krydderurter');
INSERT INTO "afgroede_kategori" ("afgroedekode", "afgroedenavn", "afgroedegruppe", "afgroedekategori", "priskategori") VALUES (406, 'Grønkål', 'Grøntsager, friland', 'kål', 'kål');
INSERT INTO "afgroede_kategori" ("afgroedekode", "afgroedenavn", "afgroedegruppe", "afgroedekategori", "priskategori") VALUES (424, 'Ærter, konsum', 'Grøntsager, friland', 'ært', 'grøntsager');
INSERT INTO "afgroede_kategori" ("afgroedekode", "afgroedenavn", "afgroedegruppe", "afgroedekategori", "priskategori") VALUES (491, 'Storfrugtet tranebær', 'Småplanteproduktion og planteskoleplanter', '(afgrøden har ingen kategori)', 'potteplanter og stauder');
INSERT INTO "afgroede_kategori" ("afgroedekode", "afgroedenavn", "afgroedegruppe", "afgroedekategori", "priskategori") VALUES (576, 'skovrejsning (statslig) - forbedring af vandmiljø og grundvandsbeskyttelse', 'Trækulturer', '(afgrøden har ingen kategori)', 'skovdrift');
INSERT INTO "afgroede_kategori" ("afgroedekode", "afgroedenavn", "afgroedegruppe", "afgroedekategori", "priskategori") VALUES (605, 'MFO - Lavskov', 'Energiafgrøder og anden særlig produktion', '(afgrøden har ingen kategori)', 'Energiafgrøder');
INSERT INTO "afgroede_kategori" ("afgroedekode", "afgroedenavn", "afgroedegruppe", "afgroedekategori", "priskategori") VALUES (345, 'Brak langs vandløb og søer, sommerslåning (alternativ til efterafgrøder)', 'Udyrkede arealer, vildtagre o.l.', 'brak', 'brak');
INSERT INTO "afgroede_kategori" ("afgroedekode", "afgroedenavn", "afgroedegruppe", "afgroedekategori", "priskategori") VALUES (541, 'Agurker', 'Småplanteproduktion og planteskoleplanter', 'agurk', 'potteplanter og stauder');
INSERT INTO "afgroede_kategori" ("afgroedekode", "afgroedenavn", "afgroedegruppe", "afgroedekategori", "priskategori") VALUES (180, 'Gul sennep', 'Oliefrø og Bælgsæd', 'sennep', 'oliefrø');
INSERT INTO "afgroede_kategori" ("afgroedekode", "afgroedenavn", "afgroedegruppe", "afgroedekategori", "priskategori") VALUES (660, 'Persillefrø', 'Havefrø', 'persille', 'Havefrø');
INSERT INTO "afgroede_kategori" ("afgroedekode", "afgroedenavn", "afgroedegruppe", "afgroedekategori", "priskategori") VALUES (509, 'Trækvæde', 'Småplanteproduktion og planteskoleplanter', '(afgrøden har ingen kategori)', 'potteplanter og stauder');
INSERT INTO "afgroede_kategori" ("afgroedekode", "afgroedenavn", "afgroedegruppe", "afgroedekategori", "priskategori") VALUES (663, 'Pastinakfrø', 'Havefrø', 'pastinak', 'Havefrø');
INSERT INTO "afgroede_kategori" ("afgroedekode", "afgroedenavn", "afgroedegruppe", "afgroedekategori", "priskategori") VALUES (22, 'Vinterraps', 'Oliefrø og Bælgsæd', 'vinterraps', 'oliefrø');
INSERT INTO "afgroede_kategori" ("afgroedekode", "afgroedenavn", "afgroedegruppe", "afgroedekategori", "priskategori") VALUES (263, 'Græs uden kløvergræs (omdrift)', 'Græsmarksplanter, omdrift', 'græs eller andet grøntfoder', 'lucerne');
INSERT INTO "afgroede_kategori" ("afgroedekode", "afgroedenavn", "afgroedegruppe", "afgroedekategori", "priskategori") VALUES (271, 'Rekreative formål', 'Udyrkede arealer, vildtagre o.l.', '(afgrøden har ingen kategori)', 'brak');
INSERT INTO "afgroede_kategori" ("afgroedekode", "afgroedenavn", "afgroedegruppe", "afgroedekategori", "priskategori") VALUES (156, 'Kartofler, friteret/chips/pommes frites', 'Kartofler', 'kartoffel', 'chipskartofler');
INSERT INTO "afgroede_kategori" ("afgroedekode", "afgroedenavn", "afgroedegruppe", "afgroedekategori", "priskategori") VALUES (417, 'Rødbede', 'Grøntsager, friland', 'beder', 'grøntsager');
INSERT INTO "afgroede_kategori" ("afgroedekode", "afgroedenavn", "afgroedegruppe", "afgroedekategori", "priskategori") VALUES (493, 'Surbær ', 'Småplanteproduktion og planteskoleplanter', '(afgrøden har ingen kategori)', 'potteplanter og stauder');
INSERT INTO "afgroede_kategori" ("afgroedekode", "afgroedenavn", "afgroedegruppe", "afgroedekategori", "priskategori") VALUES (711, 'Grønkorn af vintertriticale', 'Korn, grønkorn', 'vintertriticale', 'vintertriticale');
INSERT INTO "afgroede_kategori" ("afgroedekode", "afgroedenavn", "afgroedegruppe", "afgroedekategori", "priskategori") VALUES (707, 'Grønkorn af vinterhvede', 'Korn, grønkorn', 'vinterhvede', 'vinterhvede');
INSERT INTO "afgroede_kategori" ("afgroedekode", "afgroedenavn", "afgroedegruppe", "afgroedekategori", "priskategori") VALUES (665, 'Havrerodfrø', 'Havefrø', 'havrerod', 'Havefrø');
INSERT INTO "afgroede_kategori" ("afgroedekode", "afgroedenavn", "afgroedegruppe", "afgroedekategori", "priskategori") VALUES (529, 'Pærer', 'Frugt og bær', '(afgrøden har ingen kategori)', 'frugt');
INSERT INTO "afgroede_kategori" ("afgroedekode", "afgroedenavn", "afgroedegruppe", "afgroedekategori", "priskategori") VALUES (282, 'Fodermarvkål', 'Andre foderafgrøder', 'kål', 'foderrodfrugter');
INSERT INTO "afgroede_kategori" ("afgroedekode", "afgroedenavn", "afgroedegruppe", "afgroedekategori", "priskategori") VALUES (149, 'Kartofler, lægge- (certificerede)', 'Kartofler', 'kartoffel', 'læggekartofler');
INSERT INTO "afgroede_kategori" ("afgroedekode", "afgroedenavn", "afgroedegruppe", "afgroedekategori", "priskategori") VALUES (173, 'Kløver til slæt', 'Kløver og lucerne i renbestand', 'kløver', 'kløver');
INSERT INTO "afgroede_kategori" ("afgroedekode", "afgroedenavn", "afgroedegruppe", "afgroedekategori", "priskategori") VALUES (577, 'Skov med biodiversitetsformål', 'Trækulturer', '(afgrøden har ingen kategori)', 'skovdrift');
INSERT INTO "afgroede_kategori" ("afgroedekode", "afgroedenavn", "afgroedegruppe", "afgroedekategori", "priskategori") VALUES (269, 'Græs, rullegræs', 'Græsmarksplanter, omdrift', 'græs eller andet grøntfoder', 'græs, sædskifte');
INSERT INTO "afgroede_kategori" ("afgroedekode", "afgroedenavn", "afgroedegruppe", "afgroedekategori", "priskategori") VALUES (311, 'Skovrejsning på tidl. landbrugsjord 1', 'Særlige afgrødekoder i forbindelse med tilsagn eller miljøtiltag', '(afgrøden har ingen kategori)', 'brak');
INSERT INTO "afgroede_kategori" ("afgroedekode", "afgroedenavn", "afgroedegruppe", "afgroedekategori", "priskategori") VALUES (505, 'Ribs, stiklingeopformering', 'Småplanteproduktion og planteskoleplanter', '(afgrøden har ingen kategori)', 'potteplanter og stauder');
INSERT INTO "afgroede_kategori" ("afgroedekode", "afgroedenavn", "afgroedegruppe", "afgroedekategori", "priskategori") VALUES (261, 'Kløvergræs, over 50% kløver (omdrift)', 'Græsmarksplanter, omdrift', 'græs eller andet grøntfoder', 'græs, sædskifte');
INSERT INTO "afgroede_kategori" ("afgroedekode", "afgroedenavn", "afgroedegruppe", "afgroedekategori", "priskategori") VALUES (103, 'Rajgræsfrø, ital.', 'Frøgræs', 'vårsået rajgræsfrø', 'Frøgræs');
INSERT INTO "afgroede_kategori" ("afgroedekode", "afgroedenavn", "afgroedegruppe", "afgroedekategori", "priskategori") VALUES (502, 'Blomsterløg', 'Småplanteproduktion og planteskoleplanter', 'planteskolekultur', 'potteplanter og stauder');
INSERT INTO "afgroede_kategori" ("afgroedekode", "afgroedenavn", "afgroedegruppe", "afgroedekategori", "priskategori") VALUES (280, 'Fodersukkerroer', 'Andre foderafgrøder', 'beder', 'foderrodfrugter');
INSERT INTO "afgroede_kategori" ("afgroedekode", "afgroedenavn", "afgroedegruppe", "afgroedekategori", "priskategori") VALUES (42, 'Hamp', 'Hør og Hamp', 'hamp', 'oliefrø');
INSERT INTO "afgroede_kategori" ("afgroedekode", "afgroedenavn", "afgroedegruppe", "afgroedekategori", "priskategori") VALUES (161, 'Cikorierødder', 'Rodfrugter til fabrik', 'cikorie', 'sukkeroer');
INSERT INTO "afgroede_kategori" ("afgroedekode", "afgroedenavn", "afgroedegruppe", "afgroedekategori", "priskategori") VALUES (121, 'Bælgplanter, frø', 'Frøgræs', 'vårsået blanding', 'Frøgræs');
INSERT INTO "afgroede_kategori" ("afgroedekode", "afgroedenavn", "afgroedegruppe", "afgroedekategori", "priskategori") VALUES (117, 'Rajgræs, efterårsudl. hybrid', 'Frøgræs', 'efterårssået rajgræsfrø', 'Frøgræs');
INSERT INTO "afgroede_kategori" ("afgroedekode", "afgroedenavn", "afgroedegruppe", "afgroedekategori", "priskategori") VALUES (420, 'Salat (friland)', 'Grøntsager, friland', 'salat', 'grøntsager');
INSERT INTO "afgroede_kategori" ("afgroedekode", "afgroedenavn", "afgroedegruppe", "afgroedekategori", "priskategori") VALUES (40, 'Oliehør', 'Hør og Hamp', 'hør', 'oliefrø');
INSERT INTO "afgroede_kategori" ("afgroedekode", "afgroedenavn", "afgroedegruppe", "afgroedekategori", "priskategori") VALUES (257, 'Permanent græs, uden kløver', 'Græs, permanent', '(afgrøden har ingen kategori)', 'græs, permanent');
INSERT INTO "afgroede_kategori" ("afgroedekode", "afgroedenavn", "afgroedegruppe", "afgroedekategori", "priskategori") VALUES (125, 'Bederoefrø', 'Frøgræs', 'beder', 'Frøgræs');
INSERT INTO "afgroede_kategori" ("afgroedekode", "afgroedenavn", "afgroedegruppe", "afgroedekategori", "priskategori") VALUES (113, 'Engrapsgræsfrø (plænetype)', 'Frøgræs', 'eng- og rapgræsfrø', 'Frøgræs');
INSERT INTO "afgroede_kategori" ("afgroedekode", "afgroedenavn", "afgroedegruppe", "afgroedekategori", "priskategori") VALUES (328, 'MFO-bræmme med blomsterblanding', 'Særlige afgrødekoder i forbindelse med tilsagn eller miljøtiltag', 'brak', 'brak');
INSERT INTO "afgroede_kategori" ("afgroedekode", "afgroedenavn", "afgroedegruppe", "afgroedekategori", "priskategori") VALUES (525, 'Sødkirsebær med undervækst af græs', 'Frugt og bær', '(afgrøden har ingen kategori)', 'bær');
INSERT INTO "afgroede_kategori" ("afgroedekode", "afgroedenavn", "afgroedegruppe", "afgroedekategori", "priskategori") VALUES (658, 'Gulerodsfrø', 'Havefrø', 'gulerod', 'Havefrø');
INSERT INTO "afgroede_kategori" ("afgroedekode", "afgroedenavn", "afgroedegruppe", "afgroedekategori", "priskategori") VALUES (587, 'Skovrejsning på tidl. landbrugsjord 3', 'Trækulturer', '(afgrøden har ingen kategori)', 'skovdrift');
INSERT INTO "afgroede_kategori" ("afgroedekode", "afgroedenavn", "afgroedegruppe", "afgroedekategori", "priskategori") VALUES (650, 'Chrysanthemum Garland, frø', 'Havefrø', 'chrysanthemum', 'Havefrø');
INSERT INTO "afgroede_kategori" ("afgroedekode", "afgroedenavn", "afgroedegruppe", "afgroedekategori", "priskategori") VALUES (120, 'Kløverfrø', 'Frøgræs', 'kløver', 'Frøgræs');
INSERT INTO "afgroede_kategori" ("afgroedekode", "afgroedenavn", "afgroedegruppe", "afgroedekategori", "priskategori") VALUES (15, 'Vinterhybridrug', 'Vintersæd til modenhed', 'vinterrug', 'vinterrug');
INSERT INTO "afgroede_kategori" ("afgroedekode", "afgroedenavn", "afgroedegruppe", "afgroedekategori", "priskategori") VALUES (578, 'Skovrejsning (privat) – forbedring af vandmiljø og grundvandsbeskyttelse', 'Trækulturer', '(afgrøden har ingen kategori)', 'skovdrift');
INSERT INTO "afgroede_kategori" ("afgroedekode", "afgroedenavn", "afgroedegruppe", "afgroedekategori", "priskategori") VALUES (703, 'Grønkorn af vårhavre', 'Korn, grønkorn', 'vårhavre', 'havre');
INSERT INTO "afgroede_kategori" ("afgroedekode", "afgroedenavn", "afgroedegruppe", "afgroedekategori", "priskategori") VALUES (210, 'Vårbyg, helsæd', 'Helsæd, vår', 'vårbyg', 'vårbyg');
INSERT INTO "afgroede_kategori" ("afgroedekode", "afgroedenavn", "afgroedegruppe", "afgroedekategori", "priskategori") VALUES (440, 'Solhat', 'Medicinplanter', 'solhat', 'potteplanter og stauder');
INSERT INTO "afgroede_kategori" ("afgroedekode", "afgroedenavn", "afgroedegruppe", "afgroedekategori", "priskategori") VALUES (710, 'Grønkorn af hybridrug', 'Korn, grønkorn', 'vinterrug', 'vinterrug');
INSERT INTO "afgroede_kategori" ("afgroedekode", "afgroedenavn", "afgroedegruppe", "afgroedekategori", "priskategori") VALUES (57, 'Vinterhavre', 'Vintersæd til modenhed', 'vinterhavre', 'havre');
INSERT INTO "afgroede_kategori" ("afgroedekode", "afgroedenavn", "afgroedegruppe", "afgroedekategori", "priskategori") VALUES (160, 'Sukkerroer til fabrik', 'Rodfrugter til fabrik', 'beder', 'sukkeroer');
INSERT INTO "afgroede_kategori" ("afgroedekode", "afgroedenavn", "afgroedegruppe", "afgroedekategori", "priskategori") VALUES (602, 'MFO - Pil', 'Energiafgrøder og anden særlig produktion', '(afgrøden har ingen kategori)', 'Energiafgrøder');
INSERT INTO "afgroede_kategori" ("afgroedekode", "afgroedenavn", "afgroedegruppe", "afgroedekategori", "priskategori") VALUES (506, 'Stikkelsbær, stiklingeopformering', 'Småplanteproduktion og planteskoleplanter', '(afgrøden har ingen kategori)', 'potteplanter og stauder');
INSERT INTO "afgroede_kategori" ("afgroedekode", "afgroedenavn", "afgroedegruppe", "afgroedekategori", "priskategori") VALUES (508, 'Andre af slægten Vaccinium', 'Småplanteproduktion og planteskoleplanter', '(afgrøden har ingen kategori)', 'potteplanter og stauder');
INSERT INTO "afgroede_kategori" ("afgroedekode", "afgroedenavn", "afgroedegruppe", "afgroedekategori", "priskategori") VALUES (251, 'Permanent græs, lavt udbytte', 'Græs, permanent', '(afgrøden har ingen kategori)', 'græs, permanent');
INSERT INTO "afgroede_kategori" ("afgroedekode", "afgroedenavn", "afgroedegruppe", "afgroedekategori", "priskategori") VALUES (705, 'Grønkorn af vårtriticale', 'Korn, grønkorn', 'vårtriticale', 'vårtriticale');
INSERT INTO "afgroede_kategori" ("afgroedekode", "afgroedenavn", "afgroedegruppe", "afgroedekategori", "priskategori") VALUES (599, 'Poppel (100-400 andre træer pr. ha)', 'Energiafgrøder og anden særlig produktion', '(afgrøden har ingen kategori)', 'Energiafgrøder');
INSERT INTO "afgroede_kategori" ("afgroedekode", "afgroedenavn", "afgroedegruppe", "afgroedekategori", "priskategori") VALUES (5, 'Majs til modenhed', 'Vårsæd til modenhed', 'majs', 'vårsæd til modenhed');
INSERT INTO "afgroede_kategori" ("afgroedekode", "afgroedenavn", "afgroedegruppe", "afgroedekategori", "priskategori") VALUES (266, 'Græs under 50% kløver/lucerne, ekstremt lavt udbytte (omdrift)', 'Græsmarksplanter, omdrift', 'græs eller andet grøntfoder', 'græs, sædskifte');
INSERT INTO "afgroede_kategori" ("afgroedekode", "afgroedenavn", "afgroedegruppe", "afgroedekategori", "priskategori") VALUES (104, 'Rajgræsfrø, ital. 1. år efterårsudlagt', 'Frøgræs', 'efterårssået rajgræsfrø', 'Frøgræs');
INSERT INTO "afgroede_kategori" ("afgroedekode", "afgroedenavn", "afgroedegruppe", "afgroedekategori", "priskategori") VALUES (171, 'Lucerne, slæt', 'Kløver og lucerne i renbestand', 'lucerne', 'lucerne');
INSERT INTO "afgroede_kategori" ("afgroedekode", "afgroedenavn", "afgroedegruppe", "afgroedekategori", "priskategori") VALUES (531, 'Anden træfrugt', 'Frugt og bær', '(afgrøden har ingen kategori)', 'frugt');
INSERT INTO "afgroede_kategori" ("afgroedekode", "afgroedenavn", "afgroedegruppe", "afgroedekategori", "priskategori") VALUES (604, 'MFO - El', 'Energiafgrøder og anden særlig produktion', '(afgrøden har ingen kategori)', 'Energiafgrøder');
INSERT INTO "afgroede_kategori" ("afgroedekode", "afgroedenavn", "afgroedegruppe", "afgroedekategori", "priskategori") VALUES (283, 'Fodergulerødder', 'Andre foderafgrøder', 'gulerod', 'foderrodfrugter');
INSERT INTO "afgroede_kategori" ("afgroedekode", "afgroedenavn", "afgroedegruppe", "afgroedekategori", "priskategori") VALUES (305, 'Permanent græs, uden udbetaling af økologi-tilskud', 'Udyrkede arealer, vildtagre o.l.', '(afgrøden har ingen kategori)', 'græs, permanent');
INSERT INTO "afgroede_kategori" ("afgroedekode", "afgroedenavn", "afgroedegruppe", "afgroedekategori", "priskategori") VALUES (54, 'Bælgsæd blanding', 'Oliefrø og Bælgsæd', 'vårsået blanding', 'Bælgsæd');
INSERT INTO "afgroede_kategori" ("afgroedekode", "afgroedenavn", "afgroedegruppe", "afgroedekategori", "priskategori") VALUES (4, 'Blanding af vårsåede arter', 'Vårsæd til modenhed', 'vårsået blanding', 'vårsæd til modenhed');
INSERT INTO "afgroede_kategori" ("afgroedekode", "afgroedenavn", "afgroedegruppe", "afgroedekategori", "priskategori") VALUES (361, 'Ikke støtteberettiget landbrugsareal', 'Særlige afgrødekoder i forbindelse med tilsagn eller miljøtiltag', '(afgrøden har ingen kategori)', 'brak');
INSERT INTO "afgroede_kategori" ("afgroedekode", "afgroedenavn", "afgroedegruppe", "afgroedekategori", "priskategori") VALUES (321, 'Miljøtiltag, ej landbrugsarealer', 'Særlige afgrødekoder i forbindelse med tilsagn eller miljøtiltag', '(afgrøden har ingen kategori)', 'brak');
INSERT INTO "afgroede_kategori" ("afgroedekode", "afgroedenavn", "afgroedegruppe", "afgroedekategori", "priskategori") VALUES (10, 'Vinterbyg', 'Vintersæd til modenhed', 'vinterbyg', 'vinterbyg');
INSERT INTO "afgroede_kategori" ("afgroedekode", "afgroedenavn", "afgroedegruppe", "afgroedekategori", "priskategori") VALUES (105, 'Timothefrø', 'Frøgræs', 'Timothefrø', 'Frøgræs');
INSERT INTO "afgroede_kategori" ("afgroedekode", "afgroedenavn", "afgroedegruppe", "afgroedekategori", "priskategori") VALUES (35, 'Bælgsæd, flerårig blanding', 'Oliefrø og Bælgsæd', 'vårsået blanding ', 'Bælgsæd');
INSERT INTO "afgroede_kategori" ("afgroedekode", "afgroedenavn", "afgroedegruppe", "afgroedekategori", "priskategori") VALUES (402, 'Bladselleri', 'Grøntsager, friland', 'selleri', 'grøntsager');
INSERT INTO "afgroede_kategori" ("afgroedekode", "afgroedenavn", "afgroedegruppe", "afgroedekategori", "priskategori") VALUES (6, 'Vårhvede, brødhvede', 'Vårsæd til modenhed', 'vårhvede', 'vårsæd til modenhed');
INSERT INTO "afgroede_kategori" ("afgroedekode", "afgroedenavn", "afgroedegruppe", "afgroedekategori", "priskategori") VALUES (107, 'Engsvingelfrø', 'Frøgræs', 'svingelfrø', 'Frøgræs');
INSERT INTO "afgroede_kategori" ("afgroedekode", "afgroedenavn", "afgroedegruppe", "afgroedekategori", "priskategori") VALUES (537, 'Valnød (almindelig)', 'Frugt og bær', '(afgrøden har ingen kategori)', 'bær');
INSERT INTO "afgroede_kategori" ("afgroedekode", "afgroedenavn", "afgroedegruppe", "afgroedekategori", "priskategori") VALUES (220, 'Vinterbyg, helsæd', 'Helsæd, vinter', 'vinterbyg', 'vinterbyg');
INSERT INTO "afgroede_kategori" ("afgroedekode", "afgroedenavn", "afgroedegruppe", "afgroedekategori", "priskategori") VALUES (400, 'Asieagurker', 'Grøntsager, friland', 'agurk', 'grøntsager');
INSERT INTO "afgroede_kategori" ("afgroedekode", "afgroedenavn", "afgroedegruppe", "afgroedekategori", "priskategori") VALUES (252, 'Permanent græs, normalt udbytte', 'Græs, permanent', '(afgrøden har ingen kategori)', 'græs, permanent');
INSERT INTO "afgroede_kategori" ("afgroedekode", "afgroedenavn", "afgroedegruppe", "afgroedekategori", "priskategori") VALUES (343, 'MFO-bestøverbrak', 'Særlige afgrødekoder i forbindelse med tilsagn eller miljøtiltag', 'brak', 'brak');
INSERT INTO "afgroede_kategori" ("afgroedekode", "afgroedenavn", "afgroedegruppe", "afgroedekategori", "priskategori") VALUES (31, 'Hestebønner', 'Oliefrø og Bælgsæd', 'hestebønne', 'Bælgsæd');
INSERT INTO "afgroede_kategori" ("afgroedekode", "afgroedenavn", "afgroedegruppe", "afgroedekategori", "priskategori") VALUES (596, 'Elefantgræs', 'Energiafgrøder og anden særlig produktion', '(afgrøden har ingen kategori)', 'Energiafgrøder');
INSERT INTO "afgroede_kategori" ("afgroedekode", "afgroedenavn", "afgroedegruppe", "afgroedekategori", "priskategori") VALUES (285, 'Græs og kløvergræs uden norm, over 50 % kløver (omdrift)', 'Græsmarksplanter, omdrift', 'græs eller andet grøntfoder', 'græs, sædskifte');
INSERT INTO "afgroede_kategori" ("afgroedekode", "afgroedenavn", "afgroedegruppe", "afgroedekategori", "priskategori") VALUES (327, 'MFO-bræmme, sommerslåning', 'Særlige afgrødekoder i forbindelse med tilsagn eller miljøtiltag', 'brak', 'brak');
INSERT INTO "afgroede_kategori" ("afgroedekode", "afgroedenavn", "afgroedegruppe", "afgroedekategori", "priskategori") VALUES (253, 'Miljøgræs MVJ-tilsagn (80 N), omdrift', 'Arealer med tilsagn under miljøordningerne', 'græs eller andet grøntfoder', 'græs, sædskifte');
INSERT INTO "afgroede_kategori" ("afgroedekode", "afgroedenavn", "afgroedegruppe", "afgroedekategori", "priskategori") VALUES (14, 'Vinterrug', 'Vintersæd til modenhed', 'vinterrug', 'vinterrug');
INSERT INTO "afgroede_kategori" ("afgroedekode", "afgroedenavn", "afgroedegruppe", "afgroedekategori", "priskategori") VALUES (581, 'Skovdrift med fjernelse af ved', 'Trækulturer', '(afgrøden har ingen kategori)', 'skovdrift');
INSERT INTO "afgroede_kategori" ("afgroedekode", "afgroedenavn", "afgroedegruppe", "afgroedekategori", "priskategori") VALUES (497, 'Planteskolekulturer, vedplanter, til videresalg', 'Småplanteproduktion og planteskoleplanter', '(afgrøden har ingen kategori)', 'potteplanter og stauder');
INSERT INTO "afgroede_kategori" ("afgroedekode", "afgroedenavn", "afgroedegruppe", "afgroedekategori", "priskategori") VALUES (661, 'Kørvelfrø', 'Havefrø', 'kørvel', 'Havefrø');
INSERT INTO "afgroede_kategori" ("afgroedekode", "afgroedenavn", "afgroedegruppe", "afgroedekategori", "priskategori") VALUES (512, 'Rabarber', 'Frugt og bær', '(afgrøden har ingen kategori)', 'frugt');
INSERT INTO "afgroede_kategori" ("afgroedekode", "afgroedenavn", "afgroedegruppe", "afgroedekategori", "priskategori") VALUES (109, 'Rajsvingelfrø', 'Frøgræs', 'vårssået rajsvingelfrø', 'Frøgræs');
INSERT INTO "afgroede_kategori" ("afgroedekode", "afgroedenavn", "afgroedegruppe", "afgroedekategori", "priskategori") VALUES (523, 'Blomme med undervækst af græs', 'Frugt og bær', '(afgrøden har ingen kategori)', 'bær');
INSERT INTO "afgroede_kategori" ("afgroedekode", "afgroedenavn", "afgroedegruppe", "afgroedekategori", "priskategori") VALUES (13, 'Vinterhvede, brødhvede', 'Vintersæd til modenhed', 'vinterhvede', 'vinterhvede');
INSERT INTO "afgroede_kategori" ("afgroedekode", "afgroedenavn", "afgroedegruppe", "afgroedekategori", "priskategori") VALUES (155, 'Kartofler, pulver/granules-', 'Kartofler', 'kartoffel', 'processkartofler');
INSERT INTO "afgroede_kategori" ("afgroedekode", "afgroedenavn", "afgroedegruppe", "afgroedekategori", "priskategori") VALUES (416, 'Rosenkål', 'Grøntsager, friland', 'kål', 'kål');
INSERT INTO "afgroede_kategori" ("afgroedekode", "afgroedenavn", "afgroedegruppe", "afgroedekategori", "priskategori") VALUES (487, 'Skovlandbrug', 'Trækulturer', '(afgrøden har ingen kategori)', 'skovdrift');
INSERT INTO "afgroede_kategori" ("afgroedekode", "afgroedenavn", "afgroedegruppe", "afgroedekategori", "priskategori") VALUES (2, 'Vårhvede', 'Vårsæd til modenhed', 'vårhvede', 'vårsæd til modenhed');
INSERT INTO "afgroede_kategori" ("afgroedekode", "afgroedenavn", "afgroedegruppe", "afgroedekategori", "priskategori") VALUES (339, 'MFO-brak, forårsslåning', 'Udyrkede arealer, vildtagre o.l.', 'brak', 'brak');
INSERT INTO "afgroede_kategori" ("afgroedekode", "afgroedenavn", "afgroedegruppe", "afgroedekategori", "priskategori") VALUES (538, 'Kastanje (ægte)', 'Frugt og bær', '(afgrøden har ingen kategori)', 'bær');
INSERT INTO "afgroede_kategori" ("afgroedekode", "afgroedenavn", "afgroedegruppe", "afgroedekategori", "priskategori") VALUES (344, 'Brak langs vandløb og søer, forårsslåning (alternativ til efterafgrøder)', 'Udyrkede arealer, vildtagre o.l.', 'brak', 'brak');
INSERT INTO "afgroede_kategori" ("afgroedekode", "afgroedenavn", "afgroedegruppe", "afgroedekategori", "priskategori") VALUES (335, 'MFO-bræmme, permanent græs, forårsslåning', 'Særlige afgrødekoder i forbindelse med tilsagn eller miljøtiltag', '(afgrøden har ingen kategori)', 'græs, permanent');
INSERT INTO "afgroede_kategori" ("afgroedekode", "afgroedenavn", "afgroedegruppe", "afgroedekategori", "priskategori") VALUES (152, 'Kartofler, spise- (pakkeri, vejsalg)', 'Kartofler', 'kartoffel', 'spisekartofler');
INSERT INTO "afgroede_kategori" ("afgroedekode", "afgroedenavn", "afgroedegruppe", "afgroedekategori", "priskategori") VALUES (410, 'Knoldselleri', 'Grøntsager, friland', 'selleri', 'grøntsager');
INSERT INTO "afgroede_kategori" ("afgroedekode", "afgroedenavn", "afgroedegruppe", "afgroedekategori", "priskategori") VALUES (534, 'Hyben', 'Frugt og bær', '(afgrøden har ingen kategori)', 'frugt');
INSERT INTO "afgroede_kategori" ("afgroedekode", "afgroedenavn", "afgroedegruppe", "afgroedekategori", "priskategori") VALUES (603, 'MFO - Poppel (0-100 andre træer pr. ha)', 'Energiafgrøder og anden særlig produktion', '(afgrøden har ingen kategori)', 'Energiafgrøder');
INSERT INTO "afgroede_kategori" ("afgroedekode", "afgroedenavn", "afgroedegruppe", "afgroedekategori", "priskategori") VALUES (591, 'Lavskov', 'Energiafgrøder og anden særlig produktion', '(afgrøden har ingen kategori)', 'Energiafgrøder');
INSERT INTO "afgroede_kategori" ("afgroedekode", "afgroedenavn", "afgroedegruppe", "afgroedekategori", "priskategori") VALUES (230, 'Blanding af vårkorn, grønkorn', 'Korn, grønkorn', 'vårsået blanding', 'vårkorn blanding');
INSERT INTO "afgroede_kategori" ("afgroedekode", "afgroedenavn", "afgroedegruppe", "afgroedekategori", "priskategori") VALUES (7, 'Korn og bælgsæd under 50% bælgsæd', 'Vårsæd til modenhed', 'vårsået blanding', 'vårsæd til modenhed');
INSERT INTO "afgroede_kategori" ("afgroedekode", "afgroedenavn", "afgroedegruppe", "afgroedekategori", "priskategori") VALUES (222, 'Vinterrug, helsæd', 'Helsæd, vinter', 'vinterrug', 'vinterrug');
INSERT INTO "afgroede_kategori" ("afgroedekode", "afgroedenavn", "afgroedegruppe", "afgroedekategori", "priskategori") VALUES (651, 'Dildfrø', 'Havefrø', 'dild', 'Havefrø');
INSERT INTO "afgroede_kategori" ("afgroedekode", "afgroedenavn", "afgroedegruppe", "afgroedekategori", "priskategori") VALUES (597, 'Rørgræs', 'Energiafgrøder og anden særlig produktion', '(afgrøden har ingen kategori)', 'Energiafgrøder');
INSERT INTO "afgroede_kategori" ("afgroedekode", "afgroedenavn", "afgroedegruppe", "afgroedekategori", "priskategori") VALUES (503, 'En- og to-årige planter', 'Småplanteproduktion og planteskoleplanter', 'planteskolekultur', 'potteplanter og stauder');
INSERT INTO "afgroede_kategori" ("afgroedekode", "afgroedenavn", "afgroedegruppe", "afgroedekategori", "priskategori") VALUES (254, 'Miljøgræs MVJ-tilsagn (0 N), permanent', 'Arealer med tilsagn under miljøordningerne', '(afgrøden har ingen kategori)', 'græs, permanent');
INSERT INTO "afgroede_kategori" ("afgroedekode", "afgroedenavn", "afgroedegruppe", "afgroedekategori", "priskategori") VALUES (548, 'Småplanter, en-årige', 'Småplanteproduktion og planteskoleplanter', 'planteskolekultur', 'potteplanter og stauder');
INSERT INTO "afgroede_kategori" ("afgroedekode", "afgroedenavn", "afgroedegruppe", "afgroedekategori", "priskategori") VALUES (217, 'Korn og bælgsæd, helsæd, over 50% bælgsæd', 'Helsæd, vår', 'vårsået blanding', 'helsæd, vår');
INSERT INTO "afgroede_kategori" ("afgroedekode", "afgroedenavn", "afgroedegruppe", "afgroedekategori", "priskategori") VALUES (432, 'Krydderurter (undtagen persille og purløg)', 'Grøntsager, friland', 'planteskolekultur', 'krydderurter');
INSERT INTO "afgroede_kategori" ("afgroedekode", "afgroedenavn", "afgroedegruppe", "afgroedekategori", "priskategori") VALUES (250, 'Permanent græs, meget lavt udbytte', 'Græs, permanent', '(afgrøden har ingen kategori)', 'græs, permanent');
INSERT INTO "afgroede_kategori" ("afgroedekode", "afgroedenavn", "afgroedegruppe", "afgroedekategori", "priskategori") VALUES (709, 'Grønkorn af vinterrug', 'Korn, grønkorn', 'vinterrug', 'vinterrug');
INSERT INTO "afgroede_kategori" ("afgroedekode", "afgroedenavn", "afgroedegruppe", "afgroedekategori", "priskategori") VALUES (501, 'Stauder', 'Småplanteproduktion og planteskoleplanter', 'planteskolekultur', 'potteplanter og stauder');
INSERT INTO "afgroede_kategori" ("afgroedekode", "afgroedenavn", "afgroedegruppe", "afgroedekategori", "priskategori") VALUES (545, 'Potteplanter', 'Småplanteproduktion og planteskoleplanter', '(afgrøden har ingen kategori)', 'potteplanter og stauder');
INSERT INTO "afgroede_kategori" ("afgroedekode", "afgroedenavn", "afgroedegruppe", "afgroedekategori", "priskategori") VALUES (182, 'Blanding af oliearter', 'Oliefrø og Bælgsæd', 'vårsået blanding', 'oliefrø');
INSERT INTO "afgroede_kategori" ("afgroedekode", "afgroedenavn", "afgroedegruppe", "afgroedekategori", "priskategori") VALUES (319, 'MFO-brak, Udtagning, ej landbrugsareal', 'Særlige afgrødekoder i forbindelse med tilsagn eller miljøtiltag', '(afgrøden har ingen kategori)', 'brak');
INSERT INTO "afgroede_kategori" ("afgroedekode", "afgroedenavn", "afgroedegruppe", "afgroedekategori", "priskategori") VALUES (1, 'Vårbyg', 'Vårsæd til modenhed', 'vårbyg', 'vårbyg');
INSERT INTO "afgroede_kategori" ("afgroedekode", "afgroedenavn", "afgroedegruppe", "afgroedekategori", "priskategori") VALUES (106, 'Hundegræsfrø', 'Frøgræs', 'hundegræsfrø', 'Frøgræs');
INSERT INTO "afgroede_kategori" ("afgroedekode", "afgroedenavn", "afgroedegruppe", "afgroedekategori", "priskategori") VALUES (517, 'Brombær', 'Frugt og bær', '(afgrøden har ingen kategori)', 'bær');
INSERT INTO "afgroede_kategori" ("afgroedekode", "afgroedenavn", "afgroedegruppe", "afgroedekategori", "priskategori") VALUES (18, 'Korn og bælgsæd over 50% bælgsæd', 'Vårsæd til modenhed', 'vårsået blanding', 'vårsæd til modenhed');
INSERT INTO "afgroede_kategori" ("afgroedekode", "afgroedenavn", "afgroedegruppe", "afgroedekategori", "priskategori") VALUES (528, 'Æbler', 'Frugt og bær', '(afgrøden har ingen kategori)', 'frugt');
INSERT INTO "afgroede_kategori" ("afgroedekode", "afgroedenavn", "afgroedegruppe", "afgroedekategori", "priskategori") VALUES (110, 'Svingelfrø, bakke- (tidl. Stivbladet)', 'Frøgræs', 'svingelfrø', 'Frøgræs');
INSERT INTO "afgroede_kategori" ("afgroedekode", "afgroedenavn", "afgroedegruppe", "afgroedekategori", "priskategori") VALUES (563, 'Svampe, champignon', 'Småplanteproduktion og planteskoleplanter', '(afgrøden har ingen kategori)', 'potteplanter og stauder');
INSERT INTO "afgroede_kategori" ("afgroedekode", "afgroedenavn", "afgroedegruppe", "afgroedekategori", "priskategori") VALUES (496, 'Medicinpl., vedplanter', 'Medicinplanter', '(afgrøden har ingen kategori)', 'potteplanter og stauder');
INSERT INTO "afgroede_kategori" ("afgroedekode", "afgroedenavn", "afgroedegruppe", "afgroedekategori", "priskategori") VALUES (58, 'Sorghum', 'Vårsæd til modenhed', 'sorghum', 'vårsæd til modenhed');
INSERT INTO "afgroede_kategori" ("afgroedekode", "afgroedenavn", "afgroedegruppe", "afgroedekategori", "priskategori") VALUES (8, 'Vårspelt', 'Vårsæd til modenhed', 'vårspelt', 'vårsæd til modenhed');
INSERT INTO "afgroede_kategori" ("afgroedekode", "afgroedenavn", "afgroedegruppe", "afgroedekategori", "priskategori") VALUES (585, 'Skovrejsning i projektområde, som ikke er omfattet af tilsagn', 'Trækulturer', '(afgrøden har ingen kategori)', 'skovdrift');
INSERT INTO "afgroede_kategori" ("afgroedekode", "afgroedenavn", "afgroedegruppe", "afgroedekategori", "priskategori") VALUES (667, 'Timianfrø', 'Havefrø', 'timian', 'Havefrø');
INSERT INTO "afgroede_kategori" ("afgroedekode", "afgroedenavn", "afgroedegruppe", "afgroedekategori", "priskategori") VALUES (668, 'Blomsterfrø', 'Havefrø', 'planteskolekultur', 'Havefrø');
INSERT INTO "afgroede_kategori" ("afgroedekode", "afgroedenavn", "afgroedegruppe", "afgroedekategori", "priskategori") VALUES (708, 'Grønkorn af vinterhavre', 'Korn, grønkorn', 'vinterhavre', 'havre');
INSERT INTO "afgroede_kategori" ("afgroedekode", "afgroedenavn", "afgroedegruppe", "afgroedekategori", "priskategori") VALUES (267, 'Græs  under 50% kløver/lucerne, meget lavt udbytte (omdrift)', 'Græsmarksplanter, omdrift', 'græs eller andet grøntfoder', 'græs, sædskifte');
INSERT INTO "afgroede_kategori" ("afgroedekode", "afgroedenavn", "afgroedegruppe", "afgroedekategori", "priskategori") VALUES (448, 'Medicinpl., en- og toårige', 'Medicinplanter', 'planteskolekultur', 'potteplanter og stauder');
INSERT INTO "afgroede_kategori" ("afgroedekode", "afgroedenavn", "afgroedegruppe", "afgroedekategori", "priskategori") VALUES (52, 'Quinoa', 'Hør og Hamp', 'quinoa', 'oliefrø');
INSERT INTO "afgroede_kategori" ("afgroedekode", "afgroedenavn", "afgroedegruppe", "afgroedekategori", "priskategori") VALUES (701, 'Grønkorn af vårbyg', 'Korn, grønkorn', 'vårbyg', 'vårbyg');
INSERT INTO "afgroede_kategori" ("afgroedekode", "afgroedenavn", "afgroedegruppe", "afgroedekategori", "priskategori") VALUES (162, 'Blanding, andre industriafgr.', 'Rodfrugter til fabrik', 'vintersået blanding', 'sukkeroer');
INSERT INTO "afgroede_kategori" ("afgroedekode", "afgroedenavn", "afgroedegruppe", "afgroedekategori", "priskategori") VALUES (514, 'Solbær', 'Frugt og bær', '(afgrøden har ingen kategori)', 'bær');
INSERT INTO "afgroede_kategori" ("afgroedekode", "afgroedenavn", "afgroedegruppe", "afgroedekategori", "priskategori") VALUES (450, 'Grøntsager, blandinger', 'Grøntsager, friland', 'vårsået blanding', 'grøntsager');
INSERT INTO "afgroede_kategori" ("afgroedekode", "afgroedenavn", "afgroedegruppe", "afgroedekategori", "priskategori") VALUES (322, 'Minivådområder, projekttilsagn', 'Særlige afgrødekoder i forbindelse med tilsagn eller miljøtiltag', '(afgrøden har ingen kategori)', 'brak');
INSERT INTO "afgroede_kategori" ("afgroedekode", "afgroedenavn", "afgroedegruppe", "afgroedekategori", "priskategori") VALUES (582, 'Pyntegrønt, økologisk jordbrug', 'Trækulturer', '(afgrøden har ingen kategori)', 'skovdrift');
INSERT INTO "afgroede_kategori" ("afgroedekode", "afgroedenavn", "afgroedegruppe", "afgroedekategori", "priskategori") VALUES (900, 'Øvrige afgrøder', 'Øvrige afgrøder', '(afgrøden har ingen kategori)', 'Brak');
INSERT INTO "afgroede_kategori" ("afgroedekode", "afgroedenavn", "afgroedegruppe", "afgroedekategori", "priskategori") VALUES (405, 'Courgette, squash', 'Grøntsager, friland', 'mandelgræskar', 'grøntsager');
INSERT INTO "afgroede_kategori" ("afgroedekode", "afgroedenavn", "afgroedegruppe", "afgroedekategori", "priskategori") VALUES (170, 'Græs til fabrik (omdrift)', 'Græsmarksplanter, omdrift', 'græs eller andet grøntfoder', 'græs, sædskifte');
INSERT INTO "afgroede_kategori" ("afgroedekode", "afgroedenavn", "afgroedegruppe", "afgroedekategori", "priskategori") VALUES (276, 'Permanent græs og kløvergræs uden norm, under 50 % kløver', 'Græs, permanent', '(afgrøden har ingen kategori)', 'græs, permanent');
INSERT INTO "afgroede_kategori" ("afgroedekode", "afgroedenavn", "afgroedegruppe", "afgroedekategori", "priskategori") VALUES (513, 'Jordbær', 'Frugt og bær', 'jordbær', 'bær');
INSERT INTO "afgroede_kategori" ("afgroedekode", "afgroedenavn", "afgroedegruppe", "afgroedekategori", "priskategori") VALUES (101, 'Rajgræsfrø, alm.', 'Frøgræs', 'vårsået rajgræsfrø', 'Frøgræs');
INSERT INTO "afgroede_kategori" ("afgroedekode", "afgroedenavn", "afgroedegruppe", "afgroedekategori", "priskategori") VALUES (262, 'Lucernegræs, over 50% lucerne (omdrift)', 'Græsmarksplanter, omdrift', 'græs eller andet grøntfoder', 'græs, sædskifte');
INSERT INTO "afgroede_kategori" ("afgroedekode", "afgroedenavn", "afgroedegruppe", "afgroedekategori", "priskategori") VALUES (337, 'MFO-bræmme, permanent græs, miljøtilsagn', 'Særlige afgrødekoder i forbindelse med tilsagn eller miljøtiltag', '(afgrøden har ingen kategori)', 'græs, permanent');
INSERT INTO "afgroede_kategori" ("afgroedekode", "afgroedenavn", "afgroedegruppe", "afgroedekategori", "priskategori") VALUES (115, 'Hvenefrø, alm. og krybende', 'Frøgræs', 'hvenefrø', 'Frøgræs');
INSERT INTO "afgroede_kategori" ("afgroedekode", "afgroedenavn", "afgroedegruppe", "afgroedekategori", "priskategori") VALUES (114, 'Rapgræsfrø, alm.', 'Frøgræs', 'eng- og rapgræsfrø', 'Frøgræs');
INSERT INTO "afgroede_kategori" ("afgroedekode", "afgroedenavn", "afgroedegruppe", "afgroedekategori", "priskategori") VALUES (504, 'Solbær, stiklingeopformering', 'Småplanteproduktion og planteskoleplanter', '(afgrøden har ingen kategori)', 'potteplanter og stauder');
INSERT INTO "afgroede_kategori" ("afgroedekode", "afgroedenavn", "afgroedegruppe", "afgroedekategori", "priskategori") VALUES (415, 'Porre', 'Grøntsager, friland', 'løg', 'grøntsager');
INSERT INTO "afgroede_kategori" ("afgroedekode", "afgroedenavn", "afgroedegruppe", "afgroedekategori", "priskategori") VALUES (112, 'Engrapgræsfrø (marktype)', 'Frøgræs', 'eng- og rapgræsfrø', 'Frøgræs');
INSERT INTO "afgroede_kategori" ("afgroedekode", "afgroedenavn", "afgroedegruppe", "afgroedekategori", "priskategori") VALUES (108, 'Rødsvingelfrø', 'Frøgræs', 'svingelfrø', 'Frøgræs');
INSERT INTO "afgroede_kategori" ("afgroedekode", "afgroedenavn", "afgroedegruppe", "afgroedekategori", "priskategori") VALUES (547, 'Planteskolekulturer, stauder', 'Småplanteproduktion og planteskoleplanter', 'planteskolekultur', 'potteplanter og stauder');
INSERT INTO "afgroede_kategori" ("afgroedekode", "afgroedenavn", "afgroedegruppe", "afgroedekategori", "priskategori") VALUES (408, 'Hvidkål', 'Grøntsager, friland', 'kål', 'kål');
INSERT INTO "afgroede_kategori" ("afgroedekode", "afgroedenavn", "afgroedegruppe", "afgroedekategori", "priskategori") VALUES (268, 'Græs under 50% kløver/lucerne, lavt udbytte (omdrift)', 'Græsmarksplanter, omdrift', 'græs eller andet grøntfoder', 'græs, sædskifte');
INSERT INTO "afgroede_kategori" ("afgroedekode", "afgroedenavn", "afgroedegruppe", "afgroedekategori", "priskategori") VALUES (518, 'Hindbær', 'Frugt og bær', '(afgrøden har ingen kategori)', 'bær');
INSERT INTO "afgroede_kategori" ("afgroedekode", "afgroedenavn", "afgroedegruppe", "afgroedekategori", "priskategori") VALUES (589, 'Bæredygtig skovdrift', 'Trækulturer', '(afgrøden har ingen kategori)', 'skovdrift');
INSERT INTO "afgroede_kategori" ("afgroedekode", "afgroedenavn", "afgroedegruppe", "afgroedekategori", "priskategori") VALUES (583, 'Juletræer og pyntegrønt', 'Trækulturer', '(afgrøden har ingen kategori)', 'skovdrift');
INSERT INTO "afgroede_kategori" ("afgroedekode", "afgroedenavn", "afgroedegruppe", "afgroedekategori", "priskategori") VALUES (124, 'Spinatfrø', 'Frøgræs', 'spinat', 'Frøgræs');
INSERT INTO "afgroede_kategori" ("afgroedekode", "afgroedenavn", "afgroedegruppe", "afgroedekategori", "priskategori") VALUES (522, 'Blomme uden undervækst af græs', 'Frugt og bær', '(afgrøden har ingen kategori)', 'bær');
INSERT INTO "afgroede_kategori" ("afgroedekode", "afgroedenavn", "afgroedegruppe", "afgroedekategori", "priskategori") VALUES (329, 'MFO-bræmme, miljøtilsagn', 'Særlige afgrødekoder i forbindelse med tilsagn eller miljøtiltag', 'brak', 'brak');
INSERT INTO "afgroede_kategori" ("afgroedekode", "afgroedenavn", "afgroedegruppe", "afgroedekategori", "priskategori") VALUES (11, 'Vinterhvede', 'Vintersæd til modenhed', 'vinterhvede', 'vinterhvede');
INSERT INTO "afgroede_kategori" ("afgroedekode", "afgroedenavn", "afgroedegruppe", "afgroedekategori", "priskategori") VALUES (575, 'Skovrejsning (privat) - kulstofbinding og grundvandsbeskyttelse', 'Trækulturer', '(afgrøden har ingen kategori)', 'skovdrift');
INSERT INTO "afgroede_kategori" ("afgroedekode", "afgroedenavn", "afgroedegruppe", "afgroedekategori", "priskategori") VALUES (401, 'Asparges', 'Grøntsager, friland', '(afgrøden har ingen kategori)', 'grøntsager');
INSERT INTO "afgroede_kategori" ("afgroedekode", "afgroedenavn", "afgroedegruppe", "afgroedekategori", "priskategori") VALUES (490, 'Hassel, træ (Corylus avellana)', 'Frugt og bær', '(afgrøden har ingen kategori)', 'bær');
INSERT INTO "afgroede_kategori" ("afgroedekode", "afgroedenavn", "afgroedegruppe", "afgroedekategori", "priskategori") VALUES (527, 'Hassel (Corylus maxima)', 'Frugt og bær', '(afgrøden har ingen kategori)', 'bær');
INSERT INTO "afgroede_kategori" ("afgroedekode", "afgroedenavn", "afgroedegruppe", "afgroedekategori", "priskategori") VALUES (235, 'Blanding af vinterkorn, grønkorn', 'Korn, grønkorn', 'vintersået blanding', 'vinterkorn blanding');
INSERT INTO "afgroede_kategori" ("afgroedekode", "afgroedenavn", "afgroedegruppe", "afgroedekategori", "priskategori") VALUES (590, 'Bæredygtig skovdrift i Natura 2000-område', 'Trækulturer', '(afgrøden har ingen kategori)', 'skovdrift');
INSERT INTO "afgroede_kategori" ("afgroedekode", "afgroedenavn", "afgroedegruppe", "afgroedekategori", "priskategori") VALUES (659, 'Kålfrø (hvid- og rødkål)', 'Havefrø', 'kål', 'Havefrø');
INSERT INTO "afgroede_kategori" ("afgroedekode", "afgroedenavn", "afgroedegruppe", "afgroedekategori", "priskategori") VALUES (306, 'Græs i omdrift, uden udbetaling af økologi-tilskud', 'Udyrkede arealer, vildtagre o.l.', 'græs eller andet grøntfoder', 'græs, sædskifte');
INSERT INTO "afgroede_kategori" ("afgroedekode", "afgroedenavn", "afgroedegruppe", "afgroedekategori", "priskategori") VALUES (286, 'Permanent græs og kløvergræs uden norm, over 50 % kløver', 'Græs, permanent', '(afgrøden har ingen kategori)', 'græs, permanent');
INSERT INTO "afgroede_kategori" ("afgroedekode", "afgroedenavn", "afgroedegruppe", "afgroedekategori", "priskategori") VALUES (507, 'Hindbær, stiklingeopformering', 'Småplanteproduktion og planteskoleplanter', '(afgrøden har ingen kategori)', 'potteplanter og stauder');
INSERT INTO "afgroede_kategori" ("afgroedekode", "afgroedenavn", "afgroedegruppe", "afgroedekategori", "priskategori") VALUES (279, 'Permanent kløvergræs til fabrik', 'Græs, permanent', '(afgrøden har ingen kategori)', 'græs, permanent');
INSERT INTO "afgroede_kategori" ("afgroedekode", "afgroedenavn", "afgroedegruppe", "afgroedekategori", "priskategori") VALUES (214, 'Korn og bælgsæd, helsæd, under 50% bælgsæd', 'Helsæd, vår', 'vårsået blanding', 'helsæd, vår');
INSERT INTO "afgroede_kategori" ("afgroedekode", "afgroedenavn", "afgroedegruppe", "afgroedekategori", "priskategori") VALUES (9, 'Vinterspelt', 'Vintersæd til modenhed', 'vinterspelt', 'vinterkorn blanding');
INSERT INTO "afgroede_kategori" ("afgroedekode", "afgroedenavn", "afgroedegruppe", "afgroedekategori", "priskategori") VALUES (338, 'Brak, forårsslåning', 'Udyrkede arealer, vildtagre o.l.', 'brak', 'brak');
INSERT INTO "afgroede_kategori" ("afgroedekode", "afgroedenavn", "afgroedegruppe", "afgroedekategori", "priskategori") VALUES (903, 'Lysåbne arealer i skov', 'Øvrige afgrøder', '(afgrøden har ingen kategori)', 'Brak');
INSERT INTO "afgroede_kategori" ("afgroedekode", "afgroedenavn", "afgroedegruppe", "afgroedekategori", "priskategori") VALUES (543, 'Grøntsager, andre (drivhus)', 'Småplanteproduktion og planteskoleplanter', 'planteskolekultur', 'potteplanter og stauder');
INSERT INTO "afgroede_kategori" ("afgroedekode", "afgroedenavn", "afgroedegruppe", "afgroedekategori", "priskategori") VALUES (664, 'Skorzonerrod/skorzonerrodfrø', 'Havefrø', 'skorzonerrod', 'Havefrø');
INSERT INTO "afgroede_kategori" ("afgroedekode", "afgroedenavn", "afgroedegruppe", "afgroedekategori", "priskategori") VALUES (412, 'Pastinak', 'Grøntsager, friland', 'pastinak', 'grøntsager');
INSERT INTO "afgroede_kategori" ("afgroedekode", "afgroedenavn", "afgroedegruppe", "afgroedekategori", "priskategori") VALUES (551, 'Moskusgræskar', 'Frugt og bær', 'moskusgræskar', 'grøntsager');
INSERT INTO "afgroede_kategori" ("afgroedekode", "afgroedenavn", "afgroedegruppe", "afgroedekategori", "priskategori") VALUES (532, 'Anden buskfrugt', 'Frugt og bær', '(afgrøden har ingen kategori)', 'frugt');
INSERT INTO "afgroede_kategori" ("afgroedekode", "afgroedenavn", "afgroedegruppe", "afgroedekategori", "priskategori") VALUES (564, 'Containerplads', 'Småplanteproduktion og planteskoleplanter', '(afgrøden har ingen kategori)', 'brak');
INSERT INTO "afgroede_kategori" ("afgroedekode", "afgroedenavn", "afgroedegruppe", "afgroedekategori", "priskategori") VALUES (535, 'Bærmispel', 'Frugt og bær', '(afgrøden har ingen kategori)', 'frugt');
INSERT INTO "afgroede_kategori" ("afgroedekode", "afgroedenavn", "afgroedegruppe", "afgroedekategori", "priskategori") VALUES (592, 'Pil', 'Energiafgrøder og anden særlig produktion', '(afgrøden har ingen kategori)', 'Energiafgrøder');
INSERT INTO "afgroede_kategori" ("afgroedekode", "afgroedenavn", "afgroedegruppe", "afgroedekategori", "priskategori") VALUES (281, 'Kålroer', 'Andre foderafgrøder', 'vårraps', 'foderrodfrugter');
INSERT INTO "afgroede_kategori" ("afgroedekode", "afgroedenavn", "afgroedegruppe", "afgroedekategori", "priskategori") VALUES (579, 'Tagetes, sygdomssanerende plante', 'Udyrkede arealer, vildtagre o.l.', 'tagetes', 'potteplanter og stauder');
INSERT INTO "afgroede_kategori" ("afgroedekode", "afgroedenavn", "afgroedegruppe", "afgroedekategori", "priskategori") VALUES (510, 'Melon', 'Frugt og bær', 'melon', 'frugt');
INSERT INTO "afgroede_kategori" ("afgroedekode", "afgroedenavn", "afgroedegruppe", "afgroedekategori", "priskategori") VALUES (553, 'Centnergræskar', 'Frugt og bær', 'centnergræskar', 'grøntsager');
INSERT INTO "afgroede_kategori" ("afgroedekode", "afgroedenavn", "afgroedegruppe", "afgroedekategori", "priskategori") VALUES (259, 'Permanent græs, fabrik, over 6 tons', 'Græs, permanent', '(afgrøden har ingen kategori)', 'græs, permanent');
INSERT INTO "afgroede_kategori" ("afgroedekode", "afgroedenavn", "afgroedegruppe", "afgroedekategori", "priskategori") VALUES (519, 'Blåbær', 'Frugt og bær', '(afgrøden har ingen kategori)', 'bær');
INSERT INTO "afgroede_kategori" ("afgroedekode", "afgroedenavn", "afgroedegruppe", "afgroedekategori", "priskategori") VALUES (172, 'Lucernegræs, over 25% græs til slæt inkl. eget foder', 'Græsmarksplanter, omdrift', 'græs eller andet grøntfoder', 'græs, sædskifte');
INSERT INTO "afgroede_kategori" ("afgroedekode", "afgroedenavn", "afgroedegruppe", "afgroedekategori", "priskategori") VALUES (409, 'Kinakål', 'Grøntsager, friland', 'ager-kål', 'kål');
INSERT INTO "afgroede_kategori" ("afgroedekode", "afgroedenavn", "afgroedegruppe", "afgroedekategori", "priskategori") VALUES (30, 'Ærter', 'Oliefrø og Bælgsæd', 'ært', 'Bælgsæd');
INSERT INTO "afgroede_kategori" ("afgroedekode", "afgroedenavn", "afgroedegruppe", "afgroedekategori", "priskategori") VALUES (21, 'Vårraps', 'Oliefrø og Bælgsæd', 'vårraps', 'oliefrø');
INSERT INTO "afgroede_kategori" ("afgroedekode", "afgroedenavn", "afgroedegruppe", "afgroedekategori", "priskategori") VALUES (521, 'Surkirsebær med undervækst af græs', 'Frugt og bær', '(afgrøden har ingen kategori)', 'bær');
INSERT INTO "afgroede_kategori" ("afgroedekode", "afgroedenavn", "afgroedegruppe", "afgroedekategori", "priskategori") VALUES (3, 'Vårhavre', 'Vårsæd til modenhed', 'vårhavre', 'vårsæd til modenhed');
INSERT INTO "afgroede_kategori" ("afgroedekode", "afgroedenavn", "afgroedegruppe", "afgroedekategori", "priskategori") VALUES (17, 'Blanding af efterårssåede arter', 'Vintersæd til modenhed', 'vintersået blanding', 'vinterkorn blanding');
INSERT INTO "afgroede_kategori" ("afgroedekode", "afgroedenavn", "afgroedegruppe", "afgroedekategori", "priskategori") VALUES (324, 'Blomsterbrak', 'Særlige afgrødekoder i forbindelse med tilsagn eller miljøtiltag', 'brak', 'brak');
INSERT INTO "afgroede_kategori" ("afgroedekode", "afgroedenavn", "afgroedegruppe", "afgroedekategori", "priskategori") VALUES (212, 'Vårhavre, helsæd', 'Helsæd, vår', 'vårhavre', 'helsæd, vår');
INSERT INTO "afgroede_kategori" ("afgroedekode", "afgroedenavn", "afgroedegruppe", "afgroedekategori", "priskategori") VALUES (310, 'Brak, sommerslåning', 'Udyrkede arealer, vildtagre o.l.', 'brak', 'brak');
INSERT INTO "afgroede_kategori" ("afgroedekode", "afgroedenavn", "afgroedegruppe", "afgroedekategori", "priskategori") VALUES (907, 'Naturarealer, økologisk jordbrug', 'Øvrige afgrøder', '(afgrøden har ingen kategori)', 'Brak');
INSERT INTO "afgroede_kategori" ("afgroedekode", "afgroedenavn", "afgroedegruppe", "afgroedekategori", "priskategori") VALUES (404, 'Broccoli', 'Grøntsager, friland', 'kål', 'grøntsager');
INSERT INTO "afgroede_kategori" ("afgroedekode", "afgroedenavn", "afgroedegruppe", "afgroedekategori", "priskategori") VALUES (489, 'Havtorn', 'Småplanteproduktion og planteskoleplanter', '(afgrøden har ingen kategori)', 'potteplanter og stauder');
INSERT INTO "afgroede_kategori" ("afgroedekode", "afgroedenavn", "afgroedegruppe", "afgroedekategori", "priskategori") VALUES (255, 'Permanent græs, under 50% kløver/lucerne', 'Græs, permanent', '(afgrøden har ingen kategori)', 'græs, permanent');
INSERT INTO "afgroede_kategori" ("afgroedekode", "afgroedenavn", "afgroedegruppe", "afgroedekategori", "priskategori") VALUES (56, 'Vårtriticale', 'Vårsæd til modenhed', 'vårtriticale', 'vårtriticale');
INSERT INTO "afgroede_kategori" ("afgroedekode", "afgroedenavn", "afgroedegruppe", "afgroedekategori", "priskategori") VALUES (515, 'Ribs', 'Frugt og bær', '(afgrøden har ingen kategori)', 'bær');
INSERT INTO "afgroede_kategori" ("afgroedekode", "afgroedenavn", "afgroedegruppe", "afgroedekategori", "priskategori") VALUES (151, 'Kartofler, stivelses-', 'Kartofler', 'kartoffel', 'stivelseskartofler');
INSERT INTO "afgroede_kategori" ("afgroedekode", "afgroedenavn", "afgroedegruppe", "afgroedekategori", "priskategori") VALUES (418, 'Rødkål', 'Grøntsager, friland', 'kål', 'kål');
INSERT INTO "afgroede_kategori" ("afgroedekode", "afgroedenavn", "afgroedegruppe", "afgroedekategori", "priskategori") VALUES (706, 'Grønkorn af vinterbyg', 'Korn, grønkorn', 'vinterbyg', 'vinterbyg');
INSERT INTO "afgroede_kategori" ("afgroedekode", "afgroedenavn", "afgroedegruppe", "afgroedekategori", "priskategori") VALUES (407, 'Gulerod', 'Grøntsager, friland', 'gulerod', 'grøntsager');
INSERT INTO "afgroede_kategori" ("afgroedekode", "afgroedenavn", "afgroedegruppe", "afgroedekategori", "priskategori") VALUES (325, 'MFO-Blomsterbrak', 'Særlige afgrødekoder i forbindelse med tilsagn eller miljøtiltag', 'brak', 'brak');
INSERT INTO "afgroede_kategori" ("afgroedekode", "afgroedenavn", "afgroedegruppe", "afgroedekategori", "priskategori") VALUES (516, 'Stikkelsbær', 'Frugt og bær', '(afgrøden har ingen kategori)', 'bær');
INSERT INTO "afgroede_kategori" ("afgroedekode", "afgroedenavn", "afgroedegruppe", "afgroedekategori", "priskategori") VALUES (542, 'Salat (drivhus)', 'Småplanteproduktion og planteskoleplanter', 'salat', 'potteplanter og stauder');
INSERT INTO "afgroede_kategori" ("afgroedekode", "afgroedenavn", "afgroedegruppe", "afgroedekategori", "priskategori") VALUES (216, 'Silomajs', 'Helsæd, vår', 'majs', 'majs til helsæd');
INSERT INTO "afgroede_kategori" ("afgroedekode", "afgroedenavn", "afgroedegruppe", "afgroedekategori", "priskategori") VALUES (666, 'Purløgsfrø', 'Havefrø', 'løg', 'Havefrø');
INSERT INTO "afgroede_kategori" ("afgroedekode", "afgroedenavn", "afgroedegruppe", "afgroedekategori", "priskategori") VALUES (174, 'Kløvergræs til fabrik', 'Græsmarksplanter, omdrift', 'græs eller andet grøntfoder', 'græs, sædskifte');
INSERT INTO "afgroede_kategori" ("afgroedekode", "afgroedenavn", "afgroedegruppe", "afgroedekategori", "priskategori") VALUES (213, 'Blandkorn, vårsået, helsæd', 'Helsæd, vår', 'vårsået blanding', 'helsæd, vår');
INSERT INTO "afgroede_kategori" ("afgroedekode", "afgroedenavn", "afgroedegruppe", "afgroedekategori", "priskategori") VALUES (274, 'Permanent lucernegræs over 25% græs, til fabrik', 'Græs, permanent', '(afgrøden har ingen kategori)', 'græs, permanent');
INSERT INTO "afgroede_kategori" ("afgroedekode", "afgroedenavn", "afgroedegruppe", "afgroedekategori", "priskategori") VALUES (334, 'MFO-bræmme, forårsslåning', 'Særlige afgrødekoder i forbindelse med tilsagn eller miljøtiltag', 'brak', 'brak');
INSERT INTO "afgroede_kategori" ("afgroedekode", "afgroedenavn", "afgroedegruppe", "afgroedekategori", "priskategori") VALUES (540, 'Tomater', 'Småplanteproduktion og planteskoleplanter', 'tomat', 'potteplanter og stauder');
INSERT INTO "afgroede_kategori" ("afgroedekode", "afgroedenavn", "afgroedegruppe", "afgroedekategori", "priskategori") VALUES (598, 'Sorrel', 'Energiafgrøder og anden særlig produktion', 'sorrel', 'Energiafgrøder');
INSERT INTO "afgroede_kategori" ("afgroedekode", "afgroedenavn", "afgroedegruppe", "afgroedekategori", "priskategori") VALUES (223, 'Vintertriticale, helsæd', 'Helsæd, vinter', 'vintertriticale', 'vintertriticale');
INSERT INTO "afgroede_kategori" ("afgroedekode", "afgroedenavn", "afgroedegruppe", "afgroedekategori", "priskategori") VALUES (526, 'Hyld', 'Frugt og bær', '(afgrøden har ingen kategori)', 'bær');
INSERT INTO "afgroede_kategori" ("afgroedekode", "afgroedenavn", "afgroedegruppe", "afgroedekategori", "priskategori") VALUES (36, 'Bælgsæd, andre typer til modenhed blanding', 'Oliefrø og Bælgsæd', 'vårsået blanding', 'Bælgsæd');
INSERT INTO "afgroede_kategori" ("afgroedekode", "afgroedenavn", "afgroedegruppe", "afgroedekategori", "priskategori") VALUES (287, 'Græs til udegrise, permanent', 'Græs, permanent', '(afgrøden har ingen kategori)', 'græs, permanent');
INSERT INTO "afgroede_kategori" ("afgroedekode", "afgroedenavn", "afgroedegruppe", "afgroedekategori", "priskategori") VALUES (221, 'Vinterhvede, helsæd', 'Helsæd, vinter', 'vinterhvede', 'vinterhvede');
INSERT INTO "afgroede_kategori" ("afgroedekode", "afgroedenavn", "afgroedegruppe", "afgroedekategori", "priskategori") VALUES (524, 'Sødkirsebær uden undervækst af græs', 'Frugt og bær', '(afgrøden har ingen kategori)', 'bær');
INSERT INTO "afgroede_kategori" ("afgroedekode", "afgroedenavn", "afgroedegruppe", "afgroedekategori", "priskategori") VALUES (430, 'Bladpersille', 'Grøntsager, friland', 'persille', 'krydderurter');
INSERT INTO "afgroede_kategori" ("afgroedekode", "afgroedenavn", "afgroedegruppe", "afgroedekategori", "priskategori") VALUES (102, 'Rajgræsfrø, alm. 1. år, efterårsudlagt', 'Frøgræs', 'efterårssået rajgræsfrø', 'Frøgræs');
INSERT INTO "afgroede_kategori" ("afgroedekode", "afgroedenavn", "afgroedegruppe", "afgroedekategori", "priskategori") VALUES (312, '20-årig udtagning', 'Særlige afgrødekoder i forbindelse med tilsagn eller miljøtiltag', 'brak', 'brak');
INSERT INTO "afgroede_kategori" ("afgroedekode", "afgroedenavn", "afgroedegruppe", "afgroedekategori", "priskategori") VALUES (277, 'Kløver til fabrik', 'Kløver og lucerne i renbestand', 'kløver', 'kløver');
INSERT INTO "afgroede_kategori" ("afgroedekode", "afgroedenavn", "afgroedegruppe", "afgroedekategori", "priskategori") VALUES (594, 'El', 'Energiafgrøder og anden særlig produktion', '(afgrøden har ingen kategori)', 'Energiafgrøder');
INSERT INTO "afgroede_kategori" ("afgroedekode", "afgroedenavn", "afgroedegruppe", "afgroedekategori", "priskategori") VALUES (494, 'Japan kvæde', 'Småplanteproduktion og planteskoleplanter', '(afgrøden har ingen kategori)', 'potteplanter og stauder');
INSERT INTO "afgroede_kategori" ("afgroedekode", "afgroedenavn", "afgroedegruppe", "afgroedekategori", "priskategori") VALUES (533, 'Rønnebær', 'Frugt og bær', '(afgrøden har ingen kategori)', 'frugt');
INSERT INTO "afgroede_kategori" ("afgroedekode", "afgroedenavn", "afgroedegruppe", "afgroedekategori", "priskategori") VALUES (118, 'Rajsvingelfrø, efterårsudlagt', 'Frøgræs', 'efterårssået rajsvingelfrø', 'Frøgræs');
INSERT INTO "afgroede_kategori" ("afgroedekode", "afgroedenavn", "afgroedegruppe", "afgroedekategori", "priskategori") VALUES (499, 'Lukket system', 'Småplanteproduktion og planteskoleplanter', '(afgrøden har ingen kategori)', 'potteplanter og stauder');
INSERT INTO "afgroede_kategori" ("afgroedekode", "afgroedenavn", "afgroedegruppe", "afgroedekategori", "priskategori") VALUES (662, 'Majroefrø', 'Havefrø', 'ager-kål', 'Havefrø');
INSERT INTO "afgroede_kategori" ("afgroedekode", "afgroedenavn", "afgroedegruppe", "afgroedekategori", "priskategori") VALUES (284, 'Græs med vikke og andre bælgplanter, under 50 % bælgpl.', 'Græsmarksplanter, omdrift', 'græs eller andet grøntfoder', 'græs, sædskifte');
INSERT INTO "afgroede_kategori" ("afgroedekode", "afgroedenavn", "afgroedegruppe", "afgroedekategori", "priskategori") VALUES (317, 'Vådområder med udtagning', 'Særlige afgrødekoder i forbindelse med tilsagn eller miljøtiltag', 'brak', 'brak');
INSERT INTO "afgroede_kategori" ("afgroedekode", "afgroedenavn", "afgroedegruppe", "afgroedekategori", "priskategori") VALUES (111, 'Svingelfrø, strand-', 'Frøgræs', 'svingelfrø', 'Frøgræs');
INSERT INTO "afgroede_kategori" ("afgroedekode", "afgroedenavn", "afgroedegruppe", "afgroedekategori", "priskategori") VALUES (342, 'Bestøverbrak', 'Særlige afgrødekoder i forbindelse med tilsagn eller miljøtiltag', 'brak', 'brak');
INSERT INTO "afgroede_kategori" ("afgroedekode", "afgroedenavn", "afgroedegruppe", "afgroedekategori", "priskategori") VALUES (16, 'Vintertriticale', 'Vintersæd til modenhed', 'vintertriticale', 'vintertriticale');
INSERT INTO "afgroede_kategori" ("afgroedekode", "afgroedenavn", "afgroedegruppe", "afgroedekategori", "priskategori") VALUES (702, 'Grønkron af vårhvede', 'Korn, grønkorn', 'vårhvede', 'hvede');
INSERT INTO "afgroede_kategori" ("afgroedekode", "afgroedenavn", "afgroedegruppe", "afgroedekategori", "priskategori") VALUES (488, 'Hønsegård, permanent græs', 'Græs, permanent', '(afgrøden har ingen kategori)', 'græs, permanent');
INSERT INTO "afgroede_kategori" ("afgroedekode", "afgroedenavn", "afgroedegruppe", "afgroedekategori", "priskategori") VALUES (123, 'Valmuefrø', 'Frøgræs', 'valmue', 'Frøgræs');
INSERT INTO "afgroede_kategori" ("afgroedekode", "afgroedenavn", "afgroedegruppe", "afgroedekategori", "priskategori") VALUES (126, 'Blanding af markfrø til udsæd', 'Frøgræs', 'vårsået blanding', 'Frøgræs');
INSERT INTO "afgroede_kategori" ("afgroedekode", "afgroedenavn", "afgroedegruppe", "afgroedekategori", "priskategori") VALUES (326, 'Ej landbrug, MSO, omlagt fra permanent græs', 'Særlige afgrødekoder i forbindelse med tilsagn eller miljøtiltag', '(afgrøden har ingen kategori)', 'brak');
INSERT INTO "afgroede_kategori" ("afgroedekode", "afgroedenavn", "afgroedegruppe", "afgroedekategori", "priskategori") VALUES (492, 'Tyttebær ', 'Småplanteproduktion og planteskoleplanter', '(afgrøden har ingen kategori)', 'potteplanter og stauder');
INSERT INTO "afgroede_kategori" ("afgroedekode", "afgroedenavn", "afgroedegruppe", "afgroedekategori", "priskategori") VALUES (655, 'Radisefrø (inklusiv olieræddikefrø)', 'Havefrø', 'radise', 'Havefrø');
INSERT INTO "afgroede_kategori" ("afgroedekode", "afgroedenavn", "afgroedegruppe", "afgroedekategori", "priskategori") VALUES (544, 'Snitblomster og snitgrønt', 'Småplanteproduktion og planteskoleplanter', 'planteskolekultur', 'potteplanter og stauder');
INSERT INTO "afgroede_kategori" ("afgroedekode", "afgroedenavn", "afgroedegruppe", "afgroedekategori", "priskategori") VALUES (41, 'Spindhør', 'Hør og Hamp', 'hør', 'oliefrø');
INSERT INTO "afgroede_kategori" ("afgroedekode", "afgroedenavn", "afgroedegruppe", "afgroedekategori", "priskategori") VALUES (224, 'Blandkorn, efterårssået helsæd', 'Helsæd, vinter', 'vintersået blanding', 'helsæd, vinter');
INSERT INTO "afgroede_kategori" ("afgroedekode", "afgroedenavn", "afgroedegruppe", "afgroedekategori", "priskategori") VALUES (704, 'Grønkorn af vårrug', 'Korn, grønkorn', 'vårrug', 'rug');
INSERT INTO "afgroede_kategori" ("afgroedekode", "afgroedenavn", "afgroedegruppe", "afgroedekategori", "priskategori") VALUES (586, 'Offentlig skovrejsning', 'Trækulturer', '(afgrøden har ingen kategori)', 'skovdrift');
INSERT INTO "afgroede_kategori" ("afgroedekode", "afgroedenavn", "afgroedegruppe", "afgroedekategori", "priskategori") VALUES (53, 'Boghvede', 'Hør og Hamp', 'boghvede', 'oliefrø');
INSERT INTO "afgroede_kategori" ("afgroedekode", "afgroedenavn", "afgroedegruppe", "afgroedekategori", "priskategori") VALUES (32, 'Sødlupin', 'Oliefrø og Bælgsæd', 'lupin', 'Bælgsæd');
INSERT INTO "afgroede_kategori" ("afgroedekode", "afgroedenavn", "afgroedegruppe", "afgroedekategori", "priskategori") VALUES (413, 'Rodpersille', 'Grøntsager, friland', 'persille', 'grøntsager');
INSERT INTO "afgroede_kategori" ("afgroedekode", "afgroedenavn", "afgroedegruppe", "afgroedekategori", "priskategori") VALUES (336, 'MFO-bræmme, permanent græs, sommerslåning ', 'Særlige afgrødekoder i forbindelse med tilsagn eller miljøtiltag', '(afgrøden har ingen kategori)', 'græs, permanent');
INSERT INTO "afgroede_kategori" ("afgroedekode", "afgroedenavn", "afgroedegruppe", "afgroedekategori", "priskategori") VALUES (318, 'MVJ ej udtagning, ej landbrugsareal', 'Særlige afgrødekoder i forbindelse med tilsagn eller miljøtiltag', '(afgrøden har ingen kategori)', 'brak');
INSERT INTO "afgroede_kategori" ("afgroedekode", "afgroedenavn", "afgroedegruppe", "afgroedekategori", "priskategori") VALUES (606, 'MFO - Poppel (100-400 andre træer pr. ha)', 'Energiafgrøder og anden særlig produktion', '(afgrøden har ingen kategori)', 'Energiafgrøder');
INSERT INTO "afgroede_kategori" ("afgroedekode", "afgroedenavn", "afgroedegruppe", "afgroedekategori", "priskategori") VALUES (247, 'Miljøgræs MVJ-tilsagn (0 N), omdrift', 'Arealer med tilsagn under miljøordningerne', 'græs eller andet grøntfoder', 'græs, sædskifte');
INSERT INTO "afgroede_kategori" ("afgroedekode", "afgroedenavn", "afgroedegruppe", "afgroedekategori", "priskategori") VALUES (260, 'Græs med kløver/lucerne, under 50 % bælgpl. (omdrift)', 'Græsmarksplanter, omdrift', 'græs eller andet grøntfoder', 'græs, sædskifte');
INSERT INTO "afgroede_kategori" ("afgroedekode", "afgroedenavn", "afgroedegruppe", "afgroedekategori", "priskategori") VALUES (308, 'MFO-brak, sommerslåning', 'Udyrkede arealer, vildtagre o.l.', 'brak', 'brak');
INSERT INTO "afgroede_kategori" ("afgroedekode", "afgroedenavn", "afgroedegruppe", "afgroedekategori", "priskategori") VALUES (423, 'Sukkermajs', 'Grøntsager, friland', 'majs', 'grøntsager');
INSERT INTO "afgroede_kategori" ("afgroedekode", "afgroedenavn", "afgroedegruppe", "afgroedekategori", "priskategori") VALUES (313, '20-årig udtagning af agerjord med frivillig skovrejsning', 'Særlige afgrødekoder i forbindelse med tilsagn eller miljøtiltag', '(afgrøden har ingen kategori)', 'brak');
INSERT INTO "afgroede_kategori" ("afgroedekode", "afgroedenavn", "afgroedegruppe", "afgroedekategori", "priskategori") VALUES (150, 'Kartofler, lægge- (egen opformering)', 'Kartofler', 'kartoffel', 'læggekartofler');
INSERT INTO "afgroede_kategori" ("afgroedekode", "afgroedenavn", "afgroedegruppe", "afgroedekategori", "priskategori") VALUES (656, 'Bladbedefrø, rødbedefrø', 'Havefrø', 'beder', 'Havefrø');
INSERT INTO "afgroede_kategori" ("afgroedekode", "afgroedenavn", "afgroedegruppe", "afgroedekategori", "priskategori") VALUES (593, 'Poppel (0-100 andre træer pr. ha)', 'Energiafgrøder og anden særlig produktion', '(afgrøden har ingen kategori)', 'Energiafgrøder');
INSERT INTO "afgroede_kategori" ("afgroedekode", "afgroedenavn", "afgroedegruppe", "afgroedekategori", "priskategori") VALUES (421, 'Savoykål, spidskål', 'Grøntsager, friland', 'kål', 'kål');
INSERT INTO "afgroede_kategori" ("afgroedekode", "afgroedenavn", "afgroedegruppe", "afgroedekategori", "priskategori") VALUES (411, 'Løg', 'Grøntsager, friland', 'løg', 'grøntsager');
INSERT INTO "afgroede_kategori" ("afgroedekode", "afgroedenavn", "afgroedegruppe", "afgroedekategori", "priskategori") VALUES (24, 'Solsikke', 'Oliefrø og Bælgsæd', 'solsikke', 'oliefrø');
INSERT INTO "afgroede_kategori" ("afgroedekode", "afgroedenavn", "afgroedegruppe", "afgroedekategori", "priskategori") VALUES (429, 'Jordskokker, konsum', 'Grøntsager, friland', 'solsikke', 'grøntsager');
INSERT INTO "afgroede_kategori" ("afgroedekode", "afgroedenavn", "afgroedegruppe", "afgroedekategori", "priskategori") VALUES (25, 'Sojabønner', 'Oliefrø og Bælgsæd', 'soja', 'oliefrø');
INSERT INTO "afgroede_kategori" ("afgroedekode", "afgroedenavn", "afgroedegruppe", "afgroedekategori", "priskategori") VALUES (495, 'Morbær ', 'Småplanteproduktion og planteskoleplanter', '(afgrøden har ingen kategori)', 'potteplanter og stauder');
INSERT INTO "afgroede_kategori" ("afgroedekode", "afgroedenavn", "afgroedegruppe", "afgroedekategori", "priskategori") VALUES (122, 'Kommenfrø', 'Frøgræs', 'kommen', 'Frøgræs');
INSERT INTO "afgroede_kategori" ("afgroedekode", "afgroedenavn", "afgroedegruppe", "afgroedekategori", "priskategori") VALUES (154, 'Kartofler, spise- (proces, skrællet kogte)', 'Kartofler', 'kartoffel', 'processkartofler');
INSERT INTO "afgroede_kategori" ("afgroedekode", "afgroedenavn", "afgroedegruppe", "afgroedekategori", "priskategori") VALUES (570, 'Humle', 'Frugt og bær', '(afgrøden har ingen kategori)', 'bær');
INSERT INTO "afgroede_kategori" ("afgroedekode", "afgroedenavn", "afgroedegruppe", "afgroedekategori", "priskategori") VALUES (234, 'Korn og bælgsæd, grønkorn, under 50% bælgsæd', 'Korn, grønkorn', 'vårsået blanding', 'vårkorn blanding');
INSERT INTO "afgroede_kategori" ("afgroedekode", "afgroedenavn", "afgroedegruppe", "afgroedekategori", "priskategori") VALUES (657, 'Grønkålfrø', 'Havefrø', 'kål', 'Havefrø');
INSERT INTO "afgroede_kategori" ("afgroedekode", "afgroedenavn", "afgroedegruppe", "afgroedekategori", "priskategori") VALUES (434, 'Grøntsager, andre (friland)', 'Grøntsager, friland', 'planteskolekultur', 'grøntsager');
INSERT INTO "afgroede_kategori" ("afgroedekode", "afgroedenavn", "afgroedegruppe", "afgroedekategori", "priskategori") VALUES (211, 'Vårhvede, helsæd', 'Helsæd, vår', 'vårhvede', 'helsæd, vår');
INSERT INTO "afgroede_kategori" ("afgroedekode", "afgroedenavn", "afgroedegruppe", "afgroedekategori", "priskategori") VALUES (316, '20-årig Udtagning med fastholdelse, ej landbrugsareal', 'Særlige afgrødekoder i forbindelse med tilsagn eller miljøtiltag', '(afgrøden har ingen kategori)', 'brak');
INSERT INTO "afgroede_kategori" ("afgroedekode", "afgroedenavn", "afgroedegruppe", "afgroedekategori", "priskategori") VALUES (403, 'Blomkål', 'Grøntsager, friland', 'kål', 'kål');
INSERT INTO "afgroede_kategori" ("afgroedekode", "afgroedenavn", "afgroedegruppe", "afgroedekategori", "priskategori") VALUES (256, 'Permanent kløvergræs, over 50% kløver/lucerne', 'Græs, permanent', '(afgrøden har ingen kategori)', 'græs, permanent');
INSERT INTO "afgroede_kategori" ("afgroedekode", "afgroedenavn", "afgroedegruppe", "afgroedekategori", "priskategori") VALUES (580, 'Anden skovdrift', 'Trækulturer', '(afgrøden har ingen kategori)', 'skovdrift');
INSERT INTO "afgroede_kategori" ("afgroedekode", "afgroedenavn", "afgroedegruppe", "afgroedekategori", "priskategori") VALUES (654, 'Rucolafrø', 'Havefrø', 'rucola', 'Havefrø');
INSERT INTO "afgroede_kategori" ("afgroedekode", "afgroedenavn", "afgroedegruppe", "afgroedekategori", "priskategori") VALUES (530, 'Vindrue', 'Frugt og bær', '(afgrøden har ingen kategori)', 'frugt');
INSERT INTO "afgroede_kategori" ("afgroedekode", "afgroedenavn", "afgroedegruppe", "afgroedekategori", "priskategori") VALUES (422, 'Spinat', 'Grøntsager, friland', 'spinat', 'grøntsager');
INSERT INTO "afgroede_kategori" ("afgroedekode", "afgroedenavn", "afgroedegruppe", "afgroedekategori", "priskategori") VALUES (536, 'Spisedruer', 'Frugt og bær', '(afgrøden har ingen kategori)', 'frugt');
INSERT INTO "afgroede_kategori" ("afgroedekode", "afgroedenavn", "afgroedegruppe", "afgroedekategori", "priskategori") VALUES (449, 'Medicinpl., stauder ', 'Medicinplanter', 'planteskolekultur', 'potteplanter og stauder');
INSERT INTO "afgroede_kategori" ("afgroedekode", "afgroedenavn", "afgroedegruppe", "afgroedekategori", "priskategori") VALUES (264, 'Græs og kløvergræs uden norm, under 50 % kløver (omdrift)', 'Græsmarksplanter, omdrift', 'græs eller andet grøntfoder', 'græs, sædskifte');
INSERT INTO "afgroede_kategori" ("afgroedekode", "afgroedenavn", "afgroedegruppe", "afgroedekategori", "priskategori") VALUES (520, 'Surkirsebær uden undervækst af græs', 'Frugt og bær', '(afgrøden har ingen kategori)', 'bær');
INSERT INTO "afgroede_kategori" ("afgroedekode", "afgroedenavn", "afgroedegruppe", "afgroedekategori", "priskategori") VALUES (215, 'Ærtehelsæd', 'Helsæd, vår', 'ært', 'helsæd, vår');
INSERT INTO "afgroede_kategori" ("afgroedekode", "afgroedenavn", "afgroedegruppe", "afgroedekategori", "priskategori") VALUES (653, 'Karsefrø', 'Havefrø', 'karse', 'Havefrø');
INSERT INTO "afgroede_kategori" ("afgroedekode", "afgroedenavn", "afgroedegruppe", "afgroedekategori", "priskategori") VALUES (55, 'Vårrug', 'Vårsæd til modenhed', 'vårrug', 'vårsæd til modenhed');
INSERT INTO "afgroede_kategori" ("afgroedekode", "afgroedenavn", "afgroedegruppe", "afgroedekategori", "priskategori") VALUES (23, 'Rybs', 'Oliefrø og Bælgsæd', 'ager-kål', 'oliefrø');
INSERT INTO "afgroede_kategori" ("afgroedekode", "afgroedenavn", "afgroedegruppe", "afgroedekategori", "priskategori") VALUES (270, 'Græs til udegrise, omdrift', 'Græsmarksplanter, omdrift', 'græs eller andet grøntfoder', 'græs, sædskifte');
INSERT INTO "afgroede_kategori" ("afgroedekode", "afgroedenavn", "afgroedegruppe", "afgroedekategori", "priskategori") VALUES (486, 'Hønsegård uden plantedække', 'Udyrkede arealer, vildtagre o.l.', 'brak', 'brak');

ALTER TABLE "afgroede_kategori"
    ADD CONSTRAINT "afgroede_kategori_pkey" PRIMARY KEY ("afgroedekode");

ALTER TABLE "afgroede_kategori"
    ADD CONSTRAINT fk_afgroede_kategori_afgroedekode FOREIGN KEY (priskategori) REFERENCES afgroede_pris(priskategori);

    
-- Patch  2022-09-16: Model q_agriculture slut --