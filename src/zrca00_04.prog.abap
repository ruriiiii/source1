*&---------------------------------------------------------------------*
*& Report ZRCA00_04
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zrca00_04.

PARAMETERS pa_car TYPE scarr-carrid. " Char 3
*PARAMETERS pa_car1 TYPE c LENGTH 3.

DATA gs_info TYPE scarr.

CLEAR gs_info.
SELECT SINGLE carrid carrname
  FROM scarr
  INTO CORRESPONDING FIELDS OF gs_info
*  INTO gs_info
 WHERE carrid = pa_car.

WRITE: gs_info-mandt, gs_info-carrid, gs_info-carrname.
