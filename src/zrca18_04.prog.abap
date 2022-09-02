*&---------------------------------------------------------------------*
*& Report ZRCA18_04
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT ZRCA18_04.

PARAMETERS pa_car TYPE scarr-carrid.  "scarr테이블의 carrid 필드 => Char 3
*PARAMETERS pa_car1 type c LENGTH 3.   "위아래 코드의 차이점 - 위 코드는 입력값을 입력하지않고 선택할 수 있게 함. (F4기능)

Data gs_info type scarr.

Clear gs_info.
SELECT SINGLE carrid carrname
  From scarr
  INTO CORRESPONDING FIELDS OF gs_info  "INTO CORRESPONDING FIELDS OF : 순서대로 넣지 않고 동일한 값에 넣음.
*   INTO gs_info              -> 순서대로 넣어서 결과값이 정확하지 않음.
  WHERE carrid = pa_car.

  WRITE: gs_info-mandt, gs_info-carrid, gs_info-carrname.
