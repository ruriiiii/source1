*&---------------------------------------------------------------------*
*& Report ZBC401_A18_MAIN
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zbc401_a18_main.

TYPE-POOLS : icon.   "SE11->type group : icon인 얘들을 가져다 쓸 수 있도록 선언(아이콘, 심볼,, 등을 사용 가능함)

CLASS lcl_airplane DEFINITION.


  PUBLIC SECTION.

    METHODS:
      constructor
        IMPORTING  iv_name      TYPE string
                   iv_planetype TYPE saplane-planetype
        EXCEPTIONS
                   wrong_planetype.

    METHODS: set_attributes    "첫번째 메소드
      IMPORTING iv_name      TYPE string
                iv_planetype TYPE saplane-planetype,

      display_attributes.  "두번째 메소드

    CLASS-METHODS: display_n_o_airplanes.
    CLASS-METHODS: get_n_o_airplanes
      RETURNING VALUE(rv_count) TYPE i.

    CLASS-METHODS: class_constructor.


  PRIVATE SECTION.
    CONSTANTS c_pos_1 TYPE i VALUE 30.

    DATA: mv_name      TYPE string,
          mv_planetype TYPE saplane-planetype,
          mv_weight    TYPE saplane-weight,
          mv_tankcap   TYPE saplane-tankcap.

    TYPES: ty_planetype TYPE TABLE OF saplane.

    CLASS-DATA: gv_n_o_airplanes TYPE i.
    CLASS-DATA: gv_planetypes TYPE ty_planetype.

    CLASS-METHODS: get_technical_attributes
      IMPORTING  iv_type    TYPE saplane-planetype
      EXPORTING  ev_weight  TYPE saplane-weight
                 ev_tankcap TYPE saplane-tankcap
      EXCEPTIONS wrong_planetype.



ENDCLASS.

CLASS lcl_airplane IMPLEMENTATION.
  METHOD get_technical_attributes.
    DATA ls_planetype TYPE saplane.

    READ TABLE gv_planetypes INTO ls_planetype WITH KEY planetype = iv_type.

    IF sy-subrc EQ 0.
      ev_weight = ls_planetype-weight.
      ev_tankcap = ls_planetype-tankcap.
    ELSE.
    ENDIF.

  ENDMETHOD.

  METHOD class_constructor.
    SELECT *
      FROM saplane
      INTO TABLE gv_planetypes.

  ENDMETHOD.


  METHOD constructor.
    DATA ls_planetype TYPE saplane.
    mv_name = iv_name.
    mv_planetype = iv_planetype.

*    SELECT SINGLE *
*      FROM saplane
*      INTO ls_planetype
*      WHERE planetype = iv_planetype.
*
*    IF sy-subrc NE 0.
*      RAISE wrong_planetype.
*    ELSE.
*
*      mv_weight = ls_planetype-weight.
*      mv_tankcap = ls_planetype-tankcap.

    CALL METHOD get_technical_attributes
      EXPORTING
        iv_type         = iv_planetype
      IMPORTING
        ev_weight       = mv_weight
        ev_tankcap      = mv_tankcap
      EXCEPTIONS
        wrong_planetype = 1.

    IF sy-subrc = 0.
      gv_n_o_airplanes = gv_n_o_airplanes + 1.
    ELSE.
      RAISE wrong_planetype.
    ENDIF.

*  ENDIF.

  ENDMETHOD.


  METHOD get_n_o_airplanes.
    rv_count = gv_n_o_airplanes .
  ENDMETHOD.


  METHOD set_attributes.
    mv_name = iv_name.
    mv_planetype = iv_planetype.

    gv_n_o_airplanes = gv_n_o_airplanes + 1.

  ENDMETHOD.

  METHOD display_attributes.
    WRITE: / icon_ws_plane,
           / 'Name of airplane', AT c_pos_1 mv_name,
           / 'Type of airplane', AT c_pos_1 mv_planetype,
           / 'Weight / Tankcap', AT c_pos_1 mv_weight, mv_tankcap.


  ENDMETHOD.

  METHOD display_n_o_airplanes.
    WRITE: / 'Number of airplanes', AT c_pos_1 gv_n_o_airplanes.
  ENDMETHOD.



ENDCLASS.

DATA: go_airplane  TYPE REF TO lcl_airplane,
      gt_airplanes TYPE TABLE OF REF TO lcl_airplane.

START-OF-SELECTION.

  CALL METHOD lcl_airplane=>display_n_o_airplanes.
*  lcl_airplane=>display_n_o_airplanes( ).


  CREATE OBJECT go_airplane
    EXPORTING
      iv_name         = 'LH Berlin'
      iv_planetype    = 'A321'
    EXCEPTIONS
      wrong_planetype = 1.


  IF sy-subrc EQ 0.


*  CALL METHOD go_airplane->set_attributes
*    EXPORTING
*      iv_name      = 'LH Berlin'
*      iv_planetype = 'A321'.


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


*  CALL METHOD go_airplane->set_attributes
*    EXPORTING
*      iv_name      = 'AA New York'
*      iv_planetype = '747-400'.


  CREATE OBJECT go_airplane
    EXPORTING
      iv_name         = 'US Herculs'
      iv_planetype    = '747-200F'
    EXCEPTIONS
      wrong_planetype = 1.

  IF sy-subrc EQ 0.
    APPEND go_airplane TO gt_airplanes.

  ENDIF.

*  CALL METHOD go_airplane->set_attributes
*    EXPORTING
*      iv_name      = 'US Herculs'
*      iv_planetype = '747-200F'.


  LOOP AT gt_airplanes INTO go_airplane.

    CALL METHOD go_airplane->display_attributes.
  ENDLOOP.

  DATA : gv_count TYPE i.

  gv_count = lcl_airplane=>get_n_o_airplanes( ).
  WRITE : / 'Number of airplane',  gv_count.
