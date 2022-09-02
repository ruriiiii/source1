*&---------------------------------------------------------------------*
*& Report ZRSA18_07
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zrsa18_07.

PARAMETERS pa_code TYPE c LENGTH 4 DEFAULT 'SYNC'.
PARAMETERS pa_date TYPE sy-datum.
DATA gv_cond_d1 LIKE pa_date.

gv_cond_d1 = sy-datum.

CASE pa_code.
  WHEN 'SYNC'.
    IF  pa_date < '20220620'.
      WRITE '교육 준비중'.

    ELSEIF + pa_date < gv_cond_d1 - 7.
      WRITE 'SAPUI5'.

    ELSEIF + pa_date > gv_cond_d1 + 365.
      WRITE '취업'.

    ELSEIF + pa_date > gv_cond_d1 + 7.
      WRITE 'ABAP Dictionary'.

    ELSE.
      WRITE 'ABAP Workbench'.

    ENDIF.

  WHEN OTHERS.
    WRITE '다음 기회에 수강'.
ENDCASE.
