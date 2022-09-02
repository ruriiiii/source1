*&---------------------------------------------------------------------*
*& Report ZRSA00_01
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zrsa00_01.

PARAMETERS: pa_carr TYPE scarr-carrid.
*PARAMETERS pa_carr TYPE c LENGTH 3.

DATA gs_scarr TYPE scarr.

SELECT SINGLE *
  FROM scarr
  INTO gs_scarr
 WHERE carrid = pa_carr.
IF sy-subrc IS NOT INITIAL.

ELSE.

ENDIF.
*IF sy-subrc = 0.
*IF sy-subrc IS INITIAL.
*  NEW-LINE.
*  WRITE: gs_scarr-carrid, gs_scarr-carrname,
*         gs_scarr-url.
*ELSE.
*  WRITE 'Sorry, no data found!'(m01).
**  WRITE TEXT-m01."Sorry, no data found!
**  MESSAGE 'Sorry, no data found!' TYPE 'I'.
*ENDIF.
