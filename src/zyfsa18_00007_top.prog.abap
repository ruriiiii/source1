*&---------------------------------------------------------------------*
*& Include ZYFSA18_00007_TOP                        - Report ZYFSA18_00007
*&---------------------------------------------------------------------*
REPORT zyfsa18_00007.

DATA ok_code TYPE sy-ucomm.
TABLES ztspfli_t03.


SELECTION-SCREEN BEGIN OF BLOCK bl1.
  SELECT-OPTIONS so_car FOR ztspfli_t03-carrid.
  SELECT-OPTIONS so_con FOR ztspfli_t03-connid.
SELECTION-SCREEN END OF BLOCK bl1.



TYPES: BEGIN OF gty_spf.
         INCLUDE TYPE ztspfli_t03.
types: sum type WTGXXX.

TYPES: END OF gty_spf.

DATA: gt_spf TYPE TABLE OF gty_spf,
      gs_spf LIKE LINE OF gt_spf.






DATA: go_con TYPE REF TO cl_gui_custom_container,
      go_alv TYPE REF TO cl_gui_alv_grid.

data: gt_fcat type LVC_T_FCAT,
      gs_fcat type LVC_S_FCAT.
