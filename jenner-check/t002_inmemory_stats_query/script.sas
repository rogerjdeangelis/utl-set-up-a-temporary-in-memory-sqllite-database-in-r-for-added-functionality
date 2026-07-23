/* The statistical query the repo demonstrates via an in-memory SQLite database in R
   (utl-set-up-a-temporary-in-memory-sqllite-database-in-r-for-added-functionality.sas):
   avg / stdev / variance / median of AGE for the WHERE age<13 subset. Here the same
   query runs natively in PROC SQL against the HAVE table the repo builds from
   sashelp.class. Aggregates, column aliases, and the age<13 filter match the original. */

options validvarname=upcase;
data have;
  set sashelp.class(keep=name age);
run;quit;

proc sql;
  create table want as
  select
     avg(age)       as Avg
    ,std(age)       as Stdev
    ,var(age)       as Var
    ,median(age)    as Median
  from
     have
  where
     age<13;
quit;

proc print data=want;
run;quit;
