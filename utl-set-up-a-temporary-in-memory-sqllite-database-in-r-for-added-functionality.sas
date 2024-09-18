%let pgm=utl-set-up-a-temporary-in-memory-sqllite-database-in-r-for-added-functionality;

Set up a temporary in memory sqllite database in r

Problem: Use an index to select students with under 13 years of age

github
https://tinyurl.com/bdfsmzz8
https://github.com/rogerjdeangelis/utl-set-up-a-temporary-in-memory-sqllite-database-in-r-for-added-functionality

This opens up the full functionality of a sqllite database for-added-functionality;
sqldf does not have this functionality

    1 insert
    2 update
    3 delete
    4 create table
    5 triggers
    6 views
    7 indexing
    8 custom functions?

   SOLUTIONS

        1  r sql (has the stat and math functions by default)

        2  python sql (NOT VERY USEFUL - DOES NOT HAVE THE MATH AND STAT FUNCTIONS LIKE STDEV AND VARIANCE)
           (Could not figure out how to add the C function extensions or to use customized functions)


NOTE

  In-memory databases can be faster for certain operations because they avoid disk I/O,
  which can be a bottleneck.

  Can be save in memory database to disk for later usage

/*               _     _
 _ __  _ __ ___ | |__ | | ___ _ __ ___
| `_ \| `__/ _ \| `_ \| |/ _ \ `_ ` _ \
| |_) | | | (_) | |_) | |  __/ | | | | |
| .__/|_|  \___/|_.__/|_|\___|_| |_| |_|
|_|
*/

/**************************************************************************************************************************/
/*                         |                                                         |                                    */
/*   INPUT                 |        PROCESS                                          |  OUTPUT                            */
/*   =====                 |        =======                                          |  ======                            */
/*                         |                                                         |                                    */
/* Obs    NAME       AGE   |                                                         |                                    */
/*                         |   con <- dbConnect(RSQLite::SQLite(), ":memory:")       |      Avg   Stdev Var      Median   */
/*   1    Alfred      14   |                                                         |                                    */
/*   2    Alice       13   |   dbWriteTable(con, "have", have)                       | 11.71429 0.48795 0.23809      12   */
/*   3    Barbara     13   |                                                         |                                    */
/*   4    Carol       14   |   dbExecute(con,                                        |                                    */
/*   5    Henry       14   |      "CREATE                                            |                                    */
/*   6    James       12   |          INDEX idx_age                                  |                                    */
/*   7    Jane        12   |       on                                                |                                    */
/*   9    Jeffrey     13   |          have(age)")                                    |                                    */
/*  10    John        12   |                                                         |                                    */
/*  11    Joyce       11   |   result <- dbGetQuery(con,                             |                                    */
/*  12    Judy        14   |      "SELECT                                            |                                    */
/*  13    Louise      12   |           avg(age)      as Avg                          |                                    */
/*  14    Mary        15   |          ,stdev(age)    as Stdev                        |                                    */
/*  15    Philip      16   |          ,variance(age) as Var                          |                                    */
/*  16    Robert      12   |          ,median(age)   as Median                       |                                    */
/*  17    Ronald      15   |       FROM                                              |                                    */
/*  18    Thomas      11   |           have                                          |                                    */
/*  19    William     15   |       where                                             |                                    */
/*                         |           age<13.")                                     |                                    */
/*                         |                                                         |                                    */
/**************************************************************************************************************************/

/*                   _
(_)_ __  _ __  _   _| |_
| | `_ \| `_ \| | | | __|
| | | | | |_) | |_| | |_
|_|_| |_| .__/ \__,_|\__|
        |_|
*/

options validvarname=upcase;
libname sd1 "d:/sd1";
data sd1.have;
  set sashelp.class(keep=name age);
run;quit;

/**************************************************************************************************************************/
/*                                                                                                                        */
/*   INPUT                                                                                                                */
/*                                                                                                                        */
/*                                                                                                                        */
/* Obs    NAME       AGE                                                                                                  */
/*                                                                                                                        */
/*   1    Alfred      14                                                                                                  */
/*   2    Alice       13                                                                                                  */
/*   2    Alice       13                                                                                                  */
/*  ...                                                                                                                   */
/*  17    Ronald      15                                                                                                  */
/*  18    Thomas      11                                                                                                  */
/*  19    William     15                                                                                                  */
/*                                                                                                                        */
/**************************************************************************************************************************/

/*                    _
/ |  _ __   ___  __ _| |
| | | `__| / __|/ _` | |
| | | |    \__ \ (_| | |
|_| |_|    |___/\__, |_|
                   |_|
*/

%utl_rbeginx;
parmcards4;
library(RSQLite)
library(DBI)
library(haven)
source("c:/oto/fn_tosas9x.R")
have<-read_sas("d:/sd1/have.sas7bdat")
print(have)
 con <- dbConnect(RSQLite::SQLite(), ":memory:")

 dbWriteTable(con, "have", have)

 dbExecute(con,
    "CREATE
        INDEX idx_age
     on
        have(age)")

 result <- dbGetQuery(con,
    "SELECT
         avg(age)      as Avg
        ,stdev(age)    as Stdev
        ,variance(age) as Var
        ,median(age)   as Median
     FROM
         have
     where
         age<13.")

 print(result)

 dbDisconnect(con)
 fn_tosas9x(
      inp    = result
     ,outlib ="d:/sd1/"
     ,outdsn ="want"
     )
;;;;
%utl_rendx;

proc print data=sd1.want;
run;quit;

/**************************************************************************************************************************/
/*                                                                                                                        */
/*  R                                                                                                                     */
/*                                                                                                                        */
/*    ageAvg ageStdev  ageStdev ageVariance ageMedian                                                                     */
/*                                                                                                                        */
/*  11.71429  0.48795 0.2380952   0.2380952        12                                                                     */
/*                                                                                                                        */
/*  SAS                                                                                                                   */
/*                                                                                                                        */
/*  Obs   ROWNAMES      AVG       STDEV       VAR      MEDIAN                                                             */
/*                                                                                                                        */
/*  1         1       11.7143    0.48795    0.23810      12                                                               */
/*                                                                                                                        */
/**************************************************************************************************************************/

/*___                _   _                             _
|___ \   _ __  _   _| |_| |__   ___  _ __    ___  __ _| |
  __) | | `_ \| | | | __| `_ \ / _ \| `_ \  / __|/ _` | |
 / __/  | |_) | |_| | |_| | | | (_) | | | | \__ \ (_| | |
|_____| | .__/ \__, |\__|_| |_|\___/|_| |_| |___/\__, |_|
        |_|    |___/                                |_|
*/

%utl_pybeginx;
parmcards4;
import pandas as pd
import sqlite3
import pyreadstat as ps;
import pyarrow.feather as feather;
import tempfile;
import pyperclip;
import os;
import sys;
import subprocess;
import time;
exec(open('c:/oto/fn_tosas9x.py').read());
have, meta = ps.read_sas7bdat('d:/sd1/have.sas7bdat');
print(have)
conn = sqlite3.connect(':memory:')
have.to_sql('class', conn, index=False, if_exists='replace')

conn.execute('CREATE INDEX idx_age ON class (age)')
cursor = conn.execute('''
      SELECT
          avg(age) as ageAve
         ,min(age) as ageMin
         ,max(age) as ageMax
      FROM
          class''')
results = cursor.fetchall()
for row in results:
    print(row)
print(results);
want=pd.DataFrame(results)
want.info()
print(want)
fn_tosas9x(want,outlib='d:/sd1/',outdsn='pywant',timeest=3);
# Close the connection
conn.close()
;;;;
%utl_pyendx;

proc print data=sd1.pywant(rename=(v0=ageAve v1=ageMin v2=ageMax));
run;quit;

/**************************************************************************************************************************/
/*                                                                                                                        */
/*  PYTHON                                                                                                                */
/*                                                                                                                        */
/*               0     1     2                                                                                            */
/*    0  13.315789  11.0  16.0                                                                                            */
/*                                                                                                                        */
/*  SAS                                                                                                                   */
/*                                                                                                                        */
/*     AGEAVE    AGEMIN    AGEMAX                                                                                         */
/*                                                                                                                        */
/*    13.3158      11        16                                                                                           */
/*                                                                                                                        */
/**************************************************************************************************************************/

/*              _
  ___ _ __   __| |
 / _ \ `_ \ / _` |
|  __/ | | | (_| |
 \___|_| |_|\__,_|

*/
