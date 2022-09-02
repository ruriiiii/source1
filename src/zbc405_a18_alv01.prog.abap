*&---------------------------------------------------------------------*
*& Report ZBC405_A18_ALV01
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zbc405_a18_alv01.

TYPES : BEGIN OF typ_flt.
          INCLUDE TYPE sflight.
TYPES :   changes_possible TYPE icon-id.      "필드 추가
TYPES :  btn_text TYPE c LENGTH 10.           "버튼 넣을 필드 추가
TYPES : tankcap TYPE s_capacity.
TYPES : capunit TYPE s_capunit.
TYPES : weight TYPE s_plan_wei.
TYPES : wei_unit TYPE s_wei_unit.
TYPES :   light TYPE c LENGTH 1.
TYPES : row_color TYPE c LENGTH 4.
TYPES : it_color TYPE lvc_t_scol.
TYPES : it_styl TYPE lvc_t_styl.
TYPES : END OF typ_flt.


DATA gt_flt TYPE TABLE OF typ_flt.
DATA gs_flt TYPE typ_flt.
DATA ok_code LIKE sy-ucomm.

"ALV Data 선언
DATA : go_container TYPE REF TO cl_gui_custom_container,
       go_alv_grid  TYPE REF TO cl_gui_alv_grid,
       gv_variant   TYPE disvariant,
       gv_save      TYPE c LENGTH 1,
       gs_layout    TYPE lvc_s_layo,
       gt_sort      TYPE lvc_t_sort,
       gs_sort      TYPE lvc_s_sort,
       gs_color     TYPE lvc_s_scol,
       gt_exct      TYPE ui_functions,
       gt_fcat      TYPE lvc_t_fcat,
       gs_fcat      TYPE lvc_s_fcat,
       gs_styl      TYPE lvc_s_styl.

DATA : gs_stable       TYPE lvc_s_stbl,
       gv_soft_refresh TYPE abap_bool.


INCLUDE zbc405_a18_alv01_class.

"Selection Screen
SELECT-OPTIONS : so_car FOR gs_flt-carrid MEMORY ID car,
                 so_con FOR gs_flt-connid MEMORY ID con,
                 so_dat FOR gs_flt-fldate.

SELECTION-SCREEN SKIP 1.
PARAMETERS p_date TYPE sy-datum DEFAULT '20201001'.
PARAMETERS pa_lv TYPE disvariant-variant.
PARAMETERS : p_edit AS CHECKBOX.

"----------------------------------------------------------------------

AT SELECTION-SCREEN ON VALUE-REQUEST FOR pa_lv.  "pa_lv에 f4기능을 추가

  gv_variant-report = sy-cprog.


  CALL FUNCTION 'LVC_VARIANT_SAVE_LOAD'
    EXPORTING
      i_save_load     = 'F'    "S, F, L
    CHANGING
      cs_variant      = gv_variant
    EXCEPTIONS
      not_found       = 1
      wrong_input     = 2
      fc_not_complete = 3
      OTHERS          = 4.
  IF sy-subrc <> 0.
* Implement suitable error handling here
  ELSE.
    pa_lv = gv_variant-variant.
  ENDIF.

  "------------------------------------------------------------------------

START-OF-SELECTION.
  "데이터 가져오기
  PERFORM get_data.


  CALL SCREEN 100.
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
  CASE ok_code.
    WHEN 'BACK' OR 'EXIT' OR 'CANC'.

      CALL METHOD go_alv_grid->free.
      CALL METHOD go_container->free. "메모리 확보를 위해 묵시적으로 해주는게 원칙. 안해도 작동은 잘되지만 하자!

      FREE : go_alv_grid, go_container.
      LEAVE TO SCREEN 0.
  ENDCASE.
ENDMODULE.
*&---------------------------------------------------------------------*
*& Module CREATE_AND_TRANSFER OUTPUT
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
MODULE create_and_transfer OUTPUT.
  IF go_container IS INITIAL.

    CREATE OBJECT go_container
      EXPORTING
        container_name = 'MY_CONTROL_AREA'
      EXCEPTIONS
        OTHERS         = 6.
    IF sy-subrc <> 0.
      MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
                 WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
    ENDIF.


    CREATE OBJECT go_alv_grid
      EXPORTING
        i_parent = go_container      "ALV가 얹혀지는 곳
      EXCEPTIONS
        OTHERS   = 5.
    IF sy-subrc <> 0.
      MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
                 WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
    ENDIF.


    PERFORM make_variant.
    PERFORM make_layout.
    PERFORM make_sort.
    PERFORM make_fieldcatalog.

    CALL METHOD go_alv_grid->register_edit_event
      EXPORTING
        i_event_id = cl_gui_alv_grid=>mc_evt_modified.



    APPEND cl_gui_alv_grid=>mc_fc_filter TO gt_exct. "CL_GUI_ALV_GRID)클래스에 (mc_fc_filter)attribute를 직접 참조하겠다
    APPEND cl_gui_alv_grid=>mc_fc_info TO gt_exct.   " => mc_fc_filter, mc_fc_info 툴을 없애겠다.

*    APPEND cl_gui_alv_grid=>mc_fc_excl_all TO gt_exct.  "Application Toolbar 전체를 없애겠다.



    SET HANDLER lcl_handler=>on_doubleclick FOR go_alv_grid.  "이벤트 트리거 : SET HANDLER 를 해줘야지 이벤트가 실행됨!
    SET HANDLER lcl_handler=>on_hotspot FOR go_alv_grid.
    SET HANDLER lcl_handler=>on_toolbar FOR go_alv_grid.
    SET HANDLER lcl_handler=>on_user_command FOR go_alv_grid.
    SET HANDLER lcl_handler=>on_button_click FOR go_alv_grid.
    SET HANDLER lcl_handler=>on_context_menu_request FOR go_alv_grid.
    SET HANDLER lcl_handler=>on_before_user_com FOR go_alv_grid.


    CALL METHOD go_alv_grid->set_table_for_first_display
      EXPORTING
*       i_buffer_active               =
*       i_bypassing_buffer            =
*       i_consistency_check           =
        i_structure_name              = 'SFLIGHT'
        is_variant                    = gv_variant
        i_save                        = gv_save
        i_default                     = 'X'
        is_layout                     = gs_layout
*       is_print                      =
*       it_special_groups             =
        it_toolbar_excluding          = gt_exct    "Application Toolbar에서 특정 아이콘을 없앨때 사용
*       it_hyperlink                  =
*       it_alv_graphics               =
*       it_except_qinfo               =
*       ir_salv_adapter               =
      CHANGING
        it_outtab                     = gt_flt
        it_fieldcatalog               = gt_fcat
        it_sort                       = gt_sort
*       it_filter                     =
      EXCEPTIONS
        invalid_parameter_combination = 1
        program_error                 = 2
        too_many_lines                = 3
        OTHERS                        = 4.
    IF sy-subrc <> 0.
* Implement suitable error handling here
    ENDIF.

  ELSE.
*    ON CHANGE OF gt_flt.
    gv_soft_refresh = 'X'.
    gs_stable-row = 'X'.
    gs_stable-col = 'X'.
    CALL METHOD go_alv_grid->refresh_table_display
      EXPORTING
        is_stable      = gs_stable
        i_soft_refresh = gv_soft_refresh
      EXCEPTIONS
        finished       = 1
        OTHERS         = 2.
    IF sy-subrc <> 0.
*       Implement suitable error handling here
    ENDIF.
*    ENDON.


  ENDIF.



ENDMODULE.
*&---------------------------------------------------------------------*
*& Form get_data
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM get_data .
  SELECT *
FROM sflight
  INTO CORRESPONDING FIELDS OF TABLE gt_flt
  WHERE carrid IN so_car
    AND connid IN so_con
  AND fldate IN so_dat.


  LOOP AT gt_flt INTO gs_flt.
    IF gs_flt-seatsocc < 5.
      gs_flt-light = 1.   "빨
    ELSEIF gs_flt-seatsocc < 100.
      gs_flt-light = 2.    "노
    ELSE.
      gs_flt-light = 3.   "초
    ENDIF.

    IF gs_flt-fldate+4(2) = sy-datum+4(2).
      gs_flt-row_color = 'C511'.
    ENDIF.

    IF gs_flt-planetype = '747-400'.
      gs_color-fname = 'PLANETYPE'.
      gs_color-color-col = col_total.
      gs_color-color-int = '1'.
      gs_color-color-inv = '0'.
      APPEND gs_color TO gs_flt-it_color.
    ENDIF.

    IF gs_flt-seatsocc_b = 0.
      gs_color-fname = 'SEATSOCC_B'.
      gs_color-color-col = col_negative.    "Color
      gs_color-color-int = '1'.             "Intenxified
      gs_color-color-inv = '0'.             "Inverse
      APPEND gs_color TO gs_flt-it_color.
    ENDIF.

    IF gs_flt-fldate < p_date.
      gs_flt-changes_possible = icon_space.
    ELSE.
      gs_flt-changes_possible = icon_okay.
    ENDIF.


    IF gs_flt-seatsmax_b = gs_flt-seatsocc_b.
      gs_flt-btn_text = 'Fullseats!'.

      gs_styl-fieldname = 'BTN_TEXT'.
      gs_styl-style = cl_gui_alv_grid=>mc_style_button.
      APPEND gs_styl TO gs_flt-it_styl.
    ENDIF.


    SELECT SINGLE tankcap
      FROM saplane
      INTO gs_flt-tankcap
      WHERE planetype = gs_flt-planetype.

    SELECT SINGLE cap_unit
      FROM saplane
      INTO gs_flt-capunit
      WHERE planetype = gs_flt-planetype.

    SELECT SINGLE weight
       FROM saplane
       INTO gs_flt-weight
       WHERE planetype = gs_flt-planetype.

    SELECT SINGLE wei_unit
      FROM saplane
      INTO gs_flt-wei_unit
      WHERE planetype = gs_flt-planetype.






    MODIFY gt_flt FROM gs_flt.
  ENDLOOP.
ENDFORM.
*&---------------------------------------------------------------------*
*& Form make_variant
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM make_variant .
  gv_variant-report = sy-cprog.
  gv_variant-variant = pa_lv.
  gv_save = 'A'.
ENDFORM.
*&---------------------------------------------------------------------*
*& Form make_layout
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM make_layout .
  gs_layout-zebra = 'X'.       "Row에 교차로 색 주기
  gs_layout-cwidth_opt = 'X'.  "압축해서 한 화면에 보이게 해줌 (Fieldcat col_opt 기능과 동일)
  gs_layout-sel_mode = 'D'.     "셀렉션 모드 추가 : A,B,C,D에 따라 선택 가능한 옵션 달라짐

  gs_layout-excp_fname = 'LIGHT'.    "Exception handling field 설정(fieldcatalog 추가 없이 사용 가능함)
  gs_layout-excp_led = 'X'.          "신호등 모양 변경

  gs_layout-info_fname = 'ROW_COLOR'.
  gs_layout-ctab_fname = 'IT_COLOR'.

  gs_layout-stylefname = 'IT_STYL'.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form make_sort
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM make_sort .
  CLEAR gs_sort.
  gs_sort-fieldname = 'CARRID'.
  gs_sort-up = 'X'.   "오름차순
  gs_sort-spos = 1.   "정렬 순서
  APPEND gs_sort TO gt_sort.

  CLEAR gs_sort.
  gs_sort-fieldname = 'CONNID'.
  gs_sort-up = 'X'.   "오름차순
  gs_sort-spos = 2.
  APPEND gs_sort TO gt_sort.

  CLEAR gs_sort.
  gs_sort-fieldname = 'FLDATE'.
  gs_sort-down = 'X'.   "내림차순
  gs_sort-spos = 3.
  APPEND gs_sort TO gt_sort.

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
  gs_fcat-coltext = 'INFO'.
  APPEND gs_fcat TO gt_fcat.   "'LIGHT'필드의 column title을 'INFO'로 바꾸겠다

  CLEAR gs_fcat.
  gs_fcat-fieldname = 'PRICE'.
  gs_fcat-no_out = 'X'.       " 'PRICE'필드를 안보이게 하겠다
*  gs_fcat-edit = 'X'.          " 필드를 입력 가능하게 하는 기능
  APPEND gs_fcat TO gt_fcat.

  CLEAR gs_fcat.
  gs_fcat-fieldname = 'CHANGES_POSSIBLE'.
  gs_fcat-coltext = 'Chang.Poss'.
  gs_fcat-col_pos = 5.   "설정 안하면 '0'으로 되서 맨 앞으로 감
  APPEND gs_fcat TO gt_fcat.  "'Changes_possible'필드 추가하고 column title을 'Chang.Poss', 디스플레이 순서는 5번째로 하겠다.

  CLEAR gs_fcat.
  gs_fcat-fieldname = 'SEATSOCC'.
  gs_fcat-do_sum = 'X'.
  APPEND gs_fcat TO gt_fcat.

  CLEAR gs_fcat.
  gs_fcat-fieldname = 'CARRID'.
*  gs_fcat-hotspot = 'X'.    "한번 클릭 활성화
  APPEND gs_fcat TO gt_fcat.

  CLEAR gs_fcat.
  gs_fcat-fieldname = 'BTN_TEXT'.     "필드 추가
  gs_fcat-coltext = 'Status'.
  gs_fcat-col_pos = 12.
  APPEND gs_fcat TO gt_fcat.

  CLEAR gs_fcat.
  gs_fcat-fieldname = 'TANKCAP'.
  gs_fcat-coltext = 'tankcap'.
  gs_fcat-col_pos = 10.
  APPEND gs_fcat TO gt_fcat.

  CLEAR gs_fcat.
  gs_fcat-fieldname = 'CAPUNIT'.
  gs_fcat-coltext = 'capunit'.
  gs_fcat-col_pos = 11.
  APPEND gs_fcat TO gt_fcat.

  CLEAR gs_fcat.
  gs_fcat-fieldname = 'WEIGHT'.
  gs_fcat-coltext = 'weight'.
  gs_fcat-col_pos = 12.
  APPEND gs_fcat TO gt_fcat.

  CLEAR gs_fcat.
  gs_fcat-fieldname = 'WEI_UNIT'.
  gs_fcat-coltext = 'wei unit'.
  gs_fcat-col_pos = 13.
  APPEND gs_fcat TO gt_fcat.

  CLEAR gs_fcat.
  gs_fcat-fieldname = 'PLANETYPE'.
  gs_fcat-edit = p_edit.
  APPEND gs_fcat TO gt_fcat.

ENDFORM.
