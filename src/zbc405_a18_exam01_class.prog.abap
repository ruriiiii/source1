*&---------------------------------------------------------------------*
*& Include          ZBC405_A18_EXAM01_CLASS
*&---------------------------------------------------------------------*

CLASS lcl_handler DEFINITION.
  PUBLIC SECTION.
    CLASS-METHODS: on_toolbar FOR EVENT toolbar
      OF cl_gui_alv_grid
      IMPORTING e_object,
      on_user_command FOR EVENT user_command
        OF cl_gui_alv_grid
        IMPORTING e_ucomm,
      on_doubleclick FOR EVENT double_click
        OF cl_gui_alv_grid
        IMPORTING e_row e_column es_row_no,
      on_data_changed FOR EVENT data_changed
        OF cl_gui_alv_grid
        IMPORTING er_data_changed.
ENDCLASS.

CLASS lcl_handler IMPLEMENTATION.
  METHOD on_toolbar.
    DATA ls_button TYPE stb_button.
*
    CLEAR ls_button.
    ls_button-butn_type = '3'.
    INSERT ls_button INTO TABLE e_object->mt_toolbar.

    CLEAR ls_button.
    ls_button-function = 'DISP_CARR'.
    ls_button-icon = icon_flight.
    ls_button-quickinfo = 'Airline Name'.
    ls_button-butn_type = '0'.   "normal button
    ls_button-text = 'Flight'.
    INSERT ls_button INTO TABLE e_object->mt_toolbar.

    CLEAR ls_button.
    ls_button-function = 'FLINFO'.
    ls_button-quickinfo = 'Goto Flight list info'.
    ls_button-butn_type = '0'.
    ls_button-text = 'Flight Info'.
    INSERT ls_button INTO TABLE e_object->mt_toolbar.

    CLEAR ls_button.
    ls_button-function = 'FLDATA'.
    ls_button-quickinfo = 'Flight Data'.
    ls_button-butn_type = '0'.
    ls_button-text = 'Flight Data'.
    INSERT ls_button INTO TABLE e_object->mt_toolbar.

  ENDMETHOD.

  METHOD on_user_command.
    DATA: ls_col  TYPE lvc_s_col,
          ls_roid TYPE lvc_s_roid.

    DATA : ls_col_id TYPE lvc_s_col,
           ls_row_id TYPE lvc_s_row.

    DATA : lt_rows TYPE lvc_t_roid,
           ls_rows TYPE lvc_s_roid.

    DATA : lv_text(30).

    CALL METHOD go_alv->get_current_cell
      IMPORTING
        es_col_id = ls_col_id
        es_row_id = ls_row_id.

    CALL METHOD go_alv->get_selected_rows
      IMPORTING
*       et_index_rows =
        et_row_no = lt_rows.

    CASE e_ucomm.

      WHEN 'DISP_CARR'.
        IF  ls_col_id-fieldname = 'CARRID'.
          READ TABLE gt_spfli INTO gs_spfli INDEX ls_row_id-index.
          IF sy-subrc = 0.
            CLEAR lv_text.
            SELECT SINGLE carrname
              FROM scarr
              INTO lv_text
              WHERE carrid = gs_spfli-carrid.

            IF sy-subrc = 0.
              MESSAGE i000(zt03_msg) WITH lv_text.
            ELSE.
              MESSAGE i000(zt03_msg) WITH 'No found!'.
            ENDIF.
          ENDIF.
        ELSE.
          MESSAGE i000(zt03_msg) WITH '항공사를 선택하세요'.
          EXIT.
        ENDIF.


      WHEN 'FLINFO'.
        DATA gs_spfli2 TYPE spfli.
        DATA gt_spfli2 TYPE TABLE OF spfli.



        IF lines( lt_rows ) > 0.
          LOOP AT lt_rows INTO ls_rows.

            READ TABLE gt_spfli INTO gs_spfli INDEX ls_rows-row_id.
            IF sy-subrc EQ 0.
              MOVE-CORRESPONDING gs_spfli TO gs_spfli2.
              APPEND gs_spfli2 TO gt_spfli2.

            ENDIF.

          ENDLOOP.

          EXPORT mem_it_spfli FROM gt_spfli2 TO MEMORY ID 'BC405'.
          SUBMIT bc405_call_flights AND RETURN.


        ELSE.
          MESSAGE i000(zt03_msg) WITH 'Please select at least one line!'.
        ENDIF.

      WHEN 'FLDATA'.

        CLEAR gs_spfli.
        READ TABLE gt_spfli INTO gs_spfli INDEX ls_row_id-index.

        SET PARAMETER ID 'CAR' FIELD gs_spfli-carrid.
        SET PARAMETER ID 'CON' FIELD gs_spfli-connid.

        CALL TRANSACTION 'SAPBC410A_INPUT_FIEL'.

    ENDCASE.





  ENDMETHOD.

  METHOD on_doubleclick.
    DATA ls_row_id TYPE lvc_s_row.

    CALL METHOD go_alv->get_current_cell
      IMPORTING
        es_row_id = ls_row_id.

    CASE e_column-fieldname.
      WHEN 'CARRID' OR 'CONNID'.

        READ TABLE gt_spfli INTO gs_spfli INDEX ls_row_id-index.
        IF sy-subrc = 0.
          SUBMIT bc405_event_s4 AND RETURN
          WITH so_car = gs_spfli-carrid
          WITH so_con = gs_spfli-connid.
        ENDIF.
    ENDCASE.



  ENDMETHOD.

  METHOD on_data_changed.
    FIELD-SYMBOLS : <fs> LIKE gt_spfli.

    DATA : ls_mod_cells TYPE lvc_s_modi,
           ls_ins_cells TYPE lvc_s_moce,
           ls_del_cells TYPE lvc_s_moce.

    LOOP AT er_data_changed->mt_good_cells INTO ls_mod_cells.

      CASE ls_mod_cells-fieldname.

        when 'FLTIME' or 'DEPTIME'.
          PERFORM time_change USING er_data_changed
                                       ls_mod_cells.

      ENDCASE.
  ENDLOOP.

  ENDMETHOD.
ENDCLASS.
