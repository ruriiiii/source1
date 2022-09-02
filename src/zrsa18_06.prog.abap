*&---------------------------------------------------------------------*
*& Report ZRSA18_06
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zrsa18_06.

*PARAMETERS pa_i TYPE i.
*DATA gv_result LIKE pa_i.

*10보다 크면 출력
*20보다 크면 10을 추가로 더하세요
*IF pa_i >= 10 and pa_i <= 20.
*  WRITE pa_i.
*ELSEIF pa_i > 20.
*  ADD 20 TO pa_i.
*  WRITE pa_i.
*ENDIF.
*
*IF pa_i > 20.
*  gv_result = pa_i + 10.
*  WRITE gv_result.
*ELSE.
*ENDIF.
*  IF pa_i > 10.
*    WRITE pa_i.
*  ENDIF.
*
*
*
*IF pa_i > 20.
*
*ELSEIF pa_i > 10.
*
*ELSE.
*
*
*ENDIF.

PARAMETERS pa_i TYPE i.
PARAMETERS pa_class TYPE c LENGTH 1.  "a,b,c,d만 입력가능
DATA gv_result LIKE pa_i.

*10보다 크면 출력
*20보다 크면 10을 추가로 더하세요
*a반이라면 입력한 값에 모두 100을 추가하시오

IF pa_i > 20.
  gv_result = pa_i + 10.
ELSEIF pa_i > 10.
  gv_result = pa_i.
ELSE.

ENDIF.

CASE pa_class.
  WHEN 'A'.
    gv_result = pa_i + 100.
    WRITE gv_result.
  WHEN OTHERS.
    gv_result = pa_i.
    WRITE gv_result.
ENDCASE.
