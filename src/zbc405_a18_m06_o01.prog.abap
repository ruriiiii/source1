*&---------------------------------------------------------------------*
*& Include          ZBC405_A18_M06_O01
*&---------------------------------------------------------------------*
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
*& Module CREATE_ALV_0100 OUTPUT
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
MODULE create_alv_0100 OUTPUT.

  CREATE OBJECT go_con
    EXPORTING
      container_name = 'MY_CON'.

  CREATE OBJECT go_alv
    EXPORTING
      i_parent = go_con.

  "Set layout
  gs_layout-zebra = 'X'.
  gs_layout-excp_fname = 'LIGHT'.
  gs_layout-info_fname = 'ROWCOL'.

  "Make fieldcatalog
  CLEAR gs_fcat.
  gs_fcat-fieldname = 'ROWCOL'.
  gs_fcat-col_pos = 2.
  gs_fcat-col_opt = 'X'.
  APPEND gs_fcat TO gt_fcat.






  CALL METHOD go_alv->set_table_for_first_display
    EXPORTING
*     i_buffer_active  =
*     i_bypassing_buffer            =
*     i_consistency_check           =
      i_structure_name = 'ZTSBOOK_A18'
*     is_variant       =
*     i_save           =
*     i_default        = 'X'
      is_layout        = gs_layout
*     is_print         =
*     it_special_groups             =
*     it_toolbar_excluding          =
*     it_hyperlink     =
*     it_alv_graphics  =
*     it_except_qinfo  =
*     ir_salv_adapter  =
    CHANGING
      it_outtab        = gt_sbook
      it_fieldcatalog  = gt_fcat
*     it_sort          =
*     it_filter        =
*  EXCEPTIONS
*     invalid_parameter_combination = 1
*     program_error    = 2
*     too_many_lines   = 3
*     others           = 4
    .
  IF sy-subrc <> 0.
* Implement suitable error handling here
  ENDIF.






ENDMODULE.
