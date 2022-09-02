*&---------------------------------------------------------------------*
*& Report ZRSA00_37
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zrsa00_37.

DATA: gs_info TYPE zvsa0002, "Databse View
      gt_info LIKE TABLE OF gs_info.

*PARAMETERS pa_dep LIKE gs_info-depid.

START-OF-SELECTION.
*  SELECT *
*    FROM zvsa0002 "database view
*    INTO CORRESPONDING FIELDS OF TABLE gt_info.
**   WHERE depid = pa_dep.

  " Open SQL
*  SELECT *
*    FROM ztsa0001 INNER JOIN ztsa0002
*      ON ztsa0001~depid = ztsa0002~depid
*    INTO CORRESPONDING FIELDS OF TABLE gt_info
*   WHERE ztsa0001~depid = pa_dep.

*  SELECT a~pernr a~ename a~depid b~phone
*    FROM ztsa0001 AS a INNER JOIN ztsa0002 AS b
*      ON a~depid = b~depid
*    INTO CORRESPONDING FIELDS OF TABLE gt_info
*   WHERE a~depid = pa_dep.




  SELECT *
    FROM ztsa0001 AS emp LEFT OUTER JOIN ztsa0002 AS dep
      ON emp~depid = dep~depid
    INTO CORRESPONDING FIELDS OF TABLE gt_info.


  cl_demo_output=>display_data( gt_info ).
