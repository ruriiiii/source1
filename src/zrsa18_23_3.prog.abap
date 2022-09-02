*&---------------------------------------------------------------------*
*& Report ZRSA18_23_3
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*

INCLUDE zrsa18_23_3_top                         .    " Global Data

* INCLUDE ZRSA18_23_3_O01                         .  " PBO-Modules
* INCLUDE ZRSA18_23_3_I01                         .  " PAI-Modules
INCLUDE zrsa18_23_3_f01                         .  " FORM-Routines

*event
*LOAD-OF-PROGRAM.
INITIALIZATION. "Runtime에 딱 한번 실행(type '1')
  IF sy-uname = 'KD-A-18'.
    pa_car = 'AA'.
    pa_con = '0017'.
  ENDIF.                          "저 유저일때는 기본값을 저렇게 줄거야


*  SELECT SINGLE carrid connid
*    from spfli
*    into ( pa_car, pa_con ).       "첫번째 값을 가져와서 기본값으로 지정할거야

AT SELECTION-SCREEN OUTPUT. "PBO

AT SELECTION-SCREEN. "PAI
  IF pa_con IS INITIAL.
    MESSAGE i016(pn) WITH 'Check'.
    STOP.
  ENDIF.

START-OF-SELECTION.

"Get Info List
PERFORM ge_info.
WRITE 'TEST'.


IF gt_info IS INITIAL.
  "S, I, E, W, A, X : S, I, E를 제일 많이 씀
  MESSAGE i016(pn) WITH 'Data is not found'.
  "         메시지클래스
  RETURN.
ENDIF.
cl_demo_output=>display_data( gt_info ).


*IF gt_info is not INITIAL.
* cl_demo_output=>display_data( gt_info ).
*ELSE.
*ENDIF.
