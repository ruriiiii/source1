*&---------------------------------------------------------------------*
*& Include          ZBC405_A20_R04_C01
*&---------------------------------------------------------------------*
CLASS lcl_handler DEFINITION.
  PUBLIC SECTION.
    CLASS-METHODS: on_doubleclick FOR EVENT double_click
      OF cl_gui_alv_grid
      IMPORTING e_row e_column es_row_no,
      on_toolbar FOR EVENT toolbar
        OF cl_gui_alv_grid
        IMPORTING e_object,
      on_user_command FOR EVENT user_command
        OF cl_gui_alv_grid
        IMPORTING e_ucomm,
      on_button_click FOR EVENT button_click
        OF cl_gui_alv_grid
        IMPORTING es_col_id es_row_no.
ENDCLASS.


CLASS lcl_handler IMPLEMENTATION.
  METHOD on_doubleclick.
    DATA carr_name TYPE scarr-carrname.
    CASE e_column-fieldname.
      WHEN 'CARRID'.
        READ TABLE gt_sbook INTO gs_sbook INDEX es_row_no-row_id.
        IF sy-subrc = 0.
          SELECT SINGLE carrname
            INTO carr_name
            FROM scarr
            WHERE carrid = gs_sbook-carrid.
          IF sy-subrc = 0.
            MESSAGE i000(zt03_msg) WITH carr_name.
          ELSE.
            MESSAGE i000(zt03_msg) WITH 'No Found!'.
          ENDIF.
        ENDIF.
    ENDCASE.


  ENDMETHOD.

  METHOD on_toolbar.
    DATA ls_button TYPE stb_button.

    CLEAR ls_button.
    ls_button-function = 'DISP_CARR'.
    ls_button-icon = icon_ws_plane.
    ls_button-quickinfo = 'Airline Name'.
    ls_button-butn_type = '0'.   "normal button
*    ls_button-text = ''.
    INSERT ls_button INTO TABLE e_object->mt_toolbar.


  ENDMETHOD.

  METHOD on_user_command.
    DATA: ls_roid TYPE lvc_s_roid,
          ls_col  TYPE lvc_s_col.

    CALL METHOD go_alv->get_current_cell
      IMPORTING
        es_col_id = ls_col
        es_row_no = ls_roid.

    CASE e_ucomm.
      WHEN 'DISP_CARR'.
        READ TABLE gt_sbook INTO gs_sbook INDEX ls_roid-row_id.

        IF sy-subrc = 0.
          SET PARAMETER ID 'CAR' FIELD gs_sbook-carrid.
          SET PARAMETER ID 'CON' FIELD gs_sbook-connid.

          CALL TRANSACTION 'SAPBC405CAL'.
        ENDIF.
    ENDCASE.

  ENDMETHOD.

  METHOD on_button_click.
    CASE es_col_id-fieldname.
      WHEN 'SEAT'.
        READ TABLE gt_sbook INTO gs_sbook INDEX es_row_no-row_id.

        IF gs_sbook-carrid = 'AA'.
          MESSAGE i000(zt03_msg) WITH 'American Airlines 입니당'.
        ELSE.
        ENDIF.
    ENDCASE.


  ENDMETHOD.
ENDCLASS.
