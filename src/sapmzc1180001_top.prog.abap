*&---------------------------------------------------------------------*
*& Include SAPMZC1180001_TOP                        - Module Pool      SAPMZC1180001
*&---------------------------------------------------------------------*
PROGRAM sapmzc1180001 MESSAGE-ID zmcsa18.

DATA : BEGIN OF gs_data,
         matnr TYPE ztsa18001-matnr,  "Material
         werks TYPE ztsa18001-werks,  "Plant
         mtart TYPE ztsa18001-mtart,  "Mat.Type
         matkl TYPE ztsa18001-matkl,  "Mat.Group
         menge TYPE ztsa18001-menge,  "Quantity
         meins TYPE ztsa18001-meins,  "Unit
         dmbtr TYPE ztsa18001-dmbtr,  "Price
         waers TYPE ztsa18001-waers,  "Currency
       END OF gs_data,

       gt_data   LIKE TABLE OF gs_data,
       gv_okcode TYPE sy-ucomm.


"ALV관련
DATA : gcl_container TYPE REF TO cl_gui_custom_container,
       gcl_grid      TYPE REF TO cl_gui_alv_grid,
       gs_fcat       TYPE lvc_s_fcat,
       gt_fcat       TYPE lvc_t_fcat,
       gs_layout     TYPE lvc_s_layo,
       gs_variant    TYPE disvariant.
