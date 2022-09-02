*&---------------------------------------------------------------------*
*& Include          ZC1R180004_S01
*&---------------------------------------------------------------------*

SELECTION-SCREEN BEGIN OF BLOCK bl1 WITH FRAME TITLE TEXT-t01.
  PARAMETERS     : werks TYPE mast-werks DEFAULT '1010' OBLIGATORY.
  SELECT-OPTIONS : matnr FOR mast-matnr.
SELECTION-SCREEN END OF BLOCK bl1.
