*&---------------------------------------------------------------------*
*& Module Pool      SAPMZSA0005
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*

INCLUDE mzsa0005_top                            .    " Global Data

INCLUDE mzsa0005_o01                            .  " PBO-Modules
INCLUDE mzsa0005_i01                            .  " PAI-Modules
INCLUDE mzsa0005_f01                            .  " FORM-Routines

LOAD-OF-PROGRAM.
  PERFORM set_default CHANGING zssa0073.
