*&---------------------------------------------------------------------*
*& Include ZRRA18_05_TOP                            - Report ZRRA18_05
*&---------------------------------------------------------------------*
REPORT zrra18_05 MESSAGE-ID zmcsa18.

TABLES : scarr, sflight.

DATA : BEGIN OF gs_data,
         carrid    TYPE scarr-carrid,
         carrname  TYPE scarr-carrname,
         connid    TYPE sflight-connid,
         fldate    TYPE sflight-fldate,
         planetype TYPE sflight-planetype,
         price     TYPE sflight-price,
         currency  TYPE sflight-currency,
         url       TYPE scarr-url,
       END OF gs_data,
       gt_data LIKE TABLE OF gs_data.


DATA : gs_saplane TYPE saplane,
       gt_saplane LIKE TABLE OF gs_saplane.

DATA : gs_sBOOK TYPE sBOOK,
       gt_sBOOK LIKE TABLE OF gs_sBOOK.


"ALV
DATA : gcl_container TYPE REF TO cl_gui_docking_container,
       gcl_grid      TYPE REF TO cl_gui_alv_grid.

DATA : gs_variant TYPE disvariant,
       gs_layout  TYPE lvc_s_layo,
       gt_fcat    TYPE lvc_t_fcat,
       gs_fcat    TYPE lvc_s_fcat.



"POPUP 관련
DATA : gcl_container_pop TYPE REF TO cl_gui_custom_container,
       gcl_grid_pop      TYPE REF TO cl_gui_alv_grid,
       gs_fcat_pop       TYPE lvc_s_fcat,
       gt_fcat_pop       TYPE lvc_t_fcat,
       gs_layout_pop     TYPE lvc_s_layo.

DATA : gcl_container_pop2 TYPE REF TO cl_gui_custom_container,
       gcl_grid_pop2      TYPE REF TO cl_gui_alv_grid,
       gs_fcat_pop2       TYPE lvc_s_fcat,
       gt_fcat_pop2       TYPE lvc_t_fcat,
       gs_layout_pop2     TYPE lvc_s_layo.





DATA gv_okcode TYPE sy-ucomm.
