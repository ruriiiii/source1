*&---------------------------------------------------------------------*
*& Include          ZBC405_A18_ALV02_CLASS
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
      on_data_changed FOR EVENT data_changed
        OF cl_gui_alv_grid
        IMPORTING er_data_changed,
      on_data_changed_finished FOR EVENT data_changed_finished
        OF cl_gui_alv_grid
        IMPORTING E_MODIFIED et_good_cells.



ENDCLASS.

CLASS lcl_handler IMPLEMENTATION.
  METHOD on_doubleclick.

    DATA : carrname TYPE scarr-carrname.

    CASE e_column-fieldname.

      WHEN 'CARRID'.
        READ TABLE gt_sbook INTO gs_sbook INDEX e_row-index.
        IF sy-subrc = 0.
          SELECT SINGLE carrname
            FROM scarr
            INTO carrname
            WHERE carrid = gs_sbook-carrid.

          IF sy-subrc = 0.
            MESSAGE i000(zt03_msg) WITH carrname.
          ENDIF.

        ENDIF.
    ENDCASE.
  ENDMETHOD.

  METHOD on_toolbar.
    DATA ls_button TYPE stb_button.

    ls_button-butn_type = '3'.    "구분선 만들어주기
    INSERT ls_button INTO TABLE e_object->mt_toolbar.

    CLEAR ls_button.
    ls_button-butn_type = '0'.    "normal button
    ls_button-function = 'GOTOFL'.
    ls_button-icon = icon_flight.
    ls_button-quickinfo = 'Go to flight connection'.
    ls_button-text = 'Flight'.
    INSERT ls_button INTO TABLE e_object->mt_toolbar.

  ENDMETHOD.
  METHOD on_user_command.
    DATA: ls_col  TYPE lvc_s_col,
          ls_roid TYPE lvc_s_roid.

    CALL METHOD go_alv->get_current_cell
      IMPORTING
        es_col_id = ls_col
        es_row_no = ls_roid.

    CASE e_ucomm.
      WHEN 'GOTOFL'.
        READ TABLE gt_sbook INTO gs_sbook INDEX ls_roid-row_id.

        IF sy-subrc = 0.
          SET PARAMETER ID 'CAR' FIELD gs_sbook-carrid.
          SET PARAMETER ID 'CON' FIELD gs_sbook-connid.

          CALL TRANSACTION 'SAPBC405CAL'.
        ENDIF.
    ENDCASE.


  ENDMETHOD.

  METHOD on_data_changed .        "데이터를 변경하면 원래 있던 필드의 값이 그에 맞게 변경 (customid를 변경시 이름,폰,메일 변경)

    FIELD-SYMBOLS : <fs> LIKE gt_sbook.

    DATA : ls_mod_cells TYPE lvc_s_modi,
           ls_ins_cells TYPE lvc_s_moce,
           ls_del_cells TYPE lvc_s_moce.

    LOOP AT er_data_changed->mt_good_cells INTO ls_mod_cells.

      CASE ls_mod_cells-fieldname.

        WHEN 'CUSTOMID'.
          PERFORM customer_change_part USING er_data_changed
                                       ls_mod_cells.

      ENDCASE.


    ENDLOOP.

*-- inserted parts
    IF  er_data_changed->mt_inserted_rows IS NOT INITIAL.       "필드 추가 후 데이터를 넣어줄 때

      ASSIGN  er_data_changed->mp_mod_rows->* TO <fs>.   "<fs> : field symbol
      IF sy-subrc EQ 0.
        APPEND LINES OF <fs> TO gt_sbook.
        LOOP AT er_data_changed->mt_inserted_rows INTO ls_ins_cells.

          READ TABLE gt_sbook INTO gs_sbook INDEX ls_ins_cells-row_id.
          IF sy-subrc EQ 0.
*
            PERFORM insert_parts USING er_data_changed
                                          ls_ins_cells.

          ENDIF.
        ENDLOOP.
      ENDIF.
    ENDIF.


    " delete parts
    IF  er_data_changed->mt_deleted_rows IS NOT INITIAL.    "mt_DELETED_rows에 내가 지운 row의 위치가 들어감

      LOOP AT er_data_changed->mt_deleted_rows INTO ls_del_cells.

        READ TABLE gt_sbook INTO gs_sbook INDEX ls_del_cells-row_id.
        IF sy-subrc EQ 0.
          MOVE-CORRESPONDING gs_sbook to dw_sbook.
          APPEND dw_sbook TO dl_sbook.
        ENDIF.
      ENDLOOP.


    ENDIF.
  ENDMETHOD.

  METHOD on_data_changed_finished.
    DATA ls_mod_cells TYPE lvc_s_modi.

    CHECK e_modified = 'X'.      "'X'체크의 의미 : 조건이 참일 떄만 아래 로직을 수행한다. =>체크로직

    LOOP AT et_good_cells INTO ls_mod_cells.
      PERFORM modify_check USING ls_mod_cells.
    ENDLOOP.

  ENDMETHOD.
ENDCLASS.
