*&---------------------------------------------------------------------*
*& Include ZRSAMEN10_18_TOP                         - Report ZRSAMEN10_18
*&---------------------------------------------------------------------*
REPORT zrsamen10_18.

DATA ok_code TYPE sy-ucomm.
TABLES zvrmat18.

SELECTION-SCREEN BEGIN OF BLOCK bl1 WITH FRAME TITLE TEXT-001.
  PARAMETERS pa_cus TYPE zvrmat18-custom.
SELECTION-SCREEN END OF BLOCK bl1.


TYPES: BEGIN OF gty_manage.
         INCLUDE TYPE zvrmat18.
TYPES:   maktx TYPE makt-maktx.
TYPES: name TYPE kna1-name1.
TYPES: END OF gty_manage.

DATA: gt_manage TYPE TABLE OF gty_manage,
      gs_manage TYPE gty_manage.

DATA: gs_maktx TYPE makt,
      gt_maktx LIKE TABLE OF gs_maktx.

DATA: gs_kna1 TYPE kna1,
      gt_kna1 LIKE TABLE OF gs_kna1.



"ALV
DATA: go_con TYPE REF TO cl_gui_custom_container,
      go_alv TYPE REF TO cl_gui_alv_grid.

DATA: gt_exct   TYPE ui_functions,
      gs_fcat   TYPE lvc_s_fcat,
      gt_fcat   TYPE lvc_t_fcat,
      gs_layout TYPE lvc_s_layo.
