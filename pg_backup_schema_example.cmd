REM
REM Eksempel paa brug af postgres backup procedure pb_backup_schema.cmd

REM Ved at bruge: %0\..\pg_backup_schema.cmd kan man placere de to kommandoprocedurer
REM et vilkaarligt sted paa netvaerket, blot de ligger i samme mappe.

REM De nedenstaaende eksempler foretager en backup fra database: flood_damage_costs, 
REM schemaerne: fdc_data, fdc_admin og FDC_results og placerer backup-filerne i mappe d:\tmp
call %0\..\pg_backup_schema.cmd "flood_damage_costs" "fdc_data" "d:\tmp"
call %0\..\pg_backup_schema.cmd "flood_damage_costs" "fdc_admin" "d:\tmp"
call %0\..\pg_backup_schema.cmd "flood_damage_costs" "fdc_results" "d:\tmp"


                           
