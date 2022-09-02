*&---------------------------------------------------------------------*
*& Module Pool      SAPMZSA1802
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*

INCLUDE mzsa1802_top                            .    " Global Data

 INCLUDE mzsa1802_o01                            .  " PBO-Modules
 INCLUDE mzsa1802_i01                            .  " PAI-Modules
 INCLUDE mzsa1802_f01                            .  " FORM-Routines

 LOAD-OF-PROGRAM.     "= initialization(<-리포트프로그램에서만 사용가능)
  PERFORM set_default.
