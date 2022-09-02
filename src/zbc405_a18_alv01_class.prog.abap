*&---------------------------------------------------------------------*
*& Include          ZBC405_A18_ALV01_CLASS
*&---------------------------------------------------------------------*
CLASS lcl_handler DEFINITION.   "lcl_handler 라는 클래스를 정의
  PUBLIC SECTION.
    CLASS-METHODS: on_doubleclick FOR EVENT double_click
      OF cl_gui_alv_grid
      IMPORTING e_row e_column es_row_no,    "cl_gui_alv_grid의 double_click 이벤트를 on_doubleclick로 이름짓고 e_row e_column es_row_no에 적용하겠다

      on_hotspot FOR EVENT hotspot_click
        OF cl_gui_alv_grid
        IMPORTING e_row_id e_column_id es_row_no,   "cl_gui_alv_grid의 hotspot_click 이벤트를 on_hotspot으로 이름짓고 e_row e_column es_row_no에 적용하겠다

      on_toolbar FOR EVENT toolbar   "툴바에 버튼을 만들기
        OF cl_gui_alv_grid
        IMPORTING e_object,

      on_user_command FOR EVENT user_command
        OF cl_gui_alv_grid
        IMPORTING e_ucomm,

      on_button_click FOR EVENT button_click
        OF cl_gui_alv_grid
        IMPORTING es_col_id es_row_no,

      on_context_menu_request FOR EVENT context_menu_request
        OF cl_gui_alv_grid
        IMPORTING e_object,

      on_before_user_com FOR EVENT before_user_command       "원래 있던 스탠다드 버튼을 다른 기능으로 바꾸고 싶을 때!
        OF cl_gui_alv_grid
        IMPORTING e_ucomm.






ENDCLASS.

CLASS lcl_handler IMPLEMENTATION.  "lcl_handler 라는 클래스를 구현
  METHOD on_doubleclick.     "on_doubleclick을 실행할 때 아래 로직을 구현하겠다.
    DATA : total_occ   TYPE i,
           total_occ_c TYPE c LENGTH 10.

    CASE e_column-fieldname.
      WHEN 'CHANGES_POSSIBLE'.       "CHANGES_POSSIBLE 필드를 더블클릭 했을때만 실행하겠다!
        READ TABLE gt_flt INTO gs_flt INDEX es_row_no-row_id.
        IF sy-subrc = 0.
          total_occ = gs_flt-seatsocc + gs_flt-seatsocc_b + gs_flt-seatsocc_f.
          total_occ_c = total_occ.
          CONDENSE total_occ_c.               "숫자이면 한 방향으로 정렬되기 때문에 c타입으로 변경해주고 가운데정렬
          MESSAGE i000(zt03_msg) WITH 'Total number of bookings:' total_occ_c.
        ELSE.
          MESSAGE i075(bc_405_408).
          EXIT.
        ENDIF.
    ENDCASE.
  ENDMETHOD.

  METHOD on_hotspot.
    DATA carr_name TYPE scarr-carrname.

    CASE e_column_id-fieldname.
      WHEN 'CARRID'.
        READ TABLE gt_flt INTO gs_flt INDEX es_row_no-row_id.
        IF sy-subrc = 0.
          SELECT SINGLE carrname
            INTO carr_name
            FROM scarr
            WHERE carrid = gs_flt-carrid.
          IF sy-subrc = 0.
            MESSAGE i000(zt03_msg) WITH carr_name.
          ELSE.
            MESSAGE i000(zt03_msg) WITH 'No Found!'.
          ENDIF.

        ELSE.
          MESSAGE i075(bc_405_408).
          EXIT.
        ENDIF.

    ENDCASE.

  ENDMETHOD.

  METHOD on_toolbar.
    DATA ls_button TYPE stb_button.
    ls_button-function = 'PERCENTAGE'.
*  ls_button-icon = ?
    ls_button-quickinfo = 'OCCUPIED TOTAL PERCENTAGE'.    "마우스를 갖다대면 조그맣게 정보가 뜨는 것
    ls_button-butn_type = '0'.   "normal button
    ls_button-text = 'Percentage'.
    INSERT ls_button INTO TABLE e_object->mt_toolbar.

    CLEAR ls_button.
    ls_button-butn_type = '3'.            "구분선 만들어주기
    INSERT ls_button INTO TABLE e_object->mt_toolbar.


    CLEAR ls_button.
    ls_button-function = 'PERCENTAGE MARKED'.
*  ls_button-icon = ?
    ls_button-quickinfo = 'OCCUPIED MARKED Percentage'.
    ls_button-butn_type = '0'.   "normal button
    ls_button-text = 'Marked Percentage'.
    INSERT ls_button INTO TABLE e_object->mt_toolbar.


    CLEAR ls_button.
    ls_button-function = 'DISP_CARR'.
    ls_button-icon = icon_ws_plane.
    ls_button-quickinfo = 'Airline Name'.
    ls_button-butn_type = '0'.   "normal button
*    ls_button-text = ''.
    INSERT ls_button INTO TABLE e_object->mt_toolbar.

  ENDMETHOD.


  METHOD on_user_command.
    DATA : lv_occp     TYPE i,
           lv_capa     TYPE i,
           lv_perct    TYPE p LENGTH 8 DECIMALS 1,
           lv_text(20).

    DATA : lt_rows TYPE lvc_t_roid,
           ls_rows TYPE lvc_s_roid.

    DATA : ls_col_id TYPE lvc_s_col,
           ls_row_id TYPE lvc_s_row.

    CALL METHOD go_alv_grid->get_current_cell
      IMPORTING
*       e_row     =
*       e_value   =
*       e_col     =
        es_row_id = ls_row_id
        es_col_id = ls_col_id.

    CASE e_ucomm.
      WHEN 'PERCENTAGE'.
        LOOP AT gt_flt INTO gs_flt.
          lv_occp = lv_occp + gs_flt-seatsocc.
          lv_capa = lv_capa + gs_flt-seatsmax.
        ENDLOOP.

        lv_perct = lv_occp / lv_capa * 100.
        lv_text = lv_perct.
        CONDENSE lv_text.

        MESSAGE i000(zt03_msg) WITH 'Percentage of occupied seats(%) :' lv_text.

      WHEN 'PERCENTAGE MARKED'.
        CALL METHOD go_alv_grid->get_selected_rows
          IMPORTING
*           et_index_rows =
            et_row_no = lt_rows.

        IF lines( lt_rows ) > 0.       "lt_row의 라인이 0개 이상일 경우 아래 로직 실행
          LOOP AT lt_rows INTO ls_rows.

            READ TABLE gt_flt INTO gs_flt INDEX ls_rows-row_id.
            IF sy-subrc EQ 0.
              lv_occp = lv_occp + gs_flt-seatsocc.
              lv_capa = lv_capa + gs_flt-seatsmax.

            ENDIF.

          ENDLOOP.

          lv_perct = lv_occp / lv_capa * 100.
          lv_text = lv_perct.
          CONDENSE lv_text.

          MESSAGE i000(zt03_msg) WITH
              'Percentage of Marked occupied seats (%):' lv_text.

        ELSE.
          MESSAGE i000(zt03_msg) WITH 'Please select at least one line!'.
        ENDIF.


        CLEAR : lv_text.


      WHEN 'DISP_CARR'.



        IF  ls_col_id-fieldname = 'CARRID'.
          READ TABLE gt_flt INTO gs_flt INDEX ls_row_id-index.
          IF sy-subrc EQ 0.
            CLEAR : lv_text.
            SELECT SINGLE carrname INTO lv_text FROM scarr
                     WHERE carrid = gs_flt-carrid.
            IF sy-subrc EQ 0.
              MESSAGE i000(zt03_msg) WITH lv_text.
            ELSE.
              MESSAGE i000(zt03_msg) WITH 'No found!'.
            ENDIF.

          ENDIF.
        ELSE.
          MESSAGE i000(zt03_msg) WITH '항공사를 선택하세요'.
          EXIT.
        ENDIF.



      WHEN 'SCHE'.           "goto flight schedule report
        READ TABLE gt_flt INTO gs_flt INDEX ls_row_id-index.
        IF sy-subrc = 0.
          SUBMIT bc405_event_d4 AND RETURN           "submit : 다른 프로그램을 부를 때 사용
          WITH so_car = gs_flt-carrid
          WITH so_con = gs_flt-connid.
        ENDIF.
    ENDCASE.




  ENDMETHOD.

  METHOD on_button_click.

    CASE es_col_id-fieldname.
      WHEN 'BTN_TEXT'.
        READ TABLE gt_flt INTO gs_flt INDEX es_row_no-row_id.

        IF ( gs_flt-seatsmax <> gs_flt-seatsocc ) OR ( gs_flt-seatsmax_f <> gs_flt-seatsocc_f ).
          MESSAGE i000(zt03_msg) WITH '다른 등급의 좌석을 예약하세요.'.
        ELSE.
          MESSAGE i000(zt03_msg) WITH '모든 좌석이 예약되었습니다.'.
        ENDIF.
    ENDCASE.
  ENDMETHOD.

  METHOD on_context_menu_request.      "User command를 따로 주지 않아도 실행되는 이유는 이미 만든 버튼 fct code와 동일하기 때문에

    CALL METHOD cl_ctmenu=>load_gui_status
      EXPORTING
        program    = sy-cprog
        status     = 'CT_MENU'
*       disable    =               "여기에 'X'값을 주면 그레이 상태가 됨
        menu       = e_object
      EXCEPTIONS
        read_error = 1
        OTHERS     = 2.
    IF sy-subrc <> 0.
* Implement suitable error handling here
    ENDIF.


    DATA : ls_col_id TYPE lvc_s_col,
           ls_row_id TYPE lvc_s_row.

    CALL METHOD go_alv_grid->get_current_cell    "Carrid 필드에서만 메뉴가 나타나게 메뉴 한줄 추가(get_current_cell 시용)
      IMPORTING
*       e_row     =
*       e_value   =
*       e_col     =
        es_row_id = ls_row_id
        es_col_id = ls_col_id.

    IF  ls_col_id-fieldname = 'CARRID'.

      CALL METHOD e_object->add_function
        EXPORTING
          fcode = 'DISP_CARR'
          text  = 'Display airline'
*         icon  =
*         ftype =
*         disabled          =
*         hidden            =
*         checked           =
*         accelerator       =
*         insert_at_the_top = SPACE
        .
    ELSE.
    ENDIF.




  ENDMETHOD.

  METHOD on_before_user_com.

    CASE e_ucomm.
      WHEN cl_gui_alv_grid=>mc_fc_detail.
        CALL METHOD go_alv_grid->set_user_command
          EXPORTING
            i_ucomm = 'SCHE'.
    ENDCASE.

  ENDMETHOD.



ENDCLASS.
