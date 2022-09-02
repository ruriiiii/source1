*&---------------------------------------------------------------------*
*& Report ZRSA00_14
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zrsa00_14.

"Transparent Table  = Structure Type
DATA gs_scarr TYPE scarr.

PARAMETERS pa_carr LIKE gs_scarr-carrid.

SELECT SINGLE  *
  FROM scarr
  INTO CORRESPONDING FIELDS OF gs_scarr
*  INTO gs_scarr
 WHERE carrid = pa_carr.

WRITE: gs_scarr-carrid, gs_scarr-carrname, gs_scarr-currcode.


*TYPES: BEGIN OF ts_cat,
*         home TYPE c LENGTH 10,
*         name TYPE c LENGTH 10,
*         age  TYPE i,
*       END OF ts_cat.
*
*DATA gs_cat TYPE ts_cat.
**DATA xxx TYPE ts_cat-age.
**DATA xxx LIKE gs_cat-age.
**DATA xxx LIKE gs_cat.
*
**DATA: gv_cat_name TYPE c LENGTH 10,
**      gv_cat_age  TYPE i.
**
**DATA: BEGIN OF gs_cat,
**        name TYPE c LENGTH 10,
**        age  TYPE i,
**      END OF gs_cat.
*
**WRITE gs_cat-age.
*gs_cat-age = 2.
*IF gs_cat IS NOT INITIAL.
*  WRITE 'Check'.
*ENDIF.
