*&---------------------------------------------------------------------*
*& Report ZC1R18PR
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zc1r18pr.

DATA ls_data TYPE zssa18001.

DATA lt_data LIKE TABLE OF ls_data.

DATA ls_data_tmp LIKE ls_data.

DATA: gv_loekz TYPE eloek,
      gv_statu TYPE astat.


DATA: gv_bpumz TYPE ekpo-bpumz,
      gv_bpumn TYPE ekpo-bpumn.


DATA: gv_a LIKE gv_loekz,
      gv_b LIKE gv_statu,
      gv_c LIKE gv_bpumz,
      gv_d LIKE gv_bpumn.



ls_data-bukrs = '001'.
ls_data-belnr = '77777'.
APPEND ls_data TO lt_data.


ls_data-bukrs = '002'.
ls_data-belnr = '88888'.
APPEND ls_data TO lt_data.


ls_data-bukrs = '003'.
ls_data-belnr = '99999'.
APPEND ls_data TO lt_data.

*cl_demo_output=>display( lt_data ).


DATA ls_data2 TYPE zssa18001.
DATA lt_data2 LIKE TABLE OF ls_data2 WITH HEADER LINE.

ls_data2-bukrs = '004'.
ls_data2-belnr = '000000'.
APPEND ls_data2 TO lt_data2.

cl_demo_output=>display( lt_data2[] ).
