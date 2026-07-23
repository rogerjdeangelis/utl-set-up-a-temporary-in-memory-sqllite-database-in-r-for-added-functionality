/* INPUT setup step, from
   utl-set-up-a-temporary-in-memory-sqllite-database-in-r-for-added-functionality.sas.
   Original writes to libname sd1 "d:/sd1"; here the target library is WORK so the
   step is self-contained. The DATA step, KEEP=, and VALIDVARNAME=UPCASE are unchanged. */

options validvarname=upcase;
data have;
  set sashelp.class(keep=name age);
run;quit;

proc print data=have;
run;quit;
