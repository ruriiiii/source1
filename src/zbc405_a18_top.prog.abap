*&---------------------------------------------------------------------*
*& Include ZBC405_A18_TOP                           - Report ZBC405_A18
*&---------------------------------------------------------------------*
REPORT zbc405_a18.

DATA gs_flight TYPE dv_flights.

PARAMETERS: p_car TYPE s_carr_id
                  MEMORY ID car OBLIGATORY,    "OBLIGATORY : 필수로 입력해야하는 옵션을 설정할 때
            p_con TYPE s_conn_id
                  MEMORY ID con.

PARAMETERS p_str TYPE string LOWER CASE.   "LOWER CASE : 소문자 인식이 가능하게 함

PARAMETERS p_chk AS CHECKBOX DEFAULT 'X'.  "as CHECKBOX : 체크박스 설정, DEFAULT 'X' : 체크된게 디폴트로 설정할 때

PARAMETERS: p_rad1 RADIOBUTTON GROUP rd1,       "그룹명이 같은 애들끼리 한 묶음. 한 묶음 중 한 개만 선택 가능함
            p_rad2 RADIOBUTTON GROUP rd1,
            p_rad3 RADIOBUTTON GROUP rd1.


PARAMETERS p_chk2 AS CHECKBOX DEFAULT 'X' MODIF ID mod.



*INITIALIZATION.
*  s_fldate-low = sy-datum.
*  s_fldate-high = sy-datum + 30.
*
*  s_fldate-sign = 'I'.
*  s_fldate-option = 'BT'.
*
*  APPEND s_fldate.



*SELECT-OPTIONS : s_fldate for dv_flights-fldate.


*Loop at SCREEN.
*  if screen-group1 = 'mod'.
*    screen-input = 0.
*    screen-output = 1.
*    MODIFY SCREEN.
*  ENDIF.
*ENDLOOP.



*CASE 'X'.
*  WHEN p_rad1.
*  WHEN p_rad2.
*  WHEN p_rad3.
*ENDCASE.

*SET PARAMETER ID 'Z01' FIELD p_car.
*GET PARAMETER ID 'Z01' FIELD p_car.
