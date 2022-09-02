*&---------------------------------------------------------------------*
*& Report ZBC405_A18_EXAM01
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zbc405_a18_exam01.

DATA ok_code TYPE sy-ucomm.

TABLES: ztspfli_a18.


TYPES : BEGIN OF typ_flt.
          INCLUDE TYPE ztspfli_a18.
TYPES :   indo TYPE c LENGTH 1.
TYPES : flicon TYPE icon-id.
TYPES: ftzone TYPE s_tzone.
TYPES: ttzone TYPE s_tzone.
TYPES :   btn_text TYPE c LENGTH 10.
TYPES :   light TYPE c LENGTH 1.
TYPES : row_color TYPE c LENGTH 4.
TYPES : it_color TYPE lvc_t_scol.
TYPES : it_styl TYPE lvc_t_styl.
TYPES : chg.
TYPES : END OF typ_flt.

DATA: gt_spfli TYPE TABLE OF typ_flt,
      gs_spfli TYPE typ_flt.

"ALV Data 선언
DATA : go_container TYPE REF TO cl_gui_custom_container,
       go_alv       TYPE REF TO cl_gui_alv_grid,
       gv_variant   TYPE disvariant,
       gv_save      TYPE c LENGTH 1,
       gs_layout    TYPE lvc_s_layo,
       gs_color     TYPE lvc_s_scol,
       gt_exct      TYPE ui_functions,
       gt_fcat      TYPE lvc_t_fcat,
       gs_fcat      TYPE lvc_s_fcat,
       gs_styl      TYPE lvc_s_styl.

DATA : gs_stable       TYPE lvc_s_stbl,
       gv_soft_refresh TYPE abap_bool.






"SELECTION SCREEN
SELECTION-SCREEN BEGIN OF BLOCK bl1 WITH FRAME TITLE TEXT-t01.
  SELECT-OPTIONS : so_car FOR ztspfli_a18-carrid MEMORY ID car,
                   so_con FOR ztspfli_a18-connid MEMORY ID con.
SELECTION-SCREEN END OF BLOCK bl1.

SELECTION-SCREEN BEGIN OF BLOCK bl2 WITH FRAME.
  SELECTION-SCREEN BEGIN OF LINE.
    SELECTION-SCREEN COMMENT 1(15) TEXT-t02.
    SELECTION-SCREEN POSITION 33.
    PARAMETERS pa_lv TYPE disvariant-variant.
    SELECTION-SCREEN COMMENT 53(15) TEXT-t03.
    PARAMETERS pa_edit AS CHECKBOX.
  SELECTION-SCREEN END OF LINE.
SELECTION-SCREEN END OF BLOCK bl2.



INCLUDE zbc405_a18_exam01_class.



"------------------------------------------------------------------------

AT SELECTION-SCREEN ON VALUE-REQUEST FOR pa_lv.

  gv_variant-report = sy-cprog.


  CALL FUNCTION 'LVC_VARIANT_SAVE_LOAD'
    EXPORTING
      i_save_load     = 'F'
    CHANGING
      cs_variant      = gv_variant
    EXCEPTIONS
      not_found       = 1
      wrong_input     = 2
      fc_not_complete = 3
      OTHERS          = 4.
  IF sy-subrc <> 0.
* Implement suitable error handling here
  ELSE.
    pa_lv = gv_variant-variant.
  ENDIF.
  "------------------------------------------------------------------------


START-OF-SELECTION.

  PERFORM get_data.

  CALL SCREEN 100.





*&---------------------------------------------------------------------*
*& Module STATUS_0100 OUTPUT
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
MODULE status_0100 OUTPUT.
  IF pa_edit = 'X'.
    SET PF-STATUS 'S100'.
  ELSE.
    SET PF-STATUS 'S100' EXCLUDING 'SAVE'.
  ENDIF.
  SET TITLEBAR 'T100' WITH sy-datum sy-uname.
ENDMODULE.
*&---------------------------------------------------------------------*
*&      Module  USER_COMMAND_0100  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE user_command_0100 INPUT.
  DATA : p_ans TYPE c LENGTH 1.

  CASE ok_code.
    WHEN 'SAVE' OR 'EXIT'.
      CALL FUNCTION 'POPUP_TO_CONFIRM'
        EXPORTING
          titlebar              = 'Data Save'
*         DIAGNOSE_OBJECT       = ' '
          text_question         = 'Do you want to Save?'
          text_button_1         = 'Yes'(001)
*         ICON_BUTTON_1         = ' '
          text_button_2         = 'No'(002)
          display_cancel_button = ' '
        IMPORTING
          answer                = p_ans
        EXCEPTIONS
          text_not_found        = 1
          OTHERS                = 2.
      IF sy-subrc <> 0.
* Implement suitable error handling here
      ELSE.
        IF p_ans = '1'.
          PERFORM data_save.
        ENDIF.
      ENDIF.


  ENDCASE.
ENDMODULE.
*&---------------------------------------------------------------------*
*&      Module  EXIT  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE exit INPUT.
  CALL METHOD go_alv->free.
  CALL METHOD go_container->free.
  FREE : go_alv, go_container.

  LEAVE TO SCREEN 0.
ENDMODULE.
*&---------------------------------------------------------------------*
*& Module CREATE_AND_TRANSFER OUTPUT
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
MODULE create_and_transfer OUTPUT.
  IF go_container IS INITIAL.

    CREATE OBJECT go_container
      EXPORTING
        container_name = 'MY_CONTROL_AREA'.


    CREATE OBJECT go_alv
      EXPORTING
        i_parent = go_container.

    IF sy-subrc = 0.


      PERFORM set_variant.
      PERFORM set_layout.
      PERFORM make_fieldcatalog.


      APPEND cl_gui_alv_grid=>mc_fc_loc_append_row TO gt_exct.
      APPEND cl_gui_alv_grid=>mc_fc_loc_copy_row TO gt_exct.
      APPEND cl_gui_alv_grid=>mc_fc_loc_cut TO gt_exct.
      APPEND cl_gui_alv_grid=>mc_fc_loc_copy TO gt_exct.
      APPEND cl_gui_alv_grid=>mc_fc_loc_insert_row TO gt_exct.
      APPEND cl_gui_alv_grid=>mc_fc_loc_delete_row TO gt_exct.
      APPEND cl_gui_alv_grid=>mc_fc_check TO gt_exct.
      APPEND cl_gui_alv_grid=>mc_mb_paste TO gt_exct.


      CALL METHOD go_alv->register_edit_event
        EXPORTING
          i_event_id = cl_gui_alv_grid=>mc_evt_modified.


      "트리거
      SET HANDLER lcl_handler=>on_toolbar FOR go_alv.
      SET HANDLER lcl_handler=>on_user_command FOR go_alv.
      SET HANDLER lcl_handler=>on_doubleclick FOR go_alv.
      SET HANDLER lcl_handler=>on_data_changed FOR go_alv.

      CALL METHOD go_alv->set_table_for_first_display
        EXPORTING
*         i_buffer_active               =
*         i_bypassing_buffer            =
*         i_consistency_check           =
          i_structure_name              = 'ZTSPFLI_A18'
          is_variant                    = gv_variant
          i_save                        = 'A'
          i_default                     = 'X'
          is_layout                     = gs_layout
*         is_print                      =
*         it_special_groups             =
          it_toolbar_excluding          = gt_exct
*         it_hyperlink                  =
*         it_alv_graphics               =
*         it_except_qinfo               =
*         ir_salv_adapter               =
        CHANGING
          it_outtab                     = gt_spfli
          it_fieldcatalog               = gt_fcat
*         it_sort                       =
*         it_filter                     =
        EXCEPTIONS
          invalid_parameter_combination = 1
          program_error                 = 2
          too_many_lines                = 3
          OTHERS                        = 4.
      IF sy-subrc <> 0.
*   Implement suitable error handling here
      ENDIF.
    ENDIF.

  ELSE.

    "refresh alv method가 올 자리
    gv_soft_refresh = 'X'.
    gs_stable-row = 'X'.
    gs_stable-col = 'X'.
    CALL METHOD go_alv->refresh_table_display
      EXPORTING
        is_stable      = gs_stable
        i_soft_refresh = gv_soft_refresh
      EXCEPTIONS
        finished       = 1
        OTHERS         = 2.
    IF sy-subrc <> 0.
*     Implement suitable error handling here
    ENDIF.
*    CALL METHOD cl_gui_cfw=>flush.

  ENDIF.
ENDMODULE.
*&---------------------------------------------------------------------*
*& Form get_data
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM get_data .

  DATA gt_temp TYPE TABLE OF typ_flt.


  SELECT *
    FROM ztspfli_a18
    INTO CORRESPONDING FIELDS OF TABLE gt_spfli
    WHERE carrid IN so_car
      AND connid IN so_con.



  LOOP AT gt_spfli INTO gs_spfli.


    SELECT SINGLE time_zone
    FROM sairport
    INTO gs_spfli-ftzone
    WHERE id = gs_spfli-airpfrom.

    SELECT SINGLE time_zone
    FROM sairport
    INTO gs_spfli-ttzone
    WHERE id = gs_spfli-airpto.




    "I&D
    IF gs_spfli-countryfr = ''.
      gs_spfli-indo = ''.
    ELSEIF gs_spfli-countryfr = gs_spfli-countryto.
      gs_spfli-indo = 'D'.
    ELSE.
      gs_spfli-indo = 'I'.
    ENDIF.

    IF gs_spfli-indo = 'I'.
      gs_color-fname = 'INDO'.
      gs_color-color-col = col_positive.
      gs_color-color-int = '1'.
      gs_color-color-inv = '0'.
      APPEND gs_color TO gs_spfli-it_color.
    ELSEIF gs_spfli-indo = 'D'.
      gs_color-fname = 'INDO'.
      gs_color-color-col = col_total.
      gs_color-color-int = '1'.
      gs_color-color-inv = '0'.
      APPEND gs_color TO gs_spfli-it_color.
    ENDIF.


    "신호등
    IF gs_spfli-period > 1.
      gs_spfli-light = 1.
    ELSEIF gs_spfli-period = 1.
      gs_spfli-light = 2.
    ELSE.
      gs_spfli-light = 3.
    ENDIF.


    "비행기 아이콘
    IF gs_spfli-fltype = 'X'.
      gs_spfli-flicon = icon_ws_plane.
    ENDIF.




    MODIFY gt_spfli FROM gs_spfli.
  ENDLOOP.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form set_variant
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM set_variant .
  gv_variant-variant = pa_lv.
  gv_variant-report = sy-cprog.
ENDFORM.
*&---------------------------------------------------------------------*
*& Form make_fieldcatalog
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM make_fieldcatalog .

*  CLEAR gs_fcat.                       "chg가 다른 데이터 변경시 'X'로 바뀌는지 확인 용도
*  gs_fcat-fieldname = 'CHG'.
*  gs_fcat-coltext = 'CHG'.
*  gs_fcat-col_pos   = '1'.
*  APPEND gs_fcat TO gt_fcat.




  CLEAR gs_fcat.
  gs_fcat-fieldname = 'INDO'.
  gs_fcat-coltext = 'I&D'.
  gs_fcat-col_pos   = '5'.
  APPEND gs_fcat TO gt_fcat.

  CLEAR gs_fcat.
  gs_fcat-fieldname = 'FLTYPE'.
  gs_fcat-no_out = 'X'.
  APPEND gs_fcat TO gt_fcat.

  CLEAR gs_fcat.
  gs_fcat-fieldname = 'FTZONE'.
  gs_fcat-coltext = 'From TZONE'.
  gs_fcat-col_pos   = '18'.
  APPEND gs_fcat TO gt_fcat.

  CLEAR gs_fcat.
  gs_fcat-fieldname = 'TTZONE'.
  gs_fcat-coltext = 'To TZONE'.
  gs_fcat-col_pos   = '19'.
  APPEND gs_fcat TO gt_fcat.
  CLEAR gs_fcat.
  gs_fcat-fieldname = 'FLICON'.
  gs_fcat-coltext = 'FLIGHT'.
*  gs_fcat-icon = 'ICON_WS_PLANE'.
  gs_fcat-col_pos   = '9'.
  APPEND gs_fcat TO gt_fcat.

  CLEAR gs_fcat.
  gs_fcat-fieldname = 'FLTIME'.
  gs_fcat-edit = pa_edit.
  APPEND gs_fcat TO gt_fcat.

  CLEAR gs_fcat.
  gs_fcat-fieldname = 'DEPTIME'.
  gs_fcat-edit = pa_edit.
  APPEND gs_fcat TO gt_fcat.

  CLEAR gs_fcat.
  gs_fcat-fieldname = 'ARRTIME'.
  gs_fcat-emphasize = 'C710'.
  APPEND gs_fcat TO gt_fcat.

  CLEAR gs_fcat.
  gs_fcat-fieldname = 'PERIOD'.
  gs_fcat-emphasize = 'C710'.
  APPEND gs_fcat TO gt_fcat.
ENDFORM.
*&---------------------------------------------------------------------*
*& Form set_layout
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM set_layout .
  gs_layout-zebra      = 'X'.
  gs_layout-sel_mode = 'D'.

  gs_layout-excp_fname = 'LIGHT'.
  gs_layout-excp_led = 'X'.

  gs_layout-info_fname = 'ROW_COLOR'.
  gs_layout-ctab_fname = 'IT_COLOR'.

  gs_layout-stylefname = 'IT_STYL'.
ENDFORM.
*&---------------------------------------------------------------------*
*& Form time_change
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*&      --> ER_DATA_CHANGED
*&      --> LS_MOD_CELLS
*&---------------------------------------------------------------------*
FORM time_change  USING    per_data_changed
                  TYPE REF TO cl_alv_changed_data_protocol
                                 ps_mod_cells TYPE lvc_s_modi.

  DATA: l_fltime  TYPE ztspfli_a18-fltime,
        l_deptime TYPE ztspfli_a18-deptime,
        l_arrtime TYPE spfli-arrtime,
        l_period  TYPE n.

  READ TABLE gt_spfli INTO gs_spfli  INDEX ps_mod_cells-row_id.

  CALL METHOD per_data_changed->get_cell_value
    EXPORTING
      i_row_id    = ps_mod_cells-row_id
*     i_tabix     =
      i_fieldname = 'FLTIME'
    IMPORTING
      e_value     = l_fltime.

  CHECK sy-subrc EQ 0.


  CALL METHOD per_data_changed->get_cell_value
    EXPORTING
      i_row_id    = ps_mod_cells-row_id
*     i_tabix     =
      i_fieldname = 'DEPTIME'
    IMPORTING
      e_value     = l_deptime.


  CHECK sy-subrc EQ 0.


  CALL FUNCTION 'ZBC405_CALC_ARRTIME'
    EXPORTING
      iv_fltime       = l_fltime
      iv_deptime      = l_deptime
      iv_utc          = gs_spfli-ftzone
      iv_utc1         = gs_spfli-ttzone
    IMPORTING
      ev_arrival_time = l_arrtime
      ev_period       = l_period.


  CALL METHOD per_data_changed->modify_cell
    EXPORTING
      i_row_id    = ps_mod_cells-row_id
      i_fieldname = 'ARRTIME'
      i_value     = l_arrtime.


  CALL METHOD per_data_changed->modify_cell
    EXPORTING
      i_row_id    = ps_mod_cells-row_id
      i_fieldname = 'PERIOD'
      i_value     = l_period.


  gs_spfli-period = l_period.
  gs_spfli-arrtime = l_arrtime.

  IF gs_spfli-period >= 2.
    gs_spfli-light = '1'.
  ELSEIF gs_spfli-period = 1.
    gs_spfli-light = '2'.
  ELSE.
    gs_spfli-light = '3'.
  ENDIF.

  CALL METHOD per_data_changed->modify_cell
    EXPORTING
      i_row_id    = ps_mod_cells-row_id
      i_fieldname = 'LIGHT'
      i_value     = gs_spfli-light.

  gs_spfli-chg = 'X'.

  CALL METHOD per_data_changed->modify_cell
    EXPORTING
      i_row_id    = ps_mod_cells-row_id
      i_fieldname = 'CHG'
      i_value     = gs_spfli-chg.


  MODIFY gt_spfli FROM gs_spfli INDEX ps_mod_cells-row_id.







ENDFORM.
*&---------------------------------------------------------------------*
*& Form data_save
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM data_save .
  LOOP AT gt_spfli INTO gs_spfli WHERE chg = 'X'.

    UPDATE ztspfli_a18 SET fltime = gs_spfli-fltime
                           deptime = gs_spfli-deptime
                           arrtime = gs_spfli-arrtime
                           period = gs_spfli-period
                       WHERE carrid = gs_spfli-carrid
                         AND connid = gs_spfli-connid.
  ENDLOOP.

ENDFORM.
