*&---------------------------------------------------------------------*
*& Report ZRSA00_34
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zrsa00_34.

" Dep Info
DATA gs_dep TYPE zssa0011.
DATA gt_dep LIKE TABLE OF gs_dep.

" Emp info ( structure Variable )
DATA gs_emp LIKE LINE OF gs_dep-emp_list.

PARAMETERS pa_dep TYPE ztsa0002-depid.

START-OF-SELECTION.
  SELECT SINGLE *
    FROM ztsa0002 " Dep Table
    INTO CORRESPONDING FIELDS OF gs_dep
   WHERE depid = pa_dep.
  IF sy-subrc <> 0.
    RETURN.
  ENDIF.

  " Get Employee List
  SELECT *
    FROM ztsa0001 "Employee table
    INTO CORRESPONDING FIELDS OF TABLE gs_dep-emp_list
   WHERE depid = gs_dep-depid.

  LOOP AT gs_dep-emp_list INTO gs_emp.

    MODIFY gs_dep-emp_list FROM gs_emp.
    CLEAR gs_emp.
  ENDLOOP.
