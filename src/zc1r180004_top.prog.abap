*&---------------------------------------------------------------------*
*& Include ZC1R180004_TOP                           - Report ZC1R180004
*&---------------------------------------------------------------------*
REPORT zc1r180004 MESSAGE-ID zmcsa18.

DATA : gv_okcode TYPE sy-ucomm.

CLASS lcl_event_handler DEFINITION DEFERRED.


TABLES mast.  "Select options를 사용하기 위한 선언


DATA: BEGIN OF gs_data,
        matnr TYPE mast-matnr,
        maktx TYPE makt-maktx,
        stlan TYPE mast-stlan,
        stlnr TYPE mast-stlnr,
        stlal TYPE mast-stlal,
        mtart TYPE mara-mtart,
        matkl TYPE mara-matkl,
      END OF gs_data,
      gt_data LIKE TABLE OF gs_data.    "만약 헤드가 있는 것을 만드려면 끝에  with header line 추가


DEFINE _clear.

  clear   &1.
  refresh &1.

end-OF-DEFINITION.


DATA: gs_mara TYPE mara,
      gt_mara LIKE TABLE OF gs_mara .


"ALV
DATA : gcl_container TYPE REF TO cl_gui_docking_container,
       gcl_grid      TYPE REF TO cl_gui_alv_grid,
       gcl_handler   TYPE REF TO lcl_event_handler.

DATA : gs_layout TYPE lvc_s_layo,
       gt_fcat   TYPE lvc_t_fcat,
       gs_fcat   TYPE lvc_s_fcat,
       gs_variant type disvariant.
