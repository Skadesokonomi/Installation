
CREATE EXTENSION IF NOT EXISTS postgis;

CREATE SCHEMA IF NOT EXISTS fdc_data;
CREATE SCHEMA IF NOT EXISTS fdc_results;
CREATE SCHEMA IF NOT EXISTS fdc_admin;

CREATE TABLE IF NOT EXISTS fdc_admin.bbr_anvendelse (
    bbr_anv_kode integer NOT NULL,
    bbr_anv_tekst character varying,
    skade_kategori character varying,
	PRIMARY KEY (bbr_anv_kode)
);

CREATE TABLE IF NOT EXISTS fdc_admin.kvm_pris (
    kom_kode integer NOT NULL,
    kom_navn character varying,
    kvm_pris integer,
	PRIMARY KEY (kom_kode)
);

CREATE TABLE IF NOT EXISTS fdc_admin.parametre (
    name character varying NOT NULL,
    parent character varying,
    value character varying NOT NULL,
    type character varying(1) NOT NULL,
    minval character varying NOT NULL,
    maxval character varying NOT NULL,
    lookupvalues character varying NOT NULL,
    "default" character varying NOT NULL,
    explanation character varying NOT NULL,
    sort integer NOT NULL,
    checkable "char" NOT NULL,
	PRIMARY KEY (name)
);

CREATE TABLE IF NOT EXISTS fdc_admin.skadefunktioner (
    skade_type character varying NOT NULL,
    skade_kategori character varying NOT NULL,
    b0 double precision NOT NULL,
    b1 double precision NOT NULL,
    b2 double precision NOT NULL,
    c0 double precision NOT NULL,
	PRIMARY KEY (skade_type, skade_kategori)
);

CREATE TABLE IF NOT EXISTS fdc_admin.turisme (
    bbr_anv_kode integer NOT NULL,
    bbr_anv_tekst character varying(255) NOT NULL,
    kapacitet integer NOT NULL,
    omkostning integer NOT NULL,
	PRIMARY KEY (bbr_anv_kode)
);

TRUNCATE TABLE fdc_admin.bbr_anvendelse;
INSERT INTO fdc_admin.bbr_anvendelse (bbr_anv_kode, bbr_anv_tekst, skade_kategori) VALUES (-9999, 'No Data', 'Ingen data');
INSERT INTO fdc_admin.bbr_anvendelse (bbr_anv_kode, bbr_anv_tekst, skade_kategori) VALUES (110, 'Stuehus til landbrugsejendom', 'Helårsbeboelse');
INSERT INTO fdc_admin.bbr_anvendelse (bbr_anv_kode, bbr_anv_tekst, skade_kategori) VALUES (120, 'Fritliggende enfamilieshus (parcelhus)', 'Helårsbeboelse');
INSERT INTO fdc_admin.bbr_anvendelse (bbr_anv_kode, bbr_anv_tekst, skade_kategori) VALUES (121, 'Sammenbygget enfamiliehus', 'Helårsbeboelse');
INSERT INTO fdc_admin.bbr_anvendelse (bbr_anv_kode, bbr_anv_tekst, skade_kategori) VALUES (122, 'Fritliggende enfamiliehus i tæt-lav bebyggelse', 'Helårsbeboelse');
INSERT INTO fdc_admin.bbr_anvendelse (bbr_anv_kode, bbr_anv_tekst, skade_kategori) VALUES (130, '(UDFASES) Række-, kæde-, eller dobbelthus (lodret adskillelse mellem enhederne).', 'Helårsbeboelse');
INSERT INTO fdc_admin.bbr_anvendelse (bbr_anv_kode, bbr_anv_tekst, skade_kategori) VALUES (131, 'Række- og kædehus', 'Helårsbeboelse');
INSERT INTO fdc_admin.bbr_anvendelse (bbr_anv_kode, bbr_anv_tekst, skade_kategori) VALUES (132, 'Dobbelthus', 'Helårsbeboelse');
INSERT INTO fdc_admin.bbr_anvendelse (bbr_anv_kode, bbr_anv_tekst, skade_kategori) VALUES (140, 'Etagebolig-bygning, flerfamilehus eller to-familiehus', 'Helårsbeboelse');
INSERT INTO fdc_admin.bbr_anvendelse (bbr_anv_kode, bbr_anv_tekst, skade_kategori) VALUES (150, 'Kollegium', 'Helårsbeboelse');
INSERT INTO fdc_admin.bbr_anvendelse (bbr_anv_kode, bbr_anv_tekst, skade_kategori) VALUES (160, 'Boligbygning til døgninstitution', 'Helårsbeboelse');
INSERT INTO fdc_admin.bbr_anvendelse (bbr_anv_kode, bbr_anv_tekst, skade_kategori) VALUES (185, 'Anneks i tilknytning til helårsbolig.', 'Helårsbeboelse');
INSERT INTO fdc_admin.bbr_anvendelse (bbr_anv_kode, bbr_anv_tekst, skade_kategori) VALUES (190, 'Anden bygning til helårsbeboelse', 'Helårsbeboelse');
INSERT INTO fdc_admin.bbr_anvendelse (bbr_anv_kode, bbr_anv_tekst, skade_kategori) VALUES (210, '(UDFASES) Bygning til erhvervsmæssig produktion vedrørende landbrug, gartneri, råstofudvinding o. lign', 'Erhverv');
INSERT INTO fdc_admin.bbr_anvendelse (bbr_anv_kode, bbr_anv_tekst, skade_kategori) VALUES (211, 'Stald til svin', 'Erhverv');
INSERT INTO fdc_admin.bbr_anvendelse (bbr_anv_kode, bbr_anv_tekst, skade_kategori) VALUES (212, 'Stald til kvæg, får mv.', 'Erhverv');
INSERT INTO fdc_admin.bbr_anvendelse (bbr_anv_kode, bbr_anv_tekst, skade_kategori) VALUES (213, 'Stald til fjerkræ', 'Erhverv');
INSERT INTO fdc_admin.bbr_anvendelse (bbr_anv_kode, bbr_anv_tekst, skade_kategori) VALUES (214, 'Minkhal', 'Erhverv');
INSERT INTO fdc_admin.bbr_anvendelse (bbr_anv_kode, bbr_anv_tekst, skade_kategori) VALUES (215, 'Væksthus', 'Erhverv');
INSERT INTO fdc_admin.bbr_anvendelse (bbr_anv_kode, bbr_anv_tekst, skade_kategori) VALUES (216, 'Lade til foder, afgrøder mv.', 'Erhverv');
INSERT INTO fdc_admin.bbr_anvendelse (bbr_anv_kode, bbr_anv_tekst, skade_kategori) VALUES (217, 'Maskinhus, garage mv.', 'Erhverv');
INSERT INTO fdc_admin.bbr_anvendelse (bbr_anv_kode, bbr_anv_tekst, skade_kategori) VALUES (218, 'Lade til halm, hø mv.', 'Erhverv');
INSERT INTO fdc_admin.bbr_anvendelse (bbr_anv_kode, bbr_anv_tekst, skade_kategori) VALUES (219, 'Anden bygning til landbrug mv.', 'Erhverv');
INSERT INTO fdc_admin.bbr_anvendelse (bbr_anv_kode, bbr_anv_tekst, skade_kategori) VALUES (220, '(UDFASES) Bygning til erhvervsmæssig produktion vedrørende industri, håndværk m.v. (fabrik, værksted o.lign.)', 'Erhverv');
INSERT INTO fdc_admin.bbr_anvendelse (bbr_anv_kode, bbr_anv_tekst, skade_kategori) VALUES (221, 'Bygning til industri med integreret produktionsapparat', 'Erhverv');
INSERT INTO fdc_admin.bbr_anvendelse (bbr_anv_kode, bbr_anv_tekst, skade_kategori) VALUES (222, 'Bygning til industri uden integreret produktionsapparat', 'Erhverv');
INSERT INTO fdc_admin.bbr_anvendelse (bbr_anv_kode, bbr_anv_tekst, skade_kategori) VALUES (223, 'Værksted', 'Erhverv');
INSERT INTO fdc_admin.bbr_anvendelse (bbr_anv_kode, bbr_anv_tekst, skade_kategori) VALUES (229, 'Anden bygning til produktion', 'Erhverv');
INSERT INTO fdc_admin.bbr_anvendelse (bbr_anv_kode, bbr_anv_tekst, skade_kategori) VALUES (230, '(UDFASES) El-, gas-, vand- eller varmeværk, forbrændingsanstalt m.v.', 'Forsyning');
INSERT INTO fdc_admin.bbr_anvendelse (bbr_anv_kode, bbr_anv_tekst, skade_kategori) VALUES (231, 'Bygning til energiproduktion', 'Forsyning');
INSERT INTO fdc_admin.bbr_anvendelse (bbr_anv_kode, bbr_anv_tekst, skade_kategori) VALUES (232, 'Bygning til forsyning- og energidistribution', 'Forsyning');
INSERT INTO fdc_admin.bbr_anvendelse (bbr_anv_kode, bbr_anv_tekst, skade_kategori) VALUES (233, 'Bygning til vandforsyning', 'Forsyning');
INSERT INTO fdc_admin.bbr_anvendelse (bbr_anv_kode, bbr_anv_tekst, skade_kategori) VALUES (234, 'Bygning til håndtering af affald og spildevand', 'Forsyning');
INSERT INTO fdc_admin.bbr_anvendelse (bbr_anv_kode, bbr_anv_tekst, skade_kategori) VALUES (239, 'Anden bygning til energiproduktion og -distribution', 'Forsyning');
INSERT INTO fdc_admin.bbr_anvendelse (bbr_anv_kode, bbr_anv_tekst, skade_kategori) VALUES (290, '(UDFASES) Anden bygning til landbrug, industri etc.', 'Erhverv');
INSERT INTO fdc_admin.bbr_anvendelse (bbr_anv_kode, bbr_anv_tekst, skade_kategori) VALUES (310, '(UDFASES) Transport- og garageanlæg (fragtmandshal, lufthavnsbygning, banegårdsbygning, parkeringshus).', 'Erhverv');
INSERT INTO fdc_admin.bbr_anvendelse (bbr_anv_kode, bbr_anv_tekst, skade_kategori) VALUES (311, 'Bygning til jernbane- og busdrift', 'Erhverv');
INSERT INTO fdc_admin.bbr_anvendelse (bbr_anv_kode, bbr_anv_tekst, skade_kategori) VALUES (312, 'Bygning til luftfart', 'Erhverv');
INSERT INTO fdc_admin.bbr_anvendelse (bbr_anv_kode, bbr_anv_tekst, skade_kategori) VALUES (313, 'Bygning til parkering- og transportanlæg', 'Erhverv');
INSERT INTO fdc_admin.bbr_anvendelse (bbr_anv_kode, bbr_anv_tekst, skade_kategori) VALUES (314, 'Bygning til parkering af flere end to køretøjer i tilknytning til boliger', 'Garage mm.');
INSERT INTO fdc_admin.bbr_anvendelse (bbr_anv_kode, bbr_anv_tekst, skade_kategori) VALUES (315, 'Havneanlæg', 'Erhverv');
INSERT INTO fdc_admin.bbr_anvendelse (bbr_anv_kode, bbr_anv_tekst, skade_kategori) VALUES (319, 'Andet transportanlæg', 'Erhverv');
INSERT INTO fdc_admin.bbr_anvendelse (bbr_anv_kode, bbr_anv_tekst, skade_kategori) VALUES (320, '(UDFASES) Bygning til kontor, handel, lager, herunder offentlig administration', 'Erhverv');
INSERT INTO fdc_admin.bbr_anvendelse (bbr_anv_kode, bbr_anv_tekst, skade_kategori) VALUES (321, 'Bygning til kontor', 'Erhverv');
INSERT INTO fdc_admin.bbr_anvendelse (bbr_anv_kode, bbr_anv_tekst, skade_kategori) VALUES (322, 'Bygning til detailhandel', 'Erhverv');
INSERT INTO fdc_admin.bbr_anvendelse (bbr_anv_kode, bbr_anv_tekst, skade_kategori) VALUES (323, 'Bygning til lager', 'Erhverv');
INSERT INTO fdc_admin.bbr_anvendelse (bbr_anv_kode, bbr_anv_tekst, skade_kategori) VALUES (324, 'Butikscenter', 'Erhverv');
INSERT INTO fdc_admin.bbr_anvendelse (bbr_anv_kode, bbr_anv_tekst, skade_kategori) VALUES (325, 'Tankstation', 'Erhverv');
INSERT INTO fdc_admin.bbr_anvendelse (bbr_anv_kode, bbr_anv_tekst, skade_kategori) VALUES (329, 'Anden bygning til kontor, handel og lager', 'Erhverv');
INSERT INTO fdc_admin.bbr_anvendelse (bbr_anv_kode, bbr_anv_tekst, skade_kategori) VALUES (330, '(UDFASES) Bygning til hotel, restaurant, vaskeri, frisør og anden servicevirksomhed', 'Erhverv');
INSERT INTO fdc_admin.bbr_anvendelse (bbr_anv_kode, bbr_anv_tekst, skade_kategori) VALUES (331, 'Hotel, kro eller konferencecenter med overnatning', 'Erhverv');
INSERT INTO fdc_admin.bbr_anvendelse (bbr_anv_kode, bbr_anv_tekst, skade_kategori) VALUES (332, 'Bed & breakfast mv.', 'Erhverv');
INSERT INTO fdc_admin.bbr_anvendelse (bbr_anv_kode, bbr_anv_tekst, skade_kategori) VALUES (333, 'Restaurant, café og konferencecenter uden overnatning', 'Erhverv');
INSERT INTO fdc_admin.bbr_anvendelse (bbr_anv_kode, bbr_anv_tekst, skade_kategori) VALUES (334, 'Privat servicevirksomhed som frisør, vaskeri, netcafé mv.', 'Erhverv');
INSERT INTO fdc_admin.bbr_anvendelse (bbr_anv_kode, bbr_anv_tekst, skade_kategori) VALUES (339, 'Anden bygning til serviceerhverv', 'Erhverv');
INSERT INTO fdc_admin.bbr_anvendelse (bbr_anv_kode, bbr_anv_tekst, skade_kategori) VALUES (390, '(UDFASES) Anden bygning til transport, handel etc', 'Erhverv');
INSERT INTO fdc_admin.bbr_anvendelse (bbr_anv_kode, bbr_anv_tekst, skade_kategori) VALUES (410, '(UDFASES) Bygning til biograf, teater, erhvervsmæssig udstilling, bibliotek, museum, kirke o. lign.', 'Kultur');
INSERT INTO fdc_admin.bbr_anvendelse (bbr_anv_kode, bbr_anv_tekst, skade_kategori) VALUES (411, 'Biograf, teater, koncertsted mv.', 'Kultur');
INSERT INTO fdc_admin.bbr_anvendelse (bbr_anv_kode, bbr_anv_tekst, skade_kategori) VALUES (412, 'Museum', 'Kultur');
INSERT INTO fdc_admin.bbr_anvendelse (bbr_anv_kode, bbr_anv_tekst, skade_kategori) VALUES (413, 'Bibliotek', 'Kultur');
INSERT INTO fdc_admin.bbr_anvendelse (bbr_anv_kode, bbr_anv_tekst, skade_kategori) VALUES (414, 'Kirke eller anden bygning til trosudøvelse for statsanerkendte trossamfund', 'Kultur');
INSERT INTO fdc_admin.bbr_anvendelse (bbr_anv_kode, bbr_anv_tekst, skade_kategori) VALUES (415, 'Forsamlingshus', 'Kultur');
INSERT INTO fdc_admin.bbr_anvendelse (bbr_anv_kode, bbr_anv_tekst, skade_kategori) VALUES (416, 'Forlystelsespark', 'Erhverv');
INSERT INTO fdc_admin.bbr_anvendelse (bbr_anv_kode, bbr_anv_tekst, skade_kategori) VALUES (419, 'Anden bygning til kulturelle formål', 'Kultur');
INSERT INTO fdc_admin.bbr_anvendelse (bbr_anv_kode, bbr_anv_tekst, skade_kategori) VALUES (420, '(UDFASES) Bygning til undervisning og forskning (skole, gymnasium, forskningslabratorium o.lign.).', 'Offentlig');
INSERT INTO fdc_admin.bbr_anvendelse (bbr_anv_kode, bbr_anv_tekst, skade_kategori) VALUES (421, 'Grundskole', 'Offentlig');
INSERT INTO fdc_admin.bbr_anvendelse (bbr_anv_kode, bbr_anv_tekst, skade_kategori) VALUES (422, 'Universitet', 'Offentlig');
INSERT INTO fdc_admin.bbr_anvendelse (bbr_anv_kode, bbr_anv_tekst, skade_kategori) VALUES (429, 'Anden bygning til undervisning og forskning', 'Offentlig');
INSERT INTO fdc_admin.bbr_anvendelse (bbr_anv_kode, bbr_anv_tekst, skade_kategori) VALUES (430, '(UDFASES) Bygning til hospital, sygehjem, fødeklinik o. lign.', 'Offentlig');
INSERT INTO fdc_admin.bbr_anvendelse (bbr_anv_kode, bbr_anv_tekst, skade_kategori) VALUES (431, 'Hospital og sygehus', 'Offentlig');
INSERT INTO fdc_admin.bbr_anvendelse (bbr_anv_kode, bbr_anv_tekst, skade_kategori) VALUES (432, 'Hospice, behandlingshjem mv.', 'Erhverv');
INSERT INTO fdc_admin.bbr_anvendelse (bbr_anv_kode, bbr_anv_tekst, skade_kategori) VALUES (433, 'Sundhedscenter, lægehus, fødeklinik mv.', 'Offentlig');
INSERT INTO fdc_admin.bbr_anvendelse (bbr_anv_kode, bbr_anv_tekst, skade_kategori) VALUES (439, 'Anden bygning til sundhedsformål', 'Offentlig');
INSERT INTO fdc_admin.bbr_anvendelse (bbr_anv_kode, bbr_anv_tekst, skade_kategori) VALUES (440, '(UDFASES) Bygning til daginstitution', 'Offentlig');
INSERT INTO fdc_admin.bbr_anvendelse (bbr_anv_kode, bbr_anv_tekst, skade_kategori) VALUES (441, 'Daginstitution', 'Offentlig');
INSERT INTO fdc_admin.bbr_anvendelse (bbr_anv_kode, bbr_anv_tekst, skade_kategori) VALUES (442, 'Servicefunktion på døgninstitution', 'Offentlig');
INSERT INTO fdc_admin.bbr_anvendelse (bbr_anv_kode, bbr_anv_tekst, skade_kategori) VALUES (443, 'Kaserne', 'Offentlig');
INSERT INTO fdc_admin.bbr_anvendelse (bbr_anv_kode, bbr_anv_tekst, skade_kategori) VALUES (444, 'Fængsel, arresthus mv.', 'Offentlig');
INSERT INTO fdc_admin.bbr_anvendelse (bbr_anv_kode, bbr_anv_tekst, skade_kategori) VALUES (449, 'Anden bygning til institutionsformål', 'Offentlig');
INSERT INTO fdc_admin.bbr_anvendelse (bbr_anv_kode, bbr_anv_tekst, skade_kategori) VALUES (490, '(UDFASES) Bygning til anden institution, herunder kaserne, fængsel o. lign.', 'Offentlig');
INSERT INTO fdc_admin.bbr_anvendelse (bbr_anv_kode, bbr_anv_tekst, skade_kategori) VALUES (510, 'Bygninger til sommerhus', 'Sommerhus');
INSERT INTO fdc_admin.bbr_anvendelse (bbr_anv_kode, bbr_anv_tekst, skade_kategori) VALUES (520, '(UDFASES) Bygning til feriekoloni, vandrehjem o.lign. bortset fra sommerhus', 'Erhverv');
INSERT INTO fdc_admin.bbr_anvendelse (bbr_anv_kode, bbr_anv_tekst, skade_kategori) VALUES (521, 'Feriecenter, center til campingplads mv.', 'Erhverv');
INSERT INTO fdc_admin.bbr_anvendelse (bbr_anv_kode, bbr_anv_tekst, skade_kategori) VALUES (522, 'Bygning med ferielejligheder til erhvervsmæssig udlejning', 'Erhverv');
INSERT INTO fdc_admin.bbr_anvendelse (bbr_anv_kode, bbr_anv_tekst, skade_kategori) VALUES (523, 'Bygning med ferielejligheder til eget brug', 'Erhverv');
INSERT INTO fdc_admin.bbr_anvendelse (bbr_anv_kode, bbr_anv_tekst, skade_kategori) VALUES (532, 'Svømmehal', 'Erhverv');
INSERT INTO fdc_admin.bbr_anvendelse (bbr_anv_kode, bbr_anv_tekst, skade_kategori) VALUES (529, 'Anden bygning til ferieformål', 'Erhverv');
INSERT INTO fdc_admin.bbr_anvendelse (bbr_anv_kode, bbr_anv_tekst, skade_kategori) VALUES (530, '(UDFASES) Bygning i forbindelse med idrætsudøvelse (klubhus, idrætshal, svømmehal o. lign.)', 'Erhverv');
INSERT INTO fdc_admin.bbr_anvendelse (bbr_anv_kode, bbr_anv_tekst, skade_kategori) VALUES (531, 'Klubhus i forbindelse med fritid og idræt', 'Erhverv');
INSERT INTO fdc_admin.bbr_anvendelse (bbr_anv_kode, bbr_anv_tekst, skade_kategori) VALUES (533, 'Idrætshal', 'Erhverv');
INSERT INTO fdc_admin.bbr_anvendelse (bbr_anv_kode, bbr_anv_tekst, skade_kategori) VALUES (534, 'Tribune i forbindelse med stadion', 'Erhverv');
INSERT INTO fdc_admin.bbr_anvendelse (bbr_anv_kode, bbr_anv_tekst, skade_kategori) VALUES (535, 'Rideskole', 'Erhverv');
INSERT INTO fdc_admin.bbr_anvendelse (bbr_anv_kode, bbr_anv_tekst, skade_kategori) VALUES (539, 'Anden bygning til idrætformål', 'Erhverv');
INSERT INTO fdc_admin.bbr_anvendelse (bbr_anv_kode, bbr_anv_tekst, skade_kategori) VALUES (540, 'Kolonihavehus', 'Sommerhus');
INSERT INTO fdc_admin.bbr_anvendelse (bbr_anv_kode, bbr_anv_tekst, skade_kategori) VALUES (585, 'Anneks i tilknytning til fritids- og sommerhus', 'Anneks');
INSERT INTO fdc_admin.bbr_anvendelse (bbr_anv_kode, bbr_anv_tekst, skade_kategori) VALUES (590, 'Anden bygning til fritidsformål', 'Anneks');
INSERT INTO fdc_admin.bbr_anvendelse (bbr_anv_kode, bbr_anv_tekst, skade_kategori) VALUES (910, 'Garage (med plads til et eller to køretøjer)', 'Garage mm.');
INSERT INTO fdc_admin.bbr_anvendelse (bbr_anv_kode, bbr_anv_tekst, skade_kategori) VALUES (920, 'Carport', 'Garage mm.');
INSERT INTO fdc_admin.bbr_anvendelse (bbr_anv_kode, bbr_anv_tekst, skade_kategori) VALUES (930, 'Udhus', 'Garage mm.');
INSERT INTO fdc_admin.bbr_anvendelse (bbr_anv_kode, bbr_anv_tekst, skade_kategori) VALUES (940, 'Drivhus', 'Andet');
INSERT INTO fdc_admin.bbr_anvendelse (bbr_anv_kode, bbr_anv_tekst, skade_kategori) VALUES (950, 'Fritliggende overdækning', 'Andet');
INSERT INTO fdc_admin.bbr_anvendelse (bbr_anv_kode, bbr_anv_tekst, skade_kategori) VALUES (960, 'Fritliggende udestue', 'Andet');
INSERT INTO fdc_admin.bbr_anvendelse (bbr_anv_kode, bbr_anv_tekst, skade_kategori) VALUES (970, 'Tiloversbleven landbrugsbygning', 'Andet');
INSERT INTO fdc_admin.bbr_anvendelse (bbr_anv_kode, bbr_anv_tekst, skade_kategori) VALUES (990, 'Faldefærdig bygning', 'Andet');
INSERT INTO fdc_admin.bbr_anvendelse (bbr_anv_kode, bbr_anv_tekst, skade_kategori) VALUES (999, 'Ukendt bygning', 'Andet');


TRUNCATE TABLE fdc_admin.kvm_pris;
INSERT INTO fdc_admin.kvm_pris (kom_kode, kom_navn, kvm_pris) VALUES (101, 'København', 45176);
INSERT INTO fdc_admin.kvm_pris (kom_kode, kom_navn, kvm_pris) VALUES (147, 'Frederiksberg', 59438);
INSERT INTO fdc_admin.kvm_pris (kom_kode, kom_navn, kvm_pris) VALUES (151, 'Ballerup', 28690);
INSERT INTO fdc_admin.kvm_pris (kom_kode, kom_navn, kvm_pris) VALUES (153, 'Brøndby', 26420);
INSERT INTO fdc_admin.kvm_pris (kom_kode, kom_navn, kvm_pris) VALUES (155, 'Dragør', 35188);
INSERT INTO fdc_admin.kvm_pris (kom_kode, kom_navn, kvm_pris) VALUES (157, 'Gentofte', 49302);
INSERT INTO fdc_admin.kvm_pris (kom_kode, kom_navn, kvm_pris) VALUES (159, 'Gladsaxe', 33252);
INSERT INTO fdc_admin.kvm_pris (kom_kode, kom_navn, kvm_pris) VALUES (161, 'Glostrup', 27695);
INSERT INTO fdc_admin.kvm_pris (kom_kode, kom_navn, kvm_pris) VALUES (163, 'Herlev', 29974);
INSERT INTO fdc_admin.kvm_pris (kom_kode, kom_navn, kvm_pris) VALUES (165, 'Albertslund', 23424);
INSERT INTO fdc_admin.kvm_pris (kom_kode, kom_navn, kvm_pris) VALUES (167, 'Hvidovre', 31036);
INSERT INTO fdc_admin.kvm_pris (kom_kode, kom_navn, kvm_pris) VALUES (169, 'Høje-Taastrup', 23976);
INSERT INTO fdc_admin.kvm_pris (kom_kode, kom_navn, kvm_pris) VALUES (173, 'Lyngby-Taarbæk', 39551);
INSERT INTO fdc_admin.kvm_pris (kom_kode, kom_navn, kvm_pris) VALUES (175, 'Rødovre', 31634);
INSERT INTO fdc_admin.kvm_pris (kom_kode, kom_navn, kvm_pris) VALUES (183, 'Ishøj', 23212);
INSERT INTO fdc_admin.kvm_pris (kom_kode, kom_navn, kvm_pris) VALUES (185, 'Tårnby', 33092);
INSERT INTO fdc_admin.kvm_pris (kom_kode, kom_navn, kvm_pris) VALUES (187, 'Vallensbæk', 26305);
INSERT INTO fdc_admin.kvm_pris (kom_kode, kom_navn, kvm_pris) VALUES (190, 'Furesø', 29563);
INSERT INTO fdc_admin.kvm_pris (kom_kode, kom_navn, kvm_pris) VALUES (201, 'Allerød', 27341);
INSERT INTO fdc_admin.kvm_pris (kom_kode, kom_navn, kvm_pris) VALUES (210, 'Fredensborg', 23627);
INSERT INTO fdc_admin.kvm_pris (kom_kode, kom_navn, kvm_pris) VALUES (217, 'Helsingør', 25324);
INSERT INTO fdc_admin.kvm_pris (kom_kode, kom_navn, kvm_pris) VALUES (219, 'Hillerød', 24838);
INSERT INTO fdc_admin.kvm_pris (kom_kode, kom_navn, kvm_pris) VALUES (223, 'Hørsholm', 35647);
INSERT INTO fdc_admin.kvm_pris (kom_kode, kom_navn, kvm_pris) VALUES (230, 'Rudersdal', 35674);
INSERT INTO fdc_admin.kvm_pris (kom_kode, kom_navn, kvm_pris) VALUES (240, 'Egedal', 25282);
INSERT INTO fdc_admin.kvm_pris (kom_kode, kom_navn, kvm_pris) VALUES (250, 'Frederikssund', 20082);
INSERT INTO fdc_admin.kvm_pris (kom_kode, kom_navn, kvm_pris) VALUES (253, 'Greve', 27563);
INSERT INTO fdc_admin.kvm_pris (kom_kode, kom_navn, kvm_pris) VALUES (259, 'Køge', 24013);
INSERT INTO fdc_admin.kvm_pris (kom_kode, kom_navn, kvm_pris) VALUES (260, 'Halsnæs', 16758);
INSERT INTO fdc_admin.kvm_pris (kom_kode, kom_navn, kvm_pris) VALUES (265, 'Roskilde', 27134);
INSERT INTO fdc_admin.kvm_pris (kom_kode, kom_navn, kvm_pris) VALUES (269, 'Solrød', 27536);
INSERT INTO fdc_admin.kvm_pris (kom_kode, kom_navn, kvm_pris) VALUES (270, 'Gribskov', 19180);
INSERT INTO fdc_admin.kvm_pris (kom_kode, kom_navn, kvm_pris) VALUES (306, 'Odsherred', 11309);
INSERT INTO fdc_admin.kvm_pris (kom_kode, kom_navn, kvm_pris) VALUES (316, 'Holbæk', 18149);
INSERT INTO fdc_admin.kvm_pris (kom_kode, kom_navn, kvm_pris) VALUES (320, 'Faxe', 13763);
INSERT INTO fdc_admin.kvm_pris (kom_kode, kom_navn, kvm_pris) VALUES (326, 'Kalundborg', 9007);
INSERT INTO fdc_admin.kvm_pris (kom_kode, kom_navn, kvm_pris) VALUES (329, 'Ringsted', 15186);
INSERT INTO fdc_admin.kvm_pris (kom_kode, kom_navn, kvm_pris) VALUES (330, 'Slagelse', 11445);
INSERT INTO fdc_admin.kvm_pris (kom_kode, kom_navn, kvm_pris) VALUES (336, 'Stevns', 13202);
INSERT INTO fdc_admin.kvm_pris (kom_kode, kom_navn, kvm_pris) VALUES (340, 'Sorø', 12856);
INSERT INTO fdc_admin.kvm_pris (kom_kode, kom_navn, kvm_pris) VALUES (350, 'Lejre', 18255);
INSERT INTO fdc_admin.kvm_pris (kom_kode, kom_navn, kvm_pris) VALUES (360, 'Lolland', 4596);
INSERT INTO fdc_admin.kvm_pris (kom_kode, kom_navn, kvm_pris) VALUES (370, 'Næstved', 12866);
INSERT INTO fdc_admin.kvm_pris (kom_kode, kom_navn, kvm_pris) VALUES (376, 'Guldborgsund', 9381);
INSERT INTO fdc_admin.kvm_pris (kom_kode, kom_navn, kvm_pris) VALUES (390, 'Vordingborg', 11425);
INSERT INTO fdc_admin.kvm_pris (kom_kode, kom_navn, kvm_pris) VALUES (400, 'Bornholm', 12527);
INSERT INTO fdc_admin.kvm_pris (kom_kode, kom_navn, kvm_pris) VALUES (410, 'Middelfart', 13999);
INSERT INTO fdc_admin.kvm_pris (kom_kode, kom_navn, kvm_pris) VALUES (411, 'Christiansø', NULL);
INSERT INTO fdc_admin.kvm_pris (kom_kode, kom_navn, kvm_pris) VALUES (420, 'Assens', 7879);
INSERT INTO fdc_admin.kvm_pris (kom_kode, kom_navn, kvm_pris) VALUES (430, 'Faaborg-Midtfyn', 10176);
INSERT INTO fdc_admin.kvm_pris (kom_kode, kom_navn, kvm_pris) VALUES (440, 'Kerteminde', 11366);
INSERT INTO fdc_admin.kvm_pris (kom_kode, kom_navn, kvm_pris) VALUES (450, 'Nyborg', 11595);
INSERT INTO fdc_admin.kvm_pris (kom_kode, kom_navn, kvm_pris) VALUES (461, 'Odense', 20248);
INSERT INTO fdc_admin.kvm_pris (kom_kode, kom_navn, kvm_pris) VALUES (479, 'Svendborg', 14294);
INSERT INTO fdc_admin.kvm_pris (kom_kode, kom_navn, kvm_pris) VALUES (480, 'Nordfyns', 12339);
INSERT INTO fdc_admin.kvm_pris (kom_kode, kom_navn, kvm_pris) VALUES (482, 'Langeland', 9558);
INSERT INTO fdc_admin.kvm_pris (kom_kode, kom_navn, kvm_pris) VALUES (492, 'Ærø', 6836);
INSERT INTO fdc_admin.kvm_pris (kom_kode, kom_navn, kvm_pris) VALUES (510, 'Haderslev', 10428);
INSERT INTO fdc_admin.kvm_pris (kom_kode, kom_navn, kvm_pris) VALUES (530, 'Billund', 9325);
INSERT INTO fdc_admin.kvm_pris (kom_kode, kom_navn, kvm_pris) VALUES (540, 'Sønderborg', 10989);
INSERT INTO fdc_admin.kvm_pris (kom_kode, kom_navn, kvm_pris) VALUES (550, 'Tønder', 8291);
INSERT INTO fdc_admin.kvm_pris (kom_kode, kom_navn, kvm_pris) VALUES (561, 'Esbjerg', 14513);
INSERT INTO fdc_admin.kvm_pris (kom_kode, kom_navn, kvm_pris) VALUES (563, 'Fanø', 13030);
INSERT INTO fdc_admin.kvm_pris (kom_kode, kom_navn, kvm_pris) VALUES (573, 'Varde', 10444);
INSERT INTO fdc_admin.kvm_pris (kom_kode, kom_navn, kvm_pris) VALUES (575, 'Vejen', 8031);
INSERT INTO fdc_admin.kvm_pris (kom_kode, kom_navn, kvm_pris) VALUES (580, 'Aabenraa', 9667);
INSERT INTO fdc_admin.kvm_pris (kom_kode, kom_navn, kvm_pris) VALUES (607, 'Fredericia', 13168);
INSERT INTO fdc_admin.kvm_pris (kom_kode, kom_navn, kvm_pris) VALUES (615, 'Horsens',  14417);
INSERT INTO fdc_admin.kvm_pris (kom_kode, kom_navn, kvm_pris) VALUES (621, 'Kolding', 14294);
INSERT INTO fdc_admin.kvm_pris (kom_kode, kom_navn, kvm_pris) VALUES (630, 'Vejle', 16023);
INSERT INTO fdc_admin.kvm_pris (kom_kode, kom_navn, kvm_pris) VALUES (657, 'Herning', 12833);
INSERT INTO fdc_admin.kvm_pris (kom_kode, kom_navn, kvm_pris) VALUES (661, 'Holstebro', 11470);
INSERT INTO fdc_admin.kvm_pris (kom_kode, kom_navn, kvm_pris) VALUES (665, 'Lemvig', 8211);
INSERT INTO fdc_admin.kvm_pris (kom_kode, kom_navn, kvm_pris) VALUES (671, 'Struer', 7435);
INSERT INTO fdc_admin.kvm_pris (kom_kode, kom_navn, kvm_pris) VALUES (706, 'Syddjurs', 16043);
INSERT INTO fdc_admin.kvm_pris (kom_kode, kom_navn, kvm_pris) VALUES (707, 'Norddjurs', 8376);
INSERT INTO fdc_admin.kvm_pris (kom_kode, kom_navn, kvm_pris) VALUES (710, 'Favrskov', 13207);
INSERT INTO fdc_admin.kvm_pris (kom_kode, kom_navn, kvm_pris) VALUES (727, 'Odder', 14663);
INSERT INTO fdc_admin.kvm_pris (kom_kode, kom_navn, kvm_pris) VALUES (730, 'Randers', 10454);
INSERT INTO fdc_admin.kvm_pris (kom_kode, kom_navn, kvm_pris) VALUES (740, 'Silkeborg', 16612);
INSERT INTO fdc_admin.kvm_pris (kom_kode, kom_navn, kvm_pris) VALUES (741, 'Samsø', 8242);
INSERT INTO fdc_admin.kvm_pris (kom_kode, kom_navn, kvm_pris) VALUES (746, 'Skanderborg', 19055);
INSERT INTO fdc_admin.kvm_pris (kom_kode, kom_navn, kvm_pris) VALUES (751, 'Aarhus', 30649);
INSERT INTO fdc_admin.kvm_pris (kom_kode, kom_navn, kvm_pris) VALUES (756, 'Ikast-Brande', 11393);
INSERT INTO fdc_admin.kvm_pris (kom_kode, kom_navn, kvm_pris) VALUES (760, 'Ringkøbing-Skjern', 11188);
INSERT INTO fdc_admin.kvm_pris (kom_kode, kom_navn, kvm_pris) VALUES (766, 'Hedensted', 12912);
INSERT INTO fdc_admin.kvm_pris (kom_kode, kom_navn, kvm_pris) VALUES (773, 'Morsø', 5353);
INSERT INTO fdc_admin.kvm_pris (kom_kode, kom_navn, kvm_pris) VALUES (779, 'Skive', 7593);
INSERT INTO fdc_admin.kvm_pris (kom_kode, kom_navn, kvm_pris) VALUES (787, 'Thisted', 9780);
INSERT INTO fdc_admin.kvm_pris (kom_kode, kom_navn, kvm_pris) VALUES (791, 'Viborg', 11738);
INSERT INTO fdc_admin.kvm_pris (kom_kode, kom_navn, kvm_pris) VALUES (810, 'Brønderslev', 7673);
INSERT INTO fdc_admin.kvm_pris (kom_kode, kom_navn, kvm_pris) VALUES (813, 'Frederikshavn', 14226);
INSERT INTO fdc_admin.kvm_pris (kom_kode, kom_navn, kvm_pris) VALUES (820, 'Vesthimmerlands', 6987);
INSERT INTO fdc_admin.kvm_pris (kom_kode, kom_navn, kvm_pris) VALUES (825, 'Læsø', NULL);
INSERT INTO fdc_admin.kvm_pris (kom_kode, kom_navn, kvm_pris) VALUES (840, 'Rebild', 10752);
INSERT INTO fdc_admin.kvm_pris (kom_kode, kom_navn, kvm_pris) VALUES (846, 'Mariagerfjord', 9581);
INSERT INTO fdc_admin.kvm_pris (kom_kode, kom_navn, kvm_pris) VALUES (849, 'Jammerbugt', 11058);
INSERT INTO fdc_admin.kvm_pris (kom_kode, kom_navn, kvm_pris) VALUES (851, 'Aalborg', 17421);
INSERT INTO fdc_admin.kvm_pris (kom_kode, kom_navn, kvm_pris) VALUES (860, 'Hjørring', 10664);
INSERT INTO fdc_admin.kvm_pris (kom_kode, kom_navn, kvm_pris) VALUES (999, 'Danmark', 13897);


--
-- TOC entry 4007 (class 0 OID 90304)
-- Dependencies: 212
-- Data for Name: parametre; Type: TABLE DATA; Schema: fdc_admin; Owner: -
--

TRUNCATE TABLE fdc_admin.parametre;
INSERT INTO fdc_admin.parametre (name, parent, value, type, minval, maxval, lookupvalues, "default", explanation, sort, checkable) VALUES ('General', '', '', 'G', '', '', '', '', 'Hovedgrupper til administration af grundlæggende parametre for systemet', 1, ' ');
INSERT INTO fdc_admin.parametre (name, parent, value, type, minval, maxval, lookupvalues, "default", explanation, sort, checkable) VALUES ('Cell layername', 'General', 'celler', 'T', '', '', '', '', '', 1, ' ');
INSERT INTO fdc_admin.parametre (name, parent, value, type, minval, maxval, lookupvalues, "default", explanation, sort, checkable) VALUES ('Name of model value section', 'General', 'Generelle modelværdier', 'T', '', '', '', '', '', 1, ' ');
INSERT INTO fdc_admin.parametre (name, parent, value, type, minval, maxval, lookupvalues, "default", explanation, sort, checkable) VALUES ('Clear cell layer template', 'General', 'UPDATE "{schema}"."{table}" SET val_intersect = 0.0, num_intersect = 0
', 'P', '', '', '', '', '', 1, ' ');
INSERT INTO fdc_admin.parametre (name, parent, value, type, minval, maxval, lookupvalues, "default", explanation, sort, checkable) VALUES ('Cell size', 'General', '100', 'I', '10', '1000', '50', '', '', 1, ' ');
INSERT INTO fdc_admin.parametre (name, parent, value, type, minval, maxval, lookupvalues, "default", explanation, sort, checkable) VALUES ('Delete parameter table', 'General', 'DELETE FROM {parametertable}', 'P', '', '', '', '', '', 1, ' ');
INSERT INTO fdc_admin.parametre (name, parent, value, type, minval, maxval, lookupvalues, "default", explanation, sort, checkable) VALUES ('update cell layer', 'General', 'WITH cte AS (
  SELECT
    a.fid AS fid,
    a.i AS i,
    a.j AS j,
    sum(
      CASE 				  
        WHEN ST_GeometryType(b.{geom_value}) ILIKE ''%POINT%'' THEN b.{value_value} 				  
        WHEN ST_GeometryType(b.{geom_value}) ILIKE ''%LINE%'' THEN b.{value_value} * st_length(st_intersection(a.{geom_cell},b.{geom_value}))/st_length(b.{geom_value})				  
        WHEN ST_GeometryType(b.{geom_value}) ILIKE ''%POLYGON%'' THEN b.{value_value} * st_area(st_intersection(a.{geom_cell},b.{geom_value}))/st_area(b.{geom_value})	  
        ELSE -10000000.00      
      END
    ) as sum_value,
    count(*) as count_number
  FROM {cell_table} a JOIN {value_table} b ON st_intersects (a.{geom_cell},b.{geom_value})
  GROUP BY a.fid, a.i, a.j
)
UPDATE {cell_table} SET 
  val_intersect = val_intersect + sum_value, 
  num_intersect = num_intersect + count_number 
FROM cte
WHERE {cell_table}.fid = cte.fid; ', 'P', '', '', '', '', '', 1, ' ');
INSERT INTO fdc_admin.parametre (name, parent, value, type, minval, maxval, lookupvalues, "default", explanation, sort, checkable) VALUES ('Create cell layer template', 'General', 'CREATE TABLE IF NOT EXISTS {celltable} AS
  WITH g AS (
    SELECT (
      st_squaregrid({cellsize}, st_geomfromewkt(''SRID={epsg}; POLYGON(({xmin} {ymin},{xmax} {ymin},{xmax} {ymax},{xmin} {ymax},{xmin} {ymin}))''))
	).*
  )
  SELECT
    row_number() OVER () AS fid,
    *,
    0.0::NUMERIC(12,2) AS val_intersect, 
    0 AS num_intersect 
  FROM g;
ALTER TABLE {celltable} ADD PRIMARY KEY(fid);
CREATE INDEX ON {celltable} USING GIST(geom);', 'P', '', '', '', '', '', 1, ' ');
INSERT INTO fdc_admin.parametre (name, parent, value, type, minval, maxval, lookupvalues, "default", explanation, sort, checkable) VALUES ('Insert parameter table', 'General', 'INSERT INTO {parametertable} ({parametercolumns}) VALUES ({parametervalues}', 'P', '', '', '', '', '', 1, ' ');
INSERT INTO fdc_admin.parametre (name, parent, value, type, minval, maxval, lookupvalues, "default", explanation, sort, checkable) VALUES ('Fetch parameter table', 'General', 'WITH RECURSIVE tree_search AS (SELECT *, 0 AS "level" FROM {parametertable} WHERE "parent" = '''' AND name <> '''' UNION ALL SELECT t.*, ts."level"+1 AS "level" FROM {parametertable} t, tree_search ts WHERE t."parent" = ts."name") SELECT * FROM tree_search ORDER BY "level", "sort";', 'P', '', '', '', '', '', 1, ' ');
INSERT INTO fdc_admin.parametre (name, parent, value, type, minval, maxval, lookupvalues, "default", explanation, sort, checkable) VALUES ('Drop schema command', 'General', 'DROP SCHEMA {} /CASCADE', 'P', '', '', '', '', '', 10, ' ');
INSERT INTO fdc_admin.parametre (name, parent, value, type, minval, maxval, lookupvalues, "default", explanation, sort, checkable) VALUES ('Create schema command', 'General', 'CREATE SCHEMA {}', 'P', '', '', '', '', '', 10, ' ');
INSERT INTO fdc_admin.parametre (name, parent, value, type, minval, maxval, lookupvalues, "default", explanation, sort, checkable) VALUES ('Create_result_table', 'General', 'CREATE TABLE IF NOT EXISTS "{Result_schema}"."{tablename_ts}" AS {sqlquery}', 'P', '', '', '', '', 'SQL template for creating result tables', 10, ' ');
INSERT INTO fdc_admin.parametre (name, parent, value, type, minval, maxval, lookupvalues, "default", explanation, sort, checkable) VALUES ('Main groupname', 'General', 'Modeller', 'T', '', '', '', '', '', 10, ' ');
INSERT INTO fdc_admin.parametre (name, parent, value, type, minval, maxval, lookupvalues, "default", explanation, sort, checkable) VALUES ('Group name template', 'General', 'Kørsel: {time_stamp}', 'T', '', '', '', '', '', 10, ' ');
INSERT INTO fdc_admin.parametre (name, parent, value, type, minval, maxval, lookupvalues, "default", explanation, sort, checkable) VALUES ('Create_result_pkey', 'General', 'ALTER TABLE "{Result_schema}"."{tablename_ts}" ADD PRIMARY KEY ({pkey_column});  ', 'P', '', '', '', '', '', 10, ' ');
INSERT INTO fdc_admin.parametre (name, parent, value, type, minval, maxval, lookupvalues, "default", explanation, sort, checkable) VALUES ('Create_result_index', 'General', 'CREATE INDEX ON "{Result_schema}"."{tablename_ts}" USING GIST ({geom_column})', 'P', '', '', '', '', '', 10, ' ');
INSERT INTO fdc_admin.parametre (name, parent, value, type, minval, maxval, lookupvalues, "default", explanation, sort, checkable) VALUES ('Model_layergroup', 'General', 'Resultater fra modelkørsler', 'T', '', '', '', '', '', 10, ' ');
INSERT INTO fdc_admin.parametre (name, parent, value, type, minval, maxval, lookupvalues, "default", explanation, sort, checkable) VALUES ('Create comment command', 'General', 'COMMENT ON {} {} IS {}', 'P', '', '', '', '', '', 10, ' ');
INSERT INTO fdc_admin.parametre (name, parent, value, type, minval, maxval, lookupvalues, "default", explanation, sort, checkable) VALUES ('Queries', '', '', 'G', '', '', '', '', 'Hovedgrupper til administration af Forespørgsler', 1, ' ');
INSERT INTO fdc_admin.parametre (name, parent, value, type, minval, maxval, lookupvalues, "default", explanation, sort, checkable) VALUES ('q_infrastructure', 'Queries', 'SELECT DISTINCT
  k.*
  FROM {t_infrastructure} k
  INNER JOIN {t_flood} o on st_intersects(k.{f_geom_t_infrastructure},o.{f_geom_t_flood})
  WHERE o.{f_depth_t_flood} >= {Minimum vanddybde (meter)}', 'P', '', '', '', '', '', 6, ' ');
INSERT INTO fdc_admin.parametre (name, parent, value, type, minval, maxval, lookupvalues, "default", explanation, sort, checkable) VALUES ('q_publicservice', 'Queries', 'SELECT DISTINCT
  k.*
  FROM {t_publicservice} k
  INNER JOIN {t_flood} o on st_intersects(k.{f_geom_t_publicservice},o.{f_geom_t_flood})
  WHERE o.{f_depth_t_flood} >= {Minimum vanddybde (meter)}', 'P', '', '', '', '', '', 6, ' ');
INSERT INTO fdc_admin.parametre (name, parent, value, type, minval, maxval, lookupvalues, "default", explanation, sort, checkable) VALUES ('f_pkey_q_bioscore_alphanumeric', 'q_bioscore_alphanumeric', 'fid', 'T', '', '', '', '', '', 10, ' ');
INSERT INTO fdc_admin.parametre (name, parent, value, type, minval, maxval, lookupvalues, "default", explanation, sort, checkable) VALUES ('q_building', 'Queries', 'WITH ob AS
(
    SELECT
        b.{f_pkey_t_building} as {f_pkey_q_building},
        b.{f_muncode_t_building} AS kom_kode,
		b.{f_usage_code_t_building} AS bbr_kode,
        b.{f_cellar_area_t_building}::NUMERIC(12,2) AS areal_kaelder_m2,
        st_area(b.{f_geom_t_building})::NUMERIC(12,2) AS areal_byg_m2,
        {Værditab, skaderamte bygninger (%)}::NUMERIC(12,2) as tab_procent,
        st_force2d(b.{f_geom_t_building}) AS {f_geom_q_building},
        COUNT (*) AS cnt_oversvoem,
        (SUM(st_area(st_intersection(b.{f_geom_t_building},o.{f_geom_t_flood}))))::NUMERIC(12,2) AS areal_oversvoem_m2,
        (MIN(o.{f_depth_t_flood}) * 100.00)::NUMERIC(12,2) AS min_vanddybde_cm,
        (MAX(o.{f_depth_t_flood}) * 100.00)::NUMERIC(12,2) AS max_vanddybde_cm,
        (AVG(o.{f_depth_t_flood}) * 100.00)::NUMERIC(12,2) AS avg_vanddybde_cm
        --(SUM(o.{f_depth_t_flood}*st_area(st_intersection(b.{f_geom_t_building},o.{f_geom_t_flood}))) * 100.0 / SUM(st_area(st_intersection(b.{f_geom_t_building},o.{f_geom_t_flood}))))::NUMERIC(12,2) AS avg_vanddybde_cm
    FROM {t_building} b
    INNER JOIN {t_flood} o on st_intersects(b.{f_geom_t_building},o.{f_geom_t_flood})
    WHERE o.{f_depth_t_flood} >= {Minimum vanddybde (meter)}
    GROUP BY b.{f_pkey_t_building}, b.{f_muncode_t_building}, b.{f_usage_code_t_building}, b.{f_cellar_area_t_building}, b.{f_geom_t_building}
),
os AS
(
    SELECT ob.*, 
        u.{f_pkey_t_build_usage} AS bbr_anv_kode,
        u.{f_usage_text_t_build_usage} AS bbr_anv_tekst,
        d.{f_category_t_damage} AS skade_kategori,
        d.{f_type_t_damage} AS skade_type,
        k.{f_sqmprice_t_sqmprice}::NUMERIC(12,2) as kvm_pris_kr,
        (k.{f_sqmprice_t_sqmprice} * ob.areal_byg_m2 * {Værditab, skaderamte bygninger (%)}/100.0)::NUMERIC(12,2) as {f_loss_q_building},
        (d.b0 + ob.areal_byg_m2 * (d.b1 * ln(ob.max_vanddybde_cm) + d.b2))::NUMERIC(12,2) AS {f_damage_q_building},
        CASE
	        WHEN ''{Skadeberegning for kælder}'' = ''Medtages ikke'' THEN 0.0
	        WHEN ''{Skadeberegning for kælder}'' = ''Medtages'' THEN ob.areal_kaelder_m2 * d.c0 
        END::NUMERIC(12,2) as {f_cellar_damage_q_building}

    FROM ob
    LEFT JOIN {t_build_usage} u on ob.bbr_kode = u.{f_pkey_t_build_usage}
    LEFT JOIN {t_damage} d on u.{f_category_t_build_usage} = d.{f_category_t_damage} AND d.{f_type_t_damage} = ''{Skadetype}''   
    LEFT JOIN {t_sqmprice} k on (ob.kom_kode = k.{f_muncode_t_sqmprice})

)
SELECT 
    os.*,
	(
	CASE
	    WHEN ''{Medtag i risikoberegninger}'' = ''Intet (0 kr.)'' THEN 0.0
	    WHEN ''{Medtag i risikoberegninger}'' = ''Skadebeløb'' THEN os.{f_damage_q_building} + os.{f_cellar_damage_q_building}
	    WHEN ''{Medtag i risikoberegninger}'' = ''Værditab'' THEN os.{f_loss_q_building}
	    WHEN ''{Medtag i risikoberegninger}'' = ''Skadebeløb og værditab'' THEN os.{f_damage_q_building} + os.{f_cellar_damage_q_building} + os.{f_loss_q_building} 
	END * (0.089925/{Returperiode for hændelse i fremtiden (år)} + 0.21905/{Returperiode for hændelse i dag (år)}))::NUMERIC(12,2) AS {f_risk_q_building}
FROM os
', 'P', '', '', '', '', 'SQL template for "Bygninger" model ', 10, ' ');
INSERT INTO fdc_admin.parametre (name, parent, value, type, minval, maxval, lookupvalues, "default", explanation, sort, checkable) VALUES ('q_bioscore_spatial', 'Queries', 'SELECT
  b.{f_pkey_t_bioscore} as pkey,
  b.{f_bioscore_t_bioscore} as bioscore,
  st_area(st_intersection(b.{f_geom_t_bioscore},o.{f_geom_t_flood}))::NUMERIC(12,2) AS areal_m2,
  st_intersection(b.{f_geom_t_bioscore},o.{f_geom_t_flood}) as geom_clip,
  o.{f_depth_t_flood} as depth
  FROM {t_bioscore} b
  INNER JOIN {t_flood} o on st_intersects(b.{f_geom_t_bioscore},o.{f_geom_t_flood})
  WHERE o.{f_depth_t_flood} >= {Minimum vanddybde (meter)}
  ', 'P', '', '', '', '', '', 10, ' ');
INSERT INTO fdc_admin.parametre (name, parent, value, type, minval, maxval, lookupvalues, "default", explanation, sort, checkable) VALUES ('q_comp_nobuild', 'Queries', 'SELECT 
  c.{f_pkey_t_company} AS {f_pkey_q_comp_nobuild}, 
  c."Virk_cvrnr",
  c.pnr,
  c.modifikati,
  c.ajourfoeri,
  c."Virk_gyldi",
  c.{f_geom_t_company} AS {f_geom_q_comp_nobuild}, 
  o.{f_depth_t_flood} 
  FROM {t_company} c 
  LEFT JOIN {t_flood} o ON st_within(c.{f_geom_t_company},o.{f_geom_t_flood})
  LEFT JOIN {t_building} b ON st_within(c.{f_geom_t_company},b.{f_geom_t_building})
  WHERE o.{f_depth_t_flood} >= {Minimum vanddybde (meter)} AND b.{f_pkey_t_building} IS NULL
', 'P', '', '', '', '', '', 10, ' ');
INSERT INTO fdc_admin.parametre (name, parent, value, type, minval, maxval, lookupvalues, "default", explanation, sort, checkable) VALUES ('q_bioscore_alphanumeric', 'Queries', '  SELECT
  row_number() over () as {f_pkey_q_bioscore_alphanumeric},    b.{f_bioscore_t_bioscore} as bioscore,
  sum(st_area(st_intersection(b.{f_geom_t_bioscore},o.{f_geom_t_flood})))::NUMERIC(12,2) AS sum_area_m2,
  min(o.{f_depth_t_flood})::NUMERIC(12,2) as min_depth_m,
  max(o.{f_depth_t_flood})::NUMERIC(12,2) as max_depth_m
  FROM {t_bioscore} b
  INNER JOIN {t_flood} o on st_intersects(b.{f_geom_t_bioscore},o.{f_geom_t_flood})
  WHERE o.{f_depth_t_flood} >= {Minimum vanddybde (meter)}
  group by b.{f_bioscore_t_bioscore};', 'P', '', '', '', '', '', 10, ' ');
INSERT INTO fdc_admin.parametre (name, parent, value, type, minval, maxval, lookupvalues, "default", explanation, sort, checkable) VALUES ('Skadeberegning, Rekreative områder', 'Rekreative områder', '', 'T', '', '', '', 'q_recreative', 'Sæt hak såfremt der skal beregnes økonomiske tab i forbindelse med reduceret adgang til rekreative områder som bliver berørt at den pågældende oversvømmelse.', 12, 'T');
INSERT INTO fdc_admin.parametre (name, parent, value, type, minval, maxval, lookupvalues, "default", explanation, sort, checkable) VALUES ('Industri, personale i bygninger', 'Industri', ' ', 'T', '', '', '', 'q_comp_build', 'Sæt hak såfremt modellen skal identificere de virksomheder som bliver berørt af den pågældende oversvømmelse, og angive antallet af medarbejdere per virksomhed.', 10, 'T');
INSERT INTO fdc_admin.parametre (name, parent, value, type, minval, maxval, lookupvalues, "default", explanation, sort, checkable) VALUES ('Industri, punkter fejlplaceret', 'Industri', '', 'T', '', '', '', 'q_comp_nobuild', '', 11, 'T');
INSERT INTO fdc_admin.parametre (name, parent, value, type, minval, maxval, lookupvalues, "default", explanation, sort, checkable) VALUES ('Humane omkostninger ', 'Mennesker og helbred', '', 'T', '', '', '', 'q_human_health', 'Sæt hak såfremt der skal beregnes økonomiske tab ifm. oprydning, sygedage og feriedage som en konsekvens af ens ejendom har været oversvømmet.', 11, 'T');
INSERT INTO fdc_admin.parametre (name, parent, value, type, minval, maxval, lookupvalues, "default", explanation, sort, checkable) VALUES ('q_surrounding_loss', 'Queries', 'WITH 
  vb AS (
    SELECT
      st_union(b.{f_geom_t_building}) AS geom 
    FROM {t_building} b 
    JOIN {t_flood} o 
    ON st_intersects(o.{f_geom_t_flood}, b.{f_geom_t_building}) 
    WHERE o.{f_depth_t_flood} >= {Minimum vanddybde (meter)}),
    
  ob AS (
	SELECT
      distinct b.{f_pkey_t_building} as fid
    FROM {t_building} b 
    JOIN {t_flood} o 
    ON st_intersects(o.{f_geom_t_flood}, b.{f_geom_t_building}) 
    WHERE o.{f_depth_t_flood} >= {Minimum vanddybde (meter)}),

  fb AS (
    SELECT
      b.{f_pkey_t_building} AS {f_pkey_q_building},
      b.{f_muncode_t_building} AS kom_kode,
      b.{f_usage_code_t_building} AS bbr_anv_kode,
      b.{f_usage_text_t_building} AS bbr_anv_tekst,
      st_area(b.{f_geom_t_building})::NUMERIC(12,2) AS areal_byg_m2,
      k.{f_sqmprice_t_sqmprice}::NUMERIC(12,2) AS kvm_pris_kr,
      ({Værditab, skaderamte bygninger (%)}*{Faktor for værditab})::NUMERIC(12,2) AS tab_procent,
      (k.{f_sqmprice_t_sqmprice} * st_area(b.{f_geom_t_building}) * {Værditab, skaderamte bygninger (%)} * {Faktor for værditab} / 100.0)::NUMERIC(12,2) AS vaerditab_kr,
      st_force2d(b.{f_geom_t_building}) AS {f_geom_q_building}
        
    FROM {t_building} b
    LEFT JOIN ob ON ob.fid=b.{f_pkey_t_building} 
    LEFT JOIN {t_sqmprice} k ON b.{f_muncode_t_building}=k.{f_muncode_t_sqmprice}
    INNER JOIN vb ON st_dwithin(vb.geom, b.{f_geom_t_building}, {Bredde af nabozone (meter)})
    WHERE ob.fid IS NULL)

SELECT 
    fb.*,
	(
	CASE
	    WHEN ''{Medtag i risikoberegninger}'' = ''Intet (0 kr.)'' THEN 0.0
	    WHEN ''{Medtag i risikoberegninger}'' = ''Skadebeløb'' THEN 0.0
	    WHEN ''{Medtag i risikoberegninger}'' = ''Værditab'' THEN fb.vaerditab_kr
	    WHEN ''{Medtag i risikoberegninger}'' = ''Skadebeløb og værditab'' THEN 0.0 + fb.vaerditab_kr 
	END * (0.089925/{Returperiode for hændelse i fremtiden (år)} + 0.21905/{Returperiode for hændelse i dag (år)}))::NUMERIC(12,2) AS risiko_kr
FROM fb
', 'P', '', '', '', '', 'SQL template for "Nabobygninge værditabar" model ', 10, ' ');
INSERT INTO fdc_admin.parametre (name, parent, value, type, minval, maxval, lookupvalues, "default", explanation, sort, checkable) VALUES ('q_comp_build', 'Queries', 'WITH fb AS
(
  SELECT DISTINCT
    b.{f_pkey_t_building} as {f_pkey_q_comp_build},
    b.{f_muncode_t_building} AS kom_kode,
    b.{f_usage_code_t_building} AS bbr_anv_kode,
    b.{f_usage_text_t_building} AS bbr_anv_tekst,
    st_force2d(b.{f_geom_t_building}) AS {f_geom_q_comp_build}
  FROM {t_building} b
  INNER JOIN {t_flood} o on st_intersects(b.{f_geom_t_building},o.{f_geom_t_flood})
  WHERE o.{f_depth_t_flood} >= {Minimum vanddybde (meter)}
)
SELECT 
  fb.{f_pkey_q_comp_build},
  fb.kom_kode,
  fb.bbr_anv_kode,
  fb.bbr_anv_tekst,
  fb.{f_geom_q_comp_build},
  SUM(c.{f_empcount_t_company})::bigint AS empl_cnt, 
  COUNT(*) AS comp_cnt,
  COUNT(*) FILTER (WHERE c.{f_empcount_t_company} = 0) AS empcnt_zero,
  COUNT(*) FILTER (WHERE c.{f_empcount_t_company} > 0) AS empcnt_nonzero
FROM fb INNER JOIN {t_company} c on st_within(c.{f_geom_t_company},fb.{f_geom_q_comp_build})
GROUP BY fb.{f_pkey_q_comp_build}, fb.kom_kode, fb.bbr_anv_kode, fb.bbr_anv_tekst, fb.{f_geom_q_comp_build}', 'P', '', '', '', '', 'Query for compagny-buiding-emplyee', 10, ' ');
INSERT INTO fdc_admin.parametre (name, parent, value, type, minval, maxval, lookupvalues, "default", explanation, sort, checkable) VALUES ('q_recreative', 'Queries', 'WITH fr AS
(
  SELECT 
    r.{f_pkey_t_recreative} as {f_pkey_q_recreative},
    st_force2d(MIN(r.{f_geom_t_recreative})) AS {f_geom_q_recreative},
    MIN(r.gridcode) AS gridcode, 
    MIN(r.valuationk) AS valuation_kr,
    st_area(MIN(r.{f_geom_t_recreative}))::NUMERIC(12,2)  AS areal_org_m2,
    (SUM(st_area(st_intersection(r.{f_geom_t_recreative},o.{f_geom_t_flood}))))::NUMERIC(12,2) AS areal_oversvoem_m2,
    (MIN(o.{f_depth_t_flood}) * 100.00)::NUMERIC(12,2) AS min_vanddybde_cm,
    (MAX(o.{f_depth_t_flood}) * 100.00)::NUMERIC(12,2) AS max_vanddybde_cm,
    (AVG(o.{f_depth_t_flood}) * 100.00)::NUMERIC(12,2) AS avg_vanddybde_cm
    --(SUM(o.{f_depth_t_flood}*st_area(st_intersection(r.{f_geom_t_recreative},o.{f_geom_t_flood}))) * 100.0 / SUM(st_area(st_intersection(r.{f_geom_t_recreative},o.{f_geom_t_flood}))))::NUMERIC(12,2) AS avg_vanddybde_cm
  FROM {t_recreative} r
  INNER JOIN {t_flood} o on st_intersects(r.{f_geom_t_recreative},o.{f_geom_t_flood})
  WHERE o.{f_depth_t_flood} >= {Minimum vanddybde (meter)}
  GROUP BY r.{f_pkey_t_recreative}
),
qr AS (
  SELECT fr.*,   
    {Antal dage med oversvømmelse} AS periode_dage, 
    (100.0 * fr.areal_oversvoem_m2 / fr.areal_org_m2)::NUMERIC(12,2) AS oversvoem_pct,
    (({Antal dage med oversvømmelse}/365.0) * (fr.areal_oversvoem_m2 / fr.areal_org_m2) * fr.valuation_kr)::NUMERIC(12,2)  AS total_omkost_kr
  FROM fr
)

SELECT 
  qr.*,
  (
    CASE
      WHEN ''{Medtag i risikoberegninger}'' = ''Intet (0 kr.)'' THEN 0.0
      WHEN ''{Medtag i risikoberegninger}'' = ''Skadebeløb'' THEN qr.total_omkost_kr
      WHEN ''{Medtag i risikoberegninger}'' = ''Værditab'' THEN 0.0
      WHEN ''{Medtag i risikoberegninger}'' = ''Skadebeløb og værditab'' THEN 0.0 + qr.total_omkost_kr 
    END * (0.089925/{Returperiode for hændelse i fremtiden (år)} + 0.21905/{Returperiode for hændelse i dag (år)}))::NUMERIC(12,2) AS risiko_kr
FROM qr
', 'P', '', '', '', '', '', 10, ' ');
INSERT INTO fdc_admin.parametre (name, parent, value, type, minval, maxval, lookupvalues, "default", explanation, sort, checkable) VALUES ('q_road_traffic', 'Queries', 'WITH
    tr AS (
        SELECT
            v.{f_pkey_t_road_traffic} as {f_pkey_q_road_traffic},
            st_force2d(v.{f_geom_t_road_traffic}) AS {f_geom_q_road_traffic},
            st_length(v.{f_geom_t_road_traffic})::NUMERIC(12,2) AS laengde_org_m,
            v.{f_number_cars_t_road_traffic} AS gennemsnit_biler_pr_dag,
            COUNT(*) AS ant_oversvoem,
            (SUM(st_length(st_intersection(v.{f_geom_t_road_traffic},o.{f_geom_t_flood}))))::NUMERIC(12,2) AS laengde_oversvoem_m,
            (MIN(o.{f_depth_t_flood}) * 100.00)::NUMERIC(12,2) AS min_vanddybde_cm,
            (MAX(o.{f_depth_t_flood}) * 100.00)::NUMERIC(12,2) AS max_vanddybde_cm,
            (SUM(o.{f_depth_t_flood}*st_length(st_intersection(v.{f_geom_t_road_traffic},o.{f_geom_t_flood}))) * 100.0 / SUM(st_length(st_intersection(v.{f_geom_t_road_traffic},o.{f_geom_t_flood}))))::NUMERIC(12,2) AS avg_vanddybde_cm
        FROM {t_road_traffic} v
        INNER JOIN {t_flood} o on st_intersects(v.{f_geom_t_road_traffic},o.{f_geom_t_flood})
        WHERE o.{f_depth_t_flood} >= 0.075
    GROUP BY v.{f_pkey_t_road_traffic}, v.{f_geom_t_road_traffic}, v.{f_number_cars_t_road_traffic}
    ),
    tr2 AS (
        SELECT
            tr.*,
            {Oversvømmelsesperiode (timer)} AS blokering_dage,
            0.3 AS vanddybde_bloker_m,
            0.075 AS vanddybde_min_m,
            {Renovationspris pr meter vej (DKK)} AS pris_renovation_kr_m,
            (CASE
                WHEN tr.avg_vanddybde_cm >= 30.0 THEN 0.0
                ELSE 0.0009 * (tr.avg_vanddybde_cm*10.0)^2.0 - 0.5529 * tr.avg_vanddybde_cm*10.0 + 86.9448
            END)::NUMERIC(12,2) AS hastighed_red_km_time,
            tr.laengde_oversvoem_m * {Renovationspris pr meter vej (DKK)} AS renovationspris_total_kr
        FROM tr
    ),
    tr3 AS (
        SELECT
            tr2.*,
            (CASE
                WHEN tr2.hastighed_red_km_time > 50.0 THEN 0.0
                ELSE (68.8 - 1.376 * tr2.hastighed_red_km_time) * (tr2.blokering_dage / 24.0) * tr2.laengde_org_m * (tr2.gennemsnit_biler_pr_dag/6200.00)*2.0
                
            END)::NUMERIC(12,2) AS transportpris_total_kr,
            (CASE
                WHEN tr2.hastighed_red_km_time > 50.0 THEN 0.0
                ELSE (68.8 - 1.376 * tr2.hastighed_red_km_time) * (tr2.blokering_dage / 24.0) * tr2.laengde_org_m * (tr2.gennemsnit_biler_pr_dag/6200.00)*2.0
            END + tr2.renovationspris_total_kr)::NUMERIC(12,2) AS pris_total_kr
        FROM tr2
)
SELECT 
    tr3.*,
	(
	CASE
	    WHEN ''{Medtag i risikoberegninger}'' = ''Intet (0 kr.)'' THEN 0.0
	    WHEN ''{Medtag i risikoberegninger}'' = ''Skadebeløb'' THEN tr3.pris_total_kr
	    WHEN ''{Medtag i risikoberegninger}'' = ''Værditab'' THEN 0.0
	    WHEN ''{Medtag i risikoberegninger}'' = ''Skadebeløb og værditab'' THEN 0.0 + tr3.pris_total_kr 
	END * (0.089925/{Returperiode for hændelse i fremtiden (år)} + 0.21905/{Returperiode for hændelse i dag (år)}))::NUMERIC(12,2) AS risiko_kr
FROM tr3
', 'P', '', '', '', '', '', 10, ' ');
INSERT INTO fdc_admin.parametre (name, parent, value, type, minval, maxval, lookupvalues, "default", explanation, sort, checkable) VALUES ('f_pkey_q_infrastructure', 'q_infrastructure', 'objectid', 'T', '', '', '', '', '', 1, ' ');
INSERT INTO fdc_admin.parametre (name, parent, value, type, minval, maxval, lookupvalues, "default", explanation, sort, checkable) VALUES ('f_geom_q_infrastructure', 'q_infrastructure', 'geom', 'T', '', '', '', '', '', 1, ' ');
INSERT INTO fdc_admin.parametre (name, parent, value, type, minval, maxval, lookupvalues, "default", explanation, sort, checkable) VALUES ('f_pkey_q_publicservice', 'q_publicservice', 'objectid', 'T', '', '', '', '', '', 1, ' ');
INSERT INTO fdc_admin.parametre (name, parent, value, type, minval, maxval, lookupvalues, "default", explanation, sort, checkable) VALUES ('f_geom_q_publicservice', 'q_publicservice', 'geom', 'T', '', '', '', '', '', 1, ' ');
INSERT INTO fdc_admin.parametre (name, parent, value, type, minval, maxval, lookupvalues, "default", explanation, sort, checkable) VALUES ('f_damage_q_building', 'q_building', 'skadebeloeb_kr', 'T', '', '', '', '', '', 1, 'T');
INSERT INTO fdc_admin.parametre (name, parent, value, type, minval, maxval, lookupvalues, "default", explanation, sort, checkable) VALUES ('f_loss_q_building', 'q_building', 'vaerditab_kr', 'T', '', '', '', '', '', 1, 'T');
INSERT INTO fdc_admin.parametre (name, parent, value, type, minval, maxval, lookupvalues, "default", explanation, sort, checkable) VALUES ('f_risk_q_building', 'q_building', 'risiko_kr', 'T', '', '', '', '', '', 1, 'T');
INSERT INTO fdc_admin.parametre (name, parent, value, type, minval, maxval, lookupvalues, "default", explanation, sort, checkable) VALUES ('f_pkey_q_building', 'q_building', 'fid', 'T', '', '', '', '', 'Name of primary keyfield for query', 10, ' ');
INSERT INTO fdc_admin.parametre (name, parent, value, type, minval, maxval, lookupvalues, "default", explanation, sort, checkable) VALUES ('f_geom_q_building', 'q_building', 'geom_byg', 'T', '', '', '', '', 'Field name for geometry column', 10, ' ');
INSERT INTO fdc_admin.parametre (name, parent, value, type, minval, maxval, lookupvalues, "default", explanation, sort, checkable) VALUES ('f_damage_q_tourism_spatial', 'q_tourism_spatial', 'tot_kr', 'T', '', '', '', '', '', 1, 'T');
INSERT INTO fdc_admin.parametre (name, parent, value, type, minval, maxval, lookupvalues, "default", explanation, sort, checkable) VALUES ('f_risk_q_tourism_spatial', 'q_tourism_spatial', 'risiko_kr', 'T', '', '', '', '', '', 1, 'T');
INSERT INTO fdc_admin.parametre (name, parent, value, type, minval, maxval, lookupvalues, "default", explanation, sort, checkable) VALUES ('f_geom_q_tourism_spatial', 'q_tourism_spatial', 'geom', 'T', '', '', '', '', 'Field name for geometry field in tourism query', 10, ' ');
INSERT INTO fdc_admin.parametre (name, parent, value, type, minval, maxval, lookupvalues, "default", explanation, sort, checkable) VALUES ('f_pkey_q_tourism_spatial', 'q_tourism_spatial', 'id', 'T', '', '', '', '', '', 10, ' ');
INSERT INTO fdc_admin.parametre (name, parent, value, type, minval, maxval, lookupvalues, "default", explanation, sort, checkable) VALUES ('f_pkey_q_tourism_alphanumeric', 'q_tourism_alphanumeric', 'fid', 'T', '', '', '', '', '', 10, ' ');
INSERT INTO fdc_admin.parametre (name, parent, value, type, minval, maxval, lookupvalues, "default", explanation, sort, checkable) VALUES ('f_risk_q_surrounding_loss', 'q_surrounding_loss', 'risiko_kr', 'T', '', '', '', '', '', 1, 'T');
INSERT INTO fdc_admin.parametre (name, parent, value, type, minval, maxval, lookupvalues, "default", explanation, sort, checkable) VALUES ('f_loss_q_surrounding_loss', 'q_surrounding_loss', 'vaerditab_kr', 'T', '', '', '', '', '', 1, 'T');
INSERT INTO fdc_admin.parametre (name, parent, value, type, minval, maxval, lookupvalues, "default", explanation, sort, checkable) VALUES ('f_pkey_q_surrounding_loss', 'q_surrounding_loss', 'fid', 'T', '', '', '', '', '', 10, ' ');
INSERT INTO fdc_admin.parametre (name, parent, value, type, minval, maxval, lookupvalues, "default", explanation, sort, checkable) VALUES ('f_geom_q_surrounding_loss', 'q_surrounding_loss', 'geom_byg', 'T', '', '', '', '', '', 10, ' ');
INSERT INTO fdc_admin.parametre (name, parent, value, type, minval, maxval, lookupvalues, "default", explanation, sort, checkable) VALUES ('f_geom_q_bioscore_spatial', 'q_bioscore_spatial', 'geom_clip', 'T', '', '', '', '', '', 10, ' ');
INSERT INTO fdc_admin.parametre (name, parent, value, type, minval, maxval, lookupvalues, "default", explanation, sort, checkable) VALUES ('f_pkey_q_comp_build', 'q_comp_build', 'fid', 'T', '', '', '', '', '', 10, ' ');
INSERT INTO fdc_admin.parametre (name, parent, value, type, minval, maxval, lookupvalues, "default", explanation, sort, checkable) VALUES ('f_geom_q_comp_build', 'q_comp_build', 'geom_byg', 'T', '', '', '', '', 'Field name for building geometry', 10, ' ');
INSERT INTO fdc_admin.parametre (name, parent, value, type, minval, maxval, lookupvalues, "default", explanation, sort, checkable) VALUES ('f_geom_q_comp_nobuild', 'q_comp_nobuild', 'geom', 'T', '', '', '', '', '', 10, ' ');
INSERT INTO fdc_admin.parametre (name, parent, value, type, minval, maxval, lookupvalues, "default", explanation, sort, checkable) VALUES ('f_pkey_q_comp_nobuild', 'q_comp_nobuild', 'fid', 'T', '', '', '', '', '', 10, ' ');
INSERT INTO fdc_admin.parametre (name, parent, value, type, minval, maxval, lookupvalues, "default", explanation, sort, checkable) VALUES ('Oversvømmelsesperiode (timer)', 'Skadeberegning, vej og trafik', '24', 'I', '0', '100', '1', '', 'Her angives det antal dage, hvor vejene ikke kan benyttes pga. oversvømmelsen.', 4, ' ');
INSERT INTO fdc_admin.parametre (name, parent, value, type, minval, maxval, lookupvalues, "default", explanation, sort, checkable) VALUES ('Renovationspris pr meter vej (DKK)', 'Skadeberegning, vej og trafik', '20', 'I', '0', '1000', '10', '', 'Her angives den økonomiske omkostning til oprydning per meter vej som bliver oversvømmet. Omkostningen angives i DKK per meter.', 5, ' ');
INSERT INTO fdc_admin.parametre (name, parent, value, type, minval, maxval, lookupvalues, "default", explanation, sort, checkable) VALUES ('Minimum vanddybde (meter), kælder', 'Skadeberegninger, kælder', '0.1', 'R', '0.05', '10.0', '0.05', '', 'Mindste værdi for vandybde for kælder, som medtages i beregningerne ', 10, ' ');
INSERT INTO fdc_admin.parametre (name, parent, value, type, minval, maxval, lookupvalues, "default", explanation, sort, checkable) VALUES ('Bredde af nabozone (meter)', 'Værditab nabobygninger', '300.0', 'R', '0.0', '1000.0', '10.0', '', 'Maks. afstand for nabobygninger fra skaderamte bygningerder som medtages i beregningen', 10, ' ');
INSERT INTO fdc_admin.parametre (name, parent, value, type, minval, maxval, lookupvalues, "default", explanation, sort, checkable) VALUES ('q_human_health', 'Queries', 'WITH ob AS (
  SELECT
    b.{f_pkey_t_building} as {f_pkey_q_human_health},
    b.{f_muncode_t_building} AS kom_kode,
    b.{f_usage_code_t_building} AS bbr_anv_kode,
    b.{f_usage_text_t_building} AS bbr_anv_tekst,
    st_area(b.{f_geom_t_building})::NUMERIC(12,2) AS areal_byg_m2,
    (SUM(st_area(st_intersection(b.{f_geom_t_building},o.{f_geom_t_flood}))))::NUMERIC(12,2) AS areal_oversvoem_m2,
    (MIN(o.{f_depth_t_flood}) * 100.00)::NUMERIC(12,2) AS min_vanddybde_cm,
    (MAX(o.{f_depth_t_flood}) * 100.00)::NUMERIC(12,2) AS max_vanddybde_cm,
    (AVG(o.{f_depth_t_flood}) * 100.00)::NUMERIC(12,2) AS avg_vanddybde_cm,
    --(SUM(o.{f_depth_t_flood}*st_area(st_intersection(b.{f_geom_t_building},o.{f_geom_t_flood}))) * 100.0 / SUM(st_area(st_intersection(b.{f_geom_t_building},o.{f_geom_t_flood}))))::NUMERIC(12,2) AS avg_vanddybde_cm,
    st_force2d(b.{f_geom_t_building}) AS {f_geom_q_human_health}
    FROM {t_building} b
    INNER JOIN {t_flood} o on st_intersects(b.{f_geom_t_building},o.{f_geom_t_flood})
    WHERE o.{f_depth_t_flood} >= {Minimum vanddybde (meter)}
    GROUP BY b.{f_pkey_t_building}, b.{f_muncode_t_building}, b.{f_usage_code_t_building}, b.{f_usage_text_t_building}, b.{f_geom_t_building}
),
om AS ( 
  SELECT 
    ob.{f_pkey_q_human_health},
    ob.kom_kode,
    ob.bbr_anv_kode,
    ob.bbr_anv_tekst,
	ob.areal_byg_m2,
	ob.areal_oversvoem_m2, 
	ob.min_vanddybde_cm, 
	ob.max_vanddybde_cm, 
	ob.avg_vanddybde_cm,
    ob.{f_geom_q_human_health},
    COUNT(*) as mennesker_total,
    COUNT(*) FILTER (WHERE m.{f_age_t_human_health} BETWEEN 0 AND 6) AS mennesker_0_6,
    COUNT(*) FILTER (WHERE m.{f_age_t_human_health} BETWEEN 7 AND 17) AS mennesker_7_17,
    COUNT(*) FILTER (WHERE m.{f_age_t_human_health} BETWEEN 18 AND 70) AS mennesker_18_70,
    COUNT(*) FILTER (WHERE m.{f_age_t_human_health} > 70) AS mennesker_71plus,
    COUNT(*) FILTER (WHERE m.{f_age_t_human_health} BETWEEN 18 AND 70) * (138 * 301)::integer AS arbejdstid_kr,
    COUNT(*) FILTER (WHERE m.{f_age_t_human_health} BETWEEN 18 AND 70) * (23  * 301)::integer AS rejsetid_kr,
    COUNT(*) FILTER (WHERE m.{f_age_t_human_health} BETWEEN 18 AND 70) * (64  * 301)::integer AS sygetimer_kr, 
    COUNT(*) FILTER (WHERE m.{f_age_t_human_health} BETWEEN 18 AND 70) * (26  * 301)::integer AS ferietimer_kr 
  FROM ob 
  INNER JOIN {t_human_health} m ON st_intersects (ob.{f_geom_q_human_health}, m.{f_geom_t_human_health})
  GROUP BY ob.{f_pkey_q_human_health}, ob.kom_kode, ob.bbr_anv_kode, ob.bbr_anv_tekst, ob.areal_byg_m2, ob.areal_oversvoem_m2, ob.min_vanddybde_cm, ob.max_vanddybde_cm, ob.avg_vanddybde_cm, ob.{f_geom_q_human_health}
)

SELECT 
    om.*,
    om.rejsetid_kr + om.sygedage_kr + om.feriedage_kr AS omkostning_kr,
	(
	CASE
	    WHEN ''{Medtag i risikoberegninger}'' = ''Intet (0 kr.)'' THEN 0.0
	    WHEN ''{Medtag i risikoberegninger}'' = ''Skadebeløb'' THEN om.arbejdstid_kr + om.rejsetid_kr + om.sygetimer_kr + om.ferietimer_kr
	    WHEN ''{Medtag i risikoberegninger}'' = ''Værditab'' THEN 0.0
	    WHEN ''{Medtag i risikoberegninger}'' = ''Skadebeløb og værditab'' THEN 0.0 + om.arbejdstid_kr + om.rejsetid_kr + om.sygetimer_kr + om.ferietimer_kr 
	END * (0.089925/{Returperiode for hændelse i fremtiden (år)} + 0.21905/{Returperiode for hændelse i dag (år)}))::NUMERIC(12,2) AS risiko_kr
FROM om
', 'P', '', '', '', '', '', 10, ' ');
INSERT INTO fdc_admin.parametre (name, parent, value, type, minval, maxval, lookupvalues, "default", explanation, sort, checkable) VALUES ('f_risk_q_human_health', 'q_human_health', 'risiko_kr', 'T', '', '', '', '', '', 1, 'T');
INSERT INTO fdc_admin.parametre (name, parent, value, type, minval, maxval, lookupvalues, "default", explanation, sort, checkable) VALUES ('f_damage_q_human_health', 'q_human_health', 'omkostning_kr', 'T', '', '', '', '', '', 1, 'T');
INSERT INTO fdc_admin.parametre (name, parent, value, type, minval, maxval, lookupvalues, "default", explanation, sort, checkable) VALUES ('f_pkey_q_human_health', 'q_human_health', 'fid', 'T', '', '', '', '', '', 10, ' ');
INSERT INTO fdc_admin.parametre (name, parent, value, type, minval, maxval, lookupvalues, "default", explanation, sort, checkable) VALUES ('f_geom_q_human_health', 'q_human_health', 'geom', 'T', '', '', '', '', '', 10, ' ');
INSERT INTO fdc_admin.parametre (name, parent, value, type, minval, maxval, lookupvalues, "default", explanation, sort, checkable) VALUES ('f_risk_q_recreative', 'q_recreative', 'risiko_kr', 'T', '', '', '', '', '', 1, 'T');
INSERT INTO fdc_admin.parametre (name, parent, value, type, minval, maxval, lookupvalues, "default", explanation, sort, checkable) VALUES ('f_damage_q_recreative', 'q_recreative', 'total_omkost_kr', 'T', '', '', '', '', '', 1, 'T');
INSERT INTO fdc_admin.parametre (name, parent, value, type, minval, maxval, lookupvalues, "default", explanation, sort, checkable) VALUES ('f_pkey_q_recreative', 'q_recreative', 'id', 'T', '', '', '', '', '', 10, ' ');
INSERT INTO fdc_admin.parametre (name, parent, value, type, minval, maxval, lookupvalues, "default", explanation, sort, checkable) VALUES ('f_geom_q_recreative', 'q_recreative', 'geom', 'T', '', '', '', '', '', 10, ' ');
INSERT INTO fdc_admin.parametre (name, parent, value, type, minval, maxval, lookupvalues, "default", explanation, sort, checkable) VALUES ('f_damage_q_road_traffic', 'q_road_traffic', 'pris_total_kr', 'T', '', '', '', '', '', 1, 'T');
INSERT INTO fdc_admin.parametre (name, parent, value, type, minval, maxval, lookupvalues, "default", explanation, sort, checkable) VALUES ('f_risk_q_road_traffic', 'q_road_traffic', 'risiko_kr', 'T', '', '', '', '', '', 1, 'T');
INSERT INTO fdc_admin.parametre (name, parent, value, type, minval, maxval, lookupvalues, "default", explanation, sort, checkable) VALUES ('f_pkey_q_road_traffic', 'q_road_traffic', 'id', 'T', '', '', '', '', '', 10, ' ');
INSERT INTO fdc_admin.parametre (name, parent, value, type, minval, maxval, lookupvalues, "default", explanation, sort, checkable) VALUES ('f_geom_q_road_traffic', 'q_road_traffic', 'geom', 'T', '', '', '', '', '', 10, ' ');
INSERT INTO fdc_admin.parametre (name, parent, value, type, minval, maxval, lookupvalues, "default", explanation, sort, checkable) VALUES ('Data', '', '', 'G', '', '', '', '', 'Hovedgruppe for administration af Tabeller', 2, ' ');
INSERT INTO fdc_admin.parametre (name, parent, value, type, minval, maxval, lookupvalues, "default", explanation, sort, checkable) VALUES ('f_pkey_t_publicservice', 't_publicservice', 'objectid', 'T', '', '', '', '', '', 1, ' ');
INSERT INTO fdc_admin.parametre (name, parent, value, type, minval, maxval, lookupvalues, "default", explanation, sort, checkable) VALUES ('f_geom_t_publicservice', 't_publicservice', 'geom', 'T', '', '', '', '', '', 1, ' ');
INSERT INTO fdc_admin.parametre (name, parent, value, type, minval, maxval, lookupvalues, "default", explanation, sort, checkable) VALUES ('f_number_cars_t_road_traffic', 't_road_traffic', 'trafik_tal', 'I', '0', '100000', '', '', '', 10, ' ');
INSERT INTO fdc_admin.parametre (name, parent, value, type, minval, maxval, lookupvalues, "default", explanation, sort, checkable) VALUES ('f_geom_t_road_traffic', 't_road_traffic', 'geom', 'T', '', '', '', '', '', 10, ' ');
INSERT INTO fdc_admin.parametre (name, parent, value, type, minval, maxval, lookupvalues, "default", explanation, sort, checkable) VALUES ('f_pkey_t_road_traffic', 't_road_traffic', 'objectid', 'T', '', '', '', '', '', 10, ' ');
INSERT INTO fdc_admin.parametre (name, parent, value, type, minval, maxval, lookupvalues, "default", explanation, sort, checkable) VALUES ('f_pkey_t_company', 't_company', '"OBJECTID"', 'T', '', '', '', '', '', 10, ' ');
INSERT INTO fdc_admin.parametre (name, parent, value, type, minval, maxval, lookupvalues, "default", explanation, sort, checkable) VALUES ('f_empcount_t_company', 't_company', 'aarsbes_an', 'I', '0', '20000', '10', '', '', 10, ' ');
INSERT INTO fdc_admin.parametre (name, parent, value, type, minval, maxval, lookupvalues, "default", explanation, sort, checkable) VALUES ('f_geom_t_company', 't_company', 'geom', 'T', '', '', '', '', '', 10, ' ');
INSERT INTO fdc_admin.parametre (name, parent, value, type, minval, maxval, lookupvalues, "default", explanation, sort, checkable) VALUES ('f_pkey_t_bioscore', 't_bioscore', 'id', 'T', '', '', '', '', '', 10, ' ');
INSERT INTO fdc_admin.parametre (name, parent, value, type, minval, maxval, lookupvalues, "default", explanation, sort, checkable) VALUES ('f_geom_t_bioscore', 't_bioscore', 'geom', 'T', '', '', '', '', '', 10, ' ');
INSERT INTO fdc_admin.parametre (name, parent, value, type, minval, maxval, lookupvalues, "default", explanation, sort, checkable) VALUES ('f_bioscore_t_bioscore', 't_bioscore', '"Bioscore"', 'T', '', '', '', '', '', 10, ' ');
INSERT INTO fdc_admin.parametre (name, parent, value, type, minval, maxval, lookupvalues, "default", explanation, sort, checkable) VALUES ('f_pkey_t_human_health', 't_human_health', 'objectid', 'T', '', '', '', '', 'Field name for keyfield in Human health table ', 10, ' ');
INSERT INTO fdc_admin.parametre (name, parent, value, type, minval, maxval, lookupvalues, "default", explanation, sort, checkable) VALUES ('f_age_t_human_health', 't_human_health', 'alder_rand', 'T', '', '', '', '', 'Field name for age field in Human health table ', 10, ' ');
INSERT INTO fdc_admin.parametre (name, parent, value, type, minval, maxval, lookupvalues, "default", explanation, sort, checkable) VALUES ('f_geom_t_human_health', 't_human_health', 'geom', 'T', '', '', '', '', 'Field name for geometry field in Human health table ', 10, ' ');
INSERT INTO fdc_admin.parametre (name, parent, value, type, minval, maxval, lookupvalues, "default", explanation, sort, checkable) VALUES ('f_geom_t_recreative', 't_recreative', 'geom', 'T', '', '', '', '', '', 1, ' ');
INSERT INTO fdc_admin.parametre (name, parent, value, type, minval, maxval, lookupvalues, "default", explanation, sort, checkable) VALUES ('f_pkey_t_recreative', 't_recreative', 'objectid', 'T', '', '', '', '', '', 10, ' ');
INSERT INTO fdc_admin.parametre (name, parent, value, type, minval, maxval, lookupvalues, "default", explanation, sort, checkable) VALUES ('f_geom_t_flood', 't_flood', 'geom', 'T', '', '', '', '', 'Field name for geometry field in flood table', 10, ' ');
INSERT INTO fdc_admin.parametre (name, parent, value, type, minval, maxval, lookupvalues, "default", explanation, sort, checkable) VALUES ('f_depth_t_flood', 't_flood', '"Vanddybde"', 'T', '', '', '', '', 'Field name for detph field in flood table ', 10, ' ');
INSERT INTO fdc_admin.parametre (name, parent, value, type, minval, maxval, lookupvalues, "default", explanation, sort, checkable) VALUES ('f_pkey_t_infrastructure', 't_infrastructure', 'objectid', 'T', '', '', '', '', '', 1, ' ');
INSERT INTO fdc_admin.parametre (name, parent, value, type, minval, maxval, lookupvalues, "default", explanation, sort, checkable) VALUES ('f_geom_t_infrastructure', 't_infrastructure', 'geom', 'T', '', '', '', '', '', 1, ' ');
INSERT INTO fdc_admin.parametre (name, parent, value, type, minval, maxval, lookupvalues, "default", explanation, sort, checkable) VALUES ('f_muncode_t_building', 't_building', 'komkode', 'T', '', '', '', '', 'Fieldname for municipality code for building table', 10, ' ');
INSERT INTO fdc_admin.parametre (name, parent, value, type, minval, maxval, lookupvalues, "default", explanation, sort, checkable) VALUES ('f_geom_t_building', 't_building', 'geom', 'T', '', '', '', '', 'Field name for geometry field in building table', 10, ' ');
INSERT INTO fdc_admin.parametre (name, parent, value, type, minval, maxval, lookupvalues, "default", explanation, sort, checkable) VALUES ('f_pkey_t_building', 't_building', '"OBJECTID"', 'T', '', '', '', '', 'Field name for keyfield in Building table ', 10, ' ');
INSERT INTO fdc_admin.parametre (name, parent, value, type, minval, maxval, lookupvalues, "default", explanation, sort, checkable) VALUES ('Models', '', '', 'G', '', '', '', '', 'Hovedgruppe for administration og kørsel af  Modeller', 10, ' ');
INSERT INTO fdc_admin.parametre (name, parent, value, type, minval, maxval, lookupvalues, "default", explanation, sort, checkable) VALUES ('Generelle modelværdier', 'Models', '', 'G', '', '', '', '', 'Afsnit, hvor parametre, der bruges i mange forskellige modeller, kan værdisættes', 1, ' ');
INSERT INTO fdc_admin.parametre (name, parent, value, type, minval, maxval, lookupvalues, "default", explanation, sort, checkable) VALUES ('Offentlig service', 'Models', '', 'G', '', '', '', '', 'Skademodeller for Offentlig service', 2, ' ');
INSERT INTO fdc_admin.parametre (name, parent, value, type, minval, maxval, lookupvalues, "default", explanation, sort, checkable) VALUES ('Vej og trafik', 'Models', '', 'G', '', '', '', '', 'Skademodeller for Vej og trafik', 2, ' ');
INSERT INTO fdc_admin.parametre (name, parent, value, type, minval, maxval, lookupvalues, "default", explanation, sort, checkable) VALUES ('Kritisk infrastruktur', 'Models', '', 'G', '', '', '', '', 'Skademodeller for Kritisk infrastruktur', 2, ' ');
INSERT INTO fdc_admin.parametre (name, parent, value, type, minval, maxval, lookupvalues, "default", explanation, sort, checkable) VALUES ('Bygninger', 'Models', '', 'G', '', '', '', '', 'Skademodeller for Bygninger', 2, ' ');
INSERT INTO fdc_admin.parametre (name, parent, value, type, minval, maxval, lookupvalues, "default", explanation, sort, checkable) VALUES ('Biodiversitet', 'Models', '', 'G', '', '', '', '', 'Skademodeller for Biodiversitet', 4, ' ');
INSERT INTO fdc_admin.parametre (name, parent, value, type, minval, maxval, lookupvalues, "default", explanation, sort, checkable) VALUES ('Turisme', 'Models', '', 'G', '', '', '', '', 'Skademodeller for Turisme', 5, ' ');
INSERT INTO fdc_admin.parametre (name, parent, value, type, minval, maxval, lookupvalues, "default", explanation, sort, checkable) VALUES ('Rekreative områder', 'Models', '', 'T', '', '', '', '', 'Skademodeller for Rekreative områder', 5, ' ');
INSERT INTO fdc_admin.parametre (name, parent, value, type, minval, maxval, lookupvalues, "default", explanation, sort, checkable) VALUES ('Industri', 'Models', ' ', 'G', '', '', '', '', 'Skademodeller for Industri', 5, ' ');
INSERT INTO fdc_admin.parametre (name, parent, value, type, minval, maxval, lookupvalues, "default", explanation, sort, checkable) VALUES ('Mennesker og helbred', 'Models', '', 'G', '', '', '', '', 'Skademodeller for Mennesker og helbred', 7, ' ');
INSERT INTO fdc_admin.parametre (name, parent, value, type, minval, maxval, lookupvalues, "default", explanation, sort, checkable) VALUES ('Returperiode for hændelse i dag (år)', 'Generelle modelværdier', '20', 'I', '0', '1000', '5', '', 'Indtast returperioden under nuværende klima for den oversvømmelseshændelse som der beregnes skader og risiko for. Returperioden angives i år.', 1, ' ');
INSERT INTO fdc_admin.parametre (name, parent, value, type, minval, maxval, lookupvalues, "default", explanation, sort, checkable) VALUES ('Returperiode for hændelse i fremtiden (år)', 'Generelle modelværdier', '5', 'I', '0', '1000', '10', '', 'Indtast returperioden om 100 år under fremtidigt klima for den oversvømmelseshændelse som der beregnes skader og risiko for. Dette kan f.eks. være under klimascenarie RCP4.5 eller RCP8.5 Returperioden angives i år.', 2, ' ');
INSERT INTO fdc_admin.parametre (name, parent, value, type, minval, maxval, lookupvalues, "default", explanation, sort, checkable) VALUES ('Medtag i risikoberegninger', 'Generelle modelværdier', 'Skadebeløb', 'O', '', '', 'Skadebeløb¤Værditab¤Skadebeløb og værditab¤Intet (0 kr.)', '', 'Her vælger man om det kun er skadeomkostningen eller skadeomkostning inkl. værditab for bygninger som inkluderes i risikoberegningen.', 3, ' ');
INSERT INTO fdc_admin.parametre (name, parent, value, type, minval, maxval, lookupvalues, "default", explanation, sort, checkable) VALUES ('Minimum vanddybde (meter)', 'Generelle modelværdier', '0.3', 'R', '0.15', '10.0', '0.05', '', 'Her angives den minimale vanddybde på terræn som der skal til for at der opstår økonomiske tab i forbindelse med oversvømmelsen. Denne værdi angives i m, og anvendes kun for de sektorer hvor der ikke er angivet en alternativ minimum vanddybde.', 10, ' ');
INSERT INTO fdc_admin.parametre (name, parent, value, type, minval, maxval, lookupvalues, "default", explanation, sort, checkable) VALUES ('Oversvømmet offentlig service', 'Offentlig service', '', 'T', '', '', '', 'q_publicservice', 'Sæt hak såfremt modellen skal identificere offentlig service som bliver berørt i forbindelse med den pågældende oversvømmelseshændelse.', 10, 'T');
INSERT INTO fdc_admin.parametre (name, parent, value, type, minval, maxval, lookupvalues, "default", explanation, sort, checkable) VALUES ('Skadeberegning, vej og trafik', 'Vej og trafik', '', 'T', '', '', '', 'q_road_traffic', 'Sæt hak såfremt der skal beregnes økonomiske tab for vej og trafik i forbindelse med den pågældende oversvømmelseshændelse.', 10, 'T');
INSERT INTO fdc_admin.parametre (name, parent, value, type, minval, maxval, lookupvalues, "default", explanation, sort, checkable) VALUES ('Oversvømmet infrastruktur', 'Kritisk infrastruktur', '', 'T', '', '', '', 'q_infrastructure', 'Sæt hak såfremt modellen skal identificere kritisk infrastruktur som bliver berørt i forbindelse med den pågældende oversvømmelseshændelse.', 10, 'T');
INSERT INTO fdc_admin.parametre (name, parent, value, type, minval, maxval, lookupvalues, "default", explanation, sort, checkable) VALUES ('Værditab, skaderamte bygninger (%)', 'Bygninger', '10.0', 'R', '0.0', '100.0', '5.0', '', 'Her angives størrelsen på reduktionen i salgspris for de bygninger som bliver berørt af den pågældende oversvømmelse. Tabet beregnes som en procentsats, som angives af brugeren, af den gennemsnitlige kommunale m2 pris for solgte boliger i løbet af de seneste år. Det anbefales at anvende værdien 10% såfremt man ikke har bedre data.', 1, ' ');
INSERT INTO fdc_admin.parametre (name, parent, value, type, minval, maxval, lookupvalues, "default", explanation, sort, checkable) VALUES ('Værditab nabobygninger', 'Bygninger', '', 'T', '', '', '', 'q_surrounding_loss', '', 10, 'T');
INSERT INTO fdc_admin.parametre (name, parent, value, type, minval, maxval, lookupvalues, "default", explanation, sort, checkable) VALUES ('f_pkey_t_tourism', 't_tourism', 'bbr_anv_kode', 'T', '', '', '', '', '', 10, ' ');
INSERT INTO fdc_admin.parametre (name, parent, value, type, minval, maxval, lookupvalues, "default", explanation, sort, checkable) VALUES ('f_muncode_t_sqmprice', 't_sqmprice', 'kom_kode', 'T', '', '', '', '', 'Fieldname for municipalitycode', 10, ' ');
INSERT INTO fdc_admin.parametre (name, parent, value, type, minval, maxval, lookupvalues, "default", explanation, sort, checkable) VALUES ('f_sqmprice_t_sqmprice', 't_sqmprice', 'kvm_pris', 'T', '', '', '', '', 'Fieldname for sqm price', 10, ' ');
INSERT INTO fdc_admin.parametre (name, parent, value, type, minval, maxval, lookupvalues, "default", explanation, sort, checkable) VALUES ('Skadeberegninger, Bygninger', 'Bygninger', '', 'T', '', '', '', 'q_building', 'Skadeberegning for bygninger, forskellige skademodeller, med eller uden kælderberegning', 10, 'T');
INSERT INTO fdc_admin.parametre (name, parent, value, type, minval, maxval, lookupvalues, "default", explanation, sort, checkable) VALUES ('f_cellar_area_t_building', 't_building', 'kaelder123', 'T', '', '', '', '', '', 10, ' ');
INSERT INTO fdc_admin.parametre (name, parent, value, type, minval, maxval, lookupvalues, "default", explanation, sort, checkable) VALUES ('Biodiversitet, opsummering', 'Biodiversitet', '', 'T', '', '', '', 'q_bioscore_alphanumeric', 'Sæt hak såfremt modellen skal identificere særlige levesteder for rødlistede arter som bliver berørt i forbindelse med den pågældende oversvømmelseshændelse. Her opsummeres de berørte levesteder i en tabel.', 10, 'T');
INSERT INTO fdc_admin.parametre (name, parent, value, type, minval, maxval, lookupvalues, "default", explanation, sort, checkable) VALUES ('Biodiversitet, kort', 'Biodiversitet', '', 'T', '', '', '', 'q_bioscore_spatial', 'Sæt hak såfremt modellen skal identificere særlige levesteder for rødlistede arter som bliver berørt i forbindelse med den pågældende oversvømmelseshændelse. Her vises levestederne geografisk på et kort.', 10, 'T');
INSERT INTO fdc_admin.parametre (name, parent, value, type, minval, maxval, lookupvalues, "default", explanation, sort, checkable) VALUES ('Antal tabte døgn', 'Turisme', '20', 'I', '0', '365', '5', '', 'Her angives antallet af dage hvor bygningerne som bliver berørt af den pågældende oversvømmelse ikke kan anvendes til turistformål pga. skader eller oprydning efter oversvømmelsen.  ', 1, ' ');
INSERT INTO fdc_admin.parametre (name, parent, value, type, minval, maxval, lookupvalues, "default", explanation, sort, checkable) VALUES ('Turisme, Opsummering', 'Turisme', '', 'T', '', '', '', 'q_tourism_alphanumeric', 'Sæt hak såfremt der skal beregnes økonomiske tab for overnatningssteder som anvendes til turistformål. De økonomiske tab opsummeres i en tabel.', 10, 'T');
INSERT INTO fdc_admin.parametre (name, parent, value, type, minval, maxval, lookupvalues, "default", explanation, sort, checkable) VALUES ('Turisme, Kort', 'Turisme', '', 'T', '', '', '', 'q_tourism_spatial', 'Sæt hak såfremt der skal beregnes økonomiske tab for overnatningssteder som anvendes til turistformål. De berørte bygninger vises geografisk på et kort.  ', 10, 'T');
INSERT INTO fdc_admin.parametre (name, parent, value, type, minval, maxval, lookupvalues, "default", explanation, sort, checkable) VALUES ('Faktor for værditab', 'Værditab nabobygninger', '0.50', 'R', '0.0', '1.0', '0.1', '', 'Faktor værdi til beregning af værditab for nabobygninger ud fra værditab for skaderamte bygninger', 10, ' ');
INSERT INTO fdc_admin.parametre (name, parent, value, type, minval, maxval, lookupvalues, "default", explanation, sort, checkable) VALUES ('Antal dage med oversvømmelse', 'Skadeberegning, Rekreative områder', '24', 'I', '0', '100', '1', '', 'Angiv antallet af dage hvor de rekreative områder ikke kan anvendes som en konsekvens af den pågældende oversvømmelse.', 10, ' ');
INSERT INTO fdc_admin.parametre (name, parent, value, type, minval, maxval, lookupvalues, "default", explanation, sort, checkable) VALUES ('Reports', '', '', 'G', '', '', '', '', 'Hovedgruppe til administration og kørsel af Rapporter', 4, ' ');
INSERT INTO fdc_admin.parametre (name, parent, value, type, minval, maxval, lookupvalues, "default", explanation, sort, checkable) VALUES ('q_tourism_spatial', 'Queries', 'WITH pn AS (
  SELECT DISTINCT
    b.{f_pkey_t_building} as {f_pkey_q_tourism_spatial},
    b.{f_muncode_t_building} AS kom_kode,
    b.{f_usage_code_t_building} AS bbr_kode,
    t.bbr_anv_tekst AS bbr_tekst,
    t.kapacitet AS kapacitet,
    t.omkostning AS omkostninger,
    {Antal tabte døgn} AS tabte_dage,
    {Antal tabte døgn} * t.omkostning AS tabte_overnat,
    {Antal tabte døgn} * t.omkostning * t.kapacitet AS tot_kr,
    st_force2d(b.{f_geom_t_building}) AS {f_geom_q_tourism_spatial}
    FROM {t_building} b
    INNER JOIN {t_flood} o on st_intersects(b.{f_geom_t_building},o.{f_geom_t_flood})
    INNER JOIN {t_tourism} t  ON t.{f_pkey_t_tourism} = b.{f_usage_code_t_building}  
    WHERE o.{f_depth_t_flood} >= {Minimum vanddybde (meter)}
)
SELECT 
    pn.*,
	(
	CASE
	    WHEN ''{Medtag i risikoberegninger}'' = ''Intet (0 kr.)'' THEN 0.0
	    WHEN ''{Medtag i risikoberegninger}'' = ''Skadebeløb'' THEN pn.tot_kr
	    WHEN ''{Medtag i risikoberegninger}'' = ''Værditab'' THEN 0.0
	    WHEN ''{Medtag i risikoberegninger}'' = ''Skadebeløb og værditab'' THEN 0.0 + pn.tot_kr 
	END * (0.089925/{Returperiode for hændelse i fremtiden (år)} + 0.21905/{Returperiode for hændelse i dag (år)}))::NUMERIC(12,2) AS risiko_kr
FROM pn
', 'P', '', '', '', '', '', 10, ' ');
INSERT INTO fdc_admin.parametre (name, parent, value, type, minval, maxval, lookupvalues, "default", explanation, sort, checkable) VALUES ('f_usage_code_t_building', 't_building', '"BYG_ANVEND"', 'T', '', '', '', '', 'Fieldname for usage code for building table', 10, ' ');
INSERT INTO fdc_admin.parametre (name, parent, value, type, minval, maxval, lookupvalues, "default", explanation, sort, checkable) VALUES ('f_pkey_t_build_usage', 't_build_usage', 'bbr_anv_kode', 'T', '', '', '', '', 'Field name for keyfield in Building table ', 10, ' ');
INSERT INTO fdc_admin.parametre (name, parent, value, type, minval, maxval, lookupvalues, "default", explanation, sort, checkable) VALUES ('f_usage_text_t_build_usage', 't_build_usage', 'bbr_anv_tekst', 'T', '', '', '', '', '', 10, ' ');
INSERT INTO fdc_admin.parametre (name, parent, value, type, minval, maxval, lookupvalues, "default", explanation, sort, checkable) VALUES ('f_pkey_t_damage', 't_damage', 'skade_type, skade_kategori', 'T', '', '', '', '', 'Field name for keyfield in damage function table ', 10, ' ');
INSERT INTO fdc_admin.parametre (name, parent, value, type, minval, maxval, lookupvalues, "default", explanation, sort, checkable) VALUES ('f_category_t_damage', 't_damage', 'skade_kategori', 'T', '', '', '', '', 'Field name for keyfield in damage function table ', 10, ' ');
INSERT INTO fdc_admin.parametre (name, parent, value, type, minval, maxval, lookupvalues, "default", explanation, sort, checkable) VALUES ('f_type_t_damage', 't_damage', 'skade_type', 'T', '', '', '', '', 'Field name for keyfield in damage function table ', 10, ' ');
INSERT INTO fdc_admin.parametre (name, parent, value, type, minval, maxval, lookupvalues, "default", explanation, sort, checkable) VALUES ('f_category_t_build_usage', 't_build_usage', 'skade_kategori', 'T', '', '', '', '', 'Field name for keyfield in Building table ', 10, ' ');
INSERT INTO fdc_admin.parametre (name, parent, value, type, minval, maxval, lookupvalues, "default", explanation, sort, checkable) VALUES ('f_cellar_damage_q_building', 'q_building', 'skadebeloeb_kaelder_kr', 'T', '', '', '', '', '', 1, 'T');
INSERT INTO fdc_admin.parametre (name, parent, value, type, minval, maxval, lookupvalues, "default", explanation, sort, checkable) VALUES ('Skadetype', 'Skadeberegninger, Bygninger', 'Stormflod', 'O', '', '', 'Stormflod¤Skybrud¤Vandløb', ' ', 'Valg af økonomisk skademodel', 10, ' ');
INSERT INTO fdc_admin.parametre (name, parent, value, type, minval, maxval, lookupvalues, "default", explanation, sort, checkable) VALUES ('Skadeberegning for kælder', 'Skadeberegninger, Bygninger', 'Medtages ikke', 'O', '', '', 'Medtages ikke¤Medtages', ' ', 'Bestemmer skadeberegning for kælder medtages i udregningen', 10, ' ');
INSERT INTO fdc_admin.parametre (name, parent, value, type, minval, maxval, lookupvalues, "default", explanation, sort, checkable) VALUES ('f_usage_text_t_building', 't_building', '"BYG_ANVE_1"', 'T', '', '', '', '', 'Fieldname for usage code for building table', 10, ' ');
INSERT INTO fdc_admin.parametre (name, parent, value, type, minval, maxval, lookupvalues, "default", explanation, sort, checkable) VALUES ('q_tourism_alphanumeric', 'Queries', 'WITH pn AS (
  SELECT
    row_number() over () as {f_pkey_q_tourism_alphanumeric},
    b.{f_muncode_t_building} AS kom_kode,
    b.{f_usage_code_t_building} AS bbr_kode,
    t.bbr_anv_tekst AS bbr_tekst,
    t.kapacitet AS kapacitet_bygning,
    t.omkostning AS omkostning_overnatning,
    {Antal tabte døgn} AS tabte_dage,
    SUM(t.kapacitet * {Antal tabte døgn}) AS sum_overnatninger,
    SUM(t.omkostning * t.kapacitet* {Antal tabte døgn} / 1000000.0)::NUMERIC(12,3)  AS sum_tot_kr,
    SUM(t.omkostning * t.kapacitet* {Antal tabte døgn} / 1000000.0)::NUMERIC(12,3)  AS sum_tot_mill_kr
    FROM {t_building} b
    INNER JOIN {t_flood} o on st_intersects(b.{f_geom_t_building},o.{f_geom_t_flood})
    JOIN {t_tourism} t  ON t.{f_pkey_t_tourism} = b.{f_usage_code_t_building}  
    WHERE o.{f_depth_t_flood} >= {Minimum vanddybde (meter)}
    GROUP BY b.komkode, b.{f_usage_code_t_building}, t.bbr_anv_tekst, t.kapacitet, t.omkostning
)
SELECT 
    pn.*,
	(
	CASE
	    WHEN ''{Medtag i risikoberegninger}'' = ''Intet (0 kr.)'' THEN 0.0
	    WHEN ''{Medtag i risikoberegninger}'' = ''Skadebeløb'' THEN pn.sum_tot_mill_kr
	    WHEN ''{Medtag i risikoberegninger}'' = ''Værditab'' THEN 0.0
	    WHEN ''{Medtag i risikoberegninger}'' = ''Skadebeløb og værditab'' THEN 0.0 + pn.sum_tot_mill_kr 
	END * (0.089925/{Returperiode for hændelse i fremtiden (år)} + 0.21905/{Returperiode for hændelse i dag (år)}))::NUMERIC(12,2) AS risiko_mill_kr
FROM pn
', 'P', '', '', '', '', '', 10, ' ');
INSERT INTO fdc_admin.parametre (name, parent, value, type, minval, maxval, lookupvalues, "default", explanation, sort, checkable) VALUES ('Result_schema', 'General', 'fdc_results', 'T', '', '', '', '', 'Name of schema to place result tables in', 10, ' ');
INSERT INTO fdc_admin.parametre (name, parent, value, type, minval, maxval, lookupvalues, "default", explanation, sort, checkable) VALUES ('t_company', 'Data', 'fdc_data.industri', 'T', '', '', '', '', 'Parametergruppe til tabel "industri"', 10, ' ');
INSERT INTO fdc_admin.parametre (name, parent, value, type, minval, maxval, lookupvalues, "default", explanation, sort, checkable) VALUES ('t_publicservice', 'Data', 'fdc_data.offentlig_service', 'T', '', '', '', '', '', 10, ' ');
INSERT INTO fdc_admin.parametre (name, parent, value, type, minval, maxval, lookupvalues, "default", explanation, sort, checkable) VALUES ('t_road_traffic', 'Data', 'fdc_data.vejnet', 'T', '', '', '', '', 'Parametergruppe til tabel "vejnet"', 10, ' ');
INSERT INTO fdc_admin.parametre (name, parent, value, type, minval, maxval, lookupvalues, "default", explanation, sort, checkable) VALUES ('t_tourism', 'Data', 'fdc_admin.turisme', 'T', '', '', '', '', 'Parametergruppe til opslagstabel "turisme"', 10, ' ');
INSERT INTO fdc_admin.parametre (name, parent, value, type, minval, maxval, lookupvalues, "default", explanation, sort, checkable) VALUES ('t_bioscore', 'Data', 'fdc_data.biodiversitet', 'T', '', '', '', '', 'Parametergruppe til tabel "biodiversitet"', 10, ' ');
INSERT INTO fdc_admin.parametre (name, parent, value, type, minval, maxval, lookupvalues, "default", explanation, sort, checkable) VALUES ('t_human_health', 'Data', 'fdc_data.mennesker', 'T', '', '', '', '', 'Parametergruppe til tabel "mennesker"', 10, ' ');
INSERT INTO fdc_admin.parametre (name, parent, value, type, minval, maxval, lookupvalues, "default", explanation, sort, checkable) VALUES ('t_recreative', 'Data', 'fdc_data.rekreative_omr', 'T', '', '', '', '', 'Parametergruppe til tabel "rekreative områder"', 10, ' ');
INSERT INTO fdc_admin.parametre (name, parent, value, type, minval, maxval, lookupvalues, "default", explanation, sort, checkable) VALUES ('t_flood', 'Data', 'fdc_data.oversvoem', 'T', '', '', '', '', 'Parametergruppe til tabel "oversvømmelser"', 10, ' ');
INSERT INTO fdc_admin.parametre (name, parent, value, type, minval, maxval, lookupvalues, "default", explanation, sort, checkable) VALUES ('t_infrastructure', 'Data', 'fdc_data.kritisk_infrastruktur', 'T', '', '', '', '', 'Parametergruppe til tabel "kritisk infrastruktur"', 10, ' ');
INSERT INTO fdc_admin.parametre (name, parent, value, type, minval, maxval, lookupvalues, "default", explanation, sort, checkable) VALUES ('t_building', 'Data', 'fdc_data.bygninger', 'T', '', '', '', '', 'Parametergruppe til tabel "Bygninger"', 10, ' ');
INSERT INTO fdc_admin.parametre (name, parent, value, type, minval, maxval, lookupvalues, "default", explanation, sort, checkable) VALUES ('t_build_usage', 'Data', 'fdc_admin.bbr_anvendelse', 'T', '', '', '', '', 'Parametergruppe til opslagstabel "bbr-anvendelse"', 10, ' ');
INSERT INTO fdc_admin.parametre (name, parent, value, type, minval, maxval, lookupvalues, "default", explanation, sort, checkable) VALUES ('t_sqmprice', 'Data', 'fdc_admin.kvm_pris', 'T', '', '', '', '', 'Parametergruppe til opslagstabel "kommunal kvm. pris"', 10, ' ');
INSERT INTO fdc_admin.parametre (name, parent, value, type, minval, maxval, lookupvalues, "default", explanation, sort, checkable) VALUES ('t_damage', 'Data', 'fdc_admin.skadefunktioner', 'T', '', '', '', '', 'Parametergruppe til opslagstabel "skadesfunktioner"', 10, ' ');

TRUNCATE TABLE fdc_admin.skadefunktioner;
INSERT INTO fdc_admin.skadefunktioner (skade_type, skade_kategori, b0, b1, b2, c0) VALUES ('Stormflod', 'Helårsbeboelse', 0, 1167.86, -571.21, 578);
INSERT INTO fdc_admin.skadefunktioner (skade_type, skade_kategori, b0, b1, b2, c0) VALUES ('Stormflod', 'Sommerhus', 0, 1681.71, -2128.87, 578);
INSERT INTO fdc_admin.skadefunktioner (skade_type, skade_kategori, b0, b1, b2, c0) VALUES ('Stormflod', 'Garage mm.', 30000, 0, 0, 578);
INSERT INTO fdc_admin.skadefunktioner (skade_type, skade_kategori, b0, b1, b2, c0) VALUES ('Stormflod', 'Anneks', 30000, 0, 0, 578);
INSERT INTO fdc_admin.skadefunktioner (skade_type, skade_kategori, b0, b1, b2, c0) VALUES ('Stormflod', 'Erhverv', 0, 1387.94, -881.8, 578);
INSERT INTO fdc_admin.skadefunktioner (skade_type, skade_kategori, b0, b1, b2, c0) VALUES ('Stormflod', 'Kultur', 0, 1387.94, -881.8, 578);
INSERT INTO fdc_admin.skadefunktioner (skade_type, skade_kategori, b0, b1, b2, c0) VALUES ('Stormflod', 'Forsyning', 0, 1387.94, -881.8, 578);
INSERT INTO fdc_admin.skadefunktioner (skade_type, skade_kategori, b0, b1, b2, c0) VALUES ('Stormflod', 'Offentlig', 0, 1387.94, -881.8, 578);
INSERT INTO fdc_admin.skadefunktioner (skade_type, skade_kategori, b0, b1, b2, c0) VALUES ('Stormflod', 'Ingen data', 0, 0, 2000, 578);
INSERT INTO fdc_admin.skadefunktioner (skade_type, skade_kategori, b0, b1, b2, c0) VALUES ('Stormflod', 'Andet', 0, 0, 2000, 578);
INSERT INTO fdc_admin.skadefunktioner (skade_type, skade_kategori, b0, b1, b2, c0) VALUES ('Skybrud', 'Helårsbeboelse', 0, 1167.86, -571.21, 578);
INSERT INTO fdc_admin.skadefunktioner (skade_type, skade_kategori, b0, b1, b2, c0) VALUES ('Skybrud', 'Sommerhus', 0, 1681.71, -2128.87, 578);
INSERT INTO fdc_admin.skadefunktioner (skade_type, skade_kategori, b0, b1, b2, c0) VALUES ('Skybrud', 'Garage mm.', 30000, 0, 0, 578);
INSERT INTO fdc_admin.skadefunktioner (skade_type, skade_kategori, b0, b1, b2, c0) VALUES ('Skybrud', 'Anneks', 30000, 0, 0, 578);
INSERT INTO fdc_admin.skadefunktioner (skade_type, skade_kategori, b0, b1, b2, c0) VALUES ('Skybrud', 'Erhverv', 0, 1387.94, -881.8, 578);
INSERT INTO fdc_admin.skadefunktioner (skade_type, skade_kategori, b0, b1, b2, c0) VALUES ('Skybrud', 'Kultur', 0, 1387.94, -881.8, 578);
INSERT INTO fdc_admin.skadefunktioner (skade_type, skade_kategori, b0, b1, b2, c0) VALUES ('Skybrud', 'Forsyning', 0, 1387.94, -881.8, 578);
INSERT INTO fdc_admin.skadefunktioner (skade_type, skade_kategori, b0, b1, b2, c0) VALUES ('Skybrud', 'Offentlig', 0, 1387.94, -881.8, 578);
INSERT INTO fdc_admin.skadefunktioner (skade_type, skade_kategori, b0, b1, b2, c0) VALUES ('Skybrud', 'Ingen data', 0, 0, 2000, 578);
INSERT INTO fdc_admin.skadefunktioner (skade_type, skade_kategori, b0, b1, b2, c0) VALUES ('Skybrud', 'Andet', 0, 0, 2000, 578);
INSERT INTO fdc_admin.skadefunktioner (skade_type, skade_kategori, b0, b1, b2, c0) VALUES ('Vandløb', 'Helårsbeboelse', 0, 1167.86, -571.21, 578);
INSERT INTO fdc_admin.skadefunktioner (skade_type, skade_kategori, b0, b1, b2, c0) VALUES ('Vandløb', 'Sommerhus', 0, 1681.71, -2128.87, 578);
INSERT INTO fdc_admin.skadefunktioner (skade_type, skade_kategori, b0, b1, b2, c0) VALUES ('Vandløb', 'Garage mm.', 30000, 0, 0, 578);
INSERT INTO fdc_admin.skadefunktioner (skade_type, skade_kategori, b0, b1, b2, c0) VALUES ('Vandløb', 'Anneks', 30000, 0, 0, 578);
INSERT INTO fdc_admin.skadefunktioner (skade_type, skade_kategori, b0, b1, b2, c0) VALUES ('Vandløb', 'Erhverv', 0, 1387.94, -881.8, 578);
INSERT INTO fdc_admin.skadefunktioner (skade_type, skade_kategori, b0, b1, b2, c0) VALUES ('Vandløb', 'Kultur', 0, 1387.94, -881.8, 578);
INSERT INTO fdc_admin.skadefunktioner (skade_type, skade_kategori, b0, b1, b2, c0) VALUES ('Vandløb', 'Forsyning', 0, 1387.94, -881.8, 578);
INSERT INTO fdc_admin.skadefunktioner (skade_type, skade_kategori, b0, b1, b2, c0) VALUES ('Vandløb', 'Offentlig', 0, 1387.94, -881.8, 578);
INSERT INTO fdc_admin.skadefunktioner (skade_type, skade_kategori, b0, b1, b2, c0) VALUES ('Vandløb', 'Ingen data', 0, 0, 2000, 578);
INSERT INTO fdc_admin.skadefunktioner (skade_type, skade_kategori, b0, b1, b2, c0) VALUES ('Vandløb', 'Andet', 0, 0, 2000, 578);

TRUNCATE TABLE fdc_admin.turisme;
INSERT INTO fdc_admin.turisme (bbr_anv_kode, bbr_anv_tekst, kapacitet, omkostning) VALUES (520, '(UDFASES) Bygning til feriekoloni, vandrehjem o.lign. bortset fra sommerhus', 10, 2362);
INSERT INTO fdc_admin.turisme (bbr_anv_kode, bbr_anv_tekst, kapacitet, omkostning) VALUES (331, 'Hotel, kro eller konferencecenter med overnatning', 50, 2362);
INSERT INTO fdc_admin.turisme (bbr_anv_kode, bbr_anv_tekst, kapacitet, omkostning) VALUES (332, 'Bed & breakfast mv.', 8, 2362);
INSERT INTO fdc_admin.turisme (bbr_anv_kode, bbr_anv_tekst, kapacitet, omkostning) VALUES (510, 'Bygninger til sommerhus', 6, 2362);
INSERT INTO fdc_admin.turisme (bbr_anv_kode, bbr_anv_tekst, kapacitet, omkostning) VALUES (521, 'Feriecenter, center til campingplads mv.', 100, 2362);
INSERT INTO fdc_admin.turisme (bbr_anv_kode, bbr_anv_tekst, kapacitet, omkostning) VALUES (522, 'Bygning med ferielejligheder til erhvervsmæssig udlejning', 50, 2362);

CREATE INDEX IF NOT EXISTS parametre_parent_idx ON fdc_admin.parametre USING btree (parent);

