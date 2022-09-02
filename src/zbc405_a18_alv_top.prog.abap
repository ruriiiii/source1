*&---------------------------------------------------------------------*
*& Include ZBC405_A18_ALV_TOP                       - Report ZBC405_A18_ALV
*&---------------------------------------------------------------------*
REPORT zbc405_a18_alv.

DATA gt_flt TYPE TABLE OF sflight.
DATA gs_flt TYPE sflight.
DATA ok_code LIKE sy-ucomm.

"ALV Data 선언
DATA : go_container TYPE REF TO cl_gui_custom_container,
       go_alv_grid  TYPE REF TO cl_gui_alv_grid,
       gv_variant   TYPE disvariant,
       gv_save      TYPE c LENGTH 1.


"Selection Screen
SELECT-OPTIONS : so_car FOR gs_flt-carrid MEMORY ID car,
                 so_con FOR gs_flt-connid MEMORY ID con,
                 so_dat FOR gs_flt-fldate.

SELECTION-SCREEN SKIP 1.
PARAMETERS pa_lv TYPE disvariant-variant.
