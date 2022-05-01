-- Dette script skal køres af en Postgres superuser, f.eks. user "postgres"

-- Husk at ændre database navn "fdc_andeby" til det korrekte database navn

-- Opret refererede schemaer - Just in case...
CREATE SCHEMA IF NOT EXISTS fdc_data;
CREATE SCHEMA IF NOT EXISTS fdc_results;
CREATE SCHEMA IF NOT EXISTS fdc_admin;
CREATE SCHEMA IF NOT EXISTS fdc_flood;

-- Opret ressourcegrupper. 
-- Husk at disse roller administres på database *server* niveau, ikke database niveau, 
-- så de deles af alle databaser på server. Pas på navne sammenfald. 
CREATE ROLE fdc_reader       NOINHERIT; -- kan læse data fra alle schemaer i databasen
CREATE ROLE fdc_administrator NOINHERIT; -- har alle rettigheder inkl. oprettelse af nye schemaer


-- Fjern alle standard rettigheder fra schemaer, inkl. schema "public" fro role "PUBLIC"
REVOKE ALL ON SCHEMA public, fdc_data, fdc_flood, fdc_results, fdc_admin FROM PUBLIC;
REVOKE ALL ON DATABASE fdc_andeby FROM PUBLIC;  

-- Tildel rettigheder til de forskellige ressourcegrupper

-- Adgang til database
GRANT CONNECT, TEMP ON DATABASE fdc_andeby TO fdc_reader;
GRANT ALL ON DATABASE fdc_andeby TO fdc_administrator;

-- Adgang til schemaer for read gruppe
GRANT USAGE ON SCHEMA public, fdc_data, fdc_flood, fdc_results, fdc_admin TO fdc_reader;
-- Administrator får alle rettigheder
GRANT ALL ON SCHEMA public, fdc_data, fdc_flood, fdc_results, fdc_admin TO fdc_administrator;

-- Alle rettigheder tildeles på *schema* niveau. Dette simplificeres administrationen voldsomt.
-- Administrator skal kun en gang tage stilling til sikkerhedsniveau for en enkelt tabel
-- og derefter placere denne i det relevante schema 

-- Læse rettigheder for read gruppe på alle schemaer.
GRANT SELECT  ON ALL TABLES    IN SCHEMA public, fdc_data, fdc_flood, fdc_results, fdc_admin TO fdc_reader;
GRANT SELECT  ON ALL SEQUENCES IN SCHEMA public, fdc_data, fdc_flood, fdc_results, fdc_admin TO fdc_reader;
GRANT EXECUTE ON ALL FUNCTIONS IN SCHEMA public, fdc_data, fdc_flood, fdc_results, fdc_admin TO fdc_reader;

-- Alle rettigheder til gruppe adm
GRANT ALL ON ALL TABLES    IN SCHEMA public, fdc_data, fdc_flood, fdc_results, fdc_admin TO fdc_administrator;
GRANT ALL ON ALL SEQUENCES IN SCHEMA public, fdc_data, fdc_flood, fdc_results, fdc_admin TO fdc_administrator; 
GRANT ALL ON ALL FUNCTIONS IN SCHEMA public, fdc_data, fdc_flood, fdc_results, fdc_admin TO fdc_administrator;

-- Ovenstående kommandoer opsætter sikkerhed for *eksisterende* tabeller i de frskellige schemaer, men
-- hvad med *nye* tabeller, dvs. tabeller der oprettes *efter* de ovenstående grant kommandoer er udført ?
-- Svar: Ved brugen af: ALTER DEFAULT PRIVILEGES IN SCHEMA... kan der opsættes et standard sæt af 
-- rettigheder for tabeller o.a. som tilføjes schemaet.  

-- Læse rettigheder til nye objekter for read og write grupper
ALTER DEFAULT PRIVILEGES IN SCHEMA public, fdc_data, fdc_flood, fdc_results, fdc_admin GRANT SELECT  ON TABLES    TO fdc_reader;
ALTER DEFAULT PRIVILEGES IN SCHEMA public, fdc_data, fdc_flood, fdc_results, fdc_admin GRANT SELECT  ON SEQUENCES TO fdc_reader;
ALTER DEFAULT PRIVILEGES IN SCHEMA public, fdc_data, fdc_flood, fdc_results, fdc_admin GRANT EXECUTE ON FUNCTIONS TO fdc_reader;

-- Alle rettigheder til nye objekter til gruppe adm
ALTER DEFAULT PRIVILEGES IN SCHEMA public, fdc_data, fdc_flood, fdc_results, fdc_admin GRANT ALL ON TABLES    TO fdc_administrator;
ALTER DEFAULT PRIVILEGES IN SCHEMA public, fdc_data, fdc_flood, fdc_results, fdc_admin GRANT ALL ON SEQUENCES TO fdc_administrator; 
ALTER DEFAULT PRIVILEGES IN SCHEMA public, fdc_data, fdc_flood, fdc_results, fdc_admin GRANT ALL ON FUNCTIONS TO fdc_administrator;

--- SLUT på Ressource opsætning


--- Oprettelse af eksempel brugere. 
--- * Navne bør ændres til relevante brugernavne
--- * Husk at brugernavne administres på database *server* niveau, ikke database niveau, 

-- Opret 2 eksempel brugere; husk at bruge nøgleordet INHERIT i denne kommando; dette medfører at 
-- bruger automatisk får tildelt rettigheder fra ressourcegrupperne, som brugeren bliver medlem af

-- Bruger "bo" oprettes og tildeles administrator rettigheder til databasen 
-- (afkommentér næste 2 linjer)
-- CREATE ROLE bo WITH LOGIN PASSWORD 'thomsen' VALID UNTIL '2023-01-01' INHERIT;
-- GRANT fdc_administrator TO bo;

-- Bruger "lene" oprettes og tildeles læse rettigheder til databasen
-- (afkommentér næste 2 linjer)
-- CREATE ROLE lene WITH LOGIN PASSWORD 'fischer' VALID UNTIL '2023-01-01' INHERIT;
-- GRANT fdc_reader TO lene;


