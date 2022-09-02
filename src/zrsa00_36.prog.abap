*&---------------------------------------------------------------------*
*& Report ZRSA00_36
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zrsa00_36.
TYPES: BEGIN OF ts_dep,
         budget TYPE ztsa0002-budget,
         waers  TYPE ztsa0002-waers,
       END OF ts_dep.

DATA: gs_dep TYPE zssa0020, "ts_dep," ztsa0002                               "ztsa0002,
      gt_dep LIKE TABLE OF gs_dep.

DATA go_salv TYPE REF TO cl_salv_table.

START-OF-SELECTION.
  SELECT *
    FROM ztsa0002
    INTO CORRESPONDING FIELDS OF TABLE gt_dep.

  cl_salv_table=>factory(
    IMPORTING r_salv_table = go_salv
    CHANGING t_table = gt_dep
  ).
  go_salv->display( ).

*  cl_demo_output=>display_data( gt_dep ).
