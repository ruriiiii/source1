*&---------------------------------------------------------------------*
*& Include          ZC1R180002_F01
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
  SELECT a~matnr a~mtart a~matkl a~meins a~tragr b~pstat b~dismm b~ekgrp
    INTO CORRESPONDING FIELDS OF TABLE gt_data
    FROM mara AS a INNER JOIN marc AS b ON a~matnr = b~matnr
    WHERE a~matnr in so_matnr
      AND a~mtart in so_mtart
      AND b~ekgrp in so_ekgrp
      AND b~werks = pa_werks.

  IF sy-subrc NE 0.
    MESSAGE s001.
    STOP.
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

  IF gt_fcat IS INITIAL.
    PERFORM set_fcat USING :
          'MATNR' 'MATNR',
          'MTART' 'MTART',
          'MATKL' 'MATKL',
          'MEINS' 'MEINS',
          'TRAGR' 'TRAGR',
          'PSTAT' 'PSTAT',
          'DISMM' 'DISMM',
          'EKGRP' 'EKGRP'.
  ENDIF.
ENDFORM.
*&---------------------------------------------------------------------*
*& Form set_fcat
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*&      --> P_
*&---------------------------------------------------------------------*
FORM set_fcat  USING pv_fieldname pv_text.

  gs_fcat = VALUE #( fieldname = pv_fieldname
                     coltext = pv_text ).

  APPEND gs_fcat TO gt_fcat.

ENDFORM.
