*&---------------------------------------------------------------------*
*& Report ZRSA18_32
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zrsa18_32.

"Emp Info
DATA gs_emp TYPE zssa1810.

PARAMETERS pa_pernr LIKE gs_emp-pernr.

INITIALIZATION.
 pa_pernr = '22020001'.

START-OF-SELECTION.
  SELECT SINGLE *
    FROM ztsa1801 "Employee Table
  INTO CORRESPONDING FIELDS OF gs_emp
  WHERE pernr = pa_pernr.

*IF gs_emp IS INITIAL.
*  MESSAGE i016(pn) WITH 'Data is not found.'.
*RETURN.
*ENDIF.

IF sy-subrc <> 0.
  "Data is not found
  MESSAGE i001(zmcsa18).
RETURN.
ENDIF.

*WRITE gs_emp-depid.    "일반변수
*new-LINE.
*WRITE gs_emp-dep-depid.    "structure type

SELECT SINGLE *
  FROM ztsa1802_2
  into gs_emp-dep
  where depid = gs_emp-depid.

 cl_demo_output=>display_data( gs_emp-dep ).
