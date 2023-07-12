set termout off
set echo off
set verify off
set pagesize 0
set linesize 5000
set arraysize 1
set feedback off
set trimspool on
set trimout on
set heading on
set wrap off

SPOOL /u01/wlzy/jzgz_alarm/data/_MY_DATE/_FILE_NAME.csv
select *
from v_jzgz_jf;
SPOOL OFF
