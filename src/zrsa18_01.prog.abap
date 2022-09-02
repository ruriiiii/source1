*&---------------------------------------------------------------------*
*& Report ZRSA18_01
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zrsa18_01.



PARAMETERS pa_carr TYPE scarr-carrid.


DATA gs_scarr TYPE scarr.

PERFORM get_data.


*&---------------------------------------------------------------------*
*& Form get_data
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM get_data .
  SELECT SINGLE * FROM scarr
                INTO gs_scarr
                WHERE carrid = pa_carr.

IF sy-subrc IS NOT INITIAL.

ELSE.

ENDIF.



  IF sy-subrc = 0.
  IF sy-subrc IS INITIAL.

 NEW-LINE.

 WRITE: gs_scarr-carrid,
        gs_scarr-carrname,
        gs_scarr-url.
  ELSE.

    WRITE 'Sorry, no data found!'(M01).
*    WRITE text-m01."Sorry, no data found!
*  MESSAGE 'Sorry, no data found!' TYPE 'I'.

  ENDIF.
ENDFORM.
