*&---------------------------------------------------------------------*
*& Include          ZRRA18_06_S01
*&---------------------------------------------------------------------*

SELECTION-SCREEN BEGIN OF BLOCK bl1 WITH FRAME TITLE TEXT-t01.
  PARAMETERS     : pa_bukrs TYPE bkpf-bukrs DEFAULT '1010',
                   pa_gjahr TYPE bkpf-gjahr.
  SELECT-OPTIONS : so_belnr FOR bkpf-belnr,
                   so_blart FOR bkpf-blart.
SELECTION-SCREEN END OF BLOCK bl1.
