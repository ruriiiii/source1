*&---------------------------------------------------------------------*
*& Report ZRSAMEN02_18
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zrsamen02_18.


TYPES: BEGIN OF typ_flt.
         INCLUDE TYPE sflight.
TYPES:   carrname TYPE s_carrname.
TYPES: END OF typ_flt.

DATA ok_code TYPE sy-ucomm.
DATA gt_flt TYPE TABLE OF typ_flt.
DATA gs_flt TYPE typ_flt.
DATA gt_flt2 TYPE TABLE OF typ_flt.
DATA gs_flt2 TYPE typ_flt.




"ALV Data 선언
DATA: go_container  TYPE REF TO cl_gui_custom_container,
      go_alv_grid   TYPE REF TO cl_gui_alv_grid,
      go_container2 TYPE REF TO cl_gui_custom_container,
      go_alv_grid2  TYPE REF TO cl_gui_alv_grid,
      gs_layout     TYPE lvc_s_layo,
      gs_layout2    TYPE lvc_s_layo,
      gt_exct       TYPE ui_functions,
      gt_fcat       TYPE lvc_t_fcat,
      gs_fcat       TYPE lvc_s_fcat.


DATA : gs_stable       TYPE lvc_s_stbl,
       gv_soft_refresh TYPE abap_bool.





TABLES zssa1840.
DATA gs_flight TYPE zssa1840.

INCLUDE zrsamen02_18_class.



"Selection Screen
SELECT-OPTIONS : so_car FOR gs_flight-carrid NO-EXTENSION,
                 so_con FOR gs_flight-connid NO-EXTENSION,
                 so_dat FOR gs_flight-fldate NO-EXTENSION.





START-OF-SELECTION.
  PERFORM get_data.
  CALL SCREEN 100.
















*&---------------------------------------------------------------------*
*& Module STATUS_0100 OUTPUT
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
MODULE status_0100 OUTPUT.
  SET PF-STATUS 'S100'.
  SET TITLEBAR 'T100'.
ENDMODULE.
*&---------------------------------------------------------------------*
*&      Module  USER_COMMAND_0100  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE user_command_0100 INPUT.
  CASE ok_code.
    WHEN 'BACK' OR 'EXIT' OR 'CANC'.
      CALL METHOD go_alv_grid->free.
      CALL METHOD go_container->free.

      FREE : go_alv_grid, go_container.
      LEAVE TO SCREEN 0.

    WHEN 'PUSH'.      "복수 가져오기가 안됨
*

      DATA: lt_rows   TYPE lvc_t_roid,
            ls_rows   TYPE lvc_s_roid,
            lt_row_id TYPE lvc_t_row,
            ls_row_id TYPE lvc_s_row.



      CALL METHOD go_alv_grid->get_selected_rows
        IMPORTING
          et_index_rows = lt_row_id.
*            et_row_no = lt_rows.



      LOOP AT lt_row_id INTO ls_row_id.
        READ TABLE gt_flt INTO gs_flt INDEX ls_row_id-index.
        APPEND gs_flt to gt_flt2.
      ENDLOOP.


      CALL METHOD go_alv_grid2->refresh_table_display.

  ENDCASE.
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
        container_name = 'CONTROL_AREA'
      EXCEPTIONS
        OTHERS         = 6.
    IF sy-subrc <> 0.
      MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
                 WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
    ENDIF.


    CREATE OBJECT go_alv_grid
      EXPORTING
        i_parent = go_container
      EXCEPTIONS
        OTHERS   = 5.
    IF sy-subrc <> 0.
      MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
                 WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
    ENDIF.

    PERFORM make_layout.
    PERFORM make_fieldcatalog.




    SET HANDLER lcl_handler=>on_toolbar FOR go_alv_grid.
    SET HANDLER lcl_handler=>on_doubleclick FOR go_alv_grid.
    SET HANDLER lcl_handler=>on_user_command FOR go_alv_grid.
    SET HANDLER lcl_handler=>on_context_menu_request FOR go_alv_grid.



    CALL METHOD go_alv_grid->set_table_for_first_display
      EXPORTING
*       i_buffer_active               =
*       i_bypassing_buffer            =
*       i_consistency_check           =
        i_structure_name              = 'SFLIGHT'
*       is_variant                    = gv_variant
*       i_save                        = gv_save
*       i_default                     = 'X'
        is_layout                     = gs_layout
*       is_print                      =
*       it_special_groups             =
*       it_toolbar_excluding          =
*       it_hyperlink                  =
*       it_alv_graphics               =
*       it_except_qinfo               =
*       ir_salv_adapter               =
      CHANGING
        it_outtab                     = gt_flt
        it_fieldcatalog               = gt_fcat
*       it_sort                       =
*       it_filter                     =
      EXCEPTIONS
        invalid_parameter_combination = 1
        program_error                 = 2
        too_many_lines                = 3
        OTHERS                        = 4.
    IF sy-subrc <> 0.
* Implement suitable error handling here
    ENDIF.






  ELSE.
  ENDIF.



  IF go_container2 IS INITIAL.
    CREATE OBJECT go_container2
      EXPORTING
        container_name = 'CONTROL_AREA2'
      EXCEPTIONS
        OTHERS         = 6.
    IF sy-subrc <> 0.
      MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
                 WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
    ENDIF.



    CREATE OBJECT go_alv_grid2
      EXPORTING
        i_parent = go_container2
      EXCEPTIONS
        OTHERS   = 5.
    IF sy-subrc <> 0.
      MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
                 WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
    ENDIF.

    PERFORM make_layout2.

    APPEND cl_gui_alv_grid=>mc_fc_excl_all TO gt_exct.

    CALL METHOD go_alv_grid2->set_table_for_first_display
      EXPORTING
*       i_buffer_active               =
*       i_bypassing_buffer            =
*       i_consistency_check           =
        i_structure_name              = 'SFLIGHT'
*       is_variant                    = gv_variant
*       i_save                        = gv_save
*       i_default                     = 'X'
        is_layout                     = gs_layout2
*       is_print                      =
*       it_special_groups             =
        it_toolbar_excluding          = gt_exct
*       it_hyperlink                  =
*       it_alv_graphics               =
*       it_except_qinfo               =
*       ir_salv_adapter               =
      CHANGING
        it_outtab                     = gt_flt2
*       it_fieldcatalog               =
*       it_sort                       =
*       it_filter                     =
      EXCEPTIONS
        invalid_parameter_combination = 1
        program_error                 = 2
        too_many_lines                = 3
        OTHERS                        = 4.
    IF sy-subrc <> 0.
* Implement suitable error handling here
    ENDIF.





  ELSE.


  ENDIF.






ENDMODULE.
*&---------------------------------------------------------------------*
*& Form make_variant
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM make_variant .

ENDFORM.
*&---------------------------------------------------------------------*
*& Form get_data
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM get_data .
  SELECT *
    FROM sflight
    INTO CORRESPONDING FIELDS OF TABLE gt_flt
    WHERE carrid IN so_car
      AND connid IN so_con
      AND fldate IN so_dat.


ENDFORM.
*&---------------------------------------------------------------------*
*& Form make_layout
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM make_layout .
  gs_layout-zebra = 'X'.
  gs_layout-sel_mode = 'A'.
  gs_layout-cwidth_opt = 'X'.
ENDFORM.
*&---------------------------------------------------------------------*
*& Form make_layout2
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM make_layout2 .
  gs_layout-sel_mode = 'A'.
  gs_layout-cwidth_opt = 'X'.
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
  CLEAR gs_fcat.        "필드 추가
  gs_fcat-fieldname = 'CARRNAME'.
  gs_fcat-coltext = 'carrname'.
  gs_fcat-col_pos = 3.
  APPEND gs_fcat TO gt_fcat.
ENDFORM.
