*&---------------------------------------------------------------------*
*& Include ZBC405_A20_R04_TOP                       - Report ZBC405_A20_R04
*&---------------------------------------------------------------------*
REPORT zbc405_a20_r04.

"COMMON VARIABLE
DATA ok_code TYPE sy-ucomm.

TABLES : ztsbook_a18, sscrfields.

"SELECTION SCREEN.
SELECTION-SCREEN BEGIN OF BLOCK bl1 WITH FRAME TITLE TEXT-t01.
  SELECT-OPTIONS : so_car FOR ztsbook_a18-carrid OBLIGATORY MEMORY ID car,
                   so_con FOR ztsbook_a18-connid MEMORY ID con,
                   so_fld FOR ztsbook_a18-fldate,
                   so_cus FOR ztsbook_a18-customid.
  SELECTION-SCREEN SKIP 2.
  PARAMETERS pa_edit AS CHECKBOX.
SELECTION-SCREEN END OF BLOCK bl1.

SELECTION-SCREEN SKIP 2.

SELECTION-SCREEN BEGIN OF BLOCK bl2 WITH FRAME TITLE TEXT-t02.
  PARAMETERS pa_var TYPE disvariant-variant.
SELECTION-SCREEN END OF BLOCK bl2.

"TYPE
TYPES BEGIN OF typ_flt.
INCLUDE TYPE ztsbook_a18.
TYPES : light   TYPE c LENGTH 1,
        cellcol TYPE lvc_t_scol,
        rowcol  TYPE c LENGTH 4,
        seat TYPE c LENGTH 10,
        it_styl TYPE lvc_t_styl,
        END OF typ_flt.

*DATA gt_sbook TYPE TABLE OF typ_flt.
*DATA gs_sbook TYPE typ_flt.




"FOR ALV
DATA gt_sbook TYPE TABLE OF typ_flt.
DATA gs_sbook TYPE typ_flt.


DATA : go_con TYPE REF TO cl_gui_custom_container,
       go_alv TYPE REF TO cl_gui_alv_grid.

DATA : gs_variant TYPE disvariant,
       gs_layout  TYPE lvc_s_layo,
       gs_cellcol TYPE lvc_s_scol,
       gt_sort    TYPE lvc_t_sort,
       gs_sort    LIKE LINE OF gt_sort,
       gt_fcat    TYPE lvc_t_fcat,
      gs_fcat    TYPE lvc_s_fcat,
      gs_styl      TYPE lvc_s_styl.



gs_layout-ctab_fname = 'GT_CELLCOL'.
gs_layout-info_fname = 'GS_ROWCOL'.
