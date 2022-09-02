*&---------------------------------------------------------------------*
*& Include          ZC1R180006_F01
*&---------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*& Form INIT_PARAM
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM init_param .

  pa_bukrs = '1010'.
  pa_gjahr = sy-datum(4) - 1.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form GET_BELNR
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM get_belnr .
  _clear gs_data gt_data.

  SELECT a~blart a~budat a~waers
         b~belnr b~buzei b~shkzg b~dmbtr b~hkont
  INTO CORRESPONDING FIELDS OF TABLE gt_data
    FROM bkpf AS a INNER JOIN bseg AS b
    ON a~belnr = b~belnr
    AND a~bukrs = b~bukrs
    AND a~gjahr = b~gjahr
    WHERE a~bukrs = pa_bukrs
    AND a~gjahr = pa_gjahr
    AND a~belnr IN so_belnr
    AND a~blart IN so_blart.


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

  gs_layout-zebra = 'X'.
  gs_layout-sel_mode = 'D'.
  gs_layout-cwidth_opt = 'X'.


  IF gt_fcat IS INITIAL.
    PERFORM set_fcat USING :
          'X' 'BELNR'  ' '  'BSEG' 'BELNR',
          'X' 'BUZEI'  ' '  'BSEG' 'BUZEI',
          ' ' 'BLART'  ' '  'BKPF' 'BLART',
          ' ' 'BUDAT'  ' '  'BKPF' 'BUDAT',
          ' ' 'SHKZG'  ' '  'BSEG' 'SHKZG',
          ' ' 'DMBTR'  ' '  'BSEG' 'DMBTR',
          ' ' 'WAERS'  ' '  'BKPF' 'WAERS',
          ' ' 'HKONT'  ' '  'BSEG' 'HKONT'.
  ENDIF.





ENDFORM.
*&---------------------------------------------------------------------*
*& Form set_fcat
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*&      --> P_
*&      --> P_
*&      --> P_
*&      --> P_
*&      --> P_
*&---------------------------------------------------------------------*
FORM set_fcat USING  pv_key pv_field pv_text pv_ref_table pv_ref_field .

  gs_fcat = VALUE #( key = pv_key
                     fieldname = pv_field
                     coltext = pv_text
                     ref_table = pv_ref_table
                     ref_field = pv_ref_field ).

  CASE pv_field.
    WHEN 'DMBTR'.
      gs_fcat-fieldname =  'WAERS'.

    WHEN 'BELNR'.
      gs_fcat-hotspot = 'X'.

  ENDCASE.


  APPEND gs_fcat TO gt_fcat.

ENDFORM.
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
        side      = gcl_container->dock_at_left
        extension = 3000.

    CREATE OBJECT gcl_grid
      EXPORTING
        i_parent = gcl_container.

    gs_variant-report = sy-repid.

    IF GCL_HANDLER IS NOT BOUND.
      CREATE OBJECT GCL_HANDLER.
    ENDIF.

    SET HANDLER : GCL_HANDLER->HANDLE_HOTSPOT FOR GCL_GRID.


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
        it_fieldcatalog = gt_fcat.

  ENDIF.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form handle_hotspot
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*&      --> E_ROW_ID
*&      --> E_COLUMN_ID
*&---------------------------------------------------------------------*
FORM handle_hotspot  USING  ps_row_id TYPE lvc_s_row
                            ps_column_id TYPE lvc_s_col.

  READ TABLE GT_DATA INTO GS_dATA INDEX pS_row_id-INDEX.

  IF SY-SUBRC NE 0.
    EXIT.
  ENDIF.

  CASE pS_column_id-fieldname.
    WHEN 'BELNR'.
      IF GS_DATA-BELNR IS INITIAL.
        EXIT.
      ENDIF.

      SET PARAMETER ID : 'BLN' FIELD GS_DATA-BELNR,
                         'BUK' FIELD PA_bukrs,
                         'GJR' FIELD PA_gjahr.

      CALL TRANSACTION 'FB03' AND SKIP FIRST SCREEN.
   ENDCASE.




ENDFORM.
