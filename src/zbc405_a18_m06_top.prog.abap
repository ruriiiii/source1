*&---------------------------------------------------------------------*
*& Include ZBC405_A18_M06_TOP                       - Report ZBC405_A18_M06
*&---------------------------------------------------------------------*
REPORT zbc405_a18_m06.

DATA ok_code TYPE sy-ucomm.

TABLES ztsbook_a18.

"Selection Screen
SELECT-OPTIONS: pa_car FOR ztsbook_a18-carrid,
                pa_con FOR ztsbook_a18-connid.     "for 뒤에는 이미 선언된 것만 들어올 수 있다.

"ALV 생성
DATA: go_con TYPE REF TO cl_gui_custom_container,
      go_alv TYPE REF TO cl_gui_alv_grid.

"In ALV
TYPES BEGIN OF ts_sbook.
INCLUDE TYPE ztsbook_a18.
TYPES: light,
       rowcol TYPE c LENGTH 4,
       rowcol2 TYPE c LENGTH 4.
TYPES: END OF ts_sbook.

"Data 담을 변수
DATA: gs_sbook TYPE ts_sbook,
      gt_sbook LIKE TABLE OF gs_sbook.

"AlV 관련 변수
DATA: gs_layout TYPE lvc_s_layo,
      gt_fcat   TYPE lvc_t_fcat,
      gs_fcat   LIKE LINE OF gt_fcat.
