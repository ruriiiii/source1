*&---------------------------------------------------------------------*
*& Report ZRSA18_08
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zrsa18_08.

PARAMETERS pa_code TYPE c LENGTH 4 DEFAULT 'SYNC'.
PARAMETERS pa_date TYPE sy-datum. "d도 가능
DATA gv_cond_d1 LIKE pa_date.

gv_cond_d1 = sy-datum + 7.

CASE pa_code.
  WHEN 'SYNC'.
    IF pa_date > gv_cond_d1.
    WRITE 'ABAP Dictionary'(t02).
    ELSE.
    WRITE 'ABAP Workbench'(t01).
    ENDIF.

  WHEN OTHERS.
    WRITE '다음 기회에'(t03).
    EXIT.       "아래 코드를 하지 않고 빠져나감
ENDCASE.

*IF pa_date > gv_cond_d1.
* WRITE 'ABAP Dictionary'(t02).
*ELSE.
*  WRITE 'ABAP Workbench'(t01).
*ENDIF.
