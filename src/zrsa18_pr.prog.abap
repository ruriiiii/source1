*&---------------------------------------------------------------------*
*& Report ZRSA18_PR
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zrsa18_pr.

"2주차 과제(if문)
*PARAMETERS pa_year TYPE i.
*
*IF pa_year MOD 4 = 0.
*  IF pa_year MOD 100 <> 0 or pa_year MOD 400 = 0.
*   WRITE '1'.
*
*  ELSE.
*   WRITE '0'.
*
*  ENDIF.
*ELSE.
*  WRITE '0'.
*
*ENDIF.



"별찍기 예제 1

*PARAMETERS pa_a type i.
*
*DATA: gv_a TYPE i.
*
*
*DO pa_a TIMES.
*
*  gv_a = gv_a + 1.
*
*  Do gv_a Times.
*    WRITE '*'.
*  Enddo.
*  New-line.
*
*ENDDO.



"2주차 과제(반복문)

*PARAMETERS pa_a TYPE i.
*
*DATA: gv_a TYPE i.
*
*DO pa_a TIMES.
*
*  gv_a = gv_a + 1.
*
*  DO pa_a - gv_a TIMES.
*
*    WRITE ''.
*  ENDDO.
*
*  DO gv_a TIMES.
*
*    WRITE '*'.
*
*  ENDDO.
*
*  NEW-LINE.
*
*ENDDO.



"3주차 과제(조건문)

PARAMETERS pa_hour TYPE i.
PARAMETERS pa_min TYPE i.

DATA pa_min2 TYPE i.

IF pa_hour = 0.
 pa_hour = 24.
  IF pa_min > 44.
   pa_min = pa_min - 45.
   pa_hour = 0.
   WRITE: pa_hour, pa_min.
  ELSEIF pa_min < 45.
   pa_hour = pa_hour - 1.
   pa_min =  pa_min - 45 .
   pa_min2 = 60 + pa_min.
   WRITE: pa_hour, pa_min2.
  ENDIF.

 ELSE.
   IF pa_min > 44.
    pa_min = pa_min - 45.
    WRITE: pa_hour, pa_min.
   ELSEIF pa_min < 45.
    pa_hour = pa_hour - 1.
    pa_min =  pa_min - 45 .
    pa_min2 = 60 + pa_min.
    WRITE: pa_hour, pa_min2.
   ENDIF.

ENDIF.



"3주차 과제(반복문)
*
*PARAMETERS pa_a TYPE i.
*
*DATA: gv_a TYPE i.
*
*DO pa_a TIMES.
*
*  gv_a = gv_a + 1.
*
*  DO pa_a - gv_a TIMES.
*
*    WRITE ''.
*  ENDDO.
*
*  DO gv_a TIMES.
*
*    WRITE '*'.
*
*  ENDDO.
*
*  NEW-LINE.
*
*
*
*ENDDO.
*
*CLEAR gv_a.
*
*DO pa_a TIMES.
*
*  gv_a = gv_a + 1.
*
*  DO gv_a TIMES.
*
*    WRITE ''.
*  ENDDO.
*
*  DO pa_a - gv_a TIMES.
*
*    WRITE '*'.
*
*  ENDDO.
*
*  NEW-LINE.
*
*
*ENDDO.
