*&---------------------------------------------------------------------*
*& Include          ZRRA18_05_S01
*&---------------------------------------------------------------------*

SELECTION-SCREEN BEGIN OF BLOCK bl1 WITH FRAME TITLE TEXT-t01.
  SELECT-OPTIONS : so_carr FOR scarr-carrid,
                   so_conn FOR sflight-connid,
                   so_ptype FOR sflight-planetype NO INTERVALS NO-EXTENSION.
SELECTION-SCREEN END OF BLOCK bl1.
