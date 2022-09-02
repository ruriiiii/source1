*&---------------------------------------------------------------------*
*& Report ZRRA18_01
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zrra18_01 MESSAGE-ID zmcsa18.

*Data: gv_a type c LENGTH 20,   "= gv_a(20) // CHAR타입의 길이 20의 변수
*      gv_b type p LENGTH 5 DECIMALS 2, "=gv_b(5) type p decimals 2 // 소수점 2자리를 가진 5자리의 변수
*      gv_c type n LENGTH 8. "00000678이 나올 수 있는 변수
*
*Data: gv_d type c LENGTH 10,
*      gv_e type n LENGTH 10,
*      gv_f type i,
*      gv_g type i DECIMALS 2.


*DATA gs_a TYPE ztsa1801.
*DATA gt_a LIKE TABLE OF gs_a.
*
*DATA: BEGIN OF gs_c,
*        matnr TYPE mara-matnr,
*        werks TYPE marc-werks,
*        mtart TYPE mara-mtart,
*        matkl TYPE mara-matkl,
*        ekgrp TYPE marc-ekgrp,
*        pstat TYPE marc-pstat.
*DATA: END OF gs_c.
*
*
*
*DATA gt_c LIKE TABLE OF gs_c.




*TYPES: BEGIN OF ty_d,
*         matnr TYPE mara-matnr,
*         werks TYPE marc-werks,
*         mtart TYPE mara-mtart,
*         matkl TYPE mara-matkl,
*         ekgrp TYPE marc-ekgrp,
*         pstat TYPE marc-pstat.
*TYPES: END OF ty_d.
*
*DATA gs_e TYPE ty_d.
*DATA gt_e LIKE TABLE OF gs_e.



"------------------------------------------------
*DATA: gs_sbook TYPE sbook,
*      gt_sbook LIKE TABLE OF gs_sbook,
*      lv_tabix type sy-tabix. "sy-tabix가 로직이 추가되면서 바뀔수 있어서 따로 변수 선언
*
*clear gs_sbook.
*refresh gt_sbook.
*
*SELECT carrid connid fldate bookid customid custtype invoice class smoker
*  FROM sbook
*  INTO CORRESPONDING FIELDS OF TABLE gt_sbook
*  WHERE carrid = 'DL'
*    AND custtype = 'P'
*    AND order_date = '20201227'.
*
*  if sy-subrc ne 0.
*    MESSAGE s001.
*    LEAVE TO LIST-PROCESSING.   "=stop
*  ENDIF.
*
*LOOP AT gt_sbook INTO gs_sbook.
*  lv_tabix = lv-tabix.
*
*  IF gs_sbook-smoker = 'X' AND gs_sbook-invoice = 'X'.
*    gs_sbook-class = 'F'.
*  ELSE.
*  ENDIF.
*
*  MODIFY gt_sbook FROM gs_sbook INDEX lv-tabix  "modify를 더 안전하게 쓰는 방법
*  TRANSPORTING class.  "class필드만 변경하겠다
*ENDLOOP.
*
* cl_demo_output=>display_data( gt_sbook ).

"------------------------------------------------

*DATA: BEGIN OF gs_fl,
*        carrid     TYPE sflight-carrid,
*        connid     TYPE sflight-connid,
*        fldate     TYPE sflight-fldate,
*        currency   TYPE sflight-currency,
*        planetype  TYPE sflight-planetype,
*        seatsocc_b TYPE sflight-seatsocc_b,
*      END OF gs_fl,
*      gt_fl LIKE TABLE OF gs_fl.
*
*DATA lv_tabix TYPE sy-tabix.
*
*SELECT  carrid connid fldate currency planetype seatsocc_b
*  FROM  sflight
*  INTO CORRESPONDING FIELDS OF TABLE gt_fl
*  WHERE currency  = 'KRW'
*    AND planetype = '747-400'.
*
*LOOP AT gt_fl INTO gs_fl.
*  lv_tabix = sy-tabix.
*  CASE 'CARRID'.
*    WHEN 'UA'.
*      gs_fl-seatsocc_b = gs_fl-seatsocc_b + 5.
*
*  ENDCASE.
*
*  MODIFY gt_fl FROM gs_fl INDEX lv_tabix.
*ENDLOOP.
*
*
*
*cl_demo_output=>display_data( gt_fl ).
"--------------------------------------------------------------

*DATA: BEGIN OF gs_fl,
*        carrid     TYPE sflight-carrid,
*        connid     TYPE sflight-connid,
*        fldate     TYPE sflight-fldate,
*        currency   TYPE sflight-currency,
*        planetype  TYPE sflight-planetype,
*        seatsocc_b TYPE sflight-seatsocc_b,
*      END OF gs_fl,
*      gt_fl LIKE TABLE OF gs_fl.
*
*DATA lv_tabix TYPE sy-tabix.
*
*SELECT carrid connid fldate currency planetype seatsocc_b
*  FROM sflight
*  INTO CORRESPONDING FIELDS OF TABLE gt_fl
*  WHERE currency = 'USD'
*   AND planetype = '747-400'.
*
*LOOP AT gt_fl INTO gs_fl.
*  lv_tabix = sy-tabix.
*
*  IF gs_fl-carrid = 'UA'.
*    gs_fl-seatsocc_b = gs_fl-seatsocc_b + 5.
*  ENDIF.
*  MODIFY gt_fl FROM gs_fl INDEX lv_tabix.
*ENDLOOP.
*
*cl_demo_output=>display_data( gt_fl ).

"----------------------------------------------------------
*
*DATA: BEGIN OF gs_mara,
*        matnr TYPE mara-matnr,
*        maktx TYPE makt-maktx,
*        mtart TYPE mara-mtart,
*        matkl TYPE mara-matkl,
*      END OF gs_mara,
*      gt_mara LIKE TABLE OF gs_mara.
*
*DATA: BEGIN OF gs_makt,
*        matnr TYPE makt-matnr,
*        maktx TYPE makt-maktx,
*      END OF gs_makt,
*      gt_makt LIKE TABLE OF gs_makt.
*
*DATA lv_tabix TYPE sy-tabix.
*
*SELECT matnr mtart matkl
*  FROM mara
*  INTO CORRESPONDING FIELDS OF TABLE gt_mara.
*
*
*SELECT matnr maktx
*  FROM makt
*  INTO CORRESPONDING FIELDS OF TABLE gt_makt
*  WHERE spras = sy-langu.
*
*
*
*LOOP AT gt_mara INTO gs_mara.
*  lv_tabix = sy-tabix.
*
*  READ TABLE gt_makt INTO gs_makt WITH KEY matnr = gs_mara-matnr.
*
*  gs_mara-maktx = gs_makt-maktx.
*
*  MODIFY gt_mara FROM gs_mara INDEX lv_tabix TRANSPORTING maktx.
*
*ENDLOOP.
*
*
*
*
*cl_demo_output=>display_data( gt_mara ).
*cl_demo_output=>display_data( gt_makt ).

"------------------------------------------------------------------

*DATA: BEGIN OF gs_spfli,
*        carrid   TYPE spfli-carrid,
*        carrname TYPE scarr-carrname,
*        url      TYPE scarr-url,
*        connid   TYPE spfli-connid,
*        airpfrom TYPE spfli-airpfrom,
*        airpto   TYPE spfli-airpto,
*        deptime  TYPE spfli-deptime,
*        arrtime  TYPE spfli-arrtime,
*      END OF gs_spfli,
*      gt_spfli LIKE TABLE OF gs_spfli.
*
*DATA: BEGIN OF gs_scarr,
*        carrid   TYPE scarr-carrid,
*        carrname TYPE scarr-carrname,
*        url      TYPE scarr-url,
*      END OF gs_scarr,
*      gt_scarr LIKE TABLE OF gs_scarr.
*
*DATA lv_tabix TYPE sy-tabix.
*
*REFRESH: gt_spfli, gt_scarr.
*
*SELECT *
*  FROM spfli
*  INTO CORRESPONDING FIELDS OF TABLE gt_spfli.
*
*IF sy-subrc NE 0.
*  MESSAGE s001.
*  LEAVE TO LIST-PROCESSING.
*ENDIF.
*
*
*SELECT *
*  FROM scarr
*  INTO CORRESPONDING FIELDS OF TABLE gt_scarr.
*
*IF sy-subrc NE 0.
*  MESSAGE s001.
*  LEAVE TO LIST-PROCESSING.
*ENDIF.
*
*
*LOOP AT gt_spfli INTO gs_spfli.
*  lv_tabix = sy-tabix.
*
*  READ TABLE gt_scarr INTO gs_scarr WITH KEY carrid = gs_spfli-carrid.
*
*  gs_spfli-carrname = gs_scarr-carrname.
*  gs_spfli-url      = gs_scarr-url.
*
*  MODIFY gt_spfli FROM gs_spfli INDEX lv_tabix TRANSPORTING carrname url.
*
*  CLEAR: gs_spfli, gs_scarr.
*ENDLOOP.



*cl_demo_output=>display_data( gt_spfli ).
*cl_demo_output=>display_data( gt_scarr ).

"------------------------------------------------------------------------
*
*DATA: BEGIN OF gs_data,
*        matnr TYPE mara-matnr,
*        maktx TYPE makt-maktx,
*        mtart TYPE mara-mtart,
*        mtbez TYPE t134t-mtbez,
*        mbrsh TYPE mara-mbrsh,
*        mbbez TYPE t137t-mbbez,
*        tragr TYPE mara-tragr,
*        vtext TYPE ttgrt-vtext,
*      END OF gs_data,
*      gt_data LIKE TABLE OF gs_data.
*
*
*DATA: gs_mtbez TYPE t134t,
*      gt_mtbez LIKE TABLE OF gs_mtbez.
*
*DATA: gs_mbbez TYPE t137t,
*      gt_mbbez LIKE TABLE OF gs_mbbez.
*
*DATA: gs_vtext TYPE ttgrt,
*      gt_vtext LIKE TABLE OF gs_vtext.
*
*DATA lv_tabix TYPE sy-tabix.
*
*
*
*SELECT *
*  FROM mara INNER JOIN makt ON mara~matnr = makt~matnr
*  INTO CORRESPONDING FIELDS OF TABLE gt_data.
*
*SELECT *
*  FROM t134t
*  INTO CORRESPONDING FIELDS OF TABLE gt_mtbez
*  WHERE spras = sy-langu.
*
*SELECT *
*  FROM t137t
*  INTO CORRESPONDING FIELDS OF TABLE gt_mbbez
*  WHERE spras = sy-langu.
*
*SELECT *
*  FROM ttgrt
*  INTO CORRESPONDING FIELDS OF TABLE gt_vtext
*  WHERE spras = sy-langu.
*
*
*LOOP AT gt_data INTO gs_data.
*  lv_tabix = sy-tabix.
*
*  READ TABLE gt_mtbez INTO gs_mtbez WITH KEY mtart = gs_data-mtart.
*  gs_data-mtbez = gs_mtbez-mtbez.
*
*  READ TABLE gt_mbbez INTO gs_mbbez WITH KEY mbrsh = gs_data-mbrsh.
*  gs_data-mbbez = gs_mbbez-mbbez.
*
*  READ TABLE gt_vtext INTO gs_vtext WITH KEY tragr = gs_data-tragr.
*  gs_data-vtext = gs_vtext-vtext.
*
*
*  MODIFY gt_data FROM gs_data INDEX lv_tabix TRANSPORTING mtbez mbbez vtext.
*
*  CLEAR: gs_data, gs_mtbez, gs_mbbez, gs_vtext.
*ENDLOOP.
*
*
*
*
*cl_demo_output=>display_data( gt_data ).

"-------------------------------------------------------------

DATA: BEGIN OF gs_data,
        ktopl TYPE ska1-ktopl,
        ktplt TYPE t004t-ktplt,
        saknr TYPE ska1-saknr,
        txt20 TYPE skat-txt20,
        ktoks TYPE ska1-ktoks,
        txt30 TYPE t077z-txt30,
      END OF gs_data,
      gt_data LIKE TABLE OF gs_data.

DATA: gs_ktplt TYPE t004t,
      gt_ktplt LIKE TABLE OF gs_ktplt.

DATA: gs_txt20 TYPE skat,
      gt_txt20 LIKE TABLE OF gs_txt20.

DATA: gs_txt30 TYPE t077z,
      gt_txt30 LIKE TABLE OF gs_txt30.

DATA lv_tabix TYPE sy-tabix.

SELECT *
  FROM ska1
  INTO CORRESPONDING FIELDS OF TABLE gt_data
  WHERE ktopl = 'WEG'.

SELECT *
  FROM t004t
  INTO CORRESPONDING FIELDS OF TABLE gt_ktplt
  WHERE spras = sy-langu.

SELECT *
  FROM skat
  INTO CORRESPONDING FIELDS OF TABLE gt_txt20
  WHERE spras = sy-langu.

SELECT *
  FROM t077z
  INTO CORRESPONDING FIELDS OF TABLE gt_txt30
  WHERE spras = sy-langu.



LOOP AT gt_data INTO gs_data.
  lv_tabix = sy-tabix.

  READ TABLE gt_ktplt INTO gs_ktplt WITH KEY ktopl = gs_data-ktopl.
  IF sy-subrc = 0.
    gs_data-ktplt = gs_ktplt-ktplt.
  ENDIF.

  READ TABLE gt_txt20 INTO gs_txt20 WITH KEY saknr = gs_data-saknr.
  IF sy-subrc = 0.
    gs_data-txt20 = gs_txt20-txt20.
  ENDIF.

  READ TABLE gt_txt30 INTO gs_txt30 WITH KEY ktoks = gs_data-ktoks.
  IF sy-subrc = 0.
    gs_data-txt30 = gs_txt30-txt30.
  ENDIF.



  MODIFY gt_data FROM gs_data INDEX lv_tabix TRANSPORTING ktplt txt20 txt30.

  CLEAR: gs_data, gs_ktplt, gs_txt20, gs_txt30.

ENDLOOP.





cl_demo_output=>display_data( gt_data ).
