*&---------------------------------------------------------------------*
*& Report ZRSA00_33
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zrsa00_33.

DATA gs_dep TYPE zssa0006. " dep info
" Emp Info
DATA: gt_emp TYPE TABLE OF zssa0005, "Emp Info
      gs_emp LIKE LINE OF gt_emp.

PARAMETERS pa_dep TYPE ztsa0002-depid.

START-OF-SELECTION.
  SELECT SINGLE *
    FROM ztsa0002 " dep table
    INTO CORRESPONDING FIELDS OF gs_dep
   WHERE depid = pa_dep.

  cl_demo_output=>display_data( gs_dep ).

  SELECT *
    FROM ztsa0001
    INTO CORRESPONDING FIELDS OF TABLE gt_emp
   WHERE depid = gs_dep-depid.
  cl_demo_output=>display_data( gt_emp ).
