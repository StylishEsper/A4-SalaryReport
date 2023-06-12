       identification division.
       program-id. A4-SalaryReport.
       author. Ahmed Butt.
       date-written. 2021-02-22.
      *Program Description: This program reads data from a file and calculates, formats, and outputs it into another file.
      *
       environment division.
      *
       input-output section.
       file-control.
      *
           select salary-file
               assign to "../../../A4-SalaryReport/A4.dat"
               organization is line sequential.

           select salary-file-5A
               assign to "../../../A4-SalaryReport/A5.dat"
               organization is line sequential.

           select report-file
               assign to "../../../A4-SalaryReport/A4-SalaryReport.out"
               organization is line sequential.

           select report-file-5A
               assign to "../../../A4-SalaryReport/A5-SalaryReport-5A.out"
               organization is line sequential.

           select report-file-dat
               assign to "../../../A4-SalaryReport/A5-SalaryData-NonGrad.dat"
               organization is line sequential.


           select report-file-5B
               assign to "../../../A4-SalaryReport/A5-SalaryReport-5B.out"
               organization is line sequential.

      *
       data division.
       file section.

       fd salary-file
           data record is salary-rep
           record contains 28 characters.
      *
       01 salary-rep.
         05 sr-employee-number pic 9(3).
         05 sr-employee-name pic x(15).
         05 sr-education-code pic x.
         05 sr-years-service pic 99.
         05 sr-present-salary pic 9(5)v99.

       fd salary-file-5A
           data record is salary-rep-5A
           record contains 37 characters.
      *
       01 salary-rep-5A.
         05 5A-employee-number pic 9(3).
         05 5A-employee-name pic x(15).
         05 5A-years-service pic 99.
         05 5A-education-code pic x.
         05 5A-present-salary pic 9(5)v99.
         05 5A-budget pic 9(6)v99.

       fd report-file-dat
           data record is salary-rep-5B
           record contains 37 characters.

       01 salary-rep-5B.
         05 5B-employee-number pic 9(3).
         05 5B-employee-name pic x(15).
         05 5B-years-service pic 99.
         05 5B-education-code pic x.
         05 5B-present-salary pic 9(5)v99.
         05 5B-budget pic 9(6)v99.


      *
       fd report-file
           data record is report-line
           record contains 80 characters.
      *
       01 report-line pic x(80).

       fd report-file-5A
           data record is report-line-5A
           record contains 102 characters.
      *
       01 report-line-5A pic x(102).

       fd report-file-5B
           data record is report-line-5B
           record contains 102 characters.
      *
       01 report-line-5B pic x(102).

      *
       working-storage section.
      *
       01 ws-eof-flag pic x value 'n'.

       77 ws-true-cnst pic x value "Y".
       77 ws-false-cnst pic x value "N".
       77 ws-one-cnst pic 9 value 1.
       77 ws-hundred-cnst pic 999 value 100.
       77 ws-analyst-cnst pic x(7) value "ANALYST".
       77 ws-senprog-cnst pic x(8) value "SEN PROG".
       77 ws-prog-cnst pic x(4) value "PROG".
       77 ws-jrprog-cnst pic x(7) value "JR PROG".
       77 ws-per-analyst-cnst pic 99v9 value 12.8.
       77 ws-per-senprog-cnst pic 9v9 value 9.3.
       77 ws-per-prog-cnst pic 9v9 value 6.7.
       77 ws-per-jrprog-cnst pic 9v9 value 3.2.
       77 ws-per-unclassified-cnst pic 9 value 0.

       01 ws-line-page-counters.
         05 ws-line-count pic 999 value 0.
         05 ws-page-count pic 999 value 0.
         05 ws-lines-per-page-cnst pic 999 value 19.
      *
       01 ws-header-info pic x(80) value "Ahmed Butt, Assignment 5                  20210311                     ".
      *
       01 ws-header-title.
         05 filler pic x(79) value "                              EMPLOYEE SALARY REPORT                     PAGE  ".
         05 ws-page-number pic 9.
      *
       01 ws-header-columns1 pic x(80) value "EMP  EMP                            PRESENT  INCREASE     PAY           NEW".
      *
       01 ws-header-columns2 pic x(80) value "NUM  NAME          YEARS POSITION    SALARY     %       INCREASE       SALARY".

       01 ws-header-columns15 pic x(102) value "EMP  EMP                             PRESENT  INCREASE     PAY           NEW       BUDGET       BUDGET".
      *
       01 ws-header-columns25 pic x(102) value "NUM  NAME          YEARS POSITION    SALARY     %       INCREASE       SALARY      ESTIMATE     DIFF".


       01 5A-header pic x(88) value "                         OLD      INCREASE       NEW	     BUDGET        DIFF".

       01 5A-pageno.
         05 filler pic x(99) value "                               NON-GRADUATE EMPLOYEE SALARY REPORT                            PAGE".
         05 filler pic x value spaces.
         05 page-num pic 99.

       01 5A-pageno2.
         05 filler pic x(99) value "                                 GRADUATE EMPLOYEE SALARY REPORT                              PAGE".
         05 filler pic x value spaces.
         05 page-num2 pic 99.


       01 5A-total-diff.
         05 5A-total-title pic x(89) value "                                                              GRADUATE TOTAL BUDGET DIFF: ".
         05 5A-total pic $$z(4),zz9.99.

       01 5B-total-diff.
         05 5B-total-title pic x(89) value "                                                          NON-GRADUATE TOTAL BUDGET DIFF: ".
         05 5B-total pic $$z(4),zz9.99.

       01 avg-increase-line.
         05 avg-increase-title pic x(89) value "                                                                        AVERAGE INCREASE: ".
         05 avg-increase pic $$z(4),zz9.99.

      *
       01 ws-detail-line.
         05 ws-employee-number pic 999.
         05 filler pic x value spaces.
         05 ws-employee-name pic x(15).
         05 filler pic x(2) value spaces.
         05 ws-years-service pic z9.
         05 filler pic x(2) value spaces.
         05 ws-position pic x(8).
         05 filler pic x(2) value spaces.
         05 ws-present-salary pic zz,zz9.99.
         05 filler pic x(2) value spaces.
         05 ws-increase-percent pic zz.z.
         05 ws-per-sign pic x value spaces.
         05 filler pic x(3) value spaces.
         05 ws-pay-increase pic $$zz,zz9.99+.
         05 filler pic x(2) value spaces.
         05 ws-new-salary pic $z(4),zz9.99.

       01 5A-detail-line.
         05 ws5A-employee-number pic 999.
         05 filler pic x value spaces.
         05 ws5A-employee-name pic x(15).
         05 filler pic x(2) value spaces.
         05 ws5A-years-service pic z9.
         05 filler pic x(2) value spaces.
         05 ws5A-position pic x(8).
         05 filler pic x(2) value spaces.
         05 ws5A-present-salary pic zz,zz9.99.
         05 filler pic x(2) value spaces.
         05 ws5A-increase-percent pic zz.z.
         05 ws5A-per-sign pic x value spaces.
         05 filler pic x(2) value spaces.
         05 ws5A-pay-increase pic $$zz,zz9.99+.
         05 filler pic x(2) value spaces.
         05 ws5A-new-salary pic $z(4),zz9.99.
         05 filler pic x(3) value spaces.
         05 ws5A-budget pic zz,zz9.99.
         05 ws5A-diff pic --zz,zz9.99.

       01 5B-detail-line.
         05 ws5B-employee-number pic 999.
         05 filler pic x value spaces.
         05 ws5B-employee-name pic x(15).
         05 filler pic x(2) value spaces.
         05 ws5B-years-service pic z9.
         05 filler pic x(2) value spaces.
         05 ws5B-position pic x(8).
         05 filler pic x(2) value spaces.
         05 ws5B-present-salary pic zz,zz9.99.
         05 filler pic x(2) value spaces.
         05 ws5B-increase-percent pic zz.z.
         05 ws5B-per-sign pic x value spaces.
         05 filler pic x(2) value spaces.
         05 ws5B-pay-increase pic $$zz,zz9.99+.
         05 filler pic x(2) value spaces.
         05 ws5B-new-salary pic $z(4),zz9.99.
         05 filler pic x(3) value spaces.
         05 ws5B-budget pic zz,zz9.99.
         05 ws5B-diff pic --zz,zz9.99.


       01 ws-class-line-title pic x(80) value "EMPLOYEE CLASS:        Analyst    Sen Prog    Prog    Jr Prog    Unclassified".

       01 ws-class-line.
         05 filler pic x(28) value "# ON THIS PAGE:             ".
         05 ws-analysts pic z9.
         05 filler pic x(10) value spaces.
         05 ws-senprogs pic z9.
         05 filler pic x(6) value spaces.
         05 ws-progs pic z9.
         05 filler pic x(9) value spaces.
         05 ws-jrprogs pic z9.
         05 filler pic x(14) value spaces.
         05 ws-unclassifieds pic z9.

       01 ws-avg-line1.
         05 filler pic x(34) value "AVERAGE INCREASES:   ANALYST=     ".
         05 ws-avg-analyst pic z,zz9.99.
         05 filler pic x(17) value "     SEN PROG=   ".
         05 ws-avg-senprog pic z,zz9.99.

       01 ws-avg-line2.
         05 filler pic x(34) value "                     PROG=        ".
         05 ws-avg-prog pic z,zz9.99.
         05 filler pic x(17) value "     JR PROG=    ".
         05 ws-avg-jrprog pic z,zz9.99.

       01 ws-for-calculation.
         05 ws-increase-percent-calc pic 99v99.
         05 ws-pay-increase-calc pic 9(5)v99.
         05 ws-ratio pic 9v999.
         05 ws-new-salary-calc pic 9(6)v99.
         05 ws-analyst-count pic 99.
         05 ws-senprog-count pic 99.
         05 ws-prog-count pic 99.
         05 ws-jrprog-count pic 99.
         05 ws-unclassified-count pic 99.
         05 ws-avg-analyst-calc pic 9(6)v99.
         05 ws-avg-senprog-calc pic 9(6)v99.
         05 ws-avg-prog-calc pic 9(6)v99.
         05 ws-avg-jrprog-calc pic 9(6)v99.
         05 ws-analyst-total-count pic 99.
         05 ws-senprog-total-count pic 99.
         05 ws-prog-total-count pic 99.
         05 ws-jrprog-total-count pic 99.
         05 ws5A-diff-calc pic S9(7)v99.
         05 ws5A-diff-calc-total pic S9(8)v99.
         05 ws5B-diff-calc pic S9(7)v99.
         05 ws5B-diff-calc-total pic S9(8)v99.
         05 ws-increase-calc pic S9(7)v99.
         05 ws-avg-increase-calc pic S9(8)v99.
         05 ws-avg-increase-total pic S9(8)v99.
         05 ws-lines pic 99.

       procedure division.
       000-main.
      *
           move ws-false-cnst to ws-eof-flag.

           open input salary-file.
           open input salary-file-5A.
           open output report-file.
           open output report-file-dat.
           open output report-file-5A.

           read salary-file
               at end
                   move ws-true-cnst to ws-eof-flag.

           read salary-file-5A
               at end
                   move ws-true-cnst to ws-eof-flag.

           perform 100-process-pages
             until ws-eof-flag = ws-true-cnst.

           divide ws-avg-analyst-calc by ws-analyst-total-count giving ws-avg-analyst-calc rounded.
           divide ws-avg-senprog-calc by ws-senprog-total-count giving ws-avg-senprog-calc rounded.
           divide ws-avg-prog-calc by ws-prog-total-count giving ws-avg-prog-calc rounded.
           divide ws-avg-jrprog-calc by ws-jrprog-total-count giving ws-avg-jrprog-calc rounded.

           move ws-avg-analyst-calc to ws-avg-analyst.
           move ws-avg-senprog-calc to ws-avg-senprog.
           move ws-avg-prog-calc to ws-avg-prog.
           move ws-avg-jrprog-calc to ws-avg-jrprog.

           display "".
           display ws-avg-line1.
           display ws-avg-line2.

           write report-line from "".
           write report-line from ws-avg-line1.
           write report-line from ws-avg-line2.

           move ws5A-diff-calc-total to 5A-total.

           divide ws-avg-increase-total by ws-lines giving ws-avg-increase-calc rounded.
           move ws-avg-increase-calc to avg-increase.

           write report-line-5A from "".
           write report-line-5A from avg-increase-line.

           write report-line-5A from "".
           write report-line-5A from 5A-total-diff.

           close salary-file, report-file, salary-file-5A, report-file-dat, report-file-5A.

           open input salary-file.
           open input report-file-dat.
           open output report-file-5B.

           read salary-file
               at end
                   move ws-true-cnst to ws-eof-flag.

           read report-file-dat
               at end
                   move ws-true-cnst to ws-eof-flag.

           move 0 to ws-page-count.
           move 0 to ws-line-count.
           move 0 to page-num.
           move 0 to ws-lines, ws-avg-increase-calc, ws-avg-increase-total, avg-increase.
           move spaces to ws-eof-flag.

           perform 400-process-pages-nongrads
             until ws-eof-flag = ws-true-cnst.

           move ws5B-diff-calc-total to 5B-total.

           divide ws-avg-increase-total by ws-lines giving ws-avg-increase-calc rounded.
           move ws-avg-increase-calc to avg-increase.

           write report-line-5B from "".
           write report-line-5B from avg-increase-line.

           write report-line-5B from "".
           write report-line-5B from 5B-total-diff.

           close report-file-dat, report-file-5B, salary-file.

           accept return-code.

           goback.
      *
       100-process-pages.
      *
           move 0 to ws-line-count.

           perform 200-print-headings

           perform 300-process-lines
             until ws-eof-flag = ws-true-cnst
             OR ws-line-count > ws-lines-per-page-cnst.

           move ws-analyst-count to ws-analysts.
           move ws-senprog-count to ws-senprogs.
           move ws-prog-count to ws-progs.
           move ws-jrprog-count to ws-jrprogs.
           move ws-unclassified-count to ws-unclassifieds.

           display "".
           display ws-class-line-title.
           display ws-class-line.

           write report-line from "".
           write report-line from ws-class-line-title.
           write report-line from ws-class-line.

           move 0 to ws-analyst-count, ws-senprog-count, ws-prog-count, ws-jrprog-count, ws-unclassified-count.
           move 0 to ws-analysts, ws-senprogs, ws-progs, ws-jrprogs, ws-unclassifieds.
      *
       200-print-headings.
      *
           add ws-one-cnst to ws-page-count.
           move ws-page-count to ws-page-number.

           if ws-page-count = ws-one-cnst
               display ws-header-info
               write report-line from ws-header-info
               write report-line-5A from ws-header-info
               write report-line-5A from ""
           else
               display ""
               display ""
               write report-line from ""
               write report-line from "" after advancing page
               write report-line-5A from "" after advancing page
           end-if.
      *
           display "".
           display ws-header-title.
           display "".
           display ws-header-columns1.
           display ws-header-columns2.
           display "".

           write report-line from ws-header-title after advancing 1 line.
           write report-line from ws-header-columns1 after advancing 2 line.
           write report-line from ws-header-columns2.
           write report-line from "".

           move ws-page-count to page-num2.
           write report-line-5A from 5A-pageno2.
           write report-line-5A from "".
           write report-line-5A from ws-header-columns15.
           write report-line-5A from ws-header-columns25.
           write report-line-5A from "".
      *
       300-process-lines.

           move sr-employee-number to ws-employee-number.
           move sr-employee-name to ws-employee-name.
           move sr-years-service to ws-years-service.
           move sr-present-salary to ws-present-salary.

           if 5A-education-code = "N"
             then
               write salary-rep-5B from salary-rep-5A
               subtract ws-one-cnst from ws-line-count
           end-if.

           if sr-years-service > 15 AND sr-education-code = "G"
             then
               move ws-analyst-cnst to ws-position
               add ws-one-cnst to ws-analyst-count
               add ws-one-cnst to ws-analyst-total-count
               move ws-per-analyst-cnst to ws-increase-percent, ws-increase-percent-calc
               move "%" to ws-per-sign
               divide ws-per-analyst-cnst by ws-hundred-cnst giving ws-ratio
               multiply ws-ratio by sr-present-salary giving ws-pay-increase-calc rounded
               move ws-pay-increase-calc to ws-pay-increase
               add ws-pay-increase-calc to sr-present-salary giving ws-new-salary-calc
               move ws-new-salary-calc to ws-new-salary
               add ws-pay-increase-calc to ws-avg-analyst-calc
           end-if.

           if sr-years-service >= 7 AND sr-years-service <= 15 AND sr-education-code = "G"
             then
               move ws-senprog-cnst to ws-position
               add ws-one-cnst to ws-senprog-count
               add ws-one-cnst to ws-senprog-total-count
               move ws-per-senprog-cnst to ws-increase-percent
               move "%" to ws-per-sign
               divide ws-per-senprog-cnst by ws-hundred-cnst giving ws-ratio
               multiply ws-ratio by sr-present-salary giving ws-pay-increase-calc rounded
               move ws-pay-increase-calc to ws-pay-increase
               add ws-pay-increase-calc to sr-present-salary giving ws-new-salary-calc
               move ws-new-salary-calc to ws-new-salary
               add ws-pay-increase-calc to ws-avg-senprog-calc
           end-if.

           if sr-years-service > 2 AND sr-years-service < 7 AND sr-education-code = "G"
             then
               move ws-prog-cnst to ws-position
               add ws-one-cnst to ws-prog-count
               add ws-one-cnst to ws-prog-total-count
               move ws-per-prog-cnst to ws-increase-percent
               move "%" to ws-per-sign
               divide ws-per-prog-cnst by ws-hundred-cnst giving ws-ratio
               multiply ws-ratio by sr-present-salary giving ws-pay-increase-calc rounded
               move ws-pay-increase-calc to ws-pay-increase
               add ws-pay-increase-calc to sr-present-salary giving ws-new-salary-calc
               move ws-new-salary-calc to ws-new-salary
               add ws-pay-increase-calc to ws-avg-prog-calc
           end-if.

           if sr-years-service <= 2 AND sr-education-code = "G"
             then
               move spaces to ws-position
               add ws-one-cnst to ws-unclassified-count
               move ws-per-unclassified-cnst to ws-increase-percent
               move spaces to ws-per-sign
               move 0 to ws-pay-increase
               move sr-present-salary to ws-new-salary
           end-if.

           if sr-years-service > 10 AND sr-education-code = "N"
             then
               move ws-prog-cnst to ws-position
               add ws-one-cnst to ws-prog-count
               add ws-one-cnst to ws-prog-total-count
               move ws-per-prog-cnst to ws-increase-percent
               move "%" to ws-per-sign
               divide ws-per-prog-cnst by ws-hundred-cnst giving ws-ratio
               multiply ws-ratio by sr-present-salary giving ws-pay-increase-calc rounded
               move ws-pay-increase-calc to ws-pay-increase
               add ws-pay-increase-calc to sr-present-salary giving ws-new-salary-calc
               move ws-new-salary-calc to ws-new-salary
               add ws-pay-increase-calc to ws-avg-prog-calc
           end-if.

           if sr-years-service <= 10 AND sr-years-service > 4 AND sr-education-code = "N"
             then
               move ws-jrprog-cnst to ws-position
               add ws-one-cnst to ws-jrprog-count
               add ws-one-cnst to ws-jrprog-total-count
               move ws-per-jrprog-cnst to ws-increase-percent
               move "%" to ws-per-sign
               divide ws-per-jrprog-cnst by ws-hundred-cnst giving ws-ratio
               multiply ws-ratio by sr-present-salary giving ws-pay-increase-calc rounded
               move ws-pay-increase-calc to ws-pay-increase
               add ws-pay-increase-calc to sr-present-salary giving ws-new-salary-calc
               move ws-new-salary-calc to ws-new-salary
               add ws-pay-increase-calc to ws-avg-jrprog-calc
           end-if.

           if sr-years-service <= 4 AND sr-education-code = "N"
             then
               move spaces to ws-position
               add ws-one-cnst to ws-unclassified-count
               move ws-per-unclassified-cnst to ws-increase-percent
               move spaces to ws-per-sign
               move 0 to ws-pay-increase
               move sr-present-salary to ws-new-salary
           end-if.

           if 5A-education-code = "G"
             then
               move 0 to ws-new-salary-calc
               move 5A-employee-number to ws5A-employee-number
               move 5A-employee-name to ws5A-employee-name
               move 5A-years-service to ws5A-years-service

               if 5A-years-service > 15 AND 5A-education-code = "G"
                 then
                   move ws-analyst-cnst to ws5A-position
                   move ws-per-analyst-cnst to ws5A-increase-percent
                   move "%" to ws5A-per-sign
                   divide ws-per-analyst-cnst by ws-hundred-cnst giving ws-ratio
                   multiply ws-ratio by 5A-present-salary giving ws-pay-increase-calc rounded
                   move ws-pay-increase-calc to ws5A-pay-increase
                   add ws-pay-increase-calc to 5A-present-salary giving ws-new-salary-calc
                   move ws-new-salary-calc to ws5A-new-salary
                   move 5A-budget to ws5A-budget
                   subtract ws-new-salary-calc from 5A-budget giving ws5A-diff-calc
                   move ws5A-diff-calc to ws5A-diff

               end-if

               if 5A-years-service >= 7 AND 5A-years-service <= 15 AND 5A-education-code = "G"
                 then
                   move ws-senprog-cnst to ws5A-position
                   move ws-per-senprog-cnst to ws5A-increase-percent
                   move "%" to ws5A-per-sign
                   divide ws-per-senprog-cnst by ws-hundred-cnst giving ws-ratio
                   multiply ws-ratio by 5A-present-salary giving ws-pay-increase-calc rounded
                   move ws-pay-increase-calc to ws5A-pay-increase
                   add ws-pay-increase-calc to 5A-present-salary giving ws-new-salary-calc
                   move ws-new-salary-calc to ws5A-new-salary
                   move 5A-budget to ws5A-budget
                   subtract ws-new-salary-calc from 5A-budget giving ws5A-diff-calc
                   move ws5A-diff-calc to ws5A-diff

               end-if

               if 5A-years-service > 2 AND 5A-years-service < 7 AND 5A-education-code = "G"
                 then
                   move ws-prog-cnst to ws5A-position
                   move ws-per-prog-cnst to ws5A-increase-percent
                   move "%" to ws5A-per-sign
                   divide ws-per-prog-cnst by ws-hundred-cnst giving ws-ratio
                   multiply ws-ratio by 5A-present-salary giving ws-pay-increase-calc rounded
                   move ws-pay-increase-calc to ws5A-pay-increase
                   add ws-pay-increase-calc to 5A-present-salary giving ws-new-salary-calc
                   move ws-new-salary-calc to ws5A-new-salary
                   move 5A-budget to ws5A-budget
                   subtract ws-new-salary-calc from 5A-budget giving ws5A-diff-calc
                   move ws5A-diff-calc to ws5A-diff
               end-if

               if 5A-years-service <= 2 AND 5A-education-code = "G"
                 then
                   move spaces to ws5A-position
                   move 0 to ws5A-increase-percent
                   move spaces to ws5A-per-sign
                   move 0 to ws5A-pay-increase
                   move 5A-present-salary to ws5A-new-salary
                   move 5A-budget to ws5A-budget
                   subtract 5A-present-salary from 5A-budget giving ws5A-diff-calc
                   move ws5A-diff-calc to ws5A-diff
                   move 0 to ws-pay-increase-calc
               end-if

               move 5A-present-salary to ws5A-present-salary

               add ws-pay-increase-calc to ws-avg-increase-total

               add ws5A-diff-calc to ws5A-diff-calc-total

               add 1 to ws-lines

               write report-line-5A from 5A-detail-line
           end-if.


           add ws-one-cnst to ws-line-count.

           display ws-detail-line.

           write report-line from ws-detail-line.

           read salary-file
               at end
                   move ws-true-cnst to ws-eof-flag.

           read salary-file-5A
               at end
                   move ws-true-cnst to ws-eof-flag.

       400-process-pages-nongrads.

           move 0 to ws-line-count.

           perform 500-print-headings-nongrads

           perform 600-process-nongrads
             until ws-eof-flag = ws-true-cnst
             OR ws-line-count > ws-lines-per-page-cnst.

       500-print-headings-nongrads.

           add ws-one-cnst to ws-page-count.
           move ws-page-count to page-num.

           if ws-page-count = ws-one-cnst
               write report-line-5B from ws-header-info
               write report-line-5B from ""
           else
               write report-line-5B from "" after advancing page
           end-if.

           write report-line-5B from 5A-pageno.
           write report-line-5B from "".
           write report-line-5B from ws-header-columns15.
           write report-line-5B from ws-header-columns25.
           write report-line-5B from "".

       600-process-nongrads.

           move 0 to ws-new-salary-calc
           
           move 5B-employee-number to ws5B-employee-number
           move 5B-employee-name to ws5B-employee-name
           move 5B-years-service to ws5B-years-service

           if 5B-years-service <= 10 AND 5B-years-service > 4 AND 5B-education-code = "N"
             then
               move ws-jrprog-cnst to ws5B-position
               move ws-per-jrprog-cnst to ws5B-increase-percent
               move "%" to ws5A-per-sign
               divide ws-per-jrprog-cnst by ws-hundred-cnst giving ws-ratio
               multiply ws-ratio by 5B-present-salary giving ws-pay-increase-calc rounded
               move ws-pay-increase-calc to ws5B-pay-increase
               add ws-pay-increase-calc to 5B-present-salary giving ws-new-salary-calc
               move ws-new-salary-calc to ws5B-new-salary
               move 5B-budget to ws5B-budget
               subtract ws-new-salary-calc from 5B-budget giving ws5B-diff-calc
               move ws5B-diff-calc to ws5B-diff

           end-if

           if 5B-years-service > 10 AND 5B-education-code = "N"
             then
               move ws-prog-cnst to ws5B-position
               move ws-per-prog-cnst to ws5B-increase-percent
               move "%" to ws5B-per-sign
               divide ws-per-prog-cnst by ws-hundred-cnst giving ws-ratio
               multiply ws-ratio by 5B-present-salary giving ws-pay-increase-calc rounded
               move ws-pay-increase-calc to ws5B-pay-increase
               add ws-pay-increase-calc to 5B-present-salary giving ws-new-salary-calc
               move ws-new-salary-calc to ws5B-new-salary
               move 5B-budget to ws5B-budget
               subtract ws-new-salary-calc from 5B-budget giving ws5B-diff-calc
               move ws5B-diff-calc to ws5B-diff
           end-if

           if 5B-years-service <= 4 AND 5B-education-code = "N"
             then
               move spaces to ws5B-position
               move 0 to ws5B-increase-percent
               move spaces to ws5B-per-sign
               move 0 to ws5B-pay-increase
               move 5B-present-salary to ws5B-new-salary
               move 5B-budget to ws5B-budget
               subtract 5B-present-salary from 5B-budget giving ws5B-diff-calc
               move ws5B-diff-calc to ws5B-diff
               move 0 to ws-pay-increase-calc
           end-if

           move 5B-present-salary to ws5B-present-salary

           add ws-pay-increase-calc to ws-avg-increase-total

           add ws5B-diff-calc to ws5B-diff-calc-total

           add ws-one-cnst to ws-line-count
           add ws-one-cnst to ws-lines

           write report-line-5B from 5B-detail-line

           read salary-file
               at end
                   move ws-true-cnst to ws-eof-flag.

           read report-file-dat
               at end
                   move ws-true-cnst to ws-eof-flag.

       end program A4-SalaryReport.