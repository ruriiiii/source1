*&---------------------------------------------------------------------*
*& Report ZRSA00_32
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zrsa00_32.

" Emp Info
*DATA gs_emp TYPE zssa0010.
DATA gs_emp TYPE zssa0005.
DATA gs_dep TYPE zssa0006.

PARAMETERS pa_pernr LIKE gs_emp-pernr.

INITIALIZATION.
  pa_pernr = '22020001'.

START-OF-SELECTION.
  SELECT SINGLE *
    FROM ztsa0001 "Employee Table
  INTO CORRESPONDING FIELDS OF gs_emp
  WHERE pernr = pa_pernr.
  IF sy-subrc <> 0.
    "Data is not found
    MESSAGE i001(zmcsa00).
    RETURN.
  ENDIF.

*  WRITE gs_emp-depid.
*  NEW-LINE.
*  WRITE gs_emp-dep-depid.
  SELECT SINGLE *
    FROM ztsa0002 "Dep Table
    INTO gs_dep "gs_emp-dep
   WHERE depid = gs_emp-depid.

  cl_demo_output=>display_data( gs_dep ).
