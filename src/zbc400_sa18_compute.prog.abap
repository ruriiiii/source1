*&---------------------------------------------------------------------*
*& Report ZBC400_SA18_COMPUTE
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zbc400_sa18_compute.

PARAMETERS pa_int1 TYPE i.
PARAMETERS pa_int2 TYPE i.
PARAMETERS pa_op.

DATA gv_result TYPE p LENGTH 16 DECIMALS 2.

IF pa_op = '+' OR pa_op = '-' OR pa_op = '*' OR pa_op = '/'.

  CASE pa_op.
  WHEN '+'.
   gv_result = pa_int1 + pa_int2.
   WRITE gv_result.
   CLEAR gv_result.
  WHEN '-'.
   gv_result = pa_int1 - pa_int2.
   WRITE gv_result.
   CLEAR gv_result.
  WHEN '*'.
   gv_result = pa_int1 * pa_int2.
   WRITE gv_result.
   CLEAR gv_result.
  WHEN '/'.
   IF pa_int2 = 0.
    WRITE 'Error!'.

   ELSE.
   gv_result = pa_int1 / pa_int2.
   WRITE gv_result.
   CLEAR gv_result.
   ENDIF.
 ENDCASE.

  ELSE.
    WRITE 'Error!'.
ENDIF.
