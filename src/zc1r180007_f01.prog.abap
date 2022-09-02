*&---------------------------------------------------------------------*
*& Include          ZC1R180007_F01
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

    gs_variant-report = sy-repid.

    SET HANDLER : lcl_event_handler=>handle_data_changed FOR gcl_grid,
                   lcl_event_handler=>handle_changed_finished FOR gcl_grid.

    CALL METHOD gcl_grid->register_edit_event
      EXPORTING
        i_event_id = cl_gui_alv_grid=>mc_evt_modified
      EXCEPTIONS
        error      = 1
        OTHERS     = 2.



    CALL METHOD gcl_grid->set_table_for_first_display
      EXPORTING
        is_variant      = gs_variant
        i_save          = 'A'
        i_default       = 'X'
        is_layout       = gs_layout
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
*  gs_layout-cwidth_opt = 'X'.
  gs_layout-sel_mode = 'D'.
  gs_layout-stylefname = 'STYLE'.


  IF gt_fcat IS INITIAL.
    PERFORM set_fcat USING :
          'X' 'PERNR'   ' '   'ZTSA1801'   'PERNR'  'X' 10,
          ' ' 'ENAME'   ' '   'ZTSA1801'   'ENAME'  'X' 20,
          ' ' 'ENTDT'   ' '   'ZTSA1801'   'ENTDT'  'X' 10,
          ' ' 'GENDER'  ' '   'ZTSA1801'   'GENDER' 'X' 5,
          ' ' 'DEPID'   ' '   'ZTSA1801'   'DEPID'  'X' 8,
          ' ' 'CARRID'   ' '   'SCARR'   'CARRID'  'X' 10,
          ' ' 'CARRNAME'   ' '   'SCARR'   'CARRNAME'  ' ' 20.



  ENDIF.



ENDFORM.
*&---------------------------------------------------------------------*
*& Form SET_FCAT
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*&      --> P_
*&      --> P_
*&      --> P_
*&      --> P_
*&      --> P_
*&---------------------------------------------------------------------*
FORM set_fcat  USING  pv_key
                      pv_field
                      pv_text
                      pv_ref_table
                      pv_ref_field
                      pv_edit
                      pv_length.

  gt_fcat = VALUE #( BASE gt_fcat
                    (
                   key     = pv_key
                   fieldname = pv_field
                   coltext   = pv_text
                   ref_table = pv_ref_table
                   ref_field = pv_ref_field
                   edit      = pv_edit
                   outputlen = pv_length
                     )
                   ).


ENDFORM.
*&---------------------------------------------------------------------*
*& Form GET_DATA
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM get_data .

  SELECT pernr ename entdt gender depid
    INTO CORRESPONDING FIELDS OF TABLE gt_data
    FROM ztsa1801
   WHERE pernr IN so_pernr.





ENDFORM.
*&---------------------------------------------------------------------*
*& Form SAVE_DATA
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM save_data .









ENDFORM.
*&---------------------------------------------------------------------*
*& Form CREATE_ROW
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM create_row .

  CLEAR gs_data.
  APPEND gs_data TO gt_data.

  PERFORM refresh_grid.



ENDFORM.
*&---------------------------------------------------------------------*
*& Form refresh_grid
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM refresh_grid .

  gs_stable-row = 'X'.
  gs_stable-col = 'X'.

  CALL METHOD gcl_grid->refresh_table_display
    EXPORTING
      is_stable      = gs_stable
      i_soft_refresh = space.





ENDFORM.
*&---------------------------------------------------------------------*
*& Form save_emp
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM save_emp .

  DATA : lt_save  TYPE TABLE OF ztsa1801,
         lt_del   TYPE TABLE OF ztsa1801,
         lv_error.

  REFRESH lt_save.

  CALL METHOD gcl_grid->check_changed_data. "ALV의 입력된 값을 인터널테이블로 반영시키는 메소드


  CLEAR lv_error.   "필수 입력값 입력 여부 체크
  LOOP AT gt_data INTO gs_data.

    IF gs_data-pernr IS INITIAL.
      MESSAGE s000 WITH TEXT-e01 DISPLAY LIKE 'E'.
      lv_error = 'X'.    "에러 발생했을 경우 저장 플로우 수행 방지를 위해 값을 세팅
      EXIT.              "현재 수행중인 루틴을 빠져나감 : 지금은 loop를 빠져나감
    ENDIF.



    lt_save = VALUE #( BASE lt_save    "에러없는 데이터는 저장할 인터널테이블에 데이터 저장
                        (
                          pernr  = gs_data-pernr
                          ename  = gs_data-ename
                          entdt  = gs_data-entdt
                          gender = gs_data-gender
                          depid  = gs_data-depid
                          )
                         ).

  ENDLOOP.

*  CHECK LV_ERROR IS INITIAL.   "에러가 없으면 아래 로직 수행
  IF lv_error IS NOT INITIAL.  "에러가 있으면 현재 루틴 빠져나감
    EXIT.
  ENDIF.

  IF gt_data_del IS NOT INITIAL.
    LOOP AT gt_data_del INTO DATA(ls_del).

      lt_del = VALUE #( BASE lt_del
                        ( pernr = ls_del-pernr )
                        ).
    ENDLOOP.

    DELETE ztsa1801 FROM TABLE lt_del.

    IF sy-dbcnt > 0.
      COMMIT WORK AND WAIT.
    ENDIF.




  ENDIF.



  IF lt_save IS NOT INITIAL.

    MODIFY ztsa1801 FROM TABLE lt_save.

    IF sy-dbcnt > 0.
      COMMIT WORK AND WAIT.
      MESSAGE s002.
    ENDIF.

  ENDIF.




ENDFORM.
*&---------------------------------------------------------------------*
*& Form delete_row
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM delete_row .

  REFRESH gt_rows.

  CALL METHOD gcl_grid->get_selected_rows   "사용자가 선택한 행의 정보 가져옴
    IMPORTING
      et_index_rows = gt_rows.

  IF gt_rows IS INITIAL.    "행을 선택했는지 체크
    MESSAGE s000 WITH TEXT-e02 DISPLAY LIKE 'E'.
    EXIT.
  ENDIF.

  SORT gt_rows BY index DESCENDING.    "엉뚱한 정보가 날아가지 않도록 정렬 필요

  LOOP AT gt_rows INTO gs_row.

    "인터널테이블에서 삭제하기 전에 DB테이블에서도 삭제해야 하므로 삭제 대상을 따로 보관
    READ TABLE gt_data INTO gs_data INDEX gs_row-index.  "선택한 행의 정보 조회

    IF sy-subrc = 0.
      APPEND gs_data TO gt_data_del.  "삭제 대상을 삭제, 인터널테이블에 보관
    ENDIF.

    DELETE gt_data INDEX gs_row-index.  "사용자가 선택한 행을 직접 삭제

  ENDLOOP.

  PERFORM refresh_grid.  "변경된 인터널테이블을 ALV에 반영



ENDFORM.
*&---------------------------------------------------------------------*
*& Form SET_STYLE
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM set_style .

  DATA : lv_tabix TYPE sy-tabix,
         ls_style TYPE lvc_s_styl,
         lt_style TYPE lvc_t_styl.

  "구문법
*   LS_STYLE-fieldname = 'PERNR'.
*   LS_STYLE-STYLE     = cl_gui_alv_grid=>MC_STYLE_DISABLED.
*   APPEND LS_STYLE TO LT_STYLE.
  "신문법(스트럭쳐 사용시)
*  ls_style = VALUE #( fieldname = 'PERNR'
*                      style = cl_gui_alv_grid=>mc_style_disabled  ).
*  APPEND LS_STYLE TO LT_STYLE.

  "신문법(인터널테이블만 사용시)
  lt_style = VALUE #(
                      ( fieldname = 'PERNR'
                    style = cl_gui_alv_grid=>mc_style_disabled
                       )
                      ).




  "TABLE에서 가지고 온 데이터의 PK 변경 방지를 위해서 편집 금지 모드 만들기
  LOOP AT gt_data INTO gs_data.
    lv_tabix = sy-tabix.

    REFRESH gs_data-style.

    APPEND LINES OF lt_style TO gs_data-style.
*     gs_emp-style = lt_style.
*    MOVE-CORRESPONDING lt_style TO gs_emp-style.

    MODIFY gt_data FROM gs_data INDEX lv_tabix TRANSPORTING style.

  ENDLOOP.


ENDFORM.
*&---------------------------------------------------------------------*
*& Form handle_data_changed
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*&      --> ER_DATA_CHANGED
*&---------------------------------------------------------------------*
FORM handle_data_changed  USING  pcl_data_changed TYPE REF TO
                                          cl_alv_changed_data_protocol.
*
*  LOOP AT pcl_data_changed->mt_mod_cells INTO DATA(ls_modi).
*
*    READ TABLE gt_data INTO gs_data INDEX ls_modi-row_id.
*
*    IF sy-subrc NE 0.
*      CONTINUE.
*    ENDIF.
*
*    SELECT SINGLE carrname
*      INTO gs_data-carrname
*      FROM scarr
*      WHERE carrid = ls_modi-value.  "NEW VALUE
*
*    IF sy-subrc NE 0.
*      CLEAR gs_data-carrname.
*    ENDIF.
*
*    MODIFY gt_data FROM gs_data INDEX ls_modi-row_id TRANSPORTING carrname.
*
*  ENDLOOP.
*
*  PERFORM refresh_grid.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form HANDLE_changed_finished
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*&      --> E_MODIFIED
*&      --> ET_GOOD_CELLS
*&---------------------------------------------------------------------*
FORM handle_changed_finished  USING    pv_modified
                                       pt_good_cells TYPE lvc_t_modi.

  LOOP AT pt_good_cells INTO DATA(ls_modi).
    READ TABLE gt_data INTO gs_data INDEX ls_modi-row_id.

    IF sy-subrc NE 0.
      CONTINUE.
    ENDIF.

    SELECT SINGLE carrname
      INTO gs_data-carrname
      FROM scarr
      WHERE carrid = GS_DATA-CARRID.

    IF sy-subrc NE 0.
      CLEAR gs_data-carrname.
    ENDIF.

    MODIFY gt_data FROM gs_data INDEX ls_modi-row_id TRANSPORTING carrname.

  ENDLOOP.

  PERFORM refresh_grid.


ENDFORM.
