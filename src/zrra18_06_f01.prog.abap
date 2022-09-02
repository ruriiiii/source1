*&---------------------------------------------------------------------*
*& Include          ZRRA18_06_F01
*&---------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*& Form GET_DATA
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM get_data .

  SELECT a~belnr a~buzei a~shkzg a~dmbtr a~hkont
         b~blart b~budat b~waers
    INTO CORRESPONDING FIELDS OF TABLE gt_data
    FROM bseg AS a INNER JOIN bkpf AS b ON a~belnr = b~belnr
    WHERE b~bukrs = pa_bukrs
      AND b~gjahr = pa_gjahr
      AND b~belnr IN so_belnr
      AND b~blart IN so_blart.






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
          'X' 'BELNR'     ' ' 'BSEG' 'BELNR',
          'X' 'BUZEI'     ' ' 'BSEG' 'BUZEI',
          ' ' 'BLART'     ' ' 'BKPF' 'BLART',
          ' ' 'BUDAT'      ' ' 'BKPF' 'BUDAT',
          ' ' 'SHKZG'   ' ' 'BSEG' 'SHKZG',
          ' ' 'DMBTR'  ' ' 'BSEG' 'DMBTR',
          ' ' 'WAERS' ' ' 'BKPF' 'WAERS',
          ' ' 'HKONT' ' ' 'BSEG' 'HKONT'.
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

  APPEND gs_fcat TO gt_fcat.

ENDFORM.
