REM
REM Eksempel paa brug af postgres backup procedure pb_backup.cmd

REM Ved at bruge: %0\..\pg_backup.cmd kan man placere de to kommandoprocedurer
REM et vilkaarligt sted paa netvaerket, blot de ligger i samme mappe.

REM De nedenstaaende eksempler foretager en backup fra database: flood_damage_costs, 
call %0\..\pg_backup.cmd  "d:\tmp" "flood_damage_costs"
pause

                           

