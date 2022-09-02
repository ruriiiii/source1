*&---------------------------------------------------------------------*
*& Report ZBC401_A18_MAIN_CHG
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zbc401_a18_main_chg.

DATA: go_airplane  TYPE REF TO zcl_airplane_a18,
      gt_airplanes TYPE TABLE OF REF TO zcl_airplane_a18.

START-OF-SELECTION.

  CALL METHOD zcl_airplane_a18=>display_n_o_airplanes.

  CREATE OBJECT go_airplane
    EXPORTING
      iv_name         = 'LH Berlin'
      iv_planetype    = 'A321-200'
*
    EXCEPTIONS
      wrong_planetype = 1.

  IF sy-subrc EQ 0.

    APPEND go_airplane TO gt_airplanes.

  ENDIF.

  CREATE OBJECT go_airplane
    EXPORTING
      iv_name         = 'AA New York'
      iv_planetype    = '747-400'
    EXCEPTIONS
      wrong_planetype = 1.

  IF sy-subrc EQ 0.
    APPEND go_airplane TO gt_airplanes.
  ENDIF.


  CREATE OBJECT go_airplane
    EXPORTING
      iv_name         = 'US Herculs'
      iv_planetype    = '747-200F'
    EXCEPTIONS
      wrong_planetype = 1.

  IF sy-subrc EQ 0.
    APPEND go_airplane TO gt_airplanes.

  ENDIF.



  LOOP AT gt_airplanes INTO go_airplane.

    CALL METHOD go_airplane->display_attributes.
  ENDLOOP.
