* Encoding: UTF-8.
* פתיחת קובץ ללא תכניות לא בתכנית הלאומית חדש

* find first measurment for each id/maane/yishuv.
* Identify Duplicate Cases.
SORT CASES BY id(A) datefill(A) yishuv(A) mmaanecode(A).
MATCH FILES
  /FILE=*
  /BY id datefill yishuv mmaanecode
  /FIRST=PrimaryFirst
  /LAST=PrimaryLast.
DO IF (PrimaryFirst).
COMPUTE  MatchSequence=1-PrimaryLast.
ELSE.
COMPUTE  MatchSequence=MatchSequence+1.
END IF.
LEAVE  MatchSequence.
FORMATS  MatchSequence (f7).
COMPUTE  InDupGrp=MatchSequence>0.
SORT CASES InDupGrp(D).
MATCH FILES
  /FILE=*
  /DROP=PrimaryLast InDupGrp MatchSequence.
VARIABLE LABELS  PrimaryFirst 'Indicator of each first matching case as Primary'.
VALUE LABELS  PrimaryFirst 0 'Duplicate Case' 1 'Primary Case'.
VARIABLE LEVEL  PrimaryFirst (ORDINAL).
FREQUENCIES VARIABLES=PrimaryFirst.
EXECUTE.


*define the date of the first measurment for all the cases blonging to the same id/maane/yishuv.
If PrimaryFirst=1 datefirst=datefill.
formats datefirst (edate10).
execute.
If id=lag(Id) and mmaanecode=lag(mmaanecode) and yishuv=lag(yishuv) datefirst=Lag(datefirst).
execute.


* delete from file all single measurments (by id/maane/yishuv).
FILTER OFF.
USE ALL.
SELECT IF (MatchSequence>0).
EXECUTE.

* compute number of days from first measurment to current measurment.
compute DaysFromFirstMeasure=ctime.days(datefill-dateFirst).
exe.

***compute DaysFromFirstMeasure=ctime.days(datefill-dateFirst).
recode DaysFromFirstMeasure (0=1) (1 thru 90=2) (91 thru 465=3) (466 thru hi=4) into cat_timefromfirst.
val lab cat_timefromfirst
1 same day
2 less than 3 months
3 3 months to 1 year and 3 months
4 more than 1 year and 3 months.
exe.
freq var=cat_timefromfirst.

* leave in the file only: first measurments and other measurments in range of 3-15 months from the first one.
FILTER OFF.
USE ALL.
SELECT IF (PrimaryFirst=1 or (DaysFromFirstMeasure>90 and DaysFromFirstMeasure<456)).
EXECUTE.

* find first measurments which have pairs in the range specified - 3-12 months - i.e. only first measurments which are still not single NOW after deleting other measurment which are not in the specified range.
SORT CASES BY id(A) mmaanecode(A) yishuv(A) datefill(A).
MATCH FILES
  /FILE=*
  /BY id mmaanecode yishuv
  /FIRST=FirstM
  /LAST=PrimaryLast.
DO IF (FirstM).
COMPUTE  MatchSequence1=1-PrimaryLast.
ELSE.
COMPUTE  MatchSequence1=MatchSequence1+1.
END IF.
LEAVE  MatchSequence1.
FORMATS  MatchSequence1 (f7).
COMPUTE  InDupGrp=MatchSequence1>0.
SORT CASES InDupGrp(D).
MATCH FILES
  /FILE=*
  /DROP=PrimaryLast InDupGrp.
VARIABLE LABELS  FirstM 'Indicator of each first matching case as Primary' MatchSequence1 
    'Sequential count of matching cases'.
VALUE LABELS  FirstM 0 'Duplicate Case' 1 'Primary Case'.
VARIABLE LEVEL  FirstM (ORDINAL) /MatchSequence1 (SCALE).
FREQUENCIES VARIABLES=FirstM MatchSequence1.
EXECUTE.

* delete first measurments which are single now.  
FILTER OFF.
USE ALL.
SELECT IF (MatchSequence1>0).
EXECUTE.



* find the last measurment in the specified range.
SORT CASES BY id(A) mmaanecode(A) yishuv(A) datefill(A).
MATCH FILES
  /FILE=*
  /BY id mmaanecode yishuv
  /FIRST=PrimaryFirst1
  /LAST=PrimaryLast.
DO IF (PrimaryFirst1).
COMPUTE  MatchSequence1=1-PrimaryLast.
ELSE.
COMPUTE  MatchSequence1=MatchSequence1+1.
END IF.
LEAVE  MatchSequence1.
FORMATS  MatchSequence1 (f7).
COMPUTE  InDupGrp=MatchSequence1>0.
SORT CASES InDupGrp(D).
MATCH FILES
  /FILE=*
  /DROP=PrimaryFirst1 InDupGrp MatchSequence1.
VARIABLE LABELS  PrimaryLast 'Indicator of each last matching case as Primary'.
VALUE LABELS  PrimaryLast 0 'Duplicate Case' 1 'Primary Case'.
VARIABLE LEVEL  PrimaryLast (ORDINAL).
FREQUENCIES VARIABLES=PrimaryLast.
EXECUTE.

* leave in the file only the first and last measurments.
FILTER OFF.
USE ALL.
SELECT IF (FirstM=1 or PrimaryLast=1).
EXECUTE.

*name the measurments - 1 or 2 - chronologically.
compute Measurment=0.
if FirstM=1 Measurment=1.
if PrimaryLast=1 Measurment=2.
FORMATS  Measurment (f1).
exe.
freq var=Measurment.


* restructure file.
SORT CASES BY id mmaanecode yishuv Measurment.
CASESTOVARS
  /ID=id mmaanecode yishuv
  /INDEX=Measurment
  /GROUPBY=VARIABLE.

** DONE!!!!! ****

