*&---------------------------------------------------------------------*
*& Report ZBC405_OM_A18
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zbc405_om_a18.
TABLES spfli.

SELECT-OPTIONS : so_car FOR spfli-carrid MEMORY ID car,
                 so_con FOR spfli-connid MEMORY ID con.

DATA: gt_spfli TYPE TABLE OF spfli,
      gs_spfli TYPE spfli.

DATA: go_alv     TYPE REF TO cl_salv_table,
      go_func    TYPE REF TO cl_salv_functions_list,
      go_disp    TYPE REF TO cl_salv_display_settings,
      go_columns TYPE REF TO cl_salv_columns_table,
      go_column  TYPE REF TO cl_salv_column_table,
      go_cols    TYPE REF TO cl_salv_column,
      go_layout  TYPE REF TO cl_salv_layout,
      go_selc type ref to cl_salv_selections.

START-OF-SELECTION.
  SELECT *
    FROM spfli
    INTO TABLE gt_spfli
    WHERE carrid IN so_car
      AND connid IN so_con.

  TRY.
      CALL METHOD cl_salv_table=>factory
        EXPORTING
          list_display = ' '  "IF_SALV_C_BOOL_SAP=>FALSE     "'X'값을 주면 리스트형식으로 보여줌. ' ' 공백을 주면 그리드 형식.
*         r_container  =
*         container_name =
        IMPORTING
          r_salv_table = go_alv
        CHANGING
          t_table      = gt_spfli.     "출력할 인터널 테이블
    CATCH cx_salv_msg.
  ENDTRY.                           "Try, endtry, carch 는 의도치않은 오류 방지를 위해 사용해주는게 좋음.


  CALL METHOD go_alv->get_functions
    RECEIVING
      value = go_func.

*  CALL METHOD go_func->set_sort_asc .
*
*  CALL METHOD go_func->set_sort_desc .


  CALL METHOD go_func->set_all . "버튼 다 가져오기



  "Display

  CALL METHOD go_alv->get_display_settings
    RECEIVING
      value = go_disp.

  "Salv Title
  CALL METHOD go_disp->set_list_header
    EXPORTING
      value = 'SALV DEMO!'.

  "zebra pattern
  CALL METHOD go_disp->set_striped_pattern
    EXPORTING
      value = 'X'.

  CALL METHOD go_alv->get_columns
    RECEIVING
      value = go_columns.

  " col opt 기능
  CALL METHOD go_columns->set_optimize
*    EXPORTING
*      value  = IF_SALV_C_BOOL_SAP~TRUE
    .

  TRY.
      CALL METHOD go_columns->get_column
        EXPORTING
          columnname = 'MANDT'
        RECEIVING
          value      = go_cols.
    CATCH cx_salv_not_found.
  ENDTRY.


  go_column ?= go_cols.   "Casting type이 달라도 구문오류 없이 인정해주라


  "fcat-tech 기능
  CALL METHOD go_column->set_technical.


  TRY.
      CALL METHOD go_columns->get_column
        EXPORTING
          columnname = 'FLTIME'
        RECEIVING
          value      = go_cols.
    CATCH cx_salv_not_found.
  ENDTRY.

  go_column ?= go_cols.
  DATA g_color TYPE lvc_s_colo.

  g_color-col = '5'.
  g_color-int = '1'.
  g_color-inv ='0'.

  CALL METHOD go_column->set_color
    EXPORTING
      value = g_color.

  CALL METHOD go_alv->get_layout
    RECEIVING
      value = go_layout.



  DATA g_program TYPE salv_s_layout_key.

  g_program-report = sy-cprog.

  CALL METHOD go_layout->set_key
    EXPORTING
      value = g_program.



  CALL METHOD go_layout->set_save_restriction
    EXPORTING
      value = if_salv_c_layout=>restrict_none.

CALL METHOD  go_layout->set_default
  EXPORTING
    value = 'X'.


"Selection mode
call METHOD go_alv->get_selections
 receiving
 value = go_selc.

CALL METHOD go_selc->set_selection_mode
  EXPORTING
    value  = IF_SALV_C_SELECTION_MODE=>ROW_COLUMN.

CALL METHOD go_selc->set_selection_mode
  EXPORTING
    value  = IF_SALV_C_SELECTION_MODE=>cell.



  CALL METHOD go_alv->display.
