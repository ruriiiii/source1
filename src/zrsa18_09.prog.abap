*&---------------------------------------------------------------------*
*& Report ZRSA18_09
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zrsa18_09.

DATA gv_d TYPE sy-datum.

gv_d = sy-datum - 365.

CLEAR gv_d.

IF gv_d IS INITIAL.
  WRITE 'No date'.
ELSE.
  WRITE 'Exist date'.
ENDIF.


*
*DATA gv_cnt TYPE i.
*
*DO 10 TIMES.
*  gv_cnt = gv_cnt + 1.
**  WRITE sy-index.
*  DO 5 TIMES.
**    WRITE sy-index.
*  ENDDO.
**  WRITE sy-index.
*  NEW-LINE.
*
*ENDDO.
*
*WRITE gv_cnt.
