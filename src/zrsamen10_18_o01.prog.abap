*&---------------------------------------------------------------------*
*& Include          ZRSAMEN10_18_O01
*&---------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*& Module STATUS_0100 OUTPUT
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
MODULE status_0100 OUTPUT.
  SET PF-STATUS 'S100'.
  SET TITLEBAR 'T100' WITH sy-datum sy-uname.
ENDMODULE.
*&---------------------------------------------------------------------*
*& Module CREATE_ALV_OBJECT OUTPUT
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
MODULE create_alv_object OUTPUT.
  IF go_con IS INITIAL.

    CREATE OBJECT go_con
      EXPORTING
        container_name = 'MY_CON'.

    IF sy-subrc = 0.

      CREATE OBJECT go_alv
        EXPORTING
          i_parent = go_con.
      IF sy-subrc = 0.
*


        PERFORM make_fieldcatalog.
        PERFORM make_layout.

        CALL METHOD go_alv->register_edit_event
          EXPORTING
            i_event_id = cl_gui_alv_grid=>mc_evt_modified.



        SET HANDLER lcl_handler=>on_toolbar FOR go_alv.



        CALL METHOD go_alv->set_table_for_first_display
          EXPORTING
*           i_buffer_active  =
*           i_bypassing_buffer            =
*           i_consistency_check           =
            i_structure_name = 'ZVRMAT18'
*           is_variant       =
*           i_save           =
*           i_default        = 'X'
           is_layout        = gs_layout
*           is_print         =
*           it_special_groups             =
           it_toolbar_excluding = gt_exct
*           it_hyperlink     =
*           it_alv_graphics  =
*           it_except_qinfo  =
*           ir_salv_adapter  =
          CHANGING
            it_outtab        = gt_manage
           it_fieldcatalog  = gt_fcat
*           it_sort          =
*           it_filter        =
*          EXCEPTIONS
*           invalid_parameter_combination = 1
*           program_error    = 2
*           too_many_lines   = 3
*           others           = 4
          .
        IF sy-subrc <> 0.
*         Implement suitable error handling here
        ENDIF.

      ENDIF.



    ENDIF.



  ELSE.
    DATA :
      gs_stable       TYPE          lvc_s_stbl,
      gv_soft_refresh TYPE          abap_bool.
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
