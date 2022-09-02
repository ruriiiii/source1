*&---------------------------------------------------------------------*
*& Include ZC1R180007_TOP                           - Report ZC1R180007
*&---------------------------------------------------------------------*
REPORT zc1r180007 MESSAGE-ID zmcsa18.

DATA gv_okcode TYPE sy-ucomm.
TABLES ztsa1801.

DATA : BEGIN OF gs_data,
         mark,
         pernr  TYPE ztsa1801-pernr,
         ename  TYPE ztsa1801-ename,
         entdt  TYPE ztsa1801-entdt,
         gender TYPE ztsa1801-gender,
         depid  TYPE ztsa1801-depid,
         CARRID TYPE SCARR-CARRID,
         CARRNAME TYPE SCARR-CARRNAME,
         style  TYPE lvc_t_styl,
       END OF gs_data,
       gt_data     LIKE TABLE OF gs_data,
       gt_data_del LIKE TABLE OF gs_data.



"ALV
DATA : gcl_container TYPE REF TO cl_gui_docking_container,
       gcl_grid      TYPE REF TO cl_gui_alv_grid.

DATA : gs_variant TYPE disvariant,
       gs_fcat    TYPE lvc_s_fcat,
       gt_fcat    TYPE lvc_t_fcat,
       gs_layout  TYPE lvc_s_layo,
       gs_stable  TYPE lvc_s_stbl.

DATA : gt_rows TYPE lvc_t_row,   "사용자가 선택한 행의 정보 저장할 인터널테이블
       gs_row  TYPE lvc_s_row.
