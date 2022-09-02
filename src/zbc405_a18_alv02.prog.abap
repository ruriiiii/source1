*&---------------------------------------------------------------------*
*& Report ZBC405_A18_ALV02
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zbc405_a18_alv02.

TABLES ztsbook_a18.

SELECTION-SCREEN BEGIN OF BLOCK b1 WITH FRAME TITLE TEXT-t01.
  SELECT-OPTIONS : so_car FOR ztsbook_a18-carrid OBLIGATORY
                                             MEMORY ID car,
                   so_con FOR ztsbook_a18-connid
                                             MEMORY ID con,
                   so_fld FOR ztsbook_a18-fldate,
                   so_cus FOR ztsbook_a18-customid.
  PARAMETERS : p_edit AS CHECKBOX.     "수정모드 설정할 수 있도록 파라미터 생성
SELECTION-SCREEN END OF BLOCK b1.

SELECTION-SCREEN SKIP 1.
PARAMETERS p_layout TYPE disvariant-variant.


DATA: gt_custom TYPE TABLE OF ztscustom_a18,
      gs_custom TYPE ztscustom_a18.

"-------------------------------------------------------------------

TYPES: BEGIN OF gty_sbook.
         INCLUDE TYPE ztsbook_t03.
TYPES:   light TYPE c LENGTH 1.
TYPES : row_color TYPE c LENGTH 4.
TYPES : it_color TYPE lvc_t_scol.
TYPES :   telephone TYPE ztscustom_a18-telephone.
TYPES :   email     TYPE ztscustom_a18-email.
TYPES :   bt        TYPE lvc_t_styl.
TYPES : modified TYPE c LENGTH 1.   "레코드가 변경되면 'X'
TYPES: END OF gty_sbook.

DATA: gt_sbook TYPE TABLE OF gty_sbook,
*      dl_sbook TYPE TABLE OF ztsbook_a18,  "for deleted records
      gs_sbook TYPE gty_sbook.

DATA: dl_sbook TYPE TABLE OF ztsbook_a18,
      dw_sbook TYPE ztsbook_a18.

DATA ok_code TYPE sy-ucomm.


"ALV
DATA: go_container TYPE REF TO cl_gui_custom_container,
      go_alv       TYPE REF TO cl_gui_alv_grid.

DATA: gs_variant TYPE disvariant,
      gs_layout  TYPE lvc_s_layo,
      gt_sort    TYPE lvc_t_sort,
      gs_sort    TYPE lvc_s_sort,
      gs_color   TYPE lvc_s_scol,
      gt_exct    TYPE ui_functions,
      gt_fcat    TYPE lvc_t_fcat,
      gs_fcat    TYPE lvc_s_fcat.

INCLUDE zbc405_a18_alv02_class.


"------------------------------------------------------------------

AT SELECTION-SCREEN ON VALUE-REQUEST FOR p_layout.  "pa_lv에 f4기능을 추가

  CALL FUNCTION 'LVC_VARIANT_SAVE_LOAD'
    EXPORTING
      i_save_load = 'F'
    CHANGING
      cs_variant  = gs_variant.
  IF sy-subrc <> 0.
* Implement suitable error handling here
  ELSE.
    p_layout = gs_variant-variant.
  ENDIF.


  "-------------------------------------------------------------------

INITIALIZATION.
  gs_variant-report = sy-cprog.

START-OF-SELECTION.  "시작한다는 의미로 꼭 써줘야 함

  PERFORM get_data.

  CALL SCREEN 100.


*&---------------------------------------------------------------------*
*& Form get_data
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM get_data .

  DATA gt_temp TYPE TABLE OF gty_sbook.

  SELECT *
    FROM ztsbook_a18
    INTO CORRESPONDING FIELDS OF TABLE gt_sbook
    WHERE carrid IN so_car
    AND connid IN so_con
    AND fldate IN so_fld
    AND customid IN so_cus.

  IF sy-subrc = 0.

    gt_temp = gt_sbook.
    DELETE gt_temp WHERE customid = space.

    SORT gt_temp BY customid.
    DELETE ADJACENT DUPLICATES FROM gt_temp COMPARING customid.

    SELECT *
      FROM ztscustom_a18
      INTO TABLE gt_custom
      FOR ALL ENTRIES IN gt_temp
      WHERE id = gt_temp-customid.

  ENDIF.

  LOOP AT gt_sbook INTO gs_sbook.
    READ TABLE gt_custom INTO gs_custom
             WITH KEY id = gs_sbook-customid.
    IF sy-subrc EQ 0.
      gs_sbook-telephone = gs_custom-telephone.
      gs_sbook-email     = gs_custom-email.
    ENDIF.





    IF gs_sbook-luggweight > 25.
      gs_sbook-light = 1.   "red
    ELSEIF gs_sbook-luggweight > 15.
      gs_sbook-light = 2.   "Yellow
    ELSE.
      gs_sbook-light = 3.  "Green
    ENDIF.

    IF gs_sbook-class = 'F'.
      gs_sbook-row_color = 'C710'.
    ENDIF.

    IF gs_sbook-smoker = 'X'.
      gs_color-fname = 'SMOKER'.
      gs_color-color-col = col_negative.
      gs_color-color-int = '1'.
      gs_color-color-inv = '0'.
      APPEND gs_color TO gs_sbook-it_color.
    ENDIF.



    MODIFY gt_sbook FROM gs_sbook.
  ENDLOOP.
ENDFORM.
*&---------------------------------------------------------------------*
*& Module STATUS_0100 OUTPUT
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
MODULE status_0100 OUTPUT.
  IF p_edit = 'X'.
    SET PF-STATUS 'S100'.
  ELSE.
    SET PF-STATUS 'S100' EXCLUDING 'SAVE'.
  ENDIF.
  SET TITLEBAR 'T100' WITH sy-datum sy-uname.
ENDMODULE.
*&---------------------------------------------------------------------*
*&      Module  USER_COMMAND_0100  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE user_command_0100 INPUT.
  DATA : p_ans TYPE c LENGTH 1.

  CASE ok_code.
    WHEN 'SAVE'.
      CALL FUNCTION 'POPUP_TO_CONFIRM'    "컴펌 팝업 띄우기
        EXPORTING
          titlebar              = 'Data Save!'
*         DIAGNOSE_OBJECT       = ' '
          text_question         = 'Do you want to Save?'
          text_button_1         = 'Yes'(001)
*         ICON_BUTTON_1         = ' '
          text_button_2         = 'No'(002)
          display_cancel_button = ' '
        IMPORTING
          answer                = p_ans
        EXCEPTIONS
          text_not_found        = 1
          OTHERS                = 2.
      IF sy-subrc <> 0.
* Implement suitable error handling here
      ELSE.
        IF p_ans = '1'.
          PERFORM data_save.
        ENDIF.
      ENDIF.


  ENDCASE.
ENDMODULE.
*&---------------------------------------------------------------------*
*&      Module  EXIT  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE exit INPUT.
  LEAVE TO SCREEN 0.
ENDMODULE.
*&---------------------------------------------------------------------*
*& Module CREATE_ALV_OBJECT OUTPUT
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
MODULE create_alv_object OUTPUT.
  IF go_container IS INITIAL.

    CREATE OBJECT go_container
      EXPORTING
        container_name = 'MY_CONTROL_AREA'.

    IF sy-subrc = 0.
      CREATE OBJECT go_alv
        EXPORTING
          i_parent = go_container.

      IF sy-subrc = 0.

        PERFORM set_variant.
        PERFORM set_layout.
        PERFORM set_sort.
        PERFORM make_fieldcatalog.

*---
        CALL METHOD go_alv->register_edit_event
          EXPORTING
            i_event_id = cl_gui_alv_grid=>mc_evt_modified.    "변경되는 순간 반영
*---
        "mc_evt_enter   "enter치면 반영



        APPEND cl_gui_alv_grid=>mc_fc_filter TO gt_exct.
        APPEND cl_gui_alv_grid=>mc_fc_info TO gt_exct.
        APPEND cl_gui_alv_grid=>mc_fc_loc_append_row TO gt_exct.
        APPEND cl_gui_alv_grid=>mc_fc_loc_copy_row TO gt_exct.    "위 툴바 버튼들 안보이게 함



        SET HANDLER lcl_handler=>on_doubleclick FOR go_alv.
        SET HANDLER lcl_handler=>on_toolbar FOR go_alv.
        SET HANDLER lcl_handler=>on_user_command FOR go_alv.
        SET HANDLER lcl_handler=>on_data_changed FOR go_alv.
        SET HANDLER lcl_handler=>on_data_changed_finished FOR go_alv.

        CALL METHOD go_alv->set_table_for_first_display
          EXPORTING
*           i_buffer_active      =
*           i_bypassing_buffer   =
*           i_consistency_check  =
            i_structure_name     = 'ZTSBOOK_A18'
            is_variant           = gs_variant
            i_save               = 'A'
            i_default            = 'X'
            is_layout            = gs_layout
*           is_print             =
*           it_special_groups    =
            it_toolbar_excluding = gt_exct
*           it_hyperlink         =
*           it_alv_graphics      =
*           it_except_qinfo      =
*           ir_salv_adapter      =
          CHANGING
            it_outtab            = gt_sbook
            it_fieldcatalog      = gt_fcat
            it_sort              = gt_sort
*           it_filter            =
*        EXCEPTIONS
*           invalid_parameter_combination = 1
*           program_error        = 2
*           too_many_lines       = 3
*           others               = 4
          .
        IF sy-subrc <> 0.
*       Implement suitable error handling here
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
*&---------------------------------------------------------------------*
*& Form set_layout
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM set_layout .
  gs_layout-sel_mode = 'D'.
  gs_layout-excp_fname = 'LIGHT'.
  gs_layout-excp_led = 'X'. "한개짜리 신호등으로 변경
  gs_layout-zebra      = 'X'.
  gs_layout-cwidth_opt  = 'X'.

  gs_layout-info_fname = 'ROW_COLOR'.
  gs_layout-ctab_fname = 'IT_COLOR'.
  gs_layout-stylefname = 'BT'.
ENDFORM.
*&---------------------------------------------------------------------*
*& Form set_sort
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM set_sort .
  CLEAR gs_sort.
  gs_sort-fieldname = 'CARRID'.
  gs_sort-up = 'X'.
  gs_sort-spos = '1'.
  APPEND gs_sort TO gt_sort.

  CLEAR gs_sort.
  gs_sort-fieldname = 'CONNID'.
  gs_sort-up = 'X'.
  gs_sort-spos = '2'.
  APPEND gs_sort TO gt_sort.

  CLEAR gs_sort.
  gs_sort-fieldname = 'FLDATE'.
  gs_sort-down = 'X'.
  gs_sort-spos = '3'.
  APPEND gs_sort TO gt_sort.
ENDFORM.
*&---------------------------------------------------------------------*
*& Form set_variant
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM set_variant .
  gs_variant-variant = p_layout.
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
  CLEAR gs_fcat.
  gs_fcat-fieldname = 'LIGHT'.
  gs_fcat-coltext = 'Info'.
  APPEND gs_fcat TO gt_fcat.

  CLEAR gs_fcat.
  gs_fcat-fieldname = 'SMOKER'.       "필드를 체크박스로 만들기
  gs_fcat-checkbox = 'X'.
  APPEND gs_fcat TO gt_fcat.

  CLEAR gs_fcat.
  gs_fcat-fieldname = 'INVOICE'.
  gs_fcat-checkbox = 'X'.
  APPEND gs_fcat TO gt_fcat.

  CLEAR gs_fcat.
  gs_fcat-fieldname = 'CANCELLED'.
  gs_fcat-checkbox = 'X'.
*  gs_fcat-edit = 'X'.        "수정이 가능하게 변경
  gs_fcat-edit = p_edit.      "edit mode를 선택했을 때만 수정 가능하도록 함
  APPEND gs_fcat TO gt_fcat.

  CLEAR gs_fcat.
  gs_fcat-fieldname = 'TELEPHONE'.
  gs_fcat-ref_table = 'ZTSCUSTOM_T03'.
  gs_fcat-ref_field = 'TELEPHONE'.
  gs_fcat-col_pos   = '30'.
  APPEND gs_fcat TO gt_fcat.


  CLEAR gs_fcat.
  gs_fcat-fieldname = 'EMAIL'.
  gs_fcat-ref_table = 'ZTSCUSTOM_T03'.
  gs_fcat-ref_field = 'EMAIL'.
  gs_fcat-col_pos = '31'.
  APPEND gs_fcat TO gt_fcat.

  CLEAR : gs_fcat.
  gs_fcat-fieldname = 'CUSTOMID'.
*  gs_fcat-emphasize = 'C400'.     "필드 색 강조,,?
*  gs_fcat-edit = 'X'.
  gs_fcat-edit = p_edit.
  APPEND gs_fcat TO gt_fcat.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form customer_change_part
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*&      --> ER_DATA_CHANGED
*&      --> LS_MOD_CELLS
*&---------------------------------------------------------------------*
FORM customer_change_part USING per_data_changed
                            TYPE REF TO cl_alv_changed_data_protocol
                                 ps_mod_cells TYPE lvc_s_modi.

  DATA : l_customid TYPE ztsbook_t03-customid,
         l_phone    TYPE ztscustom_a18-telephone,
         l_email    TYPE ztscustom_a18-email,
         l_name     TYPE ztscustom_a18-name.


  READ TABLE gt_sbook INTO gs_sbook  INDEX ps_mod_cells-row_id.

  CALL METHOD per_data_changed->get_cell_value
    EXPORTING
      i_row_id    = ps_mod_cells-row_id
*     i_tabix     =
      i_fieldname = 'CUSTOMID'  "=ps_mod_cells-fieldname
    IMPORTING
      e_value     = l_customid.


  IF l_customid IS NOT INITIAL.

    READ TABLE gt_custom INTO gs_custom WITH KEY id = l_customid.

    IF sy-subrc = 0.
      l_phone = gs_custom-telephone.
      l_email = gs_custom-email.
      l_name = gs_custom-name.
    ELSE.
      SELECT SINGLE telephone email name
        FROM ztscustom_a18
        INTO (l_phone, l_email, l_name)
        WHERE id = l_customid.
    ENDIF.
  ELSE.
    CLEAR: l_email, l_phone, l_name.
  ENDIF.

  CALL METHOD per_data_changed->modify_cell    "변경된 값을 화면에 나타나게 해줌. 안쓰면 테이블은 변경되지만 화면에는 변경값으로 안보임.
    EXPORTING
      i_row_id    = ps_mod_cells-row_id
      i_fieldname = 'TELEPHONE'
      i_value     = l_phone.

  CALL METHOD per_data_changed->modify_cell
    EXPORTING
      i_row_id    = ps_mod_cells-row_id
      i_fieldname = 'EMAIL'
      i_value     = l_email.

  CALL METHOD per_data_changed->modify_cell
    EXPORTING
      i_row_id    = ps_mod_cells-row_id
      i_fieldname = 'PASSNAME'
      i_value     = l_name.


  gs_sbook-email = l_email.
  gs_sbook-telephone = l_phone.
  gs_sbook-passname = l_name.

  MODIFY gt_sbook FROM gs_sbook INDEX ps_mod_cells-row_id.      "인터널 테이블을 변경



ENDFORM.
*&---------------------------------------------------------------------*
*& Form insert_parts
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*&      --> ER_DATA_CHANGED
*&      --> LS_INS_CELLS
*&---------------------------------------------------------------------*
FORM insert_parts  USING rr_data_changed TYPE REF TO
                             cl_alv_changed_data_protocol
                            rs_ins_cells TYPE lvc_s_moce.


  gs_sbook-carrid = so_car-low.    "so_car-sign = 'I', so_car-option = 'EQ'가 생략
  gs_sbook-connid = so_con-low.
  gs_sbook-fldate = so_fld-low.


  CALL METHOD rr_data_changed->modify_cell
    EXPORTING
      i_row_id    = rs_ins_cells-row_id
      i_fieldname = 'CARRID'
      i_value     = gs_sbook-carrid.


  CALL METHOD rr_data_changed->modify_cell
    EXPORTING
      i_row_id    = rs_ins_cells-row_id
      i_fieldname = 'CONNID'
      i_value     = gs_sbook-connid.



  CALL METHOD rr_data_changed->modify_cell
    EXPORTING
      i_row_id    = rs_ins_cells-row_id
      i_fieldname = 'FLDATE'
      i_value     = gs_sbook-fldate.



  CALL METHOD rr_data_changed->modify_cell
    EXPORTING
      i_row_id    = rs_ins_cells-row_id
      i_fieldname = 'ORDER_DATE'
      i_value     = sy-datum.

  CALL METHOD rr_data_changed->modify_cell
    EXPORTING
      i_row_id    = rs_ins_cells-row_id
      i_fieldname = 'CUSTTYPE'
      i_value     = 'P'.

  CALL METHOD rr_data_changed->modify_cell
    EXPORTING
      i_row_id    = rs_ins_cells-row_id
      i_fieldname = 'CLASS'
      i_value     = 'C'.



  PERFORM modify_style USING rr_data_changed
                             rs_ins_cells
                             'CONNID'.
  PERFORM modify_style USING rr_data_changed
                             rs_ins_cells
                             'FLDATE'.


  PERFORM modify_style USING rr_data_changed
                             rs_ins_cells
                             'CUSTTYPE'.
  PERFORM modify_style USING rr_data_changed
                             rs_ins_cells
                             'CLASS'.
  PERFORM modify_style USING rr_data_changed
                             rs_ins_cells
                             'DISCOUNT'.
  PERFORM modify_style USING rr_data_changed
                            rs_ins_cells
                            'SMOKER'.
  PERFORM modify_style USING rr_data_changed
                           rs_ins_cells
                           'LUGGWEIGHT'.
  PERFORM modify_style USING rr_data_changed
                           rs_ins_cells
                           'WUNIT'.
  PERFORM modify_style USING rr_data_changed
                          rs_ins_cells
                          'INVOICE'.
  PERFORM modify_style USING rr_data_changed
                          rs_ins_cells
                          'FORCURAM'.
  PERFORM modify_style USING rr_data_changed
                         rs_ins_cells
                         'FORCURKEY'.
  PERFORM modify_style USING rr_data_changed
                       rs_ins_cells
                       'LOCCURAM'.
  PERFORM modify_style USING rr_data_changed
                        rs_ins_cells
                        'LOCCURKEY'.
  PERFORM modify_style USING rr_data_changed
                        rs_ins_cells
                        'ORDER_DATE'.
  PERFORM modify_style USING rr_data_changed
                        rs_ins_cells
                        'AGENCYNUM'.




  MODIFY gt_sbook FROM gs_sbook INDEX rs_ins_cells-row_id .


ENDFORM.
*&---------------------------------------------------------------------*
*& Form modify_style
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*&      --> RR_DATA_CHANGED
*&      --> RS_INS_CELLS
*&      --> P_
*&---------------------------------------------------------------------*
FORM modify_style  USING  rr_data_changed  TYPE REF TO
                             cl_alv_changed_data_protocol
                            rs_ins_cells TYPE lvc_s_moce
                            VALUE(p_val).

  CALL METHOD rr_data_changed->modify_style
    EXPORTING
      i_row_id    = rs_ins_cells-row_id
      i_fieldname = p_val
      i_style     = cl_gui_alv_grid=>mc_style_enabled.
ENDFORM.
*&---------------------------------------------------------------------*
*& Form modify_check
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*&      --> LS_MOD_CELLS
*&---------------------------------------------------------------------*
FORM modify_check  USING    pls_mod_cells TYPE lvc_s_modi.


  READ TABLE gt_sbook INTO gs_sbook INDEX pls_mod_cells-row_id.
  IF sy-subrc EQ 0.
    gs_sbook-modified = 'X'.
    MODIFY gt_sbook FROM gs_sbook INDEX pls_mod_cells-row_id.
  ENDIF.
ENDFORM.
*&---------------------------------------------------------------------*
*& Form data_save
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM data_save .

  DATA: ins_sbook TYPE TABLE OF ztsbook_a18,
        wa_sbook  TYPE ztsbook_a18.
  "Update 대상
  LOOP AT gt_sbook INTO gs_sbook WHERE modified = 'X'.

    UPDATE ztsbook_a18
      SET customid = gs_sbook-customid
          cancelled = gs_sbook-cancelled
          passname = gs_sbook-passname
     WHERE carrid = gs_sbook-carrid
      AND connid = gs_sbook-connid
      AND fldate = gs_sbook-fldate
      AND bookid = gs_sbook-bookid.

  ENDLOOP.

  "Insert 부분
  DATA: next_number TYPE s_book_id,
        ret_code    TYPE inri-returncode.
  DATA l_tabix LIKE sy-tabix.


  LOOP AT gt_sbook INTO gs_sbook WHERE bookid IS INITIAL.

    l_tabix = sy-tabix.

    CALL FUNCTION 'NUMBER_GET_NEXT'
      EXPORTING
        nr_range_nr             = '01'
        object                  = 'ZBOOKIDA18'
        subobject               = gs_sbook-carrid
*       IGNORE_BUFFER           = ' '
      IMPORTING
        number                  = next_number
        returncode              = ret_code
      EXCEPTIONS
        interval_not_found      = 1
        number_range_not_intern = 2
        object_not_found        = 3
        quantity_is_0           = 4
        quantity_is_not_1       = 5
        interval_overflow       = 6
        buffer_overflow         = 7
        OTHERS                  = 8.
    IF sy-subrc <> 0.
* Implement suitable error handling here
    ELSE.
      IF next_number IS NOT INITIAL.
        gs_sbook-bookid = next_number.

        MOVE-CORRESPONDING gs_sbook TO wa_sbook.
        APPEND wa_sbook TO ins_sbook.

        MODIFY gt_sbook FROM gs_sbook INDEX l_tabix TRANSPORTING bookid.
      ENDIF.
    ENDIF.




  ENDLOOP.

  IF ins_sbook IS NOT INITIAL.
    INSERT ztsbook_a18 FROM TABLE ins_sbook.
  ENDIF.

*  delete
  IF dl_sbook IS NOT INITIAL.
    DELETE ztsbook_a18 FROM TABLE dl_sbook.
    CLEAR : dl_sbook. REFRESH : dl_sbook.
  ENDIF.

ENDFORM.
