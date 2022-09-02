*&---------------------------------------------------------------------*
*& Report ZRSA00_06
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zrsa00_06.

*DATA: gv_a,
*      gv_b,
*      gv_c TYPE i.


*PARAMETERS pa_i TYPE i.
*" A, B, C, D만 입력 가능
*PARAMETERS pa_class TYPE c LENGTH 1.
*DATA gv_result LIKE pa_i.
*
** 10보다 크면 출력
** 20보다 크다면, 10추가로 더헤서 출력하세요.
** A반이라면, 입력한 값에 모두 100을 추가하세요.
*IF pa_i > 20.
*  gv_result = pa_i + 10.
*ELSEIF pa_i > 10.
*  gv_result = pa_i.
*ELSE.
*
*ENDIF.
*
*CASE pa_class.
*  WHEN 'A'.
*    gv_result = pa_i + 100.
*  WHEN OTHERS.
*
*ENDCASE.

*CASE 변수 .
*  WHEN 값
*
*  WHEN OTHERS.
*
*ENDCASE.
