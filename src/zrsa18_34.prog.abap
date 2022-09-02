*&---------------------------------------------------------------------*
*& Report ZRSA18_34
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zrsa18_34.
"Dep Info
DATA gs_dep TYPE zssa1811.
DATA gt_dep LIKE TABLE OF gs_dep.

"Emp info ( Structure Variable )
DATA gs_emp LIKE LINE OF gs_dep-emp_list.



PARAMETERS pa_dep TYPE ztsa1802_2-depid.

START-OF-SELECTION.
SELECT SINGLE *
  FROM ztsa1802_2
  INTO CORRESPONDING FIELDS OF gs_dep
 WHERE depid = pa_dep.

 IF sy-subrc <> 0 .
   RETURN.
 ENDIF.

 "Get Employee List
 SELECT *
   FROM ztsa1801  "Employee Table
   INTO CORRESPONDING FIELDS OF TABLE gs_dep-emp_list
  WHERE depid = gs_dep-depid.


  LOOP AT gs_dep-emp_list INTO gs_emp.
    "Get gender Text

    MODIFY gs_dep-emp_list FROM gs_emp.
    CLEAR gs_emp.
  ENDLOOP.

   cl_demo_output=>display_data( gs_dep-emp_list ).
