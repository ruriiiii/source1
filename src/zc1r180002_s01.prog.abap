*&---------------------------------------------------------------------*
*& Include          ZC1R180002_S01
*&---------------------------------------------------------------------*

SELECTION-SCREEN BEGIN OF BLOCK bl1 WITH FRAME TITLE TEXT-t01.
  PARAMETERS pa_werks TYPE marc-werks.
  SELECT-OPTIONS: so_matnr FOR mara-matnr,
                  so_mtart FOR mara-mtart,
                  so_ekgrp FOR marc-ekgrp.
SELECTION-SCREEN END OF BLOCK bl1.
