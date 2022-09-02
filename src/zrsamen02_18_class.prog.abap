*&---------------------------------------------------------------------*
*& Include          ZRSAMEN02_18_CLASS
*&---------------------------------------------------------------------*
CLASS lcl_handler DEFINITION.
  PUBLIC SECTION.
    CLASS-METHODS: on_toolbar FOR EVENT toolbar
      OF cl_gui_alv_grid
      IMPORTING e_object,
      on_doubleclick FOR EVENT double_click
        OF cl_gui_alv_grid
        IMPORTING e_row e_column es_row_no,
      on_user_command FOR EVENT user_command
        OF cl_gui_alv_grid
        IMPORTING e_ucomm,
      on_context_menu_request FOR EVENT context_menu_request
        OF cl_gui_alv_grid
        IMPORTING e_object.

ENDCLASS.



CLASS lcl_handler IMPLEMENTATION.
  METHOD on_toolbar.
    DATA ls_button TYPE stb_button.
    ls_button-function = 'SELECT ALL'.
    ls_button-butn_type = '0'.
    ls_button-text = 'SELECT ALL'.
    INSERT ls_button INTO TABLE e_object->mt_toolbar.
*   = APPEND ls_button to e_object->mt_toolbar.

    CLEAR ls_button.
    ls_button-function = 'DESELECT ALL'.
    ls_button-butn_type = '0'.
    ls_button-text = 'DESELECT ALL'.
    INSERT ls_button INTO TABLE e_object->mt_toolbar.
*     = APPEND ls_button to e_object->mt_toolbar.

  ENDMETHOD.

  METHOD on_doubleclick.

    READ TABLE gt_flt INTO gs_flt INDEX es_row_no-row_id.
    gs_flt2 = gs_flt.
    APPEND gs_flt2 TO gt_flt2.

    CALL METHOD go_alv_grid2->refresh_table_display.

  ENDMETHOD.

  METHOD on_user_command.
    DATA : ls_col_id TYPE lvc_s_col,
           ls_row_id TYPE lvc_s_row,
           lt_rows   TYPE lvc_t_row.

    CASE e_ucomm.
      WHEN 'SELECT ALL'.
        MESSAGE i000(zt03_msg) WITH 'test'.


      WHEN 'DESELECT ALL'.

        CALL METHOD go_alv_grid->set_selected_rows
          EXPORTING
            it_index_rows = lt_rows.


      WHEN 'MOVE'.   "Context Menu
        CALL METHOD go_alv_grid->get_current_cell
          IMPORTING
*           e_row     =
*           e_value   =
*           e_col     =
            es_row_id = ls_row_id
            es_col_id = ls_col_id.

        READ TABLE gt_flt INTO gs_flt INDEX ls_row_id-index.
        gs_flt2 = gs_flt.
        APPEND gs_flt2 TO gt_flt2.

        CALL METHOD go_alv_grid2->refresh_table_display.


    ENDCASE.
  ENDMETHOD.

  METHOD on_context_menu_request.
    CALL METHOD cl_ctmenu=>load_gui_status
      EXPORTING
        program    = sy-cprog
        status     = 'CT_MENU'
        menu       = e_object
      EXCEPTIONS
        read_error = 1
        OTHERS     = 2.
    IF sy-subrc <> 0.
* Implement suitable error handling here
    ENDIF.


    .
  ENDMETHOD.




ENDCLASS.
