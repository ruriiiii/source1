*&---------------------------------------------------------------------*
*& Include          ZRRA18_05_F01
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

  CLEAR gs_data.
  REFRESH gt_data.

  SELECT a~carrid a~carrname a~url
         b~connid b~fldate b~planetype b~price b~currency
    INTO CORRESPONDING FIELDS OF TABLE gt_data
    FROM scarr AS a INNER JOIN sflight AS b ON a~carrid = b~carrid
   WHERE a~carrid IN so_carr
     AND b~connid IN so_conn
     AND b~planetype IN so_ptype.


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


  gs_layout-zebra = 'X'.
  gs_layout-sel_mode = 'D'.
  gs_layout-cwidth_opt = 'X'.

  IF gt_fcat IS INITIAL.
    PERFORM set_fcat USING :
          'X' 'CARRID'     ' ' 'SCARR'   'CARRID',
          'X' 'CARRNAME'   ' ' 'SCARR'   'CARRNAME',
          'X' 'CONNID'     ' ' 'SFLIGHT' 'CONNID',
          'X' 'FLDATA'     ' ' 'SFLIGHT' 'FLDATE',
          ' ' 'PLANETYPE'  ' ' 'SFLIGHT' 'PLANETYPE',
          ' ' 'PRICE'      ' ' 'SFLIGHT' 'PRICE',
          ' ' 'CURRENCY'   ' ' 'SFLIGHT' 'CURRENCY',
          ' ' 'URL'        ' ' 'SCARR'   'URL'.
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
FORM set_fcat  USING pv_key pv_field pv_text pv_ref_table pv_ref_field .

  gs_fcat = VALUE #( key = pv_key
                     fieldname = pv_field
                     coltext = pv_text
                     ref_table = pv_ref_table
                     ref_field = pv_ref_field ).

  CASE pv_field.
    WHEN 'PRICE' OR 'CURRENCY'.
      gs_fcat = VALUE #( BASE gs_fcat
                          cfieldname = 'CURRENCY' ).

    WHEN 'PLANETYPE'.
      gs_fcat-hotspot = 'X'.
  ENDCASE.

  APPEND gs_fcat TO gt_fcat.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form display_screen_POP
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM display_screen_pop .
  IF gcl_container_pop IS NOT BOUND.

    CREATE OBJECT gcl_container_pop
      EXPORTING
        container_name = 'GCL_CONTAINER_POP'.


    CREATE OBJECT gcl_grid_pop
      EXPORTING
        i_parent = gcl_container_pop.


    CALL METHOD gcl_grid_pop->set_table_for_first_display
      EXPORTING
        i_save          = 'A'
        i_default       = 'X'
        is_layout       = gs_layout_pop
      CHANGING
        it_outtab       = gt_saplane
        it_fieldcatalog = gt_fcat_pop.


  ENDIF.
ENDFORM.
*&---------------------------------------------------------------------*
*& Form GET_AIRLINE_INFO
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM get_airline_info .

  CLEAR gs_saplane.
  REFRESH gt_saplane.

  SELECT *
    INTO CORRESPONDING FIELDS OF TABLE gt_saplane
    FROM saplane
    WHERE planetype = gs_data-planetype.

  IF sy-subrc NE 0.
    MESSAGE s001.
    EXIT.
  ENDIF.

  CALL SCREEN '0101' STARTING AT 20 3.
ENDFORM.
*&---------------------------------------------------------------------*
*& Form display_screeN
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

    SET HANDLER : lcl_event_handler=>on_hotspot FOR gcl_grid,
                  lcl_event_handler=>on_double_click FOR gcl_grid.


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
*& Form set_fcat_layout_pop
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM set_fcat_layout_pop .

  gs_layout_pop-zebra = 'X'.
  gs_layout_pop-col_opt = 'X'.
  gs_layout_pop-sel_mode = 'D'.
  gs_layout_pop-no_toolbar = 'X'.    "ALV의 툴바를 없애줌



  IF gt_fcat_pop IS INITIAL.
    PERFORM set_fcat_pop USING :
          'X' 'PLANETYPE' ' ' 'SAPLANE' 'PLANETYPE',
          ' ' 'CON_UNIT' ' ' 'SAPLANE' 'CON_UNIT',
          ' ' 'CAP_UNIT' ' ' 'SAPLANE' 'CAP_UNIT',
          ' ' 'WEIGHT' ' ' 'SAPLANE' 'WEIGHT'.
  ENDIF.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form set_fcat_pop
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*&      --> P_
*&      --> P_
*&      --> P_
*&      --> P_
*&      --> P_
*&---------------------------------------------------------------------*
FORM set_fcat_pop  USING pv_key pv_field pv_text pv_ref_table pv_ref_field.

  gt_fcat_pop =  VALUE #( BASE gt_fcat_pop
                          ( key = pv_key
                            fieldname = pv_field
                            coltext = pv_text
                            ref_table = pv_ref_table
                            ref_field = pv_ref_field
                            )
                           ).

ENDFORM.
*&---------------------------------------------------------------------*
*& Form display_screen_POP2
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM display_screen_pop2 .

  IF gcl_container_pop IS NOT BOUND.

    CREATE OBJECT gcl_container_pop2
      EXPORTING
        container_name = 'GCL_CONTAINER_POP2'.


    CREATE OBJECT gcl_grid_pop2
      EXPORTING
        i_parent = gcl_container_pop2.



    CALL METHOD gcl_grid_pop2->set_table_for_first_display
      EXPORTING
        i_save          = 'A'
        i_default       = 'X'
        is_layout       = gs_layout_pop2
      CHANGING
        it_outtab       = gt_sbook
        it_fieldcatalog = gt_fcat_pop2.

  ENDIF.
ENDFORM.
*&---------------------------------------------------------------------*
*& Form set_fcat_layout_pop2
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM set_fcat_layout_pop2 .

  gs_layout_pop-zebra = 'X'.
  gs_layout_pop-col_opt = 'X'.
  gs_layout_pop-sel_mode = 'D'.
  gs_layout_pop-no_toolbar = 'X'.    "ALV의 툴바를 없애줌

  IF gt_fcat_pop2 IS INITIAL.
    PERFORM set_fcat_pop2 USING :
          'X' 'CARRID' ' ' 'SBOOK' 'CARRID',
          'X' 'CONNID' ' ' 'SBOOK' 'CONNID',
          'X' 'FLDATA' ' ' 'SBOOK' 'FLDATA',
          'X' 'BOOKID' ' ' 'SBOOK' 'BOOKID',
          ' ' 'CUSTOMID' ' ' 'SBOOK' 'CUSTOMID',
          ' ' 'CUSTTYPE' ' ' 'SBOOK' 'CUSTTYPE'.
  ENDIF.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form set_fcat_pop2
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*&      --> P_
*&      --> P_
*&      --> P_
*&      --> P_
*&      --> P_
*&---------------------------------------------------------------------*
FORM set_fcat_pop2 USING pv_key pv_field pv_text pv_ref_table pv_ref_field.

  gt_fcat_pop2 =  VALUE #( BASE gt_fcat_pop2
                          ( key = pv_key
                            fieldname = pv_field
                            coltext = pv_text
                            ref_table = pv_ref_table
                            ref_field = pv_ref_field
                            )
                           ).

ENDFORM.
*&---------------------------------------------------------------------*
*& Form get_booking_info
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM get_booking_info .


  CLEAR gs_sbook.
  REFRESH gt_sbook.

  SELECT *
    INTO CORRESPONDING FIELDS OF TABLE gt_sbook
    FROM sbook
    WHERE carrid = gs_data-carrid
      AND connid = gs_data-connid
      AND fldate = gs_data-fldate.

  IF sy-subrc NE 0.
    MESSAGE s001.
    EXIT.
  ENDIF.

  CALL SCREEN '0102' STARTING AT 20 3.
ENDFORM.
