*&---------------------------------------------------------------------*
*& Include ZBC405_A18_M04_TOP                       - Report ZBC405_A18_M04
*&---------------------------------------------------------------------*
REPORT zbc405_a18_m04.

SELECTION-SCREEN BEGIN OF BLOCK bll WITH FRAME. " title text-t03.
  SELECTION-SCREEN BEGIN OF LINE.
    SELECTION-SCREEN COMMENT 3(8) TEXT-t01 FOR FIELD pa_rad1.   "for FIELD pa_rad1를 써줌으로써 텍스트와 버튼을 하나로 연결. 글자를 클릭해도 버튼 체크 가능!
    SELECTION-SCREEN POSITION 1.  "라디오버튼 위치 왼쪽으로 변경
    PARAMETERS pa_rad1 RADIOBUTTON GROUP rg1 MODIF ID gr1.
    SELECTION-SCREEN COMMENT pos_low(9) TEXT-t02 FOR FIELD pa_rad2.  "pos_low:셀렉트옵션스의 왼쪽    pos_high:셀렉트옵션스의 오른쪽
    PARAMETERS   pa_rad2 RADIOBUTTON GROUP rg1 MODIF ID gr1.
  SELECTION-SCREEN END OF LINE.
SELECTION-SCREEN END OF BLOCK bll.


TABLES: sflight, sscrfields.


*SELECTION-SCREEN skip 1.
SELECTION-SCREEN PUSHBUTTON /1(10) gv_text USER-COMMAND on.

DATA gv_chg TYPE c LENGTH 1.


"Subscreen
SELECTION-SCREEN BEGIN OF SCREEN 1100 AS SUBSCREEN.
  PARAMETERS pa_car type sflight-carrid.
SELECTION-SCREEN END OF SCREEN 1100.

SELECTION-SCREEN BEGIN OF SCREEN 1200 AS SUBSCREEN.
  SELECT-OPTIONS so_fid FOR sflight-fldate.
SELECTION-SCREEN END OF SCREEN 1200.





"Tab Strip
SELECTION-SCREEN BEGIN OF TABBED BLOCK ts_info FOR 5 LINES.
  SELECTION-SCREEN TAB (10) tab1 USER-COMMAND car DEFAULT SCREEN 1100.
  SELECTION-SCREEN TAB (10) tab2 USER-COMMAND fid DEFAULT SCREEN 1200.
SELECTION-SCREEN END OF BLOCK ts_info.
