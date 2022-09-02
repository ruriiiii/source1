*&---------------------------------------------------------------------*
*& Report ZRSA00_38
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zrsa00_38.

*DATA gt_head TYPE TABLE OF scarr WITH HEADER LINE.
DATA: BEGIN OF gt_head OCCURS 0,
        carrid   TYPE scarr-carrid,
        carrname TYPE scarr-carrname,
      END OF gt_head.

gt_head-carrid = 'KA'.
gt_head-carrname = 'Korea Airline'.

*APPEND gt_head TO gt_head[].
*APPEND gt_head TO gt_head.
APPEND gt_head.

cl_demo_output=>display_data( gt_head[] ).
