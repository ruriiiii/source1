*&---------------------------------------------------------------------*
*& Report ZRSA00_23
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*

INCLUDE zrsa00_23_top                           .    " Global Data

* INCLUDE ZRSA00_23_O01                           .  " PBO-Modules
* INCLUDE ZRSA00_23_I01                           .  " PAI-Modules
INCLUDE zrsa00_23_f01                           .  " FORM-Routines

* Event
*LOAD-OF-PROGRAM.
INITIALIZATION. " Runtime에 딱 한번 실행 ( Type '1' )
  IF sy-uname = 'KD-T-06'.
    pa_car = 'AA'.
    pa_con = '0017'.
  ENDIF.

AT SELECTION-SCREEN OUTPUT. "PBO

AT SELECTION-SCREEN. "PAI
  IF pa_con IS INITIAL.
    "E/W
    MESSAGE w016(pn) WITH 'Check'.
    "I
*    MESSAGE i016(pn) WITH 'Check'.
*    STOP.
  ENDIF.

START-OF-SELECTION.
  " Get Info List
  PERFORM get_info.
  WRITE 'Test'.
  IF gt_info IS INITIAL.
    "S, I
    MESSAGE i016(pn) WITH 'Data is not found'.
    RETURN.
  ENDIF.
  cl_demo_output=>display_data( gt_info ).
*  IF gt_info IS NOT INITIAL.
*    cl_demo_output=>display_data( gt_info ).
*  ELSE.
*
*  ENDIF.
