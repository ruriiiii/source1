*&---------------------------------------------------------------------*
*& Include          ZC1R180004_F01
*&---------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*& Form display_screen
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM display_screen .
  IF gcl_container IS INITIAL.
    CREATE OBJECT gcl_container
      EXPORTING
        repid     = sy-repid
        dynnr     = sy-dynnr
        side      = gcl_container->dock_at_left  "=cl_gui_docking_container=>dock_at_left
        extension = 3000.

    CREATE OBJECT gcl_grid
      EXPORTING
        i_parent = gcl_container.


    IF gcl_handler IS NOT BOUND.
      CREATE OBJECT gcl_handler.
    ENDIF.

    SET HANDLER : gcl_handler->handle_double_click FOR gcl_grid,
                  gcl_handler->handle_hotspot      FOR gcl_grid.




    CALL METHOD gcl_grid->set_table_for_first_display
      EXPORTING
*       i_buffer_active =
*       i_bypassing_buffer            =
*       i_consistency_check           =
*       i_structure_name              =
        is_variant      = gs_variant
        i_save          = 'A'
        i_default       = 'X'
        is_layout       = gs_layout
*       is_print        =
*       it_special_groups             =
*       it_toolbar_excluding          =
*       it_hyperlink    =
*       it_alv_graphics =
*       it_except_qinfo =
*       ir_salv_adapter =
      CHANGING
        it_outtab       = gt_data
        it_fieldcatalog = gt_fcat
*       it_sort         =
*       it_filter       =
      .


  ENDIF.
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


  CLEAR gs_data.
  _clear gt_data.



  SELECT a~matnr a~stlan a~stlnr a~stlal
         b~mtart b~matkl
         c~maktx
    INTO CORRESPONDING FIELDS OF TABLE gt_data
    FROM mast AS a INNER JOIN mara AS b ON a~matnr = b~matnr
    LEFT OUTER JOIN makt AS c
    ON a~matnr = c~matnr
    AND c~spras = sy-langu
   WHERE a~werks = werks
     AND a~matnr IN matnr.


  IF sy-subrc NE 0.
    MESSAGE s001.
    STOP.
  ENDIF.



*
*
*  LOOP AT gt_data INTO gs_data.
*    lv_tabix = sy-tabix.
*
*    READ TABLE gt_mara INTO gs_mara WITH KEY matnr = gs_data-matnr.
*
*    gs_data-mtart = gs_mara-mtart.
*    gs_data-matkl = gs_mara-matkl.
*
*    MODIFY gt_data FROM gs_data INDEX lv_tabix TRANSPORTING mtart matkl.
*    CLEAR gs_data.
*  ENDLOOP.







ENDFORM.
*&---------------------------------------------------------------------*
*& Form set_fcat_layout
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM set_fcat_layout .

  gs_layout-zebra      = 'X'.
  gs_layout-sel_mode   = 'D'.
  gs_layout-cwidth_opt = 'X'.

  IF gt_fcat IS INITIAL.
    PERFORM set_fcat USING :
    'X'   'MATNR'   ' '   'MAST'    'MATNR',
    ' '   'MAKTX'   ' '   'MAKT'    'MAKTX',
    ' '   'STLAN'   ' '   'MAST'    'STLAN',
    ' '   'STLNR'   ' '   'MAST'    'STLNR',
    ' '   'STLAL'   ' '   'MAST'    'STLAL',
    ' '   'MTART'   ' '   'MARA'    'MTART',
    ' '   'MATKL'   ' '   'MARA'    'MATKL'.
  ENDIF.
ENDFORM.
*&---------------------------------------------------------------------*
*& Form set_fcat
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*&      --> P_
*&      --> P_
*&---------------------------------------------------------------------*
FORM set_fcat  USING pv_key pv_field pv_text pv_ref_table pv_ref_field.

  gs_fcat = VALUE #(
                      key       = pv_key
                       fieldname = pv_field
                       coltext   = pv_text
                       ref_table = pv_ref_table
                       ref_field = pv_ref_field
                      ).

  CASE pv_field.
    WHEN 'STLNR'.
      gs_fcat-hotspot = 'X'.

  ENDCASE.

*  gs_fcat-key       = pv_key.
*  gs_fcat-fieldname = pv_field.
*  gs_fcat-coltext   = pv_text.
*  gs_fcat-ref_table = pv_ref_table.
*  gs_fcat-ref_field = pv_ref_field.
*
  APPEND gs_fcat TO gt_fcat.
*  CLEAR  gs_fcat.
ENDFORM.
*&---------------------------------------------------------------------*
*& Form handle_double_click
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*&      --> E_ROW
*&      --> E_COLUMN
*&---------------------------------------------------------------------*
FORM handle_double_click  USING  ps_row TYPE lvc_s_row
                                 ps_column TYPE lvc_s_col.

  READ TABLE gt_data INTO gs_data INDEX ps_row-index.

  IF sy-subrc NE 0.
    EXIT.
  ENDIF.

  CASE ps_column-fieldname.
    WHEN 'MATNR'.
      IF gs_data-matnr IS INITIAL.
        EXIT.
      ENDIF.

      SET PARAMETER ID 'MAT' FIELD gs_data-matnr.

      CALL TRANSACTION 'MM03' AND SKIP FIRST SCREEN.
  ENDCASE.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form handle_hotspot
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*&      --> E_ROW_ID
*&      --> E_COLUMN_ID
*&---------------------------------------------------------------------*
FORM handle_hotspot USING ps_row_id    TYPE lvc_s_row
                           ps_column_id TYPE lvc_s_col.

  READ TABLE gt_data INTO gs_data INDEX ps_row_id-index.

  IF sy-subrc NE 0.
    EXIT.
  ENDIF.

  CASE ps_column_id-fieldname.
    WHEN 'STLNR'.
      IF gs_data-stlnr IS INITIAL.
        EXIT.
      ENDIF.

      SET PARAMETER ID : 'MAT' FIELD gs_data-matnr,
                         'WRK' FIELD werks,
                         'CSV' FIELD gs_data-stlan.

      CALL TRANSACTION 'CS03' AND SKIP FIRST SCREEN.

  ENDCASE.
ENDFORM.
