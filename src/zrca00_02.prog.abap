*&---------------------------------------------------------------------*
*& Report ZRCA00_02
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zrca00_02.

DATA gv_step TYPE i.
DATA gv_cal LIKE gv_step.
DATA gv_lev LIKE gv_cal.
PARAMETERS pa_req LIKE gv_lev.
PARAMETERS pa_syear(1) TYPE c.
DATA gv_new_lev LIKE gv_lev.

CASE pa_syear.
  WHEN '1' OR '2' OR '3' OR '4' OR '5' OR '6'.
    IF pa_req >= 3.
      gv_new_lev = 3.
    ELSE.
      gv_new_lev = pa_req.
    ENDIF.

  WHEN OTHERS.
    MESSAGE 'Message Test' TYPE 'X'.

ENDCASE.

WRITE 'Times Table'.
NEW-LINE.

DO gv_new_lev TIMES.
  gv_lev = gv_lev + 1.
  CLEAR gv_step.
  DO 9 TIMES.
    gv_step = gv_step + 1.
    CLEAR gv_cal.
    gv_cal = gv_lev * gv_step.
    WRITE: gv_lev, ' * ', gv_step, ' = ', gv_cal.
    NEW-LINE.
  ENDDO.
  CLEAR gv_step.
  WRITE '========================================'.
  NEW-LINE.
ENDDO.


* Lev2
*DATA gv_step TYPE i.
*DATA gv_cal TYPE i.
*DATA gv_lev TYPE i.
*
*DO 9 TIMES.
*  gv_lev = gv_lev + 1.
*  CLEAR gv_step.
*  DO 9 TIMES.
*    gv_step = gv_step + 1.
*    CLEAR gv_cal.
*    gv_cal = gv_lev * gv_step.
*    WRITE: gv_lev, ' * ', gv_step, ' = ', gv_cal.
*    NEW-LINE.
*  ENDDO.
*  CLEAR gv_step.
*  WRITE '========================================'.
*  NEW-LINE.
*ENDDO.



" 1 Lev
*DATA gv_step TYPE i.
*DATA gv_cal TYPE i.
*DO 9 TIMES.
*  gv_step = gv_step + 1.
*  CLEAR gv_cal.
*  gv_cal = 1 * gv_step.
*  WRITE: '1 * ', gv_step, ' = ', gv_cal.
*  NEW-LINE.
*ENDDO.
