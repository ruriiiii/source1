*&---------------------------------------------------------------------*
*& Include ZBC405_A18_EX01_TOP                      - Report ZBC405_A18_EX01
*&---------------------------------------------------------------------*
REPORT zbc405_a18_ex01.

DATA gs_flight TYPE dv_flights.

SELECT-OPTIONS : so_car FOR gs_flight-carrid,
                 so_con FOR gs_flight-connid,
                 so_dat FOR gs_flight-fldate.



SELECTION-SCREEN BEGIN OF BLOCK radio WITH FRAME.
  PARAMETERS: p_rad1 RADIOBUTTON GROUP rd1,
              p_rad2 RADIOBUTTON GROUP rd1,
              p_rad3 RADIOBUTTON GROUP rd1.
SELECTION-SCREEN END OF BLOCK radio.
