*&---------------------------------------------------------------------*
*& Module Pool      SAPMZSA1804_2
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*

INCLUDE mzsa1806_top.
*INCLUDE MZSA1804_2_TOP                          .    " Global Data

INCLUDE mzsa1806_o01.
* INCLUDE MZSA1804_2_O01                          .  " PBO-Modules
INCLUDE mzsa1806_i01.
* INCLUDE MZSA1804_2_I01                          .  " PAI-Modules
INCLUDE mzsa1806_f01.
* INCLUDE MZSA1804_2_F01                          .  " FORM-Routines

 LOAD-OF-PROGRAM.
 PERFORM set_default CHANGING zssa0073.
 CLEAR: gv_r1, gv_r2, gv_r3.
 gv_r2 = 'X'.
