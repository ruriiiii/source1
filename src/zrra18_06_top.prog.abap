*&---------------------------------------------------------------------*
*& Include ZRRA18_06_TOP                            - Report ZRRA18_06
*&---------------------------------------------------------------------*
REPORT zrra18_06.

TABLES bkpf.

DATA : BEGIN OF gs_data,
         belnr TYPE bseg-belnr,
         buzei TYPE bseg-buzei,
         blart TYPE bkpf-blart,
         budat TYPE bkpf-budat,
         shkzg TYPE bseg-shkzg,
         dmbtr TYPE bseg-dmbtr,
         waers TYPE bkpf-waers,
         hkont TYPE bseg-hkont,
       END OF gs_data,
       gt_data LIKE TABLE OF gs_data.


"ALV
DATA : gcl_container TYPE REF TO cl_gui_docking_container,
       gcl_grid      TYPE REF TO cl_gui_alv_grid.

DATA : gs_variant TYPE disvariant,
       gs_layout  TYPE lvc_s_layo,
       gs_fcat    TYPE lvc_s_fcat,
       gt_fcat    TYPE lvc_t_fcat.
