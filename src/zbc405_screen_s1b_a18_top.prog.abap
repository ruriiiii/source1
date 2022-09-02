*&---------------------------------------------------------------------*
*& Include BC405_SCREEN_S1B_TOP                                        *
*&---------------------------------------------------------------------*
Report ZBC405_SCREEN_S1B_A18.
* Workarea for data fetch
DATA: gs_flight TYPE dv_flights.
TABLES sscrfields.
Data gv_switch.

* Constant for CASE statement
CONSTANTS gc_mark VALUE 'X'.

* Selections for connections
SELECTION-SCREEN BEGIN OF SCREEN 1100 AS SUBSCREEN.
  SELECT-OPTIONS: so_car FOR gs_flight-carrid MEMORY ID car,
                  so_con FOR gs_flight-connid.
SELECTION-SCREEN END OF SCREEN 1100.

* Selections for flights
SELECTION-SCREEN BEGIN OF SCREEN 1200 AS SUBSCREEN.
  SELECT-OPTIONS so_fdt FOR gs_flight-fldate NO-EXTENSION.
SELECTION-SCREEN END OF SCREEN 1200.

* Output parameter
SELECTION-SCREEN BEGIN OF SCREEN 1300 AS SUBSCREEN.
  SELECTION-SCREEN BEGIN OF BLOCK radio WITH FRAME.
    PARAMETERS: pa_all RADIOBUTTON GROUP rbg1,
                pa_nat RADIOBUTTON GROUP rbg1,
                pa_int RADIOBUTTON GROUP rbg1 DEFAULT 'X'.
  SELECTION-SCREEN END OF BLOCK radio.
SELECTION-SCREEN END OF SCREEN 1300.

"1400스크린 추가
SELECTION-SCREEN BEGIN OF SCREEN 1400 AS SUBSCREEN.
  SELECT-OPTIONS: so_cofr FOR gs_flight-countryfr MODIF ID det,
                  so_cifr FOR gs_flight-cityfrom MODIF ID det.     "so_cofr, so_cifr 를 'det'로 그룹화해준 것

 SELECTION-SCREEN skip 2.
 SELECTION-SCREEN PUSHBUTTON pos_low(20) push_but USER-COMMAND detail.
SELECTION-SCREEN END OF SCREEN 1400.




SELECTION-SCREEN BEGIN OF TABBED BLOCK airlines
  FOR 5 LINES.
  SELECTION-SCREEN TAB (20) tab1 USER-COMMAND conn
    DEFAULT SCREEN 1100.
  SELECTION-SCREEN TAB (20) tab2 USER-COMMAND date
    DEFAULT SCREEN 1200.
  SELECTION-SCREEN TAB (20) tab3 USER-COMMAND type
    DEFAULT SCREEN 1300.
  selection-screen tab (20) tab4 USER-COMMAND cont
    DEFAULT screen 1400.
SELECTION-SCREEN END OF BLOCK airlines .
