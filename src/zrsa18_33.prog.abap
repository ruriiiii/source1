*&---------------------------------------------------------------------*
*& Report ZRSA18_33
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zrsa18_33.

DATA gs_dep TYPE zssa1806.  "dep info
"Emp Info
Data: gt_emp type TABLE of zssa1805, "emp info
     gs_emp like line of gt_emp.

PARAMETERS pa_dep TYPE ztsa1802_2-depid.

START-OF-SELECTION.
SELECT SINGLE *
  FROM ztsa1802_2  "dep Table
  INTO CORRESPONDING FIELDS OF gs_dep
  WHERE depid = pa_dep.

  cl_demo_output=>display_data( gs_dep ).


  SELECT *
    from ztsa1801
    into CORRESPONDING FIELDS OF table gt_emp
    WHERE depid = gs_dep-depid.
   cl_demo_output=>display_data( gt_emp ).
