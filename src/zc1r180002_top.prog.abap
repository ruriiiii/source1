*&---------------------------------------------------------------------*
*& Include ZC1R180002_TOP                           - Report ZC1R180002
*&---------------------------------------------------------------------*
REPORT zc1r180002 MESSAGE-ID zmcsa18.

DATA gv_okcode TYPE sy-ucomm.

TABLES: mara, marc.



DATA: BEGIN OF gs_data,
        matnr TYPE mara-matnr,
        mtart TYPE mara-mtart,
        matkl TYPE mara-matkl,
        meins TYPE mara-meins,
        tragr TYPE mara-tragr,
        pstat TYPE marc-pstat,
        dismm TYPE marc-dismm,
        ekgrp TYPE marc-ekgrp,
      END OF gs_data,
      gt_data LIKE TABLE OF gs_data.


"ALV
DATA: gcl_container TYPE REF TO cl_gui_docking_container,
      gcl_grid      TYPE REF TO cl_gui_alv_grid.

DATA: gs_variant TYPE disvariant,
      gs_layout  TYPE lvc_s_layo,
      gs_fcat    TYPE lvc_s_fcat,
      gt_fcat    TYPE lvc_t_fcat.
