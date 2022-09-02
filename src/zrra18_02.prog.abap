*&---------------------------------------------------------------------*
*& Report ZRRA18_02
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zrra18_02 MESSAGE-ID zmcsa18.


*TABLES sbuspart.    "select-options로 쓰기 위해서 꼭 선언해줘야함.
*
*SELECTION-SCREEN BEGIN OF BLOCK bl1 WITH FRAME TITLE TEXT-t01.
*  PARAMETERS pa_bus TYPE sbuspart-buspartnum OBLIGATORY.
*  SELECT-OPTIONS so_con FOR sbuspart-contact NO INTERVALS.
*
*  SELECTION-SCREEN ULINE.
*
*  PARAMETERS pa_ta RADIOBUTTON GROUP rg1 DEFAULT 'X' MODIF ID gr1.
*  PARAMETERS pa_fc RADIOBUTTON GROUP rg1 MODIF ID gr1.
*SELECTION-SCREEN END OF BLOCK bl1.
*
*
*
*
*DATA: gs_sb TYPE sbuspart,
*      gt_sb LIKE TABLE OF gs_sb.
*
*DATA gv_type TYPE sbuspart-buspatyp.  "케이스문의 sql문을 하나로 합치기 위한 변수 선언
*
*REFRESH gt_sb.
*
*
*
*CASE 'X'.
*
*  WHEN pa_ta.
*    SELECT buspartnum contact contphono buspatyp
*    FROM sbuspart
*    INTO CORRESPONDING FIELDS OF TABLE gt_sb
*    WHERE buspartnum = pa_bus
*     AND contact IN so_con
*     AND buspatyp = 'TA'.
*
*
*  WHEN pa_fc.
*    SELECT buspartnum contact contphono buspatyp
*    FROM sbuspart
*    INTO CORRESPONDING FIELDS OF TABLE gt_sb
*    WHERE buspartnum = pa_bus
*     AND contact IN so_con
*     AND buspatyp = 'FC'.
*
*ENDCASE.
*
*"--------------------------------------------------위 아래 결과 동일
*CASE 'X'.
*  WHEN pa_ta.
*    gv_type = 'TA'.
*
*  WHEN pa_fc.
*    gv_type = 'FC'.
*ENDCASE.
*
*SELECT buspartnum contact contphono buspatyp
*    FROM sbuspart
*    INTO CORRESPONDING FIELDS OF TABLE gt_sb
*    WHERE buspartnum = pa_bus
*     AND contact IN so_con
*     AND buspatyp = gv_type.


"------------------------------------------------------------------------


*TABLES sbook.
*
*SELECTION-SCREEN BEGIN OF BLOCK bl1 WITH FRAME TITLE TEXT-t02.
*
*  PARAMETERS     pa_car TYPE sbook-carrid DEFAULT 'AA' OBLIGATORY.
*
*  SELECT-OPTIONS so_con FOR sbook-connid OBLIGATORY.
*
*  PARAMETERS     pa_cus TYPE sbook-custtype AS LISTBOX VISIBLE LENGTH 15 DEFAULT 'P' OBLIGATORY.
*
*  SELECT-OPTIONS: so_fld  FOR sbook-fldate DEFAULT sy-datum,  "sy-datlo : 현지날짜, sap가 깔려있는 서버의 날짜
*                  so_bid  FOR sbook-bookid,
*                  so_ctid FOR sbook-customid NO INTERVALS NO-EXTENSION.
*
*SELECTION-SCREEN END OF BLOCK bl1.
*
*DATA: BEGIN OF gs_sbook,
*        carrid   TYPE sbook-carrid,
*        connid   TYPE sbook-connid,
*        fldate   TYPE sbook-fldate,
*        bookid   TYPE sbook-bookid,
*        customid TYPE sbook-customid,
*        custtype TYPE sbook-custtype,
*        invoice  TYPE sbook-invoice,
*        class    TYPE sbook-class,
*      END OF gs_sbook,
*      gt_sbook LIKE TABLE OF gs_sbook.
*
*DATA lv_tabix TYPE sy-tabix.
*
*REFRESH gt_sbook.
*
*SELECT *
*  FROM sbook
*  INTO CORRESPONDING FIELDS OF TABLE gt_sbook
*  WHERE carrid   = pa_car
*    AND connid   IN so_con
*    AND custtype = pa_cus
*    AND fldate   IN so_fld
*    AND bookid   IN so_bid
*    AND customid IN so_ctid.
*
*IF sy-subrc NE 0.
*  MESSAGE s001.
*  STOP.
*ENDIF.
*
*
*LOOP AT gt_sbook INTO gs_sbook.
*  lv_tabix = sy-tabix.
*
*  IF gs_sbook-invoice = 'X'.
*     gs_sbook-class   = 'F'.
*
*    MODIFY gt_sbook FROM gs_sbook INDEX lv_tabix TRANSPORTING class.
*  ENDIF.
*  CLEAR gs_sbook.
*ENDLOOP.
*
*
*
*cl_demo_output=>display_data( gt_sbook ).

"-----------------------------------------------------------------------------------

TABLES sflight.
TABLES sbook.

SELECTION-SCREEN BEGIN OF BLOCK bl1 WITH FRAME TITLE TEXT-003.

  PARAMETERS pa_car TYPE sflight-carrid OBLIGATORY.
  SELECT-OPTIONS so_con FOR sflight-connid OBLIGATORY.
  PARAMETERS pa_ptype TYPE sflight-planetype AS LISTBOX VISIBLE LENGTH 15.
  SELECT-OPTIONS so_bkid FOR sbook-bookid.

SELECTION-SCREEN END OF BLOCK bl1.


DATA: BEGIN OF gs_tab1,
        carrid    TYPE sflight-carrid,
        connid    TYPE sflight-connid,
        fldate    TYPE sflight-fldate,
        planetype TYPE sflight-planetype,
        currency  TYPE sflight-currency,
        bookid    TYPE sbook-bookid,
        customid  TYPE sbook-customid,
        custtype  TYPE sbook-custtype,
        class     TYPE sbook-class,
        agencynum TYPE sbook-agencynum,
      END OF gs_tab1,
      gt_tab1 LIKE TABLE OF gs_tab1.


DATA: BEGIN OF gs_tab2,
        carrid    TYPE sflight-carrid,
        connid    TYPE sflight-connid,
        fldate    TYPE sflight-fldate,
        bookid    TYPE sbook-bookid,
        customid  TYPE sbook-customid,
        custtype  TYPE sbook-custtype,
        agencynum TYPE sbook-agencynum,
      END OF gs_tab2,
      gt_tab2 LIKE TABLE OF gs_tab2.

REFRESH: gt_tab1, gt_tab2.

SELECT a~carrid a~connid a~fldate a~planetype a~currency
       b~bookid b~customid b~custtype b~agencynum b~class
  FROM sflight AS a INNER JOIN sbook AS b
                                ON a~carrid = b~carrid
                                AND a~connid = b~connid
                                AND a~fldate = b~fldate
  INTO CORRESPONDING FIELDS OF TABLE gt_tab1
  WHERE a~carrid = pa_car
    AND a~connid IN so_con
    AND a~planetype = pa_ptype
    AND b~bookid IN so_bkid.

IF sy-subrc NE 0.
  MESSAGE s001.
  STOP.
ENDIF.


LOOP AT gt_tab1 INTO gs_tab1.

  IF gs_tab1-custtype = 'B'.
    MOVE-CORRESPONDING gs_tab1 TO gs_tab2.
    APPEND gs_tab2 TO gt_tab2.
  ENDIF.

  CLEAR gs_tab2.

ENDLOOP.


SORT gt_tab2 BY carrid connid fldate.
DELETE ADJACENT DUPLICATES FROM gt_tab2 COMPARING carrid connid fldate. "정렬한 순서와 comparing순서가 같아야함




*cl_demo_output=>display_data( gt_tab1 ).
cl_demo_output=>display_data( gt_tab2 ).
