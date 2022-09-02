*&---------------------------------------------------------------------*
*& Report ZRSA18_12
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zrsa18_12.

DATA gv_carrname TYPE scarr-carrname.
PARAMETERS pa_carr TYPE scarr-carrid.


PERFORM airline USING pa_carr
                CHANGING gv_carrname.


WRITE gv_carrname.
*&---------------------------------------------------------------------*
*& Form airline
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM airline USING p_code
              " CHANGING VALUE(p_carrname).
              CHANGING p_carrname.
  p_code = 'UA'.
SELECT SINGLE carrname
  FROM scarr
  INTO p_carrname
  WHERE carrid = p_code.
  WRITE 'Test pa_carr:'.
  WRITE pa_carr.

ENDFORM.
