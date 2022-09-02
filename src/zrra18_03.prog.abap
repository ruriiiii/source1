*&---------------------------------------------------------------------*
*& Report ZRRA18_03
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zrra18_03.

TABLES : sflight, sbook.

SELECTION-SCREEN BEGIN OF BLOCK bl1 WITH FRAME TITLE TEXT-t01.
  PARAMETERS     : pa_carr TYPE sflight-carrid OBLIGATORY.
  SELECT-OPTIONS : so_conn FOR  sflight-connid OBLIGATORY.
  PARAMETERS     : pa_pltp TYPE sflight-planetype AS LISTBOX
                   VISIBLE LENGTH 10.
  SELECT-OPTIONS : so_bkid FOR  sbook-bookid.
SELECTION-SCREEN END OF BLOCK bl1.


AT SELECTION-SCREEN ON VALUE-REQUEST FOR pa_carr.
  PERFORM f4_carrid.

AT SELECTION-SCREEN ON VALUE-REQUEST FOR so_bkid-low.
  "select option에 f4기능을 먹일때는 low나 high를 지정해줘야 됨.



*&---------------------------------------------------------------------*
*& Form f4_carrid
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM f4_carrid .
    DATA : BEGIN OF ls_carrid,
           carrid   TYPE scarr-carrid,
           carrname TYPE scarr-carrname,
           currcode TYPE scarr-currcode,
           url      TYPE scarr-url,
         END OF ls_carrid,

         lt_carrid LIKE TABLE OF ls_carrid.

  REFRESH lt_carrid.

  SELECT carrid carrname currcode url
    INTO CORRESPONDING FIELDS OF TABLE lt_carrid
    FROM scarr.

  CALL FUNCTION 'F4IF_INT_TABLE_VALUE_REQUEST'
    EXPORTING
      retfield     = 'CARRID'   "선택하면 화면으로 세팅할 ITAB의 필드ID
      dynpprog     = sy-repid
      dynpnr       = sy-dynnr
      dynprofield  = 'PA_CARR'  "서치헬프 화면에서 선택한 데이터가 세팅될 화면의 필드ID
*     WINDOW_TITLE = TEXT-t02
      window_title = 'Airline List'
      value_org    = 'S'
*     DISPLAY      = ' ' "'X'값을 줄 경우, 선택한 데이터가 세팅될 화면의 필드에 세팅 되는것을 막음.
    TABLES
      value_tab    = lt_carrid.

ENDFORM.
