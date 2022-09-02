*&---------------------------------------------------------------------*
*& Module Pool      SAPMZSA0005
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*

INCLUDE mzsa0006_top.
*INCLUDE mzsa0005_top                            .    " Global Data

INCLUDE mzsa0006_o01.
*INCLUDE mzsa0005_o01                            .  " PBO-Modules
INCLUDE mzsa0006_i01.
*INCLUDE mzsa0005_i01                            .  " PAI-Modules
INCLUDE mzsa0006_f01.
*INCLUDE mzsa0005_f01                            .  " FORM-Routines

LOAD-OF-PROGRAM.
  PERFORM set_default CHANGING zssa0073.
  CLEAR: gv_r1, gv_r2, gv_r3.
  gv_r2 = 'X'.
